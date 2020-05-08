table 46015605 "Company Officials"
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

    Caption = 'Company Officials';
    DataCaptionFields = "No.", "First Name", "Middle Name", "Last Name";
    //DrillDownPageID = "Company Officials";
    //LookupPageID = "Company Officials";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate();
            begin
                if "No." <> xRec."No." then begin
                    GLSetup.GET;
                    NoSeriesMgt.TestManual(GLSetup."Company Officials Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "First Name"; Text[30])
        {
            Caption = 'First Name';
        }
        field(3; "Middle Name"; Text[30])
        {
            Caption = 'Middle Name';
        }
        field(4; "Last Name"; Text[30])
        {
            Caption = 'Last Name';
        }
        field(5; Initials; Text[30])
        {
            Caption = 'Initials';

            trigger OnValidate();
            begin
                if ("Search Name" = UPPERCASE(xRec.Initials)) or ("Search Name" = '') then
                    "Search Name" := Initials;
            end;
        }
        field(6; "Job Title"; Text[30])
        {
            Caption = 'Job Title';
        }
        field(7; "Search Name"; Code[30])
        {
            Caption = 'Search Name';
        }
        field(8; Address; Text[50])
        {
            Caption = 'Address';
        }
        field(9; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(10; City; Text[30])
        {
            Caption = 'City';

            trigger OnValidate();
            begin

                PostCode.ValidateCity(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GUIALLOWED);
            end;
        }
        field(11; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate();
            begin

                PostCode.ValidatePostCode(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GUIALLOWED);
            end;
        }
        field(12; County; Text[30])
        {
            Caption = 'County';
        }
        field(13; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(14; "Mobile Phone No."; Text[30])
        {
            Caption = 'Mobile Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(15; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            ExtendedDatatype = EMail;
        }
        field(19; Picture; BLOB)
        {
            Caption = 'Picture';
            SubType = Bitmap;
        }
        field(25; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(40; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(46; Extension; Text[30])
        {
            Caption = 'Extension';
        }
        field(48; Pager; Text[30])
        {
            Caption = 'Pager';
        }
        field(49; "Fax No."; Text[30])
        {
            Caption = 'Fax No.';
        }
        field(53; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(55; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = Employee;

            trigger OnValidate();
            begin
                if Employee.GET("Employee No.") then begin
                    TRANSFERFIELDS(Employee);
                    "No." := xRec."No.";
                end;
            end;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; "Search Name")
        {
        }
        key(Key3; "Last Name", "First Name", "Middle Name")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "First Name", "Last Name")
        {
        }
    }

    trigger OnInsert();
    begin
        if "No." = '' then begin
            GLSetup.GET;
            GLSetup.TESTFIELD("Company Officials Nos.");
            NoSeriesMgt.InitSeries(GLSetup."Company Officials Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;
    end;

    trigger OnModify();
    begin
        "Last Date Modified" := TODAY;
    end;

    trigger OnRename();
    begin
        "Last Date Modified" := TODAY;
    end;

    var
        GLSetup: Record "General Ledger Setup";
        Employee: Record Employee;
        PostCode: Record "Post Code";
        Officials: Record "Company Officials";
        NoSeriesMgt: Codeunit NoSeriesManagement;

    procedure AssistEdit(OldOfficials: Record "Company Officials"): Boolean;
    begin
        with Officials do begin
            Officials := Rec;
            GLSetup.GET;
            GLSetup.TESTFIELD("Company Officials Nos.");
            if NoSeriesMgt.SelectSeries(GLSetup."Company Officials Nos.", OldOfficials."No. Series", "No. Series") then begin
                GLSetup.GET;
                GLSetup.TESTFIELD("Company Officials Nos.");
                NoSeriesMgt.SetSeries("No.");
                Rec := Officials;
                exit(true);
            end;
        end;
    end;

    procedure FullName(): Text[100];
    begin
        if "Middle Name" = '' then
            exit("First Name" + ' ' + "Last Name")
        else
            exit("First Name" + ' ' + "Middle Name" + ' ' + "Last Name");
    end;

    procedure DisplayMap();
    var
        MapPoint: Record "Online Map Setup";
        MapMgt: Codeunit "Online Map Management";
    begin
        if MapPoint.FIND('-') then
            MapMgt.MakeSelection(DATABASE::Table46012225, GETPOSITION);
    end;
}

