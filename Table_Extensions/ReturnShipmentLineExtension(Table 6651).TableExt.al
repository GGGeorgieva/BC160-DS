tableextension 46015598 "Return Shipment Line Extension" extends "Return Shipment Line"
{
    // version NAVW111.00,NAVBG11.0

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
    }
    procedure ExciseLabels();
    VAR
        ExciseLabelLedgerEntry: Record "Excise Label Ledger Entry";
    BEGIN
        TESTFIELD(Type, Type::Item.AsInteger());
        TESTFIELD(Quantity);

        ExciseLabelLedgerEntry.FILTERGROUP := 2;
        ExciseLabelLedgerEntry.SETRANGE("Entry Type", ExciseLabelLedgerEntry."Entry Type"::Purchase);
        if "Return Order No." <> '' then
            ExciseLabelLedgerEntry.SETRANGE("Document Type", ExciseLabelLedgerEntry."Document Type"::"Return Order")
        else
            ExciseLabelLedgerEntry.SETRANGE("Document Type", ExciseLabelLedgerEntry."Document Type"::"Credit Memo");
        ExciseLabelLedgerEntry.SETRANGE("Document No.", "Document No.");
        ExciseLabelLedgerEntry.SETRANGE("Document Line No.", "Line No.");
        ExciseLabelLedgerEntry.FILTERGROUP := 0;
        //TODO: After adding the page
        //PAGE.RUNMODAL(PAGE::Page46015718,ExciseLabelLedgerEntry);
    END;

}

