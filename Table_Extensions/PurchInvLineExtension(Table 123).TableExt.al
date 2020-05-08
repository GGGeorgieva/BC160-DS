tableextension 46015516 "Purch. Inv. Line Extension" extends "Purch. Inv. Line"
{
    // version NAVW111.00.00.24742,NAVE111.0,NAVBG11.0

    fields
    {
        field(46015543; "Inbound Excise Destination"; Code[2])
        {
            Caption = 'Inbound Excise Destination';
            Description = 'NAVBG11.0,001';
            TableRelation = "Excise Destination";
        }
        field(46015549; "Additional Excise Code"; Text[13])
        {
            Caption = 'Additional Excise Code';
            Description = 'NAVBG11.0,001';
            Numeric = true;
        }
        field(46015607; "Tariff No."; Code[10])
        {
            Caption = 'Tariff No.';
            Description = 'NAVE111.0,001';
            TableRelation = "Tariff Number";
        }
        field(46015609; "Country/Region of Origin Code"; Code[10])
        {
            Caption = 'Country/Region of Origin Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Country/Region";
        }
        field(46015610; "VAT Date"; Date)
        {
            Caption = 'VAT Date';
            Description = 'NAVE111.0,001';
        }
        field(46015625; "SAD No."; Code[20])
        {
            Caption = 'SAD No.';
            Description = 'NAVE111.0,001';
            TableRelation = "Import SAD Header" WHERE("Vendor No." = FIELD("Buy-from Vendor No."));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
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
            AutoFormatExpression = GetCurrencyCode;
            Caption = 'VAT Base (Non Deductible)';
            Description = 'NAVE111.0,001';
            Editable = false;
        }
        field(46015637; "VAT Amount (Non Deductible)"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            Caption = 'VAT Amount (Non Deductible)';
            Description = 'NAVE111.0,001';
            Editable = false;
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


}

