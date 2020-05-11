tableextension 46015590 "ItemChAssignment(Sales)Ext." extends "Item Charge Assignment (Sales)"
{
    // version NAVW111.00,NAVE111.0

    fields
    {
        field(46015606; "Incl. in Intrastat Amount"; Boolean)
        {
            Caption = 'Incl. in Intrastat Amount';
            Description = 'NAVE111.0,001';

            trigger OnValidate();
            begin
                CheckIncludeIntrastat;
            end;
        }
        field(46015607; "Incl. in Intrastat Stat. Value"; Boolean)
        {
            Caption = 'Incl. in Intrastat Stat. Value';
            Description = 'NAVE111.0,001';

            trigger OnValidate();
            begin
                CheckIncludeIntrastat;
            end;
        }
    }

    procedure CheckIncludeIntrastat();
    var
        StatReportingSetup: Record "Stat. Reporting Setup";
    begin
        StatReportingSetup.GET;
        StatReportingSetup.TESTFIELD("No Item Charges in Intrastat", false);
    end;

    PROCEDURE SetIncludeAmount(): Boolean;
    var
        SalesHeader: Record "Sales Header";
        CustomerNo: Code[20];
    begin
        if SalesHeader.GET("Document Type", "Document No.") then begin
            CustomerNo := GetCustomer;

            if (CustomerNo <> '') and (SalesHeader."Sell-to Customer No." = CustomerNo) then
                exit(true);
        end;

        exit(false);
    end;

    local procedure GetCustomer(): Code[20];
    var
        SalesHeader: Record "Sales Header";
        ReturnRcptHeader: Record "Return Receipt Header";
        SalesShptHeader: Record "Sales Shipment Header";
        CustomerNo: Code[20];
    begin
        case "Applies-to Doc. Type" of
            "Applies-to Doc. Type"::Order, "Applies-to Doc. Type"::Invoice,
            "Applies-to Doc. Type"::"Return Order", "Applies-to Doc. Type"::"Credit Memo":
                begin
                    SalesHeader.GET("Applies-to Doc. Type", "Applies-to Doc. No.");
                    CustomerNo := SalesHeader."Sell-to Customer No.";
                end;
            "Applies-to Doc. Type"::Shipment:
                begin
                    SalesShptHeader.GET("Applies-to Doc. No.");
                    CustomerNo := SalesShptHeader."Sell-to Customer No.";
                end;
            "Applies-to Doc. Type"::"Return Receipt":
                begin
                    ReturnRcptHeader.GET("Applies-to Doc. No.");
                    CustomerNo := ReturnRcptHeader."Sell-to Customer No.";
                end;
        end;

        exit(CustomerNo);
    end;
}

