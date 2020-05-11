codeunit 46015506 "VAT Ledgers Management"
{
    // version NAVBG11.0.001

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
    // 001   mp       27.10.14                  List of changes :
    //                           NAVBG8.00      Builded from version 6.0
    //                           NAVBG8.00      Changed function : InsertSalesVATLedgerLine()
    //                           NAVBG8.00      Changed function : InsertPurchVATLedgerLine()
    //                           NAVBG8.00      Changed function : ExportSales()
    //                           NAVBG8.00      Changed function : ExportPurch()
    //                           NAVBG8.00      Added new function : CodeInUnrealizedVat()
    //                           NAVBG8.00      Added new function : CodeInUnrealizedVatPurchase()
    //                           NAVBG8.00      Added new function : SetCalledFromLedger()
    // ------------------------------------------------------------------------------------------
    // Dynamic Solutions
    // MS Dynamics NAV 2017 Localisation
    // 
    // 
    // -----------------------------------------------------------------------------------------
    // No.   Sign     Date       Version        Description
    // -----------------------------------------------------------------------------------------
    // 001                                     List of changes :
    //                           NAVBG11.0   Changed function : FillSalesAmounts()
    //                           NAVBG11.0   Changed function : InsertSalesVATLedgerLine()
    //                           NAVBG11.0   Changed function : SetSign()
    //                           NAVBG11.0   Changed function : FillSalesAmounts()
    //                           NAVBG11.0   Changed function : FillSalesAmounts()
    //                           NAVBG11.0   Changed function : FillSalesIndexes()
    //                           NAVBG11.0   Changed function : FillPurchAmounts()
    //                           NAVBG11.0   Changed function : FillPurchIndexes()
    //                           NAVBG11.0   Changed function : FillSalesAmounts()
    //                           NAVBG11.0   Added comments to function FillSalesAmounts()
    //                           NAVBG11.0   Changed function : FillPurchAmounts()
    //                           NAVBG11.0   Changed function : InsertSalesVATLedgerLine()- Unrealized VAT
    //                           NAVBG11.0   Changed function : SetSign()                 - Unrealized VAT
    //                           NAVBG11.0   Changed function : FillSalesAmounts()        - Unrealized VAT
    //                           NAVBG11.0   Changed function : FillPurchAmounts()        - Unrealized VAT
    //                           NAVBG11.0   Changed function : SetSign()
    // 
    // ------------------------------------------------------------------------------------------
    // Dynamic Solutions
    // MS Dynamics NAV 2017 Localisation
    // 
    // 
    // -----------------------------------------------------------------------------------------
    // No.   Sign     Date       Version        Description
    // -----------------------------------------------------------------------------------------
    // 001            21.02.18                      List of changes :
    //                           NAVBG11.0.001      Changed function : FillDeclaration()
    //                           NAVBG11.0.001      Changed function : InsertSalesVATLedgerLine()
    // -----------------------------------------------------------------------------------------


    trigger OnRun();
    begin
    end;

    var
        CompanyInfo : Record "Company Information";
        VATExportSetup : Record "VAT Export Setup";
        VATPostingSetup : Record "VAT Posting Setup";
        VATEntry : Record "VAT Entry";
        Utils : Codeunit "BG Utils";
        TierMgt : Codeunit "File Management";
        Window : Dialog;
        Text16200 : Label 'File %1 could not be created.';
        Text16201 : Label 'File %1 was created.';
        Counter : Integer;
        EntryNo : Integer;
        Text16250 : Label 'The %1 specified in %2 is not enough to perform the rotation of exported file.';
        Text16251 : Label 'Please insert a new empty removable disk with free space not less than %1 Byte(s) and click Yes.';
        Text16252 : Label 'The export process was aborted.';
        NoOfExportFiles : Integer;
        FileName : Text[250];
        IndSBase : Option " ","02-11","02-12","02-13","02-14","02-15","02-16","02-17","02-18","02-19","02-25","02-26","02-10";
        IndSVAT : Option " ","02-21","02-22","02-23","02-24","02-20";
        IndPBase : Option " ","03-30","03-31","03-32","03-44";
        IndPVAT : Option " ","03-41","03-42";
        IndD : Option " ","01-01","01-11","01-12","01-13","01-14","01-15","01-16","01-17","01-18","01-19","01-20","01-21","01-22","01-23","01-24","01-30","01-31","01-32","01-33","01-40","01-41","01-42","01-43","01-50","01-60","01-70","01-71","01-80","01-81","01-82";
        Encoding : Option DOS,WIN;
        Text001 : Label 'Export Sales VAT Ledger';
        Text002 : Label 'Export Purch. VAT Ledger';
        Text003 : Label 'Export Monthly VAT Declaration';
        Text004 : Label 'Export VIES Declaration';
        Text005 : Label 'VAT Ledger has already been exported. Do you want to proceed?';
        ClientFileName : Text[250];
        VATLedger2 : Record "VAT Ledger";
        streamWriter : DotNet SystemIOStreamWriter;
        encoder : DotNet SystemTextEncoding;
        OutFile : File;
        FileOutStream : OutStream;
        BGSetup : Record "BG Setup";
        SourceCodeSetup : Record "Source Code Setup";
        PostedVATProtocolHeader : Record "Posted VAT Protocol Header";
        GLSetup : Record "General Ledger Setup";
        CalledFromLedger : Boolean;
        CharsTxt : Label 'ABCDEFGHIJKLMNOPQRSTUVWXYZАБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЬЮЯ';
        IntTxt : Label '<Integer>';
        FormatTxt1 : Label '<Precision,2:2><Sign><Integer><Decimals,3><Comma,.>';
        FormatTxt2 : Label '<Text,%1><Filler Character,0>%2';
        FormatTxt3 : Label '<Day,2>/<Month,2>/<Year4>';
        FormatTxt4 : Label '<Year4><Month,2>';
        FormatTxt5 : Label '<Month,2>/<Year4>';
        FormatTxt6 : Label '<Precision,2:2><Standard Format,9>';
        VHRTxt : Label 'VHR';
        VDRTxt : Label 'VDR';
        VTRTxt : Label 'VTR';
        TTRTxt : Label 'TTR';
        VIRTxt : Label 'VIR';

    procedure GenerateSales(var VATLedger : Record "VAT Ledger");
    var
        VATLedgerLine : Record "VAT Ledger Line";
        VATPostingSetup : Record "VAT Posting Setup";
    begin
        VATExportSetup.GET;
        CompanyInfo.GET;
        CompanyInfo.TESTFIELD("Identification No.");

        if VATLedger.Exported then
          if not CONFIRM(Text005,false) then
            exit;

        VATLedgerLine.SETRANGE(Type,VATLedgerLine.Type::Sales);
        VATLedgerLine.SETRANGE("Period Start Date",VATLedger."Period Start Date");
        if VATLedgerLine.FINDFIRST then
          VATLedgerLine.DELETEALL;
        EntryNo := 0;

        Window.OPEN(VATLedgerLine.TABLECAPTION + ' @1@@@@@@@@@@@@@@@@@');
        Counter := 0;

        VATEntry.RESET;
        VATEntry.SETRANGE(Type,VATEntry.Type::Sale);
        VATEntry.SETRANGE("Posting Date",VATLedger."Period Start Date",VATLedger."Period End Date");
        VATEntry.SETRANGE("Do not include in VAT Ledgers", false);
        if VATEntry.FIND('-') then
          repeat
            Counter += 1;
            Window.UPDATE(1,ROUND(Counter/VATEntry.COUNT*10000,1));
            InsertSalesVATLedgerLine(VATEntry,false,VATLedger."Period Start Date",VATLedger."Period End Date");
          until VATEntry.NEXT = 0;


        Counter := 0;

        VATEntry.RESET;
        VATEntry.SETRANGE(Type,VATEntry.Type::" ");
        VATEntry.SETRANGE("Posting Date",VATLedger."Period Start Date",VATLedger."Period End Date");
        VATEntry.SETRANGE("Do not include in VAT Ledgers", false);
        if VATEntry.FIND('-') then
          repeat
            Counter += 1;
            Window.UPDATE(1,ROUND(Counter/VATEntry.COUNT*10000,1));
            VATPostingSetup.GET(VATEntry."VAT Bus. Posting Group",
              VATEntry."VAT Prod. Posting Group");
            if VATPostingSetup."Transaction Type" in [VATPostingSetup."Transaction Type"::Sales,
              VATPostingSetup."Transaction Type"::Both] then
              InsertSalesVATLedgerLine(VATEntry,false,VATLedger."Period Start Date",VATLedger."Period End Date");
          until VATEntry.NEXT = 0;

        Counter := 0;
        VATEntry.RESET;
        VATEntry.SETRANGE(Type,VATEntry.Type::Sale);
        VATEntry.SETFILTER("Posting Date",'..%1|%2..',VATLedger."Period Start Date" - 1,VATLedger."Period End Date" + 1);
        VATEntry.SETRANGE("Void Date",VATLedger."Period Start Date",VATLedger."Period End Date");
        VATEntry.SETRANGE("Do not include in VAT Ledgers", false);
        if VATEntry.FIND('-') then
          repeat
            Counter += 1;
            Window.UPDATE(1,ROUND(Counter/VATEntry.COUNT*10000,1));
            InsertSalesVATLedgerLine(VATEntry,true,VATLedger."Period Start Date",VATLedger."Period End Date");
          until VATEntry.NEXT = 0;

        VATLedger.Created := true;
        VATLedger.Exported := false;
        VATLedger.MODIFY;

        Window.CLOSE;
    end;

    procedure GeneratePurch(var VATLedger : Record "VAT Ledger");
    var
        VATLedgerLine : Record "VAT Ledger Line";
    begin
        VATExportSetup.GET;
        CompanyInfo.GET;
        CompanyInfo.TESTFIELD("Identification No.");

        VATLedgerLine.SETRANGE(Type,VATLedgerLine.Type::Purchase);
        VATLedgerLine.SETRANGE("Period Start Date",VATLedger."Period Start Date");
        if VATLedgerLine.FINDFIRST then
          VATLedgerLine.DELETEALL;
        EntryNo := 0;

        if VATLedger.Exported then
          if not CONFIRM(Text005,false) then
            exit;

        Window.OPEN(VATLedgerLine.TABLECAPTION + ' @1@@@@@@@@@@@@@@@@@');
        Counter := 0;

        VATEntry.RESET;
        VATEntry.SETRANGE(Type,VATEntry.Type::Purchase);
        VATEntry.SETRANGE("Posting Date",VATLedger."Period Start Date",VATLedger."Period End Date");
        VATEntry.SETRANGE("Do not include in VAT Ledgers", false);
        if VATEntry.FIND('-') then
          repeat
            Counter += 1;
            Window.UPDATE(1,ROUND(Counter/VATEntry.COUNT*10000,1));
            InsertPurchVATLedgerLine(VATEntry,false,VATLedger."Period Start Date",VATLedger."Period End Date");
          until VATEntry.NEXT = 0;

        Counter := 0;
        VATEntry.RESET;
        VATEntry.SETRANGE(Type,VATEntry.Type::Purchase);
        VATEntry.SETFILTER("Posting Date",'..%1|%2..',VATLedger."Period Start Date" - 1,VATLedger."Period End Date" + 1);
        VATEntry.SETRANGE("Void Date",VATLedger."Period Start Date",VATLedger."Period End Date");
        VATEntry.SETRANGE("Do not include in VAT Ledgers", false);
        if VATEntry.FIND('-') then
          repeat
            Counter += 1;
            Window.UPDATE(1,ROUND(Counter/VATEntry.COUNT*10000,1));
            InsertPurchVATLedgerLine(VATEntry,true,VATLedger."Period Start Date",VATLedger."Period End Date");
          until VATEntry.NEXT = 0;

        Counter := 0;

        VATEntry.RESET;
        VATEntry.SETRANGE(Type,VATEntry.Type::" ");
        VATEntry.SETRANGE("Posting Date",VATLedger."Period Start Date",VATLedger."Period End Date");
        VATEntry.SETRANGE("Do not include in VAT Ledgers", false);
        if VATEntry.FIND('-') then
          repeat
            Counter += 1;
            Window.UPDATE(1,ROUND(Counter/VATEntry.COUNT*10000,1));
            VATPostingSetup.GET(VATEntry."VAT Bus. Posting Group",
              VATEntry."VAT Prod. Posting Group");
            if VATPostingSetup."Transaction Type" in [VATPostingSetup."Transaction Type"::Purchases,
              VATPostingSetup."Transaction Type"::Both] then
              InsertPurchVATLedgerLine(VATEntry,false,VATLedger."Period Start Date",VATLedger."Period End Date");
          until VATEntry.NEXT = 0;

        VATLedger.Created := true;
        VATLedger.Exported := false;
        VATLedger.MODIFY;

        Window.CLOSE;
    end;

    procedure InsertSalesVATLedgerLine(VATEntry : Record "VAT Entry";Voided : Boolean;FromDate : Date;ToDate : Date);
    var
        VATLedgerLine : Record "VAT Ledger Line";
        ContrAgentIDNo : Code[20];
        DocType : Text[2];
        ContragentName : Text[70];
        VATBase : Decimal;
        SalesInvoiceHeader : Record "Sales Invoice Header";
        SourceCodeSetup : Record "Source Code Setup";
        PostedVATProtocolHeader : Record "Posted VAT Protocol Header";
    begin
        with VATEntry do begin
          VATPostingSetup.GET("VAT Bus. Posting Group","VAT Prod. Posting Group");

          if "VAT Calculation Type" in ["VAT Calculation Type"::"Reverse Charge VAT",
            "VAT Calculation Type"::"Sales Tax"] then
            exit;

          if (("VAT Calculation Type" = "VAT Calculation Type"::"Normal VAT")or(
            "VAT Calculation Type" = "VAT Calculation Type"::"Full VAT")) and
            (("SAD No." <> '') and (not VATExportSetup."Incl. Sales with Custom Decl.")) then
            exit;

          if ("VAT Calculation Type" = "VAT Calculation Type"::"Normal VAT") and
            not ("Document Type" in ["Document Type"::Invoice,"Document Type"::"Credit Memo"]) then
            exit;

          if "Do not include in VAT Ledgers" then
            exit;

          //NAVBG11.0.001 begin
          if  VATPostingSetup."VAT Classification Code" = '14' then
            exit;
          //NAVBG11.0.001 end
          // TODO MISSING METHOD GetRegNo in table VatEntry
          //ContrAgentIDNo := GetRegNo;

          if "VAT Calculation Type" = "VAT Calculation Type"::"Full VAT" then begin
            DocType := '09';
          end else begin
            // TODO MISSING METHOD GetDocType in table VatEntry
           // DocType := GetDocType;
          end;

          //NAVBG8.00; 001; begin
          if VATEntry."Unrealized VAT" then begin

            if not BGSetup.GET then
              BGSetup.INIT;
            BGSetup.TESTFIELD( "Unrealized VAT Invoice Code" );
            BGSetup.TESTFIELD( "Unrealized VAT Debit Memo Code" );
            BGSetup.TESTFIELD( "Unrealized VAT Credi Memo Code" );

            case VATEntry."Document Type" of
              VATEntry."Document Type"::Invoice : begin
                SalesInvoiceHeader.GET( VATEntry."Document No." );
                if not SalesInvoiceHeader."Debit Memo" then
                  DocType := BGSetup."Unrealized VAT Invoice Code"
                else
                  DocType := BGSetup."Unrealized VAT Debit Memo Code";
              end;
              VATEntry."Document Type"::"Credit Memo" :
                DocType := BGSetup."Unrealized VAT Credi Memo Code";
            end;

          end;
          if not SourceCodeSetup.GET then
            SourceCodeSetup.INIT;
          SourceCodeSetup.TESTFIELD( "VAT Protocol" );
          if VATEntry."Source Code" = SourceCodeSetup."VAT Protocol" then begin
            PostedVATProtocolHeader.GET( VATEntry."Document No." );
            if PostedVATProtocolHeader."Protocol Type" = PostedVATProtocolHeader."Protocol Type"::"Unrealized VAT" then begin
              if PostedVATProtocolHeader."Protocol Subtype" = '' then begin
                if not GLSetup.GET then
                  GLSetup.INIT;
                GLSetup.TESTFIELD( "Unreal. VAT Prot. Code" );
                DocType := GLSetup."Unreal. VAT Prot. Code";
              end else
                DocType := PostedVATProtocolHeader."Protocol Subtype";
            end;
            //NAVBG11.0; 001; begin
            if PostedVATProtocolHeader."Protocol Type" = PostedVATProtocolHeader."Protocol Type"::Protocol then begin
              if PostedVATProtocolHeader."Protocol Subtype" = '95' then
                DocType := PostedVATProtocolHeader."Protocol Subtype";
            end;
            //NAVBG11.0; 001; end
          end;
          //NAVBG8.00; 001; end
          //TODO MISSING METHOD GetContragentName IN VatEntry table
          //ContragentName := GetContragentName;

          VATLedgerLine.RESET;
          VATLedgerLine.SETRANGE("Original Document No.","Document No.");
          VATLedgerLine.SETRANGE("Contracting Agent ID No.",ContrAgentIDNo);
          VATLedgerLine.SETRANGE(VATLedgerLine."Document Type",DocType);
          VATLedgerLine.SETRANGE(Type,VATLedgerLine.Type::Sales);
          VATLedgerLine.SETRANGE("Period Start Date",FromDate);
          if not VATLedgerLine.FIND('-') then begin
            EntryNo += 10000;
            VATLedgerLine.INIT;
            VATLedgerLine."Line No." := EntryNo;
            VATLedgerLine.Type := VATLedgerLine.Type::Sales;
            VATLedgerLine."Period Start Date" := FromDate;
            VATLedgerLine."Document Type" := DocType;
            VATLedgerLine."Document No." := FormatDocNo("Document No.",10);
            if VATLedgerLine."Document Type" = '07' then
              VATLedgerLine."Original Document No." := "SAD No."
            else
              VATLedgerLine."Original Document No." := "Document No.";
            VATLedgerLine."Issue Date" := "Document Date";
            VATLedgerLine."Contracting Agent ID No." := ContrAgentIDNo;
            VATLedgerLine."Contracting Agent Name" := ContragentName;
            VATLedgerLine."VAT Subject" := "VAT Subject";
            case Type of
              Type::Sale:
                VATLedgerLine."Contractor Type" := VATLedgerLine."Contractor Type"::Customer;
              Type::Purchase:
                VATLedgerLine."Contractor Type" := VATLedgerLine."Contractor Type"::Vendor;
            end;
            VATLedgerLine."Contractor No." := "Bill-to/Pay-to No.";

            VATLedgerLine.INSERT;
          end;

          VATLedgerLine."VAT Bus. Posting Group" := "VAT Bus. Posting Group";
          VATLedgerLine."VAT Prod. Posting Group" := "VAT Prod. Posting Group";

          //NAVBG8.00; 001; single
          VATLedgerLine."VAT Chargeable On Recipient" := VATEntry."VAT Chargeable On Recipient";

            VATLedgerLine.Base += SetSign(Base,VATLedgerLine."Document Type",0);
            VATLedgerLine.Amount += SetSign(Amount,VATLedgerLine."Document Type",0);

          FillSalesIndexes(VATLedgerLine);

          if not Voided and Void and ("Void Date" >= FromDate) and ("Void Date" <= ToDate) then begin
            //TODO MISSING METHOD GetDocType IN VATENTRY TABLE
            //VATLedgerLine."Document Type" := GetDocType;
            VATLedgerLine.MODIFY;
            exit;
          end;

            VATBase := Base;

          if ("VAT Calculation Type" = "VAT Calculation Type"::"Full VAT") and
            not "VAT Protocol" then begin
            VATPostingSetup.TESTFIELD("VAT %");
            VATBase := Amount / VATPostingSetup."VAT %" * 100;
          end;

          //NAVBG8.00; 001; begin
          //NAVBG11.0; 001; delete begin
          //IF VATEntry."Unrealized VAT" THEN BEGIN
          //  VATLedgerLine.Base := VATEntry."Unrealized Base";
          //  VATLedgerLine.Amount := VATEntry."Unrealized Amount";
          //END;
          //NAVBG11.0; 001; delete end

          //NAVBG11.0; 001; begin
          if VATEntry."Unrealized VAT" then begin
            VATLedgerLine.Base += SetSign(VATEntry."Unrealized Base",VATLedgerLine."Document Type",0);
            VATLedgerLine.Amount += SetSign(VATEntry."Unrealized Amount",VATLedgerLine."Document Type",0);
          end;
          //NAVBG11.0; 001; end

          if not SourceCodeSetup.GET then
            SourceCodeSetup.INIT;
          SourceCodeSetup.TESTFIELD( "VAT Protocol" );
          if VATEntry."Source Code" = SourceCodeSetup."VAT Protocol" then begin
            PostedVATProtocolHeader.GET( VATEntry."Document No." );
            if PostedVATProtocolHeader."Protocol Type" = PostedVATProtocolHeader."Protocol Type"::"Unrealized VAT" then begin
              VATLedgerLine.Base := ABS( VATLedgerLine.Base );
              VATLedgerLine.Amount := ABS( VATLedgerLine.Amount );
            end;
          end;
          //NAVBG8.00; 001; end

          VATLedgerLine.MODIFY;
        end;
    end;

    procedure InsertPurchVATLedgerLine(VATEntry : Record "VAT Entry";Voided : Boolean;FromDate : Date;ToDate : Date);
    var
        VATLedgerLine : Record "VAT Ledger Line";
        ContrAgentIDNo : Code[20];
        DocType : Text[2];
        ContragentName : Text[70];
        VATBase : Decimal;
        PurchaseInvoiceHeader : Record "Purch. Inv. Header";
        PurchInvoiceHeader : Record "Purch. Inv. Header";
        PurchCrMemoHeader : Record "Purch. Cr. Memo Hdr.";
    begin
        with VATEntry do begin
          VATPostingSetup.GET("VAT Bus. Posting Group","VAT Prod. Posting Group");

          if "VAT Calculation Type" in ["VAT Calculation Type"::"Reverse Charge VAT",
            "VAT Calculation Type"::"Sales Tax"] then
            exit;

          if ("VAT Calculation Type" = "VAT Calculation Type"::"Normal VAT") and
            ("SAD No." <> '') and
            (not VATExportSetup."Incl. Purch. with Custom Decl.")
          then
            exit;

          if ("VAT Calculation Type" = "VAT Calculation Type"::"Normal VAT") and
            not ("Document Type" in ["Document Type"::Invoice,"Document Type"::"Credit Memo"]) then
            exit;


          if "Do not include in VAT Ledgers" then
            exit;
          //TODO MISSING METHODS GetContragentName AND GetRegNo IN TABLE VAT ENTRY
          //ContragentName := GetContragentName;
          //ContrAgentIDNo := GetRegNo;

          if "VAT Calculation Type" = "VAT Calculation Type"::"Full VAT" then begin
            if "SAD No." <> '' then
              DocType := '07'
            else
              DocType := '09';
          end else begin
            //TODO MISSING METHODS GetDocType IN TABLE VAT ENTRY
            //DocType := GetDocType;
          end;

          //NAVBG8.00; 001; begin
          if VATEntry."Unrealized VAT" then begin

            if not BGSetup.GET then
              BGSetup.INIT;
            BGSetup.TESTFIELD( "Unrealized VAT Invoice Code" );
            BGSetup.TESTFIELD( "Unrealized VAT Debit Memo Code" );
            BGSetup.TESTFIELD( "Unrealized VAT Credi Memo Code" );

            case VATEntry."Document Type" of
              VATEntry."Document Type"::Invoice : begin
                PurchaseInvoiceHeader.GET( VATEntry."Document No." );
                if not PurchaseInvoiceHeader."Debit Memo" then
                  DocType := BGSetup."Unrealized VAT Invoice Code"
                else
                  DocType := BGSetup."Unrealized VAT Debit Memo Code";
              end;
              VATEntry."Document Type"::"Credit Memo" :
                DocType := BGSetup."Unrealized VAT Credi Memo Code";
            end;

          end;
          if not SourceCodeSetup.GET then
            SourceCodeSetup.INIT;
          SourceCodeSetup.TESTFIELD( "VAT Protocol" );
          if VATEntry."Source Code" = SourceCodeSetup."VAT Protocol" then begin
            PostedVATProtocolHeader.GET( VATEntry."Document No." );
            if PostedVATProtocolHeader."Protocol Type" = PostedVATProtocolHeader."Protocol Type"::"Unrealized VAT" then begin
              if PostedVATProtocolHeader."Protocol Subtype" = '' then begin
                if not GLSetup.GET then
                  GLSetup.INIT;
                GLSetup.TESTFIELD( "Unreal. VAT Prot. Code" );
                DocType := GLSetup."Unreal. VAT Prot. Code";
              end else
                DocType := PostedVATProtocolHeader."Protocol Subtype";
              // Get external document No.
              case PostedVATProtocolHeader."Original Doc. Type" of
                PostedVATProtocolHeader."Original Doc. Type"::Invoice : begin
                  PurchInvoiceHeader.GET( PostedVATProtocolHeader."Original Doc. No." );
                  "External Document No." := PurchInvoiceHeader."Vendor Invoice No.";
                end;
                PostedVATProtocolHeader."Original Doc. Type"::"Credit Memo" : begin
                  PurchCrMemoHeader.GET( PostedVATProtocolHeader."Original Doc. No." );
                  if PurchCrMemoHeader."Applies-to Doc. No." <> '' then
                    PurchInvoiceHeader.GET( PurchCrMemoHeader."Applies-to Doc. No." )
                  else
                    if PurchCrMemoHeader."To Invoice No." <> '' then
                      PurchInvoiceHeader.GET( PurchCrMemoHeader."To Invoice No." );

                   if PurchInvoiceHeader."Vendor Invoice No." <> '' then
                     "External Document No." := PurchInvoiceHeader."Vendor Invoice No."
                   else
                     "External Document No." := PurchCrMemoHeader."Vendor Cr. Memo No.";

                   // Set sign
                   VATEntry.Amount := -ABS( VATEntry.Amount );
                   VATEntry.Base := -ABS( VATEntry.Base );
                   VATEntry."Unrealized Amount" := -ABS( VATEntry."Unrealized Amount" );
                   VATEntry."Unrealized Base" := -ABS( VATEntry."Unrealized Base" );

                end;
              end;

            end;
          end;
          //NAVBG8.00; 001; end

          VATLedgerLine.RESET;
          VATLedgerLine.SETRANGE("Original Document No.","Document No.");
          VATLedgerLine.SETRANGE("Contracting Agent ID No.",ContrAgentIDNo);
          VATLedgerLine.SETRANGE(Type,VATLedgerLine.Type::Purchase);
          VATLedgerLine.SETRANGE("Period Start Date",FromDate);
          VATLedgerLine.SETRANGE(VATLedgerLine."Document Type",DocType);
          if not VATLedgerLine.FIND('-') then begin
            EntryNo += 10000;
            VATLedgerLine.INIT;
            VATLedgerLine."Line No." := EntryNo;
            VATLedgerLine.Type := VATLedgerLine.Type::Purchase;
            VATLedgerLine."Period Start Date" := FromDate;
            VATLedgerLine."Document Type" := DocType;
            if "External Document No." <> '' then
              VATLedgerLine."Document No." := FormatDocNo("External Document No.",10)
            else
              VATLedgerLine."Document No." := FormatDocNo("Document No.",10);
            if VATLedgerLine."Document Type" = '07' then begin
              VATLedgerLine."Document No." := FormatDocNo("SAD No.",10);
              VATLedgerLine."Original Document No." := "SAD No.";
            end else
              VATLedgerLine."Original Document No." := "Document No.";
            VATLedgerLine."Issue Date" := "Document Date";
            VATLedgerLine."Contracting Agent ID No." := ContrAgentIDNo;
            VATLedgerLine."Contracting Agent Name" := ContragentName;
            VATLedgerLine."VAT Subject" := "VAT Subject";
            case Type of
              Type::Sale:
                VATLedgerLine."Contractor Type" := VATLedgerLine."Contractor Type"::Customer;
              Type::Purchase:
                VATLedgerLine."Contractor Type" := VATLedgerLine."Contractor Type"::Vendor;
            end;
            VATLedgerLine."Contractor No." := "Bill-to/Pay-to No.";
            VATLedgerLine.INSERT;
          end;

          VATLedgerLine."VAT Bus. Posting Group" := "VAT Bus. Posting Group";
          VATLedgerLine."VAT Prod. Posting Group" := "VAT Prod. Posting Group";
          VATLedgerLine.Base += SetSign(Base,VATLedgerLine."Document Type",1);
          VATLedgerLine.Amount += SetSign(Amount,VATLedgerLine."Document Type",1);

          //NAVBG8.00; 001; single
          VATLedgerLine."VAT Chargeable On Recipient" := VATEntry."VAT Chargeable On Recipient";

          VATExportSetup.GET;
            if ("VAT Calculation Type" = "VAT Calculation Type"::"Full VAT") and
            ("SAD No." <> '') then begin
            VATExportSetup.TESTFIELD(VATExportSetup."VAT for Export %");
            VATLedgerLine.Base := Amount / VATExportSetup."VAT for Export %" * 100;
            VATLedgerLine."Contracting Agent ID No.":='999999999999999';
          end;

          //NAVBG8.00; 001; begin
          if VATEntry."Unrealized VAT" then begin
            VATLedgerLine.Base := VATEntry."Unrealized Base";
            VATLedgerLine.Amount := VATEntry."Unrealized Amount";
          end;
          //NAVBG8.00; 001; end

          FillPurchIndexes(VATLedgerLine);

          VATLedgerLine.MODIFY;
        end;
    end;

    procedure GetVATSubject(Type : Option " ",Purchase,Sale) : Text[30];
    begin
        VATExportSetup.GET;
        case Type of
          Type::Purchase:
            exit(VATExportSetup."Purchase VAT Subject");
          Type::Sale:
            exit(VATExportSetup."Sales VAT Subject");
        end;
    end;

    procedure CheckFileSize(var VATExportFile : File;BufferLen : Integer);
    begin
        VATExportSetup.GET;
        if VATExportSetup."File Rotation Size (Bytes)" = 0 then
          exit;

        if BufferLen > VATExportSetup."File Rotation Size (Bytes)" then begin
          Window.CLOSE;
          ERROR(
            Text16250,
            VATExportSetup.FIELDCAPTION("File Rotation Size (Bytes)"),
            VATExportSetup.TABLECAPTION);
        end;

        if VATExportFile.POS + BufferLen >
           VATExportSetup."File Rotation Size (Bytes)"
        then begin
          VATExportFile.CLOSE;
          VATExportFile.WRITEMODE(true);
          VATExportFile.TEXTMODE(false);

          if VATExportSetup."Export Type" =
             VATExportSetup."Export Type"::"Removable Disk"
          then begin
            if not CONFIRM(
                 Text16251,true,VATExportSetup."File Rotation Size (Bytes)")
            then begin
              Window.CLOSE;
              ERROR(Text16252)
            end else
              if not VATExportFile.CREATE(FileName) then begin
                Window.CLOSE;
                ERROR(Text16200,FileName);
              end;
          end else begin
            NoOfExportFiles += 1;
            if STRPOS(FileName,'.') <> 0 then begin
              if not VATExportFile.CREATE(
                   INSSTR(FileName,FORMAT(NoOfExportFiles),STRPOS(FileName,'.')))
              then begin
                Window.CLOSE;
                ERROR(Text16200,INSSTR(FileName,FORMAT(NoOfExportFiles),STRPOS(FileName,'.')));
              end;
            end else
              if not VATExportFile.CREATE(
                   INSSTR(FileName,FORMAT(NoOfExportFiles),STRLEN(FileName)))
              then begin
                Window.CLOSE;
                ERROR(Text16200,FileName);
              end;
            end;
          end;
    end;

    procedure ExportSales(PeriodStartDate : Date;SalesFileName : Text[250]);
    var
        VATLedger : Record "VAT Ledger";
        VATLedgerLine : Record "VAT Ledger Line";
        f : File;
        TotalCount : Integer;
        Buffer : Text[1024];
        Char : Char;
        BaseAmount : array [12] of Decimal;
        TotalBaseAmount : array [12] of Decimal;
        VATAmount : array [5] of Decimal;
        TotalVATAmount : array [5] of Decimal;
        TotalBase : Decimal;
        TotalVAT : Decimal;
    begin
        SetEncoding(1);
        ClientFileName := SalesFileName;
        if ISSERVICETIER then
          SalesFileName := TierMgt.ServerTempFileName('.txt');

        if not OutFile.CREATE(SalesFileName) then
          ERROR(Text16200,SalesFileName);

        OutFile.CREATEOUTSTREAM(FileOutStream);
        streamWriter := streamWriter.StreamWriter(FileOutStream, encoder.GetEncoding(1251) );

        VATExportSetup.GET;
        CompanyInfo.GET;

        VATLedger.GET(VATLedger.Type::Sales,PeriodStartDate);

        VATLedgerLine.SETRANGE(Type,VATLedgerLine.Type::Sales);
        VATLedgerLine.SETRANGE("Period Start Date",VATLedger."Period Start Date");

        Window.OPEN(Text001 + ' @1@@@@@@@@@@@@@@@@@');
        TotalCount := VATLedgerLine.COUNT;
        Counter := 0;
        NoOfExportFiles := 1;
        FileName := SalesFileName;

        with VATLedgerLine do begin
          if FINDSET then
            repeat
              Counter += 1;
              Window.UPDATE(1,ROUND(Counter / TotalCount * 10000,1));
              "Document No." := DELCHR(UPPERCASE("Document No."),'=',Alphabet);
              MODIFY;

              TotalBase:=  VATLedgerLine.Base;
              TotalVAT:=  VATLedgerLine.Amount;

              CLEAR(BaseAmount);
              CLEAR(VATAmount);
              FillSalesAmounts(VATLedgerLine,BaseAmount,TotalBaseAmount,VATAmount,TotalVATAmount);

              Buffer := FormatString(CompanyInfo."VAT Registration No.",15) +
                FormatReportingPeriod(VATLedger."Period Start Date") +
                FormatInteger(VATLedger.Branch,4) +
                FormatInteger(Counter,15) +
                FORMAT("Document Type",2) +
                FormatString("Document No.",20) +
                FormatDate("Issue Date") +
                FormatString("Contracting Agent ID No.",15) +
                FormatString("Contracting Agent Name",50) +
                FormatString("VAT Subject",30) +
                FormatDecimal(BaseAmount[IndSBase::"02-10"],15) +
                FormatDecimal(VATAmount[IndSVAT::"02-20"],15) +
                FormatDecimal(BaseAmount[IndSBase::"02-11"],15) +
                FormatDecimal(VATAmount[IndSVAT::"02-21"],15) +
                FormatDecimal(BaseAmount[IndSBase::"02-12"],15) +
                FormatDecimal(BaseAmount[IndSBase::"02-26"],15) +
                FormatDecimal(VATAmount[IndSVAT::"02-22"],15) +
                FormatDecimal(VATAmount[IndSVAT::"02-23"],15) +
                FormatDecimal(BaseAmount[IndSBase::"02-13"],15) +
                FormatDecimal(VATAmount[IndSVAT::"02-24"],15) +
                FormatDecimal(BaseAmount[IndSBase::"02-14"],15) +
                FormatDecimal(BaseAmount[IndSBase::"02-15"],15) +
                FormatDecimal(BaseAmount[IndSBase::"02-16"],15) +
                FormatDecimal(BaseAmount[IndSBase::"02-17"],15) +
                FormatDecimal(BaseAmount[IndSBase::"02-18"],15) +
                FormatDecimal(BaseAmount[IndSBase::"02-19"],15) +
                FormatDecimal(BaseAmount[IndSBase::"02-25"],15) +

                //NAVBG8.00; 001; single
                FormatString( FORMAT( "VAT Chargeable On Recipient" ), 2 );

              CheckFileSize(f,STRLEN(Buffer) + 2);
              WriteChars(Buffer);
            until NEXT = 0;

          streamWriter.Close();
          OutFile.CLOSE;

          if ISSERVICETIER then begin
            TierMgt.DownloadToFile(FileName,ClientFileName);
            SalesFileName := ClientFileName;
          end;
          MESSAGE(Text16201,SalesFileName);

          Window.CLOSE;

        end;

        VATLedger.Exported := true;
        VATLedger.Release;
        VATLedger.MODIFY;
    end;

    procedure ExportPurch(PeriodStartDate : Date;PurchFileName : Text[250]);
    var
        VATLedger : Record "VAT Ledger";
        VATLedgerLine : Record "VAT Ledger Line";
        f : File;
        TotalCount : Integer;
        Buffer : Text[1024];
        Char : Char;
        BaseAmount : array [4] of Decimal;
        TotalBaseAmount : array [4] of Decimal;
        VATAmount : array [2] of Decimal;
        TotalVATAmount : array [2] of Decimal;
    begin
        SetEncoding(1);
        ClientFileName := PurchFileName;
        if ISSERVICETIER then
          PurchFileName := TierMgt.ServerTempFileName('.txt');
        if not OutFile.CREATE(PurchFileName) then
          ERROR(Text16200,PurchFileName);

        OutFile.CREATEOUTSTREAM(FileOutStream);
        streamWriter := streamWriter.StreamWriter(FileOutStream, encoder.GetEncoding(1251) );

        VATExportSetup.GET;

        VATLedger.GET(VATLedger.Type::Purchase,PeriodStartDate);

        VATLedgerLine.SETRANGE(Type,VATLedgerLine.Type::Purchase);
        VATLedgerLine.SETRANGE("Period Start Date",VATLedger."Period Start Date");

        Window.OPEN(Text002 + ' @1@@@@@@@@@@@@@@@@@');
        TotalCount := VATLedgerLine.COUNT;
        Counter := 0;
        NoOfExportFiles := 1;
        FileName := PurchFileName;

        with VATLedgerLine do begin
          if FINDSET then
            repeat
              Counter += 1;
              Window.UPDATE(1,ROUND(Counter / TotalCount * 10000,1));
              "Document No." := DELCHR(UPPERCASE("Document No."),'=',Alphabet);
              MODIFY;

              CLEAR(VATAmount);
              CLEAR(BaseAmount);
              FillPurchAmounts(VATLedgerLine,BaseAmount,TotalBaseAmount,VATAmount,TotalVATAmount);

              Buffer :=
                FormatString(CompanyInfo."VAT Registration No.",15) +
                FormatReportingPeriod(VATLedger."Period Start Date") +
                FormatInteger(VATLedger.Branch,4) +
                FormatInteger(Counter,15) +
                FORMAT("Document Type",2) +
                FormatString("Document No.",20) +
                FormatDate("Issue Date") +
                FormatString("Contracting Agent ID No.",15) +
                FormatString("Contracting Agent Name",50) +
                FormatString("VAT Subject",30) +
                FormatDecimal(BaseAmount[IndPBase::"03-30"],15) +
                FormatDecimal(BaseAmount[IndPBase::"03-31"],15) +
                FormatDecimal(VATAmount[IndPVAT::"03-41"],15) +
                FormatDecimal(BaseAmount[IndPBase::"03-32"],15) +
                FormatDecimal(VATAmount[IndPVAT::"03-42"],15) +
                FormatDecimal(VATLedgerLine."Purch. Annual Corr. Amount",15) +
                FormatDecimal(BaseAmount[IndPBase::"03-44"],15) +

                //NAVBG8.00; 001; single
                FormatString( FORMAT( "VAT Chargeable On Recipient" ), 2 );

              CheckFileSize(f,STRLEN(Buffer) + 2);
              WriteChars(Buffer);

            until NEXT = 0;

          streamWriter.Close();
          OutFile.CLOSE;

          if ISSERVICETIER then begin
            TierMgt.DownloadToFile(FileName,ClientFileName);
            PurchFileName := ClientFileName;
          end;
          MESSAGE(Text16201,PurchFileName);
          Window.CLOSE;

        end;

        VATLedger.Exported := true;
        VATLedger.Release;
        VATLedger.MODIFY;
    end;

    procedure ExportDeclaration(FromDate : Date;ToDate : Date;DeclFileName : Text[250]);
    var
        f : File;
        CompanyInfo : Record "Company Information";
        VATDeclaration : Record "VAT Declaration";
        Buffer : Text[1024];
        char : Char;
        DeclAmount : array [30] of Decimal;
        SalesVATLedgerLinesQty : Integer;
        PurchVATLedgerLinesQty : Integer;
    begin
        SetEncoding(1);
        VATDeclaration.GET(VATDeclaration.Type::"Monthly VAT Declaration",FromDate);

        CompanyInfo.GET;
        CompanyInfo.TESTFIELD("Identification No.");
        CompanyInfo.TESTFIELD(Name);

        VATExportSetup.GET;

        ClientFileName := DeclFileName;
        if ISSERVICETIER then
          DeclFileName := TierMgt.ServerTempFileName('.txt');
        if not OutFile.CREATE(DeclFileName) then
          ERROR(Text16200,DeclFileName);

        OutFile.CREATEOUTSTREAM(FileOutStream);
        streamWriter := streamWriter.StreamWriter(FileOutStream, encoder.GetEncoding(1251) );

        FillDeclaration(VATDeclaration,DeclAmount,SalesVATLedgerLinesQty,PurchVATLedgerLinesQty);

        Buffer := FormatString(CompanyInfo."VAT Registration No.",15) +
          FormatString(CompanyInfo.Name,50) +
          FormatReportingPeriod(FromDate) +
          FormatString(VATExportSetup."Authorized Person",50) +
          FormatInteger(SalesVATLedgerLinesQty,15) +
          FormatInteger(PurchVATLedgerLinesQty,15) +
          FormatDecimal(DeclAmount[IndD::"01-01"],15) +
          FormatDecimal(DeclAmount[IndD::"01-20"],15) +
          FormatDecimal(DeclAmount[IndD::"01-11"],15) +
          FormatDecimal(DeclAmount[IndD::"01-21"],15) +
          FormatDecimal(DeclAmount[IndD::"01-12"],15) +
          FormatDecimal(DeclAmount[IndD::"01-22"],15) +
          FormatDecimal(DeclAmount[IndD::"01-23"],15) +
          FormatDecimal(DeclAmount[IndD::"01-13"],15) +
          FormatDecimal(DeclAmount[IndD::"01-24"],15) +
          FormatDecimal(DeclAmount[IndD::"01-14"],15) +
          FormatDecimal(DeclAmount[IndD::"01-15"],15) +
          FormatDecimal(DeclAmount[IndD::"01-16"],15) +
          FormatDecimal(DeclAmount[IndD::"01-17"],15) +
          FormatDecimal(DeclAmount[IndD::"01-18"],15) +
          FormatDecimal(DeclAmount[IndD::"01-19"],15) +
          FormatDecimal(DeclAmount[IndD::"01-30"],15) +
          FormatDecimal(DeclAmount[IndD::"01-31"],15) +
          FormatDecimal(DeclAmount[IndD::"01-41"],15) +
          FormatDecimal(DeclAmount[IndD::"01-32"],15) +
          FormatDecimal(DeclAmount[IndD::"01-42"],15) +
          FormatDecimal(DeclAmount[IndD::"01-43"],15) +
          FormatDecimal(DeclAmount[IndD::"01-33"],4) +
          FormatDecimal(DeclAmount[IndD::"01-40"],15) +
          FormatDecimal(DeclAmount[IndD::"01-50"],15) +
          FormatDecimal(DeclAmount[IndD::"01-60"],15) +
          FormatDecimal(DeclAmount[IndD::"01-70"],15) +
          FormatDecimal(DeclAmount[IndD::"01-71"],15) +
          FormatDecimal(DeclAmount[IndD::"01-80"],15) +
          FormatDecimal(DeclAmount[IndD::"01-81"],15) +
          FormatDecimal(DeclAmount[IndD::"01-82"],15);

        WriteChars(Buffer);

        streamWriter.Close();
        OutFile.CLOSE;

        if ISSERVICETIER then begin
          TierMgt.DownloadToFile(DeclFileName,ClientFileName);
          DeclFileName := ClientFileName;
        end;
        MESSAGE(Text16201,DeclFileName);
    end;

    procedure ExportVIES(FromDate : Date;ToDate : Date;VIESFileName : Text[250];FileType : Option "Fixed Column Length","Comma Separated");
    var
        CompanyInfo : Record "Company Information";
        VATDeclaration : Record "VAT Declaration";
        CustIntraCommSalesBuffer : Record "Sales Buffer" temporary;
        f : File;
        Buffer : Text[1024];
        TaxableBaseTotalAmount : Decimal;
        TaxableBaseIntraComm : Decimal;
        EntryNo : Integer;
    begin
        SetEncoding(1);

        CompanyInfo.GET;
        CompanyInfo.TESTFIELD("Identification No.");
        CompanyInfo.TESTFIELD(Name);

        VATDeclaration.GET(VATDeclaration.Type::"VIES Declaration",FromDate);

        VATExportSetup.GET;

        ClientFileName := VIESFileName;
        if ISSERVICETIER then
          VIESFileName := TierMgt.ServerTempFileName('.txt');
        if not OutFile.CREATE(VIESFileName) then
          ERROR(Text16200,VIESFileName);

        OutFile.CREATEOUTSTREAM(FileOutStream);
        streamWriter := streamWriter.StreamWriter(FileOutStream, encoder.GetEncoding(1251) );

        // fill Intra Community Sales buffer
        FillIntraCommSalesBuffer(CustIntraCommSalesBuffer,TaxableBaseTotalAmount,
          TaxableBaseIntraComm,FromDate,ToDate);

        // Master data section
        CLEAR(Buffer);
        AddToBuffer_Str(Buffer,VHRTxt,3,FileType);
        AddToBuffer_Date(Buffer,FromDate,FileType);
        AddToBuffer_Integer(Buffer,CustIntraCommSalesBuffer.COUNT,5,FileType);

        WriteChars(Buffer);

        // Declaring person section
        CLEAR(Buffer);
        AddToBuffer_Str(Buffer,VDRTxt,3,FileType);
        AddToBuffer_Str(Buffer,VATDeclaration."Employee ID",15,FileType);
        AddToBuffer_Str(Buffer,VATDeclaration."Employee Name",150,FileType);
        AddToBuffer_Str(Buffer,VATDeclaration."Employee City",50,FileType);
        AddToBuffer_Str(Buffer,VATDeclaration."Employee Post Code",4,FileType);
        AddToBuffer_Str(Buffer,VATDeclaration."Employee Address",150,FileType);
        case VATDeclaration."Employee Position Type" of
          VATDeclaration."Employee Position Type"::"Authorized Person":
            AddToBuffer_Str(Buffer,'A',1,FileType);
          VATDeclaration."Employee Position Type"::Procurator:
            AddToBuffer_Str(Buffer,'R',1,FileType);
          end;

        WriteChars(Buffer);

        // Declaring entity section
        CLEAR(Buffer);
        AddToBuffer_Str(Buffer,VTRTxt,3,FileType);
        AddToBuffer_Str(Buffer,CompanyInfo."VAT Registration No.",15,FileType);
        AddToBuffer_Str(Buffer,CompanyInfo.Name + CompanyInfo."Name 2",150,FileType);
        AddToBuffer_Str(Buffer,CompanyInfo.Address + CompanyInfo."Address 2",200,FileType);

        WriteChars(Buffer);

        // Total turnover section
        CLEAR(Buffer);
        AddToBuffer_Str(Buffer,TTRTxt,3,FileType);
        AddToBuffer_Decimal(Buffer,TaxableBaseTotalAmount,12,FileType);
        AddToBuffer_Decimal(Buffer,TaxableBaseIntraComm,12,FileType);

        WriteChars(Buffer);

        // Intra-community sales section
        EntryNo := 0;
        if CustIntraCommSalesBuffer.FINDSET then
          repeat
            EntryNo := EntryNo + 1;
            CLEAR(Buffer);
            AddToBuffer_Str(Buffer,VIRTxt,3,FileType);
            AddToBuffer_Integer(Buffer,EntryNo,5,FileType);
            AddToBuffer_Str(Buffer,CustIntraCommSalesBuffer."VAT Registration No.",15,FileType);
            AddToBuffer_Decimal(Buffer,CustIntraCommSalesBuffer."Amount 1",12,FileType);
            AddToBuffer_Decimal(Buffer,CustIntraCommSalesBuffer."Amount 2",12,FileType);
            AddToBuffer_Decimal(Buffer,CustIntraCommSalesBuffer."Amount 3",12,FileType);
            AddToBuffer_Date(Buffer,FromDate,FileType);

            WriteChars(Buffer);

          until CustIntraCommSalesBuffer.NEXT = 0;

        streamWriter.Close();
        OutFile.CLOSE;

        if ISSERVICETIER then begin
          TierMgt.DownloadToFile(VIESFileName,ClientFileName);
          VIESFileName := ClientFileName;
        end;
        MESSAGE(Text16201,VIESFileName);
    end;

    procedure SetSign(Number : Decimal;DocType : Text[2];VATType : Option Sales,Purch) : Decimal;
    begin
        case DocType of
          '01','02','07','81','82' :   if VATType = VATType::Sales then
                                                      exit(-ROUND(Number))
                                                    else
                                                      exit(ROUND(Number));

          '03': if VATType = VATType::Sales then
                    exit(-ROUND(Number))
                else
                    exit(ROUND(Number));

          '09': if VATType = VATType::Sales then
                        exit(-ROUND(Number))
                      else
                        exit(ROUND(Number));
           //NAVBG11.0; 001; begin
           '91','92','94','95': if VATType = VATType::Sales then
                                       exit(-ROUND(Number))
                                     else
                                       exit(ROUND(Number));


           '11','12','13' :  if VATType = VATType::Sales then
                           exit(-ROUND(Number))
                        else
                           exit(ROUND(Number));
           //NAVBG11.0; 001; end
        end;

        exit(ROUND(Number));
    end;

    procedure SetEncoding(NewEncoding : Option DOS,WIN);
    begin
        Encoding := NewEncoding;
    end;

    procedure Alphabet() : Text[100];
    begin
        exit(CharsTxt);
    end;

    procedure WinCyr2DosCyr(str : Text[1024]) : Text[1024];
    var
        i : Integer;
        ch : Char;
    begin
        for i := 1 to STRLEN(str) do
          if str[i] in ['р'..'я'] then begin
            ch := str[i]-48;
            str[i] := ch;
          end;
        exit(str);
    end;

    procedure Dos2Win(DosText : Text[1024]) WinText : Text[1024];
    var
        Pos : Integer;
        OneChar : Char;
    begin
        WinText := '';
        for Pos := 1 to STRLEN(DosText) do begin
        
          OneChar := DosText[Pos];
          /*
          IF (OneChar >= 'А') AND (OneChar <= 'п') THEN
            OneChar := OneChar + 64
          ELSE
          IF (OneChar >= 'п') AND (OneChar <= 'я') THEN
            OneChar := OneChar + 16
          ELSE
          IF (OneChar = 'Ё') THEN
            OneChar := 168
          ELSE
          IF (OneChar = 'ё') THEN
            OneChar := 184;
          */
          WinText := WinText + FORMAT(OneChar);
        end;

    end;

    procedure WriteCharbyChar(Row : Text[1024];var f : File);
    var
        i : Integer;
        Len : Integer;
        Char : Char;
    begin
        FinishLine(Row);

        Len := STRLEN(Row);
        for i := 1 to Len do
          streamWriter.Write( Row[i] );
    end;

    procedure FormatString(String : Text[250];Length : Integer) : Text[250];
    begin
        // Return string is left aligned, filled with spaces at the end to size Length and in DOS cyrillic
        case Encoding of
          Encoding::WIN:
            exit(PADSTR(Dos2Win(String),Length,' '));

          Encoding::DOS:
        exit(WinCyr2DosCyr(PADSTR(String,Length,' ')));
        end;
    end;

    procedure FormatDocNo(String : Text[250];Length : Integer) : Text[250];
    var
        Str : Text[250];
        Len : Integer;
    begin
        // Return string is right aligned, filled with "0" at the front to size Length and has only digits
        String := DELCHR(String,'=',Alphabet);

        Len := STRLEN(String) - Length;
        if Len <= 0 then Len := 1;
        String := COPYSTR(String,Len,Length);

        Len := Length - STRLEN(String);
        if Len < 0 then Len := 0;

        Str := STRSUBSTNO(FormatTxt2,Len,String);
        exit(FORMAT('',0,Str));
    end;

    procedure FormatInteger(Number : Integer;Length : Integer) : Text[250];
    var
        Str : Text[50];
    begin
        // Return string is right aligned and is filled with spaces at the front to size  Length

        exit(FORMAT(Number,Length,IntTxt));
    end;

    procedure FormatDecimal(Number : Decimal;Length : Integer) : Text[250];
    var
        Str : Text[255];
    begin
        // Return string is right aligned ,filled with spaces at the front to  size Length, comma separator is "."
        // and decimal places are always 2 digits

        Str  := STRSUBSTNO(FormatTxt1);
        exit(FORMAT(ROUND(Number),Length,Str));
    end;

    procedure FormatDate(date : Date) : Text[10];
    begin
        // Return string has 10 characters length and date separator "/" (dd/mm/yyyy)

        exit(FORMAT(date,10,FormatTxt3));
    end;

    procedure FormatReportingPeriod(PeriodStartDate : Date) : Text[6];
    begin
        exit(FORMAT(PeriodStartDate,6,FormatTxt4));
    end;

    procedure FormatReportingPeriodVIES(PeriodStartDate : Date) : Text[7];
    begin
        exit(FORMAT(PeriodStartDate,7,FormatTxt5));
    end;

    procedure FinishLine(var Buffer : Text[1024]);
    var
        Char : Char;
    begin
        Char := 13;
        Buffer := Buffer + FORMAT(Char);
        Char := 10;
        Buffer := Buffer + FORMAT(Char);
    end;

    procedure AddToCSV_Str(var Buffer : Text[1024];Str : Text[250]);
    begin
        if Buffer = '' then
          Buffer := FormatString(Str,STRLEN(Str))
        else
          Buffer := Buffer + ';' + FormatString(Str,STRLEN(Str));
    end;

    procedure AddToBuffer_Str(var Buffer : Text[1024];Str : Text[250];Lenght : Integer;FileType : Option "Fixed Column Length","Comma Separated");
    begin
        case FileType of
          FileType::"Fixed Column Length":
            Buffer := Buffer + FormatString(Str,Lenght);

          FileType::"Comma Separated":
            AddToCSV_Str(Buffer,Str);
        end;
    end;

    procedure AddToBuffer_Integer(var Buffer : Text[1024];Number : Integer;Lenght : Integer;FileType : Option "Fixed Column Length","Comma Separated");
    var
        Str : Text[250];
    begin
        case FileType of
          FileType::"Fixed Column Length":
            Buffer := Buffer + FormatInteger(Number,Lenght);

          FileType::"Comma Separated":
            AddToCSV_Str(Buffer,FORMAT(Number));
        end;
    end;

    procedure AddToBuffer_Date(var Buffer : Text[1024];Date : Date;FileType : Option "Fixed Column Length","Comma Separated");
    begin
        case FileType of
          FileType::"Fixed Column Length":
            Buffer := Buffer + FormatReportingPeriodVIES(Date);

          FileType::"Comma Separated":
            AddToCSV_Str(Buffer,FORMAT(FormatReportingPeriodVIES(Date)));
        end;
    end;

    procedure AddToBuffer_Decimal(var Buffer : Text[1024];Number : Decimal;Lenght : Integer;FileType : Option "Fixed Column Length","Comma Separated");
    begin
        case FileType of
          FileType::"Fixed Column Length":
            Buffer := Buffer + FormatDecimal(Number,Lenght);

          FileType::"Comma Separated":
            AddToCSV_Str(Buffer,FORMAT(Number,0,FormatTxt6));
        end;
    end;

    procedure FillSalesAmounts(VATLedgerLine : Record "VAT Ledger Line";var BaseAmount : array [12] of Decimal;var TotalBaseAmount : array [12] of Decimal;var VATAmount : array [5] of Decimal;var TotalVATAmount : array [5] of Decimal);
    var
        VATPostingSetup : Record "VAT Posting Setup";
        i : Integer;
    begin
        VATLedger2.GET(VATLedgerLine.Type, VATLedgerLine."Period Start Date");

        VATEntry.RESET;
        VATEntry.SETRANGE(Type, VATEntry.Type::Sale);
        VATEntry.SETRANGE("Document Date", VATLedgerLine."Issue Date");

        VATEntry.SETRANGE(VATEntry."Document No.", VATLedgerLine."Original Document No.") ;
        case VATLedgerLine."Document Type" of
           '01':  VATEntry.SETRANGE("Document Type",VATEntry."Document Type"::Invoice );
           '02':  VATEntry.SETRANGE(VATEntry."Debit Memo",true);
           '03':  VATEntry.SETRANGE("Document Type",VATEntry."Document Type"::"Credit Memo" );
           '09':  VATEntry.SETRANGE("Document Type",VATEntry."Document Type"::" " );
           //NAVBG11.0; 001; single
           '95':  VATEntry.SETRANGE("Document Type",VATEntry."Document Type"::" " );
           '81':  VATEntry.SETRANGE(VATEntry."Sales Protocol",true );
        end;

        VATEntry.SETRANGE(VATEntry."Do not include in VAT Ledgers", false);

        if VATEntry.FIND('-') then repeat
          if ((VATEntry."Posting Date" >= VATLedger2."Period Start Date") and (VATEntry."Posting Date" <= VATLedger2."Period End Date")
          and (VATEntry.Void=false))
          or
          ((VATEntry."Posting Date" >= VATLedger2."Period Start Date") and (VATEntry."Posting Date" <= VATLedger2."Period End Date")
          and ((VATEntry."Void Date"<VATLedger2."Period Start Date") or (VATEntry."Void Date">VATLedger2."Period End Date")))

          then begin
          //NAVBG11.0; 001; begin
          //NAVBG8.00; 001; begin
            if VATEntry."Unrealized VAT" then begin
              VATEntry.Base := VATEntry."Unrealized Base";
              VATEntry.Amount := VATEntry."Unrealized Amount";
            end;
          //NAVBG8.00; 001; end

          //NAVBG11.0; 001; end
           if  VATPostingSetup.GET(VATEntry."VAT Bus. Posting Group",VATEntry."VAT Prod. Posting Group")  then
            case VATPostingSetup."VAT Classification Code" of
             '':
              if VATPostingSetup."Transaction Type" = VATPostingSetup."Transaction Type"::Sales then begin
               BaseAmount[IndSBase::"02-11"]+=SetSign(VATEntry.Base, VATLedgerLine."Document Type",0);    //BaseAmount[1]]
               VATAmount[IndSVAT::"02-21"]+= SetSign(VATEntry.Amount, VATLedgerLine."Document Type",0)  ; //VATAmount[1]
               BaseAmount[IndSBase::"02-10"]+=SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);     //BaseAmount[12]
               VATAmount[IndSVAT::"02-20"]+=SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0);     //VatAmount[5]
               //NAVBG11.0; 001; begin
               if not CodeInUnrealizedVat(VATLedgerLine."Document Type") then begin
                  TotalBaseAmount[IndSBase::"02-11"]+=SetSign(VATEntry.Base, VATLedgerLine."Document Type",0);    //TotalBaseAmount[1]
                  TotalVATAmount[IndSVAT::"02-21"]+= SetSign(VATEntry.Amount, VATLedgerLine."Document Type",0)  ; //TotalVATAmount[1]
                  TotalBaseAmount[IndSBase::"02-10"]+=SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);     //TotalBaseAmount[12]
                  TotalVATAmount[IndSVAT::"02-20"]+=SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0);     //TotalVATAmount[5]
               end;
               //NAVBG11.0; 001; end
              end;

            '08':
              if VATPostingSetup."Transaction Type" in [VATPostingSetup."Transaction Type"::Purchases,
              VATPostingSetup."Transaction Type"::Both] then begin
               BaseAmount[IndSBase::"02-12"]+= SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);   //BaseAmount[2]
               VATAmount[IndSVAT::"02-22"]+= SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0);   //VatAmount[2]
               BaseAmount[IndSBase::"02-10"]+=SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);    //BaseAmount[12]
               VATAmount[IndSVAT::"02-20"]+=SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0);    //VatAmount[5]
               //NAVBG11.0; 001; begin
               if not CodeInUnrealizedVat(VATLedgerLine."Document Type") then begin
                  TotalBaseAmount[IndSBase::"02-12"]+= SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);   //TotalBaseAmount[2]
                  TotalVATAmount[IndSVAT::"02-22"]+= SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0);   //TotalVATAmount[2]
                  TotalBaseAmount[IndSBase::"02-10"]+=SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);    //TotalBaseAmount[12]
                  TotalVATAmount[IndSVAT::"02-20"]+=SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0);    //TotalVATAmount[5]
                end;
               //NAVBG11.0; 001;end
              end;

            '01':
              if VATPostingSetup."Transaction Type" in [VATPostingSetup."Transaction Type"::Sales,
              VATPostingSetup."Transaction Type"::Both] then   begin
               VATAmount[IndSVAT::"02-23"]+= SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0) ;  //VATAmount[3]
               BaseAmount[IndSBase::"02-10"]+=SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);   //BaseAmount[12]
               VATAmount[IndSVAT::"02-20"]+=SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0);   //VatAmount[5]
               //NAVBG11.0; 001; begin
               if not CodeInUnrealizedVat(VATLedgerLine."Document Type") then begin
                  TotalVATAmount[IndSVAT::"02-23"]+= SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0) ;  //TotalVATAmount[3]
                  TotalBaseAmount[IndSBase::"02-10"]+=SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);   //TotalBaseAmount[12]
                  TotalVATAmount[IndSVAT::"02-20"]+=SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0);   //TotalVATAmount[5]
                end;
               //NAVBG11.0; 001; end
              end;

            '07':
              if VATPostingSetup."Transaction Type" = VATPostingSetup."Transaction Type"::Sales then begin
               BaseAmount[IndSBase::"02-13"]+=SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);   //BaseAmount[3]
               VATAmount[IndSVAT::"02-24"]+= SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0);  //VATAmount[4]
               BaseAmount[IndSBase::"02-10"]+=SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);   //BaseAmount[12]
               VATAmount[IndSVAT::"02-20"]+=SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0);   //VatAmount[5]
               //NAVBG11.0; 001; begin
               if not CodeInUnrealizedVat(VATLedgerLine."Document Type") then begin
                  TotalBaseAmount[IndSBase::"02-13"]+=SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);   //TotalBaseAmount[3]
                  TotalVATAmount[IndSVAT::"02-24"]+= SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0);  //TotalVatAmount[4]
                  TotalBaseAmount[IndSBase::"02-10"]+=SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);   //TotalBaseAmount[12]
                  TotalVATAmount[IndSVAT::"02-20"]+=SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0);   //TotalVATAmount[5]
                end;
               //NAVBG11.0; 001; end
               end;

            '03':
              if VATPostingSetup."Transaction Type" = VATPostingSetup."Transaction Type"::Sales then  begin
               BaseAmount[IndSBase::"02-14"]+= SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);   //BaseAmount[4]
               BaseAmount[IndSBase::"02-10"]+=SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);    //BaseAmount[12]
               //NAVBG11.0; 001; delete single
               //VATAmount[IndSVAT::"02-20"]+=SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0);
               //NAVBG11.0; 001;begin
               if not CodeInUnrealizedVat(VATLedgerLine."Document Type") then begin
                  TotalBaseAmount[IndSBase::"02-14"]+= SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);   //TotalBaseAmount[4]
                  TotalBaseAmount[IndSBase::"02-10"]+=SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);    //TotalBaseAmount[12]
               end;
               //NAVBG11.0; 001; end
              end;

            '13':
              if VATPostingSetup."Transaction Type" = VATPostingSetup."Transaction Type"::Sales then  begin
               BaseAmount[IndSBase::"02-15"]+=SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);   //BaseAmount[5]
               BaseAmount[IndSBase::"02-10"]+=SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);   //BaseAmount[12]
               //NAVBG11.0; 001; begin
               if not CodeInUnrealizedVat(VATLedgerLine."Document Type") then begin
                  TotalBaseAmount[IndSBase::"02-15"]+=SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);   //TotalBaseAmount[5]
                  TotalBaseAmount[IndSBase::"02-10"]+=SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);   //TotalBaseAmount[12]
               end;
               //NAVBG11.0; 001; end

               //NAVBG11.0; 001; delete single
               //VATAmount[IndSVAT::"02-20"]+=SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0);
              end;

            '04':
              if VATPostingSetup."Transaction Type" in [VATPostingSetup."Transaction Type"::Sales,
              VATPostingSetup."Transaction Type"::Both] then    begin
               BaseAmount[IndSBase::"02-16"]+= SetSign(VATEntry.Base,VATLedgerLine."Document Type",0); //BaseAmount[6]
               BaseAmount[IndSBase::"02-10"]+=SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);  //BaseAmount[12]
               //NAVBG11.0; 001; begin
               if not CodeInUnrealizedVat(VATLedgerLine."Document Type") then begin
                  TotalBaseAmount[IndSBase::"02-16"]+= SetSign(VATEntry.Base,VATLedgerLine."Document Type",0); //TotalBaseAmount[6]
                  TotalBaseAmount[IndSBase::"02-10"]+=SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);  //TotalBaseAmount[12]
               end;
               //NAVBG11.0; 001; end

               //NAVBG11.0; 001; delete single
               //VATAmount[IndSVAT::"02-20"]+=SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0);
              end;

            '05':
              if VATPostingSetup."Transaction Type" in [VATPostingSetup."Transaction Type"::Sales,
              VATPostingSetup."Transaction Type"::Both] then     begin
               BaseAmount[IndSBase::"02-17"]+= SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);  //BaseAmount[7]
               //NAVBG11.0; 001; begin
               if not CodeInUnrealizedVat(VATLedgerLine."Document Type") then
                  TotalBaseAmount[IndSBase::"02-17"]+= SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);  //TotalBaseAmount[7]
               //NAVBG11.0; 001; end

               //NAVBG11.0; 001; delete begin
               //BaseAmount[IndSBase::"02-10"]:=0;
               //VATAmount[IndSVAT::"02-20"]+=SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0);
               //NAVBG11.0; 001; delete end
              end;

            '06':
              if VATPostingSetup."Transaction Type" in [VATPostingSetup."Transaction Type"::Sales,
              VATPostingSetup."Transaction Type"::Both] then   begin
               BaseAmount[IndSBase::"02-18"]+= SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);  //BaseAmount[8]
               //NAVBG11.0; 001; begin
               if not CodeInUnrealizedVat(VATLedgerLine."Document Type") then
                  TotalBaseAmount[IndSBase::"02-18"]+= SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);  //TotalBaseAmount[8]
               //NAVBG11.0; 001; end

               //NAVBG11.0; 001; delete begin
               //BaseAmount[IndSBase::"02-10"]:=0;
               //VATAmount[IndSVAT::"02-20"]+=SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0);
               //NAVBG11.0; 001; delete end
              end;

            '09':
              if VATPostingSetup."Transaction Type" in [VATPostingSetup."Transaction Type"::Sales,
              VATPostingSetup."Transaction Type"::Both] then   begin
               BaseAmount[IndSBase::"02-18"]+= SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);  //BaseAmount[8]
               //NAVBG11.0; 001; begin
               if not CodeInUnrealizedVat(VATLedgerLine."Document Type") then
                  TotalBaseAmount[IndSBase::"02-18"]+= SetSign(VATEntry.Base,VATLedgerLine."Document Type",0); //TotalBaseAmount[8]
               //NAVBG11.0; 001; end

               //NAVBG11.0; 001; delete begin
               //BaseAmount[IndSBase::"02-10"]:=0;
               //VATAmount[IndSVAT::"02-20"]+=SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0);
               //NAVBG11.0; 001; delete end
              end;

            '10':    begin
               BaseAmount[IndSBase::"02-19"]+=SetSign(VATEntry.Base,VATLedgerLine."Document Type",0); //BaseAmount[9]
               //NAVBG11.0; 001; begin
               if not CodeInUnrealizedVat(VATLedgerLine."Document Type") then
                  TotalBaseAmount[IndSBase::"02-19"]+=SetSign(VATEntry.Base,VATLedgerLine."Document Type",0); //TotalBaseAmount[9]
               //NAVBG11.0; 001; end

               //NAVBG11.0; 001; delete begin
               //BaseAmount[IndSBase::"02-10"]:=0;
               //VATAmount[IndSVAT::"02-20"]+=SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0);
               //NAVBG11.0; 001; delete end
              end;

            '12':
              if VATPostingSetup."Transaction Type" in [VATPostingSetup."Transaction Type"::Sales,
              VATPostingSetup."Transaction Type"::Both] then   begin
               BaseAmount[IndSBase::"02-25"]+= SetSign(VATEntry.Base,VATLedgerLine."Document Type",0); //BaseAmount[10]
               //NAVBG11.0; 001; begin
               if not CodeInUnrealizedVat(VATLedgerLine."Document Type") then
                  TotalBaseAmount[IndSBase::"02-25"]+= SetSign(VATEntry.Base,VATLedgerLine."Document Type",0); //TotalBaseAmount[10]
               //NAVBG11.0; 001; end
              end;

            '02': begin
              if (VATPostingSetup."Transaction Type" in [VATPostingSetup."Transaction Type"::Purchases,
              VATPostingSetup."Transaction Type"::Both]) then begin
               BaseAmount[IndSBase::"02-26"]+= SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);   //BaseAmount[11]
               VATAmount[IndSVAT::"02-22"]+= SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0) ;  //VatAmount[2]
               BaseAmount[IndSBase::"02-10"]+=SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);    //BaseAmount[12]
               VATAmount[IndSVAT::"02-20"]+=SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0);    //VatAmount[5]
               //NAVBG11.0; 001; begin
               if not CodeInUnrealizedVat(VATLedgerLine."Document Type") then begin
                  TotalBaseAmount[IndSBase::"02-26"]+= SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);   //TotalBazeAmount[11]
                  TotalVATAmount[IndSVAT::"02-22"]+= SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0) ;  //TotalVatAmount[2]
                  TotalBaseAmount[IndSBase::"02-10"]+=SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);    //TotalBaseAmount[12]
                  TotalVATAmount[IndSVAT::"02-20"]+=SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0);    //TotalVATAmount[5]
               end;
               //NAVBG11.0; 001; end
              end;
            end;
          end;
        end;

        if (VATEntry.Void=true) and
          ((VATEntry."Posting Date" < VATLedger2."Period Start Date") or (VATEntry."Posting Date" > VATLedger2."Period End Date"))
          then begin

           if  VATPostingSetup.GET(VATEntry."VAT Bus. Posting Group",VATEntry."VAT Prod. Posting Group")  then
            case VATPostingSetup."VAT Classification Code" of
             '':
              if VATPostingSetup."Transaction Type" = VATPostingSetup."Transaction Type"::Sales then begin
               BaseAmount[IndSBase::"02-11"]+=-SetSign(VATEntry.Base, VATLedgerLine."Document Type",0);
               VATAmount[IndSVAT::"02-21"]+=-SetSign(VATEntry.Amount, VATLedgerLine."Document Type",0);
               BaseAmount[IndSBase::"02-10"]+=-SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);
               VATAmount[IndSVAT::"02-20"]+=-SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0);
               //NAVBG11.0; 001; begin
               if not CodeInUnrealizedVat(VATLedgerLine."Document Type") then begin
                  TotalBaseAmount[IndSBase::"02-11"]+=-SetSign(VATEntry.Base, VATLedgerLine."Document Type",0);
                  TotalVATAmount[IndSVAT::"02-21"]+=-SetSign(VATEntry.Amount, VATLedgerLine."Document Type",0);
                  TotalBaseAmount[IndSBase::"02-10"]+=-SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);
                  TotalVATAmount[IndSVAT::"02-20"]+=-SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0);
               end;
               //NAVBG11.0; 001; end
              end;

            '08':
              if VATPostingSetup."Transaction Type" in [VATPostingSetup."Transaction Type"::Purchases,
              VATPostingSetup."Transaction Type"::Both] then begin
               BaseAmount[IndSBase::"02-12"]+=-SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);
               VATAmount[IndSVAT::"02-22"]+=-SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0);
               BaseAmount[IndSBase::"02-10"]+=-SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);
               VATAmount[IndSVAT::"02-20"]+=-SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0);
               //NAVBG11.0; 001; begin
               if not CodeInUnrealizedVat(VATLedgerLine."Document Type") then begin
                  TotalBaseAmount[IndSBase::"02-12"]+=-SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);
                  TotalVATAmount[IndSVAT::"02-22"]+=-SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0);
                  TotalBaseAmount[IndSBase::"02-10"]+=-SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);
                  TotalVATAmount[IndSVAT::"02-20"]+=-SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0);
                end;
                //NAVBG11.0; 001; end
              end;

            '01':
              if VATPostingSetup."Transaction Type" in [VATPostingSetup."Transaction Type"::Sales,
              VATPostingSetup."Transaction Type"::Both] then   begin
               VATAmount[IndSVAT::"02-23"]+= -SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0) ;
               BaseAmount[IndSBase::"02-10"]+=-SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);
               VATAmount[IndSVAT::"02-20"]+=-SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0);
               //NAVBG11.0; 001; begin
               if not CodeInUnrealizedVat(VATLedgerLine."Document Type") then begin
                  TotalVATAmount[IndSVAT::"02-23"]+= -SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0) ;
                  TotalBaseAmount[IndSBase::"02-10"]+=-SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);
                  TotalVATAmount[IndSVAT::"02-20"]+=-SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0);
               end;
               //NAVBG11.0; 001; end
              end;

            '07':
              if VATPostingSetup."Transaction Type" = VATPostingSetup."Transaction Type"::Sales then begin
               BaseAmount[IndSBase::"02-13"]+=-SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);
               VATAmount[IndSVAT::"02-24"]+=-SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0)  ;
               BaseAmount[IndSBase::"02-10"]+=-SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);
               VATAmount[IndSVAT::"02-20"]+=-SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0);
               //NAVBG11.0; 001; begin
               if not CodeInUnrealizedVat(VATLedgerLine."Document Type") then begin
                  TotalBaseAmount[IndSBase::"02-13"]+=-SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);
                  TotalVATAmount[IndSVAT::"02-24"]+=-SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0)  ;
                  TotalBaseAmount[IndSBase::"02-10"]+=-SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);
                  TotalVATAmount[IndSVAT::"02-20"]+=-SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0);
               end;
               //NAVBG11.0; 001; end
              end;

            '03':
              if VATPostingSetup."Transaction Type" = VATPostingSetup."Transaction Type"::Sales then  begin
               BaseAmount[IndSBase::"02-14"]+=-SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);
               BaseAmount[IndSBase::"02-10"]+=-SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);
               //NAVBG11.0; 001; begin
               if not CodeInUnrealizedVat(VATLedgerLine."Document Type") then begin
                  TotalBaseAmount[IndSBase::"02-14"]+=-SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);
                  TotalBaseAmount[IndSBase::"02-10"]+=-SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);
               end;
               //NAVBG11.0; 001; end

               //NAVBG11.0; 001; delete single
               //VATAmount[IndSVAT::"02-20"]+=-SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0);

              end;

            '13':
              if VATPostingSetup."Transaction Type" = VATPostingSetup."Transaction Type"::Sales then  begin
               BaseAmount[IndSBase::"02-15"]+=-SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);
               BaseAmount[IndSBase::"02-10"]+=-SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);
               //NAVBG11.0; 001; begin
               if not CodeInUnrealizedVat(VATLedgerLine."Document Type") then begin
                  TotalBaseAmount[IndSBase::"02-15"]+=-SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);
                  TotalBaseAmount[IndSBase::"02-10"]+=-SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);
               end;
               //NAVBG11.0; 001; end

               //NAVBG11.0; 001; delete single
               //VATAmount[IndSVAT::"02-20"]+=-SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0);
              end;

            '04':
              if VATPostingSetup."Transaction Type" in [VATPostingSetup."Transaction Type"::Sales,
              VATPostingSetup."Transaction Type"::Both] then    begin
               BaseAmount[IndSBase::"02-16"]+=-SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);
               BaseAmount[IndSBase::"02-10"]+=-SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);
               //NAVBG11.0; 001; begin
               if not CodeInUnrealizedVat(VATLedgerLine."Document Type") then begin
                  TotalBaseAmount[IndSBase::"02-16"]+=-SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);
                  TotalBaseAmount[IndSBase::"02-10"]+=-SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);
               end;
               //NAVBG11.0; 001;

               //NAVBG11.0; 001; delete single
               //VATAmount[IndSVAT::"02-20"]+=-SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0);
               end;
            '05':
              if VATPostingSetup."Transaction Type" in [VATPostingSetup."Transaction Type"::Sales,
              VATPostingSetup."Transaction Type"::Both] then     begin
               BaseAmount[IndSBase::"02-17"]+=-SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);
               //NAVBG11.0; 001; begin
               if not CodeInUnrealizedVat(VATLedgerLine."Document Type") then
                  TotalBaseAmount[IndSBase::"02-17"]+=-SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);
               //NAVBG11.0; 001; end

               //NAVBG11.0; 001; delete begin
               //BaseAmount[IndSBase::"02-10"]:=0;
               //VATAmount[IndSVAT::"02-20"]+=-SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0);
               //NAVBG11.0; 001; delete end;
              end;

            '06':
              if VATPostingSetup."Transaction Type" in [VATPostingSetup."Transaction Type"::Sales,
              VATPostingSetup."Transaction Type"::Both] then   begin
               BaseAmount[IndSBase::"02-18"]+=-SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);
               //NAVBG11.0; 001; begin
               if not CodeInUnrealizedVat(VATLedgerLine."Document Type") then
                 TotalBaseAmount[IndSBase::"02-18"]+=-SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);
               //NAVBG11.0; 001; end

               //NAVBG11.0; 001; delete begin
               //BaseAmount[IndSBase::"02-10"]:=-0;
               //VATAmount[IndSVAT::"02-20"]+=-SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0);
               //NAVBG11.0; 001; delete end
              end;

            '09':
              if VATPostingSetup."Transaction Type" in [VATPostingSetup."Transaction Type"::Sales,
              VATPostingSetup."Transaction Type"::Both] then   begin
               BaseAmount[IndSBase::"02-18"]+=-SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);
               //NAVBG11.0; 001; begin
               if not CodeInUnrealizedVat(VATLedgerLine."Document Type") then
                  TotalBaseAmount[IndSBase::"02-18"]+=-SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);
               //NAVBG11.0; 001; end

               //NAVBG11.0; 001; delete begin
               //BaseAmount[IndSBase::"02-10"]+=-SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);
               //VATAmount[IndSVAT::"02-20"]+=-SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0);
               //NAVBG11.0; 001; delete end
              end;

            '10':    begin
               BaseAmount[IndSBase::"02-19"]+=-SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);
               //NAVBG11.0; 001; begin
               if not CodeInUnrealizedVat(VATLedgerLine."Document Type") then
                  TotalBaseAmount[IndSBase::"02-19"]+=-SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);
               //NAVBG11.0; 001; end

               //NAVBG11.0; 001; delete begin
               //BaseAmount[IndSBase::"02-10"]:=0;
               //VATAmount[IndSVAT::"02-20"]+=-SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0);
               //NAVBG11.0; 001; delete end
              end;

            '12':
              if VATPostingSetup."Transaction Type" in [VATPostingSetup."Transaction Type"::Sales,
               VATPostingSetup."Transaction Type"::Both] then   begin
               BaseAmount[IndSBase::"02-25"]+=-SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);
               //NAVBG11.0; 001; begin
               if not CodeInUnrealizedVat(VATLedgerLine."Document Type") then
                  BaseAmount[IndSBase::"02-25"]+=-SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);
               //NAVBG11.0; 001; end
              end;

            '02': begin
              if (VATPostingSetup."Transaction Type" in [VATPostingSetup."Transaction Type"::Purchases,
              VATPostingSetup."Transaction Type"::Both]) then begin
               BaseAmount[IndSBase::"02-26"]+=-SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);
               VATAmount[IndSVAT::"02-22"]+=-SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0) ;
               BaseAmount[IndSBase::"02-10"]+=-SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);
               VATAmount[IndSVAT::"02-20"]+=-SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0);
               //NAVBG11.0; 001; begin
               if not CodeInUnrealizedVat(VATLedgerLine."Document Type") then begin
                  TotalBaseAmount[IndSBase::"02-26"]+=-SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);
                  TotalVATAmount[IndSVAT::"02-22"]+=-SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0) ;
                  TotalBaseAmount[IndSBase::"02-10"]+=-SetSign(VATEntry.Base,VATLedgerLine."Document Type",0);
                  TotalVATAmount[IndSVAT::"02-20"]+=-SetSign(VATEntry.Amount,VATLedgerLine."Document Type",0);
               end;
               //NAVBG11.0; 001; end
              end;
            end;
          end;
        end;

        until VATEntry.NEXT = 0;

        //NAVBG11.0; 001; delete begin
        //// Total base amounts
        //FOR i := 1 TO 12 DO
        //  TotalBaseAmount[i] := TotalBaseAmount[i] + BaseAmount[i];

        //// Total VAT amounts
        //FOR i := 1 TO 5 DO
        //  TotalVATAmount[i] := TotalVATAmount[i] + VATAmount[i];
        //NAVBG11.0; 001; delete end
    end;

    procedure FillPurchAmounts(VATLedgerLine : Record "VAT Ledger Line";var BaseAmount : array [4] of Decimal;var TotalBaseAmount : array [4] of Decimal;var VATAmount : array [2] of Decimal;var TotalVATAmount : array [2] of Decimal);
    var
        VATPostingSetup : Record "VAT Posting Setup";
        i : Integer;
    begin
        VATLedger2.GET(VATLedgerLine.Type, VATLedgerLine."Period Start Date");
        VATEntry.RESET;
        VATEntry.SETRANGE(Type, VATEntry.Type::Purchase);
        VATEntry.SETRANGE("Document Date", VATLedgerLine."Issue Date");

        if VATLedgerLine."Document Type" <> '07' then
            VATEntry.SETRANGE(VATEntry."Document No.",VATLedgerLine."Original Document No.")
        else
            VATEntry.SETRANGE(VATEntry."SAD No.",VATLedgerLine."Original Document No.")    ;
        case VATLedgerLine."Document Type" of
           '01':  VATEntry.SETRANGE("Document Type",VATEntry."Document Type"::Invoice );
           '02':  VATEntry.SETRANGE(VATEntry."Debit Memo",true);
           '03':  VATEntry.SETRANGE("Document Type",VATEntry."Document Type"::"Credit Memo" );
           '07':  VATEntry.SETRANGE("Document Type",VATEntry."Document Type"::" " );
           '09':  VATEntry.SETRANGE("Document Type",VATEntry."Document Type"::" " );
           '81':  VATEntry.SETRANGE(VATEntry."Sales Protocol",true );
        end;

        VATEntry.SETRANGE(VATEntry."Do not include in VAT Ledgers", false);

        if VATEntry.FIND('-') then repeat

          //NAVBG8.00; 001; begin
            if VATEntry."Unrealized VAT" then begin
              VATEntry.Base := VATEntry."Unrealized Base";
              VATEntry.Amount := VATEntry."Unrealized Amount";
            end;
          //NAVBG8.00; 001; end

          if ((VATEntry."Posting Date" >= VATLedger2."Period Start Date") and (VATEntry."Posting Date" <= VATLedger2."Period End Date")
          and (VATEntry.Void=false))
          or
          ((VATEntry."Posting Date" >= VATLedger2."Period Start Date") and (VATEntry."Posting Date" <= VATLedger2."Period End Date")
          and ((VATEntry."Void Date"<VATLedger2."Period Start Date") or (VATEntry."Void Date">VATLedger2."Period End Date")))

          then begin
              if VATPostingSetup.GET(VATEntry."VAT Bus. Posting Group",VATEntry."VAT Prod. Posting Group") then begin
                  //NAVBG11.0; 001; delete single
                  //IF VATPostingSetup."VAT Classification Code"<>'12' THEN BEGIN
                  //NAVBG11.0.002, single
                  if VATPostingSetup."VAT Classification Code"<>'15' then begin
                  //NAVBG11.0; 001; single
                  if VATPostingSetup."VAT Classification Code"<>'14' then begin
                    case  VATPostingSetup."Purchase VAT Refund Type" of

                       VATPostingSetup."Purchase VAT Refund Type"::"Full Refund"  : begin
                         if VATLedgerLine."Document Type" <> '07' then begin
                            //NAVBG8.00; 001; single
                            //NAVBG11.0; 001; delete single
                            //IF NOT CodeInUnrealizedVatPurchase( VATLedgerLine."Document Type" ) THEN BEGIN
                               BaseAmount[IndPBase::"03-31"] += VATEntry.Base;     //BaseAmount[2], TotalBaseAmount[2]
                               VATAmount[IndPVAT::"03-41"] += VATEntry.Amount;       //VatAmount[1], TotalVatAmount[1]
                            //NAVBG11.0; 001; begin
                                if not CodeInUnrealizedVatPurchase( VATLedgerLine."Document Type" ) then begin
                                   TotalBaseAmount[IndPBase::"03-31"] += VATEntry.Base;
                                   TotalVATAmount[IndPVAT::"03-41"] += VATEntry.Amount;

                            //NAVBG11.0; 001; end
                            //NAVBG8.00; 001; single
                                end;
                         end
                         else  begin
                         //NAVBG8.00; 001; single
                         //NAVBG11.0; 001; delete single
                         //   IF NOT CodeInUnrealizedVatPurchase( VATLedgerLine."Document Type" ) THEN BEGIN
                              BaseAmount[IndPBase::"03-31"] += VATLedgerLine.Base;   //BaseAmount[2], TotalBaseAmount[2]
                              VATAmount[IndPVAT::"03-41"] += VATLedgerLine.Amount;    //VatAmount[1], TotalVatAmount[1]
                         //NAVBG11.0; 001; begin
                              if not CodeInUnrealizedVatPurchase( VATLedgerLine."Document Type" ) then begin
                                TotalBaseAmount[IndPBase::"03-31"] += VATLedgerLine.Base;
                                TotalVATAmount[IndPVAT::"03-41"] += VATLedgerLine.Amount;

                         //NAVBG11.0; 001; end
                            //NAVBG8.00; 001; single
                               end;
                         end;
                       end;

                       //NAVBG11.0; 001; delete begin
                       //VATPostingSetup."Purchase VAT Refund Type"::"Partial Refund"  : BEGIN
                       //   IF VATLedgerLine."Document Type" <> '07' THEN
                       //     //NAVBG8.00; 001; single
                       //     IF NOT CodeInUnrealizedVatPurchase( VATLedgerLine."Document Type" ) THEN
                       //       BaseAmount[IndPBase::"03-32"] +=VATEntry.Base          //BaseAmount[3], TotalBaseAmount[3]
                       //     ELSE
                       //       //NAVBG8.00; 001; single
                       //       IF NOT CodeInUnrealizedVatPurchase( VATLedgerLine."Document Type" ) THEN
                       //         BaseAmount[IndPBase::"03-32"] +=VATLedgerLine.Base;      //BaseAmount[3], TotalBaseAmount[3]
                       //       //NAVBG8.00; 001; single
                       //    IF NOT CodeInUnrealizedVatPurchase( VATLedgerLine."Document Type" ) THEN
                       //      VATAmount[IndPVAT::"03-42"]+=VATEntry.Amount;            //VatAmount[2], TotalVatAmount[2]
                       //END;
                       //NAVBG11.0; 001; delete end
                       //NAVBG11.0; 001; begin

                       VATPostingSetup."Purchase VAT Refund Type"::"Partial Refund"  : begin
                          if VATLedgerLine."Document Type" <> '07' then begin
                          //NAVBG11.0; 001; delete single
                          //  IF NOT CodeInUnrealizedVatPurchase( VATLedgerLine."Document Type" ) THEN
                              BaseAmount[IndPBase::"03-32"] += VATEntry.Base;          //BaseAmount[3], TotalBaseAmount[3]
                          //NAVBG11.0; 001; begin
                              if not CodeInUnrealizedVatPurchase( VATLedgerLine."Document Type" ) then
                                TotalBaseAmount[IndPBase::"03-32"] += VATEntry.Base;
                          //NAVBG11.0; 001; end
                          end  else begin
                          //NAVBG11.0; 001; delete single
                          //    IF NOT CodeInUnrealizedVatPurchase( VATLedgerLine."Document Type" ) THEN
                                BaseAmount[IndPBase::"03-32"] += VATLedgerLine.Base;   //BaseAmount[3], TotalBaseAmount[3]
                          //NAVBG11.0; 001; begin
                                if not CodeInUnrealizedVatPurchase( VATLedgerLine."Document Type" ) then
                                  TotalBaseAmount[IndPBase::"03-32"] += VATLedgerLine.Base;
                          //NAVBG11.0; 001; end
                          end;
                          //NAVBG11.0; 001; delete single
                          //IF NOT CodeInUnrealizedVatPurchase( VATLedgerLine."Document Type" ) THEN
                             VATAmount[IndPVAT::"03-42"] += VATEntry.Amount;            //VatAmount[2], TotalVatAmount[2]
                          //NAVBG11.0; 001; begin
                             if not CodeInUnrealizedVatPurchase( VATLedgerLine."Document Type" ) then
                               TotalVATAmount[IndPVAT::"03-42"] += VATEntry.Amount;
                          //NAVBG11.0; 001; end
                       end;
                       //NAVE18.00.007 end

                       VATPostingSetup."Purchase VAT Refund Type"::"No Refund"  :  begin
                          if VATLedgerLine."Document Type" <> '07' then    begin
                              BaseAmount[IndPBase::"03-30"] += VATEntry.Base;        //BaseAmount[1], TotalBaseAmount[1]
                              //NAVBG11.0; 001; begin
                               if not CodeInUnrealizedVatPurchase( VATLedgerLine."Document Type" ) then
                                 TotalBaseAmount[IndPBase::"03-30"] += VATEntry.Base;
                              //NAVBG11.0; 001; end
                           end
                           else begin
                              BaseAmount[IndPBase::"03-30"] += VATLedgerLine.Base;   //BaseAmount[1], TotalBaseAmount[1]
                              //NAVBG11.0; 001;  begin
                              if not CodeInUnrealizedVatPurchase( VATLedgerLine."Document Type" ) then
                                 TotalBaseAmount[IndPBase::"03-30"] += VATLedgerLine.Base;
                              //NAVBG11.0; 001; end
                           end;
                       end;
                    end;
                  end
                  else begin
                       BaseAmount[IndPBase::"03-44"] += VATEntry.Base; //IF VAT CLASSIFICATOR IS '14'
                       //NAVBG11.0; 001; begin
                       if not CodeInUnrealizedVatPurchase( VATLedgerLine."Document Type" ) then
                          TotalBaseAmount[IndPBase::"03-44"] += VATEntry.Base;
                       //NAVBG11.0; 001; end
                  end;
                  //NAVBG11.0.002; single
                  end;
              end;
          end;
        if (VATEntry.Void=true) and
          ((VATEntry."Posting Date" < VATLedger2."Period Start Date") or (VATEntry."Posting Date" > VATLedger2."Period End Date"))

          then begin

          if VATPostingSetup.GET(VATEntry."VAT Bus. Posting Group",VATEntry."VAT Prod. Posting Group") then begin
            //NAVBG11.0; 001; delete single
            //IF VATPostingSetup."VAT Classification Code"<>'12' THEN BEGIN
            //NAVBG11.0; 001; single
            if VATPostingSetup."VAT Classification Code"<>'14' then begin
              case  VATPostingSetup."Purchase VAT Refund Type" of

                  VATPostingSetup."Purchase VAT Refund Type"::"Full Refund"  : begin
                     if VATLedgerLine."Document Type" <> '07' then begin
                       //NAVBG8.00; 001; single
                       //NAVBG11.0; 001; delete single
                       //IF NOT CodeInUnrealizedVatPurchase( VATLedgerLine."Document Type" ) THEN
                         BaseAmount[IndPBase::"03-31"] += -VATEntry.Base;    //BaseAmount[2], TotalBaseAmount[2]
                       //NAVBG8.00; 001; single
                       //NAVBG11.0; 001; delete single
                       //IF NOT CodeInUnrealizedVatPurchase( VATLedgerLine."Document Type" ) THEN
                         VATAmount[IndPVAT::"03-41"] += -VATEntry.Amount;
                       //NAVBG11.0; 001; begin
                       if not CodeInUnrealizedVatPurchase( VATLedgerLine."Document Type" ) then begin
                        TotalBaseAmount[IndPBase::"03-31"] += -VATEntry.Base;
                        TotalVATAmount[IndPVAT::"03-41"] += -VATEntry.Amount;
                       end;
                       //NAVBG11.0; 001; end
                     end
                     else begin
                       //NAVBG8.00; 001; single
                       //NAVBG11.0; 001; delete begin
                       //IF NOT CodeInUnrealizedVatPurchase( VATLedgerLine."Document Type" ) THEN
                       //  BaseAmount[IndPBase::"03-31"]:=-VATLedgerLine.Base;   //BaseAmount[2], TotalBaseAmount[2]
                       //NAVBG8.00; 001; single
                       //IF NOT CodeInUnrealizedVatPurchase( VATLedgerLine."Document Type" ) THEN
                       //  VATAmount[IndPVAT::"03-41"]:=-VATLedgerLine.Amount;
                       //NAVBG11.0; 001; delete end

                       //NAVBG11.0; 001; begin
                       BaseAmount[IndPBase::"03-31"] += -VATLedgerLine.Base;
                       VATAmount[IndPVAT::"03-41"] += -VATLedgerLine.Amount;
                       if not CodeInUnrealizedVatPurchase( VATLedgerLine."Document Type" ) then begin
                        TotalBaseAmount[IndPBase::"03-31"] += -VATLedgerLine.Base;
                        TotalVATAmount[IndPVAT::"03-41"] += -VATLedgerLine.Amount;
                       end;
                       //NAVBG11.0; 001; end
                     end;
                  end;
                  //NAVBG11.0; 001; delete begin
                  //VATPostingSetup."Purchase VAT Refund Type"::"Partial Refund"  : BEGIN
                  //   IF VATLedgerLine."Document Type" <> '07' THEN
                  //     //NAVBG8.00; 001; single
                  //     IF NOT CodeInUnrealizedVatPurchase( VATLedgerLine."Document Type" ) THEN
                  //       BaseAmount[IndPBase::"03-32"]+=-VATEntry.Base
                  //   ELSE
                  //     //NAVBG8.00; 001; single
                  //     IF NOT CodeInUnrealizedVatPurchase( VATLedgerLine."Document Type" ) THEN
                  //       BaseAmount[IndPBase::"03-32"]+=-VATLedgerLine.Base;
                  //     //NAVBG8.00; 001; single
                  //   IF NOT CodeInUnrealizedVatPurchase( VATLedgerLine."Document Type" ) THEN
                  //     VATAmount[IndPVAT::"03-42"]+=-VATEntry.Amount;
                  //END;
                  //NAVBG11.0; 001; delete end

                  //NAVBG11.0; 001; begin
                  VATPostingSetup."Purchase VAT Refund Type"::"Partial Refund"  : begin
                     if VATLedgerLine."Document Type" <> '07' then begin
                     //NAVBG11.0; 001; delete single
                     //  IF NOT CodeInUnrealizedVatPurchase( VATLedgerLine."Document Type" ) THEN
                         BaseAmount[IndPBase::"03-32"] += -VATEntry.Base;
                     //NAVBG11.0; 001; begin
                         if not CodeInUnrealizedVatPurchase( VATLedgerLine."Document Type" ) then
                          TotalBaseAmount[IndPBase::"03-32"] += -VATEntry.Base;
                     //NAVBG11.0; 001; end
                     end else begin
                     //NAVBG11.0; 001; delete single
                     //  IF NOT CodeInUnrealizedVatPurchase( VATLedgerLine."Document Type" ) THEN
                         BaseAmount[IndPBase::"03-32"] += -VATLedgerLine.Base;
                     //NAVBG11.0; 001; begin
                         if not CodeInUnrealizedVatPurchase( VATLedgerLine."Document Type" ) then
                          TotalBaseAmount[IndPBase::"03-32"] += -VATLedgerLine.Base;
                     //NAVBG11.0; 001; end
                     end;
                     //NAVBG11.0; 001; delete single
                     //IF NOT CodeInUnrealizedVatPurchase( VATLedgerLine."Document Type" ) THEN
                       VATAmount[IndPVAT::"03-42"] += -VATEntry.Amount;
                     //NAVBG11.0; 001; begin
                       if not CodeInUnrealizedVatPurchase( VATLedgerLine."Document Type" ) then
                        TotalVATAmount[IndPVAT::"03-42"] += -VATEntry.Amount;
                     //NAVBG11.0; 001; end
                  end;
                  //NAVBG11.0; 001; end

                  VATPostingSetup."Purchase VAT Refund Type"::"No Refund"  :  begin
                     if VATLedgerLine."Document Type" <> '07' then    begin
                       //NAVBG8.00; 001; single
                       //NAVBG11.0; 001; dlete single
                       //IF NOT CodeInUnrealizedVatPurchase( VATLedgerLine."Document Type" ) THEN
                         BaseAmount[IndPBase::"03-30"] += -VATEntry.Base;       //BaseAmount[1], TotalBaseAmount[1]
                       //NAVBG11.0; 001; begin
                         if not CodeInUnrealizedVatPurchase( VATLedgerLine."Document Type" ) then
                           TotalBaseAmount[IndPBase::"03-30"] += -VATEntry.Base;
                       //NAVBG11.0; 001; end
                     end
                     else begin
                       //NAVBG8.00; 001; single
                       //NAVBG11.0; 001; delete single
                       //IF NOT CodeInUnrealizedVatPurchase( VATLedgerLine."Document Type" ) THEN
                        BaseAmount[IndPBase::"03-30"] += -VATLedgerLine.Base;  //BaseAmount[1], TotalBaseAmount[1]
                       //NAVBG11.0; 001; begin
                        if not CodeInUnrealizedVatPurchase( VATLedgerLine."Document Type" ) then
                           TotalBaseAmount[IndPBase::"03-30"] += -VATLedgerLine.Base;
                       //NAVBG11.0; 001; end
                     end;
                   end;
              end;
            end
            else begin
              //NAVBG8.00; 001; single
              //NAVBG11.0; 001; delete single
              //IF NOT CodeInUnrealizedVatPurchase( VATLedgerLine."Document Type" ) THEN
                 BaseAmount[IndPBase::"03-44"] += -VATEntry.Base; //IF VAT CLASSIFICATOR IS '14'
              //NAVBG11.0; 001; begin
                 if not CodeInUnrealizedVatPurchase( VATLedgerLine."Document Type" ) then
                   TotalBaseAmount[IndPBase::"03-44"] += -VATEntry.Base;
              //NAVBG11.0; 001; end
            end;
           end;
          end;
        until VATEntry.NEXT = 0;
        //NAVBG11.0; 001; delete begin
        //FOR i := 1 TO 4 DO
        //  TotalBaseAmount[i] := TotalBaseAmount[i] + ROUND(BaseAmount[i], 0.01);

        //// Total VAT amounts
        //FOR i := 1 TO 2 DO
        //  TotalVATAmount[i] := TotalVATAmount[i] + ROUND(VATAmount[i], 0.01);
        //NAVBG11.0; 001; delete end
    end;

    procedure FillDeclaration(VATDeclaration : Record "VAT Declaration";var DeclAmount : array [30] of Decimal;var SalesVATLedgerLinesQty : Integer;var PurchVATLedgerLinesQty : Integer);
    var
        SalesVATLedgerLine : Record "VAT Ledger Line";
        PurchVATLedgerLine : Record "VAT Ledger Line";
        PurchVATLedger : Record "VAT Ledger Line";
        PurchBaseAmount : array [4] of Decimal;
        PurchTotalBaseAmount : array [4] of Decimal;
        PurchVATAmount : array [2] of Decimal;
        PurchTotalVATAmount : array [2] of Decimal;
        PurchAnnCorrTotalAmount : Decimal;
        SalesBaseAmount : array [12] of Decimal;
        SalesTotalBaseAmount : array [12] of Decimal;
        SalesVATAmount : array [5] of Decimal;
        SalesTotalVATAmount : array [5] of Decimal;
        VATAmount : Decimal;
        TotalSalesBase : Decimal;
        TotalSalesVat : Decimal;
    begin
        SalesVATLedgerLine.SETRANGE(Type,SalesVATLedgerLine.Type::Sales);
        SalesVATLedgerLine.SETRANGE("Period Start Date",VATDeclaration."Period Start Date");
        if SalesVATLedgerLine.FINDSET then
          repeat
            CLEAR(SalesBaseAmount);
            CLEAR(SalesVATAmount);
            FillSalesAmounts(SalesVATLedgerLine,SalesBaseAmount,SalesTotalBaseAmount,SalesVATAmount,SalesTotalVATAmount);
            SalesVATLedgerLine.CALCSUMS(SalesVATLedgerLine.Base,SalesVATLedgerLine.Amount);
            TotalSalesBase:= SalesVATLedgerLine.Base;
            TotalSalesVat:=  SalesVATLedgerLine.Amount;
          until SalesVATLedgerLine.NEXT = 0;

        PurchVATLedgerLine.SETRANGE(Type,PurchVATLedgerLine.Type::Purchase);
        PurchVATLedgerLine.SETRANGE("Period Start Date",VATDeclaration."Period Start Date");
        if PurchVATLedgerLine.FINDSET then
          repeat
            CLEAR(PurchBaseAmount);
            CLEAR(PurchVATAmount);
            FillPurchAmounts(PurchVATLedgerLine,PurchBaseAmount,PurchTotalBaseAmount,PurchVATAmount,PurchTotalVATAmount);
            PurchAnnCorrTotalAmount := PurchAnnCorrTotalAmount + PurchVATLedgerLine."Purch. Annual Corr. Amount";
          until PurchVATLedgerLine.NEXT = 0;

        SalesVATLedgerLinesQty := SalesVATLedgerLine.COUNT;
        PurchVATLedgerLinesQty := PurchVATLedgerLine.COUNT;

        DeclAmount[IndD::"01-01"] := SalesTotalBaseAmount[12];
        DeclAmount[IndD::"01-11"] := SalesTotalBaseAmount[1];
        DeclAmount[IndD::"01-12"] := SalesTotalBaseAmount[2] + SalesTotalBaseAmount[11];
        DeclAmount[IndD::"01-13"] := SalesTotalBaseAmount[3];
        DeclAmount[IndD::"01-14"] := SalesTotalBaseAmount[4];
        DeclAmount[IndD::"01-15"] := SalesTotalBaseAmount[5];
        DeclAmount[IndD::"01-16"] := SalesTotalBaseAmount[6];
        DeclAmount[IndD::"01-17"] := SalesTotalBaseAmount[7];
        DeclAmount[IndD::"01-18"] := SalesTotalBaseAmount[8]+SalesTotalBaseAmount[10];
        DeclAmount[IndD::"01-19"] := SalesTotalBaseAmount[9];
        DeclAmount[IndD::"01-20"] := SalesTotalVATAmount[5];
        DeclAmount[IndD::"01-21"] := SalesTotalVATAmount[1];
        DeclAmount[IndD::"01-22"] := SalesTotalVATAmount[2];
        DeclAmount[IndD::"01-23"] := SalesTotalVATAmount[3];
        DeclAmount[IndD::"01-24"] := SalesTotalVATAmount[4];
        //NAVBG11.0.001 delete single
        //DeclAmount[IndD::"01-30"] := PurchTotalBaseAmount[1];
        //NAVBG11.0.001 single
        DeclAmount[IndD::"01-30"] := PurchTotalBaseAmount[1] + PurchTotalBaseAmount[4];
        DeclAmount[IndD::"01-31"] := PurchTotalBaseAmount[2];
        DeclAmount[IndD::"01-32"] := PurchTotalBaseAmount[3];
        DeclAmount[IndD::"01-33"] := VATDeclaration."Coefficient Art.73, p.5";
        DeclAmount[IndD::"01-41"] := PurchTotalVATAmount[1];
        DeclAmount[IndD::"01-42"] := PurchTotalVATAmount[2];
        DeclAmount[IndD::"01-43"] := VATDeclaration."Annual VAT Correction";



        DeclAmount[IndD::"01-40"] := DeclAmount[IndD::"01-41"] +
          DeclAmount[IndD::"01-42"] * DeclAmount[IndD::"01-33"] + DeclAmount[IndD::"01-43"];

        VATAmount := DeclAmount[IndD::"01-20"] - DeclAmount[IndD::"01-40"];
        if VATAmount > 0 then
          DeclAmount[IndD::"01-50"] := VATAmount
        else
          DeclAmount[IndD::"01-60"] := - VATAmount;

        DeclAmount[IndD::"01-70"] := VATDeclaration."VAT Deducted Art.92,p.1";
        DeclAmount[IndD::"01-71"] := VATDeclaration."VAT Effectively Paid";
        DeclAmount[IndD::"01-80"] := VATDeclaration."VAT refund.45 days-Art.91,p.2";
        DeclAmount[IndD::"01-81"] := VATDeclaration."VAT refund.30 days-Art.91,p.3";
        DeclAmount[IndD::"01-82"] := VATDeclaration."VAT refund.30 days-Art.91,p.4";
    end;

    procedure FillSalesIndexes(var VATLedgerLine : Record "VAT Ledger Line");
    var
        i : Integer;
    begin
        VATPostingSetup.GET(VATLedgerLine."VAT Bus. Posting Group",
          VATLedgerLine."VAT Prod. Posting Group");

        with VATPostingSetup do begin
          case "VAT Classification Code" of
            //"02-11" Данъчна основа на облагаемите доставки със ставка 20 %, вкл. доставките при условията на дистанционни продажби, с място на изпълнение на територията на страната
            //"02-21" ДО на ВОП
            '':
              if "Transaction Type" = "Transaction Type"::Sales then begin
                VATLedgerLine."Sales Base Index" := VATLedgerLine."Sales Base Index"::"02-11";
                VATLedgerLine."Sales Amount Index" := VATLedgerLine."Sales Amount Index"::"02-21";
              end;

            //"02-12" ДО на ВОП
            //"02-22" Начислен ДДС за ВОП и за получени доставки по чл. 82, ал. 2 - 5 ЗДДС
            '08':
              if "Transaction Type" in ["Transaction Type"::Purchases,"Transaction Type"::Both] then begin
                VATLedgerLine."Sales Base Index" := VATLedgerLine."Sales Base Index"::"02-12";
                VATLedgerLine."Sales Amount Index" := VATLedgerLine."Sales Amount Index"::"02-22";
              end;

            //Начислен данък за доставки на стоки и услуги за лични нужди
            '01':
              if "Transaction Type" in ["Transaction Type"::Sales,"Transaction Type"::Both] then
                VATLedgerLine."Sales Amount Index" := VATLedgerLine."Sales Amount Index"::"02-23";

            //"02-13" ДО на облагаемите доставки със ставка 9 %
            //"02-24" Начислен ДДС 9 %
            '07':
              if "Transaction Type" = "Transaction Type"::Sales then begin
                VATLedgerLine."Sales Base Index" := VATLedgerLine."Sales Base Index"::"02-13";
                VATLedgerLine."Sales Amount Index" := VATLedgerLine."Sales Amount Index"::"02-24";
              end;

             //"02-14" ДО на доставките със ставка 0 % по глава трета от ЗДДС
            '03':
              if "Transaction Type" = "Transaction Type"::Sales then
                VATLedgerLine."Sales Base Index" := VATLedgerLine."Sales Base Index"::"02-14";

             //"02-15" ДО на доставките със ставка 0 % на ВОД на стоки
            '13':
              if "Transaction Type" = "Transaction Type"::Sales then
                VATLedgerLine."Sales Base Index" := VATLedgerLine."Sales Base Index"::"02-15";

             //"02-16" ДО на доставките със ставка 0 % по чл. 140, чл. 146, ал. 1 и чл. 173 ЗДДС
            '04':
              if "Transaction Type" in ["Transaction Type"::Sales,"Transaction Type"::Both] then
                VATLedgerLine."Sales Base Index" := VATLedgerLine."Sales Base Index"::"02-16";

             //"02-17" Данъчна основа на доставки на услуги по чл. 21, ал. 2 ЗДДС, с място на изпълнение на територията на друга държава членка
            '05':
              if "Transaction Type" in ["Transaction Type"::Sales,"Transaction Type"::Both] then
                VATLedgerLine."Sales Base Index" := VATLedgerLine."Sales Base Index"::"02-17";

            //"02-18" Данъчна основа на доставки по чл. 69, ал. 2 ЗДДС, вкл. данъчна основа на доставките при условията на дистанционни продажби, с място на изпълнение на територията на друга държава членка
            '06','09':
              if "Transaction Type" in ["Transaction Type"::Sales,"Transaction Type"::Both] then
                VATLedgerLine."Sales Base Index" := VATLedgerLine."Sales Base Index"::"02-18";

            //"02-19" ДО на освободени доставки и освободените ВОП
            '10':
                VATLedgerLine."Sales Base Index" := VATLedgerLine."Sales Base Index"::"02-19";

            //"02-25" ДО на доставки като посредник в тристранни операции
            '12':
              if "Transaction Type" in ["Transaction Type"::Sales,"Transaction Type"::Both] then
                VATLedgerLine."Sales Base Index" := VATLedgerLine."Sales Base Index"::"02-25";

            //"02-26" ДО по получените доставки по чл. 82, ал. 2 - 5 ЗДДС
            //"02-22" Начислен ДДС за ВОП и за получени доставки по чл. 82, ал. 2 - 5 ЗДДС
            '02': begin
              if ("Transaction Type" in ["Transaction Type"::Purchases,"Transaction Type"::Both]) then begin
                VATLedgerLine."Sales Base Index" := VATLedgerLine."Sales Base Index"::"02-26";
                VATLedgerLine."Sales Amount Index" := VATLedgerLine."Sales Amount Index"::"02-22";
              end;
            end;
          end;
        end;
    end;

    procedure FillPurchIndexes(var VATLedgerLine : Record "VAT Ledger Line");
    var
        i : Integer;
    begin
        with VATPostingSetup do begin
          if "Transaction Type" in ["Transaction Type"::Purchases,"Transaction Type"::Both] then
            case "Purchase VAT Refund Type" of
              "Purchase VAT Refund Type"::"Full Refund": begin
                if ("VAT Classification Code" in ['','02','06','08','11']) then begin
                  VATLedgerLine."Purch. Base Index" := VATLedgerLine."Purch. Base Index"::"03-31";
                  VATLedgerLine."Purch. Amount Index" := VATLedgerLine."Purch. Amount Index"::"03-41";
                end;
              end;

              "Purchase VAT Refund Type"::"Partial Refund": begin
                if ("VAT Classification Code" in ['','02','06','08','11']) then begin
                  VATLedgerLine."Purch. Base Index" := VATLedgerLine."Purch. Base Index"::"03-32";
                  VATLedgerLine."Purch. Amount Index" := VATLedgerLine."Purch. Amount Index"::"03-42";
                end;
              end;

              "Purchase VAT Refund Type"::"No Refund": begin
                if ("VAT Classification Code" in ['','02','08','11']) then
                  VATLedgerLine."Purch. Base Index" := VATLedgerLine."Purch. Base Index"::"03-30";

                //NAVBG11.0; 001; delete single
                //IF "VAT Classification Code" = '12' THEN
                //NAVBG11.0; 001; single
                if "VAT Classification Code" = '14' then
                  if "Transaction Type" = "Transaction Type"::Purchases then
                    VATLedgerLine."Purch. Base Index" := VATLedgerLine."Purch. Base Index"::"03-44";
              end;
            end;
        end;
    end;

    procedure CalcCustIntraCommSales(var Buffer : Record "Sales Buffer";FromDate : Date;ToDate : Date);
    var
        VATPostingSetup : Record "VAT Posting Setup";
        VATEntry : Record "VAT Entry";
    begin
        with VATEntry do begin
          SETCURRENTKEY(Type,"Bill-to/Pay-to No.");
          SETRANGE(Type,Type::Sale);
          SETRANGE("Bill-to/Pay-to No.",Buffer.Code);
          SETRANGE("Posting Date",FromDate,ToDate);
          SETRANGE("VAT Protocol",false);
          if FINDSET then
            repeat
              if VATPostingSetup.GET("VAT Bus. Posting Group","VAT Prod. Posting Group") then
                if VATPostingSetup."Transaction Type" = VATPostingSetup."Transaction Type"::Sales then begin
                  case VATPostingSetup."VAT Classification Code" of
                    '13':
                      Buffer."Amount 1" -= Base;

                    '12':
                      Buffer."Amount 2" -= Base;

                    '05':
                      Buffer."Amount 3" -= Base;
                  end;
                end;
            until NEXT = 0;
        end;
    end;

    procedure FillIntraCommSalesBuffer(var CustIntraCommSalesBuffer : Record "Sales Buffer" temporary;var TaxableBaseTotalAmount : Decimal;var TaxableBaseIntraComm : Decimal;FromDate : Date;ToDate : Date);
    var
        Customer : Record Customer;
    begin
        if Customer.FINDSET then
          repeat
            CustIntraCommSalesBuffer.INIT;
            CustIntraCommSalesBuffer.Code := Customer."No.";
            CustIntraCommSalesBuffer."VAT Registration No." := Customer."VAT Registration No.";
            CalcCustIntraCommSales(CustIntraCommSalesBuffer,FromDate,ToDate);
            if not CustIntraCommSalesBuffer.IsBufferEmpty then begin
              CustIntraCommSalesBuffer.INSERT;
              TaxableBaseTotalAmount := TaxableBaseTotalAmount + CustIntraCommSalesBuffer."Amount 1"
                + CustIntraCommSalesBuffer."Amount 2" + CustIntraCommSalesBuffer."Amount 3";
              TaxableBaseIntraComm := TaxableBaseIntraComm + CustIntraCommSalesBuffer."Amount 1";
            end;
          until Customer.NEXT = 0;
    end;

    procedure WriteChars(Row : Text[1024]);
    var
        i : Integer;
        Len : Integer;
        Char : Char;
    begin
        FinishLine(Row);

        Len := STRLEN(Row);
        for i := 1 to Len do
          streamWriter.Write( Row[i] );
    end;

    procedure CodeInUnrealizedVat("Code" : Code[20]) : Boolean;
    begin

          //NAVBG8.00; 001; entire function
          exit( Code in [ '11', '12', '13' ] );
    end;

    procedure CodeInUnrealizedVatPurchase("Code" : Code[20]) : Boolean;
    begin

          //NAVBG8.00; 001; entire function
          if CalledFromLedger then exit( false );
          exit( Code in [ '11', '12', '13', '94' ] );
    end;

    procedure SetCalledFromLedger(NewCalledFromLedger : Boolean);
    begin

          //NAVBG8.00; 001; entire function
          CalledFromLedger := NewCalledFromLedger;
    end;
}

