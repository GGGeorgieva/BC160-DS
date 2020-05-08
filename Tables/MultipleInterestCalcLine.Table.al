table 46015637 "Multiple Interest Calc. Line"
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

    Caption = 'Multiple Interest Calc. Line';

    fields
    {
        field(1;Date;Date)
        {
            Caption = 'Date';
        }
        field(2;"Interest Rate";Decimal)
        {
            Caption = 'Interest Rate';
        }
        field(3;Days;Integer)
        {
            Caption = 'Days';
        }
        field(4;"Rate Factor";Decimal)
        {
            Caption = 'Rate Factor';
        }
    }

    keys
    {
        key(Key1;Date)
        {
        }
    }

    fieldgroups
    {
    }
}

