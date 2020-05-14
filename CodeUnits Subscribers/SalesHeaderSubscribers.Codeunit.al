codeunit 46015810 "Sales Header Subscribers"
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterInitRecord', '', true, true)]
    local procedure InitSalesHeaderFields(var SalesHeader: Record "Sales Header")
    var
        SalesSetup: Record "Sales & Receivables Setup";
        Location: Record Location;
    begin
        SalesSetup.GET;
        case SalesSetup."Default VAT Date" of
            SalesSetup."Default VAT Date"::"Posting Date":
                SalesHeader."VAT Date" := SalesHeader."Posting Date";
            SalesSetup."Default VAT Date"::"Document Date":
                SalesHeader."VAT Date" := SalesHeader."Document Date";
            SalesSetup."Default VAT Date"::Blank:
                SalesHeader."VAT Date" := 0D;
        end;
        SalesHeader."Postponed VAT" := SalesSetup."Credit Memo Confirmation";

        if SalesHeader."Location Code" <> '' then
            if Location.GET(SalesHeader."Location Code") then
                SalesHeader.Area := Location.Area;

        SalesHeader.UpdateBankInfo();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnUpdateSalesLineByChangedFieldName', '', true, true)]
    local procedure SetFieldsByChangedFieldName(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; ChangedFieldName: Text[100])
    begin
        case ChangedFieldName of
            SalesHeader.FIELDCAPTION("VAT Date"):
                if (SalesLine.Type <> SalesLine.Type::" ") then
                    SalesLine.VALIDATE("VAT Date", SalesHeader."VAT Date");
            SalesHeader.FIELDCAPTION("Calculate Excise"):
                if (SalesLine."No." <> '') then
                    SalesLine.VALIDATE("Calculate Excise (Cust.)", SalesHeader."Calculate Excise");
            SalesHeader.FIELDCAPTION("Calculate Product Tax"):
                if (SalesLine."No." <> '') then
                    SalesLine.VALIDATE("Calculate Product Tax (Cust.)", SalesHeader."Calculate Product Tax");
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnAfterChangePricesIncludingVAT', '', true, true)]
    local procedure AfterChangePricesIncludingVAT(var SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        Currency: Record Currency;
        RecalculatePrice: Boolean;

    begin
        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        SalesLine.SETFILTER("Unit Price", '<>%1', 0);
        SalesLine.SETFILTER("VAT %", '<>%1', 0);

        if not (SalesHeader."Calculate Excise" or SalesHeader."Calculate Product Tax") then
            SalesLine.SETFILTER("VAT %", '', 0);
        if SalesLine.FINDFIRST then begin
            RecalculatePrice :=
             CONFIRM(
             STRSUBSTNO(Text024, SalesHeader.FieldCaption("Prices Including VAT"),
             SalesLine.FIELDCAPTION("Unit Price")), true);
            SalesLine.SetSalesHeader(SalesHeader);

            if SalesHeader."Currency Code" = '' then
                Currency.InitRoundingPrecision
            else
                Currency.GET(SalesHeader."Currency Code");
            SalesLine.LOCKTABLE;
            SalesLine.FINDSET;
            repeat
                SalesLine.TESTFIELD("Quantity Invoiced", 0);
                SalesLine.TESTFIELD("Prepmt. Amt. Inv.", 0);
                if not RecalculatePrice then begin
                    SalesLine."VAT Difference" := 0;
                    SalesLine.UpdateAmounts;
                    //NAVE110.0; 001; begin
                    if (SalesLine."Unit Excise" <> 0) or (SalesLine."Unit Product Tax" <> 0) then begin

                        SalesLine."Unit Price" :=
                          ROUND(
                            SalesLine."Unit Price" * (1 + (SalesLine."VAT %" / 100)),
                            Currency."Unit-Amount Rounding Precision");
                        if SalesLine.Quantity <> 0 then begin
                            SalesLine."Line Discount Amount" :=
                              ROUND(
                                SalesLine.Quantity * SalesLine."Unit Price" * SalesLine."Line Discount %" / 100,
                                Currency."Amount Rounding Precision");
                            SalesLine.VALIDATE("Inv. Discount Amount",
                              ROUND(
                                SalesLine."Inv. Discount Amount" * (1 + (SalesLine."VAT %" / 100)),
                                Currency."Amount Rounding Precision"));
                        end;

                    end;
                end else
                    //NAVE110.0; 001; end
                    SalesLine."Unit Price" := ROUND(SalesLine."Unit Price" * (1 + (SalesLine."VAT %" / 100)),
                        Currency."Unit-Amount Rounding Precision");
                if SalesLine.Quantity <> 0 then begin
                    SalesLine."Line Discount Amount" :=
                      ROUND(
                        SalesLine.Quantity * SalesLine."Unit Price" * SalesLine."Line Discount %" / 100,
                        Currency."Amount Rounding Precision");
                    SalesLine.VALIDATE("Inv. Discount Amount",
                      ROUND(
                        SalesLine."Inv. Discount Amount" * (1 + (SalesLine."VAT %" / 100)),
                        Currency."Amount Rounding Precision"));
                end;
            until SalesLine.NEXT = 0;
        end else begin
            if (SalesLine."VAT %" <> 0) or (SalesLine."Unit Excise" <> 0) or (SalesLine."Unit Product Tax" <> 0) then begin

                SalesLine."Unit Price" :=
                  ROUND(
                    SalesLine."Unit Price" / (1 + (SalesLine."VAT %" / 100)),
                    Currency."Unit-Amount Rounding Precision");
                if SalesLine.Quantity <> 0 then begin
                    SalesLine."Line Discount Amount" :=
                      ROUND(
                        SalesLine.Quantity * SalesLine."Unit Price" * SalesLine."Line Discount %" / 100,
                        Currency."Amount Rounding Precision");
                    SalesLine.VALIDATE("Inv. Discount Amount",
                      ROUND(
                        SalesLine."Inv. Discount Amount" / (1 + (SalesLine."VAT %" / 100)),
                        Currency."Amount Rounding Precision"));
                end;

            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeGetNoSeriesCode', '', true, true)]
    local procedure GetNoSeriesCodeProtocol(var SalesHeader: Record "Sales Header"; SalesSetup: Record "Sales & Receivables Setup"; var NoSeriesCode: Code[20]; var IsHandled: Boolean)
    begin
        if SalesHeader."Sales Protocol" then
            NoSeriesCode := SalesSetup."Sales Protocol Nos.";
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeGetPostingNoSeriesCode', '', true, true)]
    local procedure GetPostingNoSeriesCodeProtocol(var SalesHeader: Record "Sales Header"; SalesSetup: Record "Sales & Receivables Setup"; var NoSeriesCode: Code[20]; var IsHandled: Boolean)
    begin
        if SalesHeader."Sales Protocol" then
            NoSeriesCode := SalesSetup."Posted Sales Protocol Nos.";
        IsHandled := true;
    end;

    var
        Text024: Label 'You have modified the %1 field. The recalculation of VAT may cause penny differences, so you must check the amounts afterward. Do you want to update the %2 field on the lines to reflect the new value of %1?';

}