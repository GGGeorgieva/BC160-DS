codeunit 46015803 "Trans. ReceiptHea. Subscribers"
{
    [EventSubscriber(ObjectType::Table, Database::"Transfer Receipt Header", 'OnAfterCopyFromTransferHeader', '', true, true)]
    local procedure CopyFromTransferHeaderBGLoc(var TransferReceiptHeader: Record "Transfer Receipt Header"; TransferHeader: Record "Transfer Header")
    begin
        TransferReceiptHeader."Excise Tax Document No." := TransferHeader."Excise Tax Document No.";
        TransferReceiptHeader."Excise Document Date" := TransferHeader."Excise Document Date";
        TransferReceiptHeader."Return Date of AAD" := TransferHeader."Return Date of AAD";
        TransferReceiptHeader."Payment Obligation Type" := TransferHeader."Payment Obligation Type";
        TransferReceiptHeader."Outbound Excise Destination" := TransferHeader."Outbound Excise Destination";
        TransferReceiptHeader."Inbound Excise Destination" := TransferHeader."Inbound Excise Destination";
    end;
}
