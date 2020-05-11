codeunit 46015705 "Common Dialog Management"
{
    // version NAVE18.00

    // -----------------------------------------------------------------------------------------
    // Dynamic Solutions
    // MS Dynamics NAV 2017 Localisation
    // 
    // 
    // -----------------------------------------------------------------------------------------
    // No.   Sign     Date       Version        Description
    // -----------------------------------------------------------------------------------------
    // 001                        NAVBG11.0
    // -----------------------------------------------------------------------------------------


    trigger OnRun();
    begin
    end;

    var
        Text003: Label 'Text Files (*.txt)|*.txt|All Files (*.*)|*.*';
        Text004: Label 'Microsoft Excel Files (*.xl*)|*.xl*|All Files (*.*)|*.*';
        Text005: Label 'Word Documents (*.doc)|*.doc|All Files (*.*)|*.*';
        Text006: Label 'XML files (*.xml)|*.xml|All Files (*.*)|*.*';
        Text007: Label 'HTM files (*.htm)|*.htm|All Files (*.*)|*.*';
        Text008: Label 'XML Schema Files (*.xsd)|*.xsd|All Files (*.*)|*.*';
        Text009: Label 'XSL Transform Files(*.xslt)|*.xslt|All Files (*.*)|*.*';
        DocTxt: Label '.DOC';
        XlsTxt: Label '.XLS';
        TxtTxt: Label '.TXT';
        XmlTxt: Label '.XML';
        HtmTxt: Label '.HTM';
        XsdTxt: Label '.XSD';
        XsltTxt: Label '.XSLT';

    procedure OpenFile(WindowTitle: Text[50]; DefaultFileName: Text[1024]; DefaultFileType: Option " ",Text,Excel,Word,Custom,Xml,Htm,Xsd,Xslt; FilterString: Text[250]; "Action": Option Open,Save): Text[260];
    var
        CommonDialogControl: DotNet OpenDialog;
        "Filter": Text[255];
        DialogResult: DotNet DialogResult;
    begin
        if DefaultFileType = DefaultFileType::Custom then begin
            GetDefaultFileType(DefaultFileName, DefaultFileType);
            Filter := FilterString;
        end else
            Filter := GetFilterString(DefaultFileType);

        CommonDialogControl.Title := WindowTitle;
        CommonDialogControl.Filter := Filter;
        CommonDialogControl.Multiselect := false;
        CommonDialogControl.InitialDirectory := DefaultFileName;
        CommonDialogControl.FileName := DefaultFileName;

        DialogResult := CommonDialogControl.ShowDialog;
        if DialogResult.CompareTo(DialogResult.OK) = 0 then
            exit(CommonDialogControl.FileName);
    end;

    procedure OpenFileWithName(DefaultFileName: Text[1024]): Text[260];
    var
        DefaultFileType: Option " ",Text,Excel,Word,Custom,Xml,Htm,Xsd,Xslt;
        FilterString: Text[250];
        "Action": Option Open,Save;
    begin
        GetDefaultFileType(DefaultFileName, DefaultFileType);
        if DefaultFileType = DefaultFileType::Custom then
            FilterString := Text003;

        exit(OpenFile('', DefaultFileName, DefaultFileType, FilterString, Action::Open));
    end;

    local procedure GetDefaultFileType(DefaultFileName: Text[1024]; var DefaultFileType: Option " ",Text,Excel,Word,Custom,Xml,Htm,Xsd,Xslt);
    begin
        case true of
            CheckFileNameForFileType(DefaultFileName, DocTxt):
                DefaultFileType := DefaultFileType::Word;
            CheckFileNameForFileType(DefaultFileName, XlsTxt):
                DefaultFileType := DefaultFileType::Excel;
            CheckFileNameForFileType(DefaultFileName, TxtTxt):
                DefaultFileType := DefaultFileType::Custom;
            CheckFileNameForFileType(DefaultFileName, XmlTxt):
                DefaultFileType := DefaultFileType::Xml;
            CheckFileNameForFileType(DefaultFileName, HtmTxt):
                DefaultFileType := DefaultFileType::Htm;
            CheckFileNameForFileType(DefaultFileName, XsdTxt):
                DefaultFileType := DefaultFileType::Xsd;
            CheckFileNameForFileType(DefaultFileName, XsltTxt):
                DefaultFileType := DefaultFileType::Xslt;
            else
                DefaultFileType := DefaultFileType::Custom;
        end;
    end;

    local procedure CheckFileNameForFileType(DefaultFileName: Text[1024]; FileExtension: Text[5]): Boolean;
    var
        Position: Integer;
    begin
        Position := STRPOS(UPPERCASE(DefaultFileName), FileExtension);
        exit((Position > 0) and (Position - 1 = STRLEN(DefaultFileName) - STRLEN(FileExtension)));
    end;

    procedure GetFilterString(FileType: Option " ",Text,Excel,Word,Custom,Xml,Htm,Xsd,Xslt): Text[255];
    begin
        case FileType of
            FileType::Text:
                exit(Text003);
            FileType::Excel:
                exit(Text004);
            FileType::Word:
                exit(Text005);
            FileType::Xml:
                exit(Text006);
            FileType::Htm:
                exit(Text007);
            FileType::Xsd:
                exit(Text008);
            FileType::Xslt:
                exit(Text009);
            FileType::Custom:
                exit('');
        end;
    end;
}

