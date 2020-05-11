codeunit 46015801 "Item Jnl Line Subscribers"
{
    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterUpdateAmount', '', true, true)]
    local procedure SetExciseAndProductTaxAmt(var ItemJournalLine: Record "Item Journal Line")
    begin
        ItemJournalLine."Excise Amount" := ROUND(ItemJournalLine.Quantity * ItemJournalLine."Unit Excise");
        ItemJournalLine."Product Tax Amount" := ROUND(ItemJournalLine.Quantity * ItemJournalLine."Unit Product Tax");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterCopyItemJnlLineFromSalesHeader', '', true, true)]
    local procedure CopyFieldsFromSalesHeader(var ItemJnlLine: Record "Item Journal Line"; SalesHeader: Record "Sales Header")
    begin
        ItemJnlLine."Shipment Method Code" := SalesHeader."Shipment Method Code";
        ItemJnlLine."Transport Country/Region Code" := SalesHeader."Transport Country/Region Code";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterCopyItemJnlLineFromSalesLine', '', true, true)]
    local procedure CopyFieldsFromSalesLine(var ItemJnlLine: Record "Item Journal Line"; SalesLine: Record "Sales Line")
    begin
        ItemJnlLine."Tariff No." := SalesLine."Tariff No.";
        ItemJnlLine."Net Weight" := SalesLine."Net Weight";
        ItemJnlLine."Country/Region of Origin Code" := SalesLine."Country/Region of Origin Code";
        ItemJnlLine.Product := SalesLine.Product;
        ItemJnlLine."Calculate Excise" := SalesLine."Calculate Excise";
        ItemJnlLine."Calculate Product Tax" := SalesLine."Calculate Product Tax";
        ItemJnlLine."Unit Excise" := SalesLine."Unit Excise (LCY)";
        ItemJnlLine."Unit Excise (ACY)" := SalesLine."Unit Excise";
        ItemJnlLine."Unit Product Tax" := SalesLine."Unit Product Tax (LCY)";
        ItemJnlLine."Unit Product Tax (ACY)" := SalesLine."Unit Product Tax";
        ItemJnlLine."Outbound Excise Destination" := SalesLine."Outbound Excise Destination";
        ItemJnlLine."Additional Excise Code" := SalesLine."Additional Excise Code";
        ItemJnlLine."Payment Obligation Type" := SalesLine."Payment Obligation Type";
        ItemJnlLine."Exclude from Declaration" := SalesLine."Do not include in Excise";
        ItemJnlLine."Inbound Excise Destination" := SalesLine."Inbound excise destination";
        ItemJnlLine."Excise Declaration Correction" := SalesLine."Excise Declaration Correction";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterCopyItemJnlLineFromPurchHeader', '', true, true)]
    local procedure CopyFieldsFromPurchHeader(var ItemJnlLine: Record "Item Journal Line"; PurchHeader: Record "Purchase Header")
    begin
        ItemJnlLine."Shipment Method Code" := PurchHeader."Shipment Method Code";
        ItemJnlLine."Transport Country/Region Code" := PurchHeader."Transport Country/Region Code";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterCopyItemJnlLineFromPurchLine', '', true, true)]
    local procedure CopyFieldsFromPurchaseLine(var ItemJnlLine: Record "Item Journal Line"; PurchLine: Record "Purchase Line")
    begin
        ItemJnlLine."Country/Region of Origin Code" := PurchLine."Country/Region of Origin Code";
        ItemJnlLine."Tariff No." := PurchLine."Tariff No.";
        ItemJnlLine."Net Weight" := PurchLine."Net Weight";
    end;
}