table 46015690 "Excise Tax Document"
{
    // version NAVBG11.0

    // -----------------------------------------------------------------------------------------
    // Dynamic Solutions
    // MS Dynamics NAV 2017 Localisation
    // 
    // 
    // -----------------------------------------------------------------------------------------
    // No.   Sign     Date       Version        Description
    // -----------------------------------------------------------------------------------------
    // 001                        NAVBG11.0
    // -----------------------------------------------------------------------------------------

    Caption = 'Excise Tax Document';
    //LookupPageID = "Excise Tax Document List";

    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = false;
            Caption = 'Line No.';
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
            NotBlank = true;
        }
        field(3; "Corresponding Doc. No."; Code[20])
        {
            Caption = 'Corresponding Doc. No.';
        }
        field(4; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Transfer Order,Posted Sales Shipment,Posted Sales Invoice,Posted Sales Cr.Memo,Posted Transfer Receipt,Posted Transfer Shipment';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","Transfer Order","Posted Sales Shipment","Posted Sales Invoice","Posted Sales Cr.Memo","Posted Transfer Receipt","Posted Transfer Shipment";
        }
        field(5; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
        }
        field(6; "Sell-to Customer Name"; Text[30])
        {
            Caption = 'Sell-to Customer Name';
        }
        field(7; "Transfer-From Code"; Code[10])
        {
            Caption = 'Transfer-From Code';
        }
        field(8; "Transfer-To Code"; Code[10])
        {
            Caption = 'Transfer-To Code';
        }
    }

    keys
    {
        key(Key1; "Line No.")
        {
        }
        key(Key2; "Document Type", "Corresponding Doc. No.")
        {
        }
        key(Key3; "Document Type", "Corresponding Doc. No.", "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        if "Line No." = 0 then "Line No." := GetNextNo;
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Text001: Label 'Please specify the number for Excise Tax Document';
        Text002: Label 'It is not possible to modify the number of the excise document';
        NoOfRecords: Integer;
        Text003: Label '%1 %2 already exists as an excise document';

    procedure SalesDocAssistEdit(var SalesHeader: Record "Sales Header"; OldSalesHeader: Record "Sales Header"): Boolean;
    var
        SalesHeaderNew: Record "Sales Header";
    begin
        with SalesHeader do begin
            SalesHeader.TESTFIELD("Excise Tax Document No.", '');
            SalesSetup.GET;
            SalesSetup.TESTFIELD("Excise Tax Document Nos.");
            if NoSeriesMgt.SelectSeries(SalesSetup."Excise Tax Document Nos.",
              OldSalesHeader."Excise Tax Document No. Series", "Excise Tax Document No. Series") then begin
                NoSeriesMgt.SetSeries("Excise Tax Document No.");
                VALIDATE("Excise Tax Document No.");
                exit(true);
            end;
        end;
    end;

    procedure TransOrderAssistEdit(var TransHeader: Record "Transfer Header"; OldTransHeader: Record "Transfer Header"): Boolean;
    begin
        with TransHeader do begin
            TransHeader.TESTFIELD("Excise Tax Document No.", '');
            SalesSetup.GET;
            SalesSetup.TESTFIELD("Excise Tax Document Nos.");
            if NoSeriesMgt.SelectSeries(SalesSetup."Excise Tax Document Nos.",
              OldTransHeader."Excise Tax Document No. Series", "Excise Tax Document No. Series") then begin
                NoSeriesMgt.SetSeries("Excise Tax Document No.");
                VALIDATE("Excise Tax Document No.");
                exit(true);
            end;
        end;
    end;

    procedure ValidateWithSalesValues(var SalesHeader: Record "Sales Header");
    begin
        VALIDATE("No.", SalesHeader."Excise Tax Document No.");
        VALIDATE("Sell-to Customer No.", SalesHeader."Sell-to Customer No.");
        VALIDATE("Sell-to Customer Name", SalesHeader."Sell-to Customer Name");
        VALIDATE("Corresponding Doc. No.", SalesHeader."No.");
        VALIDATE("Document Type", SalesHeader."Document Type");

        SETCURRENTKEY("Document Type", "Corresponding Doc. No.");
        SETRANGE("Document Type", SalesHeader."Document Type");
        SETRANGE("Corresponding Doc. No.", SalesHeader."No.");

        if FINDFIRST then begin
            SalesHeader."Excise Tax Document No." := "No.";
            ERROR(Text003, "Document Type", "Corresponding Doc. No.");
        end;

        INSERT;
    end;

    procedure ValidateWithTransferValues(var TransHeader: Record "Transfer Header");
    begin
        VALIDATE("No.", TransHeader."Excise Tax Document No.");
        VALIDATE("Transfer-To Code", TransHeader."Transfer-to Code");
        VALIDATE("Transfer-From Code", TransHeader."Transfer-from Code");
        VALIDATE("Corresponding Doc. No.", TransHeader."No.");
        VALIDATE("Document Type", TransHeader."Excise Tax Document Type");

        SETCURRENTKEY("Document Type", "Corresponding Doc. No.");
        SETRANGE("Document Type", TransHeader."Excise Tax Document Type");
        SETRANGE("Corresponding Doc. No.", TransHeader."No.");

        if FINDFIRST then begin
            TransHeader."Excise Tax Document No." := "No.";
            ERROR(Text003, "Document Type", "Corresponding Doc. No.");
        end;

        INSERT;
    end;

    procedure GetNextNo(): Integer;
    var
        lRecExiceDoc: Record "Excise Tax Document";
    begin
        if lRecExiceDoc.FINDLAST then
            exit(lRecExiceDoc."Line No." + 1)
        else
            exit(1);
    end;

    procedure Show(ExciseTaxDoc: Record "Excise Tax Document");
    var
        SalesHeader: Record "Sales Header";
        TransHeader: Record "Transfer Header";
        SalesShptHeader: Record "Sales Shipment Header";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        TransShptHeader: Record "Transfer Shipment Header";
        TransRcptHeader: Record "Transfer Receipt Header";
    begin
        with ExciseTaxDoc do begin
            case "Document Type" of
                "Document Type"::Order:
                    begin
                        SalesHeader.SETRANGE(SalesHeader."No.", ExciseTaxDoc."Corresponding Doc. No.");
                        PAGE.RUNMODAL(PAGE::"Sales Order", SalesHeader);
                    end;
                "Document Type"::Invoice:
                    begin
                        SalesHeader.SETRANGE(SalesHeader."No.", "Corresponding Doc. No.");
                        PAGE.RUNMODAL(PAGE::"Sales Invoice", SalesHeader);
                    end;
                "Document Type"::"Credit Memo":
                    begin
                        SalesHeader.SETRANGE(SalesHeader."No.", "Corresponding Doc. No.");
                        PAGE.RUNMODAL(PAGE::"Sales Credit Memo", SalesHeader);
                    end;
                "Document Type"::"Transfer Order":
                    begin
                        TransHeader.SETRANGE(TransHeader."No.", "Corresponding Doc. No.");
                        PAGE.RUNMODAL(PAGE::"Transfer Order", TransHeader);
                    end;
                "Document Type"::"Posted Sales Shipment":
                    begin
                        SalesShptHeader.SETRANGE(SalesShptHeader."No.", "Corresponding Doc. No.");
                        SalesShptHeader.SETRANGE(SalesShptHeader."Excise Tax Document No.", "No.");
                        PAGE.RUNMODAL(PAGE::"Posted Sales Shipment", SalesShptHeader);
                    end;
                "Document Type"::"Posted Sales Invoice":
                    begin
                        SalesInvHeader.SETRANGE(SalesInvHeader."No.", "Corresponding Doc. No.");
                        SalesInvHeader.SETRANGE(SalesInvHeader."Excise Tax Document No.", "No.");
                        PAGE.RUNMODAL(PAGE::"Posted Sales Invoice", SalesInvHeader);
                    end;
                "Document Type"::"Posted Sales Cr.Memo":
                    begin
                        SalesCrMemoHeader.SETRANGE(SalesCrMemoHeader."No.", "Corresponding Doc. No.");
                        SalesCrMemoHeader.SETRANGE(SalesCrMemoHeader."Excise Tax Document No.", "No.");
                        PAGE.RUNMODAL(PAGE::"Posted Sales Credit Memo", SalesCrMemoHeader);
                    end;
                "Document Type"::"Posted Transfer Receipt":
                    begin
                        TransRcptHeader.SETRANGE(TransRcptHeader."No.", "Corresponding Doc. No.");
                        TransRcptHeader.SETRANGE(TransRcptHeader."Excise Tax Document No.", "No.");
                        PAGE.RUNMODAL(PAGE::"Posted Transfer Receipt", TransRcptHeader);
                    end;
                "Document Type"::"Posted Transfer Shipment":
                    begin
                        TransShptHeader.SETRANGE(TransShptHeader."No.", "Corresponding Doc. No.");
                        TransShptHeader.SETRANGE(TransShptHeader."Excise Tax Document No.", "No.");
                        PAGE.RUNMODAL(PAGE::"Posted Transfer Shipment", TransShptHeader);
                    end;
            end;
        end;
    end;
}

