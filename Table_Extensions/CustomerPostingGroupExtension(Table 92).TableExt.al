tableextension 46015610 "Cust. Post. Group Extension" extends "Customer Posting Group"
{
    // version NAVW111.00.00.24742,NAVE111.0


    //Unsupported feature: CodeModification on "OnDelete". Please convert manually.

    //trigger OnDelete();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CheckCustEntries;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    CheckCustEntries;
    //NAVE111.0; 001; begin
    if LocalizationUsage.UseEastLocalization then
      DeleteSubstPostingGroups;
    //NAVE111.0; 001; end
    */
    //end;

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


}

