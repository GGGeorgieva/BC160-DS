codeunit 46015800 "Inv. Posting Buffer Subscr."
{
    [EventSubscriber(ObjectType::Table, Database::"Invoice Post. Buffer", 'OnAfterInvPostBufferPrepareSales', '', true, true)]
    local procedure SetExcisePrepaymentAndCorrectionFromSalesLine(var SalesLine: Record "Sales Line"; var InvoicePostBuffer: Record "Invoice Post. Buffer")
    var
        Product: Boolean;
        GenPostingSetup: Record "General Posting Setup";
        SalesHeader: Record "Sales Header";
    begin
        Product := SalesLine.Product;
        if Product then begin
            GenPostingSetup.GET(SalesLine."Gen. Bus. Posting Group", SalesLine."Gen. Prod. Posting Group");
            if SalesLine."Excise Amount" <> 0 then begin
                GenPostingSetup.TESTFIELD("Sales Excise Acc. (Producer)");
                InvoicePostBuffer."Sales Excise Account" := GenPostingSetup."Sales Excise Acc. (Producer)";
            end;
            if SalesLine."Product Tax Amount" <> 0 then begin
                GenPostingSetup.TESTFIELD("Sales Product Tax Acc. (Prod.)");
                InvoicePostBuffer."Sales Product Tax Account" := GenPostingSetup."Sales Product Tax Acc. (Prod.)";
            end;
        end;

        if SalesLine."Prepayment Line" then
            InvoicePostBuffer."Prepayment Type" := InvoicePostBuffer."Prepayment Type"::Prepayment;
        InvoicePostBuffer."VAT Date" := SalesLine."VAT Date";
        SalesHeader.GET(SalesLine."Document Type", SalesLine."Document No.");
        InvoicePostBuffer.Correction := SalesHeader.Correction xor SalesLine.Negative;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Invoice Post. Buffer", 'OnAfterInvPostBufferPreparePurchase', '', true, true)]
    local procedure SetVATAndCorrectionFromPurchLine(var PurchaseLine: Record "Purchase Line"; var InvoicePostBuffer: Record "Invoice Post. Buffer")
    var
        PurchHeader: Record "Purchase Header";
    begin
        if PurchaseLine."Prepayment Line" then
            InvoicePostBuffer."Prepayment Type" := InvoicePostBuffer."Prepayment Type"::Prepayment;
        InvoicePostBuffer."VAT Date" := PurchaseLine."VAT Date";
        PurchHeader.GET(PurchaseLine."Document Type", PurchaseLine."Document No.");
        InvoicePostBuffer.Correction := PurchHeader.Correction xor PurchaseLine.Negative;
        if InvoicePostBuffer.Type in [InvoicePostBuffer.Type::"G/L Account", InvoicePostBuffer.Type::Item, InvoicePostBuffer.Type::"Fixed Asset"] then begin
            InvoicePostBuffer."VAT % (Non Deductible)" := PurchaseLine."VAT % (Non Deductible)";
            InvoicePostBuffer."VAT Base (Non Deductible)" := PurchaseLine."VAT Base (Non Deductible)";
            InvoicePostBuffer."VAT Amount (Non Deductible)" := PurchaseLine."VAT Amount (Non Deductible)";
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Invoice Post. Buffer", 'OnAfterInvPostBufferPrepareService', '', true, true)]
    local procedure MSetVATDateFromServiceLine(var ServiceLine: Record "Service Line"; var InvoicePostBuffer: Record "Invoice Post. Buffer")
    begin
        InvoicePostBuffer."VAT Date" := ServiceLine."VAT Date";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Invoice Post. Buffer", 'OnBeforeInvPostBufferModify', '', true, true)]
    local procedure MyProcedure(var InvoicePostBuffer: Record "Invoice Post. Buffer"; FromInvoicePostBuffer: Record "Invoice Post. Buffer")
    begin
        InvoicePostBuffer."Excise Amount" += FromInvoicePostBuffer."Excise Amount";
        InvoicePostBuffer."Excise Amount (ACY)" += FromInvoicePostBuffer."Excise Amount (ACY)";
        InvoicePostBuffer."Product Tax Amount (ACY)" += FromInvoicePostBuffer."Product Tax Amount (ACY)";
        InvoicePostBuffer."Product Tax Amount" += FromInvoicePostBuffer."Product Tax Amount";
        InvoicePostBuffer."VAT Base (Non Deductible)" += FromInvoicePostBuffer."VAT Base (Non Deductible)";
        InvoicePostBuffer."VAT Amount (Non Deductible)" += FromInvoicePostBuffer."VAT Amount (Non Deductible)";
    end;

}
