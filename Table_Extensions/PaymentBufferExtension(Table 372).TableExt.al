tableextension 46015560 "Payment Buffer Extension" extends "Payment Buffer"
{
    // version NAVW111.00.00.24232,NAVE111.0

    fields
    {
        field(46015605; "Vendor Posting Group"; Code[10])
        {
            Caption = 'Vendor Posting Group';
            Description = 'NAVE111.0,001';
            TableRelation = "Vendor Posting Group";
        }
    }
}

