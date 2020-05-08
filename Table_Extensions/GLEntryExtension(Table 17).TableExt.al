tableextension 46015523 tableextension46015523 extends "G/L Entry" 
{
    // version NAVW111.00.00.26401,NAVBG11.0,DS11.00

    fields
    {
        field(46015605;"VAT Date";Date)
        {
            Caption = 'VAT Date';
            Description = 'NAVE111.0,001';
            Editable = false;
        }
        field(46015606;"SAD No.";Code[20])
        {
            Caption = 'SAD No.';
            Description = 'NAVE111.0,001';
            Editable = false;
            TableRelation = IF ("Source Type"=CONST(Customer)) "Export SAD Header" WHERE ("Customer No."=FIELD("Source No."))
                            ELSE IF ("Source Type"=CONST(Vendor)) "Import SAD Header" WHERE ("Vendor No."=FIELD("Source No."));
        }
        field(46015805;"Balance G/L Account";Code[20])
        {
            Caption = 'Balance G/L Account';
            Description = 'DS11.00,001';
            TableRelation = "G/L Account";
        }
        field(46015806;"Single Entry";Boolean)
        {
            Caption = 'Single Entry';
            Description = 'DS11.00,001';
            InitValue = false;
        }
        field(46015807;"Balance Entry No.";Integer)
        {
            Caption = 'Balance Entry No.';
            Description = 'DS11.00,001';
        }
        field(46015808;"Balance Entry";Boolean)
        {
            Caption = 'Balance Entry';
            Description = 'DS11.00,001';
        }
        field(46015809;"Group Entry";Boolean)
        {
            Caption = 'Group Entry';
            Description = 'DS11.00,001';
        }
        field(46015810;"Debit/Credit Type";Option)
        {
            Caption = 'Debit/Credit Type';
            Description = 'DS11.00,001';
            OptionMembers = " ",Debit,Credit;
        }
        field(46015811;Correction;Boolean)
        {
            Caption = 'Correction';
            Description = 'DS11.00,001';
        }
    }
    keys
    {
        key(Key1;"G/L Account No.","Business Unit Code","Global Dimension 1 Code","Global Dimension 2 Code","Posting Date","VAT Date")
        {
        }
        key(Key2;"G/L Account No.","VAT Date")
        {
        }
        key(Key3;"Posting Date")
        {
        }
        key(Key4;"Document No.","Posting Date","G/L Account No.")
        {
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
        Vendor : Record Vendor;
        Customer : Record Customer;
}

