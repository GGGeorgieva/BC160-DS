table 46015608 "VAT Period"
{
    // version NAVE18.00

    // -----------------------------------------------------------------------------------------
    // XAPT Solutions
    // MS Dynamics NAV 2015 Localisation
    // 
    // mp  : Mile Petachki
    // version : NAVE18.00
    // 
    // -----------------------------------------------------------------------------------------
    // No.   Sign     Date       Version        Description
    // -----------------------------------------------------------------------------------------
    // 001   mp       27.10.14   NAVE18.00      Created table from MS Dynamics NAV 6.00
    // ------------------------------------------------------------------------------------------

    Caption = 'VAT Period';
    //LookupPageID = "VAT Periods";

    fields
    {
        field(1; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            NotBlank = true;

            trigger OnValidate();
            begin
                Name := FORMAT("Starting Date", 0, Text000);
            end;
        }
        field(2; Name; Text[10])
        {
            Caption = 'Name';
        }
        field(3; "New VAT Year"; Boolean)
        {
            Caption = 'New VAT Year';

            trigger OnValidate();
            begin
                TESTFIELD("Date Locked", false);
            end;
        }
        field(4; Closed; Boolean)
        {
            Caption = 'Closed';
        }
        field(5; "Date Locked"; Boolean)
        {
            Caption = 'Date Locked';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Starting Date")
        {
        }
        key(Key2; "New VAT Year", "Date Locked")
        {
        }
        key(Key3; Closed)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        TESTFIELD("Date Locked", false);
    end;

    trigger OnInsert();
    begin
        VATPeriod2 := Rec;
        if VATPeriod2.FIND('>') then
            VATPeriod2.TESTFIELD("Date Locked", false);
    end;

    trigger OnRename();
    begin
        TESTFIELD("Date Locked", false);
        VATPeriod2 := Rec;
        if VATPeriod2.FIND('>') then
            VATPeriod2.TESTFIELD("Date Locked", false);
    end;

    var
        Text000: Label '<Month Text>';
        VATPeriod2: Record "VAT Period";
}

