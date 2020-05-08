table 46015691 "Excise Classification Type"
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

    Caption = 'Excise Classification Type';
    //LookupPageID = "Excise Classification Types";

    fields
    {
        field(1; "Code"; Code[8])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(3; "Excise Label"; Boolean)
        {
            Caption = 'Excise Label';
        }
        field(50000; "Excise Invenotry Code"; Code[10])
        {
            Caption = 'Excise Inventory Code';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }
}

