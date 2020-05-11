tableextension 46015535 "Intrastat Jnl. Line Ext." extends "Intrastat Jnl. Line"
{
    // version NAVW111.00,NAVE111.0,NAVBG11.0

    fields
    {
        //TODO

        //Unsupported feature: Change DecimalPlaces on ""Total Weight"(Field 22)". Please convert manually.


        //Unsupported feature: CodeModification on ""Tariff No."(Field 6).OnValidate". Please convert manually.

        //trigger "(Field 6)();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        TESTFIELD("Item No.",'');
        GetItemDescription;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        //NAVBG11.0; 001; single
        if not LocalizationUsage.UseBulgarianLocalization then

        TESTFIELD("Item No.",'');
        GetItemDescription;
        */
        //end;


        //Unsupported feature: CodeModification on ""Net Weight"(Field 13).OnValidate". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        if Quantity <> 0 then
          "Total Weight" := ROUND("Net Weight" * Quantity,0.00001)
        else
          "Total Weight" := 0;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..4

        //NAVE111.0; 001; begin
        if LocalizationUsage.UseEastLocalization then
          if Item.GET("Item No.") then
            if "Supplementary Units" then
              "Supplem. UoM Net Weight" := "Net Weight" /
                UnitOfMeasureManagement.GetQtyPerUnitOfMeasure(Item,"Supplem. UoM Code");
        //NAVE111.0; 001; end
        */
        //end;
        field(46015505; "Transport Country/Region Code"; Code[10])
        {
            Caption = 'Transport Country/Region Code';
            Description = 'NAVBG11.0,001';
            TableRelation = "Country/Region";
        }
        field(46015507; "Action"; Option)
        {
            Caption = 'Action';
            Description = 'NAVBG11.0,001';
            OptionCaption = '" ,NEW,EDITED-OLD,EDITED-NEW,DELETED"';
            OptionMembers = " ",NEW,"EDITED-OLD","EDITED-NEW",DELETED;
        }
        field(46015508; "Prev. Line No."; Integer)
        {
            Caption = 'Prev. Line No.';
            Description = 'NAVBG11.0,001';
            TableRelation = "Intrastat Jnl. Line"."Line No." WHERE("Journal Template Name" = FIELD("Journal Template Name"),
                                                                    "Journal Batch Name" = FIELD("Journal Batch Name"),
                                                                    Action = CONST("EDITED-OLD"),
                                                                    Type = FIELD(Type));
        }
        field(46015605; "Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Shipment Method";
        }
        field(46015606; "Supplem. UoM Code"; Code[10])
        {
            Caption = 'Supplem. UoM Code';
            Description = 'NAVE111.0,001';
            Editable = false;
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(46015607; "Supplem. UoM Quantity"; Decimal)
        {
            Caption = 'Supplem. UoM Quantity';
            DecimalPlaces = 0 : 0;
            Description = 'NAVE111.0,001';
            Editable = false;
        }
        field(46015608; "Supplem. UoM Net Weight"; Decimal)
        {
            Caption = 'Supplem. UoM Net Weight';
            DecimalPlaces = 2 : 5;
            Description = 'NAVE111.0,001';
            Editable = false;
        }
        field(46015609; "Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure';
            Description = 'NAVE111.0,001';
            Editable = false;
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
        UnitOfMeasureManagement: Codeunit "Unit of Measure Management";

}

