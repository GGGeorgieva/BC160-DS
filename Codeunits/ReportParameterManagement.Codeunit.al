codeunit 46015704 "Report Parameter Management"
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
    // 001   mp       07.11.14                  List of changes :
    //                           NAVE18.00      Builded from version 6.0
    // -----------------------------------------------------------------------------------------


    trigger OnRun();
    begin
    end;

    var
        IsInitialized : Boolean;
        NextParameterID : Integer;

    procedure InsertParameter(NewReportParameter : Record "Report Parameter";ReportID : Integer);
    var
        ReportParameter : Record "Report Parameter";
    begin
        ReportParameter.SETRANGE("User ID",USERID);
        ReportParameter.SETRANGE("Report ID",ReportID);
        if not IsInitialized then begin
          IsInitialized := true;
          ReportParameter.DELETEALL;
        end;
        NewReportParameter.ID := 1;
        if ReportParameter.FINDLAST then
          NewReportParameter.ID := ReportParameter.ID + 1;
        NewReportParameter."User ID" := USERID;
        NewReportParameter."Report ID" := ReportID;
        NewReportParameter.INSERT;
        COMMIT;
    end;

    procedure RetrieveParameter(var NewReportParameter : Record "Report Parameter";ReportID : Integer);
    var
        ReportParameter : Record "Report Parameter";
    begin
        if not IsInitialized then begin
          IsInitialized := true;
          NextParameterID := 1;
        end;
        if ReportParameter.GET(USERID,ReportID,NextParameterID) then begin
          NewReportParameter := ReportParameter;
          NextParameterID := NextParameterID + 1;
        end;
    end;

    procedure NoMoreParameters(ReportID : Integer) : Boolean;
    var
        ReportParameter : Record "Report Parameter";
    begin
        exit(not ReportParameter.GET(USERID,ReportID,NextParameterID + 1));
    end;

    procedure InsertDate(Date : Date;ReportID : Integer);
    var
        ReportParameter : Record "Report Parameter";
    begin
        ReportParameter.DateValue := Date;
        InsertParameter(ReportParameter,ReportID);
    end;

    procedure RetrieveDate(ReportID : Integer) : Date;
    var
        ReportParameter : Record "Report Parameter";
    begin
        RetrieveParameter(ReportParameter,ReportID);
        exit(ReportParameter.DateValue);
    end;

    procedure InsertText(Text : Text[250];ReportID : Integer);
    var
        ReportParameter : Record "Report Parameter";
    begin
        ReportParameter.TextValue := Text;
        InsertParameter(ReportParameter,ReportID);
    end;

    procedure RetrieveText(ReportID : Integer) : Text[250];
    var
        ReportParameter : Record "Report Parameter";
    begin
        RetrieveParameter(ReportParameter,ReportID);
        exit(ReportParameter.TextValue);
    end;

    procedure InsertInteger(Int : Integer;ReportID : Integer);
    var
        ReportParameter : Record "Report Parameter";
    begin
        ReportParameter.IntValue := Int;
        InsertParameter(ReportParameter,ReportID);
    end;

    procedure RetrieveInteger(ReportID : Integer) : Integer;
    var
        ReportParameter : Record "Report Parameter";
    begin
        RetrieveParameter(ReportParameter,ReportID);
        exit(ReportParameter.IntValue);
    end;
}

