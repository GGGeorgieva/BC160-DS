tableextension 46015583 "Transfer Line Extension" extends "Transfer Line"
{
    // version NAVW111.00.00.27667,NAVE111.0,NAVBG11.0

    fields
    {

        //Unsupported feature: CodeModification on ""Item No."(Field 3).OnValidate". Please convert manually.

        //trigger "(Field 3)();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        TESTFIELD("Quantity Shipped",0);
        if CurrFieldNo <> 0 then
          TestStatusOpen;
        #4..33
        "Item Category Code" := Item."Item Category Code";
        "Product Group Code" := Item."Product Group Code";

        CreateDim(DATABASE::Item,"Item No.");
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..36
        //NAVBG11.0; 001; begin
        if LocalizationUsage.UseEastLocalization then begin
          lLocation.GET("Transfer-from Code" );
          lLocation1.GET("Transfer-to Code");
          if ((lLocation."Excise Tax Warehouse"  = true) and (lLocation1."Excise Tax Warehouse" = false ) )
            or ((lLocation."Excise Tax Warehouse"  = true) and (lLocation1."Excise Tax Warehouse" = true )  and
                (lLocation."License No."<>lLocation1."License No."))
          then begin
            "Additional Excise Code" := Item."Additional Excise Code";
            "Unit Excise"  :=Item."Unit Excise (LCY)";
            "Excise Item"  :=Item."Excise Item";
            "CN Code" := Item."Tariff No.";
            "Alcohol Content/Degree Plato"  :=Item."Degree / KW";
            "Excise Unit of Measure":=Item."Excise Decl. Unit of Measure";
            "Excise Rate":=Item."Excise Per Exc. Decl. UM (LCY)";
            "Calculate Excise":=  Item."Excise Item";
          end;
          if ExciseDestination.GET(Item."Excise Destination") then begin
            case ExciseDestination."Destination Type" of
              ExciseDestination."Destination Type"::Inbound:
                "Inbound Excise Destination" := Item."Excise Destination";
              ExciseDestination."Destination Type"::Outbound:
                "Outbound Excise Destination" := Item."Excise Destination";
            end;

          "Inbound Excise Destination" := TransHeader."Inbound Excise Destination";
          "Outbound Excise Destination" :=TransHeader."Outbound Excise Destination";
          end;
        end;
        //NAVBG11.0; 001; end

        CreateDim(DATABASE::Item,"Item No.");
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
        */
        //end;
        field(46015607; "Tariff No."; Code[10])
        {
            Caption = 'Tariff No.';
            Description = 'NAVE111.0,001';
            TableRelation = "Tariff Number";
        }
        field(46015609; "Country/Region of Origin Code"; Code[10])
        {
            Caption = 'Country/Region of Origin Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Country/Region";
        }
        field(46015610; "Inbound Excise Destination"; Code[2])
        {
            Caption = 'Inbound Excise Destination';
            Description = 'NAVBG11.0,001';
            TableRelation = "Excise Destination";
        }
        field(46015611; "Outbound Excise Destination"; Code[2])
        {
            Caption = 'Outbound Excise Destination';
            Description = 'NAVBG11.0,001';
            TableRelation = "Excise Destination";
        }
        field(46015612; "Additional Excise Code"; Text[13])
        {
            Caption = 'Additional Excise Code';
            Description = 'NAVBG11.0,001';
            Numeric = true;
        }
        field(46015613; "Excise Destination"; Code[2])
        {
            Caption = 'Excise Destination';
            Description = 'NAVBG11.0,001';
            TableRelation = "Excise Destination";
        }
        field(46015614; "Unit Excise"; Decimal)
        {
            Caption = 'Unit Excise';
            DecimalPlaces = 2 : 5;
            Description = 'NAVBG11.0,001';
            Editable = false;
        }
        field(46015615; "Excise Amount"; Decimal)
        {
            Caption = 'Excise Amount';
            Description = 'NAVBG11.0,001';
            Editable = false;
        }
        field(46015616; "Excise Item"; Boolean)
        {
            Caption = 'Excise Item';
            Description = 'NAVBG11.0,001';
            Editable = false;
        }
        field(46015617; "Calculate Excise"; Boolean)
        {
            Caption = 'Calculate Excise';
            Description = 'NAVBG11.0,001';
            Editable = true;

            trigger OnValidate();
            var
                lItem: Record Item;
            begin
                if lItem.GET("Item No.") then;
                if "Calculate Excise" = true then begin

                    "Additional Excise Code" := lItem."Additional Excise Code";
                    "Unit Excise" := lItem."Unit Excise (LCY)";
                    "Excise Item" := lItem."Excise Item";
                    "CN Code" := lItem."Tariff No.";
                    "Alcohol Content/Degree Plato" := lItem."Degree / KW";
                    "Excise Unit of Measure" := lItem."Excise Decl. Unit of Measure";
                    "Excise Rate" := lItem."Excise Per Exc. Decl. UM (LCY)";

                    //TO DO
                    //UpdateExciseAmounts;
                end
                else begin

                    "Additional Excise Code" := '';
                    "Unit Excise" := 0;
                    "Excise Item" := false;
                    "CN Code" := '';
                    "Alcohol Content/Degree Plato" := 0;
                    "Excise Unit of Measure" := '';
                    "Excise Rate" := 0;
                    //TO DO
                    //UpdateExciseAmounts;
                end;
            end;
        }
        field(46015618; "CN Code"; Code[10])
        {
            Caption = 'CN Code';
            Description = 'NAVBG11.0,001';
        }
        field(46015619; "Alcohol Content/Degree Plato"; Decimal)
        {
            Caption = 'Alcohol Content/Degree Plato';
            Description = 'NAVBG11.0,001';
        }
        field(46015620; "Excise Unit of Measure"; Code[10])
        {
            Caption = 'Excise Unit of Measure';
            Description = 'NAVBG11.0,001';
        }
        field(46015621; "Excise Rate"; Decimal)
        {
            Caption = 'Excise Rate';
            Description = 'NAVBG11.0,001';
        }
        field(46015622; "Excise Charge Acc. Base"; Decimal)
        {
            Caption = 'Excise Charge Acc. Base';
            Description = 'NAVBG11.0,001';
        }
        field(46015623; "Payment Obligation Type"; Code[2])
        {
            Caption = 'Payment Obligation Type';
            Description = 'NAVBG11.0,001';
            TableRelation = "Payment Obligation Type";
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
        lLocation: Record Location;
        lLocation1: Record Location;
        ExciseDestination: Record "Excise Destination";

}

