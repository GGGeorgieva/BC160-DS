codeunit 46015809 "Gen. Jnl. Line Subscribers"
{
    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterSetupNewLine', '', true, true)]
    local procedure SetVATDate(var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."VAT Date" := GenJournalLine."Posting Date";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterClearCustApplnEntryFields', '', true, true)]
    local procedure SetCustLedgEntryOnHold(var CustLedgerEntry: Record "Cust. Ledger Entry")
    begin
        CustLedgerEntry."On Hold" := '';
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterClearVendApplnEntryFields', '', true, true)]
    local procedure SetVendLedgEntryOnHold(var VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
        VendorLedgerEntry."On Hold" := '';
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromInvPostBuffer', '', true, true)]
    local procedure CopyFieldsFromBuffer(InvoicePostBuffer: Record "Invoice Post. Buffer"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."VAT Date" := InvoicePostBuffer."VAT Date";
        GenJournalLine."Excise Amount" := InvoicePostBuffer."Excise Amount";
        GenJournalLine."Source Currency Excise Amount" := InvoicePostBuffer."Excise Amount (ACY)";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromPurchHeader', '', true, true)]
    local procedure CopyFieldsFromPurchHeader(PurchaseHeader: Record "Purchase Header"; var GenJournalLine: Record "Gen. Journal Line")
    var
        VATExportSetup: Record "VAT Export Setup";
    begin
        GenJournalLine."Customs Procedure Code" := PurchaseHeader."Customs Procedure Code";
        GenJournalLine."Registration No." := PurchaseHeader."Registration No.";
        GenJournalLine."EU 3-Party Trade" := PurchaseHeader."EU 3-Party Trade";
        GenJournalLine."EU 3-Party Intermediate Role" := PurchaseHeader."EU 3-Party Intermediate Role";
        GenJournalLine."Debit Memo" := PurchaseHeader."Debit Memo";
        GenJournalLine."Sales Protocol" := PurchaseHeader."Sales Protocol";
        GenJournalLine.Void := PurchaseHeader.Void;
        GenJournalLine."Void Date" := PurchaseHeader."Void Date";
        GenJournalLine."VAT Type" := GenJournalLine."VAT Type"::Purchase;
        GenJournalLine."Bill-to/Pay-to Name" := PurchaseHeader."Pay-to Name";
        GenJournalLine."Identification No." := PurchaseHeader."Identification No.";
        GenJournalLine."Do not include in VAT Ledgers" := PurchaseHeader."Do not include in VAT Ledgers";
        GenJournalLine."Unrealized VAT" := PurchaseHeader."Unrealized VAT";
        GenJournalLine."VAT Registration No." := PurchaseHeader."VAT Registration No.";
        GenJournalLine."VAT Date" := PurchaseHeader."VAT Date";
        if PurchaseHeader."VAT Subject" <> '' then
            GenJournalLine."VAT Subject" := PurchaseHeader."VAT Subject"
        else begin
            VATExportSetup.GET;
            GenJournalLine."VAT Subject" := VATExportSetup."Purchase VAT Subject";
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromPurchHeaderPrepmt', '', true, true)]
    local procedure CopyFromPurchHeaderPrepmt(PurchaseHeader: Record "Purchase Header"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."VAT Date" := PurchaseHeader."VAT Date";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromPurchHeaderPrepmtPost', '', true, true)]
    local procedure CopyGFromPurchHeaderPremptPost(PurchaseHeader: Record "Purchase Header"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."VAT Date" := PurchaseHeader."VAT Date";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromSalesHeader', '', true, true)]
    local procedure CopyFieldsFromSalesHeader(SalesHeader: Record "Sales Header"; var GenJournalLine: Record "Gen. Journal Line")
    var
        VATExportSetup: Record "VAT Export Setup";
    begin
        GenJournalLine."Customs Procedure Code" := SalesHeader."Customs Procedure Code";
        GenJournalLine."Postponed VAT" := SalesHeader."Postponed VAT";
        GenJournalLine."EU 3-Party Intermediate Role" := SalesHeader."EU 3-Party Intermediate Role";
        GenJournalLine."Debit Memo" := SalesHeader."Debit Memo";
        GenJournalLine."Sales Protocol" := SalesHeader."Sales Protocol";
        GenJournalLine.Void := SalesHeader.Void;
        GenJournalLine."Void Date" := SalesHeader."Void Date";
        GenJournalLine."Bill-to/Pay-to Name" := SalesHeader."Bill-to Name";
        GenJournalLine."Identification No." := SalesHeader."Identification No.";
        GenJournalLine."Do not include in VAT Ledgers" := SalesHeader."Do not include in VAT Ledgers";
        GenJournalLine."Unrealized VAT" := SalesHeader."Unrealized VAT";
        GenJournalLine."VAT Date" := SalesHeader."VAT Date";
        GenJournalLine."VAT Registration No." := SalesHeader."VAT Registration No.";
        if SalesHeader."VAT Subject" <> '' then
            GenJournalLine."VAT Subject" := SalesHeader."VAT Subject"
        else begin
            VATExportSetup.GET;
            GenJournalLine."VAT Subject" := VATExportSetup."Sales VAT Subject";
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromSalesHeaderPrepmt', '', true, true)]
    local procedure CopyFieldsFromSalesHeaderPrepmt(SalesHeader: Record "Sales Header"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."VAT Date" := SalesHeader."VAT Date";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromSalesHeaderPrepmtPost', '', true, true)]
    local procedure CopyFieldsFromSalesHeaderPrepmtPost(SalesHeader: Record "Sales Header"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."VAT Date" := SalesHeader."VAT Date";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromServHeader', '', true, true)]
    local procedure CopyFieldsFromServiceHeader(ServiceHeader: Record "Service Header"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."Postponed VAT" := ServiceHeader."Postponed VAT";
        GenJournalLine."VAT Date" := ServiceHeader."VAT Date";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterAccountNoOnValidateGetCustomerAccount', '', true, true)]
    local procedure CopyFieldsFromCusomer(var GenJournalLine: Record "Gen. Journal Line"; var Customer: Record Customer)
    begin
        GenJournalLine."VAT Registration No." := Customer."VAT Registration No.";
        GenJournalLine."Identification No." := Customer."Identification No.";
        GenJournalLine."Bill-to/Pay-to Name" := Customer.Name;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterAccountNoOnValidateGetCustomerBalAccount', '', true, true)]
    local procedure CopyFieldsFromCusomerBalAccount(var GenJournalLine: Record "Gen. Journal Line"; var Customer: Record Customer)
    begin
        GenJournalLine."VAT Registration No." := Customer."VAT Registration No.";
        GenJournalLine."Identification No." := Customer."Identification No.";
        GenJournalLine."Bill-to/Pay-to Name" := Customer.Name;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterAccountNoOnValidateGetVendorAccount', '', true, true)]
    local procedure CopyFieldsFromVendor(var GenJournalLine: Record "Gen. Journal Line"; var Vendor: Record Vendor)
    begin
        GenJournalLine."VAT Registration No." := Vendor."VAT Registration No.";
        GenJournalLine."Identification No." := Vendor."Identification No.";
        GenJournalLine."Bill-to/Pay-to Name" := Vendor.Name;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterAccountNoOnValidateGetVendorBalAccount', '', true, true)]
    local procedure CopyFieldsFromVendorBalAccount(var GenJournalLine: Record "Gen. Journal Line"; var Vendor: Record Vendor)
    begin
        GenJournalLine."VAT Registration No." := Vendor."VAT Registration No.";
        GenJournalLine."Identification No." := Vendor."Identification No.";
        GenJournalLine."Bill-to/Pay-to Name" := Vendor.Name;
    end;
}