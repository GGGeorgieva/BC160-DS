tableextension 46015607 "Company Info. Extension" extends "Company Information"
{
    // version NAVW111.00.00.27667,NAVE111.0,NAVBG11.0

    fields
    {

        //Unsupported feature: CodeInsertion on ""Bank Branch No."(Field 13)". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //begin
        /*
        //NAVE111.0; 001; single
        if LocalizationUsage.UseEastLocalization then
          BGUtils.TestBankCode("Bank Branch No.","Country/Region Code");
        */
        //end;


        //Unsupported feature: CodeInsertion on ""Bank Account No."(Field 14)". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //begin
        /*
        //NAVE111.0; 001; single
        if LocalizationUsage.UseEastLocalization then
          BGUtils.TestBankAcc("Bank Account No.","Country/Region Code");
        */
        //end;
        field(46015505; "Identification No."; Text[13])
        {
            Caption = 'Identification No.';
            Description = 'NAVBG11.0,001';

            trigger OnValidate();
            begin
                BGUtils.TestIdentification("Identification No.", "Country/Region Code");
            end;
        }
        field(46015506; "VAT Bank Name"; Text[30])
        {
            Caption = 'VAT Bank Name';
            Description = 'NAVBG11.0,001';
        }
        field(46015507; "VAT Bank Branch No."; Text[20])
        {
            Caption = 'VAT Bank Branch No.';
            Description = 'NAVBG11.0,001';
        }
        field(46015508; "VAT Bank Account No."; Text[20])
        {
            Caption = 'VAT Bank Account No.';
            Description = 'NAVBG11.0,001';

            trigger OnValidate();
            begin
                BGUtils.TestBankAcc("VAT Bank Account No.", "Country/Region Code");
            end;
        }
        field(46015509; "Company Contact"; Text[30])
        {
            Caption = 'Company Contact';
            Description = 'NAVBG11.0,001';
        }
        field(46015510; "Bank Code"; Code[10])
        {
            Caption = 'Bank Code';
            Description = 'NAVBG11.0,001';
            Numeric = true;

            trigger OnValidate();
            begin
                BGUtils.TestBankCode("Bank Code", "Country/Region Code");
            end;
        }
        field(46015511; "VAT Bank Code"; Code[10])
        {
            Caption = 'VAT Bank Code';
            Description = 'NAVBG11.0,001';
            Numeric = true;

            trigger OnValidate();
            begin
                BGUtils.TestBankCode("VAT Bank Code", "Country/Region Code");
            end;
        }
        field(46015512; "VAT IBAN"; Code[50])
        {
            Caption = 'VAT IBAN';
            Description = 'NAVBG11.0,001';

            trigger OnValidate();
            begin
                CheckIBAN("VAT IBAN");
            end;
        }
        field(46015513; "VAT SWIFT Code"; Code[20])
        {
            Caption = 'VAT SWIFT Code';
            Description = 'NAVBG11.0,001';
        }
        field(46015605; "Primary Business Activity"; Text[100])
        {
            Caption = 'Primary Business Activity';
            Description = 'NAVE111.0,001';
        }
        field(46015606; "Registration No. 2"; Text[20])
        {
            Caption = 'Registration No. 2';
            Description = 'NAVE111.0,001';
        }
        field(46015607; "Company Type"; Option)
        {
            Caption = 'Company Type';
            Description = 'NAVE111.0,001';
            OptionCaption = '" ,Individual,Corporate"';
            OptionMembers = " ",Individual,Corporate;
        }
        field(46015608; "Industry Code"; Code[20])
        {
            Caption = 'Industry Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Industry Code";

            trigger OnValidate();
            begin
                if IndustryCode.GET("Industry Code") then
                    "Industrial Classification" := IndustryCode.Description;
            end;
        }
        field(46015609; "Equity Capital"; Decimal)
        {
            Caption = 'Equity Capital';
            Description = 'NAVE111.0,001';
        }
        field(46015610; "Registration Date"; Date)
        {
            Caption = 'Registration Date';
            Description = 'NAVE111.0,001';
        }
        field(46015611; "Paid Equity Capital"; Decimal)
        {
            Caption = 'Paid Equity Capital';
            Description = 'NAVE111.0,001';
        }
        field(46015612; "General Manager No."; Code[20])
        {
            Caption = 'General Manager No.';
            Description = 'NAVE111.0,001';
            TableRelation = "Company Officials";
        }
        field(46015613; "Accounting Manager No."; Code[20])
        {
            Caption = 'Accounting Manager No.';
            Description = 'NAVE111.0,001';
            TableRelation = "Company Officials";
        }
        field(46015614; "Finance Manager No."; Code[20])
        {
            Caption = 'Finance Manager No.';
            Description = 'NAVE111.0,001';
            TableRelation = "Company Officials";
        }
        field(46015615; "Default Bank Account No."; Code[20])
        {
            Caption = 'Default Bank Account No.';
            Description = 'NAVE111.0,001';
            TableRelation = "Bank Account" WHERE("Currency Code" = CONST(''));

            trigger OnValidate();
            begin
                if BankAcc.GET("Default Bank Account No.") then begin
                    "Bank Name" := BankAcc.Name;
                    "Bank Account No." := BankAcc."Bank Account No.";
                    IBAN := BankAcc.IBAN;
                    "SWIFT Code" := BankAcc."SWIFT Code";
                    "Payment Routing No." := BankAcc."Transit No.";
                    "Bank Branch No." := BankAcc."Bank Branch No.";
                end;
            end;
        }
        field(46015616; "Branch Name"; Text[50])
        {
            Caption = 'Branch Name';
            Description = 'NAVE111.0,001';
        }
        field(46015620; "Custom Authority No."; Code[20])
        {
            Caption = 'Custom Authority No.';
            Description = 'NAVE111.0,001';
            TableRelation = Vendor;
        }
        field(46015621; "Court Authority No."; Code[20])
        {
            Caption = 'Court Authority No.';
            Description = 'NAVE111.0,001';
            TableRelation = Vendor;
        }
        field(46015622; "Tax Authority No."; Code[20])
        {
            Caption = 'Tax Authority No.';
            Description = 'NAVE111.0,001';
            TableRelation = Vendor;
        }
        field(46015623; "City 2"; Text[50])
        {
            Caption = 'City 2';
            Description = 'NAVBG11.0,001';
        }
        field(46015624; "Excise No."; Text[13])
        {
            Caption = 'Excise No.';
            Description = 'NAVBG11.0,001';
        }
        field(46015625; "Excise Registration Type"; Code[2])
        {
            Caption = 'Excise Registration Type';
            Description = 'NAVBG11.0,001';
            TableRelation = "Excise Registration Type";
        }
        field(46015626; "Excise Notification No."; Text[13])
        {
            Caption = 'Excise Notification No.';
            Description = 'NAVBG11.0,001';
        }
        field(46015627; "Excise Legal Entity"; Code[6])
        {
            Caption = 'Excise Legal Entity';
            Description = 'NAVBG11.0,001';
        }
        field(46015628; "Excise Customs Office"; Code[8])
        {
            Caption = 'Customs Office';
            Description = 'NAVBG11.0,001';
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
        BGUtils: Codeunit "BG Utils";
        IndustryCode: Record "Document Type";
        BankAcc: Record "Bank Account";

}

