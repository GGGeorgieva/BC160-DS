table 46015615 "Sales Invoice Line VAT Clause"
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

    Caption = 'Sales Invoice Line VAT Clause';

    fields
    {
        field(1;"Document No.";Code[20])
        {
            Caption = 'Document No.';
        }
        field(2;"Line No.";Integer)
        {
            Caption = 'Line No.';
        }
        field(3;"VAT Bus. Posting Group";Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
        }
        field(4;"VAT Prod. Posting Group";Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
        }
        field(9;Description;Text[50])
        {
            Caption = 'Description';
        }
        field(10;"VAT Base";Decimal)
        {
            Caption = 'VAT Base';
        }
        field(11;"VAT Amount";Decimal)
        {
            Caption = 'VAT Amount';
        }
    }

    keys
    {
        key(Key1;"Document No.","VAT Bus. Posting Group","VAT Prod. Posting Group","Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}

