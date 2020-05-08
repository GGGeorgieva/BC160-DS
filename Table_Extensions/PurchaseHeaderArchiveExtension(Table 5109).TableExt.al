tableextension 46015572 tableextension46015572 extends "Purchase Header Archive" 
{
    // version NAVW111.00.00.28629,NAVE111.0

    fields
    {
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
        field(46015619;"EU 3-Party Intermediate Role";Boolean)
        {
            Caption = 'EU 3-Party Intermediate Role';
            Description = 'NAVE111.0,001';
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
        field(46015630;"Posting Desc. Code";Code[10])
        {
            Caption = 'Posting Desc. Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Posting Description" WHERE (Type=CONST("Purchase Document"));
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.

}

