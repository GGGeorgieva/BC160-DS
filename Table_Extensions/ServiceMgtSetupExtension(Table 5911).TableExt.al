tableextension 46015597 "Service Mgt. Setup Extension" extends "Service Mgt. Setup"
{
    fields
    {
        field(46015609; "Default VAT Date"; Option)
        {
            Caption = 'Default VAT Date';
            Description = 'NAVE111.0,001';
            OptionCaption = 'Posting Date,Document Date,Blank';
            OptionMembers = "Posting Date","Document Date",Blank;
        }
        field(46015610; "Allow Alter Cust. Post. Groups"; Boolean)
        {
            Caption = 'Allow Alter Cust. Post. Groups';
            Description = 'NAVE111.0,001';
        }
        field(46015614; "Credit Memo Confirmation"; Boolean)
        {
            Caption = 'Credit Memo Confirmation';
            Description = 'NAVE111.0,001';

            trigger OnValidate();
            var
                GLSetup: Record "General Ledger Setup";
            begin
                GLSetup.GET;
                GLSetup.TESTFIELD("Use VAT Date");
            end;
        }
        field(46015630; "Posting Desc. Code"; Code[10])
        {
            Caption = 'Posting Desc. Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Posting Description" WHERE(Type = CONST("Service Document"));
        }
    }
}

