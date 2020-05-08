tableextension 46015605 tableextension46015605 extends "Return Shipment Header" 
{
    // version NAVW111.00.00.20783,NAVE111.0,NAVBG11.0

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
            TableRelation = Table46015715;
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
        field(46015625;"SAD No.";Code[20])
        {
            Caption = 'SAD No.';
            Description = 'NAVE111.0,001';
            TableRelation = "Import SAD Header" WHERE ("Vendor No."=FIELD("Buy-from Vendor No."));
        }
        field(46015626;"Customs Procedure Code";Code[10])
        {
            Caption = 'Customs Procedure Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Custom Procedure";
        }
    }


    //Unsupported feature: CodeModification on "OnDelete". Please convert manually.

    //trigger OnDelete();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        LOCKTABLE;
        PostPurchDelete.DeletePurchShptLines(Rec);

        #4..8

        if CertificateOfSupply.GET(CertificateOfSupply."Document Type"::"Return Shipment","No.") then
          CertificateOfSupply.DELETE(true);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        //NAVE111.0; 001; single
        if LocalizationUsage.UseEastLocalization then
          PostPurchDelete.CheckIfPurchDocDeleteAllowed("Posting Date");

        #1..11
        */
    //end;

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
        LocalizationUsage : Codeunit "Localization Usage";
}

