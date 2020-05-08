tableextension 46015506 CurrencyExtension extends Currency
{
    // version NAVW111.00,NAVE111.0,NAVBG11.0

    fields
    {
        field(46015505; "Currency Gender"; Option)
        {
            Caption = 'Currency Gender';
            Description = 'NAVBG11.0,001';
            OptionCaption = 'Masculine,Feminine,Neutral';
            OptionMembers = Masculine,Feminine,Neutral;
        }
        field(46015605; "Customs Currency Code"; Code[10])
        {
            Caption = 'Customs Currency Code';
            Description = 'NAVE111.0';
            TableRelation = Currency;
        }
    }

    trigger OnBeforeDelete()
    begin

    end;
    //Unsupported feature: CodeModification on "OnDelete". Please convert manually.

    //trigger OnDelete();
    //begin

    //end;


    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CustLedgEntry.SETRANGE(Open,true);
    CustLedgEntry.SETRANGE("Currency Code",Code);
    if not CustLedgEntry.ISEMPTY then
      ERROR(Text002,CustLedgEntry.TABLECAPTION,TABLECAPTION,Code);

    VendLedgEntry.SETRANGE(Open,true);
    VendLedgEntry.SETRANGE("Currency Code",Code);
    if not VendLedgEntry.ISEMPTY then
      ERROR(Text002,VendLedgEntry.TABLECAPTION,TABLECAPTION,Code);

    CurrExchRate.SETRANGE("Currency Code",Code);
    CurrExchRate.DELETEALL;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    //NAVBG11.0; 001; begin
    if LocalizationUsage.UseBulgarianLocalization then
      if not CustLedgEntry.SETCURRENTKEY("Customer No.",Open,Positive,"Due Date","Currency Code") then
        CustLedgEntry.SETCURRENTKEY(Open,"Due Date");
    //NAVBG11.0; 001; end

    #1..5
    //NAVBG11.0; 001; begin
    if LocalizationUsage.UseBulgarianLocalization then
      if not VendLedgEntry.SETCURRENTKEY("Vendor No.",Open,Positive,"Due Date","Currency Code") then
        VendLedgEntry.SETCURRENTKEY(Open,"Due Date");
    //NAVBG11.0; 001; end

    #6..12
    */
    //end;

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.    

}

