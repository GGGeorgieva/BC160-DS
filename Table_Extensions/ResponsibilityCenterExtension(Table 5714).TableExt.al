tableextension 46015579 "Responsibility Center Ext." extends "Responsibility Center"
{
    // version NAVW111.00.00.27667,NAVE111.0

    fields
    {
        field(46015615; "Bank No."; Code[20])
        {
            Caption = 'Bank No.';
            Description = 'NAVE111.0,001';
            TableRelation = "Bank Account";

            trigger OnValidate();
            var
                BankAcc: Record "Bank Account";
            begin
                if BankAcc.GET("Bank No.") then begin
                    "Bank Name" := BankAcc.Name;
                    "Bank Account No." := BankAcc."Bank Account No.";
                    "Bank Branch No." := BankAcc."Bank Branch No.";
                    IBAN := BankAcc.IBAN;
                end else begin
                    CompanyInfo.GET;
                    "Bank Name" := CompanyInfo."Bank Name";
                    "Bank Account No." := CompanyInfo."Bank Account No.";
                    "Bank Branch No." := CompanyInfo."Bank Branch No.";
                    IBAN := CompanyInfo.IBAN;
                end;
            end;
        }
        field(46015616; "Bank Name"; Text[50])
        {
            Caption = 'Bank Name';
            Description = 'NAVE111.0,001';
        }
        field(46015617; "Bank Account No."; Text[30])
        {
            Caption = 'Bank Account No.';
            Description = 'NAVE111.0,001';
        }
        field(46015631; "Bank Branch No."; Text[20])
        {
            Caption = 'Bank Branch No.';
            Description = 'NAVE111.0,001';
        }
        field(46015632; IBAN; Code[50])
        {
            Caption = 'IBAN';
            Description = 'NAVE111.0,001';

            trigger OnValidate();
            begin
                CompanyInfo.CheckIBAN(IBAN);
            end;
        }
    }

    var
        CompanyInfo: Record "Company Information";
}

