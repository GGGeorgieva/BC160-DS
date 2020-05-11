codeunit 46015611 "Cash Order-Post + Print"
{
    // version NAVE111.0

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
    // Dynamic Solutions
    // MS Dynamics NAV 2017 Localisation
    // 
    // 
    // -----------------------------------------------------------------------------------------
    // No.   Sign     Date       Version        Description
    // -----------------------------------------------------------------------------------------
    // 001                                     List of changes :
    //                           NAVE111.0    Changes GetReport function
    // -----------------------------------------------------------------------------------------

    TableNo = "Cash Order Header";

    trigger OnRun();
    begin
        CashOrderHeader.COPY(Rec);
        Code;
        Rec := CashOrderHeader;
    end;

    var
        CashOrderHeader: Record "Cash Order Header";
        PostedCashOrderHeader: Record "Posted Cash Order Header";
        ReportSelection: Record "Report Selections";
        CashOrderPost: Codeunit "Cash Order-Post";

    local procedure "Code"();
    begin
        with CashOrderHeader do begin
            CashOrderPost.RUN(CashOrderHeader);
            GetReport(CashOrderHeader);
            COMMIT;
        end;
    end;

    procedure GetReport(var CashOrderHeader: Record "Cash Order Header");
    begin
        with CashOrderHeader do begin
            PostedCashOrderHeader."Cash Desk No." := "Cash Desk No.";
            PostedCashOrderHeader."Order Type" := "Order Type";
            PostedCashOrderHeader."No." := "No.";
            PostedCashOrderHeader.SETRECFILTER;
            case "Order Type" of
                "Order Type"::Receipt:
                    //  PrintReport(ReportSelection.Usage::BG4);     //NAVE111.0
                    PrintReport(ReportSelection.Usage::BG6);       //NAVE111.0
                "Order Type"::Withdrawal:
                    //   PrintReport(ReportSelection.Usage::BG5);     //NAVE111.0
                    PrintReport(ReportSelection.Usage::BG7);       //NAVE111.0
            end;
        end;
    end;

    local procedure PrintReport(ReportUsage: Enum "Report Selection Usage");
    begin
        ReportSelection.RESET;
        ReportSelection.SETRANGE(Usage, ReportUsage);
        ReportSelection.FINDSET;
        repeat
            ReportSelection.TESTFIELD("Report ID");
            REPORT.RUN(ReportSelection."Report ID", false, false, PostedCashOrderHeader);
        until ReportSelection.NEXT = 0;
    end;
}

