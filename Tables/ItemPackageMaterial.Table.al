table 46015633 "Item Package Material"
{
    // version NAVE18.00

    // -----------------------------------------------------------------------------------------
    // XAPT Solutions
    // MS Dynamics NAV 2015 Localisation
    // 
    // mp  : Mile Petachki
    // version : NAVE18.00
    // 
    // -----------------------------------------------------------------------------------------
    // No.   Sign     Date       Version        Description
    // -----------------------------------------------------------------------------------------
    // 001   mp       27.10.14   NAVE18.00      Created table from MS Dynamics NAV 6.00
    // ------------------------------------------------------------------------------------------

    Caption = 'Item Package Material';
    //LookupPageID = "Item Package Materials";

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            NotBlank = true;
            TableRelation = Item."No.";
        }
        field(2; "Package Material Code"; Code[10])
        {
            Caption = 'Package Material Code';
            NotBlank = true;
            TableRelation = "Package Material".Code;
        }
        field(3; "Item Unit Of Measure Code"; Code[10])
        {
            Caption = 'Item Unit Of Measure Code';
            NotBlank = true;
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(4; Weight; Decimal)
        {
            Caption = 'Weight';
            DecimalPlaces = 2 : 5;
            MinValue = 0;
        }
    }

    keys
    {
        key(Key1; "Item No.", "Item Unit Of Measure Code", "Package Material Code")
        {
        }
    }

    fieldgroups
    {
    }
}

