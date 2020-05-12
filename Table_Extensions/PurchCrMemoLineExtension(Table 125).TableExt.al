tableextension 46015518 "Purch. Cr. Memo Line Ext." extends "Purch. Cr. Memo Line"
{
    // version NAVW111.00.00.24742,NAVE111.0,NAVBG11.0


    fields

    {
        field(46015543; "Inbound Excise Destination"; Code[2])
        {
            Caption = 'Inbound Excise Destination';
            Description = 'NAVBG11.0,001';
            TableRelation = "Excise Destination";
        }
        field(46015549; "Additional Excise Code"; Text[13])
        {
            Caption = 'Additional Excise Code';
            Description = 'NAVBG11.0,001';
            Numeric = true;
        }
        field(46015607; "Tariff No."; Code[10])
        {
            Caption = 'Tariff No.';
            Description = 'NAVE111.0,001';
            TableRelation = "Tariff Number";
        }
        field(46015609; "Country/Region of Origin Code"; Code[10])
        {
            Caption = 'Country/Region of Origin Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Country/Region";
        }
        field(46015610; "VAT Date"; Date)
        {
            Caption = 'VAT Date';
            Description = 'NAVE111.0,001';
        }
        field(46015625; "SAD No."; Code[20])
        {
            Caption = 'SAD No.';
            Description = 'NAVE111.0,001';
            TableRelation = "Import SAD Header" WHERE("Vendor No." = FIELD("Buy-from Vendor No."));
            ValidateTableRelation = false;
        }
        field(46015635; "VAT % (Non Deductible)"; Decimal)
        {
            Caption = 'VAT % (Non Deductible)';
            Description = 'NAVE111.0,001';
            MaxValue = 100;
            MinValue = 0;
        }
        field(46015636; "VAT Base (Non Deductible)"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            Caption = 'VAT Base (Non Deductible)';
            Description = 'NAVE111.0,001';
            Editable = false;
        }
        field(46015637; "VAT Amount (Non Deductible)"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            Caption = 'VAT Amount (Non Deductible)';
            Description = 'NAVE111.0,001';
            Editable = false;
        }
    }

    procedure CopyToVATProtocolLine(PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr."; var VATProtocolLine: Record "VAT Protocol Line");
    var
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        VATProtocolLine."VAT Prod. Posting Group" := "VAT Prod. Posting Group";
        //TODO: Create Vat Prot. Line Type enum
        VATProtocolLine.Type := Type;
        VATProtocolLine."No." := "No.";
        VATProtocolLine.Description := Description;
        VATProtocolLine."Description 2" := "Description 2";
        VATProtocolLine."Unit of Measure Code" := "Unit of Measure Code";
        VATProtocolLine.Quantity := Quantity;
        if PurchCrMemoHeader."Currency Code" = '' then
            VATProtocolLine."VAT Base Amount (LCY)" := Amount
        else
            VATProtocolLine."VAT Base Amount (LCY)" :=
              CurrExchRate.ExchangeAmtFCYToLCY(
                PurchCrMemoHeader."Posting Date", PurchCrMemoHeader."Currency Code", Amount, PurchCrMemoHeader."Currency Factor");
    end;

    procedure ExciseLabels();
    var
        ExciseLabelLedgerEntry: Record "Excise Label Ledger Entry";
        ItemLedgEntryNo: Integer;
    begin
        TESTFIELD(Type, Type::Item.AsInteger());
        TESTFIELD(Quantity);

        ExciseLabelLedgerEntry.FILTERGROUP := 2;
        ExciseLabelLedgerEntry.SETRANGE("Entry Type", ExciseLabelLedgerEntry."Entry Type"::Purchase);
        ExciseLabelLedgerEntry.SETRANGE("Item Ledger Entry No.", FindItemLedgEntryNo);
        ExciseLabelLedgerEntry.FILTERGROUP := 0;

        //TODO: after adding the page
        //PAGE.RUNMODAL(PAGE::Page46015718,ExciseLabelLedgerEntry);
    end;

    procedure FindItemLedgEntryNo(): Integer;
    var
        ValueEntry: Record "Value Entry";
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        LineCount: Integer;
    begin
        ValueEntry.SETRANGE("Document No.", "Document No.");
        ValueEntry.SETRANGE("Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Purchase);
        ValueEntry.SETRANGE("Item No.", "No.");
        ValueEntry.SETRANGE("Source No.", "Buy-from Vendor No.");
        ValueEntry.SETRANGE("Location Code", "Location Code");
        ValueEntry.SETRANGE("Item Ledger Entry Quantity", -Quantity);

        if ValueEntry.FINDFIRST then begin
            if ValueEntry.COUNT > 1 then begin
                PurchCrMemoLine.SETRANGE("Document No.", "Document No.");
                PurchCrMemoLine.SETRANGE("No.", "No.");
                PurchCrMemoLine.SETRANGE("Location Code", "Location Code");
                PurchCrMemoLine.SETRANGE(Quantity, Quantity);
                if PurchCrMemoLine.FINDFIRST then
                    repeat
                        LineCount := LineCount + 1;
                    until (PurchCrMemoLine."Line No." = "Line No.") or (PurchCrMemoLine.NEXT = 0);

                ValueEntry.NEXT(LineCount - 1);
            end;

            exit(ValueEntry."Item Ledger Entry No.");
        end;

        exit(0);
    END;

}

