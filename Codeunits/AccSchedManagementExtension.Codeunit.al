codeunit 46015513 "AccScheduleMangementExtension"
{
    procedure ValidateFormula(AccScheduleLine: Record "Acc. Schedule Line")
    var
        AccScheduleName: Record "Acc. Schedule Name";
        ColumnLayout: Record "Column Layout";
        SavedAccountScheduleLine: Record "Acc. Schedule Line";
        AccSchedManagement: Codeunit AccSchedManagement;
    begin
        AccScheduleName.GET(AccScheduleLine."Schedule Name");
        ColumnLayout."Column Type" := ColumnLayout."Column Type"::"Net Change";
        AccScheduleLine.SETRANGE("Date Filter", TODAY);
        SavedAccountScheduleLine := AccScheduleLine;
        AccSchedManagement.CalcCell(AccScheduleLine, ColumnLayout, FALSE);
        AccScheduleLine := SavedAccountScheduleLine;
    end;
}