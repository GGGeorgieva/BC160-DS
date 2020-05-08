tableextension 46015507 tableextension46015507 extends "Sales Shipment Line" 
{
    // version NAVW111.00.00.23019,NAVE111.0,NAVBG11.0

    fields
    {
        field(46015543;"Outbound Excise Destination";Code[2])
        {
            Caption = 'Outbound Excise Destination';
            Description = 'NAVBG11.0,001';
            TableRelation = Table0;
        }
        field(46015544;"CN Code";Code[10])
        {
            Caption = 'CN Code';
            Description = 'NAVBG11.0,001';
        }
        field(46015545;"Alcohol Content/Degree Plato";Decimal)
        {
            Caption = 'Alcohol Content/Degree Plato';
            Description = 'NAVBG11.0,001';
        }
        field(46015546;"Excise Unit of Measure";Code[10])
        {
            Caption = 'Excise Unit of Measure';
            Description = 'NAVBG11.0,001';
        }
        field(46015547;"Excise Rate";Decimal)
        {
            Caption = 'Excise Rate';
            Description = 'NAVBG11.0,001';
        }
        field(46015548;"Excise Charge Acc. Base";Decimal)
        {
            Caption = 'Excise Charge Acc. Base';
            Description = 'NAVBG11.0,001';
        }
        field(46015549;"Additional Excise Code";Text[13])
        {
            Caption = 'Additional Excise Code';
            Description = 'NAVBG11.0,001';
            Numeric = true;
        }
        field(46015550;"Do not include in Excise";Boolean)
        {
            Caption = 'Do not include in Excise';
            Description = 'NAVBG11.0,001';
        }
        field(46015551;"Inbound excise destination";Code[2])
        {
            Caption = 'Inbound excise destination';
            Description = 'NAVBG11.0,001';
        }
        field(46015552;"Excise Declaration Correction";Boolean)
        {
            Caption = 'Excise Declaration Correction';
            Description = 'NAVBG11.0,001';
        }
        field(46015607;"Tariff No.";Code[10])
        {
            Caption = 'Tariff No.';
            Description = 'NAVE111.0,001';
            TableRelation = "Tariff Number";
        }
        field(46015609;"Country/Region of Origin Code";Code[10])
        {
            Caption = 'Country/Region of Origin Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Country/Region";
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.

}

