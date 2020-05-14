codeunit 46015802 "Sales Line Subscribers"
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterUpdateAmounts', '', true, true)]
    local procedure CalcLineAmount(var SalesLine: Record "Sales Line")
    var
        DiscBase: Decimal;
        Currency: Record Currency;
    begin
        DiscBase := SalesLine.CalcDiscBase;
        Currency.GET(Salesline."Currency Code");
        IF SalesLine."Line Amount" <> ROUND(SalesLine.Quantity * DiscBase, Currency."Amount Rounding Precision") - SalesLine."Line Discount Amount" THEN BEGIN
            SalesLine."Line Amount" := ROUND(SalesLine.Quantity * DiscBase, Currency."Amount Rounding Precision") - SalesLine."Line Discount Amount";
            SalesLine."VAT Difference" := 0;
            SalesLine.UpdateDeferralAmounts();
        END;
        SalesLine."Amount Incl. Taxes Excl. VAT" := ROUND(SalesLine.Quantity * DiscBase, Currency."Amount Rounding Precision") - SalesLine."Line Discount Amount";
    end;

    [EventSubscriber(ObjectType::Table, DATABASE::"Sales Line", 'OnAfterInitOutstanding', '', true, true)]
    local procedure SetNegative(var SalesLine: Record "Sales Line")
    var
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.GET;
        IF GLSetup."Mark Neg. Qty as Correction" THEN
            SalesLine.Negative := (SalesLine.Quantity < 0);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterAssignItemValues', '', true, true)]
    local procedure CopyFromItemAndSalesHeader(var SalesLine: Record "Sales Line"; Item: Record Item)
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesLine."Tariff No." := Item."Tariff No.";
        SalesLine."Country/Region of Origin Code" := Item."Country/Region of Origin Code";
        SalesLine.Product := Item.Product;
        SalesLine."Excise Item" := Item."Excise Item";
        SalesLine."Calculate Excise" := SalesLine."Calculate Excise (Cust.)" and SalesLine."Excise Item";
        if SalesLine."Excise Item" then begin
            SalesHeader.GET(SalesLine."Document Type", SalesLine."Document No.");
            SalesLine."Outbound Excise Destination" := SalesHeader."Outbound Excise Destination";
            SalesLine."Payment Obligation Type" := SalesHeader."Payment Obligation Type";
        end;
        SalesLine."Product Tax Item" := Item."Product Tax Item";
        SalesLine."Calculate Product Tax" := SalesLine."Calculate Product Tax (Cust.)" and SalesLine."Product Tax Item";
        SalesLine."Do not include in Excise" := SalesHeader."Do not include in Excise";
        SalesLine.GetUnitExcise;
        SalesLine.GetUnitProductTax;

        SalesLine."CN Code" := Item."Tariff No.";
        SalesLine."Alcohol Content/Degree Plato" := Item."Degree / KW";
        SalesLine."Excise Unit of Measure" := Item."Excise Decl. Unit of Measure";
        SalesLine."Excise Rate" := Item."Excise Per Exc. Decl. UM (LCY)";
        SalesLine."Additional Excise Code" := Item."Additional Excise Code";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterAssignHeaderValues', '', true, true)]
    local procedure CopyFromSalesHeader(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    begin
        SalesLine."VAT Date" := SalesHeader."VAT Date";
        SalesLine."Calculate Excise (Cust.)" := SalesHeader."Calculate Excise";
        SalesLine."Calculate Product Tax (Cust.)" := SalesHeader."Calculate Product Tax";
    end;



    [EventSubscriber(ObjectType::Table, DATABASE::"Sales Line", 'OnUpdateVATAmountsOnAfterSetSalesLineFilters', '', true, true)]
    local procedure UpdateVATAmounts(var SalesLine: Record "Sales Line"; var SalesLine2: Record "Sales Line"; var IsHandled: Boolean)
    var
        SalesHeader: Record "Sales Header";
        Currency: Record Currency;
        SalesTaxCalculate: Codeunit "Sales Tax Calculate";
        TotalLineAmount: Decimal;
        TotalInvDiscAmount: Decimal;
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalQuantityBase: Decimal;
        TotalAmountInclTaxExclVAT: Decimal;
    begin
        Currency.GET(SalesLine."Currency Code");
        SalesHeader.GET(SalesLine."Document Type", SalesLine."Document No.");
        if SalesLine."Line Amount" = SalesLine."Inv. Discount Amount" then begin
            SalesLine."Amount Incl. Taxes Excl. VAT" := 0;
            SalesLine.Amount := -SalesLine."Excise Amount" - SalesLine."Product Tax Amount";

            SalesLine."VAT Base Amount" := 0;
            SalesLine."Amount Including VAT" := 0;
            //TODO; parameter xrec missing
            /*
            if (SalesLine.Quantity = 0) and (xRec.Quantity <> 0) and (xRec.Amount <> 0) then begin
            if SalesLine."Line No." <> 0 then
                SalesLine.MODIFY;
            SalesLine2.SETFILTER(Amount,'<>0');
            if SalesLine2.FIND('<>') then begin
                SalesLine2.VALIDATE("Line Discount %");
                SalesLine2.MODIFY;
            end;
            end;
            */

        end else begin
            TotalLineAmount := 0;
            TotalInvDiscAmount := 0;
            TotalAmount := 0;
            TotalAmountInclTaxExclVAT := 0;
            TotalAmountInclVAT := 0;
            TotalQuantityBase := 0;
            if (SalesLine."VAT Calculation Type" = SalesLine."VAT Calculation Type"::"Sales Tax") or
            ((SalesLine."VAT Calculation Type" in
                [SalesLine."VAT Calculation Type"::"Normal VAT", SalesLine."VAT Calculation Type"::"Reverse Charge VAT"]) and (SalesLine."VAT %" <> 0))
            then
                if not SalesLine2.ISEMPTY then begin
                    SalesLine2.CALCSUMS("Line Amount", "Inv. Discount Amount", Amount, "Amount Including VAT", "Quantity (Base)", "Amount Incl. Taxes Excl. VAT");

                    TotalLineAmount := SalesLine2."Line Amount";
                    TotalInvDiscAmount := SalesLine2."Inv. Discount Amount";
                    TotalAmount := SalesLine2.Amount;
                    TotalAmountInclVAT := SalesLine2."Amount Including VAT";
                    TotalQuantityBase := SalesLine2."Quantity (Base)";
                    TotalAmountInclTaxExclVAT := SalesLine2."Amount Incl. Taxes Excl. VAT";
                end;


            if SalesHeader."Prices Including VAT" then
                case SalesLine."VAT Calculation Type" of
                    SalesLine."VAT Calculation Type"::"Normal VAT",
                    SalesLine."VAT Calculation Type"::"Reverse Charge VAT":
                        begin
                            SalesLine."Amount Incl. Taxes Excl. VAT" :=
                                ROUND(
                                (TotalLineAmount - TotalInvDiscAmount + SalesLine."Line Amount" - SalesLine."Inv. Discount Amount") / (1 + SalesLine."VAT %" / 100),
                                Currency."Amount Rounding Precision") -
                                TotalAmountInclTaxExclVAT;
                            SalesLine.Amount := SalesLine."Amount Incl. Taxes Excl. VAT" - SalesLine."Excise Amount";
                            SalesLine."VAT Base Amount" :=
                                ROUND(
                                SalesLine."Amount Incl. Taxes Excl. VAT" * (1 - SalesHeader."VAT Base Discount %" / 100),
                                Currency."Amount Rounding Precision");
                            SalesLine."Amount Including VAT" :=
                                TotalAmountInclTaxExclVAT + SalesLine."Amount Incl. Taxes Excl. VAT" +
                                ROUND(
                                (TotalAmountInclTaxExclVAT + SalesLine."Amount Incl. Taxes Excl. VAT") *
                                (SalesHeader."VAT Base Discount %" / 100) * SalesLine."VAT %" / 100,
                                Currency."Amount Rounding Precision", Currency.VATRoundingDirection) -
                                TotalAmountInclVAT - TotalInvDiscAmount - SalesLine."Inv. Discount Amount";

                        end;
                    SalesLine."VAT Calculation Type"::"Full VAT":
                        begin
                            SalesLine.Amount := 0;
                            SalesLine."Amount Incl. Taxes Excl. VAT" := 0;
                            SalesLine."VAT Base Amount" := 0;
                        end;
                    SalesLine."VAT Calculation Type"::"Sales Tax":
                        begin
                            SalesHeader.TESTFIELD("VAT Base Discount %", 0);
                            SalesLine."Amount Incl. Taxes Excl. VAT" :=
                                SalesTaxCalculate.ReverseCalculateTax(
                                SalesLine."Tax Area Code", SalesLine."Tax Group Code", SalesLine."Tax Liable", SalesHeader."Posting Date",
                                TotalAmountInclVAT + SalesLine."Amount Including VAT", TotalQuantityBase + SalesLine."Quantity (Base)",
                                SalesHeader."Currency Factor") - TotalAmountInclTaxExclVAT;
                            if SalesLine."Amount Incl. Taxes Excl. VAT" <> 0 then
                                SalesLine."VAT %" :=
                                ROUND(100 * (SalesLine."Amount Including VAT" - SalesLine."Amount Incl. Taxes Excl. VAT") / SalesLine."Amount Incl. Taxes Excl. VAT", 0.00001)
                            else
                                SalesLine."VAT %" := 0;
                            SalesLine."Amount Incl. Taxes Excl. VAT" := ROUND(SalesLine."Amount Incl. Taxes Excl. VAT", Currency."Amount Rounding Precision");
                            SalesLine."VAT Base Amount" := SalesLine."Amount Incl. Taxes Excl. VAT";


                        end;
                end
            else
                case SalesLine."VAT Calculation Type" of
                    SalesLine."VAT Calculation Type"::"Normal VAT",
                    SalesLine."VAT Calculation Type"::"Reverse Charge VAT":
                        begin
                            SalesLine."Amount Incl. Taxes Excl. VAT" := ROUND(SalesLine."Line Amount" - SalesLine."Inv. Discount Amount", Currency."Amount Rounding Precision");
                            SalesLine.Amount := SalesLine."Amount Incl. Taxes Excl. VAT" - SalesLine."Excise Amount";
                            SalesLine."VAT Base Amount" :=
                                ROUND(SalesLine."Amount Incl. Taxes Excl. VAT" * (1 - SalesHeader."VAT Base Discount %" / 100), Currency."Amount Rounding Precision");
                            SalesLine."Amount Including VAT" :=
                                TotalAmountInclTaxExclVAT + SalesLine."Amount Incl. Taxes Excl. VAT" +
                                ROUND(
                                (TotalAmountInclTaxExclVAT + SalesLine."Amount Incl. Taxes Excl. VAT") *
                                (1 - SalesHeader."VAT Base Discount %" / 100) * SalesLine."VAT %" / 100,
                                Currency."Amount Rounding Precision", Currency.VATRoundingDirection) -
                                TotalAmountInclVAT;
                        end;
                    SalesLine."VAT Calculation Type"::"Full VAT":
                        begin
                            SalesLine.Amount := 0;
                            SalesLine."VAT Base Amount" := 0;
                            SalesLine."Amount Incl. Taxes Excl. VAT" := 0;
                            SalesLine."Amount Including VAT" := SalesLine."Line Amount" - SalesLine."Inv. Discount Amount";
                        end;
                    SalesLine."VAT Calculation Type"::"Sales Tax":
                        begin
                            SalesLine."Amount Incl. Taxes Excl. VAT" := ROUND(SalesLine."Line Amount" - SalesLine."Inv. Discount Amount", Currency."Amount Rounding Precision");
                            SalesLine.Amount := SalesLine."Amount Incl. Taxes Excl. VAT" - SalesLine."Excise Amount";
                            SalesLine."VAT Base Amount" := SalesLine."Amount Incl. Taxes Excl. VAT";
                            SalesLine."Amount Including VAT" :=
                                TotalAmountInclTaxExclVAT + SalesLine."Amount Incl. Taxes Excl. VAT" +
                                ROUND(
                                SalesTaxCalculate.CalculateTax(
                                    SalesLine."Tax Area Code", SalesLine."Tax Group Code", SalesLine."Tax Liable", SalesHeader."Posting Date",
                                    (TotalAmountInclTaxExclVAT + SalesLine."Amount Incl. Taxes Excl. VAT"), (TotalQuantityBase + SalesLine."Quantity (Base)"),
                                    SalesHeader."Currency Factor"), Currency."Amount Rounding Precision") -
                                TotalAmountInclVAT;
                            if SalesLine."VAT Base Amount" <> 0 then
                                SalesLine."VAT %" :=
                                    ROUND(100 * (SalesLine."Amount Including VAT" - SalesLine."VAT Base Amount") / SalesLine."VAT Base Amount", 0.00001)
                            else
                                SalesLine."VAT %" := 0;
                        end;
                end;
        end;
        IsHandled := true;
    end;
    //
}