table 46015623 "Import SAD Line"
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

    Caption = 'Import SAD Line';
    Permissions = TableData "Purch. Inv. Header"=rm,
                  TableData "Purch. Inv. Line"=rm,
                  TableData "Purch. Cr. Memo Hdr."=rm,
                  TableData "Purch. Cr. Memo Line"=rm;

    fields
    {
        field(1;"SAD No.";Code[20])
        {
            Caption = 'SAD No.';
            TableRelation = "Import SAD Header";

            trigger OnValidate();
            begin
                ImpSADHeader.GET("SAD No.");
                "Vendor No." := ImpSADHeader."Vendor No.";
                "Currency Code" := ImpSADHeader."Customs Currency Code";
            end;
        }
        field(2;"Line No.";Integer)
        {
            Caption = 'Line No.';
        }
        field(3;"Document No.";Code[20])
        {
            Caption = 'Document No.';
            TableRelation = IF ("Document Type"=CONST(Invoice)) "Purch. Inv. Header" WHERE ("SAD No."=CONST(''))
                            ELSE IF ("Document Type"=CONST("Credit Memo")) "Purch. Cr. Memo Hdr." WHERE ("SAD No."=CONST(''));

            trigger OnValidate();
            begin
                CheckSADStatus("SAD No.");

                if xRec."Document No." <> "Document No." then begin
                  SADPayment.RESET;
                  SADPayment.SETRANGE(Type,SADPayment.Type::Import);
                  SADPayment.SETRANGE("SAD No.",xRec."SAD No.");
                  SADPayment.SETRANGE("Document Type",xRec."Document Type");
                  SADPayment.SETRANGE("Document No.",xRec."Document No.");
                  if SADPayment.FINDFIRST then
                    ERROR(Text003);
                end;

                ImpSADLine.RESET;
                ImpSADLine.SETCURRENTKEY("SAD No.","Document Type","Document No.");
                ImpSADLine.SETRANGE("SAD No.","SAD No.");
                ImpSADLine.SETRANGE("Document Type","Document Type");
                ImpSADLine.SETRANGE("Document No.","Document No.");
                if ImpSADLine.FINDFIRST then
                  ERROR(Text001,FIELDCAPTION("Document No."),"Document No.");

                if "Document Type" = "Document Type"::Invoice then begin
                  FillInvoiceLine("Document No.",Rec);
                  PurchPost.UpdateInvoiceSADNo("Document No.","SAD No.");
                  PurchPost.UpdateInvoiceSADNo(xRec."Document No.",'');
                end else begin
                  FillCreditMemoLine("Document No.",Rec);
                  PurchPost.UpdateCrMemoSADNo("Document No.","SAD No.");
                  PurchPost.UpdateCrMemoSADNo(xRec."Document No.",'');
                end;

                if "Document No." <> '' then begin
                  SADPayment.INIT;
                  SADPayment."SAD No." := "SAD No.";
                  SADPayment.Type := SADPayment.Type::Import;
                  SADPayment."Document Type" := "Document Type";
                  SADPayment."Document No." := "Document No.";
                  SADPayment.SuggestPayment;
                end;
            end;
        }
        field(4;"Vendor Invoice No.";Code[20])
        {
            Caption = 'Vendor Invoice No.';

            trigger OnValidate();
            begin
                CheckEditAllowAndLineModify;
                TESTFIELD("Document No.");
            end;
        }
        field(5;"Vendor No.";Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;

            trigger OnValidate();
            begin
                CheckEditAllowAndLineModify;
                TESTFIELD("Document No.");
            end;
        }
        field(6;"Currency Code";Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate();
            begin
                CheckEditAllowAndLineModify;
                TESTFIELD("Document No.");

                RecalculateAmount(false,Rec);
            end;
        }
        field(7;"Amount (LCY)";Decimal)
        {
            Caption = 'Amount (LCY)';

            trigger OnValidate();
            begin
                CheckEditAllowAndLineModify;
                TESTFIELD("Document No.");

                RecalculateAmount(true,Rec);
            end;
        }
        field(8;"Document Type";Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Invoice,Credit Memo';
            OptionMembers = Invoice,"Credit Memo";

            trigger OnValidate();
            begin
                TESTFIELD("Document No.",'');
            end;
        }
        field(9;"VAT Amount (LCY)";Decimal)
        {
            Caption = 'VAT Amount (LCY)';
            Editable = false;

            trigger OnValidate();
            begin
                CheckEditAllowAndLineModify;
                TESTFIELD("Document No.");
            end;
        }
        field(10;Amount;Decimal)
        {
            Caption = 'Amount';
            FieldClass = Normal;

            trigger OnValidate();
            begin
                CheckEditAllowAndLineModify;
                TESTFIELD("Document No.");

                RecalculateAmount(false,Rec);
            end;
        }
        field(11;"Edited Manually";Boolean)
        {
            Caption = 'Edited Manually';
            Editable = false;
        }
        field(12;"Document Date";Date)
        {
            Caption = 'Document Date';
            Editable = false;

            trigger OnValidate();
            begin
                CheckSADStatus("SAD No.");
            end;
        }
    }

    keys
    {
        key(Key1;"SAD No.","Line No.")
        {
        }
        key(Key2;"SAD No.","Document Type","Document No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        if "Document Type" = "Document Type"::Invoice then
          PurchPost.UpdateInvoiceSADNo("Document No.",'')
        else
          PurchPost.UpdateCrMemoSADNo("Document No.",'');

        SADPayment.SETRANGE("SAD No.","SAD No.");
        SADPayment.SETRANGE("Document Type","Document Type");
        SADPayment.SETRANGE("Document No.","Document No.");
        SADPayment.SETRANGE(Type,SADPayment.Type::Import);
        SADPayment.DELETEALL;
    end;

    trigger OnInsert();
    begin
        TESTFIELD("Document No.");
    end;

    var
        ImpSADHeader : Record "Import SAD Header";
        PostedPurchInvoice : Record "Purch. Inv. Header";
        PostedPurchCreditMemo : Record "Purch. Cr. Memo Hdr.";
        ImpSADLine : Record "Import SAD Line";
        Text001 : Label 'The line with%1 %2 already exists.';
        SADPayment : Record "SAD Payment";
        PurchPost : Codeunit "Purch.-Post";
        SADLineNo : Integer;
        Text002 : Label 'Manual editing of SAD line is not allowed.\Please check the Purchase & Payables Setup.';
        Text003 : Label 'Payment(s) are linked to the SAD line.\You must delete the existing payment line(s) before modifying the SAD line.';

    procedure CreateLine(SADNo : Code[20];DocType : Option Invoice,"Credit Memo";DocNo : Code[20]);
    begin
        RESET;
        LOCKTABLE;
        SETRANGE("SAD No.",SADNo);
        if FIND('+') then
          SADLineNo := "Line No." + 10000
        else
          SADLineNo := 10000;

        INIT;
        "SAD No." := SADNo;
        "Line No." := SADLineNo;

        if DocType = DocType::Invoice then begin
          FillInvoiceLine(DocNo,Rec);
          PurchPost.UpdateInvoiceSADNo(DocNo,SADNo);
        end else begin
          FillCreditMemoLine(DocNo,Rec);
          PurchPost.UpdateCrMemoSADNo(DocNo,SADNo);
        end;

        INSERT(true);
    end;

    procedure FillInvoiceLine(DocNo : Code[20];var ImpSADLine : Record "Import SAD Line");
    begin
        if PostedPurchInvoice.GET(DocNo) then begin
          ImpSADLine."Document Type" := "Document Type"::Invoice;
          ImpSADLine."Document No." := DocNo;
          ImpSADLine."Document Date" := PostedPurchInvoice."Document Date";
          ImpSADLine."Vendor No." := PostedPurchInvoice."Pay-to Vendor No.";
          ImpSADLine."Vendor Invoice No." := PostedPurchInvoice."Vendor Invoice No.";
          ImpSADLine."Currency Code" := PostedPurchInvoice."Currency Code";
          PostedPurchInvoice.CALCFIELDS(Amount);
          ImpSADLine.Amount := PostedPurchInvoice.Amount;
          RecalculateAmount(false,ImpSADLine);
        end else begin
          ImpSADLine."Document Type" := "Document Type"::Invoice;
          ImpSADLine."Document No." := DocNo;
          ImpSADLine."Document Date" := 0D;
          ImpSADLine."Vendor No." := '';
          ImpSADLine."Vendor Invoice No." := '';
          ImpSADLine."Currency Code" := '';
          ImpSADLine.Amount := 0;
          ImpSADLine."Amount (LCY)" := 0;
        end;

        "Edited Manually" := false;
    end;

    procedure FillCreditMemoLine(DocNo : Code[20];var ImpSADLine : Record "Import SAD Line");
    begin
        if PostedPurchCreditMemo.GET(DocNo) then begin
          ImpSADLine."Document Type" := "Document Type"::"Credit Memo";
          ImpSADLine."Document No." := DocNo;
          ImpSADLine."Document Date" := PostedPurchCreditMemo."Document Date";
          ImpSADLine."Vendor No." := PostedPurchCreditMemo."Pay-to Vendor No.";
          ImpSADLine."Vendor Invoice No." := PostedPurchCreditMemo."Vendor Cr. Memo No.";
          ImpSADLine."Currency Code" := PostedPurchCreditMemo."Currency Code";
          PostedPurchCreditMemo.CALCFIELDS(Amount);
          ImpSADLine.Amount := -PostedPurchCreditMemo.Amount;
          RecalculateAmount(false,ImpSADLine);
        end else begin
          ImpSADLine."Document Type" := "Document Type"::Invoice;
          ImpSADLine."Document No." := DocNo;
          ImpSADLine."Document Date" := 0D;
          ImpSADLine."Vendor No." := '';
          ImpSADLine."Vendor Invoice No." := '';
          ImpSADLine."Currency Code" := '';
          ImpSADLine.Amount := 0;
          ImpSADLine."Amount (LCY)" := 0;
        end;

        "Edited Manually" := false;
    end;

    procedure ShowSADPayments();
    var
        SADPayment2 : Record "SAD Payment";
    begin
        TESTFIELD("Document No.");
        SADPayment2.FILTERGROUP := 2;
        SADPayment2.SETRANGE("SAD No.","SAD No.");
        SADPayment2.SETRANGE("Document Type","Document Type");
        SADPayment2.SETRANGE("Document No.","Document No.");
        SADPayment2.SETRANGE(Type,SADPayment2.Type::Import);
        SADPayment2.FILTERGROUP := 0;
        PAGE.RUNMODAL(PAGE::"SAD Payments",SADPayment2);
    end;

    procedure CheckEditAllowAndLineModify();
    var
        PurchSetup : Record "Purchases & Payables Setup";
        ImpSADLineTemp : Record "Import SAD Line" temporary;
    begin
        CheckSADStatus("SAD No.");

        PurchSetup.GET;
        if not PurchSetup."Allow Manual Edit SAD Line" then
          ERROR(Text002);

        ImpSADLineTemp.INIT;
        if "Document Type" = "Document Type"::Invoice then
          FillInvoiceLine("Document No.",ImpSADLineTemp)
        else
          FillCreditMemoLine("Document No.",ImpSADLineTemp);
        ImpSADLineTemp.INSERT;

        if ("Vendor Invoice No." <> ImpSADLineTemp."Vendor Invoice No.") or
           ("Vendor No." <> ImpSADLineTemp."Vendor No.") or
           ("Currency Code" <> ImpSADLineTemp."Currency Code") or
           (Amount <> ImpSADLineTemp.Amount)
        then
          "Edited Manually" := true
        else
          "Edited Manually" := false;

        ImpSADLineTemp.DELETE;
    end;

    procedure CheckSADStatus(SADNo : Code[20]);
    var
        ImpSADHeader : Record "Import SAD Header";
    begin
        ImpSADHeader.GET(SADNo);
        ImpSADHeader.TESTFIELD(Status,ImpSADHeader.Status::Open);
    end;

    procedure RecalculateAmount(CalcType : Boolean;var ImpSADLine2 : Record "Import SAD Line");
    var
        Currency : Record Currency;
        GLSetup : Record "General Ledger Setup";
        CurrExchRate : Record "Currency Exchange Rate";
        CurrFactor : Decimal;
        CurrDate : Date;
    begin
        with ImpSADLine2 do begin

          if "Document Type" = "Document Type"::Invoice then begin
            PostedPurchInvoice.GET("Document No.");
            CurrDate := PostedPurchInvoice."Posting Date";
          end else begin
            PostedPurchCreditMemo.GET("Document No.");
            CurrDate := PostedPurchCreditMemo."Posting Date";
          end;

          CurrFactor := CurrExchRate.ExchangeRate(CurrDate,"Currency Code");
          GLSetup.GET;

          if not CalcType then begin
            if "Currency Code" <> '' then
              "Amount (LCY)" := ROUND(Amount / CurrFactor,GLSetup."Amount Rounding Precision")
            else
              "Amount (LCY)" := Amount;
          end else begin
            if "Currency Code" <> '' then begin
              Currency.GET("Currency Code");
              Amount := ROUND("Amount (LCY)" * CurrFactor,Currency."Amount Rounding Precision");
            end else
              Amount := "Amount (LCY)";
          end;

          "VAT Amount (LCY)" := ROUND("Amount (LCY)" * CalculateVATCoef,GLSetup."Amount Rounding Precision");
        end;
    end;

    procedure CalculateVATCoef() : Decimal;
    var
        VATEntry : Record "VAT Entry";
        VATBase : Decimal;
        VATAmount : Decimal;
    begin
        VATEntry.RESET;
        VATEntry.SETCURRENTKEY("Document No.");
        VATEntry.SETRANGE(Type,VATEntry.Type::Purchase);
        case "Document Type" of
          "Document Type"::Invoice:
            VATEntry.SETRANGE("Document Type",VATEntry."Document Type"::Invoice);
          "Document Type"::"Credit Memo":
            VATEntry.SETRANGE("Document Type",VATEntry."Document Type"::"Credit Memo");
        end;
        VATEntry.SETRANGE("Document No.","Document No.");
        if VATEntry.FINDSET then begin
          repeat
            VATBase += VATEntry.Base;
            VATAmount += VATEntry.Amount;
          until VATEntry.NEXT = 0;
          if VATBase <> 0 then
            exit(VATAmount / VATBase);
        end;
        exit(0);
    end;
}

