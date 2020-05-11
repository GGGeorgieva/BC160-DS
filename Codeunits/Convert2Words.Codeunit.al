codeunit 46015608 Convert2Words
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

    procedure Amount2Words(Amount: Decimal; CurrencyCode: Code[10]): Text[250];
    var
        Check: Report Check;
        NoText: array[2] of Text[80];
    begin
        if GLOBALLANGUAGE = 1033 then begin // English
            Check.InitTextVariable;
            Check.FormatNoText(NoText, Amount, CurrencyCode);
            exit(NoText[1] + NoText[2]);
        end else begin // Local
                       // Here should be country call
        end;
    end;

    procedure Date2Words(Date: Date): Text[250];
    begin
        if GLOBALLANGUAGE = 1033 then begin // English
            exit(FORMAT(Date, 0, 4));
        end else begin // Local
                       // Here should be country call
        end;
    end;
}

