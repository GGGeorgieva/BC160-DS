table 46015685 "Acc. Schedule Result Header"
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

    Caption = 'Acc. Schedule Result Header';
    //LookupPageID = "Acc. Schedule Res. Header List";

    fields
    {
        field(1; "Result Code"; Code[20])
        {
            Caption = 'Result Code';
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(3; "Date Filter"; Text[30])
        {
            Caption = 'Date Filter';
        }
        field(4; "Acc. Schedule Name"; Code[10])
        {
            Caption = 'Acc. Schedule Name';
            TableRelation = "Acc. Schedule Name";
        }
        field(5; "Column Layout Name"; Code[10])
        {
            Caption = 'Column Layout Name';
        }
        field(12; "Dimension 1 Filter"; Text[50])
        {
            Caption = 'Dimension 1 Filter';
        }
        field(13; "Dimension 2 Filter"; Text[50])
        {
            Caption = 'Dimension 2 Filter';
        }
        field(14; "Dimension 3 Filter"; Text[50])
        {
            Caption = 'Dimension 3 Filter';
        }
        field(15; "Dimension 4 Filter"; Text[50])
        {
            Caption = 'Dimension 4 Filter';
        }
        field(20; "User ID"; Code[50])
        {
            Caption = 'User ID';
            Editable = false;
        }
        field(21; "Result Date"; Date)
        {
            Caption = 'Result Date';
            Editable = false;
        }
        field(22; "Result Time"; Time)
        {
            Caption = 'Result Time';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Result Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        AccScheduleResultValue.SETRANGE("Result Code", "Result Code");
        if not AccScheduleResultValue.ISEMPTY then
            AccScheduleResultValue.DELETEALL;

        AccScheduleResultHistory.SETRANGE("Result Code", "Result Code");
        if not AccScheduleResultHistory.ISEMPTY then
            AccScheduleResultHistory.DELETEALL;

        AccScheduleResultLine.SETRANGE("Result Code", "Result Code");
        if not AccScheduleResultLine.ISEMPTY then
            AccScheduleResultLine.DELETEALL;

        AccScheduleResultColumn.SETRANGE("Result Code", "Result Code");
        if not AccScheduleResultColumn.ISEMPTY then
            AccScheduleResultColumn.DELETEALL;
    end;

    var
        AccScheduleResultValue: Record "Acc. Schedule Result Value";
        AccScheduleResultHistory: Record "Acc. Schedule Result History";
        AccScheduleResultLine: Record "Acc. Schedule Result Line";
        AccScheduleResultColumn: Record "Acc. Schedule Result Column";
}

