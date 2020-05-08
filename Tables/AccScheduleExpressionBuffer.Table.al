table 46015683 "Acc. Sched. Expression Buffer"
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

    Caption = 'Acc. Sched. Expression Buffer';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; Expression; Text[250])
        {
            Caption = 'Expression';
        }
        field(3; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(4; "Acc. Sched. Row No."; Code[20])
        {
            Caption = 'Acc. Sched. Row No.';
        }
        field(5; "Totaling Type"; Option)
        {
            Caption = 'Totaling Type';
            OptionCaption = 'Posting Accounts,Total Accounts,Formula,Constant,,Set Base For Percent,Custom';
            OptionMembers = "Posting Accounts","Total Accounts",Formula,Constant,,"Set Base For Percent",Custom;
        }
        field(6; "Dimension 1 Totaling"; Text[80])
        {
            Caption = 'Dimension 1 Totaling';
            //This property is currently not supported
            //TestTableRelation = false;
            //ValidateTableRelation = false;
        }
        field(7; "Dimension 2 Totaling"; Text[80])
        {
            Caption = 'Dimension 2 Totaling';
            //This property is currently not supported
            //TestTableRelation = false;
            //ValidateTableRelation = false;
        }
        field(8; "Dimension 3 Totaling"; Text[80])
        {
            Caption = 'Dimension 3 Totaling';
            //This property is currently not supported
            //TestTableRelation = false;
            //ValidateTableRelation = false;
        }
        field(9; "Dimension 4 Totaling"; Text[80])
        {
            Caption = 'Dimension 4 Totaling';
            //This property is currently not supported
            //TestTableRelation = false;
            //ValidateTableRelation = false;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }
}

