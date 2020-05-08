tableextension 46015534 "Tariff Number Extension" extends "Tariff Number"
{
    // version NAVW17.00,NAVE111.0

    fields
    {
        field(46015605; "Supplem. Unit of Measure Code"; Code[10])
        {
            Caption = 'Supplem. Unit of Measure Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Unit of Measure";
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.

}

