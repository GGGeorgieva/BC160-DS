tableextension 46015522 tableextension46015522 extends "Job Ledger Entry" 
{
    // version NAVW111.00.00.24232,NAVE111.0

    fields
    {
        field(46015605;"Shipment Method Code";Code[10])
        {
            Caption = 'Shipment Method Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Shipment Method";
        }
        field(46015607;"Tariff No.";Code[10])
        {
            Caption = 'Tariff No.';
            Description = 'NAVE111.0,001';
            TableRelation = "Tariff Number";
        }
        field(46015608;"Net Weight";Decimal)
        {
            Caption = 'Net Weight';
            DecimalPlaces = 0:5;
            Description = 'NAVE111.0,001';
        }
        field(46015609;"Country/Region of Origin Code";Code[10])
        {
            Caption = 'Country/Region of Origin Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Country/Region";
        }
        field(46015611;"Intrastat Transaction";Boolean)
        {
            Caption = 'Intrastat Transaction';
            Description = 'NAVE111.0,001';
        }
        field(46015615;Correction;Boolean)
        {
            Caption = 'Correction';
            Description = 'NAVE111.0,001';
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.

}

