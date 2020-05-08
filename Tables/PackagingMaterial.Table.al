table 46015522 "Packaging Material"
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

    Caption = 'Packaging Material';
    //LookupPageID = "Packaging Materials";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;

            trigger OnValidate();
            var
                PackagingMaterial: Record "Packaging Material";
                Text000: Label 'The Code field must be unique.';
            begin
                PackagingMaterial.SETRANGE(Code, Code);
                if not PackagingMaterial.ISEMPTY then
                    ERROR(Text000);
            end;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(3; Abbreviation; Text[30])
        {
            Caption = 'Abbreviation';
        }
        field(4; "Type Code"; Code[10])
        {
            Caption = 'Type Code';
            NotBlank = true;
            TableRelation = "Packaging Material";
        }
    }

    keys
    {
        key(Key1; "Code", "Type Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Description, Abbreviation, "Type Code")
        {
        }
    }

    trigger OnDelete();
    var
        Text000: Label 'You cannot delete %1 %2 because there is at least one %3 that includes this packaging material.';
    begin
    end;
}

