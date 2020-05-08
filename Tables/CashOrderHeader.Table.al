table 46015645 "Cash Order Header"
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

    Caption = 'Cash Order Header';
    DataCaptionFields = "Cash Desk No.", "Order Type", "No.", "Pay-to/Receive-from Name";

    fields
    {
        field(1; "Cash Desk No."; Code[20])
        {
            Caption = 'Cash Desk No.';
            Editable = false;
            TableRelation = "Bank Account" WHERE("Account Type" = CONST("Cash Desk"));

            trigger OnLookup();
            var
                CashDeskAcc: Record "Bank Account";
            begin

                if not CashDeskAcc.GET("Cash Desk No.") then
                    CashDeskAcc."Account Type" := CashDeskAcc."Account Type"::"Cash Desk";
                CashDeskAcc.Lookup;
            end;

            trigger OnValidate();
            begin
                TESTFIELD("Cash Desk No.");
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
        field(3; "Pay-to/Receive-from Name"; Text[50])
        {
            Caption = 'Pay-to/Receive-from Name';

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(4; "Pay-to/Receive-from Name 2"; Text[50])
        {
            Caption = 'Pay-to/Receive-from Name 2';

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(5; "Posting Date"; Date)
        {
            Caption = 'Posting Date';

            trigger OnValidate();
            begin
                if "Currency Code" <> '' then begin
                    UpdateCurrencyFactor;
                    if "Currency Factor" <> xRec."Currency Factor" then
                        ConfirmUpdateCurrencyFactor;
                end;

                "Document Date" := "Posting Date";
                "VAT Date" := "Posting Date";
            end;
        }
        field(7; Amount; Decimal)
        {
            CalcFormula = Sum ("Cash Order Line".Amount WHERE("Cash Order No." = FIELD("No."),
                                                              "Order Type" = FIELD("Order Type")));
            Caption = 'Amount';
            FieldClass = FlowField;
        }
        field(8; "Amount (LCY)"; Decimal)
        {
            CalcFormula = Sum ("Cash Order Line"."Amount (LCY)" WHERE("Cash Order No." = FIELD("No."),
                                                                      "Order Type" = FIELD("Order Type")));
            Caption = 'Amount (LCY)';
            FieldClass = FlowField;
        }
        field(12; Correction; Boolean)
        {
            Caption = 'Correction';

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(13; "Cash Desk Report No."; Code[20])
        {
            Caption = 'Cash Desk Report No.';
            TableRelation = "Cash Report Header"."No." WHERE("Cash Desk No." = FIELD("Cash Desk No."),
                                                              Status = CONST(Open));

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(14; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Issued,Posted';
            OptionMembers = Open,Issued,Posted;
        }
        field(15; "No. Printed"; Integer)
        {
            Caption = 'No. Printed';
        }
        field(17; "Opened User ID"; Code[50])
        {
            Caption = 'Opened User ID';

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(18; "Issued User ID"; Code[50])
        {
            Caption = 'Issued User ID';
        }
        field(20; "Order Type"; Option)
        {
            Caption = 'Order Type';
            OptionCaption = 'Receipt,Withdrawal';
            OptionMembers = Receipt,Withdrawal;

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(21; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(22; "Currency Code"; Code[20])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
                if not (CurrFieldNo in [0, FIELDNO("Posting Date")]) then
                    TESTFIELD(Status, Status::Open);
                if CurrFieldNo <> FIELDNO("Currency Code") then
                    UpdateCurrencyFactor
                else begin
                    if "Currency Code" <> xRec."Currency Code" then begin
                        UpdateCurrencyFactor;
                    end else
                        if "Currency Code" <> '' then begin
                            UpdateCurrencyFactor;
                            if "Currency Factor" <> xRec."Currency Factor" then
                                ConfirmUpdateCurrencyFactor;
                        end;
                end;
            end;
        }
        field(23; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate();
            begin

                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(24; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate();
            begin

                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(25; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
                UpdateLines;
            end;
        }
        field(30; "Document Date"; Date)
        {
            Caption = 'Document Date';

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(35; "VAT Date"; Date)
        {
            Caption = 'VAT Date';
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
        key(Key1; "Cash Desk No.", "Order Type", "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin

        TESTFIELD(Status, Status::Open);

        CashOrderLine.RESET;
        CashOrderLine.SETRANGE("Cash Desk No.", "Cash Desk No.");
        CashOrderLine.SETRANGE("Order Type", "Order Type");
        CashOrderLine.SETRANGE("Cash Order No.", "No.");
        CashOrderLine.DELETEALL;
    end;

    trigger OnInsert();
    begin

        CashAcc.GET("Cash Desk No.");
        if "No." = '' then begin
            TestNoSeries;
            NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec."No. Series", "Posting Date", "No.", "No. Series");
        end;

        InitRecord;

        TESTFIELD("No. Series");

        SourceCodeSetup.GET;
        TableID[1] := DATABASE::"Cash Order Header";
        No[1] := "No.";

        "Dimension Set ID" := DimMgt.GetDefaultDimID(TableID, No, SourceCodeSetup."Cash Desk", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);
    end;

    trigger OnRename();
    begin
        ERROR(Text003, TABLECAPTION);
    end;

    var
        CashOrderLine: Record "Cash Order Line";
        Text003: Label 'You cannot rename a %1.';
        CurrExchRate: Record "Currency Exchange Rate";
        Text004: Label 'Do you want to update the exchange rate?';
        CashReportHeader: Record "Cash Report Header";
        GLSetup: Record "General Ledger Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DimMgt: Codeunit DimensionManagement;
        CurrencyDate: Date;
        Confirmed: Boolean;
        HideValidationDialog: Boolean;
        CashAcc: Record "Bank Account";
        Text064: Label 'You may have changed a dimension.\\Do you want to update the lines?';
        Text26540: Label 'You must have open %1 if %2 is set as %3.';
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];

    procedure InitRecord();
    begin

        "Posting Date" := WORKDATE;
        "Document Date" := "Posting Date";
        "VAT Date" := "Posting Date";
        "Opened User ID" := USERID;
        case "Order Type" of
            "Order Type"::Receipt:
                begin
                    CashAcc.TESTFIELD("Cash Order Receipt Nos.");
                    "No. Series" := CashAcc."Cash Order Receipt Nos.";
                end;
            "Order Type"::Withdrawal:
                begin
                    CashAcc.TESTFIELD("Cash Order Withdrawal Nos.");
                    "No. Series" := CashAcc."Cash Order Withdrawal Nos.";
                end;
        end;
        VALIDATE("Currency Code", CashAcc."Currency Code");

        CheckCashDeskReport(Rec);
    end;

    procedure AssistEdit(OldCashOrderHeader: Record "Cash Order Header"): Boolean;
    begin

        with OldCashOrderHeader do begin
            COPY(Rec);
            CashAcc.GET("Cash Desk No.");
            TestNoSeries;
            if NoSeriesMgt.SelectSeries(GetNoSeriesCode, "No. Series", "No. Series") then begin
                NoSeriesMgt.SetSeries("No.");
                exit(true);
            end;
        end;
    end;

    procedure Lookup();
    var
        CashReceiptList: Page "Cash Receipt List";
        CashWithdrawalList: Page "Cash Withdrawal List";
    begin
        case "Order Type" of
            "Order Type"::Receipt:
                begin
                    CashReceiptList.LOOKUPMODE(true);
                    CashReceiptList.SETRECORD(Rec);
                    if CashReceiptList.RUNMODAL = ACTION::LookupOK then
                        CashReceiptList.GETRECORD(Rec);
                end;
            "Order Type"::Withdrawal:
                begin
                    CashWithdrawalList.LOOKUPMODE(true);
                    CashWithdrawalList.SETRECORD(Rec);
                    if CashWithdrawalList.RUNMODAL = ACTION::LookupOK then
                        CashWithdrawalList.GETRECORD(Rec);
                end;
        end;
    end;

    local procedure TestNoSeries(): Boolean;
    begin

        case "Order Type" of
            "Order Type"::Receipt:
                CashAcc.TESTFIELD("Cash Order Receipt Nos.");
            "Order Type"::Withdrawal:
                CashAcc.TESTFIELD("Cash Order Withdrawal Nos.");
        end;
    end;

    local procedure GetNoSeriesCode(): Code[10];
    begin

        case "Order Type" of
            "Order Type"::Receipt:
                exit(CashAcc."Cash Order Receipt Nos.");
            "Order Type"::Withdrawal:
                exit(CashAcc."Cash Order Withdrawal Nos.");
        end;
    end;

    local procedure UpdateCurrencyFactor();
    begin
        if "Currency Code" <> '' then begin
            if "Posting Date" = 0D then
                CurrencyDate := WORKDATE
            else
                CurrencyDate := "Posting Date";
            "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate, "Currency Code");
        end else
            "Currency Factor" := 0;
    end;

    local procedure ConfirmUpdateCurrencyFactor();
    begin
        if HideValidationDialog or not GUIALLOWED then
            Confirmed := true
        else
            Confirmed := CONFIRM(Text004, false);
        if Confirmed then
            VALIDATE("Currency Factor")
        else
            "Currency Factor" := xRec."Currency Factor";
    end;

    procedure UpdateLines();
    begin
        CashOrderLine.RESET;
        CashOrderLine.SETRANGE("Cash Desk No.", "Cash Desk No.");
        CashOrderLine.SETRANGE("Order Type", "Order Type");
        CashOrderLine.SETRANGE("Cash Order No.", "No.");
        if CashOrderLine.FINDSET(true, false) then
            repeat
                CashOrderLine.UpdateBalance("Currency Factor");
                CashOrderLine.MODIFY;
            until CashOrderLine.NEXT = 0;
    end;

    procedure CheckCashDeskReport(var CashOrderHeader: Record "Cash Order Header");
    begin
        GLSetup.GET;

        CashReportHeader.RESET;
        CashReportHeader.SETRANGE("Cash Desk No.", CashOrderHeader."Cash Desk No.");
        CashReportHeader.SETRANGE(Status, CashReportHeader.Status::Open);
        if CashReportHeader.FINDFIRST then
            CashOrderHeader."Cash Desk Report No." := CashReportHeader."No."
        else
            if GLSetup."Cash Desk Report Mandatory" then
                ERROR(Text26540,
                  CashReportHeader.TABLECAPTION,
                  GLSetup.FIELDCAPTION("Cash Desk Report Mandatory"),
                  GLSetup."Cash Desk Report Mandatory");
    end;

    procedure ShowDocDim();
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet2(
            "Dimension Set ID", STRSUBSTNO('%1 %2', TABLECAPTION, "No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        if OldDimSetID <> "Dimension Set ID" then begin
            MODIFY;
            if CashOrderLinesExist then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    procedure CashOrderLinesExist(): Boolean;
    begin
        CashOrderLine.RESET;
        CashOrderLine.SETRANGE("Cash Desk No.", "Cash Desk No.");
        CashOrderLine.SETRANGE("Order Type", "Order Type");
        CashOrderLine.SETRANGE("Cash Order No.", "No.");
        exit(CashOrderLine.FINDFIRST);
    end;

    local procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer);
    var
        NewDimSetID: Integer;
    begin
        if NewParentDimSetID = OldParentDimSetID then
            exit;
        if not CONFIRM(Text064) then
            exit;

        CashOrderLine.RESET;
        CashOrderLine.SETRANGE("Cash Desk No.", "Cash Desk No.");
        CashOrderLine.SETRANGE("Order Type", "Order Type");
        CashOrderLine.SETRANGE("Cash Order No.", "No.");
        CashOrderLine.LOCKTABLE;

        if CashOrderLine.FIND('-') then
            repeat
                NewDimSetID := DimMgt.GetDeltaDimSetID(CashOrderLine."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if CashOrderLine."Dimension Set ID" <> NewDimSetID then begin
                    CashOrderLine."Dimension Set ID" := NewDimSetID;
                    DimMgt.UpdateGlobalDimFromDimSetID(
                      CashOrderLine."Dimension Set ID", CashOrderLine."Shortcut Dimension 1 Code", CashOrderLine."Shortcut Dimension 2 Code");
                    CashOrderLine.MODIFY;
                end;
            until CashOrderLine.NEXT = 0;
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        if "No." <> '' then
            MODIFY;

        if OldDimSetID <> "Dimension Set ID" then begin
            MODIFY;
            if CashOrderLinesExist then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;
}

