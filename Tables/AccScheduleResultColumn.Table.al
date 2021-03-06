table 46015682 "Acc. Schedule Result Column"
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

    Caption = 'Acc. Schedule Result Column';

    fields
    {
        field(1;"Result Code";Code[20])
        {
            Caption = 'Result Code';
            TableRelation = "Acc. Schedule Result Header";
        }
        field(2;"Line No.";Integer)
        {
            Caption = 'Line No.';
        }
        field(3;"Column No.";Code[10])
        {
            Caption = 'Column No.';
        }
        field(4;"Column Header";Text[50])
        {
            Caption = 'Column Header';
        }
        field(5;"Column Type";Option)
        {
            Caption = 'Column Type';
            InitValue = "Net Change";
            OptionCaption = 'Formula,Net Change,Balance at Date,Beginning Balance,Year to Date,Rest of Fiscal Year,Entire Fiscal Year';
            OptionMembers = Formula,"Net Change","Balance at Date","Beginning Balance","Year to Date","Rest of Fiscal Year","Entire Fiscal Year";
        }
        field(6;"Ledger Entry Type";Option)
        {
            Caption = 'Ledger Entry Type';
            OptionCaption = 'G/L Entries,G/L Budget Entries';
            OptionMembers = "G/L Entries","G/L Budget Entries";
        }
        field(7;"Amount Type";Option)
        {
            Caption = 'Amount Type';
            OptionCaption = 'Net Amount,Debit Amount,Credit Amount';
            OptionMembers = "Net Amount","Debit Amount","Credit Amount";
        }
        field(8;Formula;Code[80])
        {
            Caption = 'Formula';
        }
        field(9;"Comparison Date Formula";DateFormula)
        {
            Caption = 'Comparison Date Formula';
        }
        field(10;"Show Opposite Sign";Boolean)
        {
            Caption = 'Show Opposite Sign';
        }
        field(11;Show;Option)
        {
            Caption = 'Show';
            InitValue = Always;
            NotBlank = true;
            OptionCaption = 'Always,Never,When Positive,When Negative';
            OptionMembers = Always,Never,"When Positive","When Negative";
        }
        field(12;"Rounding Factor";Option)
        {
            Caption = 'Rounding Factor';
            OptionCaption = 'None,1,1000,1000000';
            OptionMembers = "None","1","1000","1000000";
        }
        field(14;"Comparison Period Formula";Code[20])
        {
            Caption = 'Comparison Period Formula';
        }
    }

    keys
    {
        key(Key1;"Result Code","Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}

