codeunit 46015807 "Trans.Ship. Header Subsribers"
{
    [EventSubscriber(ObjectType::Table, Database::"Transfer Shipment Header", 'OnAfterCopyFromTransferHeader', '', true, true)]
    local procedure CopyFromTransferHeaderBG(var TransferShipmentHeader: Record "Transfer Shipment Header"; TransferHeader: Record "Transfer Header")
    begin
        TransferShipmentHeader."Excise Tax Document No." := TransferHeader."Excise Tax Document No.";
        TransferShipmentHeader."Excise Document Date" := TransferHeader."Excise Document Date";
        TransferShipmentHeader."Return Date of AAD" := TransferHeader."Return Date of AAD";
        TransferShipmentHeader."Payment Obligation Type" := TransferHeader."Payment Obligation Type";
        TransferShipmentHeader."Excise Charge Ground Code" := TransferHeader."Excise Charge Ground Code";
        TransferShipmentHeader."Outbound Excise Destination" := TransferHeader."Outbound Excise Destination";
        TransferShipmentHeader."Inbound Excise Destination" := TransferHeader."Inbound Excise Destination";
    end;
}
