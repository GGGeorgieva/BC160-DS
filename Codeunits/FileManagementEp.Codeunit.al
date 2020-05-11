codeunit 46015693 "File Management EP"
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

    SingleInstance = false;

    trigger OnRun();
    begin
    end;

    var
        TempFileName : Text[250];

    procedure ReadValues(RecordString : Text[1000];FieldSeparator : Text[10];var FieldValue : array [250] of Text[250];FieldDelimiter : Text[10]);
    var
        NoOfFields : Integer;
        FieldSeparatorPos : Integer;
    begin
        NoOfFields := 0;
        repeat
          NoOfFields := NoOfFields + 1;
          FieldSeparatorPos := STRPOS(RecordString,FieldSeparator);
          if FieldSeparatorPos = 0 then
            FieldValue[NoOfFields] := DELCHR(RecordString,'=',FieldDelimiter)
          else begin
            FieldValue[NoOfFields] := DELCHR(COPYSTR(RecordString,1,(FieldSeparatorPos - 1)),'=',FieldDelimiter);
            RecordString := COPYSTR(RecordString,(FieldSeparatorPos + 1));
          end;
        until FieldSeparatorPos = 0;
    end;

    procedure CreateOrOpenFile(FilePath : Text[250];Selection : Option Import,Export;var TextFile : File);
    var
        TierMgt : Codeunit "File Management";
    begin
        if Selection = Selection::Import then begin
          if ISSERVICETIER then
            //corr TierMgt.SilentUpload(FilePath,FilePath);
          TextFile.WRITEMODE := false;
          TextFile.TEXTMODE := true;
          TextFile.OPEN(FilePath);
        end else begin
          TextFile.TEXTMODE := true;
          TextFile.WRITEMODE := true;
          if not ISSERVICETIER then
            TextFile.CREATE(FilePath)
          else begin
            //corr TempFileName := TierMgt.ServerTempFileName('','.TXT');
            TextFile.CREATE(TempFileName);
          end;
        end;
    end;

    procedure CloseFile(FilePath : Text[250];Selection : Option Import,Export;var TxtFile : File);
    var
        TierMgt : Codeunit "File Management";
    begin
        TempFileName := TxtFile.NAME;
        TxtFile.CLOSE;
        if ISSERVICETIER and (Selection = Selection::Export) then
          TierMgt.DownloadToFile(TempFileName,FilePath);
    end;
}

