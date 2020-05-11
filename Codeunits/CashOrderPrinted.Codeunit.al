codeunit 46015607 "Cash Order-Printed"
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

    TableNo = "Cash Order Header";

    trigger OnRun();
    begin
        FIND;
        "No. Printed" := "No. Printed" + 1;
        MODIFY;
        COMMIT;
    end;
}

