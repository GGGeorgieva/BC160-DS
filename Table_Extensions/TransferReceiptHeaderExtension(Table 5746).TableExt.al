tableextension 46015594 "Transfer Receipt Header Ext." extends "Transfer Receipt Header"
{
    fields
    {
        field(46015505; "Excise Tax Document No."; Code[20])
        {
            Caption = 'Excise Tax Document No.';
            Description = 'NAVBG11.0,001';
        }
        field(46015506; "Excise Document Date"; Date)
        {
            Caption = 'Excise Document Date';
            Description = 'NAVBG11.0,001';
        }
        field(46015507; "Return Date of AAD"; Date)
        {
            Caption = 'Return Date of AAD';
            Description = 'NAVBG11.0,001';
        }
        field(46015508; "Excise Tax Document No. Series"; Code[10])
        {
            Caption = 'Excise Tax Document No. Series';
            Description = 'NAVBG11.0,001';
            TableRelation = "No. Series";
        }
        field(46015509; "Excise Tax Document Type"; Option)
        {
            Caption = 'Excise Tax Document Type';
            Description = 'NAVBG11.0,001';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Transfer Order,Posted Sales Shipment,Posted Sales Invoice,Posted Transfer Receipt,Posted Transfer Shipment';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","Transfer Order","Posted Sales Shipment","Posted Sales Invoice","Posted Transfer Receipt","Posted Transfer Shipment";
        }
        field(46015510; "Outbound Excise Destination"; Code[2])
        {
            Caption = 'Outbound Excise Destination';
            Description = 'NAVBG11.0,001';
            TableRelation = "Excise Destination".Code WHERE("Destination Type" = CONST(Outbound));

            trigger OnValidate();
            var
                lRecTransLine: Record "Transfer Line";
            begin
            end;
        }
        field(46015511; "Inbound Excise Destination"; Code[2])
        {
            Caption = 'Inbound Excise Destination';
            Description = 'NAVBG11.0,001';
            TableRelation = "Excise Destination".Code WHERE("Destination Type" = CONST(Inbound));

            trigger OnValidate();
            var
                lRecTransLine: Record "Transfer Line";
            begin
            end;
        }
        field(46015512; "Payment Obligation Type"; Code[2])
        {
            Caption = 'Payment Obligation Type';
            Description = 'NAVBG11.0,001';
            TableRelation = "Payment Obligation Type";
        }
        field(46015513; "Excise Charge Ground Code"; Code[20])
        {
            Caption = 'Excise Charge Ground Code';
            Description = 'NAVBG11.0,001';
            TableRelation = "Excise Charge Ground";
        }
    }

    trigger OnDelete();
    begin
        ExciseTaxDoc.SETCURRENTKEY("Document Type", "Corresponding Doc. No.");
        ExciseTaxDoc.SETRANGE(ExciseTaxDoc."Corresponding Doc. No.", "No.");
        ExciseTaxDoc.SETRANGE(ExciseTaxDoc."Document Type", ExciseTaxDoc."Document Type"::"Posted Transfer Receipt");
        ExciseTaxDoc.DELETEALL;
    end;

    var
        ExciseTaxDoc: Record "Excise Tax Document";
}

