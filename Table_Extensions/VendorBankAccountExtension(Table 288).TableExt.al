tableextension 46015542 "Vendor Bank Account Extension" extends "Vendor Bank Account"
{
    fields
    {
        modify("Bank Account No.")
        {
            trigger OnBeforeValidate()
            begin
                BGUtils.TestBankAcc("Bank Account No.", "Country/Region Code");
            end;
        }
        field(46015505; "Bank Code"; Text[30])
        {
            Caption = 'Bank Code';
            Description = 'NAVBG11.0,001';

            trigger OnValidate();
            begin
                BGUtils.TestBankCode("Bank Code", "Country/Region Code");
            end;
        }
        field(46015607; "Local Bank Code"; Code[20])
        {
            Caption = 'Local Bank Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Local Bank";

            trigger OnValidate();
            begin
                if LocalBank.GET("Local Bank Code") then begin
                    LocalBank.TESTFIELD(Blocked, false);
                    VALIDATE(Name, LocalBank.Name);
                    "Name 2" := LocalBank."Name 2";
                    Address := LocalBank.Address;
                    "Address 2" := LocalBank."Address 2";
                    City := LocalBank.City;
                    "Post Code" := LocalBank."Post Code";
                    Contact := LocalBank.Contact;
                    "Phone No." := LocalBank."Phone No.";
                    "Telex No." := LocalBank."Telex No.";
                    "Bank Branch No." := LocalBank."Bank Branch No.";
                    "Country/Region Code" := LocalBank."Country/Region Code";
                    County := LocalBank.County;
                    "Fax No." := LocalBank."Fax No.";
                    "E-Mail" := LocalBank."E-Mail";
                    "Home Page" := LocalBank."Home Page";
                    "SWIFT Code" := LocalBank."SWIFT Code";
                end;
            end;
        }
    }
    var
        BGUtils: Codeunit "BG Utils";
        LocalBank: Record "Local Bank";
}

