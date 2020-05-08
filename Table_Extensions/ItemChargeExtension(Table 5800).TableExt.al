tableextension 46015586 "Item Charge Extension" extends "Item Charge"
{
    // version NAVW111.00,NAVE111.0

    fields
    {
        field(46015605; "Incl. in Intrastat Amount"; Boolean)
        {
            Caption = 'Incl. in Intrastat Amount';
            Description = 'NAVE111.0,001';

            trigger OnValidate();
            begin
                //TO DO
                /*
                if "Incl. in Intrastat Amount" then
                  CheckIncludeIntrastat;
                */
            end;
        }
        field(46015606; "Incl. in Intrastat Stat. Value"; Boolean)
        {
            Caption = 'Incl. in Intrastat Stat. Value';
            Description = 'NAVE111.0,001';

            trigger OnValidate();
            begin
                //TO DO
                /*
                if "Incl. in Intrastat Stat. Value" then
                  CheckIncludeIntrastat;
                  */
            end;
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.

}

