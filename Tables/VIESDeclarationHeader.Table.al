table 46015618 "VIES Declaration Header"
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

    Caption = 'VIES Declaration Header';
    //DrillDownPageID = "VIES Declarations";
    //LookupPageID = "VIES Declarations";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate();
            var
                NoSeriesMgt: Codeunit NoSeriesManagement;
            begin
                if "No." <> xRec."No." then begin
                    NoSeriesMgt.TestManual(GetNoSeriesCode);
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';
            NotBlank = true;

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(3; "Trade Type"; Option)
        {
            Caption = 'Trade Type';
            InitValue = Sales;
            OptionCaption = 'Purchases,Sales,Both';
            OptionMembers = Purchases,Sales,Both;

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
                if LineExists then
                    ERROR(Text004, FIELDCAPTION("Trade Type"));
                CheckPeriod;
            end;
        }
        field(4; "Period No."; Integer)
        {
            Caption = 'Period No.';

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
                if "Period No." <> xRec."Period No." then begin
                    if LineExists then
                        ERROR(Text004, FIELDCAPTION("Period No."));
                    SetPeriod;
                end;
            end;
        }
        field(5; Year; Integer)
        {
            Caption = 'Year';
            MaxValue = 9999;
            MinValue = 2000;

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
                if Year <> xRec.Year then begin
                    if LineExists then
                        ERROR(Text004, FIELDCAPTION(Year));
                    SetPeriod;
                end;
            end;
        }
        field(6; "Start Date"; Date)
        {
            Caption = 'Start Date';
            Editable = false;
        }
        field(7; "End Date"; Date)
        {
            Caption = 'End Date';
            Editable = false;
        }
        field(8; Name; Text[100])
        {
            Caption = 'Name';

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(9; "Name 2"; Text[50])
        {
            Caption = 'Name 2';

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(10; "Country/Region Name"; Text[30])
        {
            Caption = 'Country/Region Name';

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(11; County; Text[30])
        {
            Caption = 'County';

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(12; "Municipality No."; Text[30])
        {
            Caption = 'Municipality No.';

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(13; Street; Text[50])
        {
            Caption = 'Street';

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(14; "House No."; Text[30])
        {
            Caption = 'House No.';

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(15; "Apartment No."; Text[30])
        {
            Caption = 'Apartment No.';

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(16; City; Text[30])
        {
            Caption = 'City';

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
                PostCode.ValidateCity(City, "Post Code", "Country/Region Name", CountryCode, GUIALLOWED);
                County := CountryCode;
            end;
        }
        field(17; "Post Code"; Code[20])
        {
            Caption = 'Post Code';

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
                PostCode.ValidatePostCode(City, "Post Code", "Country/Region Name", CountryCode, GUIALLOWED);
                ;
                County := CountryCode;
            end;
        }
        field(18; "Tax Office Number"; Code[20])
        {
            Caption = 'Tax Office Number';

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(19; "Declaration Period"; Option)
        {
            Caption = 'Declaration Period';
            OptionCaption = 'Quarter,Month';
            OptionMembers = Quarter,Month;

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
                if "Declaration Period" <> xRec."Declaration Period" then begin
                    if LineExists then
                        ERROR(Text004, FIELDCAPTION("Declaration Period"));
                    SetPeriod;
                end;
            end;
        }
        field(20; "Declaration Type"; Option)
        {
            Caption = 'Declaration Type';
            OptionCaption = 'Normal,Corrective,Corrective-Supplementary';
            OptionMembers = Normal,Corrective,"Corrective-Supplementary";

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
                if "Declaration Type" <> xRec."Declaration Type" then begin
                    if LineExists then
                        ERROR(Text004, FIELDCAPTION("Declaration Type"));
                    if "Declaration Type" = "Declaration Type"::Normal then
                        "Corrected Declaration No." := '';
                end;
            end;
        }
        field(21; "Corrected Declaration No."; Code[20])
        {
            Caption = 'Corrected Declaration No.';
            TableRelation = "VIES Declaration Header" WHERE("Corrected Declaration No." = FILTER(''),
                                                             Status = CONST(Released));

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
                if "Corrected Declaration No." <> xRec."Corrected Declaration No." then begin
                    if "Declaration Type" = "Declaration Type"::Normal then
                        FIELDERROR("Declaration Type");
                    if "No." = "Corrected Declaration No." then
                        FIELDERROR("Corrected Declaration No.");
                    if LineExists then
                        ERROR(Text004, FIELDCAPTION("Corrected Declaration No."));

                    CopyCorrDeclaration;
                end;
            end;
        }
        field(24; "Document Date"; Date)
        {
            Caption = 'Document Date';

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(25; "Number of Pages"; Integer)
        {
            CalcFormula = Max ("VIES Declaration Line"."Report Page Number" WHERE("VIES Declaration No." = FIELD("No.")));
            Caption = 'Number of Pages';
            Editable = false;
            FieldClass = FlowField;
        }
        field(26; "Number of Lines"; Integer)
        {
            CalcFormula = Count ("VIES Declaration Line" WHERE("VIES Declaration No." = FIELD("No.")));
            Caption = 'Number of Lines';
            Editable = false;
            FieldClass = FlowField;
        }
        field(27; "Sign-off Place"; Text[30])
        {
            Caption = 'Sign-off Place';

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(28; "Sign-off Date"; Date)
        {
            Caption = 'Sign-off Date';

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(29; "EU Goods/Services"; Option)
        {
            Caption = 'EU Goods/Services';
            OptionCaption = 'Both,Goods,Services';
            OptionMembers = Both,Goods,Services;

            trigger OnValidate();
            begin
                if LineExists then
                    ERROR(Text004, FIELDCAPTION("EU Goods/Services"));
            end;
        }
        field(30; "Purchase Amount (LCY)"; Decimal)
        {
            CalcFormula = Sum ("VIES Declaration Line"."Amount (LCY)" WHERE("VIES Declaration No." = FIELD("No."),
                                                                            "Trade Type" = CONST(Purchase)));
            Caption = 'Purchase Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(31; "Sales Amount (LCY)"; Decimal)
        {
            CalcFormula = Sum ("VIES Declaration Line"."Amount (LCY)" WHERE("VIES Declaration No." = FIELD("No."),
                                                                            "Trade Type" = CONST(Sale)));
            Caption = 'Sales Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(32; "Amount (LCY)"; Decimal)
        {
            CalcFormula = Sum ("VIES Declaration Line"."Amount (LCY)" WHERE("VIES Declaration No." = FIELD("No.")));
            Caption = 'Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(33; "Number of Supplies"; Decimal)
        {
            CalcFormula = Sum ("VIES Declaration Line"."Number of Supplies" WHERE("VIES Declaration No." = FIELD("No.")));
            Caption = 'Number of Supplies';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Open,Released';
            OptionMembers = Open,Released;
        }
        field(51; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(70; "Authorized Employee No."; Code[20])
        {
            Caption = 'Authorized Employee No.';
            TableRelation = "Company Officials";

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(71; "Filled by Employee No."; Code[20])
        {
            Caption = 'Filled by Employee No.';
            TableRelation = "Company Officials";

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
        key(Key2; "Start Date", "End Date")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "EU Goods/Services", "Period No.", Year)
        {
        }
    }

    trigger OnDelete();
    var
        VIESLine: Record "VIES Declaration Line";
    begin
        TESTFIELD(Status, Status::Open);

        VIESLine.RESET;
        VIESLine.SETRANGE("VIES Declaration No.", "No.");
        VIESLine.DELETEALL;
    end;

    trigger OnInsert();
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        if "No." = '' then
            NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec."No. Series", WORKDATE, "No.", "No. Series");

        InitRecord;
    end;

    trigger OnRename();
    begin
        ERROR(Text003, TABLECAPTION);
    end;

    var
        Text001: Label 'Period from %1 till %2 already exists on %3 %4.';
        Text002: Label '%1 should be earlier than %2.';
        Text003: Label 'You cannot rename a %1.';
        PostCode: Record "Post Code";
        Text004: Label 'You cannot change %1 because you already have declaration lines.';
        Text005: Label 'The permitted values for %1 are from 1 to %2.';
        CountryCode: Code[10];

    procedure InitRecord();
    var
        VATReportingSetup: Record "Stat. Reporting Setup";
        Country: Record "Country/Region";
        CompanyInfo: Record "Company Information";
    begin
        CompanyInfo.GET;
        VATReportingSetup.GET;
        "VAT Registration No." := CompanyInfo."VAT Registration No.";
        "Document Date" := WORKDATE;
        Name := CompanyInfo.Name;
        "Name 2" := CompanyInfo."Name 2";
        Country.GET(CompanyInfo."Country/Region Code");
        "Country/Region Name" := Country.Name;
        County := CompanyInfo.County;
        City := CompanyInfo.City;
        Street := VATReportingSetup.Street;
        "House No." := VATReportingSetup."House No.";
        "Apartment No." := VATReportingSetup."Apartment No.";
        "Municipality No." := VATReportingSetup."Municipality No.";
        "Post Code" := CompanyInfo."Post Code";
        "Tax Office Number" := VATReportingSetup."Tax Office Number";
        "Authorized Employee No." := VATReportingSetup."VIES Decl. Auth. Employee No.";
        "Filled by Employee No." := VATReportingSetup."VIES Decl. Filled by Empl. No.";
    end;

    procedure AssistEdit(OldVIESHeader: Record "VIES Declaration Header"): Boolean;
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        if NoSeriesMgt.SelectSeries(GetNoSeriesCode, OldVIESHeader."No. Series", "No. Series") then begin
            NoSeriesMgt.SetSeries("No.");
            exit(true);
        end;
    end;

    local procedure GetNoSeriesCode(): Code[10];
    var
        VATReportingSetup: Record "Stat. Reporting Setup";
    begin
        VATReportingSetup.GET;
        VATReportingSetup.TESTFIELD("VIES Declaration Nos.");
        exit(VATReportingSetup."VIES Declaration Nos.");
    end;

    local procedure CheckPeriodNo();
    var
        MaxPeriodNo: Integer;
    begin
        if "Declaration Period" = "Declaration Period"::Month then
            MaxPeriodNo := 12
        else
            MaxPeriodNo := 4;
        if not ("Period No." in [1 .. MaxPeriodNo]) then
            ERROR(Text005, FIELDCAPTION("Period No."), MaxPeriodNo);
    end;

    local procedure SetPeriod();
    begin
        if "Period No." <> 0 then
            CheckPeriodNo;
        if ("Period No." = 0) or (Year = 0) then begin
            "Start Date" := 0D;
            "End Date" := 0D;
        end else begin
            if "Declaration Period" = "Declaration Period"::Month then begin
                "Start Date" := DMY2DATE(1, "Period No.", Year);
                "End Date" := CALCDATE('<CM>', "Start Date");
            end else begin
                "Start Date" := DMY2DATE(1, "Period No." * 3 - 2, Year);
                "End Date" := CALCDATE('<CQ>', "Start Date");
            end;
        end;
        CheckPeriod;
    end;

    local procedure CheckPeriod();
    var
        VIESHeader: Record "VIES Declaration Header";
    begin
        if ("Start Date" = 0D) or ("End Date" = 0D) then
            exit;

        if "Start Date" >= "End Date" then
            ERROR(Text002, FIELDCAPTION("Start Date"), FIELDCAPTION("End Date"));

        if "Corrected Declaration No." = '' then begin
            VIESHeader.RESET;
            VIESHeader.SETCURRENTKEY("Start Date", "End Date");
            VIESHeader.SETRANGE("Start Date", "Start Date");
            VIESHeader.SETRANGE("End Date", "End Date");
            VIESHeader.SETRANGE("Corrected Declaration No.", '');
            VIESHeader.SETRANGE("VAT Registration No.", "VAT Registration No.");
            VIESHeader.SETRANGE("Declaration Type", "Declaration Type");
            VIESHeader.SETRANGE("Trade Type", "Trade Type");
            VIESHeader.SETFILTER("No.", '<>%1', "No.");
            if VIESHeader.FINDFIRST then
                ERROR(Text001, "Start Date", "End Date", VIESHeader.TABLECAPTION, VIESHeader."No.");
        end;
    end;

    procedure PrintTestReport();
    var
        VIESDeclarationHeader: Record "VIES Declaration Header";
    begin
        VIESDeclarationHeader := Rec;
        VIESDeclarationHeader.SETRECFILTER;
        //TODO MISSING REPORT: VIES Declaration - Test
        //REPORT.RUN(REPORT::"VIES Declaration - Test", true, false, VIESDeclarationHeader);
    end;

    procedure Print();
    var
        VIESDeclarationHeader: Record "VIES Declaration Header";
        VATReportingSetup: Record "Stat. Reporting Setup";
    begin
        TESTFIELD(Status, Status::Released);
        VATReportingSetup.GET;
        VATReportingSetup.TESTFIELD(VATReportingSetup."VIES Declaration Report No.");
        VIESDeclarationHeader := Rec;
        VIESDeclarationHeader.SETRECFILTER;
        REPORT.RUN(VATReportingSetup."VIES Declaration Report No.", true, false, VIESDeclarationHeader);
    end;

    procedure Export();
    var
        VIESDeclarationHeader: Record "VIES Declaration Header";
        VATReportingSetup: Record "Stat. Reporting Setup";
    begin
        TESTFIELD(Status, Status::Released);
        VATReportingSetup.GET;
        VATReportingSetup.TESTFIELD(VATReportingSetup."VIES Decl. Exp. Obj. No.");
        VIESDeclarationHeader := Rec;
        VIESDeclarationHeader.SETRECFILTER;
        if VATReportingSetup."VIES Decl. Exp. Obj. Type" = VATReportingSetup."VIES Decl. Exp. Obj. Type"::Codeunit then
            CODEUNIT.RUN(VATReportingSetup."VIES Decl. Exp. Obj. No.", VIESDeclarationHeader)
        else
            REPORT.RUN(VATReportingSetup."VIES Decl. Exp. Obj. No.", true, false, VIESDeclarationHeader);
    end;

    local procedure LineExists(): Boolean;
    var
        VIESLine: Record "VIES Declaration Line";
    begin
        VIESLine.RESET;
        VIESLine.SETRANGE("VIES Declaration No.", "No.");
        exit(VIESLine.FINDFIRST);
    end;

    local procedure CopyCorrDeclaration();
    var
        SavedVIESHeader: Record "VIES Declaration Header";
        VIESHeader: Record "VIES Declaration Header";
    begin
        TESTFIELD("Corrected Declaration No.");
        VIESHeader.GET("Corrected Declaration No.");
        SavedVIESHeader.TRANSFERFIELDS(Rec);
        TRANSFERFIELDS(VIESHeader);
        MODIFY;
        "No." := SavedVIESHeader."No.";
        Status := SavedVIESHeader.Status::Open;
        "Document Date" := SavedVIESHeader."Document Date";
        "Declaration Type" := SavedVIESHeader."Declaration Type";
        "Corrected Declaration No." := SavedVIESHeader."Corrected Declaration No.";
    end;
}

