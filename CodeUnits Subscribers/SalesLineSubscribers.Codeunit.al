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
}