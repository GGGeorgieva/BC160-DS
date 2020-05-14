tableextension 46015532 "VAT Entry Extension" extends "VAT Entry"
{
    fields
    {

        modify("Bill-to/Pay-to No.")
        {
            trigger OnAfterValidate()
            var
                Vend: Record Vendor;
                Cust: Record Customer;
            begin
                if "Bill-to/Pay-to No." = '' then begin
                    "Registration No." := '';
                end else
                    case Type of
                        Type::Purchase:
                            begin
                                Vend.GET("Bill-to/Pay-to No.");
                                "Registration No." := Vend."Registration No.";
                            end;
                        Type::Sale:
                            begin
                                Cust.GET("Bill-to/Pay-to No.");
                                "Registration No." := Cust."Registration No.";
                            end;
                    end;
                Modify()
            end;

        }

        modify("EU 3-Party Trade")
        {
            trigger OnAfterValidate()
            begin
                if not "EU 3-Party Trade" then
                    "EU 3-Party Intermediate Role" := false;
                Modify();
            end;
        }
        field(46015505; "Debit Memo"; Boolean)
        {
            Caption = 'Debit Memo';
            Description = 'NAVBG11.0,001';
        }
        field(46015506; "Sales Protocol"; Boolean)
        {
            Caption = 'Sales Protocol';
            Description = 'NAVBG11.0,001';
        }
        field(46015507; "Identification No."; Text[13])
        {
            Caption = 'Identification No.';
            Description = 'NAVBG11.0,001';
        }
        field(46015508; Void; Boolean)
        {
            Caption = 'Void';
            Description = 'NAVBG11.0,001';
        }
        field(46015509; "Void Date"; Date)
        {
            Caption = 'Void Date';
            Description = 'NAVBG11.0,001';
        }
        field(46015510; "VAT Subject"; Text[30])
        {
            Caption = 'VAT Subject';
            Description = 'NAVBG11.0,001';
        }
        field(46015511; "VAT Type"; Option)
        {
            Caption = 'VAT Type';
            Description = 'NAVBG11.0,001';
            OptionCaption = '" ,Purchase,Sale"';
            OptionMembers = " ",Purchase,Sale;
        }
        field(46015512; "Bill-to/Pay-to Name"; Text[50])
        {
            Caption = 'Bill-to/Pay-to Name';
            Description = 'NAVBG11.0,001';
        }
        field(46015513; "Do not include in VAT Ledgers"; Boolean)
        {
            Caption = 'Do not include in VAT Ledgers';
            Description = 'NAVBG11.0,001';
        }
        field(46015514; "Excise Amount"; Decimal)
        {
            Caption = 'Excise Amount';
            Description = 'NAVBG11.0,001';
        }
        field(46015515; "Add.-Currency Excise Amount"; Decimal)
        {
            Caption = 'Add.-Currency Excise Amount';
            Description = 'NAVBG11.0,001';
        }
        field(46015516; "VAT Protocol"; Boolean)
        {
            Caption = 'VAT Protocol';
            Description = 'NAVBG11.0,001';
        }
        field(46015605; "Registration No."; Text[20])
        {
            Caption = 'Registration No.';
            Description = 'NAVE111.0,001';
        }
        field(46015610; "VAT Date"; Date)
        {
            Caption = 'VAT Date';
            Description = 'NAVE111.0,001';
            Editable = false;
        }
        field(46015611; "Postponed VAT"; Boolean)
        {
            Caption = 'Postponed VAT';
            Description = 'NAVE111.0,001';
            Editable = false;
        }
        field(46015612; "VAT Identifier"; Code[10])
        {
            Caption = 'VAT Identifier';
            Description = 'NAVE111.0,001';
            Editable = false;
        }
        field(46015619; "EU 3-Party Intermediate Role"; Boolean)
        {
            Caption = 'EU 3-Party Intermediate Role';
            Description = 'NAVE111.0,001';
            Editable = false;

            trigger OnValidate();
            begin
                if "EU 3-Party Intermediate Role" then
                    "EU 3-Party Trade" := true;
            end;
        }
        field(46015625; "SAD No."; Code[20])
        {
            Caption = 'SAD No.';
            Description = 'NAVE111.0,001';
            Editable = true;
            TableRelation = IF (Type = CONST(Purchase)) "Export SAD Header"
            ELSE
            IF (Type = CONST(Sale)) "Import SAD Header";
        }
        field(46015626; "Customs Procedure Code"; Code[10])
        {
            Caption = 'Customs Procedure Code';
            Description = 'NAVE111.0,001';
            Editable = false;
            TableRelation = "Custom Procedure";
        }
        field(46015635; "VAT % (Non Deductible)"; Decimal)
        {
            Caption = 'VAT % (Non Deductible)';
            Description = 'NAVE111.0,001';
            MaxValue = 100;
            MinValue = 0;
        }
        field(46015636; "VAT Base (Non Deductible)"; Decimal)
        {
            Caption = 'VAT Base (Non Deductible)';
            Description = 'NAVE111.0,001';
            Editable = false;
        }
        field(46015637; "VAT Amount (Non Deductible)"; Decimal)
        {
            Caption = 'VAT Amount (Non Deductible)';
            Description = 'NAVE111.0,001';
            Editable = false;
        }
        field(46015700; "Unrealized VAT"; Boolean)
        {
            Caption = 'Unrealized VAT';
            Description = 'NAVBG11.0,001';
        }
        field(46015701; "VAT Chargeable On Recipient"; Option)
        {
            Caption = 'Purchase according to art. 163a of the VAT Act';
            Description = 'NAVBG11.0,001';
            OptionCaption = '" ,01,02"';
            OptionMembers = " ","01","02";
        }
    }
    var
        PostponedVAT: Boolean;
        ErrTxt: Label 'ER';

    PROCEDURE GetDocType() txtDocType: Text[2];
    BEGIN
        //NAVE111.0; 001; entire function
        if "Debit Memo" then
            exit('02');

        if "Sales Protocol" then
            exit('81');


        case "Document Type" of
            "Document Type"::" ":
                exit('09');
            "Document Type"::Invoice:
                exit('01');
            "Document Type"::"Credit Memo":
                exit('03');
        end;

        exit(ErrTxt);
    END;

    PROCEDURE GetRegNo(): Code[20];
    VAR
        Customer: Record Customer;
        Vendor: Record Vendor;
    BEGIN
        //NAVE111.0; 001; entire function
        case "VAT Type" of
            "VAT Type"::Sale:
                if Customer.GET("Bill-to/Pay-to No.") then
                    if Customer."VAT Registration No." <> '' then
                        exit(Customer."VAT Registration No.");

            "VAT Type"::Purchase:
                if Vendor.GET("Bill-to/Pay-to No.") then
                    if Vendor."VAT Registration No." <> '' then
                        exit(Vendor."VAT Registration No.");
        end;

        exit("Identification No.");
    END;

    PROCEDURE GetContragentName(): Text[50];
    VAR
        Customer: Record Customer;
        Vendor: Record Vendor;
    BEGIN
        //NAVE111.0; 001; entire function
        if "Bill-to/Pay-to Name" = '' then
            case "VAT Type" of
                "VAT Type"::Sale:
                    if Customer.GET("Bill-to/Pay-to No.") then
                        exit(Customer.Name);

                "VAT Type"::Purchase:
                    if Vendor.GET("Bill-to/Pay-to No.") then
                        exit(Vendor.Name);
            end;

        exit("Bill-to/Pay-to Name");
    END;

    PROCEDURE GetUnrealizedVatType2(PostponedVAT: Boolean) UnrealizedVatType: Integer;
    VAR
        VatPostingSetup: Record "VAT Posting Setup";
        TaxJurisdiction: Record "Tax Jurisdiction";
    BEGIN
        //NAVE111.0; 001; entire function
        if "VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax" then begin
            TaxJurisdiction.GET("Tax Jurisdiction Code");
            UnrealizedVatType := TaxJurisdiction."Unrealized VAT Type";
        end else begin
            VatPostingSetup.GET("VAT Bus. Posting Group", "VAT Prod. Posting Group");
            UnrealizedVatType := VatPostingSetup."Unrealized VAT Type";
            if "Postponed VAT" then
                if PostponedVAT then
                    UnrealizedVatType := VatPostingSetup."Unrealized VAT Type"::Percentage
                else
                    UnrealizedVatType := 0;
        end;
    END;
}

