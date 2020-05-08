tableextension 46015613 tableextension46015613 extends "General Ledger Setup" 
{
    // version NAVW111.00.00.28629,NAVE111.0,DS11.00

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
        field(46015505;"VAT Protocol Nos.";Code[10])
        {
            Caption = 'VAT Protocol Nos.';
            Description = 'NAVBG11.0,001';
            TableRelation = "No. Series";
        }
        field(46015506;"Posted VAT Protocol Nos.";Code[10])
        {
            Caption = 'Posted VAT Protocol Nos.';
            Description = 'NAVBG11.0,001';
            TableRelation = "No. Series";
        }
        field(46015605;"Use VAT Date";Boolean)
        {
            Caption = 'Use VAT Date';
            Description = 'NAVE111.0,001';

            trigger OnValidate();
            var
                SalesSetup : Record "Sales & Receivables Setup";
                ServiceSetup : Record "Service Mgt. Setup";
                PurchSetup : Record "Purchases & Payables Setup";
            begin
                case "Use VAT Date" of
                  true:
                    if CONFIRM(Text46012126,true,FIELDCAPTION("Use VAT Date"),
                         GLEntry.FIELDCAPTION("VAT Date"),GLEntry.FIELDCAPTION("Posting Date"))
                    then
                      InitVATDate
                    else
                      "Use VAT Date" := xRec."Use VAT Date";
                  false:
                    begin
                      GLEntry.RESET;
                      GLEntry.SETFILTER("VAT Date",'>%1',0D);
                      if GLEntry.FINDFIRST then
                        ERROR(Text018,FIELDCAPTION("Use VAT Date"));
                      if CONFIRM(Text46012125,false) then begin
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
        field(46015606;"Check VAT Identifier";Boolean)
        {
            Caption = 'Check VAT Identifier';
            Description = 'NAVE111.0,001';
        }
        field(46015607;"Allow VAT Posting From";Date)
        {
            Caption = 'Allow VAT Posting From';
            Description = 'NAVE111.0,001';

            trigger OnValidate();
            begin
                TESTFIELD("Use VAT Date");
            end;
        }
        field(46015608;"Allow VAT Posting To";Date)
        {
            Caption = 'Allow VAT Posting To';
            Description = 'NAVE111.0,001';

            trigger OnValidate();
            begin
                TESTFIELD("Use VAT Date");
            end;
        }
        field(46015613;"Allow VAT Date Change in Lines";Boolean)
        {
            Caption = 'Allow VAT Date Change in Lines';
            Description = 'NAVE111.0,001';

            trigger OnValidate();
            begin
                TESTFIELD("Use VAT Date");
            end;
        }
        field(46015615;"Check Posting Debit/Credit";Boolean)
        {
            Caption = 'Check Posting Debit/Credit';
            Description = 'NAVE111.0,001';
        }
        field(46015616;"Mark Neg. Qty as Correction";Boolean)
        {
            Caption = 'Mark Neg. Qty as Correction';
            Description = 'NAVE111.0,001';
        }
        field(46015617;"Company Officials Nos.";Code[10])
        {
            Caption = 'Company Officials Nos.';
            Description = 'NAVE111.0,001';
            TableRelation = "No. Series";
        }
        field(46015645;"Cash Desk Account Nos.";Code[10])
        {
            Caption = 'Cash Desk Account Nos.';
            Description = 'NAVE111.0,001';
            TableRelation = "No. Series";
        }
        field(46015646;"Default Cash Wdr. Limit (LCY)";Decimal)
        {
            Caption = 'Default Cash Wdr. Limit (LCY)';
            Description = 'NAVE111.0,001';
        }
        field(46015647;"Default Cash Rcpt. Limit (LCY)";Decimal)
        {
            Caption = 'Default Cash Rcpt. Limit (LCY)';
            Description = 'NAVE111.0,001';
        }
        field(46015648;"Exclude from Exch. Rate Adj.";Boolean)
        {
            Caption = 'Exclude from Exch. Rate Adj.';
            Description = 'NAVE111.0,001';
        }
        field(46015650;"Cash Desk Report Mandatory";Boolean)
        {
            Caption = 'Cash Desk Report Mandatory';
            Description = 'NAVE111.0,001';

            trigger OnValidate();
            var
                CashOrderHeader : Record "Cash Order Header";
            begin

                CashOrderHeader.SETRANGE("No.");
                if CashOrderHeader.FINDFIRST then
                  ERROR(Text46012127);
            end;
        }
        field(46015685;"Shared Account Schedule";Code[10])
        {
            Caption = 'Shared Account Schedule';
            Description = 'NAVE111.0,001';
            TableRelation = "Acc. Schedule Name";
        }
        field(46015687;"Acc. Schedule Results Nos.";Code[10])
        {
            Caption = 'Acc. Schedule Results Nos.';
            Description = 'NAVE111.0,001';
            TableRelation = "No. Series";
        }
        field(46015701;"Unreal. VAT Prot. Code";Code[20])
        {
            Caption = 'Unrealized VAT Protocol Doc. Type';
            Description = 'NAVBG11.0,001';
            TableRelation = "Document Type".Code;
        }
        field(46015702;"East Localization";Boolean)
        {
            Caption = 'East Localization';
            Description = 'NAVE111.0,001';

            trigger OnValidate();
            begin

                //NAVBG11.0.001 ; 002 ; entire
                if not "East Localization" then
                  ERROR( Text46012130 );

                if not CONFIRM( Text46012129 , false ) then begin
                  "East Localization" := xRec."East Localization";
                  ERROR('');
                end;
            end;
        }
        field(46015703;"Bulgarian Localization";Boolean)
        {
            Caption = 'Bulgarian Localization';
            Description = 'NAVBG11.0,001';

            trigger OnValidate();
            begin

                //NAVBG11.0.001 ; 002 ; entire
                if not "Bulgarian Localization" then
                  ERROR( Text46012130 );

                if not "East Localization" then
                  ERROR( Text46012128 );

                if not CONFIRM( Text46012129 , false ) then begin
                  "Bulgarian Localization" := xRec."Bulgarian Localization";
                  ERROR('');
                end;
            end;
        }
        field(46015806;"Use GL Accoung Ledg.";Boolean)
        {
            Caption = 'Use GL Accoung Ledger';
            Description = 'DS11.00,001';
        }
        field(46015810;"Adj.Exchange Rate Dimension";Code[20])
        {
            Caption = 'Adj.Exchange Rate Dimension';
            Description = 'NAVBG11.0,001';
            TableRelation = Dimension.Code;
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
        OK : Boolean;
        Text006 : Label 'Deleting the additional reporting currency will have no effect on already posted general ledger entries.\\';

    var
        Text007 : Label 'Do you want to delete the additional reporting currency?';
        Text008 : Label '"If you change the additional reporting currency, future general ledger entries will be posted in the new reporting currency (and in LCY).  "';
        Text010 : Label '"If you change the additional reporting currency, a batch job will appear. "';
        Text011 : Label 'Running this batch job will cause the program to recalculate already posted general ledger entries in the new additional reporting currency.\';
        Text013 : Label 'Do you want to change the additional reporting currency?';
        Text020 : Label 'Entries will be deleted in the %1 if it is unblocked. An update will be necessary.\\';
        Text005 : Label 'If you delete the additional reporting currency, future general ledger entries will be posted in LCY only.';
        Text46012125 : Label 'Are you sure you want to disable VAT Date functionality?';
        Text46012126 : Label 'If you check field %1 you will let system post using %2 different from %3. Field %2 will be initialized from field %3 in all tables. It may take some time and you will not be able to undo this change after posting entries. Do you really want to continue?';
        Text46012127 : Label 'You cannot change the Report Mandatory settings while there are not posted Cash Orders.';
        Text46012128 : Label 'East Localization is not active. For activating Bulgarian Localization first have to activate the East Localization.';
        Text46012129 : Label 'Once activated this localization it`s not gonna be able to be deactivated. Do you want to continue ?';
        Text46012130 : Label 'The localization cannot be deactivated.';
        LocalizationUsage : Codeunit "Localization Usage";
}
