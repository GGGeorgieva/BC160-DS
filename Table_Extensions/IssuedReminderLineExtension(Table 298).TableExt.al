tableextension 46015546 "Issued Reminder Line Ext." extends "Issued Reminder Line"
{
    // version NAVW111.00,NAVE111.0

    fields
    {
        field(46015625; Days; Integer)
        {
            Caption = 'Days';
            Description = 'NAVE111.0,001';
        }
        field(46015626; "Multiple Interest Rate"; Decimal)
        {
            Caption = 'Multiple Interest Rate';
            Description = 'NAVE111.0,001';
        }
        field(46015627; "Interest Amount"; Decimal)
        {
            CalcFormula = Sum ("Detailed Issued Reminder Line"."Interest Amount" WHERE("Issued Reminder No." = FIELD("Reminder No."),
                                                                                       "Issued Reminder Line No." = FIELD("Line No.")));
            Caption = 'Interest Amount';
            Description = 'NAVE111.0,001';
            FieldClass = FlowField;
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.

}

