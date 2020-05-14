tableextension 46015530 "Vendor Ledger Entry Ext." extends "Vendor Ledger Entry"
{
    fields
    {
        field(46015610; "VAT Date"; Date)
        {
            Caption = 'VAT Date';
            Description = 'NAVE111.0,001';
            Editable = false;
        }
        field(46015615; Compensation; Boolean)
        {
            Caption = 'Compensation';
            Description = 'NAVE111.0,001';
        }
        field(46015700; "Unrealized VAT"; Boolean)
        {
            Caption = 'Unrealized VAT';
            Description = 'NAVBG11.0,001';
        }
    }
    keys
    {

        //TODO How extend keys??
        /*
        key(Key1;"Vendor No.","Currency Code","Vendor Posting Group","Document Type")
        {
        }
        key(Key2;"Document No.","Posting Date","Currency Code")
        {
        }
        key(Key3;"Vendor No.","Vendor Posting Group",Prepayment,"Posting Date")
        {
        }
        key(Key4;"Document Type","Document No.")
        {
        }
        */
    }

}

