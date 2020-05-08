tableextension 46015614 "Acc. Scedule Name Extension" extends "Acc. Schedule Name"
{
    // version NAVW111.00,NAVE111.0

    fields
    {
        field(46015685; "Report ID"; Integer)
        {
            BlankNumbers = BlankZero;
            BlankZero = true;
            Caption = 'Report ID';
            Description = 'NAVE111.0,001';
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Report));
        }
        field(46015686; "Report Name"; Text[250])
        {
            CalcFormula = Lookup (AllObjWithCaption."Object Caption" WHERE("Object Type" = CONST(Report),
                                                                           "Object ID" = FIELD("Report ID")));
            Caption = 'Report Name';
            Description = 'NAVE111.0,001';
            FieldClass = FlowField;
        }
        field(46015687; "Rounding Factor"; Integer)
        {
            Caption = 'Rounding Factor';
            Description = 'NAVE111.0,001';
        }
        field(46015688; "Dictionary Code"; Code[10])
        {
            Caption = 'Dictionary Code';
            Description = 'NAVE111.0,001';
        }
        field(46015696; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            Description = 'NAVE111.0,001';
            TableRelation = Employee;
        }
    }

    trigger OnBeforeDelete()
    begin
        if IsResultsExist(Name) then
            if CONFIRM(Text46012225, false, GetRecordDescription(Name)) then begin
                AccScheduleResultHeader.SETRANGE("Acc. Schedule Name", Name);
                AccScheduleResultHeader.DELETEALL(true);
            end;
    end;

    procedure IsResultsExist(AccSchedName: Code[10]): Boolean;

    var
        AccScheduleResultHeader: Record "Acc. Schedule Result Header";
    begin
        ;
        AccScheduleResultHeader.SETRANGE("Acc. Schedule Name", AccSchedName);
        exit(not AccScheduleResultHeader.ISEMPTY);
    end;

    procedure GetRecordDescription(AccSchedName: Code[10]): Text[100];
    var
        AccScheduleName: Record "Acc. Schedule Name";
    begin

        AccScheduleName.GET(AccSchedName);
        exit(STRSUBSTNO('%1 %2=''%3''', AccScheduleName.TABLECAPTION, FIELDCAPTION(Name), AccSchedName));
    end;



    var
        "++++++++": Integer;
        AccScheduleResultHeader: Record "Acc. Schedule Result Header";

    var
        Text46012225: Label '%1 has results. Do you want to delete it anyway?';

}

