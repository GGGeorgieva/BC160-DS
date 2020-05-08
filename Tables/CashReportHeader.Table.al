table 46015649 "Cash Report Header"
{
    // version NAVE18.00

    // -----------------------------------------------------------------------------------------
    // XAPT Solutions
    // MS Dynamics NAV 2015 Localisation
    // 
    // mp  : Mile Petachki
    // version : NAVE18.00
    // 
    // -----------------------------------------------------------------------------------------
    // No.   Sign     Date       Version        Description
    // -----------------------------------------------------------------------------------------
    // 001   mp       27.10.14   NAVE18.00      Created table from MS Dynamics NAV 6.00
    // ------------------------------------------------------------------------------------------

    Caption = 'Cash Report Header';
    DataCaptionFields = "Cash Desk No.", "No.", "Opening Date";
    //LookupPageID = "Cash Reports";

    fields
    {
        field(1; "Cash Desk No."; Code[20])
        {
            Caption = 'Cash Desk No.';

            trigger OnLookup();
            var
                BankAccount: Record "Bank Account";
            begin

                BankAccount."No." := "Cash Desk No.";
                if PAGE.RUNMODAL(PAGE::Page46012248, BankAccount, BankAccount."No.") = ACTION::LookupOK then
                    "Cash Desk No." := BankAccount."No.";
            end;
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate();
            begin

                if "No." <> xRec."No." then begin
                    CashAcc.GET("Cash Desk No.");
                    NoSeriesMgt.TestManual(GetNoSeriesCode);
                    "No. Series" := '';
                end;
            end;
        }
        field(3; "Opening Date"; Date)
        {
            Caption = 'Opening Date';
        }
        field(4; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            Editable = false;
            TableRelation = Currency;
        }
        field(10; "Starting Balance"; Decimal)
        {
            Caption = 'Starting Balance';
            Editable = false;
        }
        field(11; "Starting Balance (LCY)"; Decimal)
        {
            Caption = 'Starting Balance (LCY)';
            Editable = false;
        }
        field(12; "Net Change"; Decimal)
        {
            CalcFormula = Sum ("Cash Report Line".Amount WHERE("Cash Desk No." = FIELD("Cash Desk No."),
                                                               "Cash Desk Report No." = FIELD("No.")));
            Caption = 'Net Change';
            Editable = false;
            FieldClass = FlowField;
        }
        field(13; "Net Change (LCY)"; Decimal)
        {
            CalcFormula = Sum ("Cash Report Line"."Amount (LCY)" WHERE("Cash Desk No." = FIELD("Cash Desk No."),
                                                                       "Cash Desk Report No." = FIELD("No.")));
            Caption = 'Net Change (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14; "Ending Balance"; Decimal)
        {
            Caption = 'Ending Balance';
            Editable = false;
            FieldClass = Normal;
        }
        field(15; "Ending Balance (LCY)"; Decimal)
        {
            Caption = 'Ending Balance (LCY)';
            Editable = false;
        }
        field(16; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Closed';
            OptionMembers = Open,Closed;
        }
        field(17; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(18; "Amount Denomination"; Decimal)
        {
            CalcFormula = Sum ("Denomination Specification".Amount WHERE("Cash Desk Report No." = FIELD("No."),
                                                                         "Currency Code" = FIELD("Currency Code")));
            Caption = 'Amount Denomination';
            Editable = false;
            FieldClass = FlowField;
        }
        field(19; "Closing Date"; Date)
        {
            Caption = 'Closing Date';
        }
    }

    keys
    {
        key(Key1; "Cash Desk No.", "No.")
        {
        }
        key(Key2; "Opening Date", "No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Cash Desk No.", "No.")
        {
        }
    }

    trigger OnDelete();
    begin
        TESTFIELD(Status, Status::Open);

        CashReportLine.RESET;
        CashReportLine.SETRANGE("Cash Desk Report No.", "No.");
        CashReportLine.SETRANGE("Cash Desk No.", "Cash Desk No.");
        CashReportLine.SETRANGE(Status, CashReportLine.Status::Posted);
        if CashReportLine.FINDFIRST then
            ERROR(Text003, "No.");
        CashReportLine.SETRANGE(Status);
        CashReportLine.DELETEALL;
    end;

    trigger OnInsert();
    begin
        CashAcc.GET("Cash Desk No.");

        CheckOpenReports;

        if "No." = '' then begin
            TestNoSeries;
            NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec."No. Series", 0D, "No.", "No. Series");
        end;

        "Opening Date" := WORKDATE;
        "Currency Code" := CashAcc."Currency Code";
        CashAcc.TESTFIELD("Cash Desk Report Nos.");
        "No. Series" := CashAcc."Cash Desk Report Nos.";

        CashAcc.SetCashReptStartingBalance(Rec);
    end;

    trigger OnModify();
    begin
        TESTFIELD(Status, Status::Open);
    end;

    trigger OnRename();
    begin
        ERROR(Text006, TABLECAPTION);
    end;

    var
        CashAcc: Record "Bank Account";
        CashOrderHeader: Record "Cash Order Header";
        CashReportHeader: Record "Cash Report Header";
        Text000: Label 'There is already open Cash Desk Report for Cash Desk %1';
        CashReportLine: Record "Cash Report Line";
        Text002: Label 'You cannot close Cash Desk Report while there are not posted Cash Orders for this Cash Desk Report.';
        Text003: Label 'You cannot delete Cash Desk Report since there are posted Cash Orders with Cash Desk Report No. %1.';
        Text004: Label 'Cash Desk %1 requires %2 to be deposited.';
        PostedCashOrderHeader: Record "Posted Cash Order Header";
        Text005: Label 'You cannot close Cash Desk Report without Report Lines added to it.';
        NoSeriesMgt: Codeunit NoSeriesManagement;
        AmountToDeposit: Decimal;
        Text006: Label 'You cannot rename %1.';
        CashOrderPost: Codeunit "Cash Order-Post";

    procedure AssistEdit(OldCashReport: Record "Cash Report Header"): Boolean;
    begin
        with OldCashReport do begin
            COPY(Rec);
            CashAcc.GET("Cash Desk No.");
            TestNoSeries;
            if NoSeriesMgt.SelectSeries(GetNoSeriesCode, "No. Series", "No. Series") then begin
                NoSeriesMgt.SetSeries("No.");
                exit(true);
            end;
        end;
    end;

    local procedure TestNoSeries(): Boolean;
    begin
        CashAcc.TESTFIELD("Cash Desk Report Nos.");
    end;

    local procedure GetNoSeriesCode(): Code[10];
    begin
        exit(CashAcc."Cash Desk Report Nos.");
    end;

    procedure SuggestLines();
    var
        NextLineNo: Integer;
    begin
        PostedCashOrderHeader.LOCKTABLE;

        NextLineNo := 0;
        PostedCashOrderHeader.SETRANGE("Cash Desk No.", "Cash Desk No.");
        PostedCashOrderHeader.SETRANGE("Cash Desk Report No.", '');
        if PostedCashOrderHeader.FINDSET(true, false) then
            repeat
                CashReportLine.INIT;
                CashReportLine."Cash Desk No." := "Cash Desk No.";
                CashReportLine."Cash Desk Report No." := "No.";
                NextLineNo += 10000;
                CashReportLine."Line No." := NextLineNo;
                CashReportLine."Cash Order Type" := PostedCashOrderHeader."Order Type";
                CashReportLine."Cash Order No." := PostedCashOrderHeader."No.";
                CashReportLine.Status := CashReportLine.Status::Posted;
                CashReportLine."Pay-to/Receive-from Name" := PostedCashOrderHeader."Pay-to/Receive-from Name";
                CashReportLine."Posting Date" := PostedCashOrderHeader."Posting Date";
                PostedCashOrderHeader.CALCFIELDS(Amount, "Amount (LCY)");
                if CashReportLine."Cash Order Type" = CashReportLine."Cash Order Type"::Receipt then begin
                    CashReportLine.Amount := PostedCashOrderHeader.Amount;
                    CashReportLine."Amount (LCY)" := PostedCashOrderHeader."Amount (LCY)";
                end else begin
                    CashReportLine.Amount := -PostedCashOrderHeader.Amount;
                    CashReportLine."Amount (LCY)" := -PostedCashOrderHeader."Amount (LCY)";
                end;
                CashReportLine.Correction := PostedCashOrderHeader.Correction;
                CashReportLine.INSERT;
                PostedCashOrderHeader."Cash Desk Report No." := "No.";
                PostedCashOrderHeader.MODIFY;
            until PostedCashOrderHeader.NEXT = 0;
    end;

    procedure Close();
    begin
        TESTFIELD("Opening Date");

        CashReportLine.RESET;
        CashReportLine.SETRANGE("Cash Desk No.", "Cash Desk No.");
        CashReportLine.SETRANGE("Cash Desk Report No.", "No.");
        if not CashReportLine.FINDFIRST then
            ERROR(Text005);

        CALCFIELDS("Net Change", "Net Change (LCY)");

        CashAcc.GET("Cash Desk No.");
        TESTFIELD("Currency Code", CashAcc."Currency Code");
        CashOrderHeader.SETRANGE("Cash Desk No.", "Cash Desk No.");
        if CashAcc."Cash Posting Level" = CashAcc."Cash Posting Level"::"Cash Desk Report" then
            CashOrderHeader.SETRANGE(Status, CashOrderHeader.Status::Open);
        if CashOrderHeader.FINDFIRST then
            ERROR(Text002);

        ReCalcStartingBalance;
        "Ending Balance" := "Starting Balance" + "Net Change";
        "Ending Balance (LCY)" := "Starting Balance (LCY)" + "Net Change (LCY)";

        if CashAcc."Cash Posting Level" = CashAcc."Cash Posting Level"::"Cash Desk Report" then
            with CashReportLine do begin
                RESET;
                SETRANGE("Cash Desk Report No.", "No.");
                SETRANGE(Status, Status::Issued);
                if FINDSET then
                    repeat
                        CashOrderHeader.GET("Cash Desk No.", "Cash Order Type", "Cash Order No.");
                        CashOrderPost.SetCalledFrom(1);
                        CashOrderPost.RUN(CashOrderHeader);
                        CLEAR(CashOrderPost);
                    until NEXT = 0;
                MODIFYALL(Status, Status::Posted);
            end;

        Status := Status::Closed;
        "Closing Date" := TODAY;
        MODIFY;

        AmountToDeposit := CashAcc.ControlBalanceLimit("Ending Balance");
        if AmountToDeposit <> 0 then
            MESSAGE(Text004, CashAcc."No.", AmountToDeposit);
    end;

    procedure Reopen();
    begin
        TESTFIELD(Status, Status::Closed);
        CheckOpenReports;
        VALIDATE(Status, Status::Open);
        MODIFY;
    end;

    procedure CheckOpenReports();
    begin
        CashReportHeader.SETRANGE("Cash Desk No.", "Cash Desk No.");
        CashReportHeader.SETRANGE(Status, Status::Open);
        if CashReportHeader.FINDFIRST then
            ERROR(Text000, "Cash Desk No.");
    end;

    procedure ReCalcStartingBalance();
    begin
        "Starting Balance" := 0;
        "Starting Balance (LCY)" := 0;
        CashReportHeader.RESET;
        CashReportHeader.SETRANGE("Cash Desk No.", "Cash Desk No.");
        CashReportHeader.SETRANGE(Status, Status::Closed);
        if CashReportHeader.FINDSET then begin
            repeat
                "Starting Balance" := "Starting Balance" +
                  CashReportHeader."Ending Balance" - CashReportHeader."Starting Balance";
                "Starting Balance (LCY)" := "Starting Balance (LCY)" +
                  CashReportHeader."Ending Balance (LCY)" - CashReportHeader."Starting Balance (LCY)";
            until CashReportHeader.NEXT = 0;
        end;
    end;
}

