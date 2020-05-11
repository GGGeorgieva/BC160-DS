codeunit 46015509 "VAT Protocol-Post + Print"
{
    // version NAVBG11.0

    // -----------------------------------------------------------------------------------------
    // XAPT Solutions
    // MS Dynamics NAV 2015 Localisation
    // 
    // mp  : Mile Petachki
    // version : NAVBG8.00
    // 
    // -----------------------------------------------------------------------------------------
    // No.   Sign     Date       Version        Description
    // -----------------------------------------------------------------------------------------
    // 001   mp       07.11.14                  List of changes :
    //                           NAVBG8.00      Builded from version 6.0
    // -----------------------------------------------------------------------------------------
    // Dynamic Solutions
    // MS Dynamics NAV 2017 Localisation
    // 
    // 
    // -----------------------------------------------------------------------------------------
    // No.   Sign     Date       Version        Description
    // -----------------------------------------------------------------------------------------
    // 001                                     List of changes :
    //                           NAVBG11.0  Changed functions : GetReport(), PrintReport()
    // -----------------------------------------------------------------------------------------

    Permissions = TableData "Sales Invoice Header" = rimd,
                  TableData "Sales Invoice Line" = rimd,
                  TableData "Sales Cr.Memo Header" = rimd,
                  TableData "Sales Cr.Memo Line" = rimd,
                  TableData "Purch. Inv. Header" = rimd,
                  TableData "Purch. Inv. Line" = rimd,
                  TableData "Purch. Cr. Memo Hdr." = rimd,
                  TableData "Purch. Cr. Memo Line" = rimd;
    TableNo = "VAT Protocol Header";

    trigger OnRun();
    begin
        VATProtocolHeader.COPY(Rec);
        Code;
        Rec := VATProtocolHeader;
    end;

    var
        Text001: Label 'Do you want to post and print VAT Protocol %1?';
        VATProtocolHeader: Record "VAT Protocol Header";
        PostVATProtocolHeader: Record "Posted VAT Protocol Header";
        ReportSelection: Record "Report Selections";
        VATProtocolPost: Codeunit "VAT Protocol Post";
        Selection: Integer;

    local procedure "Code"();
    begin
        with VATProtocolHeader do begin
            if not CONFIRM(Text001, false, "No.") then
                exit;

            VATProtocolPost.RUN(VATProtocolHeader);
            GetReport(VATProtocolHeader);
        end;
    end;

    procedure GetReport(var IntInvHeader: Record "VAT Protocol Header");
    begin
        with VATProtocolHeader do begin
            if "Last Posting No." = '' then
                PostVATProtocolHeader."No." := "No."
            else
                PostVATProtocolHeader."No." := "Last Posting No.";

            PostVATProtocolHeader.SETRECFILTER;
            case "Document Type" of
                //NAVBG11.0; 001; begin
                "Document Type"::Purchase:
                    PrintReport(ReportSelection.Usage::BG10);
                "Document Type"::Sale:
                    PrintReport(ReportSelection.Usage::BG12);
            //NAVBG11.0; 001; end
            end;
        end;
    end;

    local procedure PrintReport(ReportUsage: Enum "Report Selection Usage");
    begin
        ReportSelection.RESET;
        ReportSelection.SETRANGE(Usage, ReportUsage);
        ReportSelection.FIND('-');
        repeat
            ReportSelection.TESTFIELD("Report ID");
            case ReportUsage of
                //NAVBG11.0; 001; begin
                ReportSelection.Usage::BG10,
              ReportSelection.Usage::BG12:
                    //NAVBG11.0; 001; end
                    REPORT.RUN(ReportSelection."Report ID", false, false, PostVATProtocolHeader);
            end;
        until ReportSelection.NEXT = 0;
    end;
}

