table 46015525 "Product Tax Yearly Declaration"
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

    Caption = 'Product Tax Yearly Declaration';

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
        field(3;"Posting Date";Date)
        {
            Caption = 'Posting Date';
        }
        field(4;"Amount of the Product Tax";Decimal)
        {
            Caption = 'Amount of the Product Tax';
        }
        field(5;Plastic;Decimal)
        {
            Caption = 'Plastic';
        }
        field(6;"Paper and Cardboard";Decimal)
        {
            Caption = 'Paper and Cardboard';
        }
        field(7;Metals;Decimal)
        {
            Caption = 'Metals';
        }
        field(8;Aluminium;Decimal)
        {
            Caption = 'Aluminium';
        }
        field(9;Glass;Decimal)
        {
            Caption = 'Glass';
        }
        field(10;Wood;Decimal)
        {
            Caption = 'Wood';
        }
        field(11;Others;Decimal)
        {
            Caption = 'Others';
        }
    }

    keys
    {
        key(Key1;"Document No.","Line No.")
        {
        }
        key(Key2;"Posting Date")
        {
        }
    }

    fieldgroups
    {
    }
}

