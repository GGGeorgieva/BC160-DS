tableextension 46015599 tableextension46015599 extends "Service Invoice Header" 
{
    // version NAVW111.00.00.20783,NAVE111.0

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
        field(46015610;"VAT Date";Date)
        {
            Caption = 'VAT Date';
            Description = 'NAVE111.0,001';
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.

}

