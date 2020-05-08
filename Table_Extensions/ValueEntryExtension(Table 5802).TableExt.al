tableextension 46015588 tableextension46015588 extends "Value Entry" 
{
    // version NAVW111.00.00.22292,NAVBG11.0

    fields
    {
        field(46015505;"Unit Excise";Decimal)
        {
            Caption = 'Unit Excise';
            DecimalPlaces = 2:5;
            Description = 'NAVBG11.0,001';
        }
        field(46015506;"Unit Excise (ACY)";Decimal)
        {
            Caption = 'Unit Excise (ACY)';
            DecimalPlaces = 2:5;
            Description = 'NAVBG11.0,001';
            Editable = false;
        }
        field(46015507;"Excise Amount (Actual)";Decimal)
        {
            Caption = 'Excise Amount (Actual)';
            Description = 'NAVBG11.0,001';
        }
        field(46015508;"Excise Amount (Actual) (ACY)";Decimal)
        {
            Caption = 'Excise Amount (Actual) (ACY)';
            Description = 'NAVBG11.0,001';
        }
        field(46015509;Product;Boolean)
        {
            Caption = 'Product';
            Description = 'NAVBG11.0,001';
        }
        field(46015510;"Calculate Excise";Boolean)
        {
            Caption = 'Calculate Excise';
            Description = 'NAVBG11.0,001';
        }
        field(46015511;"Unit Product Tax";Decimal)
        {
            Caption = 'Unit Product Tax';
            DecimalPlaces = 2:5;
            Description = 'NAVBG11.0,001';
        }
        field(46015512;"Unit Product Tax (ACY)";Decimal)
        {
            Caption = 'Unit Product Tax (ACY)';
            DecimalPlaces = 2:5;
            Description = 'NAVBG11.0,001';
            Editable = false;
        }
        field(46015513;"Product Tax Amount (Actual)";Decimal)
        {
            Caption = 'Product Tax Amount (Actual)';
            Description = 'NAVBG11.0,001';
        }
        field(46015514;"Product Tax Amount (Act.)(ACY)";Decimal)
        {
            Caption = 'Product Tax Amount (Act.)(ACY)';
            Description = 'NAVBG11.0,001';
        }
        field(46015515;"Excise Amount (Expected)";Decimal)
        {
            Caption = 'Excise Amount (Expected)';
            Description = 'NAVBG11.0,001';
        }
        field(46015516;"Excise Amount (Expected) (ACY)";Decimal)
        {
            Caption = 'Excise Amount (Expected) (ACY)';
            Description = 'NAVBG11.0,001';
        }
        field(46015517;"Product Tax Amount (Expected)";Decimal)
        {
            Caption = 'Product Tax Amount (Expected)';
            Description = 'NAVBG11.0,001';
        }
        field(46015518;"Product Tax Amount (Exp.)(ACY)";Decimal)
        {
            Caption = 'Product Tax Amount (Exp.)(ACY)';
            Description = 'NAVBG11.0,001';
        }
        field(46015519;"Calculate Product Tax";Boolean)
        {
            Caption = 'Calculate Product Tax';
            Description = 'NAVBG11.0,001';
        }
        field(46015606;"Incl. in Intrastat Amount";Boolean)
        {
            Caption = 'Incl. in Intrastat Amount';
            Description = 'NAVE111.0,001';
        }
        field(46015607;"Incl. in Intrastat Stat. Value";Boolean)
        {
            Caption = 'Incl. in Intrastat Stat. Value';
            Description = 'NAVE111.0,001';
        }
        field(46015615;"G/L Correction";Boolean)
        {
            Caption = 'G/L Correction';
            Description = 'NAVE111.0,001';
        }
        field(46015625;"SAD No.";Code[20])
        {
            Caption = 'SAD No.';
            Description = 'NAVE111.0,001';
            Editable = false;
            TableRelation = IF ("Source Type"=CONST(Customer)) "Export SAD Header" WHERE ("Customer No."=FIELD("Source No."))
                            ELSE IF ("Source Type"=CONST(Vendor)) "Import SAD Header" WHERE ("Vendor No."=FIELD("Source No."));
        }
    }
    keys
    {
        key(Key1;"Entry Type","Expected Cost","Calculate Excise","Item No.","Posting Date")
        {
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.

}

