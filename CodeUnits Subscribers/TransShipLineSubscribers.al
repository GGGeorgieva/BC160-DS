codeunit 46015808 "Trans.Ship. Line Subscribers"
{
    [EventSubscriber(ObjectType::Table, database::"Transfer Shipment Line", 'OnAfterCopyFromTransferLine', '', true, true)]
    local procedure CopyFromTransferLineBG(var TransferShipmentLine: Record "Transfer Shipment Line"; TransferLine: Record "Transfer Line")
    begin
        TransferShipmentLine."Inbound Excise Destination" := TransferLine."Inbound Excise Destination";
        TransferShipmentLine."Outbound Excise Destination" := TransferLine."Outbound Excise Destination";
        TransferShipmentLine."Additional Excise Code" := TransferLine."Additional Excise Code";
    end;
}
