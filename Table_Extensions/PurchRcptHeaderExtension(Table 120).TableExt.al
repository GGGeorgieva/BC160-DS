tableextension 46015513 tableextension46015513 extends "Purch. Rcpt. Header" 
{
    // version NAVW111.00.00.28629,NAVE111.0,NAVBG11.0

    fields
    {
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
        LOCKTABLE;
        PostPurchDelete.DeletePurchRcptLines(Rec);

        PurchCommentLine.SETRANGE("Document Type",PurchCommentLine."Document Type"::Receipt);
        PurchCommentLine.SETRANGE("No.","No.");
        PurchCommentLine.DELETEALL;
        ApprovalsMgmt.DeletePostedApprovalEntries(RECORDID);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        //NAVE111.0; 001; begin
        if LocalizationUsage.UseEastLocalization then
          PostPurchDelete.CheckIfPurchDocDeleteAllowed("Posting Date");
        //NAVE111.0; 001; end

        #1..7
        */
    //end;

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
        LocalizationUsage : Codeunit "Localization Usage";
}

