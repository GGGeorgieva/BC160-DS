tableextension 46015544 "VAT Amount Line Extension" extends "VAT Amount Line"
{
    fields
    {
        field(46015505; "Amount Incl. Taxes Excl. VAT"; Decimal)
        {
            Caption = 'Amount Incl. Taxes Excl. VAT';
            Description = 'NAVBG11.0,001';
        }
        field(46015506; "Excise Amount"; Decimal)
        {
            Caption = 'Excise Amount';
            Description = 'NAVBG11.0,001';
        }
        field(46015507; "Product Tax Amount"; Decimal)
        {
            Caption = 'Product Tax Amount';
            Description = 'NAVBG11.0,001';
        }
        field(46015508; "Amount Excl. Taxes"; Decimal)
        {
            Caption = 'Amount Excl. Taxes';
            Description = 'NAVBG11.0,001';
        }
        field(46015635; "VAT % (Non Deductible)"; Decimal)
        {
            Caption = 'VAT % (Non Deductible)';
            Description = 'NAVE111.0,001';
            Editable = false;
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
    PROCEDURE GetTotalAmountExclTaxes(): Decimal;
    VAR
        AmountExclTaxes: Decimal;
    BEGIN
        //NAVE111.0; 001; entire function
        AmountExclTaxes := 0;

        if FIND('-') then
            repeat
                AmountExclTaxes := AmountExclTaxes + "Amount Excl. Taxes";
            until NEXT = 0;
        exit(AmountExclTaxes);
    END;

}

