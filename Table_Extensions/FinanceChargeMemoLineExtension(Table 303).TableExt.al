tableextension 46015550 "Fin. Ch. Memo Line Extension" extends "Finance Charge Memo Line"
{
    // version NAVW111.00,NAVE111.0.001

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
            BlankZero = true;
            CalcFormula = Sum ("Detailed Fin. Charge Memo Line"."Interest Amount" WHERE("Finance Charge Memo No." = FIELD("Finance Charge Memo No."),
                                                                                        "Fin. Charge. Memo Line No." = FIELD("Line No.")));
            Caption = 'Interests Amount';
            Description = 'NAVE111.0,001';
            Editable = false;
            FieldClass = FlowField;
        }
    }


    //Unsupported feature: CodeModification on "OnDelete". Please convert manually.

    //trigger OnDelete();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    FinChrgMemoLine.SETRANGE("Finance Charge Memo No.","Finance Charge Memo No.");
    FinChrgMemoLine.SETRANGE("Attached to Line No.","Line No.");
    FinChrgMemoLine.DELETEALL;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..3

    //NAVE111.0; 001; begin
    if LocalizationUsage.UseEastLocalization then begin
      DtldFinChargeMemoLine.SETRANGE("Finance Charge Memo No.","Finance Charge Memo No.");
      DtldFinChargeMemoLine.SETRANGE("Fin. Charge. Memo Line No.","Line No.");
      DtldFinChargeMemoLine.DELETEALL;
    end;
    //NAVE111.0; 001; end
    */
    //end;

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
        DtldFinChargeMemoLine: Record "Detailed Fin. Charge Memo Line";
        SalesSetup: Record "Sales & Receivables Setup";
        MultipleInterestRate: Record "Multiple Interest Rate";
        MultipleInterestCalcLine: Record "Multiple Interest Calc. Line";
        GLSetup: Record "General Ledger Setup";
        DtldLineNo: Integer;
        Text93000: Label 'There is no %1 for date %2 for code %3.';
}

