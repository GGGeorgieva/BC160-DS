tableextension 46015519 "Location Extension" extends Location
{
    // version NAVW111.00.00.27667,NAVE111.0,NAVBG11.0

    fields
    {
        field(46015610; "Area"; Code[10])
        {
            Caption = 'Area';
            Description = 'NAVE111.0,001';
            TableRelation = Area;
        }
        field(46015611; "Excise Tax Warehouse"; Boolean)
        {
            Caption = 'Excise Tax Warehouse';
            Description = 'NAVBG11.0,001';
        }
        field(46015612; "License No."; Text[13])
        {
            Caption = 'License No.';
            Description = 'NAVBG11.0,001';
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.

}

