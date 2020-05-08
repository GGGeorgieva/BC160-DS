table 46015614 "Multiple Interest Rate"
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

    Caption = 'Multiple Interest Rate';
    //LookupPageID = "Multiple Interest Rates";

    fields
    {
        field(1; "Finance Charge Code"; Code[10])
        {
            Caption = 'Finance Charge Code';
            TableRelation = "Finance Charge Terms".Code;
        }
        field(2; "Valid from Date"; Date)
        {
            Caption = 'Valid from Date';
        }
        field(3; "Interest Rate"; Decimal)
        {
            Caption = 'Interest Rate';
            MaxValue = 100;
            MinValue = 0;
        }
        field(5; "Interest Period (Days)"; Integer)
        {
            Caption = 'Interest Period (Days)';
        }
    }

    keys
    {
        key(Key1; "Finance Charge Code", "Valid from Date")
        {
        }
    }

    fieldgroups
    {
    }
}

