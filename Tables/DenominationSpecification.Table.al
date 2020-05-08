table 46015652 "Denomination Specification"
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

    Caption = 'Denomination Specification';
    //DrillDownPageID = "Denomination Specification";

    fields
    {
        field(1; "Cash Desk Report No."; Code[20])
        {
            Caption = 'Cash Desk Report No.';
        }
        field(3; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(4; Denominator; Decimal)
        {
            Caption = 'Denominator';
            DecimalPlaces = 0 : 2;
        }
        field(5; Quantity; Integer)
        {
            Caption = 'Quantity';

            trigger OnValidate();
            begin
                Amount := Quantity * Denominator;
            end;
        }
        field(6; Amount; Decimal)
        {
            Caption = 'Amount';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Cash Desk Report No.", "Currency Code", Denominator)
        {
            SumIndexFields = Amount;
        }
    }

    fieldgroups
    {
    }
}

