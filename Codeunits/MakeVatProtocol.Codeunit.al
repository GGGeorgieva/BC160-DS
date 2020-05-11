codeunit 46015510 "Make VAT Protocol"
{
    // version NAVBG11.0

    // -----------------------------------------------------------------------------------------
    // XAPT Solutions
    // MS Dynamics NAV 2015 Localisation
    // 
    // mp  : Mile Petachki
    // version : NAVBG8.00, BCS8.00.109
    // 
    // -----------------------------------------------------------------------------------------
    // No.   Sign     Date       Version        Description
    // -----------------------------------------------------------------------------------------
    // 001   mp       27.10.14                  List of changes :
    //                           NAVBG8.00      Builded from version 6.0
    //                           NAVBG8.00      Changed function : SalesInvoice()
    //                           NAVBG8.00      Changed function : SalesCrMemo()
    //                           NAVBG8.00      Changed function : PurchInvoice()
    //                           NAVBG8.00      Changed function : PurchCrMemo()
    //                           NAVBG8.00      Changed function : MakeVATProtocolHeader()
    //                           NAVBG8.00      Changed function : MakeVATProtocolLine()
    // -----------------------------------------------------------------------------------------
    // Dynamic Solutions
    // MS Dynamics NAV 2017 Localisation
    // 
    // 
    // -----------------------------------------------------------------------------------------
    // No.   Sign     Date       Version        Description
    // -----------------------------------------------------------------------------------------
    // 001                                     List of changes :
    //                         NAVBG11.0       Changed function : VATProtocol()
    //                         NAVBG11.0       Changed variable OldVATProtocolHeader subtype
    //                         NAVBG11.0       Changed function : PurchInvoice()
    // 
    // ------------------------------------------------------------------------------------------


    trigger OnRun();
    begin
    end;

    var
        LineNo: Integer;
        Text001: Label 'EU - VAT Groups: %1 %2';
        TempVATProtocolLine: Record "VAT Protocol Line";
        CreateVATProtocolHeader: Boolean;
        CVNo: Code[20];
        Text004: Label 'There is one or more lines in VAT Protocol No. %1. All lines will be deleted and replaced with lines from %2 No. %3. Do you really want to proceed?';
        Text005: Label 'Action has been stopped.';
        CurrVATProtocolHeader: Record "VAT Protocol Header";
        GAMT2: Decimal;
        CurrExchRate: Record "Currency Exchange Rate";
        Text50001: Label 'Remaining amount to pay';
        Text50002: Label 'Unable to calculate VAT protocol line VAT Prod. Posting Group';

    procedure VATProtocol(PostedVATProtocolHeader: Record "Posted VAT Protocol Header"; var VATProtocolHeader: Record "VAT Protocol Header"; CompressLines: Boolean; IncludeHeader: Boolean);
    var
        OldVATProtocolHeader: Record "VAT Protocol Header";
        VATProtocolLine: Record "VAT Protocol Line";
        PostedVATProtocolLine: Record "Posted VAT Protocol Line";
        OldVATProtocolLine: Record "VAT Protocol Line";
        LineNo: Integer;
    begin
        with VATProtocolHeader do begin
            // Header
            if IncludeHeader then begin
                VATProtocolLine.SETRANGE("Document No.", VATProtocolHeader."No.");
                if not VATProtocolLine.ISEMPTY then begin
                    if not CONFIRM(Text004, true, "No.", PostedVATProtocolHeader.TABLECAPTION, PostedVATProtocolHeader."No.") then
                        ERROR(Text005);
                    VATProtocolLine.DELETEALL(true);
                end;
                OldVATProtocolHeader.COPY(VATProtocolHeader);
                TRANSFERFIELDS(PostedVATProtocolHeader);
                "Document Type" := OldVATProtocolHeader."Document Type";
                "No." := OldVATProtocolHeader."No.";
                "Posting Date" := OldVATProtocolHeader."Posting Date";
                "Corr. VAT Protocol No." := OldVATProtocolHeader."Corr. VAT Protocol No.";
                "No. Series" := OldVATProtocolHeader."No. Series";
                "Posting No. Series" := OldVATProtocolHeader."Posting No. Series";
                "Posting No." := '';
                "Original Doc. Type" := 0;
                "Original Doc. No." := '';
                MODIFY;
            end;

            // Lines
            if VATProtocolLine.FIND('+') then
                LineNo := VATProtocolLine."Line No.";
            PostedVATProtocolLine.SETRANGE("Document No.", PostedVATProtocolHeader."No.");
            if PostedVATProtocolLine.FIND('-') then
                repeat
                    if CompressLines then begin
                        VATProtocolLine.SETCURRENTKEY("VAT Prod. Posting Group");
                        VATProtocolLine.SETRANGE("Document No.", VATProtocolHeader."No.");
                        VATProtocolLine.SETRANGE("VAT Prod. Posting Group", PostedVATProtocolLine."VAT Prod. Posting Group");
                    end else begin
                        VATProtocolLine.RESET;
                        VATProtocolLine.SETRANGE("Document No.");
                        VATProtocolLine.SETRANGE("VAT Prod. Posting Group");
                    end;

                    if CompressLines and VATProtocolLine.FIND('-') then begin
                        OldVATProtocolLine := VATProtocolLine;
                        if not VATProtocolLine.Compressed then
                            VATProtocolLine.VALIDATE(Compressed, true);
                        VATProtocolLine.VALIDATE("VAT Base Amount (LCY)",
                          VATProtocolLine."VAT Base Amount (LCY)" + PostedVATProtocolLine."VAT Base Amount (LCY)");
                        VATProtocolLine.MODIFY;
                    end else begin
                        LineNo := LineNo + 10000;
                        VATProtocolLine.INIT;
                        VATProtocolLine.TRANSFERFIELDS(PostedVATProtocolLine);
                        VATProtocolLine."Line No." := LineNo;
                        VATProtocolLine."Document Type" := "Document Type";
                        VATProtocolLine."Document No." := "No.";
                        VATProtocolLine.INSERT;
                    end;
                until PostedVATProtocolLine.NEXT = 0;
        end;
    end;

    procedure PurchInvoice(PurchInvHeader: Record "Purch. Inv. Header"; VATProtocolHeaderReq: Record "VAT Protocol Header"; NewDocPerInvoice: Boolean; CompressLines: Boolean; IncludeHeader: Boolean; CopyMode: Boolean);
    var
        PurchInvLine: Record "Purch. Inv. Line";
        VATProtocolHeader: Record "VAT Protocol Header";
        VATProtocolLine: Record "VAT Protocol Line";
        lAmt1: Decimal;
        lVATProtocolLine: Record "VAT Protocol Line";
        VendLedgerEntry: Record "Vendor Ledger Entry";
        LastVATProdPostGroup: Code[20];
        DifferentPurchLinePostGroups: Boolean;
    begin

        //NAVBG8.00; 001; begin
        if VATProtocolHeaderReq."Protocol Type" = VATProtocolHeaderReq."Protocol Type"::"Unrealized VAT" then
            PurchInvHeader.TESTFIELD("Unrealized VAT", true)
        else
            PurchInvHeader.TESTFIELD("Unrealized VAT", false);
        //NAVBG8.00; 001; end

        if (CVNo <> PurchInvHeader."Buy-from Vendor No.") or NewDocPerInvoice then begin
            CVNo := PurchInvHeader."Buy-from Vendor No.";
            CreateVATProtocolHeader := true;
            LineNo := 0;
        end;

        if CopyMode then begin
            VATProtocolHeader.GET(VATProtocolHeaderReq."No.");
            CurrVATProtocolHeader := VATProtocolHeader;
            VATProtocolLine.SETRANGE("Document No.", VATProtocolHeaderReq."No.");
            if VATProtocolLine.FIND('+') then
                LineNo := VATProtocolLine."Line No.";
        end;
        //NAVBG110.0; 001; begin
        LastVATProdPostGroup := '';
        DifferentPurchLinePostGroups := false;
        //NAVBG110.0; 001; end
        PurchInvLine.SETRANGE("Document No.", PurchInvHeader."No.");
        PurchInvLine.SETRANGE(Type, PurchInvLine.Type::"G/L Account", PurchInvLine.Type::"Charge (Item)");
        PurchInvLine.SETFILTER(PurchInvLine.Quantity, '<>%1', 0);

        if PurchInvLine.FIND('-') then begin
            if CreateVATProtocolHeader and IncludeHeader then begin
                VATProtocolLine.SETRANGE("Document No.", VATProtocolHeader."No.");
                if not VATProtocolLine.ISEMPTY then begin
                    if not CONFIRM(Text004, true, VATProtocolHeader."No.", PurchInvHeader.TABLECAPTION, PurchInvHeader."No.") then
                        ERROR('');
                    VATProtocolLine.DELETEALL(true);
                end;
                MakeVATProtocolHeader(VATProtocolHeaderReq, VATProtocolHeader, CVNo, 0);
                VATProtocolHeader."Original Doc. Type" := VATProtocolHeader."Original Doc. Type"::Invoice;
                VATProtocolHeader."Original Doc. No." := PurchInvHeader."No.";
                VATProtocolHeader."Ground For VAT Exempt" := PurchInvHeader."VAT Exempt Ground";

                VATProtocolHeader."Document Date" := PurchInvHeader."Posting Date";

                VATProtocolHeader."Posting Date" := PurchInvHeader."Posting Date";
                VATProtocolHeader."VAT Date" := PurchInvHeader."Posting Date";
                VATProtocolHeader."VAT Subject" := PurchInvHeader."VAT Subject";

                if CopyMode then
                    VATProtocolHeader.MODIFY(true)
                else
                    VATProtocolHeader.INSERT(true);
                CurrVATProtocolHeader := VATProtocolHeader;
                CreateVATProtocolHeader := false;
            end;
            lAmt1 := 0;
            GAMT2 := 0;
            repeat
                //TODO MISSING METHOD CopyToVATProtocolLine IN PurchInvLine TABLE
                //  PurchInvLine.CopyToVATProtocolLine(PurchInvHeader,TempVATProtocolLine);
                MakeVATProtocolLine(TempVATProtocolLine, CurrVATProtocolHeader, LineNo, CompressLines);
                //NAVBG8.00.008 begin
                if (LastVATProdPostGroup <> '') and (LastVATProdPostGroup <> TempVATProtocolLine."VAT Prod. Posting Group") then
                    DifferentPurchLinePostGroups := true;
                LastVATProdPostGroup := TempVATProtocolLine."VAT Prod. Posting Group";
            //NAVBG8.00.008 end

            until PurchInvLine.NEXT = 0;


            //NAVBG8.00; 001; begin
            VendLedgerEntry.RESET;
            VendLedgerEntry.SETRANGE("Vendor No.", PurchInvHeader."Buy-from Vendor No.");
            VendLedgerEntry.SETRANGE("Document Type", VendLedgerEntry."Document Type"::Invoice);
            VendLedgerEntry.SETRANGE("Document No.", PurchInvHeader."No.");
            if VendLedgerEntry.FINDFIRST and
            (VATProtocolHeaderReq."Protocol Type" = VATProtocolHeaderReq."Protocol Type"::"Unrealized VAT") then begin
                VendLedgerEntry.CALCFIELDS("Remaining Amount");
                if ABS(VendLedgerEntry."Remaining Amount") > 0 then begin
                    TempVATProtocolLine.INIT;
                    TempVATProtocolLine."Document No." := VATProtocolHeaderReq."No.";
                    TempVATProtocolLine."Line No." := LineNo + 10000;
                    TempVATProtocolLine.Type := TempVATProtocolLine.Type::Payment;
                    TempVATProtocolLine.Description := Text50001;
                    TempVATProtocolLine.Quantity := 1;
                    TempVATProtocolLine."Document Type" := VATProtocolHeaderReq."Document Type";
                    //NAVBG11.0; 001; begin
                    if DifferentPurchLinePostGroups then
                        ERROR(Text50002);
                    //NAVBG11.0; 001; end
                    TempVATProtocolLine."VAT Prod. Posting Group" := LastVATProdPostGroup;
                    TempVATProtocolLine.VALIDATE("VAT Bus. Posting Group", VATProtocolHeaderReq."VAT Bus. Posting Group");
                    TempVATProtocolLine.VALIDATE("Bal. VAT Bus. Posting Group", VATProtocolHeaderReq."Bal. VAT Bus. Posting Group");

                    if TempVATProtocolLine."VAT %" = 0 then
                        TempVATProtocolLine.VALIDATE("VAT Base Amount (LCY)", ABS(VendLedgerEntry."Remaining Amount"))
                    else
                        TempVATProtocolLine.VALIDATE("VAT Base Amount (LCY)", ABS(VendLedgerEntry."Remaining Amount")
                        / ((100 + TempVATProtocolLine."VAT %") / 100));

                    TempVATProtocolLine.INSERT;
                end;
            end;
            //NAVBG8.00; 001; end

            if not CompressLines then begin
                lAmt1 := CheckAmt(PurchInvHeader);
                if lAmt1 <> GAMT2 then begin
                    lVATProtocolLine.SETCURRENTKEY("VAT Prod. Posting Group");
                    lVATProtocolLine.SETRANGE("Document No.", VATProtocolHeader."No.");
                    if lVATProtocolLine.FINDLAST then begin
                        lVATProtocolLine."VAT Amount (LCY)" := lVATProtocolLine."VAT Amount (LCY)" + (lAmt1 - GAMT2);
                        lVATProtocolLine.MODIFY;
                    end;
                end;
            end;
        end;
    end;

    procedure PurchCrMemo(PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr."; VATProtocolHeaderReq: Record "VAT Protocol Header"; NewDocPerCrMemo: Boolean; CompressLines: Boolean; IncludeHeader: Boolean; CopyMode: Boolean);
    var
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        VATProtocolHeader: Record "VAT Protocol Header";
        VATProtocolLine: Record "VAT Protocol Line";
    begin

        //NAVBG8.00; 001; begin
        if VATProtocolHeaderReq."Protocol Type" = VATProtocolHeaderReq."Protocol Type"::"Unrealized VAT" then
            PurchCrMemoHeader.TESTFIELD("Unrealized VAT", true)
        else
            PurchCrMemoHeader.TESTFIELD("Unrealized VAT", false);
        //NAVBG8.00; 001; end

        if EUDocument(PurchCrMemoHeader."VAT Country/Region Code") then begin
            if (CVNo <> PurchCrMemoHeader."Buy-from Vendor No.") or NewDocPerCrMemo then begin
                CVNo := PurchCrMemoHeader."Buy-from Vendor No.";
                CreateVATProtocolHeader := true;
                LineNo := 0;
            end;

            if CopyMode then begin
                VATProtocolHeader.GET(VATProtocolHeaderReq."No.");
                CurrVATProtocolHeader := VATProtocolHeader;
                VATProtocolLine.SETRANGE("Document No.", VATProtocolHeaderReq."No.");
                if VATProtocolLine.FIND('+') then
                    LineNo := VATProtocolLine."Line No.";
            end;
            PurchCrMemoLine.SETRANGE("Document No.", PurchCrMemoHeader."No.");
            PurchCrMemoLine.SETRANGE(Type, PurchCrMemoLine.Type::"G/L Account", PurchCrMemoLine.Type::"Charge (Item)");
            if PurchCrMemoLine.FIND('-') then begin
                if CreateVATProtocolHeader and IncludeHeader then begin
                    VATProtocolLine.SETRANGE("Document No.", VATProtocolHeader."No.");
                    if not VATProtocolLine.ISEMPTY then begin
                        if not CONFIRM(Text004, true, VATProtocolHeader."No.", PurchCrMemoHeader.TABLECAPTION, PurchCrMemoHeader."No.") then
                            ERROR('');
                        VATProtocolLine.DELETEALL(true);
                    end;
                    MakeVATProtocolHeader(VATProtocolHeaderReq, VATProtocolHeader, CVNo, 0);
                    VATProtocolHeader."Original Doc. Type" := VATProtocolHeader."Original Doc. Type"::"Credit Memo";
                    VATProtocolHeader."Original Doc. No." := PurchCrMemoHeader."No.";
                    VATProtocolHeader."Ground For VAT Exempt" := PurchCrMemoHeader."VAT Exempt Ground";
                    VATProtocolHeader."VAT Subject" := PurchCrMemoHeader."VAT Subject";
                    VATProtocolHeader.Correction := true;

                    //NAVBG8.00; mp ; single
                    VATProtocolHeader."EU 3-Party Trade" := PurchCrMemoHeader."EU 3-Party Trade";

                    if CopyMode then
                        VATProtocolHeader.MODIFY(true)
                    else
                        VATProtocolHeader.INSERT(true);

                    CurrVATProtocolHeader := VATProtocolHeader;
                    CreateVATProtocolHeader := false;
                end;
                repeat
                    //TODO MISSING METHOD CopyToVATProtocolLine IN PurchCrMemoLine TABLE
                    //  PurchCrMemoLine.CopyToVATProtocolLine(PurchCrMemoHeader,TempVATProtocolLine);
                    MakeVATProtocolLine(TempVATProtocolLine, CurrVATProtocolHeader, LineNo, CompressLines);
                until PurchCrMemoLine.NEXT = 0
            end;
        end;
    end;

    procedure SalesInvoice(SalesInvHeader: Record "Sales Invoice Header"; VATProtocolHeaderReq: Record "VAT Protocol Header"; NewDocPerInvoice: Boolean; CompressLines: Boolean; IncludeHeader: Boolean; CopyMode: Boolean);
    var
        SalesInvLine: Record "Sales Invoice Line";
        VATProtocolHeader: Record "VAT Protocol Header";
        CustomerNo: Code[20];
        VATProtocolLine: Record "VAT Protocol Line";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        LastVATProdPostGroup: Code[20];
    begin

        //NAVBG8.00; 001; begin
        if VATProtocolHeaderReq."Protocol Type" = VATProtocolHeaderReq."Protocol Type"::"Unrealized VAT" then
            SalesInvHeader.TESTFIELD("Unrealized VAT", true)
        else
            SalesInvHeader.TESTFIELD("Unrealized VAT", false);
        //NAVBG8.00; 001; end

        if EUDocument(SalesInvHeader."VAT Country/Region Code") then begin
            if (CVNo <> SalesInvHeader."Sell-to Customer No.") or NewDocPerInvoice then begin
                CVNo := SalesInvHeader."Sell-to Customer No.";
                CreateVATProtocolHeader := true;
                LineNo := 0;
            end;

            if CopyMode then begin
                VATProtocolHeader.GET(VATProtocolHeaderReq."No.");
                CurrVATProtocolHeader := VATProtocolHeader;
                VATProtocolLine.SETRANGE("Document No.", VATProtocolHeaderReq."No.");
                if VATProtocolLine.FIND('+') then
                    LineNo := VATProtocolLine."Line No.";
            end;
            SalesInvLine.SETRANGE("Document No.", SalesInvHeader."No.");
            SalesInvLine.SETRANGE(Type, SalesInvLine.Type::"G/L Account", SalesInvLine.Type::"Charge (Item)");
            SalesInvLine.SETFILTER(SalesInvLine.Quantity, '<>%1', 0);

            if SalesInvLine.FIND('-') then begin
                if CreateVATProtocolHeader and IncludeHeader then begin
                    VATProtocolLine.SETRANGE("Document No.", VATProtocolHeader."No.");
                    if not VATProtocolLine.ISEMPTY then begin
                        if not CONFIRM(Text004, true, VATProtocolHeader."No.", SalesInvHeader.TABLECAPTION, SalesInvHeader."No.") then
                            ERROR('');
                        VATProtocolLine.DELETEALL(true);
                    end;
                    MakeVATProtocolHeader(VATProtocolHeaderReq, VATProtocolHeader, CVNo, 1);
                    if NewDocPerInvoice then begin
                        VATProtocolHeader."Original Doc. Type" := VATProtocolHeader."Original Doc. Type"::Invoice;
                        VATProtocolHeader."Original Doc. No." := SalesInvHeader."No.";
                        VATProtocolHeader."Ground For VAT Exempt" := SalesInvHeader."VAT Exempt Ground";
                    end;
                    if CopyMode then
                        VATProtocolHeader.MODIFY(true)
                    else
                        VATProtocolHeader.INSERT(true);

                    CurrVATProtocolHeader := VATProtocolHeader;
                    CreateVATProtocolHeader := false;
                end;
                repeat
                    //TODO MISSING METHOD CopyToVATProtocolLine IN SalesInvLine TABLE
                    //  SalesInvLine.CopyToVATProtocolLine(SalesInvHeader,TempVATProtocolLine);
                    MakeVATProtocolLine(TempVATProtocolLine, CurrVATProtocolHeader, LineNo, CompressLines);
                until SalesInvLine.NEXT = 0;

                //NAVBG8.00; 001; begin
                CustLedgerEntry.RESET;
                CustLedgerEntry.SETRANGE("Customer No.", SalesInvHeader."Bill-to Customer No.");
                CustLedgerEntry.SETRANGE("Document Type", CustLedgerEntry."Document Type"::Invoice);
                CustLedgerEntry.SETRANGE("Document No.", SalesInvHeader."No.");
                if CustLedgerEntry.FINDFIRST and
                (VATProtocolHeaderReq."Protocol Type" = VATProtocolHeaderReq."Protocol Type"::"Unrealized VAT") then begin
                    CustLedgerEntry.CALCFIELDS("Remaining Amount");
                    if ABS(CustLedgerEntry."Remaining Amount") > 0 then begin
                        TempVATProtocolLine.INIT;
                        TempVATProtocolLine."Document No." := VATProtocolHeaderReq."No.";
                        TempVATProtocolLine."Line No." := LineNo + 10000;
                        TempVATProtocolLine.Type := TempVATProtocolLine.Type::Payment;
                        TempVATProtocolLine.Description := Text50001;
                        TempVATProtocolLine.Quantity := 1;
                        TempVATProtocolLine."Document Type" := VATProtocolHeaderReq."Document Type";
                        TempVATProtocolLine."VAT Prod. Posting Group" := LastVATProdPostGroup;
                        TempVATProtocolLine.VALIDATE("VAT Bus. Posting Group", VATProtocolHeaderReq."VAT Bus. Posting Group");
                        TempVATProtocolLine.VALIDATE("Bal. VAT Bus. Posting Group", VATProtocolHeaderReq."Bal. VAT Bus. Posting Group");

                        if TempVATProtocolLine."VAT %" = 0 then
                            TempVATProtocolLine.VALIDATE("VAT Base Amount (LCY)", ABS(CustLedgerEntry."Remaining Amount"))
                        else
                            TempVATProtocolLine.VALIDATE("VAT Base Amount (LCY)", ABS(CustLedgerEntry."Remaining Amount")
                            / ((100 + TempVATProtocolLine."VAT %") / 100));

                        TempVATProtocolLine.INSERT;
                    end;
                end;
                //NAVBG8.00; 001; end

            end;
        end;
    end;

    procedure SalesCrMemo(SalesCrMemoHeader: Record "Sales Cr.Memo Header"; VATProtocolHeaderReq: Record "VAT Protocol Header"; NewDocPerCrMemo: Boolean; CompressLines: Boolean; IncludeHeader: Boolean; CopyMode: Boolean);
    var
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        VATProtocolHeader: Record "VAT Protocol Header";
        VATProtocolLine: Record "VAT Protocol Line";
    begin

        //NAVBG8.00; 001; begin
        if VATProtocolHeaderReq."Protocol Type" = VATProtocolHeaderReq."Protocol Type"::"Unrealized VAT" then
            SalesCrMemoHeader.TESTFIELD("Unrealized VAT", true)
        else
            SalesCrMemoHeader.TESTFIELD("Unrealized VAT", false);
        //NAVBG8.00; 001; end

        if EUDocument(SalesCrMemoHeader."VAT Country/Region Code") then begin
            if (CVNo <> SalesCrMemoHeader."Sell-to Customer No.") or NewDocPerCrMemo then begin
                CVNo := SalesCrMemoHeader."Sell-to Customer No.";
                CreateVATProtocolHeader := true;
                LineNo := 0;
            end;

            if CopyMode then begin
                VATProtocolHeader.GET(VATProtocolHeaderReq."No.");
                CurrVATProtocolHeader := VATProtocolHeader;
                VATProtocolLine.SETRANGE("Document No.", VATProtocolHeaderReq."No.");
                if VATProtocolLine.FIND('+') then
                    LineNo := VATProtocolLine."Line No.";
            end;
            SalesCrMemoLine.SETRANGE("Document No.", SalesCrMemoHeader."No.");
            SalesCrMemoLine.SETRANGE(Type, SalesCrMemoLine.Type::"G/L Account", SalesCrMemoLine.Type::"Charge (Item)");
            if SalesCrMemoLine.FIND('-') then begin
                if CreateVATProtocolHeader and IncludeHeader then begin
                    VATProtocolLine.SETRANGE("Document No.", VATProtocolHeader."No.");
                    if not VATProtocolLine.ISEMPTY then begin
                        if not CONFIRM(Text004, true, VATProtocolHeader."No.", SalesCrMemoHeader.TABLECAPTION, SalesCrMemoHeader."No.") then
                            ERROR('');
                        VATProtocolLine.DELETEALL(true);
                    end;
                    MakeVATProtocolHeader(VATProtocolHeaderReq, VATProtocolHeader, CVNo, 1);
                    if NewDocPerCrMemo then begin
                        VATProtocolHeader."Original Doc. Type" := VATProtocolHeader."Original Doc. Type"::"Credit Memo";
                        VATProtocolHeader."Original Doc. No." := SalesCrMemoHeader."No.";
                        VATProtocolHeader."Ground For VAT Exempt" := SalesCrMemoHeader."VAT Exempt Ground";
                    end;
                    if CopyMode then
                        VATProtocolHeader.MODIFY(true)
                    else
                        VATProtocolHeader.INSERT(true);

                    CurrVATProtocolHeader := VATProtocolHeader;
                    CreateVATProtocolHeader := false;
                end;
                repeat
                    //TODO MISSING METHOD CopyToVATProtocolLine IN SalesCrMemoLine TABLE 
                    //  SalesCrMemoLine.CopyToVATProtocolLine(SalesCrMemoHeader,TempVATProtocolLine);
                    MakeVATProtocolLine(TempVATProtocolLine, CurrVATProtocolHeader, LineNo, CompressLines);
                until SalesCrMemoLine.NEXT = 0
            end;
        end;
    end;

    procedure MakeVATProtocolHeader(VATProtocolHeaderReq: Record "VAT Protocol Header"; var VATProtocolHeader: Record "VAT Protocol Header"; CVNo: Code[20]; DocType: Option);
    begin
        VATProtocolHeader.INIT;
        VATProtocolHeader."Document Type" := DocType;
        VATProtocolHeader."No." := VATProtocolHeaderReq."No.";
        VATProtocolHeader."Document Date" := VATProtocolHeaderReq."Document Date";
        VATProtocolHeader."Posting Date" := VATProtocolHeaderReq."Posting Date";
        VATProtocolHeader."VAT Date" := VATProtocolHeaderReq."VAT Date";
        VATProtocolHeader."VAT Bus. Posting Group" := VATProtocolHeaderReq."VAT Bus. Posting Group";
        VATProtocolHeader."Bal. VAT Bus. Posting Group" := VATProtocolHeaderReq."Bal. VAT Bus. Posting Group";
        VATProtocolHeader.VALIDATE("CV No.", CVNo);
        VATProtocolHeader."Corr. VAT Protocol No." := '';
        VATProtocolHeader."No. Series" := VATProtocolHeaderReq."No. Series";
        VATProtocolHeader."Posting No. Series" := VATProtocolHeaderReq."Posting No. Series";
        VATProtocolHeader."VAT Subject" := VATProtocolHeaderReq."VAT Subject";
        //NAVBG8.00; 001; begin
        VATProtocolHeader."Protocol Type" := VATProtocolHeaderReq."Protocol Type";
        VATProtocolHeader."Protocol Subtype" := VATProtocolHeaderReq."Protocol Subtype";
        //NAVBG8.00; 001; end
    end;

    procedure MakeVATProtocolLine(FromLine: Record "VAT Protocol Line"; VATProtocolHeader: Record "VAT Protocol Header"; var LineNo2: Integer; CompressLines: Boolean);
    var
        VATProtocolLine: Record "VAT Protocol Line";
    begin
        if CompressLines then begin
            VATProtocolLine.SETCURRENTKEY("VAT Prod. Posting Group");
            VATProtocolLine.SETRANGE("Document No.", VATProtocolHeader."No.");
            VATProtocolLine.SETRANGE("VAT Prod. Posting Group", FromLine."VAT Prod. Posting Group");
        end else begin
            VATProtocolLine.RESET;
            VATProtocolLine.SETRANGE("Document No.");
            VATProtocolLine.SETRANGE("VAT Prod. Posting Group");
        end;

        if VATProtocolLine.FIND('-') and CompressLines then begin
            if not VATProtocolLine.Compressed then
                VATProtocolLine.VALIDATE(Compressed, true);
            VATProtocolLine.VALIDATE("VAT Base Amount (LCY)",
              VATProtocolLine."VAT Base Amount (LCY)" + ROUND(FromLine."VAT Base Amount (LCY)"));
            VATProtocolLine.MODIFY;
        end else begin
            VATProtocolLine.INIT;
            LineNo2 := LineNo2 + 10000;
            VATProtocolLine."Line No." := LineNo2;
            VATProtocolLine."Document Type" := VATProtocolHeader."Document Type";
            VATProtocolLine."Document No." := VATProtocolHeader."No.";
            VATProtocolLine."VAT Bus. Posting Group" := VATProtocolHeader."VAT Bus. Posting Group";
            VATProtocolLine."Bal. VAT Bus. Posting Group" := VATProtocolHeader."Bal. VAT Bus. Posting Group";
            VATProtocolLine."VAT Prod. Posting Group" := FromLine."VAT Prod. Posting Group";//31.07.08; LLP5.01; dir 001; Mariana

            VATProtocolLine.Type := FromLine.Type;
            VATProtocolLine.VALIDATE("No.", FromLine."No.");
            if EUDocument(VATProtocolHeader."Country/Region Code") then
                VATProtocolLine.VALIDATE("VAT Prod. Posting Group", FromLine."VAT Prod. Posting Group");
            VATProtocolLine.Description := FromLine.Description;
            VATProtocolLine."Description 2" := FromLine."Description 2";
            VATProtocolLine.VALIDATE("Unit of Measure Code", FromLine."Unit of Measure Code");
            VATProtocolLine.VALIDATE(Quantity, FromLine.Quantity);
            VATProtocolLine.VALIDATE("VAT Base Amount (LCY)", FromLine."VAT Base Amount (LCY)");

            VATProtocolLine."System-Created Entry" := true;

            if VATProtocolLine."VAT Base Amount (LCY)" <> 0 then begin
                VATProtocolLine.INSERT(true);
                GAMT2 += VATProtocolLine."VAT Amount (LCY)";
            end;

            //NAVBG8.00; 001; begin
            if VATProtocolHeader."Protocol Type" = VATProtocolHeader."Protocol Type"::"Unrealized VAT" then begin
                VATProtocolLine."Unit Price (LCY)" := 0;
                VATProtocolLine."VAT Base Amount (LCY)" := 0;
                VATProtocolLine."VAT Amount (LCY)" := 0;
                VATProtocolLine.MODIFY;
            end;
            //NAVBG8.00; 001; end

        end;
    end;

    procedure EUDocument(VATCountryCode: Code[10]): Boolean;
    var
        Country: Record "Country/Region";
    begin
        if VATCountryCode <> '' then begin
            Country.GET(VATCountryCode);
            if Country."EU Country/Region Code" <> '' then
                exit(true);
        end;
    end;

    procedure VATProtocolPrinted(var PostedVATProtocolHeader: Record "Posted VAT Protocol Header");
    begin
        with PostedVATProtocolHeader do begin
            FIND;
            "No. Printed" := "No. Printed" + 1;
            MODIFY;
            COMMIT;
        end;
    end;

    procedure VATProtocolExists(DocType: Option; DocNo: Code[20]): Boolean;
    var
        VATProtocolHeader: Record "VAT Protocol Header";
    begin
        with VATProtocolHeader do begin
            SETCURRENTKEY("Original Doc. Type", "Original Doc. No.");
            SETRANGE("Original Doc. Type", DocType);
            SETRANGE("Original Doc. No.", DocNo);
            exit(not ISEMPTY);
        end;
    end;

    procedure PostVATProtocolExists(DocType: Option; DocNo: Code[20]): Boolean;
    var
        PostedVATProtocolHeader: Record "Posted VAT Protocol Header";
    begin
        with PostedVATProtocolHeader do begin
            SETCURRENTKEY("Original Doc. Type", "Original Doc. No.", Void);
            SETRANGE("Original Doc. Type", DocType);
            SETRANGE("Original Doc. No.", DocNo);
            SETRANGE(Void, false);
            exit(not ISEMPTY);
        end;
    end;

    procedure CheckAmt(aPurchInvHeader: Record "Purch. Inv. Header"): Decimal;
    var
        lVATEntry: Record "VAT Entry";
        lAmt: Decimal;
    begin
        lAmt := 0;
        lVATEntry.SETCURRENTKEY("Document No.");
        lVATEntry.SETRANGE("Document No.", aPurchInvHeader."No.");
        //lVATEntry.setrange("document type", lVATEntry."Document Type"::invoice);
        lVATEntry.SETRANGE(Type, lVATEntry.Type::Purchase);
        if lVATEntry.FINDFIRST then
            repeat
                lAmt += lVATEntry.Amount;
            until lVATEntry.NEXT = 0;

        exit(lAmt);
    end;
}

