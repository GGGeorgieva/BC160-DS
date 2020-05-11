codeunit 46015605 "Cash Order-Post"
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
    // 001   mp       07.11.14                  List of changes :
    //                           NAVE18.00      Builded from version 6.0
    // -----------------------------------------------------------------------------------------

    TableNo = "Cash Order Header";

    trigger OnRun();
    begin
        if PostingDateExists and (ReplacePostingDate or ("Posting Date" = 0D)) then begin
            "Posting Date" := PostingDate;
            "Document Date" := PostingDate;
            "VAT Date" := PostingDate;
        end;

        CashOrderHeader := Rec;
        with CashOrderHeader do begin
            TESTFIELD("Cash Desk No.");
            TESTFIELD("No.");
            TESTFIELD("Posting Date");
            TESTFIELD("VAT Date");
            if GenJnlCheckLine.DateNotAllowed("Posting Date") then
                FIELDERROR("Posting Date", Text045);

            SourceCodeSetup.GET;
            CashAcc.GET("Cash Desk No.");
            if CalledFrom = CalledFrom::"Cash Order" then
                CashAcc.TESTFIELD("Cash Posting Level", CashAcc."Cash Posting Level"::"Cash Order");

            CashOrderIssue.CheckCashOrder(Rec);
            CheckCashDeskReport(CashOrderHeader);

            if RECORDLEVELLOCKING then begin
                CashOrderLine.LOCKTABLE;
                GLEntry.LOCKTABLE;
                if GLEntry.FINDLAST then;
            end;

            Window.OPEN(
              '#1#################################\\' +
              Text002);

            // Insert posted cash order header
            Window.UPDATE(1, STRSUBSTNO('%1 %2 %3', "Cash Desk No.", "Order Type", "No."));

            PostedCashOrderHeader.INIT;
            PostedCashOrderHeader.TRANSFERFIELDS(CashOrderHeader);
            PostedCashOrderHeader."Posted User ID" := USERID;
            PostedCashOrderHeader."No. Printed" := 0;
            PostedCashOrderHeader.INSERT;

            // Lines
            CashOrderLine.RESET;
            CashOrderLine.SETRANGE("Cash Desk No.", "Cash Desk No.");
            CashOrderLine.SETRANGE("Order Type", "Order Type");
            CashOrderLine.SETRANGE("Cash Order No.", "No.");
            LineCount := 0;

            if CashOrderLine.FINDSET then
                repeat
                    LineCount := LineCount + 1;
                    Window.UPDATE(2, LineCount);

                    // Insert posted cash order line
                    PostedCashOrderLine.INIT;
                    PostedCashOrderLine.TRANSFERFIELDS(CashOrderLine);
                    PostedCashOrderLine.INSERT;

                    // Post cash order lines
                    if CashOrderLine.Amount <> 0 then begin
                        CashOrderLine.TESTFIELD("Account Type");
                        CashOrderLine.TESTFIELD("Account No.");

                        InitGenJnlLine(CashOrderHeader, CashOrderLine);

                        if CashOrderLine."Account Type" = CashOrderLine."Account Type"::"Bank Account" then begin
                            if CashOrderLine."Order Type" = CashOrderLine."Order Type"::Receipt then begin
                                BankAcc.GET(CashOrderLine."Account No.");
                                BankAcc.TESTFIELD("Bank Acc. Posting Group");
                                BankPostingGr.GET(BankAcc."Bank Acc. Posting Group");
                                BankPostingGr.TESTFIELD("G/L Interim Account No.");
                            end else begin
                                CashAcc.TESTFIELD("Bank Acc. Posting Group");
                                BankPostingGr.GET(CashAcc."Bank Acc. Posting Group");
                                BankPostingGr.TESTFIELD("G/L Interim Account No.");
                            end;
                            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                            GenJnlLine."Account No." := BankPostingGr."G/L Interim Account No.";
                        end;
                        GenJnlPostLine.RunWithCheck(GenJnlLine);
                    end;
                until CashOrderLine.NEXT = 0;

            // Insert to cash report
            if CalledFrom = CalledFrom::"Cash Order" then
                InsertCashOrderToReport(CashAcc, CashOrderHeader);

            if HASLINKS then
                DELETELINKS;
            DELETE;

            if CashOrderLine.FINDFIRST then
                repeat
                    if CashOrderLine.HASLINKS then
                        CashOrderLine.DELETELINKS;
                until CashOrderLine.NEXT = 0;
            CashOrderLine.DELETEALL;

            CLEAR(GenJnlPostLine);
            Window.CLOSE;
        end;
    end;

    var
        CashOrderHeader: Record "Cash Order Header";
        CashOrderLine: Record "Cash Order Line";
        GenJnlLine: Record "Gen. Journal Line" temporary;
        PostedCashOrderHeader: Record "Posted Cash Order Header";
        PostedCashOrderLine: Record "Posted Cash Order Line";
        SourceCodeSetup: Record "Source Code Setup";
        CashAcc: Record "Bank Account";
        BankAcc: Record "Bank Account";
        BankPostingGr: Record "Bank Account Posting Group";
        GLEntry: Record "G/L Entry";
        GenJnlCheckLine: Codeunit "Gen. Jnl.-Check Line";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        DimMgt: Codeunit DimensionManagement;
        CashOrderIssue: Codeunit "Cash Order-Issue";
        LineCount: Integer;
        Text002: Label 'Posting lines              #2######\';
        Text045: Label 'is not within your range of allowed posting dates.';
        LineNo: Integer;
        Window: Dialog;
        CalledFrom: Option "Cash Order","Cash Report";
        PostingDateExists: Boolean;
        ReplacePostingDate: Boolean;
        PostingDate: Date;

    procedure SetPostingDate(NewReplacePostingDate: Boolean; NewPostingDate: Date);
    begin
        PostingDateExists := true;
        ReplacePostingDate := NewReplacePostingDate;
        PostingDate := NewPostingDate;
    end;

    procedure InitGenJnlLine(CashOrderHeader2: Record "Cash Order Header"; CashOrderLine2: Record "Cash Order Line");
    begin
        with GenJnlLine do begin
            INIT;
            case CashOrderLine2."Document Type" of
                CashOrderLine2."Document Type"::Payment:
                    "Document Type" := "Document Type"::Payment;
                CashOrderLine2."Document Type"::Refund:
                    "Document Type" := "Document Type"::Refund;
            end;
            "Document No." := CashOrderHeader2."No.";
            "External Document No." := CashOrderLine2."External Document No.";
            "Posting Date" := CashOrderHeader2."Posting Date";
            "VAT Date" := CashOrderHeader2."Posting Date";
            "Posting Group" := CashOrderLine2."Posting Group";
            Description := CashOrderLine2.Description;
            "Account Type" := CashOrderLine2."Account Type"; // REMOVE -1 ENUM TO INTEGER DL 11.05.20
            "Account No." := CashOrderLine2."Account No.";
            "Bal. Account Type" := "Bal. Account Type"::"Bank Account";
            "Bal. Account No." := CashOrderHeader2."Cash Desk No.";
            "Applies-to Doc. Type" := CashOrderLine2."Applies-To Doc. Type";
            "Applies-to Doc. No." := CashOrderLine2."Applies-To Doc. No.";
            "Applies-to ID" := CashOrderLine2."Applies-to ID";
            "Currency Code" := CashOrderHeader2."Currency Code";
            "Currency Factor" := CashOrderHeader2."Currency Factor";
            "Cash Order Type" := CashOrderHeader2."Order Type" + 1;
            "Cash Desk Report No." := CashOrderHeader2."Cash Desk Report No.";
            "Source Code" := SourceCodeSetup."Cash Desk";
            Correction := CashOrderHeader2.Correction;
            Prepayment := CashOrderLine2.Prepayment;
            "On Hold" := CashOrderLine2."On Hold";
            if CashOrderLine2.OppositeSignAmount then begin
                Amount := -CashOrderLine2.Amount;
                "Amount (LCY)" := -CashOrderLine2."Amount (LCY)";
            end else begin
                Amount := CashOrderLine2.Amount;
                "Amount (LCY)" := CashOrderLine2."Amount (LCY)";
            end;
            "System-Created Entry" := true;
            "Shortcut Dimension 1 Code" := CashOrderLine2."Shortcut Dimension 1 Code";
            "Shortcut Dimension 2 Code" := CashOrderLine2."Shortcut Dimension 2 Code";

            GenJnlLine."Dimension Set ID" := CashOrderLine2."Dimension Set ID";

        end;
    end;

    procedure GetGenJnlLine(var NewGenJnlLine: Record "Gen. Journal Line" temporary);
    begin
        NewGenJnlLine := GenJnlLine;
    end;

    procedure GetInterimAccount(): Code[20];
    var
        BankPostingGr: Record "Bank Account Posting Group";
        BankAcc: Record "Bank Account";
    begin
        with CashOrderLine do begin
            BankAcc.GET("Account No.");
            BankAcc.TESTFIELD("Bank Acc. Posting Group");
            BankPostingGr.GET(BankAcc."Bank Acc. Posting Group");
            BankPostingGr.TESTFIELD("G/L Interim Account No.");
            exit(BankPostingGr."G/L Interim Account No.");
        end;
    end;

    procedure InsertCashOrderToReport(CashAcc: Record "Bank Account"; CashOrderHeader2: Record "Cash Order Header");
    var
        CashReportLine: Record "Cash Report Line";
    begin
        with CashReportLine do begin
            RESET;
            SETRANGE("Cash Desk No.", CashOrderHeader2."Cash Desk No.");
            SETRANGE("Cash Desk Report No.", CashOrderHeader2."Cash Desk Report No.");
            if FINDLAST then
                LineNo := "Line No."
            else
                LineNo := 10000;

            INIT;
            "Cash Desk No." := CashOrderHeader2."Cash Desk No.";
            "Cash Desk Report No." := CashOrderHeader2."Cash Desk Report No.";
            LineNo := LineNo + 10000;
            "Line No." := LineNo;
            "Posting Date" := CashOrderHeader2."Posting Date";
            "Cash Order Type" := CashOrderHeader2."Order Type";
            "Cash Order No." := CashOrderHeader2."No.";
            "Pay-to/Receive-from Name" := CashOrderHeader2."Pay-to/Receive-from Name";
            CashOrderHeader2.CALCFIELDS(Amount, "Amount (LCY)");
            if "Cash Order Type" = "Cash Order Type"::Receipt then begin
                Amount := CashOrderHeader2.Amount;
                "Amount (LCY)" := CashOrderHeader2."Amount (LCY)";
            end else begin
                Amount := -CashOrderHeader2.Amount;
                "Amount (LCY)" := -CashOrderHeader2."Amount (LCY)";
            end;
            Correction := CashOrderHeader2.Correction;
            case CashAcc."Cash Posting Level" of
                CashAcc."Cash Posting Level"::"Cash Order":
                    Status := Status::Posted;
                CashAcc."Cash Posting Level"::"Cash Desk Report":
                    Status := Status::Issued;
            end;
            INSERT(true);
        end;
    end;

    procedure SetCalledFrom(NewCalledFrom: Option "Cash Order","Cash Report");
    begin
        CalledFrom := NewCalledFrom;
    end;
}

