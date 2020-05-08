table 46015620 "FA History Entry"
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

    Caption = 'FA History Entry';
    //DrillDownPageID = "FA History Entries";
    //LookupPageID = "FA History Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
            Editable = false;
        }
        field(2; Type; Option)
        {
            Caption = 'Type';
            Editable = false;
            OptionCaption = 'Location,Responsible Employee';
            OptionMembers = Location,"Responsible Employee";
        }
        field(3; "FA No."; Code[20])
        {
            Caption = 'FA No.';
            Editable = false;
            TableRelation = "Fixed Asset"."No.";
        }
        field(4; "Old Value"; Code[20])
        {
            Caption = 'Old Value';
            Editable = false;
            TableRelation = IF (Type = CONST(Location)) "FA Location".Code
            ELSE
            IF (Type = CONST("Responsible Employee")) Employee."No.";
        }
        field(5; "New Value"; Code[20])
        {
            Caption = 'New Value';
            Editable = false;
            TableRelation = IF (Type = CONST(Location)) "FA Location".Code
            ELSE
            IF (Type = CONST("Responsible Employee")) Employee."No.";
        }
        field(6; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
            Editable = false;
        }
        field(7; "Closed by Entry No."; Integer)
        {
            Caption = 'Closed by Entry No.';
            Editable = false;
        }
        field(8; Disposal; Boolean)
        {
            Caption = 'Disposal';
            Editable = false;
        }
        field(9; "Creation Time"; Time)
        {
            Caption = 'Creation Time';
            Editable = false;
        }
        field(10; "User ID"; Code[50])
        {
            Caption = 'User ID';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
        key(Key2; "FA No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Entry No.", "FA No.", "Old Value", "New Value", "Creation Date")
        {
        }
    }

    procedure InsertEntry(FAHType: Option Location,"Responsible Employee"; FANo: Code[20]; OldValue: Code[20]; NewValue: Code[20]; ClosedByEntryNo: Integer; Disp: Boolean): Integer;
    var
        FAHistoryEntry: Record "FA History Entry";
    begin
        FAHistoryEntry.INIT;
        FAHistoryEntry.Type := FAHType;
        FAHistoryEntry."FA No." := FANo;
        FAHistoryEntry."Old Value" := OldValue;
        FAHistoryEntry."New Value" := NewValue;
        FAHistoryEntry."Closed by Entry No." := ClosedByEntryNo;
        FAHistoryEntry.Disposal := Disp;
        FAHistoryEntry."Creation Date" := TODAY;
        FAHistoryEntry."User ID" := USERID;
        FAHistoryEntry."Creation Time" := TIME;
        FAHistoryEntry.INSERT;

        exit(FAHistoryEntry."Entry No.");
    end;
}

