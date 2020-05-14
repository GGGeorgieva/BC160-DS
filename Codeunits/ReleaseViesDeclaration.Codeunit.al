codeunit 46015612 "Release VIES Declaration"
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

    TableNo = "VIES Declaration Header";

    trigger OnRun();
    var
        VIESLine: Record "VIES Declaration Line";
    begin
        if Status = Status::Released then
            exit;

        ReportingSetup.GET;

        TESTFIELD("VAT Registration No.");
        TESTFIELD("Document Date");
        if "Declaration Type" <> "Declaration Type"::Normal then
            TESTFIELD("Corrected Declaration No.");

        VIESLine.SETRANGE("VIES Declaration No.", "No.");
        if VIESLine.ISEMPTY then
            ERROR(Text001, "No.");
        VIESLine.FINDSET;
        repeat
            VIESLine.TESTFIELD("Country/Region Code");
            VIESLine.TESTFIELD("VAT Registration No.");
            VIESLine.TESTFIELD("Amount (LCY)");
        until VIESLine.NEXT = 0;

        Status := Status::Released;

        MODIFY(true);
    end;

    var
        Text001: Label 'There is nothing to release for declaration No. %1.';
        ReportingSetup: Record "Stat. Reporting Setup";

    procedure Reopen(var VIESHeader: Record "VIES Declaration Header");
    begin
        with VIESHeader do begin
            if Status = Status::Open then
                exit;
            Status := Status::Open;
            MODIFY(true);
        end;
    end;
}

