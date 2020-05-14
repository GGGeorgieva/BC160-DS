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
}