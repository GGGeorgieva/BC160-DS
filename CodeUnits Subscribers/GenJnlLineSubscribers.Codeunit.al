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
}