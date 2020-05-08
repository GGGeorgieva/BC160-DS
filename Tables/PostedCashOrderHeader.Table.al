table 46015647 "Posted Cash Order Header"
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
    // 001   mp       27.10.14   NAVE18.00      Created table from MS Dynamics NAV 6.00
    // ------------------------------------------------------------------------------------------

    Caption = 'Posted Cash Order Header';
    DataCaptionFields = "Cash Desk No.","Order Type","No.","Pay-to/Receive-from Name";

    fields
    {
        field(1;"Cash Desk No.";Code[20])
        {
            Caption = 'Cash Desk No.';
            TableRelation = "Bank Account" WHERE ("Account Type"=CONST("Cash Desk"));

            trigger OnLookup();
            var
                CashDeskAcc : Record "Bank Account";
            begin
                if not CashDeskAcc.GET("Cash Desk No.") then
                  CashDeskAcc."Account Type" := CashDeskAcc."Account Type"::"Cash Desk";
                CashDeskAcc.Lookup;
            end;
        }
        field(2;"No.";Code[20])
        {
            Caption = 'No.';
        }
        field(3;"Pay-to/Receive-from Name";Text[50])
        {
            Caption = 'Pay-to/Receive-from Name';
        }
        field(4;"Pay-to/Receive-from Name 2";Text[50])
        {
            Caption = 'Pay-to/Receive-from Name 2';
        }
        field(5;"Posting Date";Date)
        {
            Caption = 'Posting Date';
        }
        field(7;Amount;Decimal)
        {
            CalcFormula = Sum("Posted Cash Order Line".Amount WHERE ("Cash Order No."=FIELD("No."),
                                                                     "Order Type"=FIELD("Order Type")));
            Caption = 'Amount';
            FieldClass = FlowField;
        }
        field(8;"Amount (LCY)";Decimal)
        {
            CalcFormula = Sum("Posted Cash Order Line"."Amount (LCY)" WHERE ("Cash Order No."=FIELD("No."),
                                                                             "Order Type"=FIELD("Order Type")));
            Caption = 'Amount (LCY)';
            FieldClass = FlowField;
        }
        field(12;Correction;Boolean)
        {
            Caption = 'Correction';
        }
        field(13;"Cash Desk Report No.";Code[20])
        {
            Caption = 'Cash Desk Report No.';
        }
        field(15;"No. Printed";Integer)
        {
            Caption = 'No. Printed';
        }
        field(17;"Opened User ID";Code[50])
        {
            Caption = 'Opened User ID';
        }
        field(18;"Issued User ID";Code[50])
        {
            Caption = 'Issued User ID';
        }
        field(19;"Posted User ID";Code[50])
        {
            Caption = 'Posted User ID';
        }
        field(20;"Order Type";Option)
        {
            Caption = 'Order Type';
            OptionCaption = 'Receipt,Withdrawal';
            OptionMembers = Receipt,Withdrawal;
        }
        field(21;"No. Series";Code[20])
        {
            Caption = 'No. Series';
        }
        field(22;"Currency Code";Code[20])
        {
            Caption = 'Currency Code';
            TableRelation = Currency.Code;
        }
        field(23;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(1));
        }
        field(24;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(2));
        }
        field(25;"Currency Factor";Decimal)
        {
            Caption = 'Currency Factor';
        }
        field(30;"Document Date";Date)
        {
            Caption = 'Document Date';
        }
        field(35;"VAT Date";Date)
        {
            Caption = 'VAT Date';
        }
        field(480;"Dimension Set ID";Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup();
            begin

                  ShowDimensions;
            end;
        }
    }

    keys
    {
        key(Key1;"Cash Desk No.","Order Type","No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        PostedCashOrderHeader : Record "Posted Cash Order Header";
        DimMgt : Codeunit DimensionManagement;

    procedure Lookup();
    var
        PostedCashReceipts : Page "Posted Cash Receipts";
        PostedCashWithdrawals : Page "Posted Cash Withdrawals";
    begin
        case "Order Type" of
          "Order Type"::Receipt:
            begin
              PostedCashReceipts.LOOKUPMODE(true);
              PostedCashReceipts.SETRECORD(Rec);
              if PostedCashReceipts.RUNMODAL = ACTION::LookupOK then
                PostedCashReceipts.GETRECORD(Rec);
            end;
          "Order Type"::Withdrawal:
            begin
              PostedCashWithdrawals.LOOKUPMODE(true);
              PostedCashWithdrawals.SETRECORD(Rec);
              if PostedCashWithdrawals.RUNMODAL = ACTION::LookupOK then
                PostedCashWithdrawals.GETRECORD(Rec);
            end;
        end;
    end;

    procedure PrintRecords(ShowRequestForm : Boolean);
    var
        ReportSelection : Record "Report Selections";
    begin
        with PostedCashOrderHeader do begin
          COPY(Rec);
          FINDFIRST;
          if "Order Type" = "Order Type"::Receipt then
            ReportSelection.SETRANGE(Usage,ReportSelection.Usage::BG7)
          else
            ReportSelection.SETRANGE(Usage,ReportSelection.Usage::BG8);
          ReportSelection.SETFILTER("Report ID",'<>0');
          ReportSelection.FINDSET;
          repeat
            REPORT.RUNMODAL(ReportSelection."Report ID",ShowRequestForm,false,PostedCashOrderHeader);
          until ReportSelection.NEXT = 0;
        end;
    end;

    procedure Navigate();
    var
        NavigatePage : Page Navigate;
    begin
        NavigatePage.SetDoc("Posting Date","No.");
        NavigatePage.SetCashDesk("Cash Desk No.","Order Type");
        NavigatePage.RUN;
    end;

    procedure ShowDimensions();
    begin

          DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"No."));
    end;
}

