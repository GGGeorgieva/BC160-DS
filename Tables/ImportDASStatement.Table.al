table 46015634 "Import SAD Statement"
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

    Caption = 'Import SAD Statement';
    //LookupPageID = "Import SAD Statements";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(2; "Country/Region of Origin"; Code[10])
        {
            Caption = 'Country/Region of Origin';
            TableRelation = "Country/Region";

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(3; "Country/Region of Payment"; Code[10])
        {
            Caption = 'Country/Region of Payment';
            TableRelation = "Country/Region";

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(4; "Country/Region of Destination"; Code[10])
        {
            Caption = 'Country/Region of Destination';
            TableRelation = "Country/Region";

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(5; "Contract No."; Text[30])
        {
            Caption = 'Contract No.';

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(6; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Closed';
            OptionMembers = Open,Closed;
        }
        field(7; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(8; Description; Text[50])
        {
            Caption = 'Description';

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
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Contract No.", Description)
        {
        }
    }

    trigger OnInsert();
    begin
        PurchSetup.GET;

        if "No." = '' then begin
            TestNoSeries;
            NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec."No. Series", 0D, "No.", "No. Series");
        end;
    end;

    var
        PurchSetup: Record "Purchases & Payables Setup";
        ImpSADHeader: Record "Import SAD Header";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Text011: Label 'No payments are linked to SAD No. %1. Please link payments to SAD before closing Import Statement.';

    procedure PrintStatement();
    var
        ReportSelection: Record "Report Selections";
    begin
        ReportSelection.RESET;
        //TODO MISSING  ReportSelection.Usage::BG2
        //ReportSelection.SETRANGE(Usage, ReportSelection.Usage::BG2);
        ReportSelection.SETFILTER("Report ID", '<>0');
        if ReportSelection.FINDSET then
            repeat
                REPORT.RUNMODAL(ReportSelection."Report ID", true, false, Rec);
            until ReportSelection.NEXT = 0;
    end;

    procedure AssistEdit(OldStatement: Record "Import SAD Statement"): Boolean;
    begin
        PurchSetup.GET;
        TestNoSeries;
        if NoSeriesMgt.SelectSeries(GetNoSeriesCode, OldStatement."No. Series", "No. Series") then begin
            PurchSetup.GET;
            TestNoSeries;
            NoSeriesMgt.SetSeries("No.");
            exit(true);
        end;
    end;

    local procedure TestNoSeries(): Boolean;
    begin

        PurchSetup.TESTFIELD("Import Statement Nos.");
    end;

    local procedure GetNoSeriesCode(): Code[10];
    begin

        exit(PurchSetup."Import Statement Nos.");
    end;

    procedure Close();
    begin
        ImpSADHeader.SETRANGE("Statement No.", "No.");
        if ImpSADHeader.FINDSET then
            repeat
                ImpSADHeader.TESTFIELD(Status, ImpSADHeader.Status::Closed);
                if not ImpSADHeader.PaymentExists then
                    ERROR(Text011, ImpSADHeader."No.");
            until ImpSADHeader.NEXT = 0;
        Status := Status::Closed;
        MODIFY;
    end;

    procedure Reopen();
    begin
        Status := Status::Open;
        MODIFY;
    end;
}

