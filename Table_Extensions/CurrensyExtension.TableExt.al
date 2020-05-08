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
}

