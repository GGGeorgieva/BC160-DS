codeunit 46015606 CustVendManagement
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

    procedure FillCVBuffer(var CurrencyBuf: Record Currency temporary; var CVLedgEntry: Record "CV Ledger Entry Buffer" temporary; CustomerNo: Code[20]; VendorNo: Code[20]; AtDate: Date; AmountsInCurrency: Boolean);
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        NextEntryNo: Integer;
    begin
        CurrencyBuf.RESET;
        CurrencyBuf.DELETEALL;
        CVLedgEntry.RESET;
        CVLedgEntry.DELETEALL;
        NextEntryNo := 0;

        if not AmountsInCurrency then begin
            CurrencyBuf.Code := '';
            CurrencyBuf.INSERT;
        end;

        with CustLedgEntry do begin
            SETCURRENTKEY("Customer No.", "Posting Date", "Currency Code");
            SETRANGE("Customer No.", CustomerNo);
            SETFILTER("Posting Date", '..%1', AtDate);
            if FINDSET then
                repeat
                    SETFILTER("Date Filter", '..%1', AtDate);
                    CALCFIELDS("Remaining Amount");
                    if "Remaining Amount" <> 0 then begin
                        NextEntryNo += 1;
                        CVLedgEntry."Entry No." := NextEntryNo;
                        CVLedgEntry."Document Date" := "Document Date";
                        CVLedgEntry."Document Type" := "Document Type";
                        CVLedgEntry."Document No." := "Document No.";
                        CVLedgEntry."Currency Code" := "Currency Code";
                        CVLedgEntry."Due Date" := "Due Date";
                        CALCFIELDS(Amount, "Remaining Amount", "Remaining Amt. (LCY)");
                        CVLedgEntry.Amount := Amount;
                        CVLedgEntry."Remaining Amount" := "Remaining Amount";
                        CVLedgEntry."Remaining Amt. (LCY)" := "Remaining Amt. (LCY)";
                        CVLedgEntry.INSERT;
                        if AmountsInCurrency then
                            if not CurrencyBuf.GET("Currency Code") then begin
                                CurrencyBuf.Code := "Currency Code";
                                CurrencyBuf.INSERT;
                            end;
                    end;
                until NEXT = 0;
        end;
        with VendLedgEntry do begin
            SETCURRENTKEY("Vendor No.", "Posting Date", "Currency Code");
            SETRANGE("Vendor No.", VendorNo);
            SETFILTER("Posting Date", '..%1', AtDate);
            if FINDSET then
                repeat
                    SETFILTER("Date Filter", '..%1', AtDate);
                    CALCFIELDS("Remaining Amount");
                    if "Remaining Amount" <> 0 then begin
                        NextEntryNo += 1;
                        CVLedgEntry."Entry No." := NextEntryNo;
                        CVLedgEntry."Document Date" := "Document Date";
                        CVLedgEntry."Document Type" := "Document Type";
                        CVLedgEntry."Document No." := "External Document No.";
                        CVLedgEntry."Currency Code" := "Currency Code";
                        CVLedgEntry."Due Date" := "Due Date";
                        CALCFIELDS(Amount, "Remaining Amount", "Remaining Amt. (LCY)");
                        CVLedgEntry.Amount := Amount;
                        CVLedgEntry."Remaining Amount" := "Remaining Amount";
                        CVLedgEntry."Remaining Amt. (LCY)" := "Remaining Amt. (LCY)";
                        CVLedgEntry.INSERT;
                        if AmountsInCurrency then
                            if not CurrencyBuf.GET("Currency Code") then begin
                                CurrencyBuf.Code := "Currency Code";
                                CurrencyBuf.INSERT;
                            end;
                    end;
                until NEXT = 0;
        end;
    end;

    procedure CalcCVDebt(CustomerNo: Code[20]; VendorNo: Code[20]; CurrencyCode: Code[10]; Date: Date; InLCY: Boolean) TotalAmount: Decimal;
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
    begin
        if CustomerNo <> '' then begin
            Customer.GET(CustomerNo);
            Customer.SETFILTER("Date Filter", '..%1', Date);
            if InLCY then
                Customer.CALCFIELDS("Net Change (LCY)")
            else begin
                Customer.SETFILTER("Currency Filter", '%1', CurrencyCode);
                Customer.CALCFIELDS("Net Change");
            end;
        end;
        if VendorNo <> '' then begin
            Vendor.GET(VendorNo);
            Vendor.SETFILTER("Date Filter", '..%1', Date);
            if InLCY then
                Vendor.CALCFIELDS("Net Change (LCY)")
            else begin
                Vendor.SETFILTER("Currency Filter", '%1', CurrencyCode);
                Vendor.CALCFIELDS("Net Change");
            end;
        end;
        if InLCY then
            TotalAmount := Customer."Net Change (LCY)" - Vendor."Net Change (LCY)"
        else
            TotalAmount := Customer."Net Change" - Vendor."Net Change";
    end;
}

