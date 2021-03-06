table 46015624 "Export SAD Header"
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

    Caption = 'Export SAD Header';
    //DrillDownPageID = "Export SAD List";
    //LookupPageID = "Export SAD List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            NotBlank = true;

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(2; "SAD Date"; Date)
        {
            Caption = 'SAD Date';

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(3; Description; Text[30])
        {
            Caption = 'Description';

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(4; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);

                if "Customer No." <> '' then begin
                    Customer.GET("Customer No.");
                    "Customer Name" := Customer.Name;
                    "Customs Currency Code" := Customer."Currency Code";
                end else begin
                    "Customer Name" := '';
                    "Customs Currency Code" := '';
                end;

                VALIDATE("Customs Currency Code");
            end;
        }
        field(5; "Customer Name"; Text[30])
        {
            Caption = 'Customer Name';
            FieldClass = Normal;

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(6; "Customs Currency Code"; Code[10])
        {
            Caption = 'Customs Currency Code';
            TableRelation = Currency;

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
                if "Customs Currency Code" <> xRec."Customs Currency Code" then
                    UpdateCurrencyRate;
            end;
        }
        field(7; "Customs Currency Date"; Date)
        {
            Caption = 'Customs Currency Date';

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
                if "Customs Currency Code" <> '' then
                    UpdateCurrencyRate;
            end;
        }
        field(8; "Customs Currency Rate"; Decimal)
        {
            Caption = 'Customs Currency Rate';
            InitValue = 1;

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(11; "Invoice No."; Code[20])
        {
            Caption = 'Invoice No.';

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(12; "External Document No."; Code[20])
        {
            Caption = 'External Document No.';

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(13; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(14; "VAT Amount (LCY)"; Decimal)
        {
            Caption = 'VAT Amount (LCY)';

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(15; "Customs Outpost Name"; Text[30])
        {
            Caption = 'Customs Outpost Name';

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(16; "SAD Type"; Option)
        {
            Caption = 'SAD Type';
            OptionCaption = 'Goods,Services';
            OptionMembers = Goods,Services;

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(17; "Statement No."; Code[20])
        {
            Caption = 'Statement No.';
            TableRelation = "Export SAD Statement";

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(19; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Closed';
            OptionMembers = Open,Closed;
        }
        field(20; "Customs Authority Invoice No."; Code[20])
        {
            Caption = 'Customs Authority Invoice No.';
            TableRelation = "Sales Invoice Header";

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(21; "Customs Authority Ref. No."; Code[20])
        {
            Caption = 'Customs Authority Ref. No.';

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; "Statement No.", "No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Description, "Customer No.")
        {
        }
    }

    trigger OnDelete();
    begin
        if IsNotOpen("No.") then
            ERROR(Text002);

        SADTariff.SETRANGE("SAD No.", "No.");
        SADTariff.SETRANGE(Type, SADTariff.Type::Export);
        SADTariff.DELETEALL;
    end;

    trigger OnInsert();
    begin
        "SAD Date" := WORKDATE;
        "Customs Currency Date" := WORKDATE;
    end;

    trigger OnRename();
    begin
        if IsNotOpen(xRec."No.") then
            ERROR(Text001, FIELDCAPTION("No."), xRec."No.");

        SADTariff.SETRANGE("SAD No.", xRec."No.");
        SADTariff.SETRANGE(Type, SADTariff.Type::Export);
        if SADTariff.FINDFIRST then
            ERROR(Text012, FIELDCAPTION("No."), xRec."No.");
    end;

    var
        Customer: Record Customer;
        CurrExchRate: Record "Currency Exchange Rate";
        ExpSADLine: Record "Export SAD Line";
        Text001: Label 'You cannot change the contents of the %1 field because the %2 SAD has assigned documents.';
        Text002: Label 'You cannot delete SAD because it has assigned documents.';
        SalesHeader: Record "Purchase Header";
        SADTariff: Record "SAD Tariff";
        SADPayment: Record "SAD Payment";
        SalesSetup: Record "Sales & Receivables Setup";
        Text006: Label 'No payments are linked to SAD No. %1. Please link payments to SAD before you assign Statement No. value.';
        Text008: Label 'Are you sure that you want to close SAD No. %1?';
        Text009: Label 'You are about to reopen a closed SAD No. %1. All fields will be enabled for editing.\ On SAD, editing information that is a part of previous VAT reporting can cause inconsistencies in VAT reporting.\ Are you sure you want to re-open SAD No. %1?';
        Text010: Label 'Statement No. value has not been assigned to SAD No. %1. \Please assign Statement No. value before closing the SAD document.';
        Text004: Label 'No tariffs are linked to SAD No. %1. \Please link tariffs to SAD before printing the Export Declaration document.';
        Text005: Label 'No SAD lines exist in SAD No. %1. \Please enter SAD lines before printing the Export Declaration document.';
        Text012: Label 'You cannot change the contents of the %1 field because the tariffs have been assigned to the SAD document.';
        Text013: Label 'The value of %1 field was not calculated.\Do you want to continue processing report?';
        Text014: Label 'SAD No. %1 already closed.';
        Text015: Label 'SAD No. %1 already open.';

    local procedure UpdateCurrencyRate();
    begin
        if "Customs Currency Code" <> '' then begin
            if "Customs Currency Date" = 0D then
                "Customs Currency Date" := WORKDATE;
            "Customs Currency Rate" := 1 / CurrExchRate.ExchangeRate("Customs Currency Date", "Customs Currency Code")
        end else
            "Customs Currency Rate" := 1;
        VALIDATE("Customs Currency Rate");
    end;

    procedure IsAssigned(SADNo: Code[20]): Boolean;
    begin
        SalesHeader.RESET;
        SalesHeader.SETRANGE("SAD No.", SADNo);
        exit(SalesHeader.FINDFIRST);
    end;

    procedure IsReleased(SADNo: Code[20]): Boolean;
    begin
        ExpSADLine.RESET;
        ExpSADLine.SETRANGE("SAD No.", SADNo);
        exit(ExpSADLine.FINDFIRST);
    end;

    procedure IsNotOpen(SADNo: Code[20]): Boolean;
    begin
        exit(IsAssigned(SADNo) or IsReleased(SADNo));
    end;

    procedure PaymentExists(): Boolean;
    begin
        SADPayment.RESET;
        SADPayment.SETRANGE("SAD No.", "No.");
        SADPayment.SETRANGE(Type, SADPayment.Type::Export);
        exit(SADPayment.FINDFIRST);
    end;

    procedure CloseSAD(): Boolean;
    begin
        if Status = Status::Closed then
            ERROR(Text014, "No.");
        if "Statement No." = '' then
            ERROR(Text010, "No.")
        else
            if not PaymentExists then
                ERROR(Text006, "No.");

        if CONFIRM(Text008, false, "No.") then begin
            Status := Status::Closed;
            exit(true);
        end;
        exit(false);
    end;

    procedure OpenSAD(): Boolean;
    begin
        if Status = Status::Open then
            ERROR(Text015, "No.");
        if CONFIRM(Text009, false, "No.") then begin
            Status := Status::Open;
            exit(true);
        end;
        exit(false);
    end;

    procedure CalculateAmounts();
    begin
        if Status = Status::Closed then
            ERROR(Text014, "No.");
        "Amount (LCY)" := 0;
        "VAT Amount (LCY)" := 0;
        ExpSADLine.SETRANGE("SAD No.", "No.");
        if ExpSADLine.FINDSET then
            repeat
                "Amount (LCY)" := "Amount (LCY)" + ExpSADLine."Amount (LCY)";
                "VAT Amount (LCY)" := "VAT Amount (LCY)" + ExpSADLine."VAT Amount (LCY)";
            until ExpSADLine.NEXT = 0;
    end;

    procedure PrintDocument();
    var
        ExpSADHeader: Record "Export SAD Header";
        ReportSelection: Record "Report Selections";
    begin
        SalesSetup.GET;
        with ExpSADHeader do begin
            COPY(Rec);
            if not FINDFIRST then
                exit;

            if "Amount (LCY)" = 0 then
                if not CONFIRM(Text013, false, FIELDCAPTION("Amount (LCY)")) then
                    exit;

            ExpSADLine.RESET;
            ExpSADLine.SETRANGE("SAD No.", "No.");
            if not ExpSADLine.FINDFIRST then
                ERROR(Text005, "No.");

            if SalesSetup."SAD Tariff Required" then begin
                SADTariff.RESET;
                SADTariff.SETRANGE("SAD No.", "No.");
                SADTariff.SETRANGE(Type, SADTariff.Type::Export);
                if not SADTariff.FINDFIRST then
                    ERROR(Text004, "No.");
            end;
            ReportSelection.SETRANGE(Usage, ReportSelection.Usage::BG3);
            ReportSelection.SETFILTER("Report ID", '<>0');
            if ReportSelection.FINDSET then
                repeat
                    REPORT.RUNMODAL(ReportSelection."Report ID", true, false, ExpSADHeader);
                until ReportSelection.NEXT = 0;
        end;
    end;
}

