table 46015521 "Packaging Material Type"
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

    Caption = 'Packaging Material Type';
    //ookupPageID = "Packaging Material Types";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Name; Option)
        {
            Caption = 'Name';
            OptionCaption = '" ,Plastic,Paper and Cardboard,Metals,Aluminium,Glass,Wood,Others"';
            OptionMembers = " ",Plastic,"Paper and Cardboard",Metals,Aluminium,Glass,Wood,Others;
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(4; "Tax amount per Kg"; Decimal)
        {
            Caption = 'Tax amount per Kg';
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
        fieldgroup(DropDown; "Code", Name, Description, "Tax amount per Kg")
        {
        }
    }

    trigger OnDelete();
    var
        ItemPackagingSpecification: Record "Item Packaging Specification";
        PackagingMaterial: Record "Packaging Material";
        Text000: Label 'You cannot delete %1 %2 because there is at least one %3 that includes this packaging material type.';
    begin
        ItemPackagingSpecification.SETRANGE("Packaging Material Type Code", Code);
        if ItemPackagingSpecification.FIND('-') then
            ERROR(Text000, TABLECAPTION, Code, ItemPackagingSpecification.TABLECAPTION);

        PackagingMaterial.SETRANGE("Type Code", Code);
        PackagingMaterial.DELETEALL;
    end;
}

