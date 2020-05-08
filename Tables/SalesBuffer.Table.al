table 46015512 "Sales Buffer"
{
    // version NAVBG8.00

    // -----------------------------------------------------------------------------------------
    // XAPT Solutions
    // MS Dynamics NAV 2015 Localisation
    // 
    // mp  : Mile Petachki
    // version : NAVBG8.00
    // 
    // -----------------------------------------------------------------------------------------
    // No.   Sign     Date       Version        Description
    // -----------------------------------------------------------------------------------------
    // 001   mp       27.10.14   NAVBG8.00      Created table from MS Dynamics NAV 6.00
    // ------------------------------------------------------------------------------------------

    Caption = 'Sales Buffer';

    fields
    {
        field(1;"Code";Code[20])
        {
            Caption = 'Code';
        }
        field(2;"Amount 1";Decimal)
        {
            Caption = 'Amount 1';
        }
        field(3;"Amount 2";Decimal)
        {
            Caption = 'Amount 2';
        }
        field(4;"Amount 3";Decimal)
        {
            Caption = 'Amount 3';
        }
        field(10;"VAT Registration No.";Code[20])
        {
            Caption = 'VAT Registration No.';
        }
        field(11;Date;Date)
        {
            Caption = 'Date';
        }
    }

    keys
    {
        key(Key1;"Code")
        {
        }
    }

    fieldgroups
    {
    }

    procedure IsBufferEmpty() : Boolean;
    begin
        exit(("Amount 1" = 0) and ("Amount 2" = 0) and ("Amount 3" = 0));
    end;
}

