tableextension 46015548 "Fin. Ch. Memo Header Extension" extends "Finance Charge Memo Header"
{    // version NAVW111.00.00.27667,NAVE111.0

    fields
    {
        modify("Customer No.")
        {
            trigger OnBeforeValidate()
            var
                Cust: Record Customer;
            begin
                if "Customer No." = '' then
                    exit;
                Cust.GET("Customer No.");
                "Registration No." := Cust."Registration No.";
                "Registration No. 2" := Cust."Registration No. 2";
                UpdateBankInfo;
            end;
        }

        modify("Customer Posting Group")
        {
            trigger OnBeforeValidate()
            var
                SalesSetup: Record "Sales & Receivables Setup";
            begin
                if CurrFieldNo = FIELDNO("Customer Posting Group") then begin
                    SalesSetup.GET;
                    if SalesSetup."Allow Alter Posting Groups" then begin
                        if not SubstCustPostingGrp.GET(xRec."Customer Posting Group", "Customer Posting Group") then
                            ERROR(Text46012225, xRec."Customer Posting Group", "Customer Posting Group", SubstCustPostingGrp.TABLECAPTION);
                    end else
                        ERROR(Text46012226, FIELDCAPTION("Customer Posting Group"), SalesSetup.FIELDCAPTION("Allow Alter Posting Groups"));
                end;
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
                UpdateBankInfo;
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
        field(46015626; "Tax Amount"; Decimal)
        {
            Caption = 'Tax Amount';
            Description = 'NAVE111.0,001';
        }
        field(46015630; "Posting Desc. Code"; Code[10])
        {
            Caption = 'Posting Desc. Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Posting Description" WHERE(Type = CONST("Finance Charge"));

            trigger OnValidate();
            begin
                GetPostingDescription("Posting Desc. Code", "Posting Description");
            end;
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
    trigger OnBeforeInsert()
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        SalesSetup.GET;
        "Multiple Interest Rates" := SalesSetup."Multiple Interest Rates";
        VALIDATE("Posting Desc. Code", SalesSetup."Fin. Charge Posting Desc. Code");
    end;

    trigger OnBeforeModify()
    begin
        VALIDATE("Posting Desc. Code");
    end;

    trigger OnBeforeDelete()
    begin
        DtldFinChargeMemoLine.SETRANGE("Finance Charge Memo No.", "No.");
        DtldFinChargeMemoLine.DELETEALL;
    end;

    var
        DtldFinChargeMemoLine: Record "Detailed Fin. Charge Memo Line";
        SubstCustPostingGrp: Record "Subst. Customer Posting Group";
        CompanyInfo: Record "Company Information";
        Text46012225: Label 'You cannot change the %1 to %2 because %3 has not been filled in.';
        Text46012226: Label 'You cannot change %1 until %2 will be checked in setup.';

    procedure UpdateBankInfo();
    var
        BankAcc: Record "Bank Account";
    begin
        //NAVE111.0; 001; entire function
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

    procedure GetPostingDescription(PostingDescCode: Code[10]; VAR PostingDescription: Text[50]);
    var
        PostingDesc: Record "Posting Description";
        RecordReference: RecordRef;
    begin
        //NAVE111.0; 001; entire function
        if PostingDesc.GET(PostingDescCode) then begin
            PostingDesc.TESTFIELD(Type, PostingDesc.Type::"Finance Charge");
            RecordReference.OPEN(DATABASE::"Finance Charge Memo Header");
            RecordReference.GETTABLE(Rec);
            PostingDescription := PostingDesc.ParsePostDescString(PostingDesc, RecordReference);
        end;
    end;

}

