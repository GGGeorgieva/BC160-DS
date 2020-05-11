tableextension 46015613 "Gen. Ledg. Setup Extension" extends "General Ledger Setup"
{
    // version NAVW111.00.00.28629,NAVE111.0,DS11.00

    //TODO
    //"Additional Reporting Currency" - OnValidate

    fields
    {

        //Unsupported feature: CodeModification on ""Additional Reporting Currency"(Field 68).OnValidate". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        if ("Additional Reporting Currency" <> xRec."Additional Reporting Currency") and
           ("Additional Reporting Currency" <> '')
        then begin
        #4..14
           AdjAddReportingCurr.IsExecuted
        then
          DeleteAnalysisView;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        //NAVE111.0; 001; begin
        if LocalizationUsage.UseEastLocalization and ("Additional Reporting Currency" <> xRec."Additional Reporting Currency") then begin
          if "Additional Reporting Currency" = '' then
            OK :=
              CONFIRM(
                Text005 +
                Text006 +
                Text007,false)
          else
            OK :=
              CONFIRM(
                Text008 +
                Text010 +
                Text011 +
                Text020 +
                Text013,false,AnalysisView.TABLECAPTION);
          if not OK then begin
            "Additional Reporting Currency" := xRec."Additional Reporting Currency";
            exit;
          end;
        end;
        //NAVE111.0; 001; end

        #1..17
        */
        //end;
        field(46015505; "VAT Protocol Nos."; Code[10])
        {
            Caption = 'VAT Protocol Nos.';
            Description = 'NAVBG11.0,001';
            TableRelation = "No. Series";
        }
        field(46015506; "Posted VAT Protocol Nos."; Code[10])
        {
            Caption = 'Posted VAT Protocol Nos.';
            Description = 'NAVBG11.0,001';
            TableRelation = "No. Series";
        }
        field(46015605; "Use VAT Date"; Boolean)
        {
            Caption = 'Use VAT Date';
            Description = 'NAVE111.0,001';

            trigger OnValidate();
            var
                SalesSetup: Record "Sales & Receivables Setup";
                ServiceSetup: Record "Service Mgt. Setup";
                PurchSetup: Record "Purchases & Payables Setup";
                GLEntry: Record "G/L Entry";
            begin

                case "Use VAT Date" of
                    true:
                        if CONFIRM(Text46012126, true, FIELDCAPTION("Use VAT Date"),
                             GLEntry.FIELDCAPTION("VAT Date"), GLEntry.FIELDCAPTION("Posting Date"))
                        then
                            InitVATDate
                        else
                            "Use VAT Date" := xRec."Use VAT Date";
                    false:
                        begin
                            GLEntry.RESET;
                            GLEntry.SETFILTER("VAT Date", '>%1', 0D);
                            if GLEntry.FINDFIRST then
                                ERROR(Text018, FIELDCAPTION("Use VAT Date"));
                            if CONFIRM(Text46012125, false) then begin
                                "Allow VAT Posting From" := 0D;
                                "Allow VAT Posting To" := 0D;
                                "Allow VAT Date Change in Lines" := false;
                                if PurchSetup.GET then
                                    PurchSetup."Default VAT Date" := 0;
                                if SalesSetup.GET then begin
                                    SalesSetup."Credit Memo Confirmation" := false;
                                    SalesSetup."Default VAT Date" := 0;
                                end;
                                if ServiceSetup.GET then begin
                                    ServiceSetup."Credit Memo Confirmation" := false;
                                    ServiceSetup."Default VAT Date" := 0;
                                end;
                            end else
                                "Use VAT Date" := xRec."Use VAT Date";
                        end;
                end;

            end;
        }
        field(46015606; "Check VAT Identifier"; Boolean)
        {
            Caption = 'Check VAT Identifier';
            Description = 'NAVE111.0,001';
        }
        field(46015607; "Allow VAT Posting From"; Date)
        {
            Caption = 'Allow VAT Posting From';
            Description = 'NAVE111.0,001';

            trigger OnValidate();
            begin
                TESTFIELD("Use VAT Date");
            end;
        }
        field(46015608; "Allow VAT Posting To"; Date)
        {
            Caption = 'Allow VAT Posting To';
            Description = 'NAVE111.0,001';

            trigger OnValidate();
            begin
                TESTFIELD("Use VAT Date");
            end;
        }
        field(46015613; "Allow VAT Date Change in Lines"; Boolean)
        {
            Caption = 'Allow VAT Date Change in Lines';
            Description = 'NAVE111.0,001';

            trigger OnValidate();
            begin
                TESTFIELD("Use VAT Date");
            end;
        }
        field(46015615; "Check Posting Debit/Credit"; Boolean)
        {
            Caption = 'Check Posting Debit/Credit';
            Description = 'NAVE111.0,001';
        }
        field(46015616; "Mark Neg. Qty as Correction"; Boolean)
        {
            Caption = 'Mark Neg. Qty as Correction';
            Description = 'NAVE111.0,001';
        }
        field(46015617; "Company Officials Nos."; Code[10])
        {
            Caption = 'Company Officials Nos.';
            Description = 'NAVE111.0,001';
            TableRelation = "No. Series";
        }
        field(46015645; "Cash Desk Account Nos."; Code[10])
        {
            Caption = 'Cash Desk Account Nos.';
            Description = 'NAVE111.0,001';
            TableRelation = "No. Series";
        }
        field(46015646; "Default Cash Wdr. Limit (LCY)"; Decimal)
        {
            Caption = 'Default Cash Wdr. Limit (LCY)';
            Description = 'NAVE111.0,001';
        }
        field(46015647; "Default Cash Rcpt. Limit (LCY)"; Decimal)
        {
            Caption = 'Default Cash Rcpt. Limit (LCY)';
            Description = 'NAVE111.0,001';
        }
        field(46015648; "Exclude from Exch. Rate Adj."; Boolean)
        {
            Caption = 'Exclude from Exch. Rate Adj.';
            Description = 'NAVE111.0,001';
        }
        field(46015650; "Cash Desk Report Mandatory"; Boolean)
        {
            Caption = 'Cash Desk Report Mandatory';
            Description = 'NAVE111.0,001';

            trigger OnValidate();
            var
                CashOrderHeader: Record "Cash Order Header";
            begin

                CashOrderHeader.SETRANGE("No.");
                if CashOrderHeader.FINDFIRST then
                    ERROR(Text46012127);
            end;
        }
        field(46015685; "Shared Account Schedule"; Code[10])
        {
            Caption = 'Shared Account Schedule';
            Description = 'NAVE111.0,001';
            TableRelation = "Acc. Schedule Name";
        }
        field(46015687; "Acc. Schedule Results Nos."; Code[10])
        {
            Caption = 'Acc. Schedule Results Nos.';
            Description = 'NAVE111.0,001';
            TableRelation = "No. Series";
        }
        field(46015701; "Unreal. VAT Prot. Code"; Code[20])
        {
            Caption = 'Unrealized VAT Protocol Doc. Type';
            Description = 'NAVBG11.0,001';
            TableRelation = "Document Type".Code;
        }
        field(46015702; "East Localization"; Boolean)
        {
            Caption = 'East Localization';
            Description = 'NAVE111.0,001';

            trigger OnValidate();
            begin

                //NAVBG11.0.001 ; 002 ; entire
                if not "East Localization" then
                    ERROR(Text46012130);

                if not CONFIRM(Text46012129, false) then begin
                    "East Localization" := xRec."East Localization";
                    ERROR('');
                end;
            end;
        }
        field(46015703; "Bulgarian Localization"; Boolean)
        {
            Caption = 'Bulgarian Localization';
            Description = 'NAVBG11.0,001';

            trigger OnValidate();
            begin

                //NAVBG11.0.001 ; 002 ; entire
                if not "Bulgarian Localization" then
                    ERROR(Text46012130);

                if not "East Localization" then
                    ERROR(Text46012128);

                if not CONFIRM(Text46012129, false) then begin
                    "Bulgarian Localization" := xRec."Bulgarian Localization";
                    ERROR('');
                end;
            end;
        }
        field(46015806; "Use GL Accoung Ledg."; Boolean)
        {
            Caption = 'Use GL Accoung Ledger';
            Description = 'DS11.00,001';
        }
        field(46015810; "Adj.Exchange Rate Dimension"; Code[20])
        {
            Caption = 'Adj.Exchange Rate Dimension';
            Description = 'NAVBG11.0,001';
            TableRelation = Dimension.Code;
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
        OK: Boolean;
        Text006: Label 'Deleting the additional reporting currency will have no effect on already posted general ledger entries.\\';
        Text007: Label 'Do you want to delete the additional reporting currency?';
        Text008: Label '"If you change the additional reporting currency, future general ledger entries will be posted in the new reporting currency (and in LCY).  "';
        Text010: Label '"If you change the additional reporting currency, a batch job will appear. "';
        Text011: Label 'Running this batch job will cause the program to recalculate already posted general ledger entries in the new additional reporting currency.\';
        Text013: Label 'Do you want to change the additional reporting currency?';
        Text020: Label 'Entries will be deleted in the %1 if it is unblocked. An update will be necessary.\\';
        Text005: Label 'If you delete the additional reporting currency, future general ledger entries will be posted in LCY only.';
        Text46012125: Label 'Are you sure you want to disable VAT Date functionality?';
        Text46012126: Label 'If you check field %1 you will let system post using %2 different from %3. Field %2 will be initialized from field %3 in all tables. It may take some time and you will not be able to undo this change after posting entries. Do you really want to continue?';
        Text46012127: Label 'You cannot change the Report Mandatory settings while there are not posted Cash Orders.';
        Text46012128: Label 'East Localization is not active. For activating Bulgarian Localization first have to activate the East Localization.';
        Text46012129: Label 'Once activated this localization it`s not gonna be able to be deactivated. Do you want to continue ?';
        Text46012130: Label 'The localization cannot be deactivated.';

        Text018: Label 'You cannot change the contents of the %1 field because there are posted ledger entries.';

    procedure InitVATDate();
    var
        GLEntry: Record "G/L Entry";
        VATEntry: Record "VAT Entry";
        GenJnlLine: Record "Gen. Journal Line";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesInvLine: Record "Sales Invoice Line";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        SalesArchiveHeader: Record "Sales Header Archive";
        SalesArchiveLine: Record "Sales Line Archive";
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchInvLine: Record "Purch. Inv. Line";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        PurchArchiveHeader: Record "Purchase Header Archive";
        PurchArchiveLine: Record "Purchase Line Archive";
        ServiceHeader: Record "Service Header";
        ServiceLine: Record "Service Line";
        ServiceInvHeader: Record "Service Invoice Header";
        ServiceInvLine: Record "Service Invoice Line";
        ServiceCrMemoHeader: Record "Service Cr.Memo Header";
        ServiceCrMemoLine: Record "Service Cr.Memo Line";
    begin
        with GLEntry do begin
            RESET;
            if FINDSET(true) then
                repeat
                    if "VAT Date" = 0D then begin
                        "VAT Date" := "Posting Date";
                        MODIFY;
                    end;
                until NEXT = 0;
        end;
        with GenJnlLine do begin
            RESET;
            if FINDSET(true) then
                repeat
                    if "VAT Date" = 0D then begin
                        "VAT Date" := "Posting Date";
                        MODIFY;
                    end;
                until NEXT = 0;
        end;
        with VATEntry do begin
            RESET;
            if FINDSET(true) then
                repeat
                    if "VAT Date" = 0D then begin
                        "VAT Date" := "Posting Date";
                        MODIFY;
                    end;
                until NEXT = 0;
        end;
        with SalesHeader do begin
            RESET;
            if FINDSET(true) then
                repeat
                    if "VAT Date" = 0D then begin
                        "VAT Date" := "Posting Date";
                        MODIFY;
                    end;
                    SalesLine.SETRANGE("Document Type", "Document Type");
                    SalesLine.SETRANGE("Document No.", "No.");
                    if SalesLine.FINDSET(true) then
                        repeat
                            if "VAT Date" = 0D then begin
                                SalesLine."VAT Date" := "Posting Date";
                                SalesLine.MODIFY;
                            end;
                        until SalesLine.NEXT = 0;
                until NEXT = 0;
        end;
        with SalesInvHeader do begin
            RESET;
            if FINDSET(true) then
                repeat
                    if "VAT Date" = 0D then begin
                        "VAT Date" := "Posting Date";
                        MODIFY;
                    end;
                    SalesInvLine.SETRANGE("Document No.", "No.");
                    if SalesInvLine.FINDSET(true) then
                        repeat
                            if "VAT Date" = 0D then begin
                                SalesInvLine."VAT Date" := "Posting Date";
                                SalesInvLine.MODIFY;
                            end;
                        until SalesInvLine.NEXT = 0;
                until NEXT = 0;
        end;
        with SalesCrMemoHeader do begin
            RESET;
            if FINDSET(true) then
                repeat
                    if "VAT Date" = 0D then begin
                        "VAT Date" := "Posting Date";
                        MODIFY;
                    end;
                    SalesCrMemoLine.SETRANGE("Document No.", "No.");
                    if SalesCrMemoLine.FINDSET(true) then
                        repeat
                            if "VAT Date" = 0D then begin
                                SalesCrMemoLine."VAT Date" := "Posting Date";
                                SalesCrMemoLine.MODIFY;
                            end;
                        until SalesCrMemoLine.NEXT = 0;
                until NEXT = 0;
        end;
        with SalesArchiveHeader do begin
            RESET;
            if FINDSET(true) then
                repeat
                    if "VAT Date" = 0D then begin
                        "VAT Date" := "Posting Date";
                        MODIFY;
                    end;
                    SalesArchiveLine.SETRANGE("Document Type", "Document Type");
                    SalesArchiveLine.SETRANGE("Document No.", "No.");
                    if SalesArchiveLine.FINDSET(true) then
                        repeat
                            if "VAT Date" = 0D then begin
                                SalesArchiveLine."VAT Date" := "Posting Date";
                                SalesArchiveLine.MODIFY;
                            end;
                        until SalesArchiveLine.NEXT = 0;
                until NEXT = 0;
        end;
        with PurchHeader do begin
            RESET;
            if FINDSET(true) then
                repeat
                    if "VAT Date" = 0D then begin
                        "VAT Date" := "Posting Date";
                        MODIFY;
                    end;
                    PurchLine.SETRANGE("Document Type", "Document Type");
                    PurchLine.SETRANGE("Document No.", "No.");
                    if PurchLine.FINDSET(true) then
                        repeat
                            if "VAT Date" = 0D then begin
                                PurchLine."VAT Date" := "Posting Date";
                                PurchLine.MODIFY;
                            end;
                        until PurchLine.NEXT = 0;
                until NEXT = 0;
        end;
        with PurchInvHeader do begin
            RESET;
            if FINDSET(true) then
                repeat
                    if "VAT Date" = 0D then begin
                        "VAT Date" := "Posting Date";
                        MODIFY;
                    end;
                    PurchInvLine.SETRANGE("Document No.", "No.");
                    if PurchInvLine.FINDSET(true) then
                        repeat
                            if "VAT Date" = 0D then begin
                                PurchInvLine."VAT Date" := "Posting Date";
                                PurchInvLine.MODIFY;
                            end;
                        until PurchInvLine.NEXT = 0;
                until NEXT = 0;
        end;
        with PurchCrMemoHeader do begin
            RESET;
            if FINDSET(true) then
                repeat
                    if "VAT Date" = 0D then begin
                        "VAT Date" := "Posting Date";
                        MODIFY;
                    end;
                    PurchCrMemoLine.SETRANGE("Document No.", "No.");
                    if PurchCrMemoLine.FINDSET(true) then
                        repeat
                            if "VAT Date" = 0D then begin
                                PurchCrMemoLine."VAT Date" := "Posting Date";
                                PurchCrMemoLine.MODIFY;
                            end;
                        until PurchCrMemoLine.NEXT = 0;
                until NEXT = 0;
        end;
        with PurchArchiveHeader do begin
            RESET;
            if FINDSET(true) then
                repeat
                    if "VAT Date" = 0D then begin
                        "VAT Date" := "Posting Date";
                        MODIFY;
                    end;
                    PurchArchiveLine.SETRANGE("Document Type", "Document Type");
                    PurchArchiveLine.SETRANGE("Document No.", "No.");
                    if PurchArchiveLine.FINDSET(true) then
                        repeat
                            if "VAT Date" = 0D then begin
                                PurchArchiveLine."VAT Date" := "Posting Date";
                                PurchArchiveLine.MODIFY;
                            end;
                        until PurchArchiveLine.NEXT = 0;
                until NEXT = 0;
        end;
        with ServiceHeader do begin
            RESET;
            if FINDSET(true) then
                repeat
                    if "VAT Date" = 0D then begin
                        "VAT Date" := "Posting Date";
                        MODIFY;
                    end;
                    ServiceLine.SETRANGE("Document Type", "Document Type");
                    ServiceLine.SETRANGE("Document No.", "No.");
                    if ServiceLine.FINDSET(true) then
                        repeat
                            if "VAT Date" = 0D then begin
                                ServiceLine."VAT Date" := "Posting Date";
                                ServiceLine.MODIFY;
                            end;
                        until ServiceLine.NEXT = 0;
                until NEXT = 0;
        end;
        with ServiceInvHeader do begin
            RESET;
            if FINDSET(true) then
                repeat
                    if "VAT Date" = 0D then begin
                        "VAT Date" := "Posting Date";
                        MODIFY;
                    end;
                    ServiceInvLine.SETRANGE("Document No.", "No.");
                    if ServiceInvLine.FINDSET(true) then
                        repeat
                            if "VAT Date" = 0D then begin
                                ServiceInvLine."VAT Date" := "Posting Date";
                                ServiceInvLine.MODIFY;
                            end;
                        until ServiceInvLine.NEXT = 0;
                until NEXT = 0;
        end;
        with ServiceCrMemoHeader do begin
            RESET;
            if FINDSET(true) then
                repeat
                    if "VAT Date" = 0D then begin
                        "VAT Date" := "Posting Date";
                        MODIFY;
                    end;
                    ServiceCrMemoLine.SETRANGE("Document No.", "No.");
                    if ServiceCrMemoLine.FINDSET(true) then
                        repeat
                            if "VAT Date" = 0D then begin
                                ServiceCrMemoLine."VAT Date" := "Posting Date";
                                ServiceCrMemoLine.MODIFY;
                            end;
                        until ServiceCrMemoLine.NEXT = 0;
                until NEXT = 0;
        end;
    end;

}

