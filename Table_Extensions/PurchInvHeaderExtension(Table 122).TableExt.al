tableextension 46015515 tableextension46015515 extends "Purch. Inv. Header" 
{
    // version NAVW111.00.00.24232,NAVE111.0,NAVBG11.0

    fields
    {
        field(46015505;"Identification No.";Text[13])
        {
            Caption = 'Identification No.';
            Description = 'NAVBG11.0,001';
        }
        field(46015507;"Debit Memo";Boolean)
        {
            Caption = 'Debit Memo';
            Description = 'NAVBG11.0,001';
        }
        field(46015508;"To Invoice No.";Code[20])
        {
            Caption = 'To Invoice No.';
            Description = 'NAVBG11.0,001';
            TableRelation = "Purch. Inv. Header"."No." WHERE ("Buy-from Vendor No."=FIELD("Buy-from Vendor No."));
        }
        field(46015509;"To Invoice Date";Date)
        {
            Caption = 'To Invoice Date';
            Description = 'NAVBG11.0,001';
        }
        field(46015510;Void;Boolean)
        {
            Caption = 'Void';
            Description = 'NAVBG11.0,001';
        }
        field(46015511;"Void Date";Date)
        {
            Caption = 'Void Date';
            Description = 'NAVBG11.0,001';
        }
        field(46015512;"VAT Subject";Text[30])
        {
            Caption = 'VAT Subject';
            Description = 'NAVBG11.0,001';
            NotBlank = true;
        }
        field(46015513;"Sales Protocol";Boolean)
        {
            Caption = 'Sales Protocol';
            Description = 'NAVBG11.0,001';
        }
        field(46015515;"Do not include in VAT Ledgers";Boolean)
        {
            Caption = 'Do not include in VAT Ledgers';
            Description = 'NAVBG11.0,001';
        }
        field(46015526;"VAT Exempt Ground";Code[10])
        {
            Caption = 'VAT Exempt Ground';
            Description = 'NAVBG11.0,001';
        }
        field(46015527;"Composed By";Text[30])
        {
            Caption = 'Composed By';
            Description = 'NAVBG11.0,001';
        }
        field(46015529;"VAT Protocol";Boolean)
        {
            Caption = 'VAT Protocol';
            Description = 'NAVBG11.0,001';
        }
        field(46015540;"Appendix No.";Code[20])
        {
            Caption = 'Vendor Appendix No.';
            Description = 'NAVBG11.0,001';
        }
        field(46015542;"Excise Tax Document No.";Code[20])
        {
            Caption = 'Excise Tax Document No.';
            Description = 'NAVBG11.0,001';
        }
        field(46015544;"Excise Document Date";Date)
        {
            Caption = 'Excise Document Date';
            Description = 'NAVBG11.0,001';
        }
        field(46015545;"Payment Obligation Type";Code[20])
        {
            Caption = 'Payment Obligation Type';
            Description = 'NAVBG11.0,001';
            TableRelation = "Payment Obligation Type";
        }
        field(46015546;"Return Date of AAD";Date)
        {
            Caption = 'Return Date of AAD';
            Description = 'NAVBG11.0,001';
        }
        field(46015605;"Registration No.";Text[20])
        {
            Caption = 'Registration No.';
            Description = 'NAVE111.0,001';
        }
        field(46015606;"Registration No. 2";Text[20])
        {
            Caption = 'Registration No. 2';
            Description = 'NAVE111.0,001';
        }
        field(46015608;"EU 3-Party Trade";Boolean)
        {
            Caption = 'EU 3-Party Trade';
            Description = 'NAVE111.0,001';
        }
        field(46015610;"VAT Date";Date)
        {
            Caption = 'VAT Date';
            Description = 'NAVE111.0,001';
        }
        field(46015614;"Industry Code";Code[20])
        {
            Caption = 'Industry Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Industry Code";
        }
        field(46015619;"EU 3-Party Intermediate Role";Boolean)
        {
            Caption = 'EU 3-Party Intermediate Role';
            Description = 'NAVE111.0,001';
        }
        field(46015623;"Reversed By Cr. Memo No.";Code[20])
        {
            Caption = 'Reversed By Cr. Memo No.';
            Description = 'NAVE111.0,001';
        }
        field(46015625;"SAD No.";Code[20])
        {
            Caption = 'SAD No.';
            Description = 'NAVE111.0,001';
            TableRelation = "Import SAD Header"."No." WHERE ("Vendor No."=FIELD("Buy-from Vendor No."),
                                                             "Customs Currency Code"=FIELD("Currency Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(46015626;"Customs Procedure Code";Code[10])
        {
            Caption = 'Customs Procedure Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Custom Procedure";
        }
        field(46015627;"SAD Vend. Inv. No.";Code[20])
        {
            Caption = 'SAD Vend. Inv. No.';
            Description = 'NAVE111.0,001';
        }
        field(46015700;"Unrealized VAT";Boolean)
        {
            Caption = 'Unrealized VAT';
            Description = 'NAVBG11.0,001';
        }
    }


    //Unsupported feature: CodeModification on "OnDelete". Please convert manually.

    //trigger OnDelete();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        PostPurchDelete.IsDocumentDeletionAllowed("Posting Date");
        LOCKTABLE;
        PostPurchDelete.DeletePurchInvLines(Rec);
        #4..8
        ApprovalsMgmt.DeletePostedApprovalEntries(RECORDID);
        PostedDeferralHeader.DeleteForDoc(DeferralUtilities.GetPurchDeferralDocType,'','',
          PurchCommentLine."Document Type"::"Posted Invoice","No.");
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        //NAVE111.0; 001; begin
        if LocalizationUsage.UseEastLocalization then
          PostPurchDelete.CheckIfPurchDocDeleteAllowed("Posting Date")
        else
        //NAVE111.0; 001; end

        #1..11
        */
    //end;

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
        Text46012125 : Label 'The document is already voided.';
        Text46012126 : Label 'Document %1 was voided.';
        LocalizationUsage : Codeunit "Localization Usage";
}

