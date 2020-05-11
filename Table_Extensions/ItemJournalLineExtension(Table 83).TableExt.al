tableextension 46015612 "Item Journal Line Extension" extends "Item Journal Line"
{
    // version NAVW111.00.00.26401,NAVE111.0,NAVBG11.0 


    fields
    {

        modify("Item No.")
        {
            trigger OnBeforeValidate()
            begin
                DeleteExciseLabels(true);
                IF Item."No." <> "Item No." THEN
                    Item.GET("Item No.");
                if ("Item No." <> xRec."Item No.") then begin
                    "Tariff No." := Item."Tariff No.";
                    "Net Weight" := Item."Net Weight";
                    "Country/Region of Origin Code" := Item."Country/Region of Origin Code";
                end;
                case "Entry Type" of
                    "Entry Type"::"Negative Adjmt.":
                        begin
                            Product := Item.Product;
                            "Calculate Excise" := false;
                            "Calculate Product Tax" := false;
                            GetUnitExcise;
                            GetUnitProductTax;
                            //TODO
                            //"Unit Amount" := UnitCost;                  
                        end;
                    "Entry Type"::Sale:
                        begin
                            "Calculate Excise" := Item."Excise Item";
                            "Calculate Product Tax" := Item."Product Tax Item";
                            GetUnitExcise;
                            GetUnitProductTax;
                        end;
                end;
            end;
        }
        modify("Entry Type")
        {
            trigger OnBeforeValidate()
            begin
                if xRec."Entry Type" <> "Entry Type" then
                    ModifyExciseLabels(FIELDCAPTION("Entry Type"));
            end;
        }
        modify("Document No.")
        {
            trigger OnBeforeValidate()
            begin
                if xRec."Document No." <> "Document No." then
                    ModifyExciseLabels(FIELDCAPTION("Document No."));
            end;
        }
        modify(Quantity)
        {
            trigger OnBeforeValidate()
            begin
                GLSetup.GET;
                if GLSetup."Mark Neg. Qty as Correction" then
                    "G/L Correction" := (Quantity < 0) or ("Invoiced Quantity" < 0);
                if xRec."Document No." <> "Document No." then
                    ModifyExciseLabels(FIELDCAPTION("Document No."));
            end;
        }
        modify("Inventory Value (Revalued)")
        {
            trigger OnAfterValidate()
            begin
                if GLSetup."Mark Neg. Qty as Correction" then begin
                    "G/L Correction" := Amount < 0;
                    MODIFY;
                end;
            end;
        }
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
                GetUnitExcise;
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
                GetUnitProductTax;
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
        //TODO
        /*
        key(Key1;"Document No.","Posting Date")
        {
        }
        */
    }

    var
        ProdOrder: Record "Production Order";
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderComp: Record "Prod. Order Component";
        ProdOrderRtngLine: Record "Prod. Order Routing Line";
        StatReportingSetup: Record "Stat. Reporting Setup";
        GLSetup: Record "General Ledger Setup";
        UOMMgt: Codeunit "Unit of Measure Management";
        Item: Record Item;
        Text46012225: Label '%1 is required for Item %2.';
        Text46012226: Label '"This action will lead to the loosing excise labels data that is specified for this sales line.\Do you want to continue?  "';
        Text46012227: Label 'If you change %1, the existing excise labels lines will be deleted and new excise labels lines based on the new information on the item journal line will be created.\Do you want to change %1.';


    trigger OnBeforeDelete()
    begin
        DeleteExciseLabels(false);
    end;

    procedure GetUnitExcise();
    begin
        IF Item."No." <> "Item No." THEN
            Item.GET("Item No.");

        if "Calculate Excise" then begin
            "Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item, "Unit of Measure Code");

            VALIDATE("Unit Excise", Item."Unit Excise (LCY)" * "Qty. per Unit of Measure");
        end else
            VALIDATE("Unit Excise", 0);
    end;

    procedure GetUnitProductTax();
    var
        ItemUnitOfMeasure: Record "Item Unit of Measure";
    begin
        IF Item."No." <> "Item No." THEN
            Item.GET("Item No.");
        if "Calculate Product Tax" then begin
            if ItemUnitOfMeasure.GET(Item."No.", "Unit of Measure Code") then
                VALIDATE("Unit Product Tax", ItemUnitOfMeasure."Product Tax (LCY)")
            else
                VALIDATE("Unit Product Tax", 0);
        end else
            VALIDATE("Unit Product Tax", 0);
    end;

    procedure CheckIntrastat();
    begin
        if "Intrastat Transaction" then begin
            StatReportingSetup.GET;
            if StatReportingSetup."Transaction Type Mandatory" and ("Transaction Type" = '') then
                ERROR(Text46012225, FIELDCAPTION("Transaction Type"), "Item No.");
            if StatReportingSetup."Transaction Spec. Mandatory" and ("Transaction Specification" = '') then
                ERROR(Text46012225, FIELDCAPTION("Transaction Specification"), "Item No.");
            if StatReportingSetup."Transport Method Mandatory" and ("Transport Method" = '') then
                ERROR(Text46012225, FIELDCAPTION("Transport Method"), "Item No.");
            if StatReportingSetup."Shipment Method Mandatory" and ("Shipment Method Code" = '') then
                ERROR(Text46012225, FIELDCAPTION("Shipment Method Code"), "Item No.");
            if StatReportingSetup."Tariff No. Mandatory" and ("Tariff No." = '') then
                ERROR(Text46012225, FIELDCAPTION("Tariff No."), "Item No.");
            if StatReportingSetup."Net Weight Mandatory" and ("Net Weight" = 0) then
                ERROR(Text46012225, FIELDCAPTION("Net Weight"), "Item No.");
            if StatReportingSetup."Country/Region of Origin Mand." and ("Country/Region of Origin Code" = '') then
                ERROR(Text46012225, FIELDCAPTION("Country/Region of Origin Code"), "Item No.");
        end;
    end;

    procedure ShowExciseLabels();
    var
        ExciseLabel: Record "Excise Label";
        Item2: Record Item;
    begin
        Item2.GET("Item No.");
        Item2.TESTFIELD("Excise Item");
        TESTFIELD(Quantity);

        ExciseLabel.RESET;
        ExciseLabel.FILTERGROUP := 2;
        ExciseLabel.SETRANGE("Entry Type", "Entry Type");
        ExciseLabel.SETRANGE("Journal Template Name", "Journal Template Name");
        ExciseLabel.SETRANGE("Journal Batch Name", "Journal Batch Name");
        ExciseLabel.SETRANGE("Document No.", "Document No.");
        ExciseLabel.SETRANGE("Document Line No.", "Line No.");
        ExciseLabel.FILTERGROUP := 0;
        //TODO
        //PAGE.RUNMODAL(PAGE::Page46015717,ExciseLabel);
    end;

    procedure DeleteExciseLabels(IsWarning: Boolean);
    var
        ExciseLabel: Record "Excise Label";
    begin
        ExciseLabel.RESET;
        ExciseLabel.SETRANGE("Entry Type", "Entry Type");
        ExciseLabel.SETRANGE("Journal Template Name", "Journal Template Name");
        ExciseLabel.SETRANGE("Journal Batch Name", "Journal Batch Name");
        ExciseLabel.SETRANGE("Document No.", "Document No.");
        ExciseLabel.SETRANGE("Document Line No.", "Line No.");

        if ExciseLabel.FINDFIRST then begin
            if IsWarning and (not CONFIRM(Text46012226, false)) then
                ERROR('');

            ExciseLabel.DELETEALL;
        end;
    end;

    procedure UpdateExciseLabels();
    var
        ExciseLabel: Record "Excise Label";
    begin
        ExciseLabel.RESET;
        ExciseLabel.SETRANGE("Entry Type", "Entry Type");
        ExciseLabel.SETRANGE("Journal Template Name", "Journal Template Name");
        ExciseLabel.SETRANGE("Journal Batch Name", "Journal Batch Name");
        ExciseLabel.SETRANGE("Document No.", "Document No.");
        ExciseLabel.SETRANGE("Document Line No.", "Line No.");

        if ExciseLabel.FINDFIRST then begin
            repeat
                ExciseLabel."Posting Date" := "Posting Date";
                ExciseLabel.MODIFY;
            until ExciseLabel.NEXT = 0;
        end;
    end;

    procedure ModifyExciseLabels(FieldCaption: Text[30]);
    var
        ExciseLabel2: Record "Excise Label";
        ExciseLabel: Record "Excise Label";
    begin
        ExciseLabel.RESET;
        ExciseLabel.SETRANGE("Entry Type", xRec."Entry Type");
        ExciseLabel.SETRANGE("Journal Template Name", xRec."Journal Template Name");
        ExciseLabel.SETRANGE("Journal Batch Name", xRec."Journal Batch Name");
        ExciseLabel.SETRANGE("Document Line No.", xRec."Line No.");
        ExciseLabel.SETRANGE("Document No.", xRec."Document No.");

        if ExciseLabel.FINDFIRST then begin
            if not CONFIRM(Text46012227, false, FieldCaption) then
                ERROR('');

            repeat
                ExciseLabel2.INIT;
                ExciseLabel2.TRANSFERFIELDS(ExciseLabel);
                ExciseLabel2."Entry Type" := "Entry Type";
                ExciseLabel2."Document No." := "Document No.";
                ExciseLabel2.INSERT;
            until ExciseLabel.NEXT = 0;

            ExciseLabel.DELETEALL;
        end;
    end;
}

