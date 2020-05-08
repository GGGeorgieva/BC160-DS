tableextension 46015564 tableextension46015564 extends "Detailed Cust. Ledg. Entry" 
{
    // version NAVW111.00.00.20783,NAVE111.0

    fields
    {
        field(46015625;"Customer Posting Group";Code[10])
        {
            Caption = 'Customer Posting Group';
            Description = 'NAVE111.0,001';
            TableRelation = "Customer Posting Group";
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.

}

