tableextension 46015564 "Det. Cust. Ledg. Entry Ext." extends "Detailed Cust. Ledg. Entry"
{
    // version NAVW111.00.00.20783,NAVE111.0

    fields
    {
        field(46015625; "Customer Posting Group"; Code[10])
        {
            Caption = 'Customer Posting Group';
            Description = 'NAVE111.0,001';
            TableRelation = "Customer Posting Group";
        }
    }
}

