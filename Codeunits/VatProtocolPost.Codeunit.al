codeunit 46015507 "VAT Protocol Post"
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
    // 001   mp       27.10.14                  List of changes :
    //                           NAVBG8.00      Builded from version 6.0
    //                           NAVBG8.00      Changed function : OnRun()
    // ------------------------------------------------------------------------------------------

    Permissions = TableData "Sales Invoice Header" = rimd,
                  TableData "Sales Invoice Line" = rimd,
                  TableData "Sales Cr.Memo Header" = rimd,
                  TableData "Sales Cr.Memo Line" = rimd,
                  TableData "Purch. Inv. Header" = rimd,
                  TableData "Purch. Inv. Line" = rimd,
                  TableData "Purch. Cr. Memo Hdr." = rimd,
                  TableData "Purch. Cr. Memo Line" = rimd,
                  TableData "VAT Entry" = rimd;
    TableNo = "VAT Protocol Header";

    trigger OnRun();
    var
        UpdateAnalysisView: Codeunit "Update Analysis View";
        DimEntryNo: Integer;
        Factor: Integer;
    begin
        CLEARALL;
        VATProtocolHeader.COPY(Rec);

        with VATProtocolHeader do begin

            // Date replace
            if ReplacePostingDate then
                "Posting Date" := PostingDate;
            if ReplaceDocumentDate then
                "Document Date" := PostingDate;

            // VAT Protocol header test
            TESTFIELD("CV No.");
            TESTFIELD("VAT Registration No.");
            TESTFIELD("Document Date");
            TESTFIELD("Posting Date");
            TESTFIELD("Country/Region Code");
            TESTFIELD("Ground For Issue");

            //NAVBG8.00; 001; begin
            if "Protocol Type" = "Protocol Type"::"Unrealized VAT" then begin
                TESTFIELD("Protocol Subtype");
                VATProtocolLine.SETRANGE(Type, VATProtocolLine.Type::Payment);
            end;
            //NAVBG8.00; 001; end

            // VAT Protocol line test
            VATProtocolLine.SETRANGE("Document No.", "No.");
            VATProtocolLine.SETFILTER(Quantity, '<>0');
            if not VATProtocolLine.FIND('-') then
                ERROR(Text001);

            VATProtocolLine.SETRANGE("VAT Amount (LCY)");
            if VATProtocolLine.FIND('-') then
                repeat
                    VATProtocolLine.TESTFIELD("VAT Prod. Posting Group");
                    VATProtocolLine.TESTFIELD("Sales VAT Account");
                    VATProtocolLine.TESTFIELD("Purch. VAT Account");
                    VATProtocolLine.TESTFIELD("No.");
                    VATProtocolLine.TESTFIELD(Quantity);
                    VATProtocolLine.TESTFIELD("VAT Base Amount (LCY)");
                    VATProtocolLine.TESTFIELD("VAT Identifier");
                    VATPostSetup.GET(VATProtocolLine."VAT Bus. Posting Group", VATProtocolLine."VAT Prod. Posting Group");
                    if VATPostSetup."VAT Calculation Type" <> VATPostSetup."VAT Calculation Type"::"Full VAT" then
                        ERROR(Text008, VATProtocolLine."VAT Bus. Posting Group", VATProtocolLine."VAT Prod. Posting Group");
                    if VATProtocolLine."Bal. VAT Bus. Posting Group" <> '' then begin
                        VATPostSetup.GET(VATProtocolLine."Bal. VAT Bus. Posting Group", VATProtocolLine."VAT Prod. Posting Group");
                        VATPostSetup.TESTFIELD("VAT Identifier", VATProtocolLine."VAT Identifier");
                        if VATPostSetup."VAT Calculation Type" <> VATPostSetup."VAT Calculation Type"::"Full VAT" then
                            ERROR(Text008, VATProtocolLine."Bal. VAT Bus. Posting Group", VATProtocolLine."VAT Prod. Posting Group");
                    end;
                until VATProtocolLine.NEXT = 0;

            Window.OPEN(
              '#1#################################\\' +
              Text002 + Text003);

            if "Posting No." = '' then begin
                if "Posting No. Series" = "No. Series" then
                    "Posting No." := "No."
                else
                    "Posting No." := NoSeriesMgt.GetNextNo("Posting No. Series", "Posting Date", true);
                MODIFY;
            end;

            Window.UPDATE(1, STRSUBSTNO(Text007, "No.", "Posting No."));

            // Insert invoice Header or credit memo header
            PostVATProtocolHeader.TRANSFERFIELDS(Rec);
            PostVATProtocolHeader."No." := "Posting No.";
            PostVATProtocolHeader."User ID" := USERID();
            PostVATProtocolHeader."Posting Description" := Text009 + ' ' + PostVATProtocolHeader."No.";
            PostVATProtocolHeader."No. Printed" := 0;
            PostVATProtocolHeader.INSERT;

            //NAVBG8.00; 001; begin
            if "Protocol Type" = "Protocol Type"::"Unrealized VAT" then
                VATProtocolLine.SETRANGE(Type);
            //NAVBG8.00; 001; end

            VATProtocolLine.SETRANGE("Document No.", "No.");
            if VATProtocolLine.FIND('-') then
                repeat
                    Window.UPDATE(2, VATProtocolLine."Line No.");
                    PostVATProtocolLine.TRANSFERFIELDS(VATProtocolLine);
                    PostVATProtocolLine."Document No." := PostVATProtocolHeader."No.";
                    PostVATProtocolLine.INSERT;
                until VATProtocolLine.NEXT = 0;

            //NAVBG8.00; 001; begin
            if "Protocol Type" = "Protocol Type"::"Unrealized VAT" then
                VATProtocolLine.SETRANGE(Type, VATProtocolLine.Type::Payment);
            //NAVBG8.00; 001; end

            // Post purchase and sales VAT to G/L entries from posting buffer
            LineCount := 0;
            if VATProtocolLine.FIND('-') then
                repeat
                    LineCount := LineCount + 1;
                    Window.UPDATE(3, LineCount);

                    GenJnlLine.INIT;
                    GenJnlLine."VAT Subject" := VATProtocolHeader."VAT Subject";
                    GenJnlLine."VAT Protocol" := true;
                    GenJnlLine.VALIDATE("Posting Date", VATProtocolHeader."Posting Date");
                    GenJnlLine."Document Date" := VATProtocolHeader."Document Date";
                    GenJnlLine."VAT Date" := VATProtocolHeader."VAT Date";

                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                    GenJnlLine."Document No." := VATProtocolHeader."Posting No.";
                    GenJnlLine."Dimension Set ID" := VATProtocolLine."Dimension Set ID";

                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                    GenJnlLine.VALIDATE("Account No.", VATProtocolLine."Sales VAT Account");
                    GenJnlLine.Description := VATProtocolLine.Description;
                    GenJnlLine.VALIDATE("Gen. Posting Type", GenJnlLine."Gen. Posting Type"::Sale);
                    GenJnlLine."Gen. Bus. Posting Group" := '';
                    GenJnlLine."Gen. Prod. Posting Group" := '';
                    if "Document Type" = "Document Type"::Purchase then begin
                        GenJnlLine.VALIDATE("VAT Bus. Posting Group", VATProtocolLine."Bal. VAT Bus. Posting Group");
                        GenJnlLine."VAT Type" := GenJnlLine."VAT Type"::Purchase;
                    end else begin
                        GenJnlLine.VALIDATE("VAT Bus. Posting Group", VATProtocolLine."VAT Bus. Posting Group");
                        GenJnlLine."VAT Type" := GenJnlLine."VAT Type"::Sale;
                    end;

                    GenJnlLine.VALIDATE("VAT Prod. Posting Group", VATProtocolLine."VAT Prod. Posting Group");

                    GenJnlLine.VALIDATE(Correction, VATProtocolHeader.Correction);
                    if VATProtocolHeader.Correction then begin
                        GenJnlLine.VALIDATE(Amount, VATProtocolLine."VAT Amount (LCY)");
                        GenJnlLine."VAT Protocol Base Amount (LCY)" := VATProtocolLine."VAT Base Amount (LCY)";
                    end else begin
                        GenJnlLine.VALIDATE(Amount, -VATProtocolLine."VAT Amount (LCY)");
                        GenJnlLine."VAT Protocol Base Amount (LCY)" := -VATProtocolLine."VAT Base Amount (LCY)";
                    end;

                    GenJnlLine."Bal. Account Type" := GenJnlLine."Account Type"::"G/L Account";
                    GenJnlLine.VALIDATE("Bal. Account No.", VATProtocolLine."Purch. VAT Account");
                    GenJnlLine."Bal. Gen. Posting Type" := 0;
                    GenJnlLine."Bal. Gen. Bus. Posting Group" := '';
                    GenJnlLine."Bal. Gen. Prod. Posting Group" := '';
                    GenJnlLine."Bal. VAT Bus. Posting Group" := '';
                    GenJnlLine."Bal. VAT Prod. Posting Group" := '';
                    if "Document Type" = "Document Type"::Purchase then begin
                        GenJnlLine."Bal. Gen. Posting Type" := GenJnlLine."Bal. Gen. Posting Type"::Purchase;
                        GenJnlLine.VALIDATE("Bal. VAT Bus. Posting Group", VATProtocolLine."VAT Bus. Posting Group");
                        GenJnlLine.VALIDATE("Bal. VAT Prod. Posting Group", VATProtocolLine."VAT Prod. Posting Group");
                    end;

                    GenJnlLine."Posting No. Series" := VATProtocolHeader."Posting No. Series";
                    GenJnlLine.VALIDATE("Bill-to/Pay-to No.", VATProtocolHeader."CV No.");
                    GenJnlLine."VAT Registration No." := "VAT Registration No.";
                    GenJnlLine."Country/Region Code" := VATProtocolHeader."Country/Region Code";
                    GenJnlLine."System-Created Entry" := true;
                    if SourceCodeSetup.GET then
                        GenJnlLine."Source Code" := SourceCodeSetup."VAT Protocol";

                    RunGenJnlPostLine(GenJnlLine, DimEntryNo);

                until VATProtocolLine.NEXT = 0;

            MarkPostedDocument;

            "Last Posting No." := "Posting No.";
            "Posting No." := '';

            VATProtocolHeader.DELETE(true);

            CLEAR(GenJnlPostLine);
            Window.CLOSE;
        end;

        UpdateAnalysisView.UpdateAll(0, true);
        Rec := VATProtocolHeader;
    end;

    var
        VATPostSetup: Record "VAT Posting Setup";
        VATEntry: Record "VAT Entry";
        VATProtocolHeader: Record "VAT Protocol Header";
        PostVATProtocolHeader: Record "Posted VAT Protocol Header";
        PostVATProtocolLine: Record "Posted VAT Protocol Line";
        VATProtocolLine: Record "VAT Protocol Line";
        GenJnlLine: Record "Gen. Journal Line";
        DocDim: Record "Dimension Set Entry";
        TempDocDim: Record "Dimension Set Entry" temporary;
        TempBuffDim: Record "Dimension Buffer" temporary;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DimMgt: Codeunit DimensionManagement;
        DimBufMgt: Codeunit "Dimension Buffer Management";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        Text001: Label 'There is nothing to post.';
        Text002: Label 'Posting lines              #2######\';
        Text003: Label 'Posting purchases and VAT  #3######\';
        Text007: Label '%1 -> VAT Protocol %2';
        LineCount: Integer;
        LastVATEntryNoBefore: Integer;
        LastVATEntryNoAfter: Integer;
        Window: Dialog;
        PostingDate: Date;
        EmptyInvoice: Boolean;
        Text008: Label 'You have to define Full VAT for VAT Posting Setup %1 %2';
        Text009: Label 'VAT Protocol';
        ReplacePostingDate: Boolean;
        ReplaceDocumentDate: Boolean;
        Text010: Label 'Corrective VAT Protocol';
        Text032: Label 'The combination of dimensions used in %1 %2 is blocked. %3';
        Text033: Label 'The combination of dimensions used in %1 %2, line no. %3 is blocked. %4';
        Text034: Label 'The dimensions used in %1 %2 are invalid. %3';
        Text035: Label 'The dimensions used in %1 %2, line no. %3 are invalid. %4';
        VATProtocolLineBuf: array[2] of Record "VAT Protocol Line";
        SourceCodeSetup: Record "Source Code Setup";
        Text011: Label 'Voiding VAT Protocol %1';
        Text012: Label 'Voiding lines            #2######\';
        Text013: Label 'Reversing General Ledger #3######\';
        Text014: Label 'Void: %1';

    local procedure RunGenJnlPostLine(var GenJnlLine: Record "Gen. Journal Line"; DimEntryNo: Integer);
    var
        TempDimBuf: Record "Dimension Buffer" temporary;
    begin
        GenJnlPostLine.RunWithCheck(GenJnlLine);
    end;

    procedure SetPostingDate(NewReplacePostingDate: Boolean; NewReplaceDocumentDate: Boolean; NewPostingDate: Date);
    begin
        ReplacePostingDate := NewReplacePostingDate;
        ReplaceDocumentDate := NewReplaceDocumentDate;
        PostingDate := NewPostingDate;
    end;

    procedure Voiding(var Rec: Record "Posted VAT Protocol Header");
    var
        DimEntryNo: Integer;
    begin
        CLEARALL;
        PostVATProtocolHeader.COPY(Rec);

        with PostVATProtocolHeader do begin

            Window.OPEN(
              '#1#################################\\' +
              Text012 + Text013);

            Window.UPDATE(1, STRSUBSTNO(Text011, "No."));

            // Post reversed G/L entries
            LineCount := 0;
            PostVATProtocolLine.SETRANGE("Document No.", "No.");
            if PostVATProtocolLine.FIND('-') then
                repeat
                    LineCount := LineCount + 1;
                    Window.UPDATE(3, LineCount);


                    GenJnlLine.INIT;
                    GenJnlLine.VALIDATE("Posting Date", "Void Date");
                    GenJnlLine."Document Date" := "Void Date";
                    GenJnlLine."VAT Date" := "VAT Date";

                    GenJnlLine."Dimension Set ID" := PostVATProtocolLine."Dimension Set ID"; //LLP
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                    GenJnlLine."Document No." := "No.";

                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                    GenJnlLine.VALIDATE("Account No.", PostVATProtocolLine."Sales VAT Account");
                    GenJnlLine.Description :=
                      COPYSTR(STRSUBSTNO(Text014, PostVATProtocolLine.Description), 1, MAXSTRLEN(PostVATProtocolLine.Description));
                    GenJnlLine.VALIDATE("Gen. Posting Type", 0);
                    GenJnlLine.VALIDATE("VAT Bus. Posting Group", '');
                    GenJnlLine.VALIDATE("VAT Prod. Posting Group", '');

                    GenJnlLine.VALIDATE(Correction, not Correction);
                    GenJnlLine.VALIDATE(Amount, PostVATProtocolLine."VAT Amount (LCY)");
                    GenJnlLine."VAT Protocol Base Amount (LCY)" := PostVATProtocolLine."VAT Base Amount (LCY)";

                    GenJnlLine."Bal. Account Type" := GenJnlLine."Account Type"::"G/L Account";
                    GenJnlLine.VALIDATE("Bal. Account No.", PostVATProtocolLine."Purch. VAT Account");
                    GenJnlLine.VALIDATE("Bal. Gen. Posting Type", 0);
                    GenJnlLine.VALIDATE("Bal. VAT Bus. Posting Group", '');
                    GenJnlLine.VALIDATE("Bal. VAT Prod. Posting Group", '');

                    GenJnlLine."Posting No. Series" := "Posting No. Series";
                    GenJnlLine."VAT Registration No." := "VAT Registration No.";
                    GenJnlLine."Country/Region Code" := "Country/Region Code";
                    GenJnlLine."System-Created Entry" := true;
                    if SourceCodeSetup.GET then
                        GenJnlLine."Source Code" := SourceCodeSetup."VAT Protocol";

                    RunGenJnlPostLine(GenJnlLine, DimEntryNo);

                until PostVATProtocolLine.NEXT = 0;

            // Voiding VAT Entries
            VATEntry.RESET;
            VATEntry.SETRANGE("Document No.", "No.");
            VATEntry.SETRANGE("Posting Date", "Posting Date");
            VATEntry.SETRANGE("VAT Protocol", true);
            if VATEntry.FIND('-') then
                repeat
                    VATEntry.Void := true;
                    VATEntry."Void Date" := "Void Date";
                    VATEntry.MODIFY;
                until VATEntry.NEXT = 0;

            CLEAR(GenJnlPostLine);
            Window.CLOSE;
        end;

        Rec := PostVATProtocolHeader;
    end;

    procedure MarkPostedDocument();
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    begin
        with VATProtocolHeader do begin
            if ("Original Doc. No." = '') or ("Original Doc. Type" = 0) then
                exit;

            case "Document Type" of
                "Document Type"::Purchase:
                    if "Original Doc. Type" = "Original Doc. Type"::Invoice then begin
                        if PurchInvHeader.GET("Original Doc. No.") then begin
                            PurchInvHeader."VAT Protocol" := true;
                            PurchInvHeader.MODIFY;
                        end;
                    end else
                        if PurchCrMemoHeader.GET("Original Doc. No.") then begin
                            PurchCrMemoHeader."VAT Protocol" := true;
                            PurchCrMemoHeader.MODIFY;
                        end;
                "Document Type"::Sale:
                    if "Original Doc. Type" = "Original Doc. Type"::Invoice then begin
                        if SalesInvHeader.GET("Original Doc. No.") then begin
                            SalesInvHeader."VAT Protocol" := true;
                            SalesInvHeader.MODIFY;
                        end;
                    end else
                        if SalesCrMemoHeader.GET("Original Doc. No.") then begin
                            SalesCrMemoHeader."VAT Protocol" := true;
                            SalesCrMemoHeader.MODIFY;
                        end;
            end;
        end;
    end;
}

