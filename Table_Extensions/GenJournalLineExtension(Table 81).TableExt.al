tableextension 46015603 "Gen. Journal Line Extension" extends "Gen. Journal Line"
{
    // version NAVW111.00.00.27667,NAVE111.0,NAVBG11.0,DS11.00
    //TODO:
    //VAT Prod. Posting Group - OnValidate

    fields
    {
        modify("Account Type")
        {
            trigger OnAfterValidate()
            begin
                if ("Account Type" = "Account Type"::"IC Partner") and
                    ("Bal. Account Type" = "Bal. Account Type"::"G/L Account") and
                    GLAcc.GET("Bal. Account No.")
                then
                    "IC Partner G/L Acc. No." := GLAcc."Default IC Partner G/L Acc. No"
                else
                    "IC Partner G/L Acc. No." := '';
                MODIFY;
            end;
        }
        modify("Posting Date")
        {
            trigger OnBeforeValidate()
            begin
                VALIDATE("VAT Date", "Posting Date");
            end;
        }
        modify("VAT %")
        {
            trigger OnAfterValidate()
            begin
                VALIDATE("VAT % (Non Deductible)", GetVATDeduction);
                MODIFY;
            end;
        }
        modify("Currency Code")
        {
            trigger OnBeforeValidate()
            begin
                if "VAT Protocol" then
                    TESTFIELD("Currency Code", '');
            end;
        }
        modify(Amount)
        {
            trigger OnAfterValidate()
            var
                VATPostingSetup: Record "VAT Posting Setup";
                GLSetup: Record "General Ledger Setup";
            begin
                if "VAT Protocol" then begin
                    GLSetup.GET;
                    if VATPostingSetup.GET("VAT Bus. Posting Group", "VAT Prod. Posting Group") then
                        if VATPostingSetup."VAT %" <> 0 then
                            "VAT Protocol Base Amount (LCY)" :=
                              ROUND("Amount (LCY)" / VATPostingSetup."VAT %" * 100, GLSetup."Amount Rounding Precision");
                    MODIFY;
                end;
            end;
        }
        modify("Posting Group")
        {
            trigger OnBeforeValidate()
            var
                Cust: Record Customer;
                Vend: Record Vendor;
            begin
                if (CurrFieldNo = FIELDNO("Posting Group")) then begin
                    case "Account Type" of
                        "Account Type"::Customer:
                            begin
                                SalesSetup.GET;
                                if SalesSetup."Allow Alter Posting Groups" then begin
                                    Cust.GET("Account No.");
                                    if not SubstCustPostingGrp.GET(xRec."Posting Group", "Posting Group") and
                                      ("Posting Group" <> Cust."Customer Posting Group")
                                    then
                                        ERROR(Text46012225, xRec."Posting Group", "Posting Group", SubstCustPostingGrp.TABLECAPTION);
                                end else
                                    if xRec."Posting Group" <> "Posting Group" then
                                        ERROR(Text46012226, FIELDCAPTION("Posting Group"), SalesSetup.FIELDCAPTION("Allow Alter Posting Groups"));
                            end;
                        "Account Type"::Vendor:
                            begin
                                PurchSetup.GET;
                                if PurchSetup."Allow Alter Posting Groups" then begin
                                    Vend.GET("Account No.");
                                    if not SubstVendPostingGrp.GET(xRec."Posting Group", "Posting Group") and
                                      ("Posting Group" <> Vend."Vendor Posting Group")
                                    then
                                        ERROR(Text46012225, xRec."Posting Group", "Posting Group", SubstVendPostingGrp.TABLECAPTION);
                                end else
                                    if xRec."Posting Group" <> "Posting Group" then
                                        ERROR(Text46012226, FIELDCAPTION("Posting Group"), PurchSetup.FIELDCAPTION("Allow Alter Posting Groups"));
                            end;
                        else
                            ERROR(Text010, FIELDCAPTION("Account Type"), "Account Type"::Customer, "Account Type"::Vendor);
                    end;
                end;
            end;
        }
        modify("VAT Amount")
        {
            trigger OnAfterValidate()
            begin
                VALIDATE("VAT % (Non Deductible)", GetVATDeduction);
                MODIFY;
            end;
        }
        modify("Gen. Posting Type")
        {
            trigger OnAfterValidate()
            begin
                case "Gen. Posting Type" of
                    "Gen. Posting Type"::Sale:
                        begin
                            "VAT Type" := "VAT Type"::Sale;
                            if "VAT Protocol" then begin
                                SalesSetup.GET;
                                VALIDATE("VAT Bus. Posting Group", SalesSetup."EU VAT Bus. Posting Group");
                                if ("Bal. Gen. Posting Type" = "Bal. Gen. Posting Type"::Purchase) then
                                    "VAT Type" := "VAT Type"::Purchase;
                            end;
                        end;
                    "Gen. Posting Type"::Purchase:
                        "VAT Type" := "VAT Type"::Purchase;
                end;
                MODIFY;
            end;
        }
        modify("EU 3-Party Trade")
        {
            trigger OnBeforeValidate()
            begin
                if not "EU 3-Party Trade" then
                    "EU 3-Party Intermediate Role" := false;
            end;
        }
        modify("Bal. Gen. Posting Type")
        {
            trigger OnAfterValidate()
            begin
                case "Bal. Gen. Posting Type" of
                    "Bal. Gen. Posting Type"::Purchase:
                        begin
                            "VAT Type" := "VAT Type"::Purchase;
                            if "VAT Protocol" then begin
                                PurchSetup.GET;
                                VALIDATE("Bal. VAT Bus. Posting Group", PurchSetup."EU VAT Bus. Posting Group");
                            end;
                        end;
                    "Bal. Gen. Posting Type"::Sale:
                        "VAT Type" := "VAT Type"::Sale;
                end;
                VATExportSetup.GET;
                case "Bal. Gen. Posting Type" of
                    "Bal. Gen. Posting Type"::Purchase:
                        "VAT Subject" := VATExportSetup."Purchase VAT Subject";
                    "Bal. Gen. Posting Type"::Sale:
                        "VAT Subject" := VATExportSetup."Sales VAT Subject";
                end;
                MODIFY;
            end;
        }
        modify("Creditor No.")
        {
            trigger OnBeforeValidate()
            begin
                if ("Creditor No." <> '') and ("Recipient Bank Account" <> '') then
                    FIELDERROR("Recipient Bank Account",
                      STRSUBSTNO(FieldIsNotEmptyErr, FIELDCAPTION("Creditor No."), FIELDCAPTION("Recipient Bank Account")));
            end;
        }
        modify("Recipient Bank Account")
        {
            trigger OnBeforeValidate()
            begin
                if "Recipient Bank Account" = '' then
                    exit;
                if ("Document Type" = "Document Type"::Invoice) and
                    (("Account Type" in ["Account Type"::Customer, "Account Type"::Vendor]) or
                    ("Bal. Account Type" in ["Bal. Account Type"::Customer, "Bal. Account Type"::Vendor]))
                then
                    "Recipient Bank Account" := '';
                if ("Recipient Bank Account" <> '') and ("Creditor No." <> '') then
                    FIELDERROR("Creditor No.",
                      STRSUBSTNO(FieldIsNotEmptyErr, FIELDCAPTION("Recipient Bank Account"), FIELDCAPTION("Creditor No.")));
            end;
        }
        modify("Bill-to/Pay-to No.")
        {
            trigger OnAfterValidate()
            var
                Cust: Record Customer;
                Vend: Record Vendor;
            begin
                IF "Bill-to/Pay-to No." = '' THEN
                    "Registration No." := '';
                CASE TRUE OF
                    "VAT Protocol" AND ("Bal. Gen. Posting Type" = "Bal. Gen. Posting Type"::" ") OR
                    ("Account Type" = "Account Type"::Customer) OR ("Bal. Account Type" = "Bal. Account Type"::Customer):
                        BEGIN
                            Cust.GET("Bill-to/Pay-to No.");
                            "Country/Region Code" := Cust."Country/Region Code";
                            "VAT Registration No." := Cust."VAT Registration No.";
                            "Registration No." := Cust."Registration No.";
                        END;

                    "VAT Protocol" AND ("Bal. Gen. Posting Type" = "Bal. Gen. Posting Type"::Purchase) OR
                    ("Account Type" = "Account Type"::Vendor) OR ("Bal. Account Type" = "Bal. Account Type"::Vendor):
                        BEGIN
                            Vend.GET("Bill-to/Pay-to No.");
                            "Country/Region Code" := Vend."Country/Region Code";
                            "VAT Registration No." := Vend."VAT Registration No.";
                            "Registration No." := Vend."Registration No.";
                        END;
                END;
                MODIFY;
            end;
        }
        modify("Sell-to/Buy-from No.")
        {
            trigger OnAfterValidate()
            var
                Cust: Record Customer;
                Vend: Record Vendor;
            begin
                IF "Bill-to/Pay-to No." = '' THEN
                    "Registration No." := '';
                CASE TRUE OF
                    "VAT Protocol" AND ("Bal. Gen. Posting Type" = "Bal. Gen. Posting Type"::" ") OR
                    ("Account Type" = "Account Type"::Customer) OR ("Bal. Account Type" = "Bal. Account Type"::Customer):
                        BEGIN
                            Cust.GET("Bill-to/Pay-to No.");
                            "Country/Region Code" := Cust."Country/Region Code";
                            "VAT Registration No." := Cust."VAT Registration No.";
                            "Registration No." := Cust."Registration No.";
                        END;

                    "VAT Protocol" AND ("Bal. Gen. Posting Type" = "Bal. Gen. Posting Type"::Purchase) OR
                    ("Account Type" = "Account Type"::Vendor) OR ("Bal. Account Type" = "Bal. Account Type"::Vendor):
                        BEGIN
                            Vend.GET("Bill-to/Pay-to No.");
                            "Country/Region Code" := Vend."Country/Region Code";
                            "VAT Registration No." := Vend."VAT Registration No.";
                            "Registration No." := Vend."Registration No.";
                        END;
                END;
                MODIFY;
            end;
        }

        field(46015506; "Debit Memo"; Boolean)
        {
            Caption = 'Debit Memo';
            Description = 'NAVBG11.0,001';
        }
        field(46015507; "Sales Protocol"; Boolean)
        {
            Caption = 'Sales Protocol';
            Description = 'NAVBG11.0,001';
        }
        field(46015508; "Identification No."; Text[13])
        {
            Caption = 'Identification No.';
            Description = 'NAVBG11.0,001';
        }
        field(46015509; Void; Boolean)
        {
            Caption = 'Void';
            Description = 'NAVBG11.0,001';
        }
        field(46015510; "Void Date"; Date)
        {
            Caption = 'Void Date';
            Description = 'NAVBG11.0,001';
        }
        field(46015511; "VAT Subject"; Text[30])
        {
            Caption = 'VAT Subject';
            Description = 'NAVBG11.0,001';
        }
        field(46015512; "VAT Type"; Option)
        {
            Caption = 'VAT Type';
            Description = 'NAVBG11.0,001';
            OptionCaption = '" ,Purchase,Sale"';
            OptionMembers = " ",Purchase,Sale;
        }
        field(46015513; "Bill-to/Pay-to Name"; Text[50])
        {
            Caption = 'Bill-to/Pay-to Name';
            Description = 'NAVBG11.0,001';
        }
        field(46015515; "Do not include in VAT Ledgers"; Boolean)
        {
            Caption = 'Do not include in VAT Ledgers';
            Description = 'NAVBG11.0,001';
        }
        field(46015525; "VAT Protocol"; Boolean)
        {
            Caption = 'VAT Protocol';
            Description = 'NAVBG11.0,001';

            trigger OnValidate();
            var
                GLSetup: Record "General Ledger Setup";
                GenJnlBatch: Record "Gen. Journal Batch";

            begin
                if "VAT Protocol" then begin
                    GLSetup.GET;
                    "Posting No. Series" := GLSetup."Posted VAT Protocol Nos.";
                    VALIDATE("Currency Code", '');
                end else begin
                    GenJnlBatch.GET("Journal Template Name", "Journal Batch Name");
                    "Posting No. Series" := GenJnlBatch."Posting No. Series";
                    "VAT Protocol Base Amount (LCY)" := 0;
                end;
            end;
        }
        field(46015527; "VAT Protocol Base Amount (LCY)"; Decimal)
        {
            Caption = 'VAT Protocol Base Amount (LCY)';
            Description = 'NAVBG11.0,001';

            trigger OnValidate();
            var
                VATPostingSetup: Record "VAT Posting Setup";
                GLSetup: Record "General Ledger Setup";
            begin
                TESTFIELD("VAT Protocol");
                GLSetup.GET;
                VATPostingSetup.GET("VAT Bus. Posting Group", "VAT Prod. Posting Group");
                VALIDATE(Amount, ROUND("VAT Protocol Base Amount (LCY)" * VATPostingSetup."VAT %" / 100, GLSetup."Amount Rounding Precision"));
            end;
        }
        field(46015561; "Excise Amount"; Decimal)
        {
            Caption = 'Excise Amount';
            Description = 'NAVBG11.0,001';
            Editable = false;
        }
        field(46015562; "Excise Amount (LCY)"; Decimal)
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
                        "Posting Date", "Currency Code",
                        "Excise Amount (LCY)", "Currency Factor"));
            end;
        }
        field(46015563; "Source Currency Excise Amount"; Decimal)
        {
            Caption = 'Source Currency Excise Amount';
            Description = 'NAVBG11.0,001';
        }
        field(46015564; "Product Tax Amount"; Decimal)
        {
            Caption = 'Product Tax Amount';
            Description = 'NAVBG11.0,001';
            Editable = false;
        }
        field(46015565; "Product Tax Amount (LCY)"; Decimal)
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
                        "Posting Date", "Currency Code",
                        "Product Tax Amount (LCY)", "Currency Factor"));
            end;
        }
        field(46015566; "Src. Curr. Product Tax Amount"; Decimal)
        {
            Caption = 'Src. Curr. Product Tax Amount';
            Description = 'NAVBG11.0,001';
        }
        field(46015605; "Registration No."; Text[20])
        {
            Caption = 'Registration No.';
            Description = 'NAVE111.0,001';
        }
        field(46015606; "Registration No. 2"; Text[20])
        {
            Caption = 'Registration No. 2';
            Description = 'NAVE111.0,001';
        }
        field(46015610; "VAT Date"; Date)
        {
            Caption = 'VAT Date';
            Description = 'NAVE111.0,001';

            trigger OnValidate();
            var
                GLSetup: Record "General Ledger Setup";
            begin
                GLSetup.GET;
                if not GLSetup."Use VAT Date" then
                    TESTFIELD("VAT Date", "Posting Date");
                VALIDATE("VAT % (Non Deductible)", GetVATDeduction);
            end;
        }
        field(46015611; "Postponed VAT"; Boolean)
        {
            Caption = 'Postponed VAT';
            Description = 'NAVE111.0,001';
        }
        field(46015615; Compensation; Boolean)
        {
            Caption = 'Compensation';
            Description = 'NAVE111.0,001';
        }
        field(46015619; "EU 3-Party Intermediate Role"; Boolean)
        {
            Caption = 'EU 3-Party Intermediate Role';
            Description = 'NAVE111.0,001';

            trigger OnValidate();
            begin
                if "EU 3-Party Intermediate Role" then
                    "EU 3-Party Trade" := true;
            end;
        }
        field(46015625; "SAD No."; Code[20])
        {
            Caption = 'SAD No.';
            Description = 'NAVE111.0,001';
            TableRelation = IF ("Account Type" = CONST(Vendor)) "Import SAD Header" WHERE("Vendor No." = FIELD("Account No."))
            ELSE
            IF ("Account Type" = CONST(Customer)) "Export SAD Header" WHERE("Customer No." = FIELD("Account No."))
            ELSE
            IF ("Account Type" = CONST("G/L Account")) "Import SAD Header";

            trigger OnValidate();
            var
                ImportSADHeader: Record "Import SAD Header";
                ExportSADHeader: Record "Export SAD Header";
            begin
                if ("SAD No." <> '') then
                    if ("Account Type" = "Account Type"::Customer) and ExportSADHeader.GET("SAD No.") then begin
                        if ("Gen. Posting Type" = "Gen. Posting Type"::Purchase) or
                          ("Bal. Gen. Posting Type" = "Gen. Posting Type"::Purchase) then
                            if not CONFIRM(
                              Text003, true,
                              FIELDCAPTION("Document Date"),
                              TABLECAPTION,
                              "Document Date",
                              ExportSADHeader."SAD Date")
                            then
                                ERROR(Text005);

                        VALIDATE("Document Date", ExportSADHeader."SAD Date");
                    end else
                        if ("Account Type" = "Account Type"::Vendor) and ImportSADHeader.GET("SAD No.") then begin
                            if ("Gen. Posting Type" = "Gen. Posting Type"::Purchase) or
                              ("Bal. Gen. Posting Type" = "Gen. Posting Type"::Purchase) then
                                if not CONFIRM(
                                  Text003, true,
                                  FIELDCAPTION("Document Date"),
                                  TABLECAPTION,
                                  "Document Date",
                                  ImportSADHeader."SAD Date")
                                then
                                    ERROR(Text005);

                            VALIDATE("Document Date", ImportSADHeader."SAD Date");

                        end;
                if ("Account Type" = "Account Type"::"G/L Account") and ImportSADHeader.GET("SAD No.") then begin
                    VALIDATE("Bill-to/Pay-to Name", ImportSADHeader."Vendor Name");
                    VALIDATE("Document Date", ImportSADHeader."SAD Date");
                end;

                if ("SAD No." = '') then
                    VALIDATE("Bill-to/Pay-to Name", '');
            end;
        }
        field(46015626; "Customs Procedure Code"; Code[10])
        {
            Caption = 'Customs Procedure Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Custom Procedure".Code;
        }
        field(46015635; "VAT % (Non Deductible)"; Decimal)
        {
            Caption = 'VAT % (Non Deductible)';
            Description = 'NAVE111.0,001';
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate();
            var
                Currency: Record Currency;
            begin
                Currency.GET("Currency Code");
                VALIDATE("VAT Base (Non Deductible)",
                  ROUND("VAT Base Amount" * "VAT % (Non Deductible)" / 100, Currency."Amount Rounding Precision"));
                VALIDATE("VAT Amount (Non Deductible)",
                  ROUND("VAT Base (Non Deductible)" * "VAT %" / 100, Currency."Amount Rounding Precision"));
            end;
        }
        field(46015636; "VAT Base (Non Deductible)"; Decimal)
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
                          "Posting Date", "Currency Code",
                          "VAT Base (Non Deductible)", "Currency Factor"));
            end;
        }
        field(46015637; "VAT Amount (Non Deductible)"; Decimal)
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
                          "Posting Date", "Currency Code",
                          "VAT Amount (Non Deductible)", "Currency Factor"));

            end;
        }
        field(46015638; "VAT Base LCY (Non Deduct.)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'VAT Base LCY (Non Deduct.)';
            Description = 'NAVE111.0,001';
            Editable = false;
        }
        field(46015639; "VAT Amount LCY (Non Deduct.)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'VAT Amount LCY (Non Deduct.)';
            Description = 'NAVE111.0,001';
        }
        field(46015645; "Cash Order Type"; Option)
        {
            Caption = 'Cash Order Type';
            Description = 'NAVE111.0,001';
            OptionCaption = '" ,Receipt,Withdrawal"';
            OptionMembers = " ",Receipt,Withdrawal;
        }
        field(46015646; "Cash Desk Report No."; Code[20])
        {
            Caption = 'Cash Desk Report No.';
            Description = 'NAVE111.0,001';
        }
        field(46015700; "Unrealized VAT"; Boolean)
        {
            Caption = 'Unrealized VAT';
            Description = 'NAVBG11.0,001';
        }
        field(46015805; "Balance G/L Account"; Code[20])
        {
            Caption = 'Balance G/L Account';
            Description = 'DS11.00,001';
            TableRelation = "G/L Account";
        }
        field(46015806; "Single Entry"; Boolean)
        {
            Caption = 'Single Entry';
            Description = 'DS11.00,001';
            InitValue = false;
        }
        field(46015807; "Balance Entry No."; Integer)
        {
            Caption = 'Balance Entry No.';
            Description = 'DS11.00,001';
        }
        field(46015808; "Balance Entry"; Boolean)
        {
            Caption = 'Balance Entry';
            Description = 'DS11.00,001';
        }
        field(46015809; "Group Entry"; Boolean)
        {
            Caption = 'Group Entry';
            Description = 'DS11.00,001';
        }
        field(46015810; "Debit/Credit Type"; Option)
        {
            Caption = 'Debit/Credit Type';
            Description = 'DS11.00,001';
            OptionMembers = " ",Debit,Credit;
        }
    }
    keys
    {
        //TODO
        /*
          key(Key1;"Document No.","Posting Date","Currency Code")
          {
          }
        */
    }
    var
        CurrExchRate: Record "Currency Exchange Rate";
        GLAcc: Record "G/L Account";
        OK: Boolean;
        SalesSetup: Record "Sales & Receivables Setup";
        SubstCustPostingGrp: Record "Subst. Customer Posting Group";
        PurchSetup: Record "Purchases & Payables Setup";
        SubstVendPostingGrp: Record "Subst. Vendor Posting Group";
        VATExportSetup: Record "VAT Export Setup";
        Text010: Label '%1 must be %2 or %3.';
        FieldIsNotEmptyErr: Label '%1 cannot be used while %2 has a value.';
        Text46012225: Label 'You cannot change the %1 to %2 because %3 has not been filled in.';
        Text46012226: Label 'You cannot change %1 until %2 will be checked in setup.';
        Text46012126: Label '%1 will be replaced with %2 from %3';
        Text003: TextConst Comment = '%1=Caption of Currency Code field, %2=Caption of table Gen Journal, %3=FromCurrencyCode, %4=ToCurrencyCode', ENU = 'The %1 in the %2 will be changed from %3 to %4.\\Do you want to continue?';
        Text005: Label 'The update has been interrupted to respect the warning.';

    procedure GetVATDeduction(): Decimal;
    var
        NonDeductVATSetup: Record "Non Deductible VAT Setup";
        VATPostingSetup2: Record "VAT Posting Setup";
    begin
        if VATPostingSetup2.GET("VAT Bus. Posting Group", "VAT Prod. Posting Group") and
           (VATPostingSetup2."VAT Calculation Type" = VATPostingSetup2."VAT Calculation Type"::"Normal VAT") and
           VATPostingSetup2."Allow Non Deductible VAT"
        then begin
            NonDeductVATSetup.RESET;
            NonDeductVATSetup.SETRANGE("VAT Bus. Posting Group", VATPostingSetup2."VAT Bus. Posting Group");
            NonDeductVATSetup.SETRANGE("VAT Prod. Posting Group", VATPostingSetup2."VAT Prod. Posting Group");
            NonDeductVATSetup.SETRANGE("From Date", 0D, "VAT Date");
            if NonDeductVATSetup.FINDLAST then begin
                NonDeductVATSetup.TESTFIELD("Non Deductible VAT %");
                exit(NonDeductVATSetup."Non Deductible VAT %");
            end
        end;
        exit(0);
    end;
}

