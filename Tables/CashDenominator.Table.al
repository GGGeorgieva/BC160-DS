table 46015651 "Cash Denominator"
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

    Caption = 'Cash Denominator';

    fields
    {
        field(1;"Currency Code";Code[20])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(2;Value;Decimal)
        {
            Caption = 'Value';
            DecimalPlaces = 0:2;
        }
    }

    keys
    {
        key(Key1;"Currency Code",Value)
        {
        }
    }

    fieldgroups
    {
    }
}

