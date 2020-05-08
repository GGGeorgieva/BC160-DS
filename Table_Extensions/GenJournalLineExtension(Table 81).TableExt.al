tableextension 46015603 tableextension46015603 extends "Gen. Journal Line" 
{
    // version NAVW111.00.00.27667,NAVE111.0,NAVBG11.0,DS11.00

    fields
    {

        //Unsupported feature: CodeInsertion on ""Account Type"(Field 3).OnValidate". Please convert manually.

        //trigger (Variable: GLAcc)();
        //Parameters and return type have not been exported.
        //begin
            /*
            */
        //end;


        //Unsupported feature: CodeModification on ""Account Type"(Field 3).OnValidate". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            if ("Account Type" in ["Account Type"::Customer,"Account Type"::Vendor,"Account Type"::"Fixed Asset",
                                   "Account Type"::"IC Partner","Account Type"::Employee]) and
               ("Bal. Account Type" in ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor,"Bal. Account Type"::"Fixed Asset",
            #4..38
              "VAT Registration No." := '';
            end;

            if "Journal Template Name" <> '' then
              if "Account Type" = "Account Type"::"IC Partner" then begin
                GetTemplate;
            #45..48
              VALIDATE("Credit Card No.",'');

            VALIDATE("Deferral Code",'');
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..41
            //NAVE111.0; 001; begin
            if ("Account Type" = "Account Type"::"IC Partner") and
               ("Bal. Account Type" = "Bal. Account Type"::"G/L Account") and
               GLAcc.GET("Bal. Account No.") and
               LocalizationUsage.UseEastLocalization
            then
              "IC Partner G/L Acc. No." := GLAcc."Default IC Partner G/L Acc. No"
            else
              "IC Partner G/L Acc. No." := '';
            //NAVE111.0; 001; end

            #42..51
            */
        //end;


        //Unsupported feature: CodeModification on ""Posting Date"(Field 5).OnValidate". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            VALIDATE("Document Date","Posting Date");
            VALIDATE("Currency Code");

            if ("Posting Date" <> xRec."Posting Date") and (Amount <> 0) then
            #5..12

            if "Deferral Code" <> '' then
              VALIDATE("Deferral Code");
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            VALIDATE("Document Date","Posting Date");

            //NAVE111.0; 001; begin
            if LocalizationUsage.UseEastLocalization then
              VALIDATE("VAT Date","Posting Date");
            //NAVE111.0; 001; end

            #2..15
            */
        //end;


        //Unsupported feature: CodeModification on ""VAT %"(Field 10).OnValidate". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            GetCurrency;
            case "VAT Calculation Type" of
              "VAT Calculation Type"::"Normal VAT",
            #4..42
                    "VAT Amount","Currency Factor"));
            "VAT Base Amount (LCY)" := "Amount (LCY)" - "VAT Amount (LCY)";

            UpdateSalesPurchLCY;

            if "Deferral Code" <> '' then
              VALIDATE("Deferral Code");
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..45
            //NAVE111.0; 001; begin
            if LocalizationUsage.UseEastLocalization then
              VALIDATE("VAT % (Non Deductible)",GetVATDeduction);
            //NAVE111.0; 001; end

            #46..49
            */
        //end;


        //Unsupported feature: CodeModification on ""Currency Code"(Field 12).OnValidate". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            if "Bal. Account Type" = "Bal. Account Type"::"Bank Account" then begin
              if BankAcc.GET("Bal. Account No.") and (BankAcc."Currency Code" <> '')then
                BankAcc.TESTFIELD("Currency Code","Currency Code");
            #4..31
            if not CustVendAccountNosModified then
              if ("Currency Code" <> xRec."Currency Code") and (Amount <> 0) then
                PaymentToleranceMgt.PmtTolGenJnl(Rec);
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            //NAVE111.0; 001; begin
            if "VAT Protocol" and LocalizationUsage.UseEastLocalization then
              TESTFIELD("Currency Code",'');
            //NAVE111.0; 001; end

            #1..34
            */
        //end;


        //Unsupported feature: CodeModification on "Amount(Field 13).OnValidate". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            ValidateAmount(true);
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            ValidateAmount(true);
            //NAVE111.0; 001; begin
            if "VAT Protocol" and LocalizationUsage.UseEastLocalization then
              if VATPostingSetup.GET("VAT Bus. Posting Group","VAT Prod. Posting Group") then
                if VATPostingSetup."VAT %" <> 0 then
                  "VAT Protocol Base Amount (LCY)" :=
                    ROUND("Amount (LCY)" / VATPostingSetup."VAT %" * 100,GLSetup."Amount Rounding Precision");
            //NAVE111.0; 001; end
            */
        //end;


        //Unsupported feature: CodeInsertion on ""Posting Group"(Field 23)". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        var
            Cust : Record Customer;
            Vend : Record Vendor;
        //begin
            /*

            //NAVE111.0; 001; begin
            if (CurrFieldNo = FIELDNO("Posting Group")) and LocalizationUsage.UseEastLocalization then begin
              case "Account Type" of
                "Account Type"::Customer:
                  begin
                    SalesSetup.GET;
                    if SalesSetup."Allow Alter Posting Groups" then begin
                      Cust.GET("Account No.");
                      if not SubstCustPostingGrp.GET(xRec."Posting Group","Posting Group") and
                        ("Posting Group" <> Cust."Customer Posting Group")
                      then
                        ERROR(Text46012225,xRec."Posting Group","Posting Group",SubstCustPostingGrp.TABLECAPTION);
                    end else
                      if xRec."Posting Group" <> "Posting Group" then
                        ERROR(Text46012226,FIELDCAPTION("Posting Group"),SalesSetup.FIELDCAPTION("Allow Alter Posting Groups"));
                  end;
                "Account Type"::Vendor:
                  begin
                    PurchSetup.GET;
                    if PurchSetup."Allow Alter Posting Groups" then begin
                      Vend.GET("Account No.");
                      if not SubstVendPostingGrp.GET(xRec."Posting Group","Posting Group") and
                        ("Posting Group" <> Vend."Vendor Posting Group")
                      then
                        ERROR(Text46012225,xRec."Posting Group","Posting Group",SubstVendPostingGrp.TABLECAPTION);
                    end else
                      if xRec."Posting Group" <> "Posting Group" then
                        ERROR(Text46012226,FIELDCAPTION("Posting Group"),PurchSetup.FIELDCAPTION("Allow Alter Posting Groups"));
                  end;
                else
                  ERROR(Text010,FIELDCAPTION("Account Type"),"Account Type"::Customer,"Account Type"::Vendor);
              end;
            end;
            //NAVE111.0; 001; end
            */
        //end;


        //Unsupported feature: CodeModification on ""VAT Amount"(Field 44).OnValidate". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            GenJnlBatch.GET("Journal Template Name","Journal Batch Name");
            GenJnlBatch.TESTFIELD("Allow VAT Difference",true);
            if not ("VAT Calculation Type" in
            #4..39
                    "VAT Amount","Currency Factor"));
            "VAT Base Amount (LCY)" := "Amount (LCY)" - "VAT Amount (LCY)";

            UpdateSalesPurchLCY;

            if JobTaskIsSet then begin
            #46..48

            if "Deferral Code" <> '' then
              VALIDATE("Deferral Code");
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..42
            //NAVE111.0; 001; begin
            if LocalizationUsage.UseEastLocalization then
              VALIDATE("VAT % (Non Deductible)",GetVATDeduction);
            //NAVE111.0; 001; end

            #43..51
            */
        //end;


        //Unsupported feature: CodeModification on ""Gen. Posting Type"(Field 57).OnValidate". Please convert manually.

        //trigger  Posting Type"(Field 57)();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            if "Account Type" in ["Account Type"::Customer,"Account Type"::Vendor,"Account Type"::"Bank Account"] then
              TESTFIELD("Gen. Posting Type","Gen. Posting Type"::" ");
            if ("Gen. Posting Type" = "Gen. Posting Type"::Settlement) and (CurrFieldNo <> 0) then
              ERROR(Text006,"Gen. Posting Type");
            CheckVATInAlloc;
            if "Gen. Posting Type" > 0 then
              VALIDATE("VAT Prod. Posting Group");
            if "Gen. Posting Type" <> "Gen. Posting Type"::Purchase then
              VALIDATE("Use Tax",false)
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..5

            //NAVE111.0; 001; begin
            if LocalizationUsage.UseEastLocalization then
              case "Gen. Posting Type" of
                "Gen. Posting Type"::Sale:
                  begin
                    "VAT Type" := "VAT Type"::Sale;
                    if "VAT Protocol" then begin
                      SalesSetup.GET;
                      VALIDATE("VAT Bus. Posting Group",SalesSetup."EU VAT Bus. Posting Group");
                      if ("Bal. Gen. Posting Type" = "Bal. Gen. Posting Type"::Purchase) then
                        "VAT Type" := "VAT Type"::Purchase;
                    end;
                  end;
                "Gen. Posting Type"::Purchase:
                  "VAT Type" := "VAT Type"::Purchase;
              end;
            //NAVE111.0; 001; end

            #6..9
            */
        //end;


        //Unsupported feature: CodeInsertion on ""EU 3-Party Trade"(Field 61)". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //begin
            /*
            //NAVE111.0; 001; begin
            if not "EU 3-Party Trade" and LocalizationUsage.UseEastLocalization then
              "EU 3-Party Intermediate Role" := false;
            //NAVE111.0; 001; end
            */
        //end;


        //Unsupported feature: CodeModification on ""Bal. Gen. Posting Type"(Field 64).OnValidate". Please convert manually.

        //trigger  Gen();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            if "Bal. Account Type" in ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor,"Bal. Account Type"::"Bank Account"] then
              TESTFIELD("Bal. Gen. Posting Type","Bal. Gen. Posting Type"::" ");
            if ("Bal. Gen. Posting Type" = "Gen. Posting Type"::Settlement) and (CurrFieldNo <> 0) then
              ERROR(Text006,"Bal. Gen. Posting Type");
            if "Bal. Gen. Posting Type" > 0 then
              VALIDATE("Bal. VAT Prod. Posting Group");

            #8..12
            end;
            if "Bal. Gen. Posting Type" <> "Bal. Gen. Posting Type"::Purchase then
              VALIDATE("Bal. Use Tax",false);
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..4

            //NAVE111.0; 001; begin
            if LocalizationUsage.UseEastLocalization then begin
              case "Bal. Gen. Posting Type" of
                "Bal. Gen. Posting Type"::Purchase:
                  begin
                    "VAT Type" := "VAT Type"::Purchase;
                    if "VAT Protocol" then begin
                      PurchSetup.GET;
                      VALIDATE("Bal. VAT Bus. Posting Group",PurchSetup."EU VAT Bus. Posting Group");
                    end;
                  end;
                "Bal. Gen. Posting Type"::Sale:
                  "VAT Type" := "VAT Type"::Sale;
              end;
            end;
            //NAVE111.0; 001; end

            #5..15

            //NAVE111.0; 001; begin
            if LocalizationUsage.UseEastLocalization then begin
              VATExportSetup.GET;
              case "Bal. Gen. Posting Type" of
                "Bal. Gen. Posting Type"::Purchase:
                  "VAT Subject" := VATExportSetup."Purchase VAT Subject";
                "Bal. Gen. Posting Type"::Sale:
                  "VAT Subject" := VATExportSetup."Sales VAT Subject";
              end;
            end;
            //NAVE111.0; 001; end
            */
        //end;


        //Unsupported feature: CodeModification on ""VAT Prod. Posting Group"(Field 91).OnValidate". Please convert manually.

        //trigger  Posting Group"(Field 91)();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            if "Account Type" in ["Account Type"::Customer,"Account Type"::Vendor,"Account Type"::"Bank Account"] then
              TESTFIELD("VAT Prod. Posting Group",'');

            #4..14
                "VAT Calculation Type"::"Full VAT":
                  case "Gen. Posting Type" of
                    "Gen. Posting Type"::Sale:
                      TESTFIELD("Account No.",VATPostingSetup.GetSalesAccount(false));
                    "Gen. Posting Type"::Purchase:
                      TESTFIELD("Account No.",VATPostingSetup.GetPurchAccount(false));
                  end;
              end;
            end;
            #24..26
              CreateTempJobJnlLine;
              UpdatePricesFromJobJnlLine;
            end
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..17
                      //NAVE111.0; 001; begin
                      if not "VAT Protocol" and LocalizationUsage.UseEastLocalization then
                        TESTFIELD("Account No.",VATPostingSetup.GetSalesAccount(false))
                      else
                        if not LocalizationUsage.UseEastLocalization then
                        //NAVE111.0; 001; end
                          TESTFIELD("Account No.",VATPostingSetup.GetSalesAccount(false));
                    "Gen. Posting Type"::Purchase:
                        //NAVE111.0; 001; begin
                        if not "VAT Protocol" and LocalizationUsage.UseEastLocalization then
                          TESTFIELD("Account No.",VATPostingSetup.GetPurchAccount(false))
                        else
                          if not LocalizationUsage.UseEastLocalization then
                        //NAVE111.0; 001; end
                            TESTFIELD("Account No.",VATPostingSetup.GetPurchAccount(false));
            #21..29
            */
        //end;


        //Unsupported feature: CodeInsertion on ""Creditor No."(Field 170)". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //begin
            /*
            //NAVE111.0; 001; begin
            if ("Creditor No." <> '') and ("Recipient Bank Account" <> '') then
              FIELDERROR("Recipient Bank Account",
                STRSUBSTNO(FieldIsNotEmptyErr,FIELDCAPTION("Creditor No."),FIELDCAPTION("Recipient Bank Account")));
            //NAVE111.0; 001; end
            */
        //end;


        //Unsupported feature: CodeModification on ""Recipient Bank Account"(Field 288).OnValidate". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            if "Recipient Bank Account" = '' then
              exit;
            if ("Document Type" = "Document Type"::Invoice) and
               (("Account Type" in ["Account Type"::Customer,"Account Type"::Vendor]) or
                ("Bal. Account Type" in ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor]))
            then
              "Recipient Bank Account" := '';
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..7
            //NAVE111.0; 001; begin
            if ("Recipient Bank Account" <> '') and ("Creditor No." <> '') and LocalizationUsage.UseEastLocalization then
              FIELDERROR("Creditor No.",
                STRSUBSTNO(FieldIsNotEmptyErr,FIELDCAPTION("Recipient Bank Account"),FIELDCAPTION("Creditor No.")));
            //NAVE111.0; 001; end
            */
        //end;
        field(46015506;"Debit Memo";Boolean)
        {
            Caption = 'Debit Memo';
            Description = 'NAVBG11.0,001';
        }
        field(46015507;"Sales Protocol";Boolean)
        {
            Caption = 'Sales Protocol';
            Description = 'NAVBG11.0,001';
        }
        field(46015508;"Identification No.";Text[13])
        {
            Caption = 'Identification No.';
            Description = 'NAVBG11.0,001';
        }
        field(46015509;Void;Boolean)
        {
            Caption = 'Void';
            Description = 'NAVBG11.0,001';
        }
        field(46015510;"Void Date";Date)
        {
            Caption = 'Void Date';
            Description = 'NAVBG11.0,001';
        }
        field(46015511;"VAT Subject";Text[30])
        {
            Caption = 'VAT Subject';
            Description = 'NAVBG11.0,001';
        }
        field(46015512;"VAT Type";Option)
        {
            Caption = 'VAT Type';
            Description = 'NAVBG11.0,001';
            OptionCaption = '" ,Purchase,Sale"';
            OptionMembers = " ",Purchase,Sale;
        }
        field(46015513;"Bill-to/Pay-to Name";Text[50])
        {
            Caption = 'Bill-to/Pay-to Name';
            Description = 'NAVBG11.0,001';
        }
        field(46015515;"Do not include in VAT Ledgers";Boolean)
        {
            Caption = 'Do not include in VAT Ledgers';
            Description = 'NAVBG11.0,001';
        }
        field(46015525;"VAT Protocol";Boolean)
        {
            Caption = 'VAT Protocol';
            Description = 'NAVBG11.0,001';

            trigger OnValidate();
            begin
                if "VAT Protocol" then begin
                  GLSetup.GET;
                  "Posting No. Series" := GLSetup."Posted VAT Protocol Nos.";
                  VALIDATE("Currency Code",'');
                end else begin
                  GenJnlBatch.GET("Journal Template Name","Journal Batch Name");
                  "Posting No. Series" := GenJnlBatch."Posting No. Series";
                  "VAT Protocol Base Amount (LCY)" := 0;
                end;
            end;
        }
        field(46015527;"VAT Protocol Base Amount (LCY)";Decimal)
        {
            Caption = 'VAT Protocol Base Amount (LCY)';
            Description = 'NAVBG11.0,001';

            trigger OnValidate();
            var
                VATPostingSetup : Record "VAT Posting Setup";
            begin
                TESTFIELD("VAT Protocol");
                VATPostingSetup.GET("VAT Bus. Posting Group","VAT Prod. Posting Group");
                VALIDATE(Amount,ROUND("VAT Protocol Base Amount (LCY)" * VATPostingSetup."VAT %" / 100,GLSetup."Amount Rounding Precision"));
            end;
        }
        field(46015561;"Excise Amount";Decimal)
        {
            Caption = 'Excise Amount';
            Description = 'NAVBG11.0,001';
            Editable = false;
        }
        field(46015562;"Excise Amount (LCY)";Decimal)
        {
            Caption = 'Excise Amount (LCY)';
            Description = 'NAVBG11.0,001';

            trigger OnValidate();
            begin
                if "Currency Code" = '' then
                  "Excise Amount" := "Excise Amount (LCY)"
                else
                  "Excise Amount" :=
                    ROUND(
                      CurrExchRate.ExchangeAmtLCYToFCY(
                      "Posting Date","Currency Code",
                      "Excise Amount (LCY)","Currency Factor"));
            end;
        }
        field(46015563;"Source Currency Excise Amount";Decimal)
        {
            Caption = 'Source Currency Excise Amount';
            Description = 'NAVBG11.0,001';
        }
        field(46015564;"Product Tax Amount";Decimal)
        {
            Caption = 'Product Tax Amount';
            Description = 'NAVBG11.0,001';
            Editable = false;
        }
        field(46015565;"Product Tax Amount (LCY)";Decimal)
        {
            Caption = 'Product Tax Amount (LCY)';
            Description = 'NAVBG11.0,001';

            trigger OnValidate();
            begin
                if "Currency Code" = '' then
                  "Product Tax Amount" := "Product Tax Amount (LCY)"
                else
                  "Product Tax Amount" :=
                    ROUND(
                      CurrExchRate.ExchangeAmtLCYToFCY(
                      "Posting Date","Currency Code",
                      "Product Tax Amount (LCY)","Currency Factor"));
            end;
        }
        field(46015566;"Src. Curr. Product Tax Amount";Decimal)
        {
            Caption = 'Src. Curr. Product Tax Amount';
            Description = 'NAVBG11.0,001';
        }
        field(46015605;"Registration No.";Text[20])
        {
            Caption = 'Registration No.';
            Description = 'NAVE111.0,001';
        }
        field(46015606;"Registration No. 2";Text[20])
        {
            Caption = 'Registration No. 2';
            Description = 'NAVE111.0,001';
        }
        field(46015610;"VAT Date";Date)
        {
            Caption = 'VAT Date';
            Description = 'NAVE111.0,001';

            trigger OnValidate();
            begin
                GLSetup.GET;
                if not GLSetup."Use VAT Date" then
                  TESTFIELD("VAT Date","Posting Date");
                VALIDATE("VAT % (Non Deductible)",GetVATDeduction);
            end;
        }
        field(46015611;"Postponed VAT";Boolean)
        {
            Caption = 'Postponed VAT';
            Description = 'NAVE111.0,001';
        }
        field(46015615;Compensation;Boolean)
        {
            Caption = 'Compensation';
            Description = 'NAVE111.0,001';
        }
        field(46015619;"EU 3-Party Intermediate Role";Boolean)
        {
            Caption = 'EU 3-Party Intermediate Role';
            Description = 'NAVE111.0,001';

            trigger OnValidate();
            begin
                if "EU 3-Party Intermediate Role" then
                  "EU 3-Party Trade" := true;
            end;
        }
        field(46015625;"SAD No.";Code[20])
        {
            Caption = 'SAD No.';
            Description = 'NAVE111.0,001';
            TableRelation = IF ("Account Type"=CONST(Vendor)) "Import SAD Header" WHERE ("Vendor No."=FIELD("Account No."))
                            ELSE IF ("Account Type"=CONST(Customer)) "Export SAD Header" WHERE ("Customer No."=FIELD("Account No."))
                            ELSE IF ("Account Type"=CONST("G/L Account")) "Import SAD Header";

            trigger OnValidate();
            var
                ImportSADHeader : Record "Import SAD Header";
                ExportSADHeader : Record "Export SAD Header";
            begin
                if ("SAD No." <> '') then
                  if ("Account Type" = "Account Type"::Customer) and ExportSADHeader.GET("SAD No.") then begin
                    if ("Gen. Posting Type" = "Gen. Posting Type" ::Purchase) or
                      ("Bal. Gen. Posting Type" = "Gen. Posting Type" ::Purchase) then
                      if not CONFIRM(
                        Text003,true,
                        FIELDCAPTION("Document Date"),
                        TABLECAPTION,
                        "Document Date",
                        ExportSADHeader."SAD Date")
                      then
                        ERROR(Text005);

                    VALIDATE("Document Date",ExportSADHeader."SAD Date");
                  end else
                    if ("Account Type" = "Account Type"::Vendor) and ImportSADHeader.GET("SAD No.") then begin
                      if ("Gen. Posting Type" = "Gen. Posting Type" ::Purchase) or
                        ("Bal. Gen. Posting Type" = "Gen. Posting Type" ::Purchase) then
                        if not CONFIRM(
                          Text003,true,
                          FIELDCAPTION("Document Date"),
                          TABLECAPTION,
                          "Document Date",
                          ImportSADHeader."SAD Date")
                        then
                          ERROR(Text005);

                      VALIDATE("Document Date",ImportSADHeader."SAD Date");

                    end;
                    if ("Account Type" = "Account Type"::"G/L Account") and ImportSADHeader.GET("SAD No.") then begin
                      VALIDATE("Bill-to/Pay-to Name", ImportSADHeader."Vendor Name");
                      VALIDATE("Document Date",ImportSADHeader."SAD Date");
                    end;

                if ("SAD No." = '') then
                  VALIDATE("Bill-to/Pay-to Name", '');
            end;
        }
        field(46015626;"Customs Procedure Code";Code[10])
        {
            Caption = 'Customs Procedure Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Custom Procedure".Code;
        }
        field(46015635;"VAT % (Non Deductible)";Decimal)
        {
            Caption = 'VAT % (Non Deductible)';
            Description = 'NAVE111.0,001';
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate();
            begin
                VALIDATE("VAT Base (Non Deductible)",
                  ROUND("VAT Base Amount" * "VAT % (Non Deductible)" / 100,Currency."Amount Rounding Precision"));
                VALIDATE("VAT Amount (Non Deductible)",
                  ROUND("VAT Base (Non Deductible)" * "VAT %" / 100,Currency."Amount Rounding Precision"));
            end;
        }
        field(46015636;"VAT Base (Non Deductible)";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            Caption = 'VAT Base (Non Deductible)';
            Description = 'NAVE111.0,001';
            Editable = false;

            trigger OnValidate();
            begin
                if "Currency Code" = '' then
                  "VAT Base LCY (Non Deduct.)" := "VAT Base (Non Deductible)"
                else
                  "VAT Base LCY (Non Deduct.)" :=
                    ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Posting Date","Currency Code",
                        "VAT Base (Non Deductible)","Currency Factor"));
            end;
        }
        field(46015637;"VAT Amount (Non Deductible)";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            Caption = 'VAT Amount (Non Deductible)';
            Description = 'NAVE111.0,001';
            Editable = false;

            trigger OnValidate();
            begin
                if "Currency Code" = '' then
                  "VAT Amount LCY (Non Deduct.)" := "VAT Amount (Non Deductible)"
                else
                  "VAT Amount LCY (Non Deduct.)" :=
                    ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Posting Date","Currency Code",
                        "VAT Amount (Non Deductible)","Currency Factor"));
            end;
        }
        field(46015638;"VAT Base LCY (Non Deduct.)";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'VAT Base LCY (Non Deduct.)';
            Description = 'NAVE111.0,001';
            Editable = false;
        }
        field(46015639;"VAT Amount LCY (Non Deduct.)";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'VAT Amount LCY (Non Deduct.)';
            Description = 'NAVE111.0,001';
        }
        field(46015645;"Cash Order Type";Option)
        {
            Caption = 'Cash Order Type';
            Description = 'NAVE111.0,001';
            OptionCaption = '" ,Receipt,Withdrawal"';
            OptionMembers = " ",Receipt,Withdrawal;
        }
        field(46015646;"Cash Desk Report No.";Code[20])
        {
            Caption = 'Cash Desk Report No.';
            Description = 'NAVE111.0,001';
        }
        field(46015700;"Unrealized VAT";Boolean)
        {
            Caption = 'Unrealized VAT';
            Description = 'NAVBG11.0,001';
        }
        field(46015805;"Balance G/L Account";Code[20])
        {
            Caption = 'Balance G/L Account';
            Description = 'DS11.00,001';
            TableRelation = "G/L Account";
        }
        field(46015806;"Single Entry";Boolean)
        {
            Caption = 'Single Entry';
            Description = 'DS11.00,001';
            InitValue = false;
        }
        field(46015807;"Balance Entry No.";Integer)
        {
            Caption = 'Balance Entry No.';
            Description = 'DS11.00,001';
        }
        field(46015808;"Balance Entry";Boolean)
        {
            Caption = 'Balance Entry';
            Description = 'DS11.00,001';
        }
        field(46015809;"Group Entry";Boolean)
        {
            Caption = 'Group Entry';
            Description = 'DS11.00,001';
        }
        field(46015810;"Debit/Credit Type";Option)
        {
            Caption = 'Debit/Credit Type';
            Description = 'DS11.00,001';
            OptionMembers = " ",Debit,Credit;
        }
    }
    keys
    {
        key(Key1;"Document No.","Posting Date","Currency Code")
        {
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
        GLAcc : Record "G/L Account";

    var
        VATExportSetup : Record "VAT Export Setup";

    var
        VATExportSetup : Record "VAT Export Setup";

    var
        OK : Boolean;
        SalesSetup : Record "Sales & Receivables Setup";
        SubstCustPostingGrp : Record "Subst. Customer Posting Group";
        PurchSetup : Record "Purchases & Payables Setup";
        SubstVendPostingGrp : Record "Subst. Vendor Posting Group";
        VATExportSetup : Record "VAT Export Setup";
        LocalizationUsage : Codeunit "Localization Usage";
        FieldIsNotEmptyErr : Label '%1 cannot be used while %2 has a value.';
        Text46012225 : Label 'You cannot change the %1 to %2 because %3 has not been filled in.';
        Text46012226 : Label 'You cannot change %1 until %2 will be checked in setup.';
        Text46012126 : Label '%1 will be replaced with %2 from %3';
        Text003 : TextConst Comment='%1=Caption of Currency Code field, %2=Caption of table Gen Journal, %3=FromCurrencyCode, %4=ToCurrencyCode',ENU='The %1 in the %2 will be changed from %3 to %4.\\Do you want to continue?';
        Text005 : Label 'The update has been interrupted to respect the warning.';
}

