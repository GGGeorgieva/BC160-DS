tableextension 46015553 tableextension46015553 extends "Purchases & Payables Setup" 
{
    // version NAVW111.00.00.26401,NAVE111.0,NAVBG11.0

    fields
    {
        field(46015507;"EU VAT Bus. Posting Group";Code[20])
        {
            Caption = 'EU VAT Bus. Posting Group';
            Description = 'NAVBG11.0,001';
            TableRelation = "VAT Business Posting Group";
        }
        field(46015508;"Intr. Jnl. Incl. Item Charges";Boolean)
        {
            Caption = 'Intr. Jnl. Incl. Item Charges';
            Description = 'NAVBG11.0,001';
        }
        field(46015605;"Posted Doc. Deletion to Date";Date)
        {
            Caption = 'Posted Doc. Deletion to Date';
            Description = 'NAVE111.0,001';
        }
        field(46015609;"Default VAT Date";Option)
        {
            Caption = 'Default VAT Date';
            Description = 'NAVE111.0,001';
            OptionCaption = 'Posting Date,Document Date,Blank';
            OptionMembers = "Posting Date","Document Date",Blank;
        }
        field(46015610;"Allow Alter Posting Groups";Boolean)
        {
            Caption = 'Allow Alter Posting Groups';
            Description = 'NAVE111.0,001';
        }
        field(46015624;"SAD Tariff Required";Boolean)
        {
            Caption = 'SAD Tariff Required';
            Description = 'NAVE111.0,001';
        }
        field(46015625;"Allow Manual Edit SAD Line";Boolean)
        {
            Caption = 'Allow Manual Edit SAD Line';
            Description = 'NAVE111.0,001';
        }
        field(46015626;"Import Statement Nos.";Code[10])
        {
            Caption = 'Import Statement Nos.';
            Description = 'NAVE111.0,001';
            TableRelation = "No. Series";
        }
        field(46015627;"Allow LCY in Import SAD";Boolean)
        {
            Caption = 'Allow LCY in Import SAD';
            Description = 'NAVE111.0,001';
        }
        field(46015630;"Posting Desc. Code";Code[10])
        {
            Caption = 'Posting Desc. Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Posting Description" WHERE (Type=CONST("Purchase Document"));
        }
        field(46015700;"Unreal. VAT Prot. Nos.";Code[20])
        {
            Caption = 'Unrealized VAT Protocol Nos.';
            Description = 'NAVBG11.0,001';
            TableRelation = "No. Series".Code;
        }
        field(46015701;"Posted Unreal. VAT Prot. Nos.";Code[20])
        {
            Caption = 'Posted Unrealized VAT Protocol Nos.';
            Description = 'NAVBG11.0,001';
            TableRelation = "No. Series".Code;
        }
        field(46015702;"Protokol VAT Bus. Post. Group";Code[20])
        {
            Caption = 'Protokol VAT Bus. Post. Group';
            Description = 'NAVBG11.0,001';
            TableRelation = "VAT Business Posting Group".Code;
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.

}
