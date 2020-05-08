table 46015516 "Posted VAT Protocol Header"
{
    // version NAVBG8.00

    // -----------------------------------------------------------------------------------------
    // XAPT Solutions
    // MS Dynamics NAV 2015 Localisation
    // 
    // mp  : Mile Petachki
    // version : NAVBG8.00
    // 
    // -----------------------------------------------------------------------------------------
    // No.   Sign     Date       Version        Description
    // -----------------------------------------------------------------------------------------
    // 001   mp       27.10.14   NAVBG8.00      Created table from MS Dynamics NAV 6.00
    //                           NAVBG8.00      Added new field : 46015700 - "Protocol Type"
    //                           NAVBG8.00      Added new field : 46015701 - "Apply-to Payment Entry"
    //                           NAVBG8.00      Added new field : 46015702 - "Date of Chargeable Tax"
    //                           NAVBG8.00      Added new field : 46015703 - Protocol Subtype
    //                           NAVBG8.00      Added new field : 46015704 - Date of Tax Credit
    // -----------------------------------------------------------------------------------------
    // Dynamic Solutions
    // MS Dynamics NAV 2017 Localisation
    // 
    // 
    // -----------------------------------------------------------------------------------------
    // No.   Sign     Date       Version        Description
    // -----------------------------------------------------------------------------------------
    // 001                                     List of changes :
    //                           NAVBG8.00      Added new field : 46015705 - Payment No.
    //                           NAVBG8.00      Added new field : 46015706 - Payment Date
    //                           NAVBG8.00      Added new field : 46015707 - Payment Due
    //                           NAVBG8.00      Added new field : 46015708 - Payment Amount
    //                           NAVBG8.00      Added new field : 46015709 - VAT Base
    //                           NAVBG8.00      Added new field : 46015710 - VAT %
    //                           NAVBG8.00      Added new field : 46015711 - VAT Amount Due
    // ------------------------------------------------------------------------------------------

    Caption = 'Posted VAT Protocol Header';
    DataCaptionFields = "No.";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Purchase,Sale';
            OptionMembers = Purchase,Sale;
        }
        field(3; "CV No."; Code[20])
        {
            Caption = 'CV No.';
            TableRelation = Vendor;
        }
        field(4; Address; Text[50])
        {
            Caption = 'Address';
        }
        field(5; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(6; City; Text[50])
        {
            Caption = 'City';
        }
        field(7; "Phone No."; Text[20])
        {
            Caption = 'Phone No.';
        }
        field(8; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = "Post Code";
        }
        field(9; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region" WHERE("EU Country/Region Code" = FILTER(<> ''));
        }
        field(10; "Fax No."; Text[20])
        {
            Caption = 'Fax No.';
        }
        field(12; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(13; "Name 2"; Text[50])
        {
            Caption = 'Name 2';
        }
        field(19; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';
        }
        field(20; "Registration No."; Text[20])
        {
            Caption = 'Registration No.';
        }
        field(21; "Identification No."; Text[13])
        {
            Caption = 'Identification No.';
        }
        field(22; "Posting Description"; Text[50])
        {
            Caption = 'Posting Description';
        }
        field(28; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(29; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(30; "Composed By"; Text[30])
        {
            Caption = 'Composed By';
        }
        field(39; Amount; Decimal)
        {
            CalcFormula = Sum ("Posted VAT Protocol Line"."VAT Base Amount (LCY)" WHERE("Document No." = FIELD("No.")));
            Caption = 'Amount';
            FieldClass = FlowField;
        }
        field(40; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(41; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(42; "VAT Date"; Date)
        {
            Caption = 'VAT Date';
        }
        field(45; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
        }
        field(47; "No. Printed"; Integer)
        {
            Caption = 'No. Printed';
            Editable = false;
        }
        field(50; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(51; "Posting No. Series"; Code[10])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
        }
        field(60; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(61; "Bal. VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'Bal. VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(80; Void; Boolean)
        {
            Caption = 'Void';
        }
        field(81; "Void Date"; Date)
        {
            Caption = 'Void Date';
        }
        field(82; "Ground For Issue"; Code[10])
        {
            Caption = 'Ground For Issue';
            TableRelation = "Ground for VAT Protocol".Code WHERE(Type = CONST(Issue));
        }
        field(83; "Ground For VAT Exempt"; Code[10])
        {
            Caption = 'Ground For VAT Exempt';
            TableRelation = "Ground for VAT Protocol".Code WHERE(Type = CONST("VAT Exempt"));
        }
        field(85; "Corr. VAT Protocol No."; Code[20])
        {
            Caption = 'Corr. VAT Protocol No.';
            TableRelation = "Posted VAT Protocol Header"."No." WHERE("CV No." = FIELD("CV No."));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate();
            var
                PostedVATProtocolHeader: Record "Posted VAT Protocol Header";
            begin
            end;
        }
        field(98; Correction; Boolean)
        {
            Caption = 'Correction';
        }
        field(99; "VAT Protocols"; Integer)
        {
            CalcFormula = Count ("Posted VAT Protocol Header" WHERE("Original Doc. Type" = CONST("Credit Memo"),
                                                                    "Original Doc. No." = FIELD("No."),
                                                                    "Document Type" = CONST(Sale)));
            Caption = 'VAT Protocols';
            FieldClass = FlowField;
        }
        field(100; "Original Doc. Type"; Option)
        {
            Caption = 'Original Doc. Type';
            OptionCaption = '" ,Invoice,Credit Memo"';
            OptionMembers = " ",Invoice,"Credit Memo";
        }
        field(101; "Original Doc. No."; Code[20])
        {
            Caption = 'Original Doc. No.';
            TableRelation = IF ("Document Type" = CONST(Purchase),
                                "Original Doc. Type" = CONST(Invoice)) "Purch. Inv. Header"."No."
            ELSE
            IF ("Document Type" = CONST(Purchase),
                                         "Original Doc. Type" = CONST("Credit Memo")) "Purch. Cr. Memo Hdr."."No."
            ELSE
            IF ("Document Type" = CONST(Sale),
                                                  "Original Doc. Type" = CONST(Invoice)) "Sales Invoice Header"."No."
            ELSE
            IF ("Document Type" = CONST(Sale),
                                                           "Original Doc. Type" = CONST("Credit Memo")) "Sales Cr.Memo Header"."No.";
        }
        field(112; "User ID"; Code[50])
        {
            Caption = 'User ID';
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup();
            var
                LoginMgt: Codeunit "User Management";
            begin
            end;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup();
            begin
                ShowDimensions;
            end;
        }
        field(46015700; "Protocol Type"; Option)
        {
            Caption = 'Protocol Type';
            Description = 'NAVBG8.00';
            Editable = false;
            OptionCaption = '" ,Protocol,Unrealized VAT"';
            OptionMembers = " ",Protocol,"Unrealized VAT";
        }
        field(46015701; "Apply-to Payment Entry"; Integer)
        {
            BlankZero = true;
            Caption = 'Apply-to Payment Entry';
            Description = 'NAVBG8.00';
        }
        field(46015702; "Date of Chargeable Tax"; Date)
        {
            Caption = 'Date on which tax is chargeable';
            Description = 'NAVBG8.00';
        }
        field(46015703; "Protocol Subtype"; Code[20])
        {
            Caption = 'Protocol Subtype';
            Description = 'NAVBG8.00';
            TableRelation = "Document Type".Code;
        }
        field(46015704; "Date of Tax Credit"; Date)
        {
            Caption = 'Date of entitlement to tax credit';
            Description = 'NAVBG8.00';
        }
        field(46015705; "Payment No."; Code[20])
        {
            Caption = 'Payment No.';
            Description = 'NAVBG8.00';
        }
        field(46015706; "Payment Date"; Date)
        {
            Caption = 'Payment Date';
            Description = 'NAVBG8.00';
        }
        field(46015707; "Payment Due"; Decimal)
        {
            Caption = 'Payment Due';
            Description = 'NAVBG8.00';
        }
        field(46015708; "Payment Amount"; Decimal)
        {
            Caption = 'Payment Amount';
            Description = 'NAVBG8.00';
        }
        field(46015709; "VAT Base"; Decimal)
        {
            Caption = 'VAT Base';
            Description = 'NAVBG8.00';
        }
        field(46015710; "VAT %"; Decimal)
        {
            Caption = 'VAT %';
            Description = 'NAVBG8.00';
        }
        field(46015711; "VAT Amount Due"; Decimal)
        {
            Caption = 'VAT Amount Due';
            Description = 'NAVBG8.00';
        }
        field(46015712; "VAT Subject"; Text[30])
        {
            Caption = 'VAT Subject';
            Description = 'NAVBG8.00';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; "Original Doc. Type", "Original Doc. No.", Void)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Document Type", "No.", "Posting Date", Name, Amount, "Original Doc. Type", "Original Doc. No.")
        {
        }
    }

    trigger OnDelete();
    var
        PostedVATProtocolLine: Record "Posted VAT Protocol Line";
        PostedDocDim: Record "Dimension Set Entry";
    begin
        PostedVATProtocolLine.SETRANGE("Document No.", "No.");
        PostedVATProtocolLine.DELETEALL(true);
    end;

    var
        PostVATProtocolHeader: Record "Posted VAT Protocol Header";
        PostVATProtocolLine: Record "Posted VAT Protocol Line";
        Text16200: Label 'The voiding reverses G/L Entries. Do you want to continue?';
        Text16201: Label 'VAT Protocol %1 is already voided.';
        Text16202: Label 'VAT Protocol %1 has been voided.';
        //TODO MISSING Codeunit "VAT Protocol Post
        // PostVATProtocol : Codeunit "VAT Protocol Post";
        DimMgt: Codeunit DimensionManagement;

    procedure PrintRecords(ShowRequestForm: Boolean);
    var
        ReportSelection: Record "Report Selections";
    begin
        with PostVATProtocolHeader do begin
            //MISSING ReportSelection.Usage::BG11, ReportSelection.Usage::BG12   
            /*
             COPY(Rec);
             case "Document Type" of
               "Document Type"::Purchase:
                 if "Protocol Type" = "Protocol Type"::"Unrealized VAT" then
                    ReportSelection.SETRANGE(Usage,ReportSelection.Usage::BG12)
                 else
                   ReportSelection.SETRANGE(Usage,ReportSelection.Usage::BG11);
               "Document Type"::Sale:
                 if "Protocol Type" = "Protocol Type"::"Unrealized VAT" then
                    ReportSelection.SETRANGE(Usage,ReportSelection.Usage::BG12)
                 else
                   ReportSelection.SETRANGE(Usage,ReportSelection.Usage::BG11);

             end;
              */
            ReportSelection.SETFILTER("Report ID", '<>0');
            ReportSelection.FIND('-');
            repeat
                REPORT.RUNMODAL(ReportSelection."Report ID", ShowRequestForm, false, PostVATProtocolHeader);
            until ReportSelection.NEXT = 0;
        end;
    end;

    procedure Navigate();
    var
        NavigatePage: Page Navigate;
    begin
        NavigatePage.SetDoc("Posting Date", "No.");
        NavigatePage.RUN;
    end;

    procedure LineExist(): Boolean;
    begin
        PostVATProtocolLine.RESET;
        PostVATProtocolLine.SETRANGE("Document No.", "No.");
        exit(PostVATProtocolLine.FIND('-'));
    end;

    procedure Voiding();
    var
        VATEntry: Record "VAT Entry";
        Window: Dialog;
    // TODO MISSING "Void Date Input"
    //VoidDateInput: Page "Void Date Input";
    begin
        if Void then
            ERROR(Text16201, "No.");

        if not IsServiceTier then begin
            Window.OPEN(FIELDCAPTION("Void Date") + '#1############');
            //TODO INPUT IS NOT SUPPERTED ANYMORE 
            //if Window.INPUT(1, "Void Date") = 0 then
            exit;
            // end else begin
            //     if VoidDateInput.RUNMODAL = ACTION::OK then
            //         VoidDateInput.GetVoidDate("Void Date");
        end;

        if not CONFIRM(Text16200) then
            exit;
        //TODO MISSING Codeunit "VAT Protocol Post
        //PostVATProtocol.Voiding(Rec);

        Void := true;
        MODIFY;

        MESSAGE(Text16202, "No.");
    end;

    procedure ShowDimensions();
    var
        PostedDocDim: Record "Dimension Set Entry";
    begin
        TESTFIELD("No.");
        DimMgt.ShowDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2', TABLECAPTION, "No."));
    end;
}

