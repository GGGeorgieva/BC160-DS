tableextension 46015540 tableextension46015540 extends "Entry/Exit Point" 
{
    // version NAVW17.00,NAVE111.0

    fields
    {
        field(46015605;"Country/Region Code";Code[10])
        {
            Caption = 'Country/Region Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Country/Region";
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.

}

