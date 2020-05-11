tableextension 46015569 "Invoice Post. Buffer Extension" extends "Invoice Post. Buffer"
{
    // version NAVW111.00.00.23019,NAVE111.0,NAVBG11.0

    //TODO
    //Procedure Update()

    fields
    {
        field(46015505; "Excise Amount"; Decimal)
        {
            Caption = 'Excise Amount';
            Description = 'NAVBG11.0,001';
        }
        field(46015506; "Excise Amount (ACY)"; Decimal)
        {
            Caption = 'Excise Amount (ACY)';
            Description = 'NAVBG11.0,001';
        }
        field(46015507; "Product Tax Amount"; Decimal)
        {
            Caption = 'Product Tax Amount';
            Description = 'NAVBG11.0,001';
        }
        field(46015508; "Product Tax Amount (ACY)"; Decimal)
        {
            Caption = 'Product Tax Amount (ACY)';
            Description = 'NAVBG11.0,001';
        }
        field(46015509; "Sales Excise Account"; Code[20])
        {
            Caption = 'Sales Excise Account';
            Description = 'NAVBG11.0,001';
            TableRelation = "G/L Account";
        }
        field(46015510; "Sales Product Tax Account"; Code[20])
        {
            Caption = 'Sales Product Tax Account';
            Description = 'NAVBG11.0,001';
            TableRelation = "G/L Account";
        }
        field(46015511; Product; Boolean)
        {
            Caption = 'Product';
            Description = 'NAVBG11.0,001';
        }
        field(46015610; "VAT Date"; Date)
        {
            Caption = 'VAT Date';
            Description = 'NAVE111.0,001';
        }
        field(46015615; Correction; Boolean)
        {
            Caption = 'Correction';
            Description = 'NAVE111.0,001';
        }
        field(46015620; "Prepayment Type"; Option)
        {
            Caption = 'Prepayment Type';
            Description = 'NAVE111.0,001';
            OptionCaption = '" ,Prepayment,Advance"';
            OptionMembers = " ",Prepayment,Advance;
        }
        field(46015635; "VAT % (Non Deductible)"; Decimal)
        {
            Caption = 'VAT % (Non Deductible)';
            Description = 'NAVE111.0,001';
            MaxValue = 100;
            MinValue = 0;
        }
        field(46015636; "VAT Base (Non Deductible)"; Decimal)
        {
            Caption = 'VAT Base (Non Deductible)';
            Description = 'NAVE111.0,001';
            Editable = false;
        }
        field(46015637; "VAT Amount (Non Deductible)"; Decimal)
        {
            Caption = 'VAT Amount (Non Deductible)';
            Description = 'NAVE111.0,001';
            Editable = false;
        }
    }
}

