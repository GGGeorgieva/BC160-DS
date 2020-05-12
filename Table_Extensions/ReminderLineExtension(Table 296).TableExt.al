tableextension 46015545 "Reminder Line Extension" extends "Reminder Line"
{
    // version NAVW111.00.00.27667,NAVE111.0
    //TODO: PROCEDURE CalcFinChrg

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
            BlankZero = true;
            CalcFormula = Sum ("Detailed Reminder Line"."Interest Amount" WHERE("Reminder No." = FIELD("Reminder No."),
                                                                                "Reminder Line No." = FIELD("Line No.")));
            Caption = 'Interest Amount';
            Description = 'NAVE111.0,001';
            Editable = false;
            FieldClass = FlowField;
        }
    }
    var
        GLSetup: Record "General Ledger Setup";
        DtldLineNo: Integer;
        MultipleInterestCalcLine: Record "Multiple Interest Calc. Line";
        DtldReminderLine: Record "Detailed Reminder Line";
        SalesSetup: Record "Sales & Receivables Setup";
        MultipleInterestRate: Record "Multiple Interest Rate";
        Text93000: Label 'There is no %1 for date %2 for code %3.';

    procedure SetRatesForCalc(PayDate: Date; ClosingDate: Date; FinChrgTerms: Record "Finance Charge Terms");
    var
        StartDate: Date;
        InterestRate: Decimal;
        CreateRate: Boolean;
        RateFactor: Decimal;
    begin
        SalesSetup.GET;
        if SalesSetup."Multiple Interest Rates" then begin
            MultipleInterestRate.SETRANGE("Finance Charge Code", FinChrgTerms.Code);
            MultipleInterestRate.SETRANGE("Valid from Date", 0D, CALCDATE('<1D>', PayDate));
            if not MultipleInterestRate.FIND('+') then
                ERROR(Text93000, MultipleInterestRate.FIELDCAPTION("Interest Rate"), CALCDATE('<1D>', PayDate),
                  FinChrgTerms.Code);
            StartDate := CALCDATE('<1D>', PayDate);
            MultipleInterestRate.TESTFIELD("Interest Rate");
            InterestRate := MultipleInterestRate."Interest Rate";
            RateFactor := 100 * MultipleInterestRate."Interest Period (Days)";
            if StartDate <= ClosingDate then begin
                CreateRate := true;
                MultipleInterestRate.SETRANGE("Valid from Date", CALCDATE('<2D>', PayDate), ClosingDate);
                if MultipleInterestRate.FIND('-') then begin
                    repeat
                        if MultipleInterestRate."Valid from Date" < ClosingDate then begin
                            InsertMultInterestCalcRate(MultipleInterestCalcLine, StartDate, InterestRate,
                            MultipleInterestRate."Valid from Date" - StartDate, RateFactor);

                            StartDate := MultipleInterestRate."Valid from Date";
                            MultipleInterestRate.TESTFIELD("Interest Rate");
                            InterestRate := MultipleInterestRate."Interest Rate";
                        end else begin
                            InsertMultInterestCalcRate(MultipleInterestCalcLine, StartDate, InterestRate,
                            (ClosingDate - StartDate) + 1, RateFactor);

                            CreateRate := false;
                            exit;
                        end;
                    until MultipleInterestRate.NEXT = 0;
                end;
                if CreateRate then
                    InsertMultInterestCalcRate(MultipleInterestCalcLine, StartDate, InterestRate,
                    (ClosingDate - StartDate) + 1, RateFactor);
            end else
                InsertMultInterestCalcRate(MultipleInterestCalcLine, StartDate, InterestRate, 0, RateFactor);
        end else
            InsertMultInterestCalcRate(MultipleInterestCalcLine, PayDate, FinChrgTerms."Interest Rate",
              ClosingDate - PayDate, 100 * FinChrgTerms."Interest Period (Days)");
    end;

    procedure InsertMultInterestCalcRate(VAR MultipleInterestCalcLine: Record "Multiple Interest Calc. Line"; LineDate: Date; LineRate: Decimal; LineDays: Decimal; LineRateFactor: Decimal);
    begin
        with MultipleInterestCalcLine do begin
            Date := LineDate;
            "Interest Rate" := LineRate;
            Days := LineDays;
            "Rate Factor" := LineRateFactor;
            INSERT;
        end;
    end;
}

