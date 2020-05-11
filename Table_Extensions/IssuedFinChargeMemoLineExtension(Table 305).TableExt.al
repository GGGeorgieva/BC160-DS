tableextension 46015551 "IssuedFinChMemoLineExtension" extends "Issued Fin. Charge Memo Line"
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
        field(46015627; "Interests Amount"; Decimal)
        {
            CalcFormula = Sum ("Detailed Iss.Fin.Ch. Memo Line"."Interest Amount" WHERE("Finance Charge Memo No." = FIELD("Finance Charge Memo No."),
                                                                                        "Fin. Charge. Memo Line No." = FIELD("Line No.")));
            Caption = 'Interests Amount';
            Description = 'NAVE111.0,001';
            FieldClass = FlowField;
        }
        field(46015628; "Tax Amount"; Decimal)
        {
            Caption = 'Tax Amount';
            Description = 'NAVE111.0,001';
        }
        field(46015629; "Tax Days"; Integer)
        {
            Caption = 'Tax Days';
            Description = 'NAVE111.0,001';
        }
    }
}

