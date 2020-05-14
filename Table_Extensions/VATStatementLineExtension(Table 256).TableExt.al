tableextension 46015533 "VAT Statement Line Extension" extends "VAT Statement Line"
{
    fields
    {
        field(46015605; "G/L Amount Type"; Option)
        {
            Caption = 'G/L Amount Type';
            Description = 'NAVE111.0,001';
            OptionCaption = 'Net Change,Debit,Credit';
            OptionMembers = "Net Change",Debit,Credit;
        }
        field(46015606; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            Description = 'NAVE111.0,001';
            TableRelation = "Gen. Business Posting Group";
        }
        field(46015607; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            Description = 'NAVE111.0,001';
            TableRelation = "Gen. Product Posting Group";
        }
        field(46015608; "EU-3 Party Trade"; Option)
        {
            Caption = 'EU-3 Party Trade';
            Description = 'NAVE111.0,001';
            OptionCaption = '" ,Yes,No"';
            OptionMembers = " ",Yes,No;
        }
        field(46015609; "Use Row Date Filter"; Boolean)
        {
            Caption = 'Use Row Date Filter';
            Description = 'NAVE111.0,001';
        }
        field(46015610; "Date Row Filter"; Date)
        {
            Caption = 'Date Row Filter';
            Description = 'NAVE111.0,001';
            FieldClass = FlowFilter;
        }
        field(46015611; Show; Option)
        {
            Caption = 'Show';
            Description = 'NAVE111.0,001';
            OptionCaption = '" ,Zero If Negative,Zero If Positive"';
            OptionMembers = " ","Zero If Negative","Zero If Positive";
        }
        field(46015612; "EU 3-Party Intermediate Role"; Option)
        {
            Caption = 'EU 3-Party Intermediate Role';
            Description = 'NAVE111.0,001';
            OptionCaption = '" ,Yes,No"';
            OptionMembers = " ",Yes,No;
        }
    }
}

