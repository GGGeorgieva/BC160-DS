codeunit 46015609 "Cash Order-Issue"
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
    var
        GenJnlLineCheck: Codeunit "Gen. Jnl.-Check Line";
    begin
        if Status <> Status::Open then
            exit;

        if PostingDateExists and (ReplacePostingDate or ("Posting Date" = 0D)) then begin
            "Posting Date" := PostingDate;
            VALIDATE("Currency Code");
        end;

        CheckCashOrder(Rec);
        CheckCashDeskReport(Rec);

        CashOrderLine.RESET;
        CashOrderLine.SETRANGE("Cash Desk No.", "Cash Desk No.");
        CashOrderLine.SETRANGE("Order Type", "Order Type");
        CashOrderLine.SETRANGE("Cash Order No.", "No.");
        CashOrderLine.FINDSET;
        repeat
            SetOnHold(CashOrderLine);

            CashDeskPost.InitGenJnlLine(Rec, CashOrderLine);
            CashDeskPost.GetGenJnlLine(GenJnlLine);
            GenJnlLineCheck.RunCheck(GenJnlLine);
        until CashOrderLine.NEXT = 0;

        Status := Status::Issued;
        "Issued User ID" := USERID;
        MODIFY;

        CashAcc.GET("Cash Desk No.");
        if CashAcc."Cash Posting Level" = CashAcc."Cash Posting Level"::"Cash Desk Report" then
            CashDeskPost.InsertCashOrderToReport(CashAcc, Rec);
    end;

    var
        CashAcc: Record "Bank Account";
        CashOrderLine: Record "Cash Order Line";
        GenJnlLine: Record "Gen. Journal Line";
        CashDeskPost: Codeunit "Cash Order-Post";
        Text001: Label 'There are no cash order lines to issue.';
        Text002: Label 'Only one line with %1 Customer or Vendor is allowed.';
        Text003: Label 'Cash Order amount exceed maximal limit %1.';
        Text006: Label 'You cannot issue this %1 because %2 balance will exceed maximal balance limit %3.';
        Text007: Label 'You cannot issue this %1 because %2 balance will be less than minimal balance limit %3.';
        PostingDateExists: Boolean;
        ReplacePostingDate: Boolean;
        PostingDate: Date;

    procedure SetPostingDate(NewReplacePostingDate: Boolean; NewPostingDate: Date);
    begin
        PostingDateExists := true;
        ReplacePostingDate := NewReplacePostingDate;
        PostingDate := NewPostingDate;
    end;

    procedure Reopen(var CashOrderHeader: Record "Cash Order Header");
    begin
        with CashOrderHeader do begin
            TESTFIELD(Status, Status::Issued);
            Status := Status::Open;
            MODIFY;
        end;
    end;

    procedure CheckCashOrder(CashOrderHeader: Record "Cash Order Header");
    var
        CashAcc: Record "Bank Account";
    begin
        with CashAcc do begin
            GET(CashOrderHeader."Cash Desk No.");
            TESTFIELD("Account Type", "Account Type"::"Cash Desk");
            TESTFIELD("Bank Acc. Posting Group");

            CashOrderLine.RESET;
            CashOrderLine.SETRANGE("Cash Desk No.", CashOrderHeader."Cash Desk No.");
            CashOrderLine.SETRANGE("Order Type", CashOrderHeader."Order Type");
            CashOrderLine.SETRANGE("Cash Order No.", CashOrderHeader."No.");
            CashOrderLine.SETFILTER("Account No.", '<>%1', '');
            if CashOrderLine.ISEMPTY then
                ERROR(Text001);
            CashOrderLine.SETRANGE("Account No.");
            CashOrderLine.SETFILTER(Amount, '<>%1', 0);
            if CashOrderLine.ISEMPTY then
                ERROR(Text001);

            CashOrderLine.SETFILTER("Account Type", '<>%1', CashOrderLine."Account Type"::" ");
            CashOrderLine.SETFILTER(Amount, '%1', 0);
            if CashOrderLine.FINDFIRST then
                repeat
                    CashOrderLine.FIELDERROR(Amount);
                until CashOrderLine.NEXT = 0;

            CashOrderLine.SETRANGE(Amount);
            CashOrderLine.SETRANGE("Account Type",
              CashOrderLine."Account Type"::Customer,
              CashOrderLine."Account Type"::Vendor);
            if CashOrderLine.FINDFIRST then begin
                CashOrderLine.SETFILTER("Line No.", '<>%1', CashOrderLine."Line No.");
                if not CashOrderLine.ISEMPTY then
                    ERROR(Text002, CashOrderLine.FIELDCAPTION("Account Type"));
            end;

            if CashOrderHeader."Currency Code" <> '' then
                CashOrderHeader.TESTFIELD("Currency Factor");

            CALCFIELDS(Balance, "Cash Order Balance");
            CashOrderLine.RESET;
            CashOrderLine.SETRANGE("Cash Desk No.", CashOrderHeader."Cash Desk No.");
            CashOrderLine.SETRANGE("Order Type", CashOrderHeader."Order Type");
            CashOrderLine.SETRANGE("Cash Order No.", CashOrderHeader."No.");
            CashOrderLine.CALCSUMS(Amount);
            if CashOrderHeader."Order Type" = CashOrderHeader."Order Type"::Withdrawal then
                CashOrderLine.Amount := -CashOrderLine.Amount;
            if ("Balance Limit Control" in ["Balance Limit Control"::Min, "Balance Limit Control"::Both]) and
               ((Balance + CashOrderLine.Amount) < "Min. Balance")
            then
                ERROR(Text007, CashOrderHeader."Order Type", "No.", "Min. Balance");
            if ("Balance Limit Control" in ["Balance Limit Control"::Max, "Balance Limit Control"::Both]) and
               ((Balance + CashOrderLine.Amount) > "Max. Balance")
            then
                ERROR(Text006, CashOrderHeader."Order Type", "No.", "Max. Balance");
        end;

        with CashOrderHeader do begin
            CALCFIELDS(Amount, "Amount (LCY)");
            TESTFIELD(Amount);
            TESTFIELD("Amount (LCY)");
            case "Order Type" of
                "Order Type"::Receipt:
                    begin
                        if Amount > CashAcc."Cash Receipt Limit" then
                            ERROR(Text003, CashAcc."Cash Receipt Limit");
                    end;
                "Order Type"::Withdrawal:
                    begin
                        if Amount > CashAcc."Cash Withdrawal Limit" then
                            ERROR(Text003, CashAcc."Cash Withdrawal Limit");
                    end;
            end;
        end;
    end;

    procedure SetOnHold(CashOrderLine2: Record "Cash Order Line");
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
    begin
        with CashOrderLine2 do begin
            if ("On Hold" <> '') and ("Applies-To Doc. Type".AsInteger() > 0) and ("Applies-To Doc. No." <> '') then begin
                if "Account Type" = "Account Type"::Customer then begin
                    CustLedgEntry.RESET;
                    CustLedgEntry.SETCURRENTKEY("Customer No.");
                    CustLedgEntry.SETRANGE("Customer No.");
                    CustLedgEntry.SETRANGE("Document Type", "Applies-To Doc. Type");
                    CustLedgEntry.SETRANGE("Document No.", "Applies-To Doc. No.");
                    CustLedgEntry.SETRANGE(Open, true);
                    CustLedgEntry.MODIFYALL("On Hold", "On Hold");
                end;
                if "Account Type" = "Account Type"::Vendor then begin
                    VendLedgEntry.RESET;
                    VendLedgEntry.SETCURRENTKEY("Vendor No.");
                    VendLedgEntry.SETRANGE("Vendor No.");
                    VendLedgEntry.SETRANGE("Document Type", "Applies-To Doc. Type");
                    VendLedgEntry.SETRANGE("Document No.", "Applies-To Doc. No.");
                    VendLedgEntry.SETRANGE(Open, true);
                    VendLedgEntry.MODIFYALL("On Hold", "On Hold");
                end;
            end;
        end;
    end;
}

