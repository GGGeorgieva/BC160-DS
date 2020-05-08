tableextension 46015560 tableextension46015560 extends "Payment Buffer" 
{
    // version NAVW111.00.00.24232,NAVE111.0

    fields
    {
        field(46015605;"Vendor Posting Group";Code[10])
        {
            Caption = 'Vendor Posting Group';
            Description = 'NAVE111.0,001';
            TableRelation = "Vendor Posting Group";
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.

}

