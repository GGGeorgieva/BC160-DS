codeunit 46015812 "Purchase Line Subscribers"
{
    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterAssignHeaderValues', '', true, true)]
    local procedure CopyFieldsFromPurchHeader(var PurchLine: Record "Purchase Line"; PurchHeader: Record "Purchase Header")
    begin
        PurchLine."SAD No." := PurchHeader."SAD No.";
        PurchLine."VAT Date" := PurchHeader."VAT Date";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterAssignFieldsForNo', '', true, true)]
    local procedure SetVatPercentNotDeductible(var PurchLine: Record "Purchase Line")
    var
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        if VATPostingSetup.GET(PurchLine."VAT Bus. Posting Group", PurchLine."VAT Prod. Posting Group") then
            PurchLine.VALIDATE("VAT % (Non Deductible)", PurchLine.GetVATDeduction);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterInitOutstandingAmount', '', true, true)]
    local procedure SetNegative(var PurchLine: Record "Purchase Line")
    var
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.GET;
        if GLSetup."Mark Neg. Qty as Correction" then
            PurchLine.Negative := (PurchLine.Quantity < 0);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterAssignItemValues', '', true, true)]
    local procedure CopyFieldsFromItem(var PurchLine: Record "Purchase Line"; Item: Record Item)
    begin
        PurchLine."Tariff No." := Item."Tariff No.";
        PurchLine."Country/Region of Origin Code" := Item."Country/Region of Origin Code";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterUpdateAmounts', '', true, true)]
    local procedure SetVATPercentNonDed(var PurchLine: Record "Purchase Line")
    begin
        PurchLine.VALIDATE("VAT % (Non Deductible)");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterUpdateVATAmounts', '', true, true)]
    local procedure UpdateVATAmounts(var PurchaseLine: Record "Purchase Line")
    var
        PurchHeader: Record "Purchase Header";
        Currency: Record Currency;
    begin
        PurchHeader.GET(PurchaseLine."Document Type", PurchaseLine."Document No.");
        Currency.GET(PurchaseLine."Currency Code");
        IF PurchaseLine."Line Amount" <> PurchaseLine."Inv. Discount Amount" THEN BEGIN
            if PurchHeader."Prices Including VAT" then
                case PurchaseLine."VAT Calculation Type" of
                    PurchaseLine."VAT Calculation Type"::"Normal VAT",
                    PurchaseLine."VAT Calculation Type"::"Reverse Charge VAT":
                        begin
                            if (PurchaseLine.Type in
                                [PurchaseLine.Type::"G/L Account", PurchaseLine.Type::Item, PurchaseLine.Type::"Fixed Asset"]) then begin
                                PurchaseLine."VAT Base (Non Deductible)" :=
                                    ROUND(
                                    PurchaseLine."VAT Base Amount" * PurchaseLine."VAT % (Non Deductible)" / 100,
                                    Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
                                PurchaseLine."VAT Amount (Non Deductible)" :=
                                    ROUND(
                                    PurchaseLine."VAT Base (Non Deductible)" * PurchaseLine."VAT %" / 100,
                                    Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
                            end;
                        end;
                end
            else
                CASE PurchaseLine."VAT Calculation Type" OF
                    PurchaseLine."VAT Calculation Type"::"Normal VAT",
                    PurchaseLine."VAT Calculation Type"::"Reverse Charge VAT":
                        begin
                            IF (PurchaseLine.Type IN [PurchaseLine.Type::"G/L Account", PurchaseLine.Type::Item, PurchaseLine.Type::"Fixed Asset"]) THEN BEGIN
                                PurchaseLine."VAT Base (Non Deductible)" :=
                                    ROUND(
                                        PurchaseLine."VAT Base Amount" * PurchaseLine."VAT % (Non Deductible)" / 100,
                                        Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
                                PurchaseLine."VAT Amount (Non Deductible)" :=
                                    ROUND(
                                        PurchaseLine."VAT Base (Non Deductible)" * PurchaseLine."VAT %" / 100,
                                        Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
                            END;
                        end;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnUpdateVATOnLinesOnAfterCalculateAmounts', '', true, true)]
    local procedure UpdateVATOnLines(var PurchaseLine: Record "Purchase Line")
    var
        Currency: Record Currency;
    begin
        IF (PurchaseLine.Type IN [PurchaseLine.Type::"G/L Account", PurchaseLine.Type::Item, PurchaseLine.Type::"Fixed Asset"]) THEN BEGIN
            PurchaseLine."VAT Base (Non Deductible)" :=
              ROUND(
                PurchaseLine."VAT Base Amount" * PurchaseLine."VAT % (Non Deductible)" / 100,
                Currency."Amount Rounding Precision");
            PurchaseLine."VAT Amount (Non Deductible)" :=
              ROUND(
                PurchaseLine."VAT Base (Non Deductible)" * PurchaseLine."VAT %" / 100,
                Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnCalcVATAmountLinesOnAfterCalcLineTotals', '', true, true)]
    local procedure ClacVATAmountLines(var VATAmountLine: Record "VAT Amount Line"; PurchaseLine: Record "Purchase Line"; QtyType: Option General,Invoicing,Shipping; Currency: Record Currency)
    begin

        if (PurchaseLine.Type in [PurchaseLine.Type::"G/L Account", PurchaseLine.Type::Item, PurchaseLine.Type::"Fixed Asset"]) then
            if VATAmountLine."VAT % (Non Deductible)" = 0 then
                VATAmountLine."VAT % (Non Deductible)" := PurchaseLine."VAT % (Non Deductible)";

        case QtyType of
            QtyType::General:
                begin
                    if (PurchaseLine.Type in [PurchaseLine.Type::"G/L Account", PurchaseLine.Type::Item, PurchaseLine.Type::"Fixed Asset"]) then begin
                        VATAmountLine."VAT Base (Non Deductible)" :=
                          VATAmountLine."VAT Base (Non Deductible)" + PurchaseLine."VAT Base (Non Deductible)";
                        VATAmountLine."VAT Amount (Non Deductible)" :=
                          VATAmountLine."VAT Amount (Non Deductible)" + PurchaseLine."VAT Amount (Non Deductible)";
                    end;
                end;
            QtyType::Invoicing:
                begin
                    if (PurchaseLine.Type in [PurchaseLine.Type::"G/L Account", PurchaseLine.Type::Item, PurchaseLine.Type::"Fixed Asset"]) then begin
                        VATAmountLine."VAT Base (Non Deductible)" :=
                          VATAmountLine."VAT Base (Non Deductible)" +
                          ROUND(PurchaseLine."VAT Base (Non Deductible)", Currency."Amount Rounding Precision");
                        VATAmountLine."VAT Amount (Non Deductible)" :=
                          VATAmountLine."VAT Amount (Non Deductible)" +
                          ROUND(PurchaseLine."VAT Amount (Non Deductible)", Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
                    end;
                end;

        end;

    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnBeforeCalcPrepaymentToDeduct', '', true, true)]
    local procedure CalcPrepmtAmountToDeduct(var PurchaseLine: Record "Purchase Line"; var IsHandled: Boolean)
    var
        PurchHeader: Record "Purchase Header";
        Currency: Record Currency;
    begin
        PurchHeader.GET(PurchaseLine."Document Type", PurchaseLine."Document No.");
        Currency.GET(PurchaseLine."Currency Code");
        if PurchHeader."Prices Including VAT" then
            PurchaseLine."Prepmt Amt to Deduct" :=
                ROUND(
                ROUND(
                    ROUND(
                    ROUND(PurchaseLine."Direct Unit Cost" * PurchaseLine."Qty. to Invoice", Currency."Amount Rounding Precision") *
                    (1 - (PurchaseLine."Line Discount %" / 100)), Currency."Amount Rounding Precision") *
                    (PurchaseLine."Prepayment %" / 100) / (1 + (PurchaseLine."VAT %" / 100)), Currency."Amount Rounding Precision") *
                (1 + (PurchaseLine."VAT %" / 100)), Currency."Amount Rounding Precision")
        else
            PurchaseLine."Prepmt Amt to Deduct" :=
                ROUND(
                ROUND(
                    ROUND(PurchaseLine."Direct Unit Cost" * PurchaseLine."Qty. to Invoice", Currency."Amount Rounding Precision") *
                    (1 - (PurchaseLine."Line Discount %" / 100)), Currency."Amount Rounding Precision") *
                PurchaseLine."Prepayment %" / 100, Currency."Amount Rounding Precision");
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnBeforeUpdatePrepmtAmounts', '', true, true)]
    local procedure UpdatePrpmtAmounts(var PurchaseLine: Record "Purchase Line"; var IsHandled: Boolean)
    var
        ReceiptLine: Record "Purch. Rcpt. Line";
        PurchOrderLine: Record "Purchase Line";
        PurchOrderHeader: Record "Purchase Header";
        Currency: Record Currency;
        PurchHeader: Record "Purchase Header";
    begin
        if (PurchaseLine."Document Type" <> PurchaseLine."Document Type"::Invoice) or (PurchaseLine."Prepayment %" = 0) then begin
            IsHandled := true;
            exit;
        end;
        Currency.GET(PurchaseLine."Currency Code");
        if not ReceiptLine.GET(PurchaseLine."Receipt No.", PurchaseLine."Receipt Line No.") then begin
            PurchaseLine."Prepmt Amt to Deduct" := 0;
            PurchaseLine."Prepmt VAT Diff. to Deduct" := 0;
        end else
            if PurchOrderLine.GET(PurchOrderLine."Document Type"::Order, ReceiptLine."Order No.", ReceiptLine."Order Line No.") then begin
                if (PurchaseLine."Prepayment %" = 100) and (PurchaseLine.Quantity <> PurchOrderLine.Quantity - PurchOrderLine."Quantity Invoiced") then
                    PurchaseLine."Prepmt Amt to Deduct" := PurchaseLine."Line Amount"
                else
                    PurchaseLine."Prepmt Amt to Deduct" :=
                      ROUND((PurchOrderLine."Prepmt. Amt. Inv." - PurchOrderLine."Prepmt Amt Deducted") *
                        PurchaseLine.Quantity / (PurchOrderLine.Quantity - PurchOrderLine."Quantity Invoiced"), Currency."Amount Rounding Precision");
                PurchaseLine."Prepmt VAT Diff. to Deduct" := PurchaseLine."Prepayment VAT Difference" - PurchaseLine."Prepmt VAT Diff. Deducted";
                PurchOrderHeader.GET(PurchOrderHeader."Document Type"::Order, PurchOrderLine."Document No.");
            end else begin
                PurchaseLine."Prepmt Amt to Deduct" := 0;
                PurchaseLine."Prepmt VAT Diff. to Deduct" := 0;
            end;

        PurchHeader.GET(PurchaseLine."Document Type", PurchaseLine."Document No.");
        PurchHeader.TESTFIELD("Prices Including VAT", PurchOrderHeader."Prices Including VAT");
        if PurchHeader."Prices Including VAT" then begin
            PurchaseLine."Prepmt. Line Amount" := PurchaseLine."Prepmt Amt to Deduct";
            PurchaseLine."Prepmt. Amt. Incl. VAT" := PurchaseLine."Prepmt. Line Amount";
            PurchaseLine."Prepmt. VAT Base Amt." :=
              ROUND(PurchaseLine."Prepmt Amt to Deduct" / (1 + (PurchaseLine."Prepayment VAT %" / 100)), Currency."Amount Rounding Precision");
            PurchaseLine."Prepayment Amount" := PurchaseLine."Prepmt. VAT Base Amt.";
        end else begin
            PurchaseLine."Prepmt. Line Amount" := PurchaseLine."Prepmt Amt to Deduct";
            PurchaseLine."Prepmt. Amt. Incl. VAT" :=
              ROUND(
                PurchaseLine."Prepmt Amt to Deduct" * (1 + (PurchaseLine."Prepayment VAT %" / 100)),
                Currency."Amount Rounding Precision");
            PurchaseLine."Prepmt. VAT Base Amt." := PurchaseLine."Prepmt Amt to Deduct";
            PurchaseLine."Prepayment Amount" := PurchaseLine."Prepmt Amt to Deduct";
        end;
        PurchaseLine."Prepmt. Line Amount" := PurchaseLine."Prepmt Amt to Deduct";
        PurchaseLine."Prepmt. Amt. Inv." := PurchaseLine."Prepmt. Line Amount";
        PurchaseLine."Prepmt. VAT Base Amt." := PurchaseLine."Prepayment Amount";
        PurchaseLine."Prepmt. Amount Inv. Incl. VAT" := PurchaseLine."Prepmt. Line Amount";
        PurchaseLine."Prepmt Amt Deducted" := 0;
        IsHandled := true;
    end;
}