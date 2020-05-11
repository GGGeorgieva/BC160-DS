tableextension 46015526 "Job Journal Line Extension" extends "Job Journal Line"
{
    // version NAVW111.00.00.26401,NAVE111.0

    fields
    {
        modify(Quantity)
        {
            trigger OnBeforeValidate()
            var
                GLSetup: Record "General Ledger Setup";
            begin
                GLSetup.GET;
                if GLSetup."Mark Neg. Qty as Correction" then
                    Correction := Quantity < 0;
            end;
        }

        field(46015605; "Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Shipment Method";
        }
        field(46015607; "Tariff No."; Code[10])
        {
            Caption = 'Tariff No.';
            Description = 'NAVE111.0,001';
            TableRelation = "Tariff Number";
        }
        field(46015608; "Net Weight"; Decimal)
        {
            Caption = 'Net Weight';
            DecimalPlaces = 0 : 5;
            Description = 'NAVE111.0,001';
        }
        field(46015609; "Country/Region of Origin Code"; Code[10])
        {
            Caption = 'Country/Region of Origin Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Country/Region";
        }
        field(46015611; "Intrastat Transaction"; Boolean)
        {
            Caption = 'Intrastat Transaction';
            Description = 'NAVE111.0,001';
            Editable = false;
        }
        field(46015615; Correction; Boolean)
        {
            Caption = 'Correction';
            Description = 'NAVE111.0,001';
        }
    }
    var
        StatReportingSetup: Record "Stat. Reporting Setup";
        Text46012225: Label '%1 is required for Item %2.';

    procedure CheckIntrastat();
    begin
        if (Type = Type::Item) and "Intrastat Transaction" then begin
            StatReportingSetup.GET;
            if StatReportingSetup."Transaction Type Mandatory" and ("Transaction Type" = '') then
                ERROR(Text46012225, FIELDCAPTION("Transaction Type"), "No.");
            if StatReportingSetup."Transaction Spec. Mandatory" and ("Transaction Specification" = '') then
                ERROR(Text46012225, FIELDCAPTION("Transaction Specification"), "No.");
            if StatReportingSetup."Transport Method Mandatory" and ("Transport Method" = '') then
                ERROR(Text46012225, FIELDCAPTION("Transport Method"), "No.");
            if StatReportingSetup."Shipment Method Mandatory" and ("Shipment Method Code" = '') then
                ERROR(Text46012225, FIELDCAPTION("Shipment Method Code"), "No.");
            if StatReportingSetup."Tariff No. Mandatory" and ("Tariff No." = '') then
                ERROR(Text46012225, FIELDCAPTION("Tariff No."), "No.");
            if StatReportingSetup."Net Weight Mandatory" and ("Net Weight" = 0) then
                ERROR(Text46012225, FIELDCAPTION("Net Weight"), "No.");
            if StatReportingSetup."Country/Region of Origin Mand." and ("Country/Region of Origin Code" = '') then
                ERROR(Text46012225, FIELDCAPTION("Country/Region of Origin Code"), "No.");
        end;
    end;

    procedure IsIntrastatTransaction() IsIntrastat: Boolean;
    var
        CountryRegion: Record "Country/Region";
    begin
        exit(CountryRegion.IsIntrastat("Country/Region Code", false));
    end;
}

