table 46015612 "Non Deductible VAT Setup"
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

    Caption = 'Non Deductible VAT Setup';

    fields
    {
        field(1;"VAT Bus. Posting Group";Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(2;"VAT Prod. Posting Group";Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(3;"From Date";Date)
        {
            Caption = 'From Date';
        }
        field(4;"Non Deductible VAT %";Decimal)
        {
            Caption = 'Non Deductible VAT %';
            DecimalPlaces = 0:5;
            MaxValue = 100;
            MinValue = 0;
        }
    }

    keys
    {
        key(Key1;"VAT Bus. Posting Group","VAT Prod. Posting Group","From Date")
        {
        }
    }

    fieldgroups
    {
    }
}

