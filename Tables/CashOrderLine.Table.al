table 46015646 "Cash Order Line"
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

    Caption = 'Cash Order Line';

    fields
    {
        field(1; "Cash Desk No."; Code[20])
        {
            Caption = 'Cash Desk No.';
            TableRelation = "Bank Account" WHERE("Account Type" = CONST("Cash Desk"));
        }
        field(2; "Cash Order No."; Code[20])
        {
            Caption = 'Cash Order No.';
            TableRelation = "Cash Order Header"."No." WHERE("No." = FIELD("Cash Order No."));
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Document Type"; Enum "Gen. Journal Document Type")
        {
            Caption = 'Document Type';
            Editable = false;
        }
        field(5; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';

            trigger OnValidate();
            var
                CashOrderLine: Record "Cash Order Line";
            begin
                TestStatusOpen;
                CashOrderLine := Rec;

                INIT;
                "Account Type" := CashOrderLine."Account Type";

                UpdateBalance(0);
            end;
        }
        field(6; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Account Type" = CONST(" ")) "Standard Text";

            trigger OnValidate();
            var
                StdTxt: Record "Standard Text";
                GLAcc: Record "G/L Account";
                Customer: Record Customer;
                Vendor: Record Vendor;
                BankAcc: Record "Bank Account";
            begin
                TestStatusOpen;

                case "Account Type" of
                    "Account Type"::" ":
                        begin
                            StdTxt.GET("Account No.");
                            Description := StdTxt.Description;
                        end;
                    "Account Type"::"G/L Account":
                        begin
                            GLAcc.GET("Account No.");
                            GLAcc.CheckGLAcc;
                            Description := GLAcc.Name;
                            CreateDim(
                              DATABASE::"G/L Account", "Account No.",
                              DATABASE::"Bank Account", "Cash Desk No.");
                        end;
                    "Account Type"::Customer:
                        begin
                            Customer.GET("Account No.");
                            Description := Customer.Name;
                            "Posting Group" := Customer."Customer Posting Group";
                            CreateDim(
                              DATABASE::Customer, "Account No.",
                              DATABASE::"Bank Account", "Cash Desk No.");
                        end;
                    "Account Type"::Vendor:
                        begin
                            Vendor.GET("Account No.");
                            Description := Vendor.Name;
                            "Posting Group" := Vendor."Vendor Posting Group";
                            CreateDim(
                              DATABASE::Vendor, "Account No.",
                              DATABASE::"Bank Account", "Cash Desk No.");
                        end;
                    "Account Type"::"Bank Account":
                        begin
                            BankAcc.GET("Account No.");
                            BankAcc.TESTFIELD(Blocked, false);
                            Description := BankAcc.Name;
                            CreateDim(
                              DATABASE::"Bank Account", "Account No.",
                              DATABASE::"Bank Account", "Cash Desk No.");
                        end;
                end;
            end;
        }
        field(7; "External Document No."; Code[20])
        {
            Caption = 'External Document No.';
        }
        field(8; "Posting Group"; Code[20])
        {
            Caption = 'Posting Group';
            TableRelation = IF ("Account Type" = CONST("Bank Account")) "Bank Account Posting Group"
            ELSE
            IF ("Account Type" = CONST(Customer)) "Customer Posting Group"
            ELSE
            IF ("Account Type" = CONST(Vendor)) "Vendor Posting Group"
            ELSE
            IF ("Account Type" = CONST("G/L Account")) "Standard Text";

            trigger OnValidate();
            var
                SalesSetup: Record "Sales & Receivables Setup";
                PurchSetup: Record "Purchases & Payables Setup";
                SubstCustPostingGrp: Record "Subst. Customer Posting Group";
                SubstVendPostingGrp: Record "Subst. Vendor Posting Group";
            begin
                TestStatusOpen;

                if CurrFieldNo = FIELDNO("Posting Group") then begin
                    case "Account Type" of
                        "Account Type"::Customer:
                            begin
                                SalesSetup.GET;
                                if SalesSetup."Allow Alter Posting Groups" then begin
                                    if not SubstCustPostingGrp.GET(xRec."Posting Group", "Posting Group") then
                                        ERROR(Text26500, xRec."Posting Group", "Posting Group", SubstCustPostingGrp.TABLECAPTION);
                                end else
                                    ERROR(Text26501, FIELDCAPTION("Posting Group"), SalesSetup.FIELDCAPTION("Allow Alter Posting Groups"));
                            end;
                        "Account Type"::Vendor:
                            begin
                                PurchSetup.GET;
                                if PurchSetup."Allow Alter Posting Groups" then begin
                                    if not SubstVendPostingGrp.GET(xRec."Posting Group", "Posting Group") then
                                        ERROR(Text26500, xRec."Posting Group", "Posting Group", SubstVendPostingGrp.TABLECAPTION);
                                end else
                                    ERROR(Text26501, FIELDCAPTION("Posting Group"), PurchSetup.FIELDCAPTION("Allow Alter Posting Groups"));
                            end;
                        else
                            ERROR(Text010, FIELDCAPTION("Account Type"));
                    end;
                end;
            end;
        }
        field(14; "Applies-To Doc. Type"; enum "Gen. Journal Document Type")
        {
            Caption = 'Applies-To Doc. Type';

            trigger OnValidate();
            begin
                TestStatusOpen;
            end;
        }
        field(15; "Applies-To Doc. No."; Code[20])
        {
            Caption = 'Applies-To Doc. No.';

            trigger OnLookup();
            var
                GenJnlLine: Record "Gen. Journal Line";
                PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
                AccNo: Code[20];
                AccType: enum "Gen. Journal Account Type";
                xAmount: Decimal;
            // TODO MISSING  Codeunit "Cash Order-Post"
            // CashOrderPost : Codeunit "Cash Order-Post";
            begin
                if "Prepayment Type" = "Prepayment Type"::Advance then
                    ERROR(Text007, FIELDCAPTION("Prepayment Type"), "Prepayment Type");

                TestStatusOpen;
                //CashOrderPost.InitGenJnlLine(CashOrderHeader,Rec);
                //CashOrderPost.GetGenJnlLine(GenJnlLine);
                xAmount := GenJnlLine.Amount;

                if GenJnlLine."Bal. Account Type" in
                   [GenJnlLine."Bal. Account Type"::Customer,
                    GenJnlLine."Bal. Account Type"::Vendor]
                then begin
                    AccNo := GenJnlLine."Bal. Account No.";
                    AccType := GenJnlLine."Bal. Account Type";
                end else begin
                    AccNo := GenJnlLine."Account No.";
                    AccType := GenJnlLine."Account Type";
                end;

                case AccType of
                    AccType::Customer:
                        LookupApplyCustEntry(GenJnlLine, AccNo);
                    AccType::Vendor:
                        LookupApplyVendEntry(GenJnlLine, AccNo);
                end;

                "Applies-To Doc. Type" := GenJnlLine."Applies-to Doc. Type";
                "Applies-To Doc. No." := GenJnlLine."Applies-to Doc. No.";
                "Applies-to ID" := GenJnlLine."Applies-to ID";
                VALIDATE(Amount, ABS(GenJnlLine.Amount));

                if xAmount <> 0 then
                    if not PaymentToleranceMgt.PmtTolGenJnl(GenJnlLine) then
                        exit;
            end;

            trigger OnValidate();
            var
                GenJnlLine: Record "Gen. Journal Line";
            //TODO MISSING Codeunit "Cash Order-Post"
            // CashOrderPost : Codeunit "Cash Order-Post";
            begin
                if "Prepayment Type" = "Prepayment Type"::Advance then
                    ERROR(Text007, FIELDCAPTION("Prepayment Type"), "Prepayment Type");

                TestStatusOpen;
                // CashOrderPost.InitGenJnlLine(CashOrderHeader,Rec);
                // CashOrderPost.GetGenJnlLine(GenJnlLine);
                GenJnlLine.VALIDATE("Applies-to Doc. No.");
            end;
        }
        field(16; Description; Text[50])
        {
            Caption = 'Description';

            trigger OnValidate();
            begin
                TestStatusOpen;
            end;
        }
        field(17; Amount; Decimal)
        {
            Caption = 'Amount';
            MinValue = 0;

            trigger OnValidate();
            begin
                TestStatusOpen;
                if Amount <> 0 then
                    TESTFIELD("Account Type");

                UpdateBalance(0);
            end;
        }
        field(18; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
            MinValue = 0;

            trigger OnValidate();
            var
                CurrExchRate: Record "Currency Exchange Rate";
            begin
                TestStatusOpen;

                if CashOrderHeader."Currency Code" = '' then
                    VALIDATE(Amount, "Amount (LCY)")
                else
                    VALIDATE(
                      Amount,
                      ROUND(
                        CurrExchRate.ExchangeAmtLCYToFCY(
                          CashOrderHeader."Posting Date", CashOrderHeader."Currency Code",
                          "Amount (LCY)", CashOrderHeader."Currency Factor"),
                        Currency."Amount Rounding Precision"));
            end;
        }
        field(20; "Line Amount"; Decimal)
        {
            Caption = 'Line Amount';
        }
        field(21; "Line Amount (LCY)"; Decimal)
        {
            Caption = 'Line Amount (LCY)';
        }
        field(22; "On Hold"; Code[20])
        {
            Caption = 'On Hold';

            trigger OnValidate();
            begin
                TestStatusOpen;
            end;
        }
        field(23; "Advance Letter No."; Code[20])
        {
            Caption = 'Advance Letter No.';
            //TODO UNNECESSARY TableRelation
            //TableRelation = IF ("Account Type" = CONST(Customer)) "Excise Tax Document" WHERE("Document Type" = FIELD("Document Type"))
            //ELSE
            //IF ("Account Type" = CONST(Vendor)) "Excise Item Detail Code" WHERE(Field4 = FIELD("Account No."));

            trigger OnLookup();
            begin
                TESTFIELD(Prepayment, true);
            end;

            trigger OnValidate();
            begin
                TestStatusOpen;
                TESTFIELD(Prepayment, true);
            end;
        }
        field(24; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';

            trigger OnValidate();
            begin
                TestStatusOpen;
            end;
        }
        field(25; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';

            trigger OnValidate();
            begin
                TestStatusOpen;
            end;
        }
        field(26; "Order Type"; Option)
        {
            Caption = 'Order Type';
            Editable = false;
            OptionCaption = 'Receipt,Withdrawal';
            OptionMembers = Receipt,Withdrawal;
        }
        field(28; "Applies-to ID"; Code[20])
        {
            Caption = 'Applies-to ID';

            trigger OnValidate();
            begin
                TestStatusOpen;
            end;
        }
        field(29; Prepayment; Boolean)
        {
            Caption = 'Prepayment';
        }
        field(30; "Prepayment Type"; Option)
        {
            Caption = 'Prepayment Type';
            OptionCaption = '" ,Prepayment,Advance"';
            OptionMembers = " ",Prepayment,Advance;

            trigger OnValidate();
            begin
                TESTFIELD(Prepayment, "Prepayment Type" <> "Prepayment Type"::" ");
                if "Prepayment Type" = "Prepayment Type"::Advance then begin
                    TESTFIELD("Applies-To Doc. Type", 0);
                    TESTFIELD("Applies-To Doc. No.", '');
                end;
            end;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup();
            begin
                ShowDocDim;
            end;
        }
    }

    keys
    {
        key(Key1; "Cash Desk No.", "Order Type", "Cash Order No.", "Line No.")
        {
            SumIndexFields = Amount, "Amount (LCY)", "Line Amount", "Line Amount (LCY)";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        TestStatusOpen;
    end;

    trigger OnInsert();
    begin
        TestStatusOpen;

        LOCKTABLE;

        InitRecord;
    end;

    trigger OnModify();
    begin
        TestStatusOpen;
    end;

    trigger OnRename();
    begin
        ERROR(Text000, TABLECAPTION);
    end;

    var
        CashOrderHeader: Record "Cash Order Header";
        Text000: Label 'You cannot rename a %1.';
        Currency: Record Currency;
        DimMgt: Codeunit DimensionManagement;
        Text003: Label 'The %1 in the %2 will be changed from %3 to %4.\';
        Text004: Label 'Do you wish to continue?';
        Text005: Label 'The update has been interrupted to respect the warning.';
        Text007: Label 'You are not allowed to apply an entry with %1 %2.';
        Text010: Label '%1 must be Customer or Vendor.';
        Text26500: Label 'You cannot change the %1 to %2 because %3 has not been filled in.';
        Text26501: Label 'You cannot change %1 until %2 will be checked in setup.';

    procedure InitRecord();
    begin
        GetOrderHeader;
        "Cash Desk No." := CashOrderHeader."Cash Desk No.";
    end;

    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20]);
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
        CashHeader: Record "Cash Order Header";
    begin
        SourceCodeSetup.GET;
        TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;

        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';

        if CashHeader.GET("Cash Desk No.", "Order Type", "Cash Order No.") then;

        "Dimension Set ID" := DimMgt.GetDefaultDimID(
          TableID, No, SourceCodeSetup."Cash Desk",
          "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", CashHeader."Dimension Set ID", DATABASE::Customer);
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin

        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
    end;

    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin

        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
    end;

    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20]);
    begin

        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    local procedure TestStatusOpen();
    begin
        GetOrderHeader;
        CashOrderHeader.TESTFIELD(Status, CashOrderHeader.Status::Open);
    end;

    procedure GetOrderHeader();
    begin
        TESTFIELD("Cash Order No.");
        if ("Cash Desk No." <> CashOrderHeader."Cash Desk No.") or
           ("Order Type" <> CashOrderHeader."Order Type") or
           ("Cash Order No." <> CashOrderHeader."No.")
        then begin
            CashOrderHeader.GET("Cash Desk No.", "Order Type", "Cash Order No.");
            if CashOrderHeader."Currency Code" = '' then
                Currency.InitRoundingPrecision
            else begin
                CashOrderHeader.TESTFIELD("Currency Factor");
                Currency.GET(CashOrderHeader."Currency Code");
                Currency.TESTFIELD("Amount Rounding Precision");
            end;
        end;
    end;

    procedure ShowDimensions();
    begin

        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", STRSUBSTNO('%1 - %2 - %3', "Order Type", "Cash Desk No.", "Cash Order No."));

        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    procedure UpdateBalance(NewCurrencyFactor: Decimal);
    var
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        GetOrderHeader;
        if NewCurrencyFactor <> 0 then
            CashOrderHeader."Currency Factor" := NewCurrencyFactor;

        if CashOrderHeader."Currency Code" <> '' then
            "Amount (LCY)" :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  CashOrderHeader."Posting Date", CashOrderHeader."Currency Code",
                  Amount, CashOrderHeader."Currency Factor"))
        else
            "Amount (LCY)" := ROUND(Amount);

        UpdateDocumentType;

        if (CashOrderHeader."Order Type" = CashOrderHeader."Order Type"::Withdrawal) and CashOrderHeader.Correction then begin
            "Line Amount" := -Amount;
            "Line Amount (LCY)" := -"Amount (LCY)";
        end else begin
            "Line Amount" := Amount;
            "Line Amount (LCY)" := "Amount (LCY)";
        end;
    end;

    procedure UpdateDocumentType();
    var
        PositiveDocType: Boolean;
        PositiveAccType: Boolean;
    begin
        if not ("Account Type" in ["Account Type"::Customer, "Account Type"::Vendor]) then
            exit;

        PositiveDocType := "Order Type" = "Order Type"::Receipt;
        PositiveAccType := "Account Type" = "Account Type"::Customer;
        if not (PositiveDocType xor PositiveAccType) then
            "Document Type" := "Document Type"::Payment
        else
            "Document Type" := "Document Type"::Refund;
    end;

    procedure OppositeSignAmount(): Boolean;
    begin
        if "Document Type" = "Document Type"::" " then
            exit("Order Type" = "Order Type"::Receipt);
        exit(
          ("Account Type" = "Account Type"::Customer) and
          ("Document Type" = "Document Type"::Payment) or
          ("Account Type" = "Account Type"::Vendor) and
          ("Document Type" = "Document Type"::Refund));
    end;

    procedure ApplyEntries();
    var
        GenJnlLine: Record "Gen. Journal Line";
    // MISSING Codeunit "Cash Order-Post"
    //  CashOrderPost: Codeunit "Cash Order-Post";
    begin
        CashOrderHeader.GET("Cash Desk No.", "Order Type", "Cash Order No.");
        //  CashOrderPost.InitGenJnlLine(CashOrderHeader, Rec);
        //  CashOrderPost.GetGenJnlLine(GenJnlLine);
        CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Apply", GenJnlLine);
        "Applies-to ID" := GenJnlLine."Applies-to ID";
        VALIDATE(Amount, ABS(GenJnlLine.Amount));
        MODIFY;
    end;

    local procedure GetAmtToApplyCust(CustLedgEntry: Record "Cust. Ledger Entry"; GenJnlLine: Record "Gen. Journal Line"): Decimal;
    var
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
    begin

        //temp
        /*
        IF GenJnlPostLine.ContinuePosting(GenJnlLine) THEN
          IF (CustLedgEntry."Amount to Apply" = 0) OR
             (ABS(CustLedgEntry."Amount to Apply") >=
              ABS(CustLedgEntry."Remaining Amount" - CustLedgEntry."Remaining Pmt. Disc. Possible"))
          THEN
            EXIT(-CustLedgEntry."Remaining Amount" + CustLedgEntry."Remaining Pmt. Disc. Possible");
        IF CustLedgEntry."Amount to Apply" = 0 THEN
          EXIT(-CustLedgEntry."Remaining Amount");
        EXIT(-CustLedgEntry."Amount to Apply");
        */

    end;

    local procedure GetAmtToApplyVend(VendLedgEntry: Record "Vendor Ledger Entry"; GenJnlLine: Record "Gen. Journal Line"): Decimal;
    var
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
    begin

        //temp
        /*
        IF GenJnlPostLine.CheckCalcPmtDiscGenJnlVend(GenJnlLine,VendLedgEntry,0,FALSE) THEN
          IF (VendLedgEntry."Amount to Apply" = 0) OR
             (ABS(VendLedgEntry."Amount to Apply") >=
              ABS(VendLedgEntry."Remaining Amount" - VendLedgEntry."Remaining Pmt. Disc. Possible"))
          THEN
            EXIT(-VendLedgEntry."Remaining Amount" + VendLedgEntry."Remaining Pmt. Disc. Possible");
        IF VendLedgEntry."Amount to Apply" = 0 THEN
          EXIT(-VendLedgEntry."Remaining Amount");
        EXIT(-VendLedgEntry."Amount to Apply");
        */

    end;

    local procedure SetAppliesToFiltersCust(var CustLedgEntry: Record "Cust. Ledger Entry"; GenJnlLine: Record "Gen. Journal Line"; AccNo: Code[20]);
    begin
        CustLedgEntry.SETCURRENTKEY("Customer No.", Open, Positive, "Due Date");
        CustLedgEntry.SETRANGE("Customer No.", AccNo);
        CustLedgEntry.SETRANGE(Open, true);
        CustLedgEntry.SETRANGE("Currency Code", GenJnlLine."Currency Code");
        if GenJnlLine."Applies-to Doc. No." <> '' then begin
            CustLedgEntry.SETRANGE("Document Type", GenJnlLine."Applies-to Doc. Type");
            CustLedgEntry.SETRANGE("Document No.", GenJnlLine."Applies-to Doc. No.");
            if not CustLedgEntry.FINDFIRST then begin
                CustLedgEntry.SETRANGE("Document Type");
                CustLedgEntry.SETRANGE("Document No.");
            end;
        end;
        if GenJnlLine."Applies-to ID" <> '' then begin
            CustLedgEntry.SETRANGE("Applies-to ID", GenJnlLine."Applies-to ID");
            if not CustLedgEntry.FINDFIRST then
                CustLedgEntry.SETRANGE("Applies-to ID");
        end;
        if GenJnlLine."Applies-to Doc. Type" <> GenJnlLine."Applies-to Doc. Type"::" " then begin
            CustLedgEntry.SETRANGE("Document Type", GenJnlLine."Applies-to Doc. Type");
            if not CustLedgEntry.FINDFIRST then
                CustLedgEntry.SETRANGE("Document Type");
        end;
        if GenJnlLine."Applies-to Doc. No." <> '' then begin
            CustLedgEntry.SETRANGE("Document No.", GenJnlLine."Applies-to Doc. No.");
            if not CustLedgEntry.FINDFIRST then
                CustLedgEntry.SETRANGE("Document No.");
        end;
        if GenJnlLine.Amount <> 0 then begin
            CustLedgEntry.SETRANGE(Positive, GenJnlLine.Amount < 0);
            if CustLedgEntry.FINDFIRST then;
            CustLedgEntry.SETRANGE(Positive);
        end;
    end;

    local procedure SetAppliesToFiltersVend(var VendLedgEntry: Record "Vendor Ledger Entry"; GenJnlLine: Record "Gen. Journal Line"; AccNo: Code[20]);
    begin
        VendLedgEntry.SETCURRENTKEY("Vendor No.", Open, Positive, "Due Date");
        VendLedgEntry.SETRANGE("Vendor No.", AccNo);
        VendLedgEntry.SETRANGE(Open, true);
        VendLedgEntry.SETRANGE("Currency Code", GenJnlLine."Currency Code");
        if GenJnlLine."Applies-to Doc. No." <> '' then begin
            VendLedgEntry.SETRANGE("Document Type", GenJnlLine."Applies-to Doc. Type");
            VendLedgEntry.SETRANGE("Document No.", GenJnlLine."Applies-to Doc. No.");
            if not VendLedgEntry.FINDFIRST then begin
                VendLedgEntry.SETRANGE("Document Type");
                VendLedgEntry.SETRANGE("Document No.");
            end;
        end;
        if GenJnlLine."Applies-to ID" <> '' then begin
            VendLedgEntry.SETRANGE("Applies-to ID", GenJnlLine."Applies-to ID");
            if not VendLedgEntry.FINDFIRST then
                VendLedgEntry.SETRANGE("Applies-to ID");
        end;
        if GenJnlLine."Applies-to Doc. Type" <> GenJnlLine."Applies-to Doc. Type"::" " then begin
            VendLedgEntry.SETRANGE("Document Type", GenJnlLine."Applies-to Doc. Type");
            if not VendLedgEntry.FINDFIRST then
                VendLedgEntry.SETRANGE("Document Type");
        end;
        if GenJnlLine."Applies-to Doc. No." <> '' then begin
            VendLedgEntry.SETRANGE("Document No.", GenJnlLine."Applies-to Doc. No.");
            if not VendLedgEntry.FINDFIRST then
                VendLedgEntry.SETRANGE("Document No.");
        end;
        if GenJnlLine.Amount <> 0 then begin
            VendLedgEntry.SETRANGE(Positive, GenJnlLine.Amount < 0);
            if VendLedgEntry.FINDFIRST then;
            VendLedgEntry.SETRANGE(Positive);
        end;
    end;

    local procedure LookupApplyCustEntry(var GenJnlLine: Record "Gen. Journal Line"; AccNo: Code[20]);
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        GenJnlApply: Codeunit "Gen. Jnl.-Apply";
        ApplyCustEntries: Page "Apply Customer Entries";
    begin
        CLEAR(CustLedgEntry);
        SetAppliesToFiltersCust(CustLedgEntry, GenJnlLine, AccNo);
        ApplyCustEntries.SetGenJnlLine(GenJnlLine, GenJnlLine.FIELDNO("Applies-to Doc. No."));
        ApplyCustEntries.SETTABLEVIEW(CustLedgEntry);
        ApplyCustEntries.SETRECORD(CustLedgEntry);
        ApplyCustEntries.LOOKUPMODE(true);
        if ApplyCustEntries.RUNMODAL = ACTION::LookupOK then begin
            ApplyCustEntries.GETRECORD(CustLedgEntry);
            if GenJnlLine."Currency Code" <> CustLedgEntry."Currency Code" then
                if GenJnlLine.Amount = 0 then begin
                    if not
                       CONFIRM(
                         Text003 +
                         Text004, true,
                         GenJnlLine.FIELDCAPTION("Currency Code"), GenJnlLine.TABLECAPTION,
                         GenJnlLine.GetShowCurrencyCode(GenJnlLine."Currency Code"),
                         GenJnlLine.GetShowCurrencyCode(CustLedgEntry."Currency Code"))
                    then
                        ERROR(Text005);
                    GenJnlLine.VALIDATE("Currency Code", CustLedgEntry."Currency Code");
                end else
                    GenJnlApply.CheckAgainstApplnCurrency(
                      GenJnlLine."Currency Code", CustLedgEntry."Currency Code",
                      GenJnlLine."Account Type"::Customer, true);
            if Amount = 0 then begin
                CustLedgEntry.CALCFIELDS("Remaining Amount");
                GenJnlLine.VALIDATE(Amount, GetAmtToApplyCust(CustLedgEntry, GenJnlLine));
            end;
            GenJnlLine."Applies-to Doc. Type" := CustLedgEntry."Document Type";
            GenJnlLine."Applies-to Doc. No." := CustLedgEntry."Document No.";
            GenJnlLine."Applies-to ID" := '';
        end;
        CLEAR(ApplyCustEntries);
    end;

    local procedure LookupApplyVendEntry(var GenJnlLine: Record "Gen. Journal Line"; AccNo: Code[20]);
    var
        VendLedgEntry: Record "Vendor Ledger Entry";
        GenJnlApply: Codeunit "Gen. Jnl.-Apply";
        ApplyVendEntries: Page "Apply Vendor Entries";
    begin
        CLEAR(VendLedgEntry);
        SetAppliesToFiltersVend(VendLedgEntry, GenJnlLine, AccNo);
        ApplyVendEntries.SetGenJnlLine(GenJnlLine, GenJnlLine.FIELDNO("Applies-to Doc. No."));
        ApplyVendEntries.SETTABLEVIEW(VendLedgEntry);
        ApplyVendEntries.SETRECORD(VendLedgEntry);
        ApplyVendEntries.LOOKUPMODE(true);
        if ApplyVendEntries.RUNMODAL = ACTION::LookupOK then begin
            ApplyVendEntries.GETRECORD(VendLedgEntry);
            if GenJnlLine."Currency Code" <> VendLedgEntry."Currency Code" then
                if GenJnlLine.Amount = 0 then begin
                    if not
                       CONFIRM(
                         Text003 +
                         Text004, true,
                         GenJnlLine.FIELDCAPTION("Currency Code"), GenJnlLine.TABLECAPTION,
                         GenJnlLine.GetShowCurrencyCode(GenJnlLine."Currency Code"),
                         GenJnlLine.GetShowCurrencyCode(VendLedgEntry."Currency Code"))
                    then
                        ERROR(Text005);
                    GenJnlLine.VALIDATE("Currency Code", VendLedgEntry."Currency Code");
                end else
                    GenJnlApply.CheckAgainstApplnCurrency(
                      GenJnlLine."Currency Code", VendLedgEntry."Currency Code",
                      GenJnlLine."Account Type"::" ", true);
            if Amount = 0 then begin
                VendLedgEntry.CALCFIELDS("Remaining Amount");
                GenJnlLine.VALIDATE(Amount, GetAmtToApplyVend(VendLedgEntry, GenJnlLine));
            end;
            GenJnlLine."Applies-to Doc. Type" := VendLedgEntry."Document Type";
            GenJnlLine."Applies-to Doc. No." := VendLedgEntry."Document No.";
            GenJnlLine."Applies-to ID" := '';
        end;
        CLEAR(ApplyVendEntries);
    end;

    procedure ShowDocDim();
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        //TODO MISSING METHOD EditDimensionSet2
        //"Dimension Set ID" :=
        //  DimMgt.EditDimensionSet2(
        //  "Dimension Set ID", STRSUBSTNO('%1 %2', TABLECAPTION, "Cash Order No."),
        //  "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        if OldDimSetID <> "Dimension Set ID" then begin
            MODIFY;
        end;
    end;

    procedure GetHeader();
    begin
    end;
}

