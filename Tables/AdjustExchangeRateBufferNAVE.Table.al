table 46015551 "Adjust Exch. Rate Buffer NAVE"
{
    // version NAVW18.00.00.39663,NAVE18.00,NAVBG11.0.002

    // -----------------------------------------------------------------------------------------
    // Dynamic Solutions
    // MS Dynamics NAV 2017 Localisation
    // 
    // 
    // -----------------------------------------------------------------------------------------
    // No.   Sign     Date       Version        Description
    // -----------------------------------------------------------------------------------------
    // 001                                     List of changes :
    //                           NAVE18.00.001      Created from Table 331, version: NAVW18.00,NAVE18.00
    // ------------------------------------------------------------------------------------------
    // 
    // -----------------------------------------------------------------------------------------
    // Dynamic Solutions
    // MS Dynamics NAV 2017 Localisation
    // 
    // ggg : Galina G. Georgieva
    // -----------------------------------------------------------------------------------------
    // No.   Sign     Date       Version        Description
    // -----------------------------------------------------------------------------------------
    // 001     ggg    30.04.18                      List of changes :
    //                           NAVBG11.0.002      Added field : 46015607 - Correction
    // ------------------------------------------------------------------------------------------

    Caption = 'Adjust Exchange Rate Buffer NAVE';

    fields
    {
        field(1;"Currency Code";Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(2;"Posting Group";Code[10])
        {
            Caption = 'Posting Group';
        }
        field(3;AdjBase;Decimal)
        {
            AutoFormatType = 1;
            Caption = 'AdjBase';
        }
        field(4;AdjBaseLCY;Decimal)
        {
            AutoFormatType = 1;
            Caption = 'AdjBaseLCY';
        }
        field(5;AdjAmount;Decimal)
        {
            AutoFormatType = 1;
            Caption = 'AdjAmount';
        }
        field(6;TotalGainsAmount;Decimal)
        {
            AutoFormatType = 1;
            Caption = 'TotalGainsAmount';
        }
        field(7;TotalLossesAmount;Decimal)
        {
            AutoFormatType = 1;
            Caption = 'TotalLossesAmount';
        }
        field(8;"Dimension Entry No.";Integer)
        {
            Caption = 'Dimension Entry No.';
        }
        field(9;"Posting Date";Date)
        {
            Caption = 'Posting Date';
        }
        field(10;"IC Partner Code";Code[20])
        {
            Caption = 'IC Partner Code';
        }
        field(11;Index;Integer)
        {
            Caption = 'Index';
        }
        field(46015605;"Entry No.";Integer)
        {
            Caption = 'Entry No.';
            Description = 'NAVE18.00,001';
        }
        field(46015607;Correction;Boolean)
        {
            Description = 'NAVBG11.0.002';
        }
    }

    keys
    {
        key(Key1;"Currency Code","Posting Group","Dimension Entry No.","Posting Date","IC Partner Code","Entry No.")
        {
        }
    }

    fieldgroups
    {
    }
}

