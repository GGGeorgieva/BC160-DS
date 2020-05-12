tableextension 46015514 "Purch. Rcpt. Line Extension" extends "Purch. Rcpt. Line"
{
    // version NAVW111.00.00.28629,NAVE111.0,NAVBG11.0

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
    }
    procedure ExciseLabels();
    var
        ExciseLabelLedgerEntry: Record "Excise Label Ledger Entry";
    begin
        TESTFIELD(Type, Type::Item.AsInteger());
        TESTFIELD(Quantity);

        ExciseLabelLedgerEntry.FILTERGROUP := 2;
        ExciseLabelLedgerEntry.SETRANGE("Entry Type", ExciseLabelLedgerEntry."Entry Type"::Purchase);
        if "Order No." <> '' then
            ExciseLabelLedgerEntry.SETRANGE("Document Type", ExciseLabelLedgerEntry."Document Type"::Order)
        else
            ExciseLabelLedgerEntry.SETRANGE("Document Type", ExciseLabelLedgerEntry."Document Type"::Invoice);
        ExciseLabelLedgerEntry.SETRANGE("Document No.", "Document No.");
        ExciseLabelLedgerEntry.SETRANGE("Document Line No.", "Line No.");
        ExciseLabelLedgerEntry.FILTERGROUP := 0;
        //TODO: After adding the page
        //PAGE.RUNMODAL(PAGE::Page46015718,ExciseLabelLedgerEntry);
    end;
}

