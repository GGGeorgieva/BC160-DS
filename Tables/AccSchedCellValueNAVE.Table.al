table 46015550 "Acc. Sched. Cell Value NAVE"
{
    // version NAVE18.00.001

    // -----------------------------------------------------------------------------------------
    // Dynamic Solutions
    // MS Dynamics NAV 2017 Localisation
    // 
    // 
    // -----------------------------------------------------------------------------------------
    // No.   Sign     Date       Version        Description
    // -----------------------------------------------------------------------------------------
    // 001                                     List of changes :
    //                           NAVE18.00.001      Created from Table 342, version: NAVW17.00,NAVE18.00
    // ------------------------------------------------------------------------------------------

    Caption = 'Acc. Sched. Cell Value NAVE';

    fields
    {
        field(1;"Row No.";Integer)
        {
            Caption = 'Row No.';
        }
        field(2;"Column No.";Integer)
        {
            Caption = 'Column No.';
        }
        field(3;Value;Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Value';
        }
        field(4;"Has Error";Boolean)
        {
            Caption = 'Has Error';
        }
        field(5;"Period Error";Boolean)
        {
            Caption = 'Period Error';
        }
        field(6;"Schedule Name";Code[10])
        {
            Caption = 'Schedule Name';
            TableRelation = "Acc. Schedule Name";
        }
    }

    keys
    {
        key(Key1;"Schedule Name","Row No.","Column No.")
        {
        }
    }

    fieldgroups
    {
    }
}

