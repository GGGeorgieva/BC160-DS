table 46015524 "Product Tax Month. Declaration"
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

    Caption = 'Product Tax Month. Declaration';

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
        field(4;"Specification Row No.";Integer)
        {
            Caption = 'Specification Row No.';
        }
        field(5;"Quantity of Packed Goods";Decimal)
        {
            Caption = 'Quantity of Packed Goods';
        }
        field(6;"Amount of the Product Tax";Decimal)
        {
            Caption = 'Amount of the Product Tax';
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

