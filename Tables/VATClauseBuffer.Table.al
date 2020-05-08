table 46015616 "VAT Clause Buffer"
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

    Caption = 'VAT Clause Buffer';

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
        field(4;"VAT Base";Decimal)
        {
            BlankZero = true;
            Caption = 'VAT Base';
            InitValue = 0;
        }
        field(5;"VAT Amount";Decimal)
        {
            Caption = 'VAT Amount';
        }
    }

    keys
    {
        key(Key1;"VAT Bus. Posting Group","VAT Prod. Posting Group")
        {
        }
    }

    fieldgroups
    {
    }
}

