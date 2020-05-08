table 46015627 "SAD Payment"
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

    Caption = 'SAD Payment';

    fields
    {
        field(1;"SAD No.";Code[20])
        {
            Caption = 'SAD No.';
            TableRelation = IF (Type=CONST(Import)) "Import SAD Header"
                            ELSE IF (Type=CONST(Export)) "Export SAD Header";
        }
        field(2;"Line No.";Integer)
        {
            Caption = 'Line No.';
        }
        field(3;"Document Type";Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Invoice,Credit Memo';
            OptionMembers = Invoice,"Credit Memo";
        }
        field(4;"Document No.";Code[20])
        {
            Caption = 'Document No.';
        }
        field(5;"Bank No.";Code[20])
        {
            Caption = 'Bank No.';
            TableRelation = "Bank Account";

            trigger OnValidate();
            begin
                CheckSADStatus("SAD No.");
                TESTFIELD("Payment Date");

                if ("Bank No." <> '') and (xRec."Bank No." <> "Bank No.") then begin
                  BankAcc.GET("Bank No.");
                  VALIDATE("Currency Code",BankAcc."Currency Code");
                end;
            end;
        }
        field(6;"External Document No.";Code[20])
        {
            Caption = 'External Document No.';

            trigger OnValidate();
            begin
                CheckSADStatus("SAD No.");
                TESTFIELD("Payment Date");
            end;
        }
        field(7;"Payment Date";Date)
        {
            Caption = 'Payment Date';
            NotBlank = true;

            trigger OnValidate();
            begin
                CheckSADStatus("SAD No.");
            end;
        }
        field(8;"Amount (LCY)";Decimal)
        {
            Caption = 'Amount (LCY)';
            Editable = false;
        }
        field(9;Amount;Decimal)
        {
            Caption = 'Amount';

            trigger OnValidate();
            begin
                CheckSADStatus("SAD No.");
                TESTFIELD("Payment Date");

                GLSetup.GET;

                if "Currency Code" <> '' then
                  "Amount (LCY)" := ROUND(Amount / GetCurrencyFactor,GLSetup."Amount Rounding Precision")
                else
                  "Amount (LCY)" := Amount;
            end;
        }
        field(10;"Currency Code";Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate();
            begin
                CheckSADStatus("SAD No.");
                if xRec."Currency Code" <> "Currency Code" then
                  VALIDATE(Amount);
            end;
        }
        field(11;Type;Option)
        {
            Caption = 'Type';
            OptionCaption = 'Import,Export';
            OptionMembers = Import,Export;
        }
    }

    keys
    {
        key(Key1;"SAD No.",Type,"Document Type","Document No.","Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Text001 : Label 'You are about to run the Payments Suggestion batch job.\All existing SAD Payment lines associated to document %1 %2 will be deleted.\Do you want to proceed?';
        BankAcc : Record "Bank Account";
        GLSetup : Record "General Ledger Setup";
        SADPayment : Record "SAD Payment";

    procedure SuggestPayment();
    var
        LineNo : Integer;
        Confirmed : Boolean;
    begin
        CheckSADStatus("SAD No.");

        Confirmed := not PaymentsExists;
        if not Confirmed then
          if CONFIRM(Text001,false,"Document Type","Document No.") then begin
            Confirmed := true;
            DELETEALL;
            COMMIT;
          end;

        if Confirmed then begin
          LineNo := 10000;
          if Type = Type::Import then
            InsertVendorRecord("SAD No.","Document Type","Document No.",LineNo,Type)
          else
            InsertCustomerRecord("SAD No.","Document Type","Document No.",LineNo,Type);
        end;
    end;

    procedure CheckSADStatus(SADNo : Code[20]);
    var
        ImpSADHeader : Record "Import SAD Header";
        ExpSADHeader : Record "Export SAD Header";
    begin
        if Type = Type::Import then begin
          ImpSADHeader.GET(SADNo);
          ImpSADHeader.TESTFIELD(Status,ImpSADHeader.Status::Open);
        end else begin
          ExpSADHeader.GET(SADNo);
          ExpSADHeader.TESTFIELD(Status,ExpSADHeader.Status::Open);
        end;
    end;

    procedure GetCurrencyFactor() : Decimal;
    var
        CurrExchRate : Record "Currency Exchange Rate";
    begin
        if "Currency Code" <> '' then
          exit(CurrExchRate.ExchangeRate("Payment Date","Currency Code"))
        else
          exit(0);
    end;

    procedure PaymentsExists() : Boolean;
    begin
        SADPayment.RESET;
        SADPayment.SETRANGE("SAD No.","SAD No.");
        SADPayment.SETRANGE(Type,Type);
        SADPayment.SETRANGE("Document Type","Document Type");
        SADPayment.SETRANGE("Document No.","Document No.");
        SADPayment.SETRANGE("Line No.","Line No.");
        exit(not SADPayment.ISEMPTY);
    end;

    procedure InsertVendorRecord(SADNo : Code[20];DocType : Option Invoice,"Credit Memo";DocNo : Code[20];LineNo : Integer;ImpExpType : Option Import,Export);
    var
        VendLedgEntry : Record "Vendor Ledger Entry";
        VendLedgEntry2 : Record "Vendor Ledger Entry";
        DtldVendLedgEntry : Record "Detailed Vendor Ledg. Entry" temporary;
    begin
        VendLedgEntry.RESET;
        VendLedgEntry.SETCURRENTKEY("Document Type","Document No.");
        if DocType = "Document Type"::Invoice then
          VendLedgEntry.SETRANGE("Document Type",VendLedgEntry."Document Type"::Invoice)
        else
          VendLedgEntry.SETRANGE("Document Type",VendLedgEntry."Document Type"::"Credit Memo");
        VendLedgEntry.SETRANGE("Document No.",DocNo);

        if VendLedgEntry.FINDFIRST then begin

          GetDtlVendLedgerEntries(VendLedgEntry,DtldVendLedgEntry);

          DtldVendLedgEntry.RESET;
          if DtldVendLedgEntry.FINDSET then begin
            repeat
              if DtldVendLedgEntry."Initial Document Type" = DtldVendLedgEntry."Initial Document Type"::Payment then begin
                DtldVendLedgEntry."Amount (LCY)" := -DtldVendLedgEntry."Amount (LCY)";
                DtldVendLedgEntry.Amount := -DtldVendLedgEntry.Amount;
                VendLedgEntry2.GET(DtldVendLedgEntry."Vendor Ledger Entry No.")
              end else
                VendLedgEntry2.GET(DtldVendLedgEntry."Applied Vend. Ledger Entry No.");

              with SADPayment do begin
                INIT;
                "SAD No." := SADNo;
                "Document Type" := DocType;
                "Document No." := DocNo;
                "Line No." := LineNo;
                Type := ImpExpType;
                "Payment Date" := DtldVendLedgEntry."Posting Date";
                "Amount (LCY)" := DtldVendLedgEntry."Amount (LCY)";
                if  VendLedgEntry2."Bal. Account Type" = VendLedgEntry2."Bal. Account Type"::"Bank Account" then
                  "Bank No." := VendLedgEntry2."Bal. Account No.";
                "External Document No." := VendLedgEntry2."External Document No.";
                "Currency Code" := VendLedgEntry2."Currency Code";
                if "Currency Code" <> DtldVendLedgEntry."Currency Code" then begin
                  VendLedgEntry2.CALCFIELDS("Original Amount","Original Amt. (LCY)");
                  if VendLedgEntry2."Original Amt. (LCY)" <> 0 then
                    Amount := "Amount (LCY)" * VendLedgEntry2."Original Amount" / VendLedgEntry2."Original Amt. (LCY)"
                  else
                    Amount := 0;
                end else
                  Amount := DtldVendLedgEntry.Amount;
                INSERT;
              end;
              LineNo := LineNo + 10000;

            until DtldVendLedgEntry.NEXT = 0;
          end;
        end;
    end;

    procedure InsertCustomerRecord(SADNo : Code[20];DocType : Option Invoice,"Credit Memo";DocNo : Code[20];LineNo : Integer;ImpExpType : Option Import,Export);
    var
        CustLedgEntry : Record "Cust. Ledger Entry";
        CustLedgEntry2 : Record "Cust. Ledger Entry";
        DtldCustLedgEntry : Record "Detailed Cust. Ledg. Entry" temporary;
    begin
        CustLedgEntry.RESET;
        CustLedgEntry.SETCURRENTKEY("Document Type","Document No.");
        if DocType = "Document Type"::Invoice then
          CustLedgEntry.SETRANGE("Document Type",CustLedgEntry."Document Type"::Invoice)
        else
          CustLedgEntry.SETRANGE("Document Type",CustLedgEntry."Document Type"::"Credit Memo");
        CustLedgEntry.SETRANGE("Document No.",DocNo);

        if CustLedgEntry.FINDFIRST then begin

          GetDtlCustLedgerEntries(CustLedgEntry,DtldCustLedgEntry);

          DtldCustLedgEntry.RESET;
          if DtldCustLedgEntry.FINDSET then begin
            repeat
              if DtldCustLedgEntry."Initial Document Type" = DtldCustLedgEntry."Initial Document Type"::Payment then begin
                DtldCustLedgEntry."Amount (LCY)" := -DtldCustLedgEntry."Amount (LCY)";
                DtldCustLedgEntry.Amount := -DtldCustLedgEntry.Amount;
                CustLedgEntry2.GET(DtldCustLedgEntry."Cust. Ledger Entry No.")
              end else
                CustLedgEntry2.GET(DtldCustLedgEntry."Applied Cust. Ledger Entry No.");

              with SADPayment do begin
                INIT;
                "SAD No." := SADNo;
                "Document Type" := DocType;
                "Document No." := DocNo;
                "Line No." := LineNo;
                Type := ImpExpType;
                "Payment Date" := DtldCustLedgEntry."Posting Date";
                "Amount (LCY)" := DtldCustLedgEntry."Amount (LCY)";
                if  CustLedgEntry2."Bal. Account Type" = CustLedgEntry2."Bal. Account Type"::"Bank Account" then
                  "Bank No." := CustLedgEntry2."Bal. Account No.";
                "External Document No." := CustLedgEntry2."External Document No.";
                "Currency Code" := CustLedgEntry2."Currency Code";
                if "Currency Code" <> DtldCustLedgEntry."Currency Code" then begin
                  CustLedgEntry2.CALCFIELDS("Original Amount","Original Amt. (LCY)");
                  if CustLedgEntry2."Original Amt. (LCY)" <> 0 then
                    Amount := "Amount (LCY)" * CustLedgEntry2."Original Amount" / CustLedgEntry2."Original Amt. (LCY)"
                  else
                    Amount := 0;
                end else
                  Amount := DtldCustLedgEntry.Amount;
                INSERT;
              end;
              LineNo := LineNo + 10000;

            until DtldCustLedgEntry.NEXT = 0;
          end;
        end;
    end;

    procedure GetDtlVendLedgerEntries(VendLedgEntry : Record "Vendor Ledger Entry";var TmpDtldVendLedgEntry : Record "Detailed Vendor Ledg. Entry" temporary);
    var
        DtldVendLedgEntry1 : Record "Detailed Vendor Ledg. Entry";
        DtldVendLedgEntry2 : Record "Detailed Vendor Ledg. Entry";
    begin
        with VendLedgEntry do begin
          DtldVendLedgEntry1.SETCURRENTKEY("Vendor Ledger Entry No.");
          DtldVendLedgEntry1.SETRANGE("Vendor Ledger Entry No.","Entry No.");
          DtldVendLedgEntry1.SETRANGE(Unapplied,false);
          DtldVendLedgEntry1.SETRANGE("Entry Type",DtldVendLedgEntry1."Entry Type"::Application);
          if DtldVendLedgEntry1.FIND('-') then begin
            repeat
              if DtldVendLedgEntry1."Vendor Ledger Entry No." =
                 DtldVendLedgEntry1."Applied Vend. Ledger Entry No."
              then begin
                DtldVendLedgEntry2.INIT;
                DtldVendLedgEntry2.SETCURRENTKEY("Applied Vend. Ledger Entry No.","Entry Type");
                DtldVendLedgEntry2.SETRANGE(
                  "Applied Vend. Ledger Entry No.",DtldVendLedgEntry1."Applied Vend. Ledger Entry No.");
                DtldVendLedgEntry2.SETRANGE("Entry Type",DtldVendLedgEntry2."Entry Type"::Application);
                DtldVendLedgEntry2.SETRANGE(Unapplied,false);
                if DtldVendLedgEntry2.FIND('-') then begin
                  repeat
                    if DtldVendLedgEntry2."Vendor Ledger Entry No." <>
                       DtldVendLedgEntry2."Applied Vend. Ledger Entry No."
                    then begin
                      TmpDtldVendLedgEntry := DtldVendLedgEntry2;
                      if TmpDtldVendLedgEntry.INSERT then;
                    end;
                  until DtldVendLedgEntry2.NEXT = 0;
                end;
              end else begin
                TmpDtldVendLedgEntry := DtldVendLedgEntry1;
                if TmpDtldVendLedgEntry.INSERT then;
              end;
            until DtldVendLedgEntry1.NEXT = 0;
          end;
        end;
    end;

    procedure GetDtlCustLedgerEntries(CustLedgEntry : Record "Cust. Ledger Entry";var TmpDtldCustLedgEntry : Record "Detailed Cust. Ledg. Entry" temporary);
    var
        DtldCustLedgEntry1 : Record "Detailed Cust. Ledg. Entry";
        DtldCustLedgEntry2 : Record "Detailed Cust. Ledg. Entry";
    begin
        with CustLedgEntry do begin
          DtldCustLedgEntry1.SETCURRENTKEY("Cust. Ledger Entry No.");
          DtldCustLedgEntry1.SETRANGE("Cust. Ledger Entry No.","Entry No.");
          DtldCustLedgEntry1.SETRANGE(Unapplied,false);
          DtldCustLedgEntry1.SETRANGE("Entry Type",DtldCustLedgEntry1."Entry Type"::Application);
          if DtldCustLedgEntry1.FIND('-') then begin
            repeat
              if DtldCustLedgEntry1."Cust. Ledger Entry No." =
                 DtldCustLedgEntry1."Applied Cust. Ledger Entry No."
              then begin
                DtldCustLedgEntry2.INIT;
                DtldCustLedgEntry2.SETCURRENTKEY("Applied Cust. Ledger Entry No.","Entry Type");
                DtldCustLedgEntry2.SETRANGE(
                  "Applied Cust. Ledger Entry No.",DtldCustLedgEntry1."Applied Cust. Ledger Entry No.");
                DtldCustLedgEntry2.SETRANGE("Entry Type",DtldCustLedgEntry2."Entry Type"::Application);
                DtldCustLedgEntry2.SETRANGE(Unapplied,false);
                if DtldCustLedgEntry2.FIND('-') then begin
                  repeat
                    if DtldCustLedgEntry2."Cust. Ledger Entry No." <>
                       DtldCustLedgEntry2."Applied Cust. Ledger Entry No."
                    then begin
                      TmpDtldCustLedgEntry := DtldCustLedgEntry2;
                      if TmpDtldCustLedgEntry.INSERT then;
                    end;
                  until DtldCustLedgEntry2.NEXT = 0;
                end;
              end else begin
                TmpDtldCustLedgEntry := DtldCustLedgEntry1;
                if TmpDtldCustLedgEntry.INSERT then;
              end;
            until DtldCustLedgEntry1.NEXT = 0;
          end;
        end;
    end;
}

