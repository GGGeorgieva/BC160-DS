table 46015519 "Item Packaging Specification"
{
    // version NAVBG8.00

    // -----------------------------------------------------------------------------------------
    // XAPT Solutions
    // MS Dynamics NAV 2015 Localisation
    // 
    // mp  : Mile Petachki
    // version : NAVBG8.00
    // 
    // -----------------------------------------------------------------------------------------
    // No.   Sign     Date       Version        Description
    // -----------------------------------------------------------------------------------------
    // 001   mp       27.10.14   NAVBG8.00      Created table from MS Dynamics NAV 6.00
    // ------------------------------------------------------------------------------------------

    Caption = 'Item Packaging Specification';
    //LookupPageID = "Item Packaging Specification";

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            NotBlank = true;
            TableRelation = Item."No.";
        }
        field(2; "Item Variant Code"; Code[10])
        {
            Caption = 'Item Variant Code';
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."));

            trigger OnValidate();
            var
                ItemVariant: Record "Item Variant";
            begin
                ItemVariant.SETRANGE("Item No.", "Item No.");
                ItemVariant.SETRANGE(Code, "Item Variant Code");
                if ItemVariant.FIND('-') then
                    "Item Variant Description" := ItemVariant.Description;
            end;
        }
        field(3; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(4; "Item Variant Description"; Text[30])
        {
            Caption = 'Item Variant Description';
        }
        field(5; "Packaging Type"; Option)
        {
            Caption = 'Packaging Type';
            OptionCaption = 'Primary,Secondary,Tertiary';
            OptionMembers = Primary,Secondary,Tertiary;
        }
        field(6; "Packaging Component Code"; Code[10])
        {
            Caption = 'Packaging Component Code';
            TableRelation = "Packaging Component".Code;
        }
        field(7; "Packaging Material Type Code"; Code[10])
        {
            Caption = 'Packaging Material Type Code';
            NotBlank = true;
            TableRelation = "Packaging Material";

            trigger OnValidate();
            var
                PackagingMaterialType: Record "Packaging Material Type";
            begin
                PackagingMaterialType.SETRANGE(Code, "Packaging Material Type Code");
                if PackagingMaterialType.FIND('-') then
                    VALIDATE("Product Tax Amount per Kg", PackagingMaterialType."Tax amount per Kg");

                if "Packaging Material Type Code" <> xRec."Packaging Material Type Code" then
                    VALIDATE("Packaging Material Code", '');
            end;
        }
        field(8; "Packaging Material Code"; Code[10])
        {
            Caption = 'Packaging Material Code';
            TableRelation = "Pack. Components Specification"."Row No." WHERE("Unit of Measure Code" = FIELD("Packaging Material Type Code"));
        }
        field(9; "Pack.Component Weight (kg)"; Decimal)
        {
            Caption = 'Pack.Component Weight (kg)';

            trigger OnValidate();
            begin
                "Pack.Component Tax Amount" := "Pack.Component Weight (kg)" * "Product Tax Amount per Kg";
            end;
        }
        field(10; "Product Tax Amount per Kg"; Decimal)
        {
            Caption = 'Product Tax Amount per Kg';
            Editable = false;

            trigger OnValidate();
            begin
                "Pack.Component Tax Amount" := "Pack.Component Weight (kg)" * "Product Tax Amount per Kg";
            end;
        }
        field(11; "Pack.Component Tax Amount"; Decimal)
        {
            Caption = 'Pack.Component Tax Amount';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Item No.", "Item Variant Code", "Unit of Measure Code", "Packaging Type", "Packaging Component Code")
        {
            SumIndexFields = "Pack.Component Tax Amount";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        SalesInvoiceLine.SETRANGE("No.", "Item No.");
        SalesInvoiceLine.SETRANGE("Variant Code", "Item Variant Code");
        SalesInvoiceLine.SETRANGE("Unit of Measure Code", "Unit of Measure Code");
        if SalesInvoiceLine.FIND('-') then
            ERROR(Text000, SalesInvoiceLine.TABLECAPTION);

        SalesCrMemoLine.SETRANGE("No.", "Item No.");
        SalesCrMemoLine.SETRANGE("Variant Code", "Item Variant Code");
        SalesCrMemoLine.SETRANGE("Unit of Measure Code", "Unit of Measure Code");
        if SalesCrMemoLine.FIND('-') then
            ERROR(Text000, SalesCrMemoLine.TABLECAPTION);
    end;

    trigger OnInsert();
    begin
        TESTFIELD("Unit of Measure Code");
    end;

    trigger OnRename();
    begin
        SalesInvoiceLine.SETRANGE("No.", xRec."Item No.");
        SalesInvoiceLine.SETRANGE("Variant Code", xRec."Item Variant Code");
        SalesInvoiceLine.SETRANGE("Unit of Measure Code", xRec."Unit of Measure Code");
        if SalesInvoiceLine.FIND('-') then
            ERROR(Text001, SalesInvoiceLine.TABLECAPTION);

        SalesCrMemoLine.SETRANGE("No.", xRec."Item No.");
        SalesCrMemoLine.SETRANGE("Variant Code", xRec."Item Variant Code");
        SalesCrMemoLine.SETRANGE("Unit of Measure Code", xRec."Unit of Measure Code");
        if SalesCrMemoLine.FIND('-') then
            ERROR(Text001, SalesCrMemoLine.TABLECAPTION);
    end;

    var
        Text000: Label 'You cannot delete the line because existing %1 refers to it.';
        Text001: Label 'You cannot rename the line because existing %1 refers to it.';
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
}

