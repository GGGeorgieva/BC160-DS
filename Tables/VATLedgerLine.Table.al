table 46015508 "VAT Ledger Line"
{
    // version NAVBG11.0

    // -----------------------------------------------------------------------------------------
    // XAPT Solutions
    // MS Dynamics NAV 2015 Localisation
    // 
    // mp  : Mile Petachki
    // version : NAVBG8.00,BCS8.00.112
    // 
    // -----------------------------------------------------------------------------------------
    // No.   Sign     Date       Version        Description
    // -----------------------------------------------------------------------------------------
    // 001   mp       27.10.14   NAVBG8.00      Created table from MS Dynamics NAV 6.00
    //                           NAVBG8.00      Added new field : 46015701 - VAT Chargeable On Recipient
    // 
    // -----------------------------------------------------------------------------------------
    // Dynamic Solutions
    // MS Dynamics NAV 2017 Localisation
    // 
    // 
    // -----------------------------------------------------------------------------------------
    // No.   Sign     Date       Version        Description
    // -----------------------------------------------------------------------------------------
    // 001                                     List of changes :
    //                          NAVBG11.0  Changed field "Type" TableRelation property
    // ------------------------------------------------------------------------------------------

    Caption = 'VAT Ledger Line';

    fields
    {
        field(1;Type;Option)
        {
            Caption = 'Type';
            OptionCaption = 'Purchase,Sales';
            OptionMembers = Purchase,Sales;
        }
        field(2;"Period Start Date";Date)
        {
            Caption = 'Period Start Date';
            TableRelation = "VAT Ledger"."Period Start Date" WHERE (Type=FIELD(Type));
        }
        field(3;"Line No.";Integer)
        {
            Caption = 'Line No.';
        }
        field(6;Base;Decimal)
        {
            Caption = 'Base';
        }
        field(7;Amount;Decimal)
        {
            Caption = 'Amount';
        }
        field(10;"Document Type";Code[10])
        {
            Caption = 'Document Type';
            TableRelation = "Document Type".Code;

            trigger OnValidate();
            var
                DocumentType : Record "Document Type" temporary;
            begin
                if ("Document Type" <> '') and (DocumentType.GetDocTypeDescription("Document Type") = '') then
                  ERROR(Text16200,DocumentType.TABLECAPTION,"Document Type");
            end;
        }
        field(11;"Document No.";Code[30])
        {
            Caption = 'Document No.';
        }
        field(12;"Original Document No.";Code[20])
        {
            Caption = 'Original Document No.';
        }
        field(13;"Issue Date";Date)
        {
            Caption = 'Issue Date';
        }
        field(14;"Contracting Agent ID No.";Code[20])
        {
            Caption = 'Contracting Agent ID No.';
        }
        field(15;"Contracting Agent Name";Text[50])
        {
            Caption = 'Contracting Agent Name';
        }
        field(16;"VAT Subject";Text[30])
        {
            Caption = 'VAT Subject';
        }
        field(17;"Contractor Type";Option)
        {
            Caption = 'Contractor Type';
            OptionCaption = 'Customer,Vendor';
            OptionMembers = Customer,Vendor;
        }
        field(18;"Contractor No.";Code[20])
        {
            Caption = 'Contractor No.';
            TableRelation = IF ("Contractor Type"=CONST(Customer)) Customer
                            ELSE IF ("Contractor Type"=CONST(Vendor)) Vendor;
        }
        field(20;"VAT Bus. Posting Group";Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(21;"VAT Prod. Posting Group";Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(30;"Sales Base Index";Option)
        {
            Caption = 'Sales Base Index';
            OptionCaption = '" ,02-11,02-12,02-13,02-14,02-15,02-16,02-17,02-18,02-19,02-25,02-26,02-10"';
            OptionMembers = " ","02-11","02-12","02-13","02-14","02-15","02-16","02-17","02-18","02-19","02-25","02-26","02-10";
        }
        field(31;"Sales Amount Index";Option)
        {
            Caption = 'Sales Amount Index';
            OptionCaption = '" ,02-21,02-22,02-23,02-24,02-20"';
            OptionMembers = " ","02-21","02-22","02-23","02-24","02-20";
        }
        field(32;"Purch. Base Index";Option)
        {
            Caption = 'Purch. Base Index';
            OptionCaption = '" ,03-30,03-31,03-32,03-44"';
            OptionMembers = " ","03-30","03-31","03-32","03-44";
        }
        field(33;"Purch. Amount Index";Option)
        {
            Caption = 'Purch. Amount Index';
            OptionCaption = '" ,03-41,03-42"';
            OptionMembers = " ","03-41","03-42";
        }
        field(34;"Purch. Annual Corr. Amount";Decimal)
        {
            Caption = 'Purch. Annual Corr. Amount';
        }
        field(46015700;"VAT Entry No.";Integer)
        {
            Caption = 'VAT Entry No.';
        }
        field(46015701;"VAT Chargeable On Recipient";Option)
        {
            Caption = 'Purchase according to art. 163a of the VAT Act';
            Description = 'NAVBG8.00';
            OptionCaption = '" ,01,02"';
            OptionMembers = " ","01","02";
        }
    }

    keys
    {
        key(Key1;Type,"Period Start Date","Line No.")
        {
            SumIndexFields = Base,Amount;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        TestLedgerStatus;
    end;

    trigger OnInsert();
    begin
        TestLedgerStatus;
    end;

    trigger OnModify();
    begin
        TestLedgerStatus;
    end;

    var
        Text16200 : Label '%1 ''''%2'''' does not exist.';

    procedure TestLedgerStatus();
    var
        VATLedger : Record "VAT Ledger";
    begin
        VATLedger.GET(Type,"Period Start Date");
        VATLedger.TestStatus;
    end;
}

