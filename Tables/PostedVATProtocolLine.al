table 46015517 "Posted VAT Protocol Line"
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
    //                           NAVBG8.00      Changed field : 3 - Type
    // ------------------------------------------------------------------------------------------

    Caption = 'Posted VAT Protocol Line';

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; Type; Option)
        {
            Caption = 'Type';
            Description = 'NAVBG8.00';
            OptionCaption = '" ,G/L Account,Item,Resource,Fixed Asset,Charge (Item),Payment"';
            OptionMembers = " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)",Payment;
        }
        field(4; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type = CONST(" ")) "Standard Text"
            ELSE
            IF (Type = CONST("G/L Account")) "G/L Account"
            ELSE
            IF (Type = CONST(Item)) Item
            ELSE
            IF (Type = CONST(Resource)) Resource
            ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF (Type = CONST("Charge (Item)")) "Item Charge";
        }
        field(5; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(6; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(7; "Unit of Measure"; Text[10])
        {
            Caption = 'Unit of Measure';
        }
        field(9; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(10; "Unit Price (LCY)"; Decimal)
        {
            Caption = 'Unit Price (LCY)';
        }
        field(11; "VAT Base Amount (LCY)"; Decimal)
        {
            Caption = 'VAT Base Amount (LCY)';
        }
        field(12; "VAT Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'VAT Amount (LCY)';
            Editable = false;
        }
        field(15; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Purchase,Sale';
            OptionMembers = Purchase,Sale;
        }
        field(30; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(31; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(32; "VAT %"; Decimal)
        {
            Caption = 'VAT %';
        }
        field(35; "Sales VAT Account"; Code[20])
        {
            Caption = 'Sales VAT Account';
            TableRelation = "G/L Account";
        }
        field(36; "Purch. VAT Account"; Code[20])
        {
            Caption = 'Purch. VAT Account';
            TableRelation = "G/L Account";
        }
        field(40; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(41; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(52; "Work Type Code"; Code[10])
        {
            Caption = 'Work Type Code';
            TableRelation = "Work Type";

            trigger OnValidate();
            var
                WorkType: Record "Work Type";
            begin
            end;
        }
        field(61; "Bal. VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'Bal. VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(77; "VAT Calculation Type"; enum "Tax Calculation Type")
        {
            Caption = 'VAT Calculation Type';
            Editable = false;
        }
        field(102; Compressed; Boolean)
        {
            Caption = 'Compressed';
        }
        field(103; "System-Created Entry"; Boolean)
        {
            Caption = 'System-Created Entry';
        }
        field(106; "VAT Identifier"; Code[10])
        {
            Caption = 'VAT Identifier';
            Editable = false;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup();
            begin
                ShowDimensions;
            end;
        }
        field(5404; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
        }
        field(5407; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = IF (Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."))
            ELSE
            IF (Type = CONST(Resource)) "Resource Unit of Measure".Code WHERE("Resource No." = FIELD("No."))
            ELSE
            "Unit of Measure";

            trigger OnValidate();
            var
                UnitOfMeasureTranslation: Record "Unit of Measure Translation";
                ResUnitofMeasure: Record "Resource Unit of Measure";
            begin
            end;
        }
        field(5602; "Depreciation Book Code"; Code[10])
        {
            Caption = 'Depreciation Book Code';
            TableRelation = "Depreciation Book";
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            SumIndexFields = "VAT Base Amount (LCY)";
        }
    }

    fieldgroups
    {
    }

    var
        DimMgt: Codeunit DimensionManagement;

    procedure CalcVATAmountLines(var PostedIntInvHeader: Record "Posted VAT Protocol Header"; var VATAmountLine: Record "VAT Amount Line");
    begin
        VATAmountLine.DELETEALL;
        SETRANGE("Document No.", PostedIntInvHeader."No.");
        if FIND('-') then
            repeat
                VATAmountLine.INIT;
                VATAmountLine."VAT Identifier" := "VAT Identifier";
                VATAmountLine."VAT Calculation Type" := "VAT Calculation Type";
                VATAmountLine."VAT %" := "VAT %";
                VATAmountLine."VAT Base" := "VAT Base Amount (LCY)";
                VATAmountLine."VAT Amount" := "VAT Amount (LCY)";
                VATAmountLine."Amount Including VAT" := "VAT Base Amount (LCY)" + "VAT Amount (LCY)";
                VATAmountLine."Line Amount" := "VAT Base Amount (LCY)";
                VATAmountLine.InsertLine;
            until NEXT = 0;
    end;

    procedure ShowDimensions();
    var
        PostedDocDim: Record "Dimension Set Entry";
    begin
        TESTFIELD("No.");
        TESTFIELD("Line No.");
        DimMgt.ShowDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2', TABLECAPTION, "No."));
    end;
}

