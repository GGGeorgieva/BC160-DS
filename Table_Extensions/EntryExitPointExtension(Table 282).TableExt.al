tableextension 46015540 "Entry/Exit Point Extension" extends "Entry/Exit Point"
{
    // version NAVW17.00,NAVE111.0

    fields
    {
        field(46015605; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Country/Region";
        }
    }
}

