tableextension 46015510 "Sales Invoice Line Extension" extends "Sales Invoice Line"
{
    // version NAVW111.00.00.24742,NAVE111.0,NAVBG11.0

    fields
    {
        field(46015505; "Unit Excise (LCY)"; Decimal)
        {
            Caption = 'Unit Excise (LCY)';
            DecimalPlaces = 2 : 5;
            Description = 'NAVBG11.0,001';
        }
        field(46015506; "Unit Excise"; Decimal)
        {
            Caption = 'Unit Excise';
            DecimalPlaces = 2 : 5;
            Description = 'NAVBG11.0,001';
            Editable = false;
        }
        field(46015507; "Excise Amount (LCY)"; Decimal)
        {
            Caption = 'Excise Amount (LCY)';
            Description = 'NAVBG11.0,001';
            Editable = false;
        }
        field(46015508; "Excise Amount"; Decimal)
        {
            Caption = 'Excise Amount';
            Description = 'NAVBG11.0,001';
            Editable = false;
        }
        field(46015509; "Calculate Excise (Cust.)"; Boolean)
        {
            Caption = 'Calculate Excise (Cust.)';
            Description = 'NAVBG11.0,001';
        }
        field(46015510; "Unit Product Tax (LCY)"; Decimal)
        {
            Caption = 'Unit Product Tax (LCY)';
            DecimalPlaces = 2 : 5;
            Description = 'NAVBG11.0,001';
        }
        field(46015511; "Unit Product Tax"; Decimal)
        {
            Caption = 'Unit Product Tax';
            DecimalPlaces = 2 : 5;
            Description = 'NAVBG11.0,001';
            Editable = false;
        }
        field(46015512; "Product Tax Amount (LCY)"; Decimal)
        {
            Caption = 'Product Tax Amount (LCY)';
            Description = 'NAVBG11.0,001';
            Editable = false;
        }
        field(46015513; "Product Tax Amount"; Decimal)
        {
            Caption = 'Product Tax Amount';
            Description = 'NAVBG11.0,001';
            Editable = false;
        }
        field(46015514; "Calculate Product Tax (Cust.)"; Boolean)
        {
            Caption = 'Calculate Product Tax (Cust.)';
            Description = 'NAVBG11.0,001';
        }
        field(46015515; Product; Boolean)
        {
            Caption = 'Product';
            Description = 'NAVBG11.0,001';
            Editable = false;
        }
        field(46015516; "Amount Incl. Taxes Excl. VAT"; Decimal)
        {
            Caption = 'Amount Incl. Taxes Excl. VAT';
            Description = 'NAVBG11.0,001';
        }
        field(46015517; "Excise Item"; Boolean)
        {
            Caption = 'Excise Item';
            Description = 'NAVBG11.0,001';
        }
        field(46015518; "Calculate Excise"; Boolean)
        {
            Caption = 'Calculate Excise';
            Description = 'NAVBG11.0,001';
        }
        field(46015519; "Product Tax Item"; Boolean)
        {
            Caption = 'Product Tax Item';
            Description = 'NAVBG11.0,001';
        }
        field(46015520; "Calculate Product Tax"; Boolean)
        {
            Caption = 'Calculate Product Tax';
            Description = 'NAVBG11.0,001';
        }
        field(46015541; "Amount for Print Preview"; Integer)
        {
            Caption = 'Amount for Print Preview';
            Description = 'NAVBG11.0,001';
            TableRelation = "Sales Invoice Line"."Line No." WHERE("Document No." = FIELD("Document No."));
        }
        field(46015542; "Quantity and Amount for Print"; Integer)
        {
            Caption = 'Quantity and Amount for Print';
            Description = 'NAVBG11.0,001';
            TableRelation = "Sales Invoice Line"."Line No." WHERE("Document No." = FIELD("Document No."));
        }
        field(46015543; "Outbound Excise Destination"; Code[2])
        {
            Caption = 'Outbound Excise Destination';
            Description = 'NAVBG11.0,001';
            TableRelation = "Excise Destination";
        }
        field(46015544; "CN Code"; Code[10])
        {
            Caption = 'CN Code';
            Description = 'NAVBG11.0,001';
        }
        field(46015545; "Alcohol Content/Degree Plato"; Decimal)
        {
            Caption = 'Alcohol Content/Degree Plato';
            Description = 'NAVBG11.0,001';
        }
        field(46015546; "Excise Unit of Measure"; Code[10])
        {
            Caption = 'Excise Unit of Measure';
            Description = 'NAVBG11.0,001';
        }
        field(46015547; "Excise Rate"; Decimal)
        {
            Caption = 'Excise Rate';
            Description = 'NAVBG11.0,001';
        }
        field(46015548; "Excise Charge Acc. Base"; Decimal)
        {
            Caption = 'Excise Charge Acc. Base';
            Description = 'NAVBG11.0,001';
        }
        field(46015549; "Additional Excise Code"; Text[13])
        {
            Caption = 'Additional Excise Code';
            Description = 'NAVBG11.0,001';
            Numeric = true;
        }
        field(46015550; "Do not include in Excise"; Boolean)
        {
            Caption = 'Do not include in Excise';
            Description = 'NAVBG11.0,001';
        }
        field(46015551; "Inbound excise destination"; Code[2])
        {
            Caption = 'Inbound excise destination';
            Description = 'NAVBG11.0,001';
        }
        field(46015552; "Excise Declaration Correction"; Boolean)
        {
            Caption = 'Excise Declaration Correction';
            Description = 'NAVBG11.0,001';
        }
        field(46015553; "Payment Obligation Type"; Code[2])
        {
            Caption = 'Payment Obligation Type';
            Description = 'NAVBG11.0,001';
            TableRelation = "Payment Obligation Type";
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
        field(46015626; "Export SAD No."; Code[20])
        {
            Caption = 'Export SAD No.';
            Description = 'NAVE111.0,001';
        }
    }
    procedure CopyToVATProtocolLine(SalesInvHeader: Record "Sales Invoice Header"; VAR VATProtocolLine: Record "VAT Protocol Line");
    var
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        //NAVE111.0; 001; entire function
        VATProtocolLine."VAT Prod. Posting Group" := "VAT Prod. Posting Group";
        //TODO: Create Vat Prot. Line Type enum
        VATProtocolLine.Type := Type;
        VATProtocolLine."No." := "No.";
        VATProtocolLine.Description := Description;
        VATProtocolLine."Description 2" := "Description 2";
        VATProtocolLine."Unit of Measure Code" := "Unit of Measure Code";
        VATProtocolLine.Quantity := Quantity;
        if SalesInvHeader."Currency Code" = '' then
            VATProtocolLine."VAT Base Amount (LCY)" := "Amount Incl. Taxes Excl. VAT"
        else
            VATProtocolLine."VAT Base Amount (LCY)" :=
              CurrExchRate.ExchangeAmtFCYToLCY(
                SalesInvHeader."Posting Date", SalesInvHeader."Currency Code",
                "Amount Incl. Taxes Excl. VAT", SalesInvHeader."Currency Factor");
    end;

    procedure ExciseLabels();
    var
        ExciseLabelLedgerEntry: Record "Excise Label Ledger Entry";
        ItemLedgEntryNo: Integer;
    begin
        TESTFIELD(Type, 2);
        TESTFIELD(Quantity);

        ExciseLabelLedgerEntry.FILTERGROUP := 2;
        ExciseLabelLedgerEntry.SETRANGE("Entry Type", ExciseLabelLedgerEntry."Entry Type"::Sale);
        ExciseLabelLedgerEntry.SETRANGE("Item Ledger Entry No.", FindItemLedgEntryNo);
        ExciseLabelLedgerEntry.FILTERGROUP := 0;
        //TODO: After adding the page
        //PAGE.RUNMODAL(PAGE::Page46015718,ExciseLabelLedgerEntry);
    end;

    procedure FindItemLedgEntryNo(): Integer;
    var
        ValueEntry: Record "Value Entry";
        SalesInvLine: Record "Sales Invoice Line";
        LineCount: Integer;
    begin
        ValueEntry.SETRANGE("Document No.", "Document No.");
        ValueEntry.SETRANGE("Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Sale);
        ValueEntry.SETRANGE("Item No.", "No.");
        ValueEntry.SETRANGE("Source No.", "Sell-to Customer No.");
        ValueEntry.SETRANGE("Location Code", "Location Code");
        ValueEntry.SETRANGE("Item Ledger Entry Quantity", -Quantity);

        if ValueEntry.FINDFIRST then begin
            if ValueEntry.COUNT > 1 then begin
                SalesInvLine.SETRANGE("Document No.", "Document No.");
                SalesInvLine.SETRANGE("No.", "No.");
                SalesInvLine.SETRANGE("Location Code", "Location Code");
                SalesInvLine.SETRANGE(Quantity, Quantity);
                if SalesInvLine.FINDFIRST then
                    repeat
                        LineCount := LineCount + 1;
                    until (SalesInvLine."Line No." = "Line No.") or (SalesInvLine.NEXT = 0);

                ValueEntry.NEXT(LineCount - 1);
            end;

            exit(ValueEntry."Item Ledger Entry No.");
        end;

        exit(0);
    end;

}

