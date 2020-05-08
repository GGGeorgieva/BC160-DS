tableextension 46015529 tableextension46015529 extends "Source Code Setup" 
{
    // version NAVW111.00,NAVE111.0,NAVBG11.0

    fields
    {
        field(46015505;"VAT Protocol";Code[10])
        {
            Caption = 'VAT Protocol';
            Description = 'NAVBG11.0,001';
            TableRelation = "Source Code";
        }
        field(46015645;"Cash Desk";Code[10])
        {
            Caption = 'Cash Desk';
            Description = 'NAVBG11.0,001';
            TableRelation = "Source Code";
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.

}

