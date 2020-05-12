tableextension 46015617 "Shipment Method Extension" extends "Shipment Method"
{
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
                    CheckIncludeIntrastat;
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
    PROCEDURE CheckIncludeIntrastat();
    VAR
        StatReportingSetup: Record "Stat. Reporting Setup";
    BEGIN
        //NAVE111.0; 001; entire function
        StatReportingSetup.GET;
        StatReportingSetup.TESTFIELD("No Item Charges in Intrastat", false);
    END;
}

