table 46015696 "Excise Registration Type"
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

    Caption = 'Excise Registration Type';
    //LookupPageID = "Excise Registration Types";

    fields
    {
        field(1; "Code"; Code[2])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(3; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Licensed Warehouse Holder,Registered Company';
            OptionMembers = "Licensed Warehouse Holder","Registered Company";
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

