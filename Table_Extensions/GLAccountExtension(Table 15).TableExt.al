tableextension 46015520 "G/L Account Extension" extends "G/L Account"
{
    // version NAVW111.00,NAVBG11.0,DS11.00

    //TODO
    //CalcFormula on fileds

    fields
    {

        //Unsupported feature: Change CalcFormula on ""Balance at Date"(Field 31)". Please convert manually.


        //Unsupported feature: Change Description on ""Balance at Date"(Field 31)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Net Change"(Field 32)". Please convert manually.


        //Unsupported feature: Change Description on ""Net Change"(Field 32)". Please convert manually.


        //Unsupported feature: Change CalcFormula on "Balance(Field 36)". Please convert manually.


        //Unsupported feature: Change Description on "Balance(Field 36)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Debit Amount"(Field 47)". Please convert manually.


        //Unsupported feature: Change Description on ""Debit Amount"(Field 47)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Credit Amount"(Field 48)". Please convert manually.


        //Unsupported feature: Change Description on ""Credit Amount"(Field 48)". Please convert manually.

        field(46015506; "Balance Account Type"; Option)
        {
            Caption = 'Balance Account Type';
            Description = 'NAVBG11.00,001';
            OptionCaption = 'Balance,Off-balance';
            OptionMembers = Balance,"Off-balance";
        }
        field(46015616; "Net Change (VAT Date)"; Decimal)
        {
            CalcFormula = Sum ("G/L Entry".Amount WHERE("G/L Account No." = FIELD("No."),
                                                        "G/L Account No." = FIELD(FILTER(Totaling)),
                                                        "Business Unit Code" = FIELD("Business Unit Filter"),
                                                        "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                        "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                        "VAT Date" = FIELD("Date Filter")));
            Caption = 'Net Change (VAT Date)';
            Description = 'NAVE111.00,001';
            Editable = false;
            FieldClass = FlowField;
        }
        field(46015617; "Net Change ACY (VAT Date)"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            CalcFormula = Sum ("G/L Entry"."Additional-Currency Amount" WHERE("G/L Account No." = FIELD("No."),
                                                                              "G/L Account No." = FIELD(FILTER(Totaling)),
                                                                              "Business Unit Code" = FIELD("Business Unit Filter"),
                                                                              "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                              "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                              "VAT Date" = FIELD("Date Filter")));
            Caption = 'Net Change ACY (VAT Date)';
            Description = 'NAVE111.00,001';
            Editable = false;
            FieldClass = FlowField;
        }
        field(46015618; "Debit Amount (VAT Date)"; Decimal)
        {
            CalcFormula = Sum ("G/L Entry"."Debit Amount" WHERE("G/L Account No." = FIELD("No."),
                                                                "G/L Account No." = FIELD(FILTER(Totaling)),
                                                                "Business Unit Code" = FIELD("Business Unit Filter"),
                                                                "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                "VAT Date" = FIELD("Date Filter")));
            Caption = 'Debit Amount (VAT Date)';
            Description = 'NAVE111.00,001';
            Editable = false;
            FieldClass = FlowField;
        }
        field(46015619; "Debit Amount ACY (VAT Date)"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            CalcFormula = Sum ("G/L Entry"."Add.-Currency Debit Amount" WHERE("G/L Account No." = FIELD("No."),
                                                                              "G/L Account No." = FIELD(FILTER(Totaling)),
                                                                              "Business Unit Code" = FIELD("Business Unit Filter"),
                                                                              "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                              "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                              "VAT Date" = FIELD("Date Filter")));
            Caption = 'Debit Amount ACY (VAT Date)';
            Description = 'NAVE111.00,001';
            Editable = false;
            FieldClass = FlowField;
        }
        field(46015620; "Credit Amount (VAT Date)"; Decimal)
        {
            CalcFormula = Sum ("G/L Entry"."Credit Amount" WHERE("G/L Account No." = FIELD("No."),
                                                                 "G/L Account No." = FIELD(FILTER(Totaling)),
                                                                 "Business Unit Code" = FIELD("Business Unit Filter"),
                                                                 "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                 "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                 "VAT Date" = FIELD("Date Filter")));
            Caption = 'Credit Amount (VAT Date)';
            Description = 'NAVE111.00,001';
            Editable = false;
            FieldClass = FlowField;
        }
        field(46015621; "Credit Amount ACY (VAT Date)"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            CalcFormula = Sum ("G/L Entry"."Add.-Currency Debit Amount" WHERE("G/L Account No." = FIELD("No."),
                                                                              "G/L Account No." = FIELD(FILTER(Totaling)),
                                                                              "Business Unit Code" = FIELD("Business Unit Filter"),
                                                                              "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                              "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                              "VAT Date" = FIELD("Date Filter")));
            Caption = 'Credit Amount ACY (VAT Date)';
            Description = 'NAVE111.00,001';
            Editable = false;
            FieldClass = FlowField;
        }
        field(46015805; "Off Balance"; Boolean)
        {
            Caption = 'Off Balance';
            Description = 'DS11.00,001';
        }
        field(46015806; "Document Filter"; Code[20])
        {
            Caption = 'Document Filter';
            Description = 'DS11.00,001';
            FieldClass = FlowFilter;
        }
    }
    keys
    {
        key(Key1; "Balance Account Type")
        {
        }
    }
    var
        Text46012225: Label '%1 must be 0 at posting on %2 %3';
}

