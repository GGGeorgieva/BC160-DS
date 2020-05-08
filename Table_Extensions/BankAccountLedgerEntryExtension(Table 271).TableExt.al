tableextension 46015538 "Bank Acc. Ledg. Entry Ext" extends "Bank Account Ledger Entry"
{
    // version NAVW111.00.00.20783,NAVE110.0

    fields
    {
        field(46015645; "Cash Order Type"; Option)
        {
            Caption = 'Cash Order Type';
            Description = 'NAVE110.0,001';
            OptionCaption = '" ,Receipt,Withdrawal"';
            OptionMembers = " ",Receipt,Withdrawal;
        }
        field(46015646; "Cash Desk Report No."; Code[20])
        {
            Caption = 'Cash Desk Report No.';
            Description = 'NAVE110.0,001';
        }
    }
}

