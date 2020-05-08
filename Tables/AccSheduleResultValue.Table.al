table 46015686 "Acc. Schedule Result Value"
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

    Caption = 'Acc. Schedule Result Value';

    fields
    {
        field(1;"Result Code";Code[20])
        {
            Caption = 'Result Code';
            TableRelation = "Acc. Schedule Result Header";
        }
        field(2;"Row No.";Integer)
        {
            Caption = 'Row No.';
        }
        field(3;"Column No.";Integer)
        {
            Caption = 'Column No.';
        }
        field(4;Value;Decimal)
        {
            Caption = 'Value';

            trigger OnValidate();
            begin
                AddChangeHistoryEntry;
            end;
        }
        field(5;Expression;Text[80])
        {
            Caption = 'Expression';
        }
    }

    keys
    {
        key(Key1;"Result Code","Row No.","Column No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        VALIDATE(Value,0);
    end;

    procedure AddChangeHistoryEntry();
    var
        AccScheduleResultHistory : Record "Acc. Schedule Result History";
        VariantNo : Integer;
    begin
        AccScheduleResultHistory.SETRANGE("Result Code","Result Code");
        AccScheduleResultHistory.SETRANGE("Row No.","Row No.");
        AccScheduleResultHistory.SETRANGE("Column No.","Column No.");
        if AccScheduleResultHistory.FINDLAST then;
        VariantNo := AccScheduleResultHistory."Variant No." + 1;

        AccScheduleResultHistory.INIT;
        AccScheduleResultHistory."Result Code" := "Result Code";
        AccScheduleResultHistory."Row No." := "Row No.";
        AccScheduleResultHistory."Column No." := "Column No.";
        AccScheduleResultHistory."Variant No." := VariantNo;
        AccScheduleResultHistory."New Value" := Value;
        AccScheduleResultHistory."Old Value" := xRec.Value;
        AccScheduleResultHistory.INSERT(true);
    end;
}

