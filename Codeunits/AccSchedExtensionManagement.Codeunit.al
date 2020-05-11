codeunit 46015686 AccSchedExtensionManagement
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


    trigger OnRun();
    begin
    end;

    var
        AccSchedLine: Record "Acc. Schedule Line";
        ColumnLayout: Record "Column Layout";
        AccSchedExtension: Record "Acc. Schedule Extension";
        ReportPeriod: Record Date;
        AccSchedManagement: Codeunit AccSchedManagement;
        ReportFilter: Boolean;
        Text001: Label 'BD';
        Text002: Label 'ED';
        Text003: TextConst ENU = 'Invalid value for Date Filter = %1';
        StartDate: Date;
        EndDate: Date;

    procedure CalcCustomFunc(var NewAccSchedLine: Record "Acc. Schedule Line"; NewColumnLayout: Record "Column Layout"; NewStartDate: Date; NewEndDate: Date) Value: Decimal;
    begin
        AccSchedLine.COPY(NewAccSchedLine);
        ColumnLayout := NewColumnLayout;
        StartDate := NewStartDate;
        EndDate := NewEndDate;
        Value := 0;
        //TODO MISSING METHOD SetDateParameters IN CODEUNIT AccSchedManagement
        //AccSchedManagement.SetDateParameters(StartDate,EndDate);
        with AccSchedExtension do begin
            SETFILTER(Code, NewAccSchedLine.Totaling);
            if FINDFIRST then
                case "Source Table" of
                    "Source Table"::"VAT Entry":
                        Value := GetVATEntryValue;
                    "Source Table"::"Value Entry":
                        Value := GetValueEntry;
                    "Source Table"::"Customer Entry":
                        Value := GetCustEntryValue;
                    "Source Table"::"Vendor Entry":
                        Value := GetVendEntryValue;
                end;
        end;
    end;

    procedure SetAccSchedLine(var NewAccSchedLine: Record "Acc. Schedule Line");
    begin
        AccSchedLine.COPY(NewAccSchedLine);
    end;

    procedure SetReportPeriod(var NewReportPeriod: Record Date);
    begin
        ReportPeriod.COPY(NewReportPeriod);
        ReportFilter := true;
    end;

    procedure GetVATEntryValue() Result: Decimal;
    var
        VATEntry: Record "VAT Entry";
    begin
        VATEntry.RESET;
        VATEntry.SETCURRENTKEY(Type, Closed, "VAT Bus. Posting Group", "VAT Prod. Posting Group", "Posting Date");
        SetVATLedgEntryFilters(VATEntry);

        case AccSchedExtension."VAT Amount Type" of
            AccSchedExtension."VAT Amount Type"::Base:
                begin
                    VATEntry.CALCSUMS(Base);
                    Result := VATEntry.Base;
                end;
            AccSchedExtension."VAT Amount Type"::Amount:
                begin
                    VATEntry.CALCSUMS(Amount);
                    Result := VATEntry.Amount;
                end;
        end;
        if AccSchedExtension."Reverse Sign" then
            Result := -1 * Result;
    end;

    procedure GetValueEntry() Result: Decimal;
    var
        ValueEntry: Record "Value Entry";
    begin
        ValueEntry.RESET;
        ValueEntry.SETCURRENTKEY("Item No.", "Posting Date", "Item Ledger Entry Type", "Entry Type",
          "Variance Type", "Item Charge No.", "Location Code", "Variant Code",
          "Global Dimension 1 Code", "Global Dimension 2 Code");
        SetValueLedgEntryFilters(ValueEntry);
        ValueEntry.CALCSUMS("Cost Posted to G/L");
        Result := ValueEntry."Cost Posted to G/L";
        if AccSchedExtension."Reverse Sign" then
            Result := -1 * Result;
    end;

    procedure CalcDateFormula(DateFormula: Text[250]): Date;
    begin
        // PS421.begin
        // ED or BD formulas proccessing
        // ED or BD have to be in the begining of the formula

        if DateFormula = '' then
            exit(0D);

        case COPYSTR(DateFormula, 1, 2) of
            Text001:
                exit(CALCDATE(COPYSTR(DateFormula, 3), StartDate));

            Text002:
                exit(CALCDATE(COPYSTR(DateFormula, 3), EndDate));
        end;

        ERROR(Text003, DateFormula);
        // PS421.end
    end;

    procedure GetDateFilter(DateFilter: Text[250]): Text[250];
    var
        Position: Integer;
        LeftFormula: Text[250];
        RightFormula: Text[250];
    begin
        // PS421.begin
        if DateFilter = '' then
            exit(DateFilter);

        Position := STRPOS(DateFilter, '..');
        if Position > 0 then begin
            LeftFormula := COPYSTR(DateFilter, 1, Position - 1);
            RightFormula := COPYSTR(DateFilter, Position + 2);
            exit(FORMAT(CalcDateFormula(LeftFormula)) + '..' + FORMAT(CalcDateFormula(RightFormula)));
        end;

        case DateFilter of
            Text001:
                exit(FORMAT(StartDate));
            Text002:
                exit(FORMAT(EndDate));
        end;

        exit(DateFilter);
        // PS421.end
    end;

    procedure SetCustLedgEntryFilters(var CustLedgerEntry: Record "Cust. Ledger Entry");
    begin
        with AccSchedExtension do begin
            if "Posting Date Filter" <> '' then
                CustLedgerEntry.SETFILTER("Posting Date",
                  GetDateFilter("Posting Date Filter"))
            else
                //TODO MISSING METHOD GetPostingDateFilter IN AccSchedManagement CODEUNIT
                //    CustLedgerEntry.SETFILTER("Posting Date", AccSchedManagement.GetPostingDateFilter(AccSchedLine, ColumnLayout));
                CustLedgerEntry.COPYFILTER("Posting Date", CustLedgerEntry."Date Filter");

            if "Document Type Filter" <> '' then
                CustLedgerEntry.SETFILTER("Document Type", "Document Type Filter");
            if "Posting Group Filter" <> '' then
                CustLedgerEntry.SETFILTER("Customer Posting Group", "Posting Group Filter");
            if Prepayment = Prepayment::Yes then
                CustLedgerEntry.SETRANGE(Prepayment, true);
            if Prepayment = Prepayment::No then
                CustLedgerEntry.SETRANGE(Prepayment, false);
        end;
    end;

    procedure SetVendLedgEntryFilters(var VendLedgerEntry: Record "Vendor Ledger Entry");
    begin
        with AccSchedExtension do begin
            if "Posting Date Filter" <> '' then
                VendLedgerEntry.SETFILTER("Posting Date",
                  GetDateFilter("Posting Date Filter"))
            else
                //TODO MISSING METHOD GetPostingDateFilter IN AccSchedManagement CODEUNIT
                //  VendLedgerEntry.SETFILTER("Posting Date", AccSchedManagement.GetPostingDateFilter(AccSchedLine, ColumnLayout));
                VendLedgerEntry.COPYFILTER("Posting Date", VendLedgerEntry."Date Filter");

            if "Document Type Filter" <> '' then
                VendLedgerEntry.SETFILTER("Document Type", "Document Type Filter");
            if "Posting Group Filter" <> '' then
                VendLedgerEntry.SETFILTER("Vendor Posting Group", "Posting Group Filter");
            if Prepayment = Prepayment::Yes then
                VendLedgerEntry.SETRANGE(Prepayment, true);
            if Prepayment = Prepayment::No then
                VendLedgerEntry.SETRANGE(Prepayment, false);
        end;
    end;

    procedure SetVATLedgEntryFilters(var VATEntry: Record "VAT Entry");
    begin
        case AccSchedExtension."Entry Type" of
            AccSchedExtension."Entry Type"::Purchase:
                VATEntry.SETRANGE(Type, VATEntry.Type::Purchase);
            AccSchedExtension."Entry Type"::Sale:
                VATEntry.SETRANGE(Type, VATEntry.Type::Sale);
        end;
        //TODO MISSING METHOD GetPostingDateFilter IN AccSchedManagement CODEUNIT
        //  VATEntry.SETFILTER("Posting Date", AccSchedManagement.GetPostingDateFilter(AccSchedLine, ColumnLayout));
        VATEntry.SETFILTER("VAT Bus. Posting Group", AccSchedExtension."VAT Bus. Post. Group Filter");
        VATEntry.SETFILTER("VAT Prod. Posting Group", AccSchedExtension."VAT Prod. Post. Group Filter");
    end;

    procedure SetValueLedgEntryFilters(var ValueEntry: Record "Value Entry");
    begin
        ValueEntry.SETFILTER("Global Dimension 1 Code", AccSchedLine.GETFILTER("Dimension 1 Filter"));
        ValueEntry.SETFILTER("Global Dimension 2 Code", AccSchedLine.GETFILTER("Dimension 2 Filter"));
        ValueEntry.SETFILTER("Location Code", AccSchedExtension."Location Filter");
        //TODO MISSING METHOD GetPostingDateFilter IN AccSchedManagement CODEUNIT
        //ValueEntry.SETFILTER("Posting Date", AccSchedManagement.GetPostingDateFilter(AccSchedLine, ColumnLayout));
    end;

    procedure GetCustEntryValue() Amount: Decimal;
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        // PS421.begin
        CustLedgerEntry.SETCURRENTKEY("Document Type", "Customer No.", "Posting Date", "Currency Code");
        SetCustLedgEntryFilters(CustLedgerEntry);
        if CustLedgerEntry.FINDSET then
            repeat
                CustLedgerEntry.CALCFIELDS("Remaining Amt. (LCY)");
                case AccSchedExtension."Amount Sign" of
                    AccSchedExtension."Amount Sign"::" ":
                        Amount += CustLedgerEntry."Remaining Amt. (LCY)";
                    AccSchedExtension."Amount Sign"::Positive:
                        if CustLedgerEntry."Remaining Amt. (LCY)" > 0 then
                            Amount += CustLedgerEntry."Remaining Amt. (LCY)";
                    AccSchedExtension."Amount Sign"::Negative:
                        if CustLedgerEntry."Remaining Amt. (LCY)" < 0 then
                            Amount += CustLedgerEntry."Remaining Amt. (LCY)";
                end;
            until CustLedgerEntry.NEXT = 0;

        if AccSchedExtension."Reverse Sign" then
            Amount := -Amount;
        // PS421.end
    end;

    procedure GetVendEntryValue() Amount: Decimal;
    var
        VendLedgerEntry: Record "Vendor Ledger Entry";
    begin
        // PS421.begin
        VendLedgerEntry.SETCURRENTKEY("Document Type", "Vendor No.", "Posting Date", "Currency Code");
        SetVendLedgEntryFilters(VendLedgerEntry);
        if VendLedgerEntry.FINDSET then
            repeat
                VendLedgerEntry.CALCFIELDS("Remaining Amt. (LCY)");
                case AccSchedExtension."Amount Sign" of
                    AccSchedExtension."Amount Sign"::" ":
                        Amount += VendLedgerEntry."Remaining Amt. (LCY)";
                    AccSchedExtension."Amount Sign"::Positive:
                        if VendLedgerEntry."Remaining Amt. (LCY)" > 0 then
                            Amount += VendLedgerEntry."Remaining Amt. (LCY)";
                    AccSchedExtension."Amount Sign"::Negative:
                        if VendLedgerEntry."Remaining Amt. (LCY)" < 0 then
                            Amount += VendLedgerEntry."Remaining Amt. (LCY)";
                end;
            until VendLedgerEntry.NEXT = 0;

        if AccSchedExtension."Reverse Sign" then
            Amount := -Amount;
        // PS421.end
    end;

    procedure DrillDownAmount(var NewAccSchedLine: Record "Acc. Schedule Line"; NewColumnLayout: Record "Column Layout"; ExtensionCode: Code[20]; NewStartDate: Date; NewEndDate: Date);
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        VendLedgerEntry: Record "Vendor Ledger Entry";
        VATEntry: Record "VAT Entry";
        ValueEntry: Record "Value Entry";
    begin
        AccSchedLine.COPY(NewAccSchedLine);
        ColumnLayout := NewColumnLayout;
        AccSchedExtension.GET(ExtensionCode);
        StartDate := NewStartDate;
        EndDate := NewEndDate;
        //TODO MISSING METHOD SetDateParameters IN AccSchedManagement CODEUNIT
        // AccSchedManagement.SetDateParameters(StartDate, EndDate);
        case AccSchedExtension."Source Table" of
            AccSchedExtension."Source Table"::"VAT Entry":
                begin
                    SetVATLedgEntryFilters(VATEntry);
                    PAGE.RUN(0, VATEntry);
                end;

            AccSchedExtension."Source Table"::"Customer Entry":
                begin
                    SetCustLedgEntryFilters(CustLedgerEntry);
                    PAGE.RUN(0, CustLedgerEntry);
                end;

            AccSchedExtension."Source Table"::"Vendor Entry":
                begin
                    SetVendLedgEntryFilters(VendLedgerEntry);
                    PAGE.RUN(0, VendLedgerEntry);
                end;

            AccSchedExtension."Source Table"::"Value Entry":
                begin
                    SetValueLedgEntryFilters(ValueEntry);
                    PAGE.RUN(0, ValueEntry);
                end;
        end;
    end;
}

