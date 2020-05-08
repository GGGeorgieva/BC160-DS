tableextension 46015571 tableextension46015571 extends "Finance Charge Terms" 
{
    // version NAVW19.00,NAVW17.00,NAVE111.0

    fields
    {
        field(46015625;"Grace Tax Period";DateFormula)
        {
            Caption = 'Grace Tax Period';
            Description = 'NAVE111.0,001';
        }
    }


    //Unsupported feature: CodeModification on "OnDelete". Please convert manually.

    //trigger OnDelete();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        FinChrgText.SETRANGE("Fin. Charge Terms Code",Code);
        FinChrgText.DELETEALL;

        CurrForFinChrgTerms.SETRANGE("Fin. Charge Terms Code",Code);
        CurrForFinChrgTerms.DELETEALL;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..5

        //NAVE111.0; 001; begin
        if LocalizationUsage.UseEastLocalization then begin
          MultipleInterestRate.SETRANGE("Finance Charge Code",Code);
          MultipleInterestRate.DELETEALL;
        end;
        //NAVE111.0; 001; end
        */
    //end;

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
        MultipleInterestRate : Record "Multiple Interest Rate";
        LocalizationUsage : Codeunit "Localization Usage";
}

