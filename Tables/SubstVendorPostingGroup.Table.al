table 46015610 "Subst. Vendor Posting Group"
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

    Caption = 'Subst. Vendor Posting Group';

    fields
    {
        field(1;"Parent Vend. Posting Group";Code[10])
        {
            Caption = 'Parent Vend. Posting Group';
            TableRelation = "Vendor Posting Group";
        }
        field(2;"Vendor Posting Group";Code[10])
        {
            Caption = 'Vendor Posting Group';
            TableRelation = "Vendor Posting Group";

            trigger OnValidate();
            begin
                if "Vendor Posting Group" = "Parent Vend. Posting Group" then
                  ERROR(Text26500);
            end;
        }
    }

    keys
    {
        key(Key1;"Parent Vend. Posting Group","Vendor Posting Group")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Text26500 : Label 'Posting Group cannot substitute itself.';
}

