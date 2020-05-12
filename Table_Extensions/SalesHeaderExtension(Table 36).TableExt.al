tableextension 46015561 "Sales Header Extension" extends "Sales Header"
{
    // version NAVW111.00.00.28629,NAVE110.0,NAVBG10.0

    //TODO

    fields
    {

        //Unsupported feature: CodeModification on ""Sell-to Customer No."(Field 2).OnValidate". Please convert manually.

        //trigger "(Field 2)();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        CheckCreditLimitIfLineNotInsertedYet;
        if "No." = '' then
          InitRecord;
        #4..75
        "Responsibility Center" := UserSetupMgt.GetRespCenter(0,Cust."Responsibility Center");
        VALIDATE("Location Code",UserSetupMgt.GetLocation(0,Cust."Location Code","Responsibility Center"));

        if "Sell-to Customer No." = xRec."Sell-to Customer No." then
          if ShippedSalesLinesExist or ReturnReceiptExist then begin
            TESTFIELD("VAT Bus. Posting Group",xRec."VAT Bus. Posting Group");
        #82..108

        if (xRec."Sell-to Customer No." <> '') and (xRec."Sell-to Customer No." <> "Sell-to Customer No.") then
          RecallModifyAddressNotification(GetModifyCustomerAddressNotificationId);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..78
        //NAVE110.0; 001; begin
        if LocalizationUsage.UseEastLocalization then begin
          "Registration No." := Cust."Registration No.";
          "Registration No. 2" := Cust."Registration No. 2";
          "Identification No." := Cust."Identification No.";

          VALIDATE("Transaction Type",Cust."Transaction Type");
          VALIDATE("Transaction Specification",Cust."Transaction Specification");
          VALIDATE("Transport Method",Cust."Transport Method");
          if "Document Type" in ["Document Type"::"Return Order","Document Type"::"Credit Memo"] then
            VALIDATE("Shipment Method Code",Cust."Shipment Method Code");
        end;
        //NAVE110.0; 001; end

        #79..111
        //NAVBG10.0; 001; begin
        if LocalizationUsage.UseEastLocalization then begin
          if "Sell-to Customer No." <> xRec."Sell-to Customer No." then
            begin
              ExciseTaxDoc.SETCURRENTKEY("Document Type","Corresponding Doc. No.");
              ExciseTaxDoc.SETRANGE(ExciseTaxDoc."Corresponding Doc. No.","No.");
              ExciseTaxDoc.SETRANGE(ExciseTaxDoc."Document Type","Document Type");
              if ExciseTaxDoc.FINDFIRST then begin
                ExciseTaxDoc.VALIDATE(ExciseTaxDoc."Sell-to Customer No.","Sell-to Customer No.");
                ExciseTaxDoc.VALIDATE(ExciseTaxDoc."Sell-to Customer Name","Sell-to Customer Name");
                ExciseTaxDoc.MODIFY;
              end;
            end;
          "Calculate Excise" := not Cust."Do not calculate Excise";
        end;
        //NAVBG10.0; 001; end
        */
        //end;


        //Unsupported feature: CodeModification on ""Bill-to Customer No."(Field 4).OnValidate". Please convert manually.

        //trigger "(Field 4)();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        TESTFIELD(Status,Status::Open);
        BilltoCustomerNoChanged := xRec."Bill-to Customer No." <> "Bill-to Customer No.";
        if BilltoCustomerNoChanged then
        #4..24
        Cust.CheckBlockedCustOnDocs(Cust,"Document Type",false,false);
        Cust.TESTFIELD("Customer Posting Group");
        PostingSetupMgt.CheckCustPostingGroupReceivablesAccount("Customer Posting Group");
        CheckCrLimit;
        "Bill-to Customer Template Code" := '';
        "Bill-to Name" := Cust.Name;
        "Bill-to Name 2" := Cust."Name 2";
        CopyBillToCustomerAddressFieldsFromCustomer(Cust);
        if not SkipBillToContact then
          "Bill-to Contact" := Cust.Contact;
        "Payment Terms Code" := Cust."Payment Terms Code";
        #36..49
          "VAT Registration No." := Cust."VAT Registration No.";
          "Gen. Bus. Posting Group" := Cust."Gen. Bus. Posting Group";
        end;
        "Customer Posting Group" := Cust."Customer Posting Group";
        "Currency Code" := Cust."Currency Code";
        "Customer Price Group" := Cust."Customer Price Group";
        #56..97

        if (xRec."Bill-to Customer No." <> '') and (xRec."Bill-to Customer No." <> "Bill-to Customer No.") then
          RecallModifyAddressNotification(GetModifyBillToCustomerAddressNotificationId);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..27

        //NAVE110.0; 001; begin
        if LocalizationUsage.UseEastLocalization then
          if GUIALLOWED and (CurrFieldNo <> 0) and ("Document Type" <= "Document Type"::Invoice) then begin
            "Amount Including VAT" := 0;
            case "Document Type" of
              "Document Type"::Quote,"Document Type"::Invoice:
                CustCheckCreditLimit.SalesHeaderCheck(Rec);
              "Document Type"::Order:
                begin
                  if "Bill-to Customer No." <> xRec."Bill-to Customer No." then begin
                    SalesLine.SETRANGE("Document Type",SalesLine."Document Type"::Order);
                    SalesLine.SETRANGE("Document No.","No.");
                    SalesLine.CALCSUMS("Outstanding Amount","Shipped Not Invoiced");
                    "Amount Including VAT" := SalesLine."Outstanding Amount" + SalesLine."Shipped Not Invoiced";
                  end;
                  CustCheckCreditLimit.SalesHeaderCheck(Rec);
                end;
            end;
            CALCFIELDS("Amount Including VAT");
          end;
        //NAVE110.0; 001; end

        #28..32

        //NAVE110.0; 001; begin
        if LocalizationUsage.UseEastLocalization then begin
          "VAT Country/Region Code" := Cust."Country/Region Code";
          "VAT Registration No." := Cust."VAT Registration No.";
          "Industry Code" := Cust."Industry Code";
          "Registration No." := Cust."Registration No.";
          "Identification No." := Cust."Identification No.";
        end;
        //NAVE110.0; 001; end

        #33..52

          //NAVBG10.0; 001; begin
          if LocalizationUsage.UseBulgarianLocalization then
            VALIDATE( "VAT Bus. Posting Group", Cust."VAT Bus. Posting Group" );
          //NAVBG10.0; 001; end

        #53..100
        */
        //end;


        //Unsupported feature: CodeModification on ""Posting Date"(Field 20).OnValidate". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        TESTFIELD("Posting Date");
        TestNoSeriesDate(
          "Posting No.","Posting No. Series",
        #4..11
        if "Incoming Document Entry No." = 0 then
          VALIDATE("Document Date","Posting Date");

        if ("Document Type" in ["Document Type"::Invoice,"Document Type"::"Credit Memo"]) and
           not ("Posting Date" = xRec."Posting Date")
        then
        #18..26
          if DeferralHeadersExist then
            ConfirmUpdateDeferralDate;
        SynchronizeAsmHeader;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..14
        //NAVE110.0; 001; begin
        if LocalizationUsage.UseEastLocalization then begin
          SalesSetup.GET;
          if SalesSetup."Default VAT Date" = SalesSetup."Default VAT Date"::"Posting Date" then
            VALIDATE("VAT Date","Posting Date");
          if "Posting Date" <> xRec."Posting Date" then
            UpdateExciseLabels;
        end;
        //NAVE110.0; 001; end

        #15..29
        */
        //end;


        //Unsupported feature: CodeInsertion on ""Customer Posting Group"(Field 31)". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //begin
        /*
        //NAVE110.0; 001; begin
        if LocalizationUsage.UseEastLocalization then
          if (CurrFieldNo = FIELDNO("Customer Posting Group")) and
             ("Customer Posting Group" <> xRec."Customer Posting Group")
          then begin
            SalesSetup.GET;
            if SalesSetup."Allow Alter Posting Groups" then begin
              if not SubstCustPostingGrp.GET(xRec."Customer Posting Group","Customer Posting Group") then
                ERROR(Text46012225,xRec."Customer Posting Group","Customer Posting Group",SubstCustPostingGrp.TABLECAPTION);
            end else
              ERROR(Text46012226,FIELDCAPTION("Customer Posting Group"),SalesSetup.FIELDCAPTION("Allow Alter Posting Groups"));
          end;
        //NAVE110.0; 001; end
        */
        //end;


        //Unsupported feature: CodeModification on ""Prices Including VAT"(Field 35).OnValidate". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        TESTFIELD(Status,Status::Open);

        if "Prices Including VAT" <> xRec."Prices Including VAT" then begin
        #4..13
          SalesLine.SETRANGE("Document No.","No.");
          SalesLine.SETFILTER("Unit Price",'<>%1',0);
          SalesLine.SETFILTER("VAT %",'<>%1',0);
          if SalesLine.FINDFIRST then begin
            RecalculatePrice :=
              CONFIRM(
        #20..35
              if not RecalculatePrice then begin
                SalesLine."VAT Difference" := 0;
                SalesLine.UpdateAmounts;
              end else begin
                VatFactor := 1 + SalesLine."VAT %" / 100;
                if VatFactor = 0 then
                  VatFactor := 1;
                if not "Prices Including VAT" then
                  VatFactor := 1 / VatFactor;
                SalesLine."Unit Price" :=
                  ROUND(SalesLine."Unit Price" * VatFactor,Currency."Unit-Amount Rounding Precision");
                SalesLine."Line Discount Amount" :=
                  ROUND(
        #49..60
          end;
          OnAfterChangePricesIncludingVAT(Rec);
        end;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..16

          //NAVE110.0; 001; begin
          if LocalizationUsage.UseEastLocalization then
            if not ("Calculate Excise" or "Calculate Product Tax") then
              SalesLine.SETFILTER("VAT %",'',0);
          //NAVE110.0; 001; end

        #17..38

                  //NAVE110.0; 001; begin
                  if LocalizationUsage.UseEastLocalization then begin
                    if (SalesLine."Unit Excise" <> 0) or (SalesLine."Unit Product Tax" <> 0) then begin

                      SalesLine."Unit Price" :=
                        ROUND(
                          SalesLine."Unit Price" * (1 + (SalesLine."VAT %" / 100)),
                          Currency."Unit-Amount Rounding Precision");
                      if SalesLine.Quantity <> 0 then begin
                        SalesLine."Line Discount Amount" :=
                          ROUND(
                            SalesLine.Quantity * SalesLine."Unit Price" * SalesLine."Line Discount %" / 100,
                            Currency."Amount Rounding Precision");
                        SalesLine.VALIDATE("Inv. Discount Amount",
                          ROUND(
                            SalesLine."Inv. Discount Amount" * (1 + (SalesLine."VAT %" / 100)),
                            Currency."Amount Rounding Precision"));
                      end;

                    end;
                  end else
                  //NAVE110.0; 001; end
                    SalesLine."Unit Price" :=
                      ROUND(
                        SalesLine."Unit Price" * (1 + (SalesLine."VAT %" / 100)),
                        Currency."Unit-Amount Rounding Precision");
                    if SalesLine.Quantity <> 0 then begin
                      SalesLine."Line Discount Amount" :=
                        ROUND(
                          SalesLine.Quantity * SalesLine."Unit Price" * SalesLine."Line Discount %" / 100,
                          Currency."Amount Rounding Precision");
                      SalesLine.VALIDATE("Inv. Discount Amount",
                        ROUND(
                          SalesLine."Inv. Discount Amount" * (1 + (SalesLine."VAT %" / 100)),
                          Currency."Amount Rounding Precision"));
                    end;

        #39..44

                  //NAVE110.0; 001; begin
                  if LocalizationUsage.UseEastLocalization then begin
                    if (SalesLine."VAT %" <> 0) or (SalesLine."Unit Excise" <> 0) or (SalesLine."Unit Product Tax" <> 0) then begin

                      SalesLine."Unit Price" :=
                        ROUND(
                          SalesLine."Unit Price" / (1 + (SalesLine."VAT %" / 100)),
                          Currency."Unit-Amount Rounding Precision");
                      if SalesLine.Quantity <> 0 then begin
                        SalesLine."Line Discount Amount" :=
                          ROUND(
                            SalesLine.Quantity * SalesLine."Unit Price" * SalesLine."Line Discount %" / 100,
                            Currency."Amount Rounding Precision");
                        SalesLine.VALIDATE("Inv. Discount Amount",
                          ROUND(
                            SalesLine."Inv. Discount Amount" / (1 + (SalesLine."VAT %" / 100)),
                            Currency."Amount Rounding Precision"));
                      end;

                    end;
                  end else
                  //NAVE110.0; 001; end
                    SalesLine."Unit Price" :=
        #46..63
        */
        //end;


        //Unsupported feature: CodeModification on ""Applies-to Doc. No."(Field 53).OnLookup". Please convert manually.

        //trigger  No();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        TESTFIELD("Bal. Account No.",'');
        CustLedgEntry.SetApplyToFilters("Bill-to Customer No.","Applies-to Doc. Type","Applies-to Doc. No.",Amount);

        #4..10
            "Currency Code",CustLedgEntry."Currency Code",GenJnlLine."Account Type"::Customer,true);
          "Applies-to Doc. Type" := CustLedgEntry."Document Type";
          "Applies-to Doc. No." := CustLedgEntry."Document No.";
        end;
        CLEAR(ApplyCustEntries);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..13

          //NAVE110.0; 001; begin
          if LocalizationUsage.UseEastLocalization then
            if "Applies-to Doc. Type" = "Applies-to Doc. Type"::Invoice then begin
              "To Invoice No." := "Applies-to Doc. No.";
              "To Invoice Date" := CustLedgEntry."Posting Date";
            end else begin
              "To Invoice No." := '';
              "To Invoice Date" := 0D;
            end;
          //NAVE110.0; 001; end

        end;
        CLEAR(ApplyCustEntries);
        */
        //end;


        //Unsupported feature: CodeInsertion on ""EU 3-Party Trade"(Field 75)". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //begin
        /*
        //NAVE110.0; 001; begin
        if LocalizationUsage.UseEastLocalization then
          if not "EU 3-Party Trade" then
            "EU 3-Party Intermediate Role" := false;
        //NAVE110.0; 001; end
        */
        //end;


        //Unsupported feature: CodeModification on ""Sell-to Customer Name"(Field 79).OnValidate". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        if not IdentityManagement.IsInvAppId and ShouldLookForCustomerByName("Sell-to Customer No.") then
          VALIDATE("Sell-to Customer No.",Customer.GetCustNo("Sell-to Customer Name"));
        GetShippingTime(FIELDNO("Sell-to Customer Name"));
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..3

        //NAVBG10.0; 001; begin
        if LocalizationUsage.UseEastLocalization then
          if "Sell-to Customer Name" <> xRec."Sell-to Customer Name" then
            begin
              ExciseTaxDoc.SETCURRENTKEY("Document Type","Corresponding Doc. No.");
              ExciseTaxDoc.SETRANGE(ExciseTaxDoc."Corresponding Doc. No.","No.");
              ExciseTaxDoc.SETRANGE(ExciseTaxDoc."Document Type","Document Type");
              if ExciseTaxDoc.FINDFIRST then begin
                ExciseTaxDoc.VALIDATE(ExciseTaxDoc."Sell-to Customer Name","Sell-to Customer Name");
                ExciseTaxDoc.MODIFY;
              end;
          end;
        //NAVBG10.0; 001; end
        */
        //end;


        //Unsupported feature: CodeInsertion on ""Bill-to Country/Region Code"(Field 87).OnValidate". Please convert manually.

        //trigger (Variable: +++++++++++)();
        //Parameters and return type have not been exported.
        //begin
        /*
        */
        //end;


        //Unsupported feature: CodeModification on ""Bill-to Country/Region Code"(Field 87).OnValidate". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        ModifyBillToCustomerAddress;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
         ModifyBillToCustomerAddress;
        //NAVE110.0; 001; begin
        if LocalizationUsage.UseEastLocalization then begin
          Export := not ("Bill-to Country/Region Code" in ['',CompanyInfo."Country/Region Code"]);

          VALIDATE("Calculate Excise",not Export);
          VALIDATE("Calculate Product Tax",not Export);
        end;
        //NAVE110.0; 001; end
        */
        //end;


        //Unsupported feature: CodeModification on ""Document Date"(Field 99).OnValidate". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        if xRec."Document Date" <> "Document Date" then
          UpdateDocumentDate := true;
        VALIDATE("Payment Terms Code");
        VALIDATE("Prepmt. Payment Terms Code");
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..4

        //NAVE110.0; 001; begin
        if LocalizationUsage.UseEastLocalization then begin
          SalesSetup.GET;
          if SalesSetup."Default VAT Date" = SalesSetup."Default VAT Date"::"Document Date" then
            VALIDATE("VAT Date","Document Date");
        end;
        //NAVE110.0; 001; end
        */
        //end;


        //Unsupported feature: CodeInsertion on ""VAT Bus. Posting Group"(Field 116).OnValidate". Please convert manually.

        //trigger (Variable: +++++++)();
        //Parameters and return type have not been exported.
        //begin
        /*
        */
        //end;


        //Unsupported feature: CodeModification on ""VAT Bus. Posting Group"(Field 116).OnValidate". Please convert manually.

        //trigger  Posting Group"(Field 116)();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        TESTFIELD(Status,Status::Open);
        if xRec."VAT Bus. Posting Group" <> "VAT Bus. Posting Group" then
          RecreateSalesLines(FIELDCAPTION("VAT Bus. Posting Group"));
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..3

        //NAVBG10.0; 001; begin
        if LocalizationUsage.UseEastLocalization then
          if VATBusPostingGroup.GET( "VAT Bus. Posting Group" ) then
            "Unrealized VAT" := VATBusPostingGroup."Unrealized VAT";
        //NAVBG10.0; 001; end
        */
        //end;
        field(46015505; "Identification No."; Text[13])
        {
            Caption = 'Identification No.';
            Description = 'NAVBG10.0,001';
        }
        field(46015507; "Debit Memo"; Boolean)
        {
            Caption = 'Debit Memo';
            Description = 'NAVBG10.0,001';
        }
        field(46015508; "To Invoice No."; Code[20])
        {
            Caption = 'To Invoice No.';
            Description = 'NAVBG10.0,001';
            TableRelation = "Sales Invoice Header"."No." WHERE("Sell-to Customer No." = FIELD("Sell-to Customer No."));

            trigger OnValidate();
            var
                SalesInvHeader: Record "Sales Invoice Header";
            begin
                if "To Invoice No." <> '' then begin
                    TESTFIELD("Applies-to Doc. No.", '');
                    if SalesInvHeader.GET("To Invoice No.") then
                        "To Invoice Date" := SalesInvHeader."Posting Date";
                end else begin
                    TESTFIELD("Applies-to Doc. No.", '');
                    "To Invoice Date" := 0D;
                end;
            end;
        }
        field(46015509; "To Invoice Date"; Date)
        {
            Caption = 'To Invoice Date';
            Description = 'NAVBG10.0,001';
        }
        field(46015510; Void; Boolean)
        {
            Caption = 'Void';
            Description = 'NAVBG10.0,001';
        }
        field(46015511; "Void Date"; Date)
        {
            Caption = 'Void Date';
            Description = 'NAVBG10.0,001';
        }
        field(46015512; "VAT Subject"; Text[30])
        {
            Caption = 'VAT Subject';
            Description = 'NAVBG10.0,001';
            NotBlank = true;
        }
        field(46015513; "Sales Protocol"; Boolean)
        {
            Caption = 'Sales Protocol';
            Description = 'NAVBG10.0,001';
        }
        field(46015514; "Sales Location"; Text[30])
        {
            Caption = 'Sales Location';
            Description = 'NAVBG10.0,001';
        }
        field(46015515; "Do not include in VAT Ledgers"; Boolean)
        {
            Caption = 'Do not include in VAT Ledgers';
            Description = 'NAVBG10.0,001';
        }
        field(46015517; "VAT Bank No."; Code[20])
        {
            Caption = 'VAT Bank No.';
            Description = 'NAVBG10.0,001';
            TableRelation = "Bank Account";
        }
        field(46015518; "Calculate Excise"; Boolean)
        {
            Caption = 'Calculate Excise';
            Description = 'NAVBG10.0,001';
            InitValue = true;

            trigger OnValidate();
            begin
                UpdateSalesLines(FIELDCAPTION("Calculate Excise"), false);
            end;
        }
        field(46015519; "Excise (LCY)"; Decimal)
        {
            CalcFormula = Sum ("Sales Line"."Excise Amount (LCY)" WHERE("Document Type" = FIELD("Document Type"),
                                                                        "Document No." = FIELD("No.")));
            Caption = 'Excise (LCY)';
            Description = 'NAVBG10.0,001';
            Editable = false;
            FieldClass = FlowField;
        }
        field(46015520; Excise; Decimal)
        {
            CalcFormula = Sum ("Sales Line"."Excise Amount" WHERE("Document Type" = FIELD("Document Type"),
                                                                  "Document No." = FIELD("No.")));
            Caption = 'Excise';
            Description = 'NAVBG10.0,001';
            Editable = false;
            FieldClass = FlowField;
        }
        field(46015521; "Calculate Product Tax"; Boolean)
        {
            Caption = 'Calculate Product Tax';
            Description = 'NAVBG10.0,001';
            InitValue = true;

            trigger OnValidate();
            begin
                UpdateSalesLines(FIELDCAPTION("Calculate Product Tax"), false);
            end;
        }
        field(46015522; "Product Tax (LCY)"; Decimal)
        {
            CalcFormula = Sum ("Sales Line"."Product Tax Amount (LCY)" WHERE("Document Type" = FIELD("Document Type"),
                                                                             "Document No." = FIELD("No.")));
            Caption = 'Product Tax (LCY)';
            Description = 'NAVBG10.0,001';
            Editable = false;
            FieldClass = FlowField;
        }
        field(46015523; "Product Tax"; Decimal)
        {
            CalcFormula = Sum ("Sales Line"."Product Tax Amount" WHERE("Document Type" = FIELD("Document Type"),
                                                                       "Document No." = FIELD("No.")));
            Caption = 'Product Tax';
            Description = 'NAVBG10.0,001';
            Editable = false;
            FieldClass = FlowField;
        }
        field(46015526; "VAT Exempt Ground"; Code[10])
        {
            Caption = 'VAT Exempt Ground';
            Description = 'NAVBG10.0,001';
            TableRelation = "Ground for VAT Protocol".Code WHERE(Type = CONST("VAT Exempt"));
        }
        field(46015527; "Composed By"; Text[30])
        {
            Caption = 'Composed By';
            Description = 'NAVBG10.0,001';
        }
        field(46015528; "BP Documents Receipt Date"; Date)
        {
            Caption = 'BP Documents Receipt Date';
            Description = 'NAVBG10.0,001';
        }
        field(46015530; "Bank Code"; Code[10])
        {
            Caption = 'Bank Code';
            Description = 'NAVBG10.0,001';
        }
        field(46015535; "Transport Country/Region Code"; Code[10])
        {
            Caption = 'Transport Country/Region Code';
            Description = 'NAVBG10.0,001';
            TableRelation = "Country/Region";
        }
        field(46015540; Appendix; Code[20])
        {
            Caption = 'Appendix No.';
            Description = 'NAVB10.0,001';
        }
        field(46015541; "Country of Origin"; Code[10])
        {
            Caption = 'Country of Origin';
            Description = 'NAVB10.0,001';
            TableRelation = "Country/Region";
        }
        field(46015542; "Excise Tax Document No."; Code[20])
        {
            Caption = 'Excise Tax Document No.';
            Description = 'NAVB10.0,001';

            trigger OnValidate();
            var
                lRecSalesLine: Record "Sales Line";
            begin
                //TODO
                /*
                if "Excise Tax Document No." <> xRec."Excise Tax Document No." then begin
                    SalesSetup.GET;
                    NoSeriesMgt.TestManual(SalesSetup."Excise Tax Document Nos.");
                    "Excise Tax Document No. Series" := '';
                    ExciseTaxDoc.ValidateWithSalesValues(Rec);
                end else
                    ExciseTaxDoc.ValidateWithSalesValues(Rec);
                */
            end;
        }
        field(46015543; "Excise Charge Ground Code"; Code[20])
        {
            Caption = 'Excise Charge Ground Code';
            Description = 'NAVB10.0,001';
            TableRelation = "Excise Charge Ground";

            trigger OnValidate();
            var
                lRecSalesLine: Record "Sales Line";
            begin
                lRecSalesLine.RESET;
                lRecSalesLine.SETRANGE(lRecSalesLine."Document Type", "Document Type");
                lRecSalesLine.SETRANGE(lRecSalesLine."Document No.", "No.");
                lRecSalesLine.SETRANGE(lRecSalesLine."Excise Item", true);
                if lRecSalesLine.FIND('-') then
                    repeat
                        lRecSalesLine."Outbound Excise Destination" := "Outbound Excise Destination";
                        lRecSalesLine.MODIFY;
                    until lRecSalesLine.NEXT = 0;
            end;
        }
        field(46015544; "Excise Document Date"; Date)
        {
            Caption = 'Excise Document Date';
            Description = 'NAVB10.0,001';
        }
        field(46015545; "Payment Obligation Type"; Code[2])
        {
            Caption = 'Payment Obligation Type';
            Description = 'NAVB10.0,001';
            TableRelation = "Payment Obligation Type";

            trigger OnValidate();
            var
                lRecSalesLine: Record "Sales Line";
            begin
                lRecSalesLine.RESET;
                lRecSalesLine.SETRANGE(lRecSalesLine."Document Type", "Document Type");
                lRecSalesLine.SETRANGE(lRecSalesLine."Document No.", "No.");
                lRecSalesLine.SETRANGE(lRecSalesLine."Excise Item", true);
                if lRecSalesLine.FIND('-') then
                    repeat
                        lRecSalesLine."Payment Obligation Type" := "Payment Obligation Type";
                        lRecSalesLine.MODIFY;
                    until lRecSalesLine.NEXT = 0;
            end;
        }
        field(46015546; "Return Date of AAD"; Date)
        {
            Caption = 'Return Date of AAD';
            Description = 'NAVB10.0,001';
        }
        field(46015547; "Excise Tax Document No. Series"; Code[10])
        {
            Caption = 'Excise Tax Document No. Series';
            Description = 'NAVB10.0,001';
            TableRelation = "No. Series";
        }
        field(46015548; "Dispatched by"; Text[50])
        {
            Caption = 'Dispatched by';
            Description = 'NAVB10.0,001';
        }
        field(46015549; "Tariff No."; Text[50])
        {
            Caption = 'Tariff No.';
            Description = 'NAVB10.0,001';
        }
        field(46015550; "Outbound Excise Destination"; Code[2])
        {
            Caption = 'Outbound Excise Destination';
            Description = 'NAVB10.0,001';
            TableRelation = "Excise Destination";

            trigger OnValidate();
            var
                lRecSalesLine: Record "Sales Line";
            begin
                lRecSalesLine.RESET;
                lRecSalesLine.SETRANGE(lRecSalesLine."Document Type", "Document Type");
                lRecSalesLine.SETRANGE(lRecSalesLine."Document No.", "No.");
                lRecSalesLine.SETRANGE(lRecSalesLine."Excise Item", true);
                if lRecSalesLine.FIND('-') then
                    repeat
                        lRecSalesLine."Outbound Excise Destination" := "Outbound Excise Destination";
                        lRecSalesLine.MODIFY;
                    until lRecSalesLine.NEXT = 0;
            end;
        }
        field(46015551; "Do not include in Excise"; Boolean)
        {
            Caption = 'Do not include in Excise';
            Description = 'NAVB10.0,001';

            trigger OnValidate();
            var
                lRecSalesLine: Record "Sales Line";
            begin
                lRecSalesLine.RESET;
                lRecSalesLine.SETRANGE(lRecSalesLine."Document Type", "Document Type");
                lRecSalesLine.SETRANGE(lRecSalesLine."Document No.", "No.");
                lRecSalesLine.SETRANGE(lRecSalesLine."Excise Item", true);
                if lRecSalesLine.FIND('-') then
                    repeat
                        lRecSalesLine."Do not include in Excise" := "Do not include in Excise";
                        lRecSalesLine.MODIFY;
                    until lRecSalesLine.NEXT = 0;
            end;
        }
        field(46015552; "Excise Declaration Correction"; Boolean)
        {
            Caption = 'Excise Declaration Correction';
            Description = 'NAVB10.0,001';

            trigger OnValidate();
            var
                lRecSalesLine: Record "Sales Line";
            begin
                lRecSalesLine.RESET;
                lRecSalesLine.SETRANGE(lRecSalesLine."Document Type", "Document Type");
                lRecSalesLine.SETRANGE(lRecSalesLine."Document No.", "No.");
                lRecSalesLine.SETRANGE(lRecSalesLine."Excise Item", true);
                if lRecSalesLine.FIND('-') then
                    repeat
                        lRecSalesLine."Excise Declaration Correction" := "Excise Declaration Correction";
                        lRecSalesLine.MODIFY;
                    until lRecSalesLine.NEXT = 0;
            end;
        }
        field(46015553; "Bank Account for Report"; Code[20])
        {
            Caption = 'Bank Account for Report';
            TableRelation = "Bank Account";
        }
        field(46015605; "Registration No."; Text[20])
        {
            Caption = 'Registration No.';
            Description = 'NAVE110.0,001';
        }
        field(46015606; "Registration No. 2"; Text[20])
        {
            Caption = 'Registration No. 2';
            Description = 'NAVE110.0,001';
        }
        field(46015610; "VAT Date"; Date)
        {
            Caption = 'VAT Date';
            Description = 'NAVE110.0,001';

            trigger OnValidate();
            begin
                //TODO
                /*
                GLSetup.GET;
                if not GLSetup."Use VAT Date" then
                    TESTFIELD("VAT Date", "Posting Date");
                if "VAT Date" <> xRec."VAT Date" then
                    UpdateSalesLines(FIELDCAPTION("VAT Date"), false);
                */
            end;
        }
        field(46015611; "Postponed VAT"; Boolean)
        {
            Caption = 'Postponed VAT';
            Description = 'NAVE110.0,001';
        }
        field(46015614; "Industry Code"; Code[20])
        {
            Caption = 'Industry Code';
            Description = 'NAVE110.0,001';
            TableRelation = "Industry Code".Code;
        }
        field(46015615; "Bank No."; Code[20])
        {
            Caption = 'Bank No.';
            Description = 'NAVE110.0,001';
            TableRelation = "Bank Account";

            trigger OnValidate();
            var
                BankAcc: Record "Bank Account";
            begin
                if BankAcc.GET("Bank No.") then begin
                    "Bank Name" := BankAcc.Name;
                    "Bank Account No." := BankAcc."Bank Account No.";
                    "Bank Branch No." := BankAcc."Bank Branch No.";
                    IBAN := BankAcc.IBAN;
                    "Bank Code" := BankAcc."Bank Code";
                end else begin
                    //TODO
                    /*
                      CompanyInfo.GET;
                      "Bank Name" := CompanyInfo."Bank Name";
                      "Bank Account No." := CompanyInfo."Bank Account No.";
                      "Bank Branch No." := CompanyInfo."Bank Branch No.";
                      IBAN := CompanyInfo.IBAN;
                      "Bank Code" := CompanyInfo."Bank Code";
                    */
                end;
            end;
        }
        field(46015616; "Bank Name"; Text[50])
        {
            Caption = 'Bank Name';
            Description = 'NAVE110.0,001';
        }
        field(46015617; "Bank Account No."; Text[30])
        {
            Caption = 'Bank Account No.';
            Description = 'NAVE110.0,001';
        }
        field(46015619; "EU 3-Party Intermediate Role"; Boolean)
        {
            Caption = 'EU 3-Party Intermediate Role';
            Description = 'NAVE110.0,001';

            trigger OnValidate();
            begin
                if "EU 3-Party Intermediate Role" then
                    "EU 3-Party Trade" := true;
            end;
        }
        field(46015625; "SAD No."; Code[20])
        {
            Caption = 'SAD No.';
            Description = 'NAVE110.0,001';
            TableRelation = "Export SAD Header" WHERE("Customer No." = FIELD("Sell-to Customer No."));
        }
        field(46015626; "Customs Procedure Code"; Code[10])
        {
            Caption = 'Customs Procedure Code';
            Description = 'NAVE110.0,001';
            TableRelation = "Custom Procedure".Code;
        }
        field(46015630; "Posting Desc. Code"; Code[10])
        {
            Caption = 'Posting Desc. Code';
            Description = 'NAVE110.0,001';
            TableRelation = "Posting Description" WHERE(Type = CONST("Sales Document"));

            trigger OnValidate();
            begin
                //TODO
                /*
                if "Posting Desc. Code" <> '' then
                    "Posting Description" := GetPostingDescription(Rec);
                */
            end;
        }
        field(46015631; "Bank Branch No."; Text[20])
        {
            Caption = 'Bank Branch No.';
            Description = 'NAVE110.0,001';
        }
        field(46015632; IBAN; Code[50])
        {
            Caption = 'IBAN';
            Description = 'NAVE110.0,001';

            trigger OnValidate();
            begin
                //TODO                
                //CompanyInfo.CheckIBAN(IBAN);
            end;
        }
        field(46015636; "Delivery Person Name"; Text[30])
        {
            Caption = 'Delivery Person Name';
            Description = 'NAVE110.0,001';
            //This property is currently not supported
            //TestTableRelation = true;
            //TODO
            //ValidateTableRelation = true;
        }
        field(46015637; "Identity Card No."; Code[20])
        {
            Caption = 'Identity Card No.';
            Description = 'NAVE110.0,001';
            TableRelation = "Delivery Person";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate();
            begin
                if DeliveryPerson.GET("Identity Card No.") then begin
                    "Delivery Person Name" := DeliveryPerson."Delivery Person Name";
                    "Identity Card Authority" := DeliveryPerson."Identity Card Authority";
                    "Vehicle Reg. No." := DeliveryPerson."Vehicle Reg. No.";
                    "Delivery Transport Method" := DeliveryPerson."Delivery Transport Method";
                end
            end;
        }
        field(46015638; "Identity Card Authority"; Text[50])
        {
            Caption = 'Identity Card Authority';
            Description = 'NAVE110.0,001';
        }
        field(46015639; "Vehicle Reg. No."; Code[10])
        {
            Caption = 'Vehicle Reg. No.';
            Description = 'NAVE110.0,001';
        }
        field(46015640; "Delivery Transport Method"; Code[10])
        {
            Caption = 'Delivery Transport Method';
            Description = 'NAVE110.0,001';
            TableRelation = "Transport Method";
        }
        field(46015641; "Expedition Date"; Date)
        {
            Caption = 'Expedition Date';
            Description = 'NAVE110.0,001';
        }
        field(46015642; "Expedition Time"; Time)
        {
            Caption = 'Expedition Time';
            Description = 'NAVE110.0,001';
        }
        field(46015643; "Security No."; Code[13])
        {
            Caption = 'Security No.';
            Description = 'NAVE110.0,001';
        }
        field(46015700; "Unrealized VAT"; Boolean)
        {
            Caption = 'Unrealized VAT';
            Description = 'NAVBG10.0,001';
        }
    }


    //Unsupported feature: CodeModification on "OnInsert". Please convert manually.

    //trigger OnInsert();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    InitInsert;
    InsertMode := true;

    SetSellToCustomerFromFilter;

    if GetFilterContNo <> '' then
      VALIDATE("Sell-to Contact No.",GetFilterContNo);

    if "Salesperson Code" = '' then
      SetDefaultSalesperson;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..8
    //NAVE110.0; 001; begin
    if LocalizationUsage.UseEastLocalization then
      VALIDATE("Posting Desc. Code",SalesSetup."Posting Desc. Code");
    //NAVE110.0; 001; end

    if "Salesperson Code" = '' then
      SetDefaultSalesperson;
    */
    //end;


    //Unsupported feature: CodeInsertion on "OnModify". Please convert manually.

    //trigger OnModify();
    //Parameters and return type have not been exported.
    //begin
    /*
    //NAVE110.0; 001; begin
    if LocalizationUsage.UseEastLocalization then
      VALIDATE("Posting Desc. Code");
    //NAVE110.0; 001; end
    */
    //end;

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
        "+++++++++++": Integer;
        Export: Boolean;

    var
        "+++++++": Integer;
        VATBusPostingGroup: Record "VAT Business Posting Group";

    var
        PostedSeriesNo: Code[20];

    var
        SubstCustPostingGrp: Record "Subst. Customer Posting Group";
        DeliveryPerson: Record "Delivery Person";
        CurrencyRateEntered: Boolean;
        Text46012225: Label 'You cannot change the %1 to %2 because %3 has not been filled in.';
        Text46012226: Label 'You cannot change %1 until %2 will be checked in setup.';
        ExciseTaxDoc: Record "Excise Tax Document";
}

