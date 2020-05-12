tableextension 46015547 "Reminder Header Extension" extends "Reminder Header"
{
    // version NAVW111.00.00.27667,NAVE111.0  
    //TODO: PROCEDURE ReminderRounding
    fields
    {

        modify("Customer No.")
        {
            trigger OnAfterValidate()
            var
                Cust: Record Customer;
            begin
                Cust.GET("Customer No.");
                "Registration No." := Cust."Registration No.";
                "Registration No. 2" := Cust."Registration No. 2";
                UpdateBankInfo();
                MODIFY;
            end;
        }
        field(46015605; "Registration No."; Text[20])
        {
            Caption = 'Registration No.';
            Description = 'NAVE111.0,001';
        }
        field(46015606; "Registration No. 2"; Text[20])
        {
            Caption = 'Registration No. 2';
            Description = 'NAVE111.0,001';
        }
        field(46015615; "Bank No."; Code[20])
        {
            Caption = 'Bank No.';
            Description = 'NAVE111.0,001';
            TableRelation = "Bank Account";

            trigger OnValidate();
            begin
                //TO DO
                //UpdateBankInfo;
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
        field(46015625; "Multiple Interest Rates"; Boolean)
        {
            Caption = 'Multiple Interest Rates';
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
        DtldReminderLine: Record "Detailed Reminder Line";

    trigger OnBeforeInsert()
    var
        SalesSetup: record "Sales & Receivables Setup";
    begin
        "Multiple Interest Rates" := SalesSetup."Multiple Interest Rates";
    end;

    trigger OnBeforeDelete()
    begin
        DtldReminderLine.SETRANGE("Reminder No.", "No.");
        DtldReminderLine.DELETEALL;
    end;

    procedure UpdateBankInfo();
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

