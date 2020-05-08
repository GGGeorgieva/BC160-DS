table 46015631 "Delivery Person"
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

    Caption = 'Delivery Person';
    DataCaptionFields = "Identity Card No.", "Delivery Person Name";
    //LookupPageID = "Delivery Persons";

    fields
    {
        field(1; "Identity Card No."; Code[20])
        {
            Caption = 'Identity Card No.';
            NotBlank = true;
            ValidateTableRelation = false;
        }
        field(2; "Delivery Person Name"; Text[30])
        {
            Caption = 'Delivery Person Name';
        }
        field(4; "Identity Card Authority"; Text[50])
        {
            Caption = 'Identity Card Authority';
        }
        field(5; "Vehicle Reg. No."; Code[10])
        {
            Caption = 'Vehicle Reg. No.';
        }
        field(6; "Delivery Transport Method"; Code[10])
        {
            Caption = 'Delivery Transport Method';
            TableRelation = "Transport Method".Code;
        }
    }

    keys
    {
        key(Key1; "Identity Card No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Identity Card No.", "Delivery Person Name", "Identity Card Authority", "Vehicle Reg. No.")
        {
        }
    }
}

