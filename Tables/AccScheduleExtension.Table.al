table 46015689 "Acc. Schedule Extension"
{
    // version NAVE18.00

    // -----------------------------------------------------------------------------------------
    // XAPT Solutions
    // MS Dynamics NAV 2015 Localisation
    // 
    // mp  : Mile Petachki
    // version : NAVE18.00
    // 
    // -----------------------------------------------------------------------------------------
    // No.   Sign     Date       Version        Description
    // -----------------------------------------------------------------------------------------
    // 001   mp       27.10.14   NAVE18.00      Created table from MS Dynamics NAV 6.00
    // ------------------------------------------------------------------------------------------

    Caption = 'Acc. Schedule Extension';
    //LookupPageID = "Acc. Schedule Extensions";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(10; "Source Table"; Option)
        {
            Caption = 'Source Table';
            OptionCaption = 'VAT Entry,Value Entry,Customer Entry,Vendor Entry';
            OptionMembers = "VAT Entry","Value Entry","Customer Entry","Vendor Entry";
        }
        field(11; "Source Type"; Option)
        {
            Caption = 'Source Type';
            OptionCaption = '" ,Customer,Vendor,Bank Account,Fixed Asset"';
            OptionMembers = " ",Customer,Vendor,"Bank Account","Fixed Asset";
        }
        field(12; "Source Filter"; Text[100])
        {
            Caption = 'Source Filter';

            trigger OnLookup();
            begin
                case "Source Type" of
                    "Source Type"::Customer:
                        if PAGE.RUNMODAL(0, Customer) = ACTION::LookupOK then
                            "Source Filter" += Customer."No.";
                    "Source Type"::Vendor:
                        if PAGE.RUNMODAL(0, Vendor) = ACTION::LookupOK then
                            "Source Filter" += Vendor."No.";
                    "Source Type"::"Bank Account":
                        if PAGE.RUNMODAL(0, BankAcc) = ACTION::LookupOK then
                            "Source Filter" += BankAcc."No.";
                    "Source Type"::"Fixed Asset":
                        if PAGE.RUNMODAL(0, FixedAsset) = ACTION::LookupOK then
                            "Source Filter" += FixedAsset."No.";
                end;
            end;
        }
        field(13; "G/L Account Filter"; Text[100])
        {
            Caption = 'G/L Account Filter';

            trigger OnLookup();
            begin

                if PAGE.RUNMODAL(0, GLAcc) = ACTION::LookupOK then "G/L Account Filter" += GLAcc."No.";
            end;
        }
        field(14; "G/L Amount Type"; Option)
        {
            Caption = 'G/L Amount Type';
            OptionCaption = '" ,Debit,Credit"';
            OptionMembers = " ",Debit,Credit;
        }
        field(15; "Amount Sign"; Option)
        {
            Caption = 'Amount Sign';
            OptionCaption = '" ,Positive,Negative"';
            OptionMembers = " ",Positive,Negative;
        }
        field(16; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = '" ,Purchase,Sale"';
            OptionMembers = " ",Purchase,Sale;
        }
        field(17; Prepayment; Option)
        {
            Caption = 'Prepayment';
            OptionCaption = '" ,Yes,No"';
            OptionMembers = " ",Yes,No;
        }
        field(18; "Reverse Sign"; Boolean)
        {
            Caption = 'Reverse Sign';
        }
        field(20; "VAT Amount Type"; Option)
        {
            Caption = 'VAT Amount Type';
            OptionCaption = '" ,Base,Amount"';
            OptionMembers = " ",Base,Amount;
        }
        field(21; "VAT Bus. Post. Group Filter"; Text[100])
        {
            Caption = 'VAT Bus. Post. Group Filter';

            trigger OnLookup();
            begin
                if PAGE.RUNMODAL(0, VATBusPostGroup) = ACTION::LookupOK then
                    "VAT Bus. Post. Group Filter" += VATBusPostGroup.Code;
            end;
        }
        field(22; "VAT Prod. Post. Group Filter"; Text[100])
        {
            Caption = 'VAT Prod. Post. Group Filter';

            trigger OnLookup();
            begin
                if PAGE.RUNMODAL(0, VATProdPostGroup) = ACTION::LookupOK then
                    "VAT Prod. Post. Group Filter" += VATProdPostGroup.Code;
            end;
        }
        field(30; "Location Filter"; Text[100])
        {
            Caption = 'Location Filter';

            trigger OnLookup();
            begin
                if "Source Table" = "Source Table"::"Value Entry" then
                    if PAGE.RUNMODAL(0, Location) = ACTION::LookupOK then "Location Filter" += Location.Code;
            end;
        }
        field(31; "Bin Filter"; Text[100])
        {
            Caption = 'Bin Filter';

            trigger OnLookup();
            begin
                if "Source Table" = "Source Table"::"Value Entry" then begin
                    Bin.SETFILTER("Location Code", "Location Filter");
                    if PAGE.RUNMODAL(0, Bin) = ACTION::LookupOK then "Bin Filter" += Bin.Code;
                end;
            end;
        }
        field(55; "Amount Due Type"; Option)
        {
            Caption = 'Amount Due Type';
            OptionCaption = '" ,Short-Term,Long-Term"';
            OptionMembers = " ","Short-Term","Long-Term";
        }
        field(56; "Posting Group Filter"; Code[250])
        {
            Caption = 'Posting Group Filter';
            TableRelation = IF ("Source Table" = CONST("Customer Entry")) "Customer Posting Group"
            ELSE
            IF ("Source Table" = CONST("Vendor Entry")) "Vendor Posting Group";
            ValidateTableRelation = false;
        }
        field(57; "Posting Date Filter"; Code[20])
        {
            Caption = 'Posting Date Filter';
        }
        field(58; "Due Date Filter"; Code[20])
        {
            Caption = 'Due Date Filter';
        }
        field(59; "Document Type Filter"; Text[100])
        {
            Caption = 'Document Type Filter';

            trigger OnValidate();
            begin
                case "Source Table" of
                    "Source Table"::"Customer Entry":
                        begin
                            CustLedgerEntry.SETFILTER("Document Type", "Document Type Filter");
                            "Document Type Filter" := CustLedgerEntry.GETFILTER("Document Type");
                        end;
                    "Source Table"::"Vendor Entry":
                        begin
                            VendLedgerEntry.SETFILTER("Document Type", "Document Type Filter");
                            "Document Type Filter" := VendLedgerEntry.GETFILTER("Document Type");
                        end;
                end;
            end;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnRename();
    begin
        ERROR(Text001, TABLECAPTION);
    end;

    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        BankAcc: Record "Bank Account";
        FixedAsset: Record "Fixed Asset";
        GLAcc: Record "G/L Account";
        VATBusPostGroup: Record "VAT Business Posting Group";
        VATProdPostGroup: Record "VAT Product Posting Group";
        Location: Record Location;
        Bin: Record Bin;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        VendLedgerEntry: Record "Vendor Ledger Entry";
        Text001: Label 'You cannot rename a %1.';
}

