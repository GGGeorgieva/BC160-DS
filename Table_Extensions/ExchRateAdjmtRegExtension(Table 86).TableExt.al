tableextension 46015606 "Exch. Rate Adjmt. Reg. Ext." extends "Exch. Rate Adjmt. Reg."
{
    // version NAVW111.00,DS11.00

    fields
    {
        field(46015805; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            Description = 'DS11.00,001';
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account";
        }
    }
}

