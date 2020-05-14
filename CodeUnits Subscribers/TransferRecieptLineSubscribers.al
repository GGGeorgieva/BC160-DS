codeunit 46015806 "Trans.Rec. Line Subscribers"
{
    [EventSubscriber(ObjectType::Table, Database::"Transfer Receipt Line", 'OnAfterCopyFromTransferLine', '', true, true)]
    local procedure CopyFromTransferLineBG(var TransferReceiptLine: Record "Transfer Receipt Line"; TransferLine: Record "Transfer Line")
    begin
        TransferReceiptLine."Inbound Excise Destination" := TransferLine."Inbound Excise Destination";
        TransferReceiptLine."Outbound Excise Destination" := TransferLine."Outbound Excise Destination";
        TransferReceiptLine."Additional Excise Code" := TransferLine."Additional Excise Code";
        TransferReceiptLine."Unit Excise" := TransferLine."Unit Excise";
        TransferReceiptLine."Excise Amount" := TransferLine."Excise Amount";
        TransferReceiptLine."Excise Item" := TransferLine."Excise Item";
        TransferReceiptLine."Calculate Excise" := TransferLine."Calculate Excise";
        TransferReceiptLine."CN Code" := TransferLine."CN Code";
        TransferReceiptLine."Alcohol Content/Degree Plato" := TransferLine."Alcohol Content/Degree Plato";
        TransferReceiptLine."Excise Unit of Measure" := TransferLine."Excise Unit of Measure";
        TransferReceiptLine."Excise Rate" := TransferLine."Excise Rate";
        TransferReceiptLine."Excise Charge Acc. Base" := TransferLine."Excise Charge Acc. Base";
        TransferReceiptLine."Payment Obligation Type" := TransferLine."Payment Obligation Type";
    end;
}
