tableextension 46015567 "G/L Register Extension" extends "G/L Register"
{
    // version NAVW111.00.00.20783,DS11.00

    fields
    {
        field(46015805; "From Entry No. (Bal. Acc.)"; Integer)
        {
            Caption = 'From Entry No. (Bal. Acc.)';
            Description = 'DS11.00,001';
            TableRelation = "G/L Entry";
        }
        field(46015806; "To Entry No. (Bal. Acc.)"; Integer)
        {
            Caption = 'To Entry No. (Bal. Acc.)';
            Description = 'DS11.00,001';
            TableRelation = "G/L Entry";
        }
    }

}

