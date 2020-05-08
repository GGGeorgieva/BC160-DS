table 46015523 "Pack. Components Specification"
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

    Caption = 'Pack. Components Specification';

    fields
    {
        field(1;"Row No.";Integer)
        {
            Caption = 'Row No.';
        }
        field(2;"Item No.";Code[20])
        {
            Caption = 'Item No.';
        }
        field(3;"Item Variant Code";Code[10])
        {
            Caption = 'Item Variant Code';
        }
        field(4;"Unit of Measure Code";Code[10])
        {
            Caption = 'Unit of Measure Code';
        }
        field(5;"Item Variant Description";Text[30])
        {
            Caption = 'Item Variant Description';
        }
        field(6;"Packaging Type";Option)
        {
            Caption = 'Packaging Type';
            OptionCaption = 'Primary,Secondary,Tertiary';
            OptionMembers = Primary,Secondary,Tertiary;
        }
        field(7;"Pack. Component Description";Text[30])
        {
            Caption = 'Pack. Component Description';
        }
        field(8;"Packaging Material Code";Code[10])
        {
            Caption = 'Packaging Material Code';
        }
        field(9;"Pack. Component Weight (kg)";Decimal)
        {
            Caption = 'Pack. Component Weight (kg)';
        }
        field(10;"Product Tax Amount per Kg";Decimal)
        {
            Caption = 'Product Tax Amount per Kg';
        }
        field(11;"Pack. Component Tax Amount";Decimal)
        {
            Caption = 'Pack. Component Tax Amount';
        }
        field(12;"Tax Amount per Pack Type";Decimal)
        {
            Caption = 'Tax Amount per Pack Type';
        }
        field(13;"Total Tax Amount";Decimal)
        {
            Caption = 'Total Tax Amount';
        }
    }

    keys
    {
        key(Key1;"Row No.")
        {
        }
    }

    fieldgroups
    {
    }
}

