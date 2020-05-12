tableextension 46015517 "Purch. Cr. Memo Hdr. Ext." extends "Purch. Cr. Memo Hdr."
{
    // version NAVW111.00.00.20783,NAVE111.0,NAVBG11.0

    fields
    {
        field(46015505; "Identification No."; Text[13])
        {
            Caption = 'Identification No.';
            Description = 'NAVBG8.00,001';
        }
        field(46015507; "Debit Memo"; Boolean)
        {
            Caption = 'Debit Memo';
            Description = 'NAVBG8.00,001';
        }
        field(46015508; "To Invoice No."; Code[20])
        {
            Caption = 'To Invoice No.';
            Description = 'NAVBG8.00,001';
            TableRelation = "Purch. Cr. Memo Hdr."."No." WHERE("Buy-from Vendor No." = FIELD("Buy-from Vendor No."));
        }
        field(46015509; "To Invoice Date"; Date)
        {
            Caption = 'To Invoice Date';
            Description = 'NAVBG8.00,001';
        }
        field(46015510; Void; Boolean)
        {
            Caption = 'Void';
            Description = 'NAVBG8.00,001';
        }
        field(46015511; "Void Date"; Date)
        {
            Caption = 'Void Date';
            Description = 'NAVBG8.00,001';
        }
        field(46015512; "VAT Subject"; Text[30])
        {
            Caption = 'VAT Subject';
            Description = 'NAVBG8.00,001';
            NotBlank = true;
        }
        field(46015513; "Sales Protocol"; Boolean)
        {
            Caption = 'Sales Protocol';
            Description = 'NAVBG8.00,001';
        }
        field(46015515; "Do not include in VAT Ledgers"; Boolean)
        {
            Caption = 'Do not include in VAT Ledgers';
            Description = 'NAVBG8.00,001';
        }
        field(46015526; "VAT Exempt Ground"; Code[10])
        {
            Caption = 'VAT Exempt Ground';
            Description = 'NAVBG8.00,001';
        }
        field(46015527; "Composed By"; Text[30])
        {
            Caption = 'Composed By';
            Description = 'NAVBG8.00,001';
        }
        field(46015529; "VAT Protocol"; Boolean)
        {
            Caption = 'VAT Protocol';
            Description = 'NAVBG8.00,001';
        }
        field(46015542; "Excise Tax Document No."; Code[20])
        {
            Caption = 'Excise Tax Document No.';
        }
        field(46015544; "Excise Document Date"; Date)
        {
            Caption = 'Excise Document Date';
        }
        field(46015545; "Payment Obligation Type"; Code[20])
        {
            Caption = 'Payment Obligation Type';
            TableRelation = "Payment Obligation Type";
        }
        field(46015546; "Return Date of AAD"; Date)
        {
            Caption = 'Return Date of AAD';
        }
        field(46015605; "Registration No."; Text[20])
        {
            Caption = 'Registration No.';
            Description = 'NAVE18.00,001';
        }
        field(46015606; "Registration No. 2"; Text[20])
        {
            Caption = 'Registration No. 2';
            Description = 'NAVE18.00,001';
        }
        field(46015608; "EU 3-Party Trade"; Boolean)
        {
            Caption = 'EU 3-Party Trade';
            Description = 'NAVE18.00,001';
        }
        field(46015610; "VAT Date"; Date)
        {
            Caption = 'VAT Date';
            Description = 'NAVE18.00,001';
        }
        field(46015614; "Industry Code"; Code[20])
        {
            Caption = 'Industry Code';
            Description = 'NAVE18.00,001';
            TableRelation = "Industry Code";
        }
        field(46015619; "EU 3-Party Intermediate Role"; Boolean)
        {
            Caption = 'EU 3-Party Intermediate Role';
            Description = 'NAVE18.00,001';
        }
        field(46015625; "SAD No."; Code[20])
        {
            Caption = 'SAD No.';
            Description = 'NAVE18.00,001';
            TableRelation = "Import SAD Header"."No." WHERE("Vendor No." = FIELD("Buy-from Vendor No."));
        }
        field(46015626; "Customs Procedure Code"; Code[10])
        {
            Caption = 'Customs Procedure Code';
            Description = 'NAVE18.00,001';
            TableRelation = "Custom Procedure";
        }
        field(46015700; "Unrealized VAT"; Boolean)
        {
            Caption = 'Unrealized VAT';
            Description = 'NAVBG8.00,001';
        }
        field(46055540; "Appendix No."; Code[20])
        {
            Caption = 'Appendix No.';
        }
    }
    var
        Text46012125: Label 'The document is already voided.';
        Text46012126: Label 'Document %1 was voided.';

    trigger OnBeforeDelete()
    var
        PostPurchDelete: Codeunit "PostPurch-Delete";
    begin
        //TODO: after adding the procedure
        //PostPurchDelete.CheckIfPurchDocDeleteAllowed("Posting Date")
    end;

    procedure Voiding();
    var
        VATEntry: Record "VAT Entry";
    //TODO: after adding the page
    //VoidDate : Page "Void Date Input";
    begin
        if Void then
            ERROR(Text46012125);
        //TODO: after adding the page
        /* 
          if VoidDate.RUNMODAL = ACTION::OK then begin
            VoidDate.GetVoidDate("Void Date");
            if "Void Date" = 0D then
              exit;
          end;
          */

        VATEntry.RESET;
        VATEntry.SETRANGE(Type, VATEntry.Type::Purchase);
        VATEntry.SETRANGE("Document No.", "No.");
        VATEntry.SETRANGE("Posting Date", "Posting Date");
        if VATEntry.FIND('-') then
            repeat
                VATEntry.Void := true;
                VATEntry."Void Date" := "Void Date";
                VATEntry.MODIFY;
            until VATEntry.NEXT = 0;

        Void := true;
        MODIFY;

        MESSAGE(Text46012126, "No.");
    end;
}

