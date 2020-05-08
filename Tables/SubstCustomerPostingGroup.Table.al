table 46015609 "Subst. Customer Posting Group"
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

    Caption = 'Subst. Customer Posting Group';

    fields
    {
        field(1;"Parent Cust. Posting Group";Code[10])
        {
            Caption = 'Parent Cust. Posting Group';
            TableRelation = "Customer Posting Group";
        }
        field(2;"Customer Posting Group";Code[10])
        {
            Caption = 'Customer Posting Group';
            TableRelation = "Customer Posting Group";

            trigger OnValidate();
            begin
                if "Customer Posting Group" = "Parent Cust. Posting Group" then
                  ERROR(Text26500);
            end;
        }
    }

    keys
    {
        key(Key1;"Parent Cust. Posting Group","Customer Posting Group")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Text26500 : Label 'Posting Group cannot substitute itself.';
}

