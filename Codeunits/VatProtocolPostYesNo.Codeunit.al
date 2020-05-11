codeunit 46015508 "VAT Protocol-Post (Yes/No)"
{
    // version NAVBG8.00

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

    TableNo = "VAT Protocol Header";

    trigger OnRun();
    begin
        VATProtocolHeader.COPY(Rec);
        Code;
        Rec := VATProtocolHeader;
    end;

    var
        Text001 : Label 'Do you want to post VAT Protocol %1?';
        VATProtocolHeader : Record "VAT Protocol Header";
        VATProtocolPost : Codeunit "VAT Protocol Post";
        Text002 : Label 'Do you want to post Corrective VAT Protocol %1?';
        Text16210 : Label 'VAT Protocol No. %1 has been posted.';
        Text16211 : Label 'Corrective VAT Protocol No. %1 has been posted.';

    local procedure "Code"();
    var
        PostingNo : Code[20];
    begin
        with VATProtocolHeader do begin
          if not CONFIRM(Text001,false,"No.") then
            exit;

          VATProtocolPost.RUN(VATProtocolHeader);

          if "Last Posting No." = '' then
            PostingNo := "No."
          else
            PostingNo := "Last Posting No.";

          MESSAGE(Text16210,PostingNo);
        end;
    end;
}

