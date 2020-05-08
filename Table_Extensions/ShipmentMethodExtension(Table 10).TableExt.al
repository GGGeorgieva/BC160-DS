tableextension 46015617 "Shipment Method Extension" extends "Shipment Method"
{
    // version NAVW111.00,NAVE111.0

    fields
    {
        field(46015605; "Include Item Charges"; Boolean)
        {
            Caption = 'Include Item Charges';
            Description = 'NAVE111.0,001';

            trigger OnValidate();
            begin
                if "Include Item Charges" then begin
                    TESTFIELD("Adjustment %", 0);
                    //TO DO
                    //CheckIncludeIntrastat;
                end;
            end;
        }
        field(46015607; "Adjustment %"; Decimal)
        {
            Caption = 'Adjustment %';
            Description = 'NAVE111.0,001';
            MaxValue = 100;
            MinValue = -100;

            trigger OnValidate();
            begin
                if "Adjustment %" <> 0 then
                    TESTFIELD("Include Item Charges", false);
            end;
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.

}

