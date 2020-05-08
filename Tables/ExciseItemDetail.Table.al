table 46015693 "Excise Item Detail"
{
    // version NAVBG11.0

    // -----------------------------------------------------------------------------------------
    // Dynamic Solutions
    // MS Dynamics NAV 2017 Localisation
    // 
    // 
    // -----------------------------------------------------------------------------------------
    // No.   Sign     Date       Version        Description
    // -----------------------------------------------------------------------------------------
    // 001                        NAVBG11.0
    // -----------------------------------------------------------------------------------------

    Caption = 'Excise Item Detail';
    //LookupPageID = "Excise Item Details";

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            NotBlank = true;
            TableRelation = Item;
        }
        field(2; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(3; Value; Text[50])
        {
            Caption = 'Value';
        }
    }

    keys
    {
        key(Key1; "Item No.", "Code")
        {
        }
    }

    fieldgroups
    {
    }
}

