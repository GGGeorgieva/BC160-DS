codeunit 46015645 CashDeskManagement
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
    //                           NAVE111.0     Changed codeunit page No
    // -----------------------------------------------------------------------------------------


    trigger OnRun();
    begin
    end;

    var
        Text26540 : Label 'There are no Cash Desk accounts.';

    procedure CashDeskNoSelected(var CashDeskNo : Code[20]) : Boolean;
    var
        CashDeskSelected : Boolean;
        CashAcc : Record "Bank Account";
    begin
        CashDeskSelected := true;

        CashAcc.RESET;
        CashAcc.SETRANGE("Account Type",CashAcc."Account Type"::"Cash Desk");
        case CashAcc.COUNT of
          0:
            ERROR(Text26540);
          1:
            CashAcc.FINDFIRST;
          else
           // NAVE111.0; 001; single
           // CashDeskSelected := PAGE.RUNMODAL(46012248 ,CashAcc) = ACTION::LookupOK;
            CashDeskSelected := PAGE.RUNMODAL(46015628 ,CashAcc) = ACTION::LookupOK;

        end;
        if CashDeskSelected then
          CashDeskNo := CashAcc."No.";
        exit(CashDeskSelected);
    end;
}

