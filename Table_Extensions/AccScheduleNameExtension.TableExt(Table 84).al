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


    //Unsupported feature: CodeInsertion on "OnDelete". Please convert manually.

    //trigger (Variable: ++++++++)();
    //Parameters and return type have not been exported.
    //begin
    /*
    */
    //end;


    //Unsupported feature: CodeModification on "OnDelete". Please convert manually.

    //trigger OnDelete();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    AccSchedLine.SETRANGE("Schedule Name",Name);
    AccSchedLine.DELETEALL;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    //NAVE111.0; 001; begin
    if IsResultsExist(Name) and LocalizationUsage.UseEastLocalization then
      if CONFIRM(Text46012225,false,GetRecordDescription(Name)) then begin
        AccScheduleResultHeader.SETRANGE("Acc. Schedule Name",Name);
        AccScheduleResultHeader.DELETEALL(true);
      end;
    //NAVE111.0; 001; end

    AccSchedLine.SETRANGE("Schedule Name",Name);
    AccSchedLine.DELETEALL;
    */
    //end;

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
        "++++++++": Integer;
        AccScheduleResultHeader: Record "Acc. Schedule Result Header";

    var
        Text46012225: Label '%1 has results. Do you want to delete it anyway?';

}

