tableextension 46015543 "VAT Statement Name Extension" extends "VAT Statement Name"
{
    // version NAVW17.00,NAVE111.0

    fields
    {
        field(46015605; "Date Row Filter"; Date)
        {
            Caption = 'Date Row Filter';
            Description = 'NAVE111.0,001';
            FieldClass = FlowFilter;
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.

}

