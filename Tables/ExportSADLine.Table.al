table 46015625 "Export SAD Line"
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

    Caption = 'Export SAD Line';
    Permissions = TableData "Purch. Inv. Header"=rm,
                  TableData "Purch. Inv. Line"=rm,
                  TableData "Purch. Cr. Memo Hdr."=rm,
                  TableData "Purch. Cr. Memo Line"=rm;

    fields
    {
        field(1;"SAD No.";Code[20])
        {
            Caption = 'SAD No.';
            TableRelation = "Export SAD Header";

            trigger OnValidate();
            begin
                ExpSADHeader.GET("SAD No.");
                "Customer No." := ExpSADHeader."Customer No.";
                "Currency Code" := ExpSADHeader."Customs Currency Code";
            end;
        }
        field(2;"Line No.";Integer)
        {
            Caption = 'Line No.';
        }
        field(3;"Document No.";Code[20])
        {
            Caption = 'Document No.';
            TableRelation = IF ("Document Type"=CONST(Invoice)) "Sales Invoice Header" WHERE ("SAD Export No."=CONST(''))
                            ELSE IF ("Document Type"=CONST("Credit Memo")) "Sales Cr.Memo Header" WHERE ("SAD No."=CONST(''));

            trigger OnValidate();
            begin
                CheckSADStatus("SAD No.");
                TESTFIELD("Document No.");

                if xRec."Document No." <> "Document No." then begin
                  SADPayment.RESET;
                  SADPayment.SETRANGE(Type,SADPayment.Type::Export);
                  SADPayment.SETRANGE("SAD No.",xRec."SAD No.");
                  SADPayment.SETRANGE("Document Type",xRec."Document Type");
                  SADPayment.SETRANGE("Document No.",xRec."Document No.");
                  if SADPayment.FINDFIRST then
                    ERROR(Text003);
                end;

                ExpSADLine.RESET;
                ExpSADLine.SETCURRENTKEY("SAD No.","Document Type","Document No.");
                ExpSADLine.SETRANGE("SAD No.","SAD No.");
                ExpSADLine.SETRANGE("Document Type","Document Type");
                ExpSADLine.SETRANGE("Document No.","Document No.");
                if ExpSADLine.FINDFIRST then
                  ERROR(Text001,FIELDCAPTION("Document No."),"Document No.");

                if "Document Type" = "Document Type"::Invoice then begin
                  FillInvoiceLine("Document No.",Rec);
                  SalesPost.UpdateInvoiceSADNo("Document No.","SAD No.");
                  SalesPost.UpdateInvoiceSADNo(xRec."Document No.",'');
                end else begin
                  FillCreditMemoLine("Document No.",Rec);
                  SalesPost.UpdateCrMemoSADNo("Document No.","SAD No.");
                  SalesPost.UpdateCrMemoSADNo(xRec."Document No.",'');
                end;

                if "Document No." <> '' then begin
                  SADPayment.INIT;
                  SADPayment."SAD No." := "SAD No.";
                  SADPayment.Type := SADPayment.Type::Export;
                  SADPayment."Document Type" := "Document Type";
                  SADPayment."Document No." := "Document No.";
                  SADPayment.SuggestPayment;
                end;
            end;
        }
        field(4;"External Document No.";Code[20])
        {
            Caption = 'External Document No.';

            trigger OnValidate();
            begin
                CheckEditAllowAndLineModify;
                TESTFIELD("Document No.");
            end;
        }
        field(5;"Customer No.";Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;

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
          SalesPost.UpdateInvoiceSADNo("Document No.",'')
        else
          SalesPost.UpdateCrMemoSADNo("Document No.",'');

        SADPayment.SETRANGE("SAD No.","SAD No.");
        SADPayment.SETRANGE("Document Type","Document Type");
        SADPayment.SETRANGE("Document No.","Document No.");
        SADPayment.SETRANGE(Type,SADPayment.Type::Export);
        SADPayment.DELETEALL;
    end;

    trigger OnInsert();
    begin
        TESTFIELD("Document No.");
    end;

    var
        ExpSADHeader : Record "Export SAD Header";
        PostedSalesInvoice : Record "Sales Invoice Header";
        PostedSalesCreditMemo : Record "Sales Cr.Memo Header";
        ExpSADLine : Record "Export SAD Line";
        Text001 : Label 'The line with %1 %2 already exists.';
        SADPayment : Record "SAD Payment";
        SalesPost : Codeunit "Sales-Post";
        SADLineNo : Integer;
        Text002 : Label 'Manual editing of SAD line is not allowed.\Please check the Sales & Receivables Setup.';
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
          SalesPost.UpdateInvoiceSADNo(DocNo,SADNo);
        end else begin
          FillCreditMemoLine(DocNo,Rec);
          SalesPost.UpdateCrMemoSADNo(DocNo,SADNo);
        end;

        INSERT(true);
    end;

    procedure FillInvoiceLine(DocNo : Code[20];var ExpSADLine : Record "Export SAD Line");
    begin
        if PostedSalesInvoice.GET(DocNo) then begin
          ExpSADLine."Document Type" := "Document Type"::Invoice;
          ExpSADLine."Document No." := DocNo;
          ExpSADLine."Document Date" := PostedSalesInvoice."Document Date";
          ExpSADLine."Customer No." := PostedSalesInvoice."Bill-to Customer No.";
          ExpSADLine."Currency Code" := PostedSalesInvoice."Currency Code";
          ExpSADLine."External Document No." := PostedSalesInvoice."External Document No.";
          PostedSalesInvoice.CALCFIELDS(Amount);
          ExpSADLine.Amount := PostedSalesInvoice.Amount;
          RecalculateAmount(false,ExpSADLine);
        end;

        "Edited Manually" := false;
    end;

    procedure FillCreditMemoLine(DocNo : Code[20];var ExpSADLine : Record "Export SAD Line");
    begin
        if PostedSalesCreditMemo.GET(DocNo) then begin
          ExpSADLine."Document Type" := "Document Type"::"Credit Memo";
          ExpSADLine."Document No." := DocNo;
          ExpSADLine."Document Date" := PostedSalesCreditMemo."Document Date";
          ExpSADLine."Customer No." := PostedSalesCreditMemo."Bill-to Customer No.";
          ExpSADLine."Currency Code" := PostedSalesCreditMemo."Currency Code";
          ExpSADLine."External Document No." := PostedSalesCreditMemo."External Document No.";
          PostedSalesCreditMemo.CALCFIELDS(Amount);
          ExpSADLine.Amount := -PostedSalesCreditMemo.Amount;
          RecalculateAmount(false,ExpSADLine);
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
        SADPayment2.SETRANGE(Type,SADPayment2.Type::Export);
        SADPayment2.FILTERGROUP := 0;
        PAGE.RUNMODAL(PAGE::Page46012274,SADPayment2);
    end;

    procedure CheckEditAllowAndLineModify();
    var
        SalesSetup : Record "Sales & Receivables Setup";
        ExpSADLineTemp : Record "Export SAD Line";
    begin
        CheckSADStatus("SAD No.");

        SalesSetup.GET;
        if not SalesSetup."Allow Manual Edit SAD Line" then
          ERROR(Text002);

        ExpSADLineTemp.INIT;
        if "Document Type" = "Document Type"::Invoice then
          FillInvoiceLine("Document No.",ExpSADLineTemp)
        else
          FillCreditMemoLine("Document No.",ExpSADLineTemp);
        ExpSADLineTemp.INSERT;

        if ("External Document No." <> ExpSADLineTemp."External Document No.") or
           ("Customer No." <> ExpSADLineTemp."Customer No.") or
           ("Currency Code" <> ExpSADLineTemp."Currency Code") or
           (Amount <> ExpSADLineTemp.Amount)
        then
          "Edited Manually" := true
        else
          "Edited Manually" := false;

        ExpSADLineTemp.DELETE;
    end;

    procedure CheckSADStatus(SADNo : Code[20]);
    var
        ExpSADHeader : Record "Export SAD Header";
    begin
        ExpSADHeader.GET(SADNo);
        ExpSADHeader.TESTFIELD(Status,ExpSADHeader.Status::Open);
    end;

    procedure RecalculateAmount(CalcType : Boolean;var ExpSADLine2 : Record "Export SAD Line");
    var
        Currency : Record Currency;
        GLSetup : Record "General Ledger Setup";
        CurrExchRate : Record "Currency Exchange Rate";
        CurrFactor : Decimal;
        CurrDate : Date;
    begin
        with ExpSADLine2 do begin

          if "Document Type" = "Document Type"::Invoice then begin
            PostedSalesInvoice.GET("Document No.");
            CurrDate := PostedSalesInvoice."Posting Date";
          end else begin
            PostedSalesCreditMemo.GET("Document No.");
            CurrDate := PostedSalesCreditMemo."Posting Date";
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
        VATEntry.SETRANGE(Type,VATEntry.Type::Sale);
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

