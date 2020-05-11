tableextension 46015589 "ItemChAssignment(Purch)Ext." extends "Item Charge Assignment (Purch)"
{
    // version NAVW111.00.00.23019,NAVE111.0

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

    procedure SetIncludeAmount(): Boolean;
    var
        PurchHeader: Record "Purchase Header";
        VendorNo: Code[20];
    begin
        if PurchHeader.GET("Document Type", "Document No.") then begin
            VendorNo := GetVendor;

            if (VendorNo <> '') and (PurchHeader."Buy-from Vendor No." = VendorNo) then
                exit(true);
        end;

        exit(false);
    end;

    LOCAL PROCEDURE GetVendor(): Code[20];
    var
        PurchHeader: Record "Purchase Header";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        ReturnShptHeader: Record "Return Shipment Header";
        VendorNo: Code[20];
    begin
        case "Applies-to Doc. Type" of
            "Applies-to Doc. Type"::Order, "Applies-to Doc. Type"::Invoice,
            "Applies-to Doc. Type"::"Return Order", "Applies-to Doc. Type"::"Credit Memo":
                begin
                    PurchHeader.GET("Applies-to Doc. Type", "Applies-to Doc. No.");
                    VendorNo := PurchHeader."Buy-from Vendor No.";
                end;
            "Applies-to Doc. Type"::Receipt:
                begin
                    PurchRcptHeader.GET("Applies-to Doc. No.");
                    VendorNo := PurchRcptHeader."Buy-from Vendor No.";
                end;
            "Applies-to Doc. Type"::"Return Shipment":
                begin
                    ReturnShptHeader.GET("Applies-to Doc. No.");
                    VendorNo := ReturnShptHeader."Buy-from Vendor No.";
                end;
            "Applies-to Doc. Type"::"Transfer Receipt":
                begin
                    VendorNo := '';
                end;
            "Applies-to Doc. Type"::"Sales Shipment":
                begin
                    VendorNo := '';
                end;
            "Applies-to Doc. Type"::"Return Receipt":
                begin
                    VendorNo := '';
                end;
        end;

        exit(VendorNo);
    end;

}

