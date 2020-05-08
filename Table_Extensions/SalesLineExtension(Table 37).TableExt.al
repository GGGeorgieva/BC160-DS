tableextension 46015577 tableextension46015577 extends "Sales Line" 
{
    // version NAVW111.00.00.28629,NAVBG11.0

    fields
    {

        //Unsupported feature: CodeModification on "Type(Field 5).OnValidate". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            TestJobPlanningLine;
            TestStatusOpen;
            GetSalesHeader;
            #4..14
            CheckAssocPurchOrder(FIELDCAPTION(Type));

            if Type <> xRec.Type then begin
              case xRec.Type of
                Type::Item:
                  begin
            #21..60
              if SalesHeader.WhseShpmntConflict("Document Type","Document No.",SalesHeader."Shipping Advice") then
                ERROR(Text052,SalesHeader."Shipping Advice");
            end;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..17
              //NAVBG11.0; 001; begin
              if LocalizationUsage.UseEastLocalization then
                DeleteExciseLabels(true);
              //NAVBG11.0; 001; end

            #18..63
            */
        //end;


        //Unsupported feature: CodeModification on ""No."(Field 6).OnValidate". Please convert manually.

        //trigger "(Field 6)();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            "No." := FindRecordMgt.FindNoFromTypedValue(Type,"No.",not "System-Created Entry");

            TestJobPlanningLine;
            TestStatusOpen;
            CheckItemAvailable(FIELDNO("No."));

            if (xRec."No." <> "No.") and (Quantity <> 0) then begin
              TESTFIELD("Qty. to Asm. to Order (Base)",0);
              CALCFIELDS("Reserved Qty. (Base)");
            #10..114
            PostingSetupMgt.CheckGenPostingSetupSalesAccount("Gen. Bus. Posting Group","Gen. Prod. Posting Group");
            PostingSetupMgt.CheckGenPostingSetupCOGSAccount("Gen. Bus. Posting Group","Gen. Prod. Posting Group");
            PostingSetupMgt.CheckVATPostingSetupSalesAccount("VAT Bus. Posting Group","VAT Prod. Posting Group");
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..6
            //NAVBG11.0; 001; begin
            if LocalizationUsage.UseEastLocalization then
              if (xRec."No." <> "No.") then
                DeleteExciseLabels(true);
            //NAVBG11.0; 001; end

            #7..117
            //NAVE111.0; 001; begin
            if LocalizationUsage.UseEastLocalization then
              GetDefaultBin;
            //NAVE111.0; 001; end
            */
        //end;


        //Unsupported feature: CodeModification on "Quantity(Field 15).OnValidate". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            TestJobPlanningLine;
            TestStatusOpen;

            #4..54
              InitItemAppl(false);

            if Type = Type::Item then begin
              UpdateUnitPrice(FIELDNO(Quantity));
              if (xRec.Quantity <> Quantity) or (xRec."Quantity (Base)" <> "Quantity (Base)") then begin
                OnBeforeVerifyReservedQty(Rec,xRec,FIELDNO(Quantity));
            #61..80
              Amount := 0;
              "Amount Including VAT" := 0;
              "VAT Base Amount" := 0;
            end;

            UpdatePrePaymentAmounts;

            CheckWMS;

            UpdatePlanned;
            if "Document Type" = "Document Type"::"Return Order" then
              ValidateReturnReasonCode(FIELDNO(Quantity));
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..57

              //NAVE111.0; 001; begin
              if LocalizationUsage.UseEastLocalization then begin
                UpdateExciseAmounts;
                UpdateProductTaxAmounts;
              end;
              //NAVE111.0; 001; end

            #58..83

              //NAVE111.0; 001; begin
              if LocalizationUsage.UseEastLocalization then
                "Amount Incl. Taxes Excl. VAT" := 0;
              //NAVE111.0; 001; end

            end;

            //NAVE111.0; 001; begin
            if LocalizationUsage.UseEastLocalization then
              SetDefaultQuantity;
            //NAVE111.0; 001; end
            #85..92
            */
        //end;


        //Unsupported feature: CodeModification on ""Line Discount %"(Field 27).OnValidate". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            TestJobPlanningLine;
            TestStatusOpen;
            "Line Discount Amount" :=
              ROUND(
                ROUND(Quantity * "Unit Price",Currency."Amount Rounding Precision") *
                "Line Discount %" / 100,Currency."Amount Rounding Precision");
            "Inv. Discount Amount" := 0;
            "Inv. Disc. Amount to Invoice" := 0;
            UpdateAmounts;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            TestJobPlanningLine;
            TestStatusOpen;

            //NAVE111.0; 001; begin
            if LocalizationUsage.UseEastLocalization then
              GetSalesHeader;
            if LocalizationUsage.UseEastLocalization then
              "Line Discount Amount" :=
                ROUND(
                  ROUND(Quantity * CalcDiscBase,Currency."Amount Rounding Precision") *
                  "Line Discount %" / 100,Currency."Amount Rounding Precision")
            else
            //NAVE111.0; 001; end

            #3..9
            */
        //end;


        //Unsupported feature: CodeInsertion on ""Line Discount Amount"(Field 28).OnValidate". Please convert manually.

        //trigger (Variable: DiscBase)();
        //Parameters and return type have not been exported.
        //begin
            /*
            */
        //end;


        //Unsupported feature: CodeModification on ""Line Discount Amount"(Field 28).OnValidate". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            GetSalesHeader;
            "Line Discount Amount" := ROUND("Line Discount Amount",Currency."Amount Rounding Precision");
            TestJobPlanningLine;
            TestStatusOpen;
            TESTFIELD(Quantity);
            if xRec."Line Discount Amount" <> "Line Discount Amount" then
              UpdateLineDiscPct;
            "Inv. Discount Amount" := 0;
            "Inv. Disc. Amount to Invoice" := 0;
            UpdateAmounts;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..4

            //NAVE111.0; 001; begin
            if LocalizationUsage.UseEastLocalization then begin
              GetSalesHeader;
              DiscBase := CalcDiscBase;
            end;
            //NAVE111.0; 001; end

            #5..7

              //NAVE111.0; 001; begin
              if LocalizationUsage.UseEastLocalization then begin
                if ROUND(Quantity * DiscBase,Currency."Amount Rounding Precision") <> 0 then
                  "Line Discount %" :=
                    ROUND(
                      "Line Discount Amount" / ROUND(Quantity * "Unit Price",Currency."Amount Rounding Precision") * 100,
                      0.00001)
                else
                  "Line Discount %" := 0;
              end else
              //NAVE111.0; 001; end

            #8..10
            */
        //end;


        //Unsupported feature: CodeModification on "Amount(Field 29).OnValidate". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            Amount := ROUND(Amount,Currency."Amount Rounding Precision");
            case "VAT Calculation Type" of
              "VAT Calculation Type"::"Normal VAT",
              "VAT Calculation Type"::"Reverse Charge VAT":
                begin
                  "VAT Base Amount" :=
                    ROUND(Amount * (1 - SalesHeader."VAT Base Discount %" / 100),Currency."Amount Rounding Precision");
                  "Amount Including VAT" :=
                    ROUND(Amount + "VAT Base Amount" * "VAT %" / 100,Currency."Amount Rounding Precision");
                end;
              "VAT Calculation Type"::"Full VAT":
                if Amount <> 0 then
            #13..16
              "VAT Calculation Type"::"Sales Tax":
                begin
                  SalesHeader.TESTFIELD("VAT Base Discount %",0);
                  "VAT Base Amount" := ROUND(Amount,Currency."Amount Rounding Precision");
                  "Amount Including VAT" :=
                    Amount +
            #23..32
            end;

            InitOutstandingAmount;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..5

                  //NAVE111.0; 001; begin
                  if LocalizationUsage.UseEastLocalization then begin
                    "Amount Incl. Taxes Excl. VAT" := Amount + "Excise Amount" + "Product Tax Amount";
                    "VAT Base Amount" :=
                      ROUND("Amount Incl. Taxes Excl. VAT" * (1 - SalesHeader."VAT Base Discount %" / 100),Currency."Amount Rounding Precision");
                    "Amount Including VAT" :=
                      ROUND("Amount Incl. Taxes Excl. VAT" + "VAT Base Amount" * "VAT %" / 100,Currency."Amount Rounding Precision");
                  end else begin
                  //NAVE111.0; 001; end

            #6..9

                  //NAVE111.0; 001; single
                  end;

            #10..19

                  //NAVE111.0; 001; begin
                  if LocalizationUsage.UseEastLocalization then begin
                    "Amount Incl. Taxes Excl. VAT" := Amount + "Excise Amount" + "Product Tax Amount";
                    "VAT Base Amount" := ROUND("Amount Incl. Taxes Excl. VAT",Currency."Amount Rounding Precision");
                  end else
                  //NAVE111.0; 001; end
            #20..35
            */
        //end;


        //Unsupported feature: CodeModification on ""Amount Including VAT"(Field 30).OnValidate". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            "Amount Including VAT" := ROUND("Amount Including VAT",Currency."Amount Rounding Precision");
            case "VAT Calculation Type" of
              "VAT Calculation Type"::"Normal VAT",
              "VAT Calculation Type"::"Reverse Charge VAT":
                begin
                  Amount :=
                    ROUND(
                      "Amount Including VAT" /
            #9..14
                begin
                  Amount := 0;
                  "VAT Base Amount" := 0;
                end;
              "VAT Calculation Type"::"Sales Tax":
                begin
                  SalesHeader.TESTFIELD("VAT Base Discount %",0);
                  Amount :=
                    SalesTaxCalculate.ReverseCalculateTax(
                      "Tax Area Code","Tax Group Code","Tax Liable",SalesHeader."Posting Date",
                      "Amount Including VAT","Quantity (Base)",SalesHeader."Currency Factor");
                  if Amount <> 0 then
                    "VAT %" :=
                      ROUND(100 * ("Amount Including VAT" - Amount) / Amount,0.00001)
                  else
                    "VAT %" := 0;
                  Amount := ROUND(Amount,Currency."Amount Rounding Precision");
                  "VAT Base Amount" := Amount;
                end;
            end;

            InitOutstandingAmount;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..5

                  //NAVE111.0; 001; begin
                  if LocalizationUsage.UseEastLocalization then begin
                    "Amount Incl. Taxes Excl. VAT" :=
                      ROUND(
                        "Amount Including VAT" /
                        (1 + (1 - SalesHeader."VAT Base Discount %" / 100) * "VAT %" / 100),
                        Currency."Amount Rounding Precision");
                    Amount := "Amount Incl. Taxes Excl. VAT" - "Excise Amount";
                  end else
                  //NAVE111.0; 001; end

            #6..17

                  //NAVE111.0; 001; begin
                  if LocalizationUsage.UseEastLocalization then
                    "Amount Incl. Taxes Excl. VAT" := 0;
                  //NAVE111.0; 001; end

            #18..21

                  //NAVE111.0; 001; begin
                  if LocalizationUsage.UseEastLocalization then
                  "Amount Incl. Taxes Excl. VAT" :=
                    SalesTaxCalculate.ReverseCalculateTax(
                      "Tax Area Code","Tax Group Code","Tax Liable",SalesHeader."Posting Date",
                      "Amount Including VAT","Quantity (Base)",SalesHeader."Currency Factor")
                  else
                  //NAVE111.0; 001; end

            #22..25

                  //NAVE111.0; 001; begin
                  if LocalizationUsage.UseEastLocalization then begin
                    if "Amount Incl. Taxes Excl. VAT" <> 0 then
                      "VAT %" := ROUND(100 * ("Amount Including VAT" - "Amount Incl. Taxes Excl. VAT") / "Amount Incl. Taxes Excl. VAT",0.00001)
                    else
                      "VAT %" := 0;
                  end else
                  //NAVE111.0; 001; end

            #26..30

                  //NAVE111.0; 001; begin
                  if LocalizationUsage.UseEastLocalization then begin
                    "Amount Incl. Taxes Excl. VAT" := ROUND("Amount Incl. Taxes Excl. VAT",Currency."Amount Rounding Precision");
                    "VAT Base Amount" := "Amount Incl. Taxes Excl. VAT";
                    Amount := "Amount Incl. Taxes Excl. VAT" - "Excise Amount";
                  end else begin
                  //NAVE111.0; 001; end

                  Amount := ROUND(Amount,Currency."Amount Rounding Precision");
                  "VAT Base Amount" := Amount;

                  //NAVE111.0; 001; single
                  end;

            #33..36
            */
        //end;


        //Unsupported feature: CodeModification on ""VAT Prod. Posting Group"(Field 90).OnValidate". Please convert manually.

        //trigger  Posting Group"(Field 90)();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            TestStatusOpen;
            VATPostingSetup.GET("VAT Bus. Posting Group","VAT Prod. Posting Group");
            "VAT Difference" := 0;
            #4..6
            "VAT Calculation Type" := VATPostingSetup."VAT Calculation Type";
            "VAT Identifier" := VATPostingSetup."VAT Identifier";
            "VAT Clause Code" := VATPostingSetup."VAT Clause Code";
            case "VAT Calculation Type" of
              "VAT Calculation Type"::"Reverse Charge VAT",
              "VAT Calculation Type"::"Sales Tax":
            #13..22
                  "Unit Price" * (100 + "VAT %") / (100 + xRec."VAT %"),
                  Currency."Unit-Amount Rounding Precision");
            UpdateAmounts;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..9
            // NAVBG11.0; 001 begin
            VATClause.GET("VAT Clause Code");
            "VAT Clause Description" := VATClause.Description;
            // NAVBG11.0; 001 end

            #10..25

            //NAVE111.0; 001; begin
            if LocalizationUsage.UseEastLocalization then
              VALIDATE("Prepayment %");
            //NAVE111.0; 001; end
            */
        //end;


        //Unsupported feature: CodeModification on ""Line Amount"(Field 103).OnValidate". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            TESTFIELD(Type);
            TESTFIELD(Quantity);
            TESTFIELD("Unit Price");
            GetSalesHeader;
            "Line Amount" := ROUND("Line Amount",Currency."Amount Rounding Precision");
            VALIDATE(
              "Line Discount Amount",ROUND(Quantity * "Unit Price",Currency."Amount Rounding Precision") - "Line Amount");
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..5

            //NAVE111.0; 001; begin
            if LocalizationUsage.UseEastLocalization then
              VALIDATE("Line Discount Amount" ,ROUND(Quantity * CalcDiscBase,Currency."Amount Rounding Precision") - "Line Amount")
            else
            //NAVE111.0; 001; end

            VALIDATE(
              "Line Discount Amount",ROUND(Quantity * "Unit Price",Currency."Amount Rounding Precision") - "Line Amount");
            */
        //end;


        //Unsupported feature: CodeModification on ""Variant Code"(Field 5402).OnValidate". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            TestJobPlanningLine;
            if "Variant Code" <> '' then
              TESTFIELD(Type,Type::Item);
            #4..16

            if Type = Type::Item then begin
              GetUnitCost;
              UpdateUnitPrice(FIELDNO("Variant Code"));
            end;

            #23..29
            end;

            UpdateItemCrossRef;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..19

              //NAVE111.0; 001; begin
              if LocalizationUsage.UseEastLocalization then
                GetUnitProductTax;
              //NAVE111.0; 001; end

            #20..32
            */
        //end;


        //Unsupported feature: CodeModification on ""Unit of Measure Code"(Field 5407).OnValidate". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            TestJobPlanningLine;
            TestStatusOpen;
            TESTFIELD("Quantity Shipped",0);
            #4..32
                begin
                  GetItem;
                  GetUnitCost;
                  UpdateUnitPrice(FIELDNO("Unit of Measure Code"));
                  CheckItemAvailable(FIELDNO("Unit of Measure Code"));
                  "Gross Weight" := Item."Gross Weight" * "Qty. per Unit of Measure";
            #39..61
                "Qty. per Unit of Measure" := 1;
            end;
            VALIDATE(Quantity);
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..35

                  //NAVE111.0; 001; begin
                  if LocalizationUsage.UseEastLocalization then begin
                    GetUnitExcise;
                    GetUnitProductTax;
                  end;
                  //NAVE111.0; 001; end

            #36..64
            */
        //end;
        field(46015505;"Unit Excise (LCY)";Decimal)
        {
            Caption = 'Unit Excise (LCY)';
            DecimalPlaces = 2:5;
            Description = 'NAVBG11.0,001';

            trigger OnValidate();
            begin
                TestStatusOpen;
                GetSalesHeader;

                if CurrFieldNo = FIELDNO("Unit Excise (LCY)") then begin
                  GetItem;

                  Item.TESTFIELD("Excise Item");
                end;

                if SalesHeader."Currency Code" <> '' then begin
                  Currency.TESTFIELD("Unit-Amount Rounding Precision");
                  "Unit Excise" :=
                    ROUND(
                      CurrExchRate.ExchangeAmtLCYToFCY(
                        GetDate,SalesHeader."Currency Code",
                        "Unit Excise (LCY)",SalesHeader."Currency Factor"),
                        Currency."Unit-Amount Rounding Precision")
                end else
                  "Unit Excise" := "Unit Excise (LCY)";

                "Excise Amount (LCY)" := "Unit Excise (LCY)" * Quantity;

                VALIDATE("Unit Excise");
                VALIDATE("Line Discount %");
            end;
        }
        field(46015506;"Unit Excise";Decimal)
        {
            Caption = 'Unit Excise';
            DecimalPlaces = 2:5;
            Description = 'NAVBG11.0,001';
            Editable = false;

            trigger OnValidate();
            begin
                if CurrFieldNo = FIELDNO("Unit Excise") then begin
                  GetItem;

                  Item.TESTFIELD("Excise Item");
                end;

                "Excise Amount" := "Unit Excise" * Quantity
            end;
        }
        field(46015507;"Excise Amount (LCY)";Decimal)
        {
            Caption = 'Excise Amount (LCY)';
            Description = 'NAVBG11.0,001';
            Editable = false;
        }
        field(46015508;"Excise Amount";Decimal)
        {
            Caption = 'Excise Amount';
            Description = 'NAVBG11.0,001';
            Editable = false;
        }
        field(46015509;"Calculate Excise (Cust.)";Boolean)
        {
            Caption = 'Calculate Excise (Cust.)';
            Description = 'NAVBG11.0,001';
            Editable = false;

            trigger OnValidate();
            begin
                "Calculate Excise" := "Calculate Excise (Cust.)" and "Excise Item";

                GetUnitExcise;
            end;
        }
        field(46015510;"Unit Product Tax (LCY)";Decimal)
        {
            Caption = 'Unit Product Tax (LCY)';
            DecimalPlaces = 2:5;
            Description = 'NAVBG11.0,001';

            trigger OnValidate();
            begin
                TestStatusOpen;
                GetSalesHeader;

                if SalesHeader."Currency Code" <> '' then begin
                  Currency.TESTFIELD("Unit-Amount Rounding Precision");
                  "Unit Product Tax" :=
                    ROUND(
                      CurrExchRate.ExchangeAmtLCYToFCY(
                        GetDate,SalesHeader."Currency Code",
                        "Unit Product Tax (LCY)",SalesHeader."Currency Factor"),
                        Currency."Unit-Amount Rounding Precision")
                end else
                  "Unit Product Tax" := "Unit Product Tax (LCY)";

                if "Calculate Product Tax (Cust.)" then
                  "Product Tax Amount (LCY)" := "Unit Product Tax (LCY)" * Quantity
                else
                  "Product Tax Amount (LCY)" := 0;

                VALIDATE("Unit Product Tax");
                VALIDATE("Line Discount %");
            end;
        }
        field(46015511;"Unit Product Tax";Decimal)
        {
            Caption = 'Unit Product Tax';
            DecimalPlaces = 2:5;
            Description = 'NAVBG11.0,001';
            Editable = false;

            trigger OnValidate();
            begin
                if "Calculate Product Tax (Cust.)" then
                  "Product Tax Amount" := "Unit Product Tax" * Quantity
                else
                  "Product Tax Amount" := 0;
            end;
        }
        field(46015512;"Product Tax Amount (LCY)";Decimal)
        {
            Caption = 'Product Tax Amount (LCY)';
            Description = 'NAVBG11.0,001';
            Editable = false;
        }
        field(46015513;"Product Tax Amount";Decimal)
        {
            Caption = 'Product Tax Amount';
            Description = 'NAVBG11.0,001';
            Editable = false;
        }
        field(46015514;"Calculate Product Tax (Cust.)";Boolean)
        {
            Caption = 'Calculate Product Tax (Cust.)';
            Description = 'NAVBG11.0,001';
            Editable = false;

            trigger OnValidate();
            begin
                "Calculate Product Tax" := "Calculate Product Tax (Cust.)" and "Product Tax Item";

                GetUnitProductTax;
            end;
        }
        field(46015515;Product;Boolean)
        {
            Caption = 'Product';
            Description = 'NAVBG11.0,001';
            Editable = false;
        }
        field(46015516;"Amount Incl. Taxes Excl. VAT";Decimal)
        {
            Caption = 'Amount Incl. Taxes Excl. VAT';
            Description = 'NAVBG11.0,001';
            Editable = false;
        }
        field(46015517;"Excise Item";Boolean)
        {
            Caption = 'Excise Item';
            Description = 'NAVBG11.0,001';
            Editable = false;

            trigger OnValidate();
            begin
                if CurrFieldNo <> FIELDNO("Calculate Excise (Cust.)") then
                  VALIDATE("Calculate Excise (Cust.)");
            end;
        }
        field(46015518;"Calculate Excise";Boolean)
        {
            Caption = 'Calculate Excise';
            Description = 'NAVBG11.0,001';
            Editable = false;
        }
        field(46015519;"Product Tax Item";Boolean)
        {
            Caption = 'Product Tax Item';
            Description = 'NAVBG11.0,001';

            trigger OnValidate();
            begin
                if CurrFieldNo <> FIELDNO("Calculate Product Tax (Cust.)") then
                  VALIDATE("Calculate Product Tax (Cust.)");
            end;
        }
        field(46015520;"Calculate Product Tax";Boolean)
        {
            Caption = 'Calculate Product Tax';
            Description = 'NAVBG11.0,001';
        }
        field(46015540;"VAT Clause Description";Text[250])
        {
            Caption = 'VAT Clause Description';
            Description = 'NAVBG11.0.001';
            TableRelation = "VAT Clause";
        }
        field(46015541;"Amount for Print Preview";Integer)
        {
            Caption = 'Amount for Print Preview';
            Description = 'NAVBG11.0.001';
            TableRelation = "Sales Line"."Line No." WHERE ("Document Type"=FIELD("Document Type"),
                                                           "Document No."=FIELD("Document No."));

            trigger OnValidate();
            begin
                if "Amount for Print Preview" <> 0 then
                  if "Quantity and Amount for Print" <> 0 then
                    ERROR(STRSUBSTNO(Text50000,FIELDCAPTION("Amount for Print Preview"),FIELDCAPTION("Quantity and Amount for Print")));
            end;
        }
        field(46015542;"Quantity and Amount for Print";Integer)
        {
            Caption = 'Quantity and Amount for Print';
            Description = 'NAVBG11.0.001';
            TableRelation = "Sales Line"."Line No." WHERE ("Document Type"=FIELD("Document Type"),
                                                           "Document No."=FIELD("Document No."));

            trigger OnValidate();
            begin
                if "Quantity and Amount for Print" <> 0 then
                  if "Amount for Print Preview" <> 0 then
                    ERROR(STRSUBSTNO(Text50000,FIELDCAPTION("Amount for Print Preview"),FIELDCAPTION("Quantity and Amount for Print")));
            end;
        }
        field(46015543;"Outbound Excise Destination";Code[2])
        {
            Caption = 'Outbound Excise Destination';
            Description = 'NAVBG11.0.001';
            TableRelation = "Excise Destination".Code WHERE ("Destination Type"=CONST(Outbound));
        }
        field(46015544;"CN Code";Code[10])
        {
            Caption = 'CN Code';
            Description = 'NAVBG11.0.001';
        }
        field(46015545;"Alcohol Content/Degree Plato";Decimal)
        {
            Caption = 'Alcohol Content/Degree Plato';
            Description = 'NAVBG11.0.001';
        }
        field(46015546;"Excise Unit of Measure";Code[10])
        {
            Caption = 'Excise Unit of Measure';
            Description = 'NAVBG11.0.001';
        }
        field(46015547;"Excise Rate";Decimal)
        {
            Caption = 'Excise Rate';
            Description = 'NAVBG11.0.001';
        }
        field(46015548;"Excise Charge Acc. Base";Decimal)
        {
            Caption = 'Excise Charge Acc. Base';
            Description = 'NAVBG11.0.001';
        }
        field(46015549;"Additional Excise Code";Text[13])
        {
            Caption = 'Additional Excise Code';
            Description = 'NAVBG11.0.001';
            Numeric = true;
        }
        field(46015550;"Do not include in Excise";Boolean)
        {
            Caption = 'Do not include in Excise';
            Description = 'NAVBG11.0.001';
        }
        field(46015551;"Inbound excise destination";Code[2])
        {
            Caption = 'Inbound excise destination';
            Description = 'NAVBG11.0.001';
            TableRelation = "Excise Destination".Code WHERE ("Destination Type"=CONST(Inbound));
        }
        field(46015552;"Excise Declaration Correction";Boolean)
        {
            Caption = 'Excise Declaration Correction';
            Description = 'NAVBG11.0.001';
        }
        field(46015553;"Payment Obligation Type";Code[2])
        {
            Caption = 'Payment Obligation Type';
            Description = 'NAVBG11.0.001';
            TableRelation = "Payment Obligation Type";
        }
        field(46015607;"Tariff No.";Code[10])
        {
            Caption = 'Tariff No.';
            Description = 'NAVE111.0,001';
            TableRelation = "Tariff Number";
        }
        field(46015609;"Country/Region of Origin Code";Code[10])
        {
            Caption = 'Country/Region of Origin Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Country/Region";
        }
        field(46015610;"VAT Date";Date)
        {
            Caption = 'VAT Date';
            Description = 'NAVE111.0,001';

            trigger OnValidate();
            begin
                if CurrFieldNo = FIELDNO("VAT Date") then begin
                  GetGLSetup;
                  if not GLSetup."Allow VAT Date Change in Lines" then
                    ERROR(Text46012225,
                      GLSetup.FIELDCAPTION("Allow VAT Date Change in Lines"),
                      GLSetup.TABLECAPTION,FIELDCAPTION("VAT Date"));
                end;
            end;
        }
        field(46015615;Negative;Boolean)
        {
            Caption = 'Negative';
            Description = 'NAVE111.0,001';
        }
    }


    //Unsupported feature: CodeModification on "OnDelete". Please convert manually.

    //trigger OnDelete();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        TestStatusOpen;

        if (Quantity <> 0) and ItemExists("No.") then begin
          ReserveSalesLine.DeleteLine(Rec);
        #5..57
        // In case we have roundings on VAT or Sales Tax, we should update some other line
        if (Type <> Type::" ") and ("Line No." <> 0) and ("Attached to Line No." = 0) and ("Job Contract Entry No." = 0 ) and
           (Quantity <> 0) and (Amount <> 0) and (Amount <> "Amount Including VAT") and not StatusCheckSuspended
        then begin
          Quantity := 0;
          "Quantity (Base)" := 0;
          "Line Discount Amount" := 0;
          "Inv. Discount Amount" := 0;
          "Inv. Disc. Amount to Invoice" := 0;
          UpdateAmounts;
        end;

        if "Deferral Code" <> '' then
          DeferralUtilities.DeferralCodeOnDelete(
            DeferralUtilities.GetSalesDeferralDocType,'','',
            "Document Type","Document No.","Line No.");
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        TestStatusOpen;

        //NAVBG11.0; 001;
        if LocalizationUsage.UseEastLocalization then
          DeleteExciseLabels(true);
        //NAVBG11.0; 001; end

        #2..60
        then
          VALIDATE(Quantity,0);
        #69..73
        */
    //end;

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
        DiscBase : Decimal;

    var
        DiscBase : Decimal;

    var
        TotalAmountInclTaxExclVAT : Decimal;

    var
        NewAmountInclTaxExclVAT : Decimal;

    var
        Text017 : Label '\The entered information may be disregarded by warehouse operations.';

    var
        GLSetupRead : Boolean;
        Cust : Record Customer;
        CustPostingGroup : Record "Customer Posting Group";
        LocalizationUsage : Codeunit "Localization Usage";
        Text46012225 : Label 'You must check field %1 in %2 to be able to change the %3 field manually.';
        Text46012226 : TextConst ENU='cannot be changed while there is a related %1=%2 in %3=%4';
        GLSetup : Record "General Ledger Setup";
        VATClause : Record "VAT Clause";
        Text50000 : Label 'Only one of the fields "%1", "%2"  can have a value';
        ExciseLabel : Record "Excise Label";
        Text46012227 : Label '"This action will lead to the loosing excise labels data that is specified for this sales line.\Do you want to continue?  "';
}

