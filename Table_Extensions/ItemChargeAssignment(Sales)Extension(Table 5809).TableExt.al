tableextension 46015590 tableextension46015590 extends "Item Charge Assignment (Sales)" 
{
    // version NAVW111.00,NAVE111.0

    fields
    {
        field(46015606;"Incl. in Intrastat Amount";Boolean)
        {
            Caption = 'Incl. in Intrastat Amount';
            Description = 'NAVE111.0,001';

            trigger OnValidate();
            begin
                CheckIncludeIntrastat;
            end;
        }
        field(46015607;"Incl. in Intrastat Stat. Value";Boolean)
        {
            Caption = 'Incl. in Intrastat Stat. Value';
            Description = 'NAVE111.0,001';

            trigger OnValidate();
            begin
                CheckIncludeIntrastat;
            end;
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.

}

