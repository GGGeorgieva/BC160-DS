table 46015632 "Package Material"
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

    Caption = 'Package Material';
    //LookupPageID = "Package Materials";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(3; "Tax Rate (LCY)"; Decimal)
        {
            Caption = 'Tax Rate (LCY)';
            MinValue = 0;
        }
        field(4; "Discount %"; Decimal)
        {
            Caption = 'Discount %';
            MaxValue = 100;
            MinValue = 0;
        }
        field(5; "Exemption %"; Decimal)
        {
            Caption = 'Exemption %';
            MaxValue = 100;
            MinValue = 0;
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

