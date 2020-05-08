tableextension 46015611 tableextension46015611 extends "Vendor Posting Group" 
{
    // version NAVW111.00.00.24742,NAVE111.0


    //Unsupported feature: CodeModification on "OnDelete". Please convert manually.

    //trigger OnDelete();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        CheckGroupUsage;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        CheckGroupUsage;
        //NAVE111.0; 001; single
        if LocalizationUsage.UseEastLocalization then
          DeleteSubstPostingGroups;
        */
    //end;

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
        LocalizationUsage : Codeunit "Localization Usage";
}

