tableextension 46015612 "Item Journal Line Extension" extends "Item Journal Line"
{
    // version NAVW111.00.00.26401,NAVE111.0,NAVBG11.0

    fields
    {

        //Unsupported feature: CodeModification on ""Item No."(Field 3).OnValidate". Please convert manually.

        //trigger "(Field 3)();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        if "Item No." <> xRec."Item No." then begin
          "Variant Code" := '';
          "Bin Code" := '';
          if CurrFieldNo <> 0 then
        #5..32
        "Item Category Code" := Item."Item Category Code";
        "Product Group Code" := Item."Product Group Code";

        if ("Value Entry Type" <> "Value Entry Type"::"Direct Cost") or
           ("Item Charge No." <> '')
        then begin
        #39..70
          "Entry Type"::Consumption,
          "Entry Type"::"Assembly Consumption":
            "Unit Amount" := UnitCost;
          "Entry Type"::Sale:
            SalesPriceCalcMgt.FindItemJnlLinePrice(Rec,FIELDNO("Item No."));
          "Entry Type"::Transfer:
            begin
              "Unit Amount" := 0;
        #79..148

        OnBeforeVerifyReservedQty(Rec,xRec,FIELDNO("Item No."));
        ReserveItemJnlLine.VerifyChange(Rec,xRec);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        if "Item No." <> xRec."Item No." then begin

          //NAVBG11.0; 001; begin
          if LocalizationUsage.UseEastLocalization then
              DeleteExciseLabels(true);
          //NAVBG11.0; 001; end

        #2..35
        //NAVE111.0; 001; begin
        if ("Item No." <> xRec."Item No.") and LocalizationUsage.UseEastLocalization then begin
          "Tariff No." := Item."Tariff No.";
          "Net Weight" := Item."Net Weight";
          "Country/Region of Origin Code" := Item."Country/Region of Origin Code";
        end;
        //NAVE111.0; 001; end

        #36..73

          //NAVE111.0; 001; begin
          "Entry Type"::"Negative Adjmt." :
            begin
              if LocalizationUsage.UseEastLocalization then begin
                Product := Item.Product;
                "Calculate Excise" := false;
                "Calculate Product Tax" := false;
                GetUnitExcise;
                GetUnitProductTax;
                "Unit Amount" := UnitCost;
              end;
            end;
          //NAVE111.0; 001; end

          "Entry Type"::Sale:

            //NAVE111.0; 001; begin
            begin
              if LocalizationUsage.UseEastLocalization then begin
                Product := Item.Product;
                "Calculate Excise" := Item."Excise Item";
                "Calculate Product Tax" := Item."Product Tax Item";
                GetUnitExcise;
                GetUnitProductTax;
              end;
            //NAVE111.0; 001; end

            SalesPriceCalcMgt.FindItemJnlLinePrice(Rec,FIELDNO("Item No."));

            //NAVE111.0; 001; single
            end;

        #76..151
        */
        //end;


        //Unsupported feature: CodeModification on ""Entry Type"(Field 5).OnValidate". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        if not ("Entry Type" in ["Entry Type"::"Positive Adjmt.","Entry Type"::"Negative Adjmt."]) then
          TESTFIELD("Phys. Inventory",false);

        if CurrFieldNo <> 0 then
          WMSManagement.CheckItemJnlLineFieldChange(Rec,xRec,FIELDCAPTION("Entry Type"));

        #7..37
          Type := Type::" ";

        ReserveItemJnlLine.VerifyChange(Rec,xRec);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..3
        //NAVBG11.0; 001; begin
        if LocalizationUsage.UseEastLocalization then
          if xRec."Entry Type" <> "Entry Type" then
            ModifyExciseLabels(FIELDCAPTION("Entry Type"));
        //NAVBG11.0; 001; end

        #4..40
        */
        //end;


        //Unsupported feature: CodeInsertion on ""Document No."(Field 7)". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //begin
        /*
        //NAVBG11.0; 001; begin
        if LocalizationUsage.UseEastLocalization then
          if xRec."Document No." <> "Document No." then
            ModifyExciseLabels(FIELDCAPTION("Document No."));
        //NAVBG11.0; 001; end
        */
        //end;


        //Unsupported feature: CodeModification on "Quantity(Field 13).OnValidate". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        if ("Entry Type" <= "Entry Type"::Transfer) and (Quantity <> 0) then
          TESTFIELD("Item No.");

        #4..28

        CheckItemAvailable(FIELDNO(Quantity));

        if "Entry Type" = "Entry Type"::Transfer then begin
          "Qty. (Calculated)" := 0;
          "Qty. (Phys. Inventory)" := 0;
        #35..40

        if Item."Item Tracking Code" <> '' then
          ReserveItemJnlLine.VerifyQuantity(Rec,xRec);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..31
        //NAVE111.0; 001; begin
        if LocalizationUsage.UseEastLocalization then begin
          ReadGLSetup;
          if GLSetup."Mark Neg. Qty as Correction" then
            "G/L Correction" := (Quantity < 0) or ("Invoiced Quantity" < 0);
        end;
        //NAVE111.0; 001; end

        #32..43

        //NAVBG11.0; 001; begin
        if LocalizationUsage.UseEastLocalization then
          if xRec."Document No." <> "Document No." then
            ModifyExciseLabels(FIELDCAPTION("Document No."));
        //NAVBG11.0; 001; end
        */
        //end;


        //Unsupported feature: CodeModification on ""Inventory Value (Revalued)"(Field 5803).OnValidate". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        TESTFIELD("Value Entry Type","Value Entry Type"::Revaluation);
        VALIDATE(Amount,"Inventory Value (Revalued)" - "Inventory Value (Calculated)");
        ReadGLSetup;
        if ("Unit Cost (Revalued)" <> xRec."Unit Cost (Revalued)") or
           ("Inventory Value (Revalued)" <> xRec."Inventory Value (Revalued)")
        then begin
        #7..10
          if CurrFieldNo <> 0 then
            ClearSingleAndRolledUpCosts;
        end
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..3

        //NAVE111.0; 001; begin
        if GLSetup."Mark Neg. Qty as Correction" and LocalizationUsage.UseEastLocalization then
          "G/L Correction" := Amount < 0;
        //NAVE111.0; 001; end

        #4..13
        */
        //end;
        field(46015505; "Unit Excise"; Decimal)
        {
            Caption = 'Unit Excise';
            DecimalPlaces = 2 : 5;
            Description = 'NAVBG11.0,001';

            trigger OnValidate();
            begin
                if
                  ("Entry Type" = "Entry Type"::Sale) and
                  ("Calculate Excise" or
                   (xRec."Calculate Excise" and (CurrFieldNo = FIELDNO("Calculate Excise"))))
                then
                    "Unit Amount" := "Unit Amount" - xRec."Unit Excise" + "Unit Excise";

                VALIDATE("Unit Amount");
            end;
        }
        field(46015506; "Unit Excise (ACY)"; Decimal)
        {
            Caption = 'Unit Excise (ACY)';
            DecimalPlaces = 2 : 5;
            Description = 'NAVBG11.0,001';
            Editable = false;
        }
        field(46015507; "Excise Amount"; Decimal)
        {
            Caption = 'Excise Amount';
            Description = 'NAVBG11.0,001';
            Editable = false;
        }
        field(46015508; "Excise Amount (ACY)"; Decimal)
        {
            Caption = 'Excise Amount (ACY)';
            Description = 'NAVBG11.0,001';
            Editable = false;
        }
        field(46015509; Product; Boolean)
        {
            Caption = 'Product';
            Description = 'NAVBG11.0,001';
        }
        field(46015510; "Calculate Excise"; Boolean)
        {
            Caption = 'Calculate Excise';
            Description = 'NAVBG11.0,001';

            trigger OnValidate();
            begin
                //TO DO
                //GetUnitExcise;
            end;
        }
        field(46015511; "Unit Product Tax"; Decimal)
        {
            Caption = 'Unit Product Tax';
            DecimalPlaces = 2 : 5;
            Description = 'NAVBG11.0,001';

            trigger OnValidate();
            begin
                if
                  ("Entry Type" = "Entry Type"::Sale) and
                  ("Calculate Product Tax" or
                   (xRec."Calculate Product Tax" and (CurrFieldNo = FIELDNO("Calculate Product Tax"))))
                then
                    "Unit Amount" := "Unit Amount" - xRec."Unit Product Tax" + "Unit Product Tax";

                VALIDATE("Unit Amount");
            end;
        }
        field(46015512; "Unit Product Tax (ACY)"; Decimal)
        {
            Caption = 'Unit Product Tax (ACY)';
            DecimalPlaces = 2 : 5;
            Description = 'NAVBG11.0,001';
            Editable = false;
        }
        field(46015513; "Product Tax Amount"; Decimal)
        {
            Caption = 'Product Tax Amount';
            Description = 'NAVBG11.0,001';
            Editable = false;
        }
        field(46015514; "Product Tax Amount (ACY)"; Decimal)
        {
            Caption = 'Product Tax Amount (ACY)';
            Description = 'NAVBG11.0,001';
            Editable = false;
        }
        field(46015515; "Calculate Product Tax"; Boolean)
        {
            Caption = 'Calculate Product Tax';
            Description = 'NAVBG11.0,001';

            trigger OnValidate();
            begin
                //TO DO
                //GetUnitProductTax;
            end;
        }
        field(46015516; "Transport Country/Region Code"; Code[10])
        {
            Caption = 'Transport Country/Region Code';
            Description = 'NAVBG11.0,001';
            TableRelation = "Country/Region";
        }
        field(46015605; "Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Shipment Method";
        }
        field(46015606; "Incl. in Intrastat Amount"; Boolean)
        {
            Caption = 'Incl. in Intrastat Amount';
            Description = 'NAVE111.0,001';

            trigger OnValidate();
            begin
                TESTFIELD("Item Charge No.");
            end;
        }
        field(46015607; "Tariff No."; Code[10])
        {
            Caption = 'Tariff No.';
            Description = 'NAVE111.0,001';
            TableRelation = "Tariff Number";
        }
        field(46015608; "Net Weight"; Decimal)
        {
            Caption = 'Net Weight';
            Description = 'NAVE111.0,001';
        }
        field(46015609; "Country/Region of Origin Code"; Code[10])
        {
            Caption = 'Country/Region of Origin Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Country/Region";
        }
        field(46015610; "Incl. in Intrastat Stat. Value"; Boolean)
        {
            Caption = 'Incl. in Intrastat Stat. Value';
            Description = 'NAVE111.0,001';

            trigger OnValidate();
            begin
                TESTFIELD("Item Charge No.");
            end;
        }
        field(46015611; "Intrastat Transaction"; Boolean)
        {
            Caption = 'Intrastat Transaction';
            Description = 'NAVE111.0,001';
            Editable = false;
        }
        field(46015612; "G/L Correction"; Boolean)
        {
            Caption = 'G/L Correction';
            Description = 'NAVE111.0,001';
        }
        field(46015625; "SAD No."; Code[20])
        {
            Caption = 'SAD No.';
            Description = 'NAVE111.0,001';
        }
        field(46015626; "Outbound Excise Destination"; Code[2])
        {
            Caption = 'Outbound Excise Destination';
            Description = 'NAVBG11.0,001';
            TableRelation = "Excise Destination";
        }
        field(46015627; "Inbound Excise Destination"; Code[2])
        {
            Caption = 'Inbound Excise Destination';
            Description = 'NAVBG11.0,001';
            TableRelation = "Excise Destination";
        }
        field(46015628; "Additional Excise Code"; Text[13])
        {
            Caption = 'Additional Excise Code';
            Description = 'NAVBG11.0,001';
            Numeric = true;
        }
        field(46015629; "Payment Obligation Type"; Code[2])
        {
            Caption = 'Payment Obligation Type';
            Description = 'NAVBG11.0,001';
            TableRelation = "Payment Obligation Type";
        }
        field(46015630; "Show In Excise Declar"; Boolean)
        {
            Caption = 'Show In Excise Declar';
            Description = 'NAVBG11.0,001';
        }
        field(46015631; "Exclude from Declaration"; Boolean)
        {
            Caption = 'Exclude from Declaration';
            Description = 'NAVBG11.0,001';
        }
        field(46015632; "Post Transfer Excise"; Boolean)
        {
            Caption = 'Post Transfer Excise';
            Description = 'NAVBG11.0,001';
        }
        field(46015633; "Excise Item"; Boolean)
        {
            Caption = 'Excise Item';
            Description = 'NAVBG11.0,001';
            Editable = false;
        }
        field(46015634; "CN Code"; Code[10])
        {
            Caption = 'CN Code';
            Description = 'NAVBG11.0,001';
        }
        field(46015635; "Alcohol Content/Degree Plato"; Decimal)
        {
            Caption = 'Alcohol Content/Degree Plato';
            Description = 'NAVBG11.0,001';
        }
        field(46015636; "Excise Unit of Measure"; Code[10])
        {
            Caption = 'Excise Unit of Measure';
            Description = 'NAVBG11.0,001';
        }
        field(46015637; "Excise Rate"; Decimal)
        {
            Caption = 'Excise Rate';
            Description = 'NAVBG11.0,001';
        }
        field(46015638; "Excise Charge Acc. Base"; Decimal)
        {
            Caption = 'Excise Charge Acc. Base';
            Description = 'NAVBG11.0,001';
        }
        field(46015639; "Excise Declaration Correction"; Boolean)
        {
            Caption = 'Excise Declaration Correction';
            Description = 'NAVBG11.0,001';
        }
    }
    keys
    {
        //TO DO
        /*
        key(Key1;"Document No.","Posting Date")
        {
        }
        */
    }


    //Unsupported feature: CodeModification on "OnDelete". Please convert manually.

    //trigger OnDelete();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    ReserveItemJnlLine.DeleteLine(Rec);

    CALCFIELDS("Reserved Qty. (Base)");
    TESTFIELD("Reserved Qty. (Base)",0);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..4

    //NAVBG11.0; 001; begin
    if LocalizationUsage.UseEastLocalization then
      DeleteExciseLabels(false);
    //NAVBG11.0; 001; end
    */
    //end;

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
        ProdOrder: Record "Production Order";
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderComp: Record "Prod. Order Component";
        ProdOrderRtngLine: Record "Prod. Order Routing Line";
        StatReportingSetup: Record "Stat. Reporting Setup";
        Text46012225: Label '%1 is required for Item %2.';
        Text46012226: Label '"This action will lead to the loosing excise labels data that is specified for this sales line.\Do you want to continue?  "';
        Text46012227: Label 'If you change %1, the existing excise labels lines will be deleted and new excise labels lines based on the new information on the item journal line will be created.\Do you want to change %1.';
}

