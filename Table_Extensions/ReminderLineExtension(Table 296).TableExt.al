tableextension 46015545 tableextension46015545 extends "Reminder Line" 
{
    // version NAVW111.00.00.27667,NAVE111.0

    fields
    {
        field(46015625;Days;Integer)
        {
            Caption = 'Days';
            Description = 'NAVE111.0,001';
        }
        field(46015626;"Multiple Interest Rate";Decimal)
        {
            Caption = 'Multiple Interest Rate';
            Description = 'NAVE111.0,001';
        }
        field(46015627;"Interest Amount";Decimal)
        {
            BlankZero = true;
            CalcFormula = Sum("Detailed Reminder Line"."Interest Amount" WHERE ("Reminder No."=FIELD("Reminder No."),
                                                                                "Reminder Line No."=FIELD("Line No.")));
            Caption = 'Interest Amount';
            Description = 'NAVE111.0,001';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
        GLSetup : Record "General Ledger Setup";

    var
        DtldLineNo : Integer;
        MultipleInterestCalcLine : Record "Multiple Interest Calc. Line";
        DtldReminderLine : Record "Detailed Reminder Line";
        SalesSetup : Record "Sales & Receivables Setup";
        MultipleInterestRate : Record "Multiple Interest Rate";
        LocalizationUsage : Codeunit "Localization Usage";
        Text93000 : Label 'There is no %1 for date %2 for code %3.';
}

