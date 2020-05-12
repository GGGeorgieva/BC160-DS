tableextension 46015534 "Tariff Number Extension" extends "Tariff Number"
{
    fields
    {
        field(46015605; "Supplem. Unit of Measure Code"; Code[10])
        {
            Caption = 'Supplem. Unit of Measure Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Unit of Measure";
        }
    }
}

