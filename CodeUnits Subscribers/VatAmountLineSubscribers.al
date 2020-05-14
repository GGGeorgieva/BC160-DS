codeunit 46015813 "Vat Amount Line Subscribers"
{
    [EventSubscriber(ObjectType::Table, Database::"VAT Amount Line", 'OnInsertLineOnBeforeModify', '', true, true)]
    local procedure InsertLineBG(var VATAmountLine: Record "VAT Amount Line"; FromVATAmountLine: Record "VAT Amount Line")
    begin
        VATAmountLine."VAT Base (Non Deductible)" := FromVATAmountLine."VAT Base (Non Deductible)" + VATAmountLine."VAT Base (Non Deductible)";
        VATAmountLine."VAT Amount (Non Deductible)" := FromVATAmountLine."VAT Amount (Non Deductible)" + VATAmountLine."VAT Amount (Non Deductible)";
        VATAmountLine."Amount Incl. Taxes Excl. VAT" := FromVATAmountLine."Amount Incl. Taxes Excl. VAT" + VATAmountLine."Amount Incl. Taxes Excl. VAT";
        VATAmountLine."Excise Amount" := FromVATAmountLine."Excise Amount" + VATAmountLine."Excise Amount";
        VATAmountLine."Product Tax Amount" := FromVATAmountLine."Product Tax Amount" + VATAmountLine."Product Tax Amount";
        VATAmountLine."Amount Excl. Taxes" := FromVATAmountLine."Amount Excl. Taxes" + VATAmountLine."Amount Excl. Taxes";

    end;

    [EventSubscriber(ObjectType::Table, Database::"VAT Amount Line", 'OnAfterCopyFromPurchInvLine', '', true, true)]
    local procedure CopyFromPurchInvLineBG(var VATAmountLine: Record "VAT Amount Line"; PurchInvLine: Record "Purch. Inv. Line")
    begin
        if PurchInvLine.Type in
                                [PurchInvLine.Type::"G/L Account", PurchInvLine.Type::Item, PurchInvLine.Type::"Fixed Asset"] then begin
            VATAmountLine."VAT % (Non Deductible)" := PurchInvLine."VAT % (Non Deductible)";
            VATAmountLine."VAT Base (Non Deductible)" := PurchInvLine."VAT Base (Non Deductible)";
            VATAmountLine."VAT Amount (Non Deductible)" := PurchInvLine."VAT Amount (Non Deductible)";
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"VAT Amount Line", 'OnAfterCopyFromPurchCrMemoLine', '', true, true)]
    local procedure CopyFromPurchCrMemoLineBG(var VATAmountLine: Record "VAT Amount Line"; PurchCrMemoLine: Record "Purch. Cr. Memo Line")
    begin
        if PurchCrMemoLine.Type in
                             [PurchCrMemoLine.Type::"G/L Account", PurchCrMemoLine.Type::Item, PurchCrMemoLine.Type::"Fixed Asset"] then begin
            VATAmountLine."VAT % (Non Deductible)" := PurchCrMemoLine."VAT % (Non Deductible)";
            VATAmountLine."VAT Base (Non Deductible)" := PurchCrMemoLine."VAT Base (Non Deductible)";
            VATAmountLine."VAT Amount (Non Deductible)" := PurchCrMemoLine."VAT Amount (Non Deductible)";
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"VAT Amount Line", 'OnAfterCopyFromSalesInvLine', '', true, true)]
    local procedure CopyFromSalesInvLineBG(var VATAmountLine: Record "VAT Amount Line"; SalesInvoiceLine: Record "Sales Invoice Line")
    begin
        VATAmountLine."VAT Base" := SalesInvoiceLine."Amount Incl. Taxes Excl. VAT";
        VATAmountLine."VAT Amount" := SalesInvoiceLine."Amount Including VAT" - SalesInvoiceLine."Amount Incl. Taxes Excl. VAT";
        VATAmountLine."Excise Amount" := SalesInvoiceLine."Excise Amount";
        VATAmountLine."Product Tax Amount" := SalesInvoiceLine."Product Tax Amount";
        VATAmountLine."Amount Excl. Taxes" := SalesInvoiceLine.Amount - SalesInvoiceLine."Product Tax Amount";
        VATAmountLine."Calculated VAT Amount" :=
             SalesInvoiceLine."Amount Including VAT" - SalesInvoiceLine."Amount Incl. Taxes Excl. VAT" - SalesInvoiceLine."VAT Difference"
    end;

    [EventSubscriber(ObjectType::Table, Database::"VAT Amount Line", 'OnAfterCopyFromSalesCrMemoLine', '', true, true)]
    local procedure CopyFromSalesCrMemoLineBG(var VATAmountLine: Record "VAT Amount Line"; SalesCrMemoLine: Record "Sales Cr.Memo Line")
    begin
        VATAmountLine."VAT Base" := SalesCrMemoLine."Amount Incl. Taxes Excl. VAT";
        VATAmountLine."VAT Amount" := SalesCrMemoLine."Amount Including VAT" - SalesCrMemoLine."Amount Incl. Taxes Excl. VAT";
        VATAmountLine."Excise Amount" := SalesCrMemoLine."Excise Amount";
        VATAmountLine."Product Tax Amount" := SalesCrMemoLine."Product Tax Amount";
        VATAmountLine."Amount Excl. Taxes" := SalesCrMemoLine.Amount - SalesCrMemoLine."Product Tax Amount";
        VATAmountLine."Calculated VAT Amount" :=
                        SalesCrMemoLine."Amount Including VAT" - SalesCrMemoLine."Amount Incl. Taxes Excl. VAT" - SalesCrMemoLine."VAT Difference"
    end;
}
