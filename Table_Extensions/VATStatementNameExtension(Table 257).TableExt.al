tableextension 46015543 "VAT Statement Name Extension" extends "VAT Statement Name"
{
    fields
    {
        field(46015605; "Date Row Filter"; Date)
        {
            Caption = 'Date Row Filter';
            Description = 'NAVE111.0,001';
            FieldClass = FlowFilter;
        }
    }
}

