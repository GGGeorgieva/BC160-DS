tableextension 46015577 "Sales Line Extension" extends "Sales Line"
{
    // version NAVW111.00.00.28629,NAVBG11.0  
    //TODO: 
    //procedure ShowExciseLabels();
    //MExtend Procedure UpdateVATAmounts;
    //Extend PROCEDURE UpdateVATOnLines;
    //Extend PROCEDURE CalcVATAmountLines;

    fields
    {

        modify(Type)
        {
            trigger OnAfterValidate()
            begin
                DeleteExciseLabels(true);
                GetDefaultBinLoc;
            end;
        }

        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                if (xRec."No." <> "No.") then
                    DeleteExciseLabels(true);
            end;
        }

        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                UpdateExciseAmounts;
                UpdateProductTaxAmounts;
                if (xRec.Quantity <> Quantity) and (Quantity = 0) and ((Amount <> 0) or ("Amount Including VAT" <> 0) or ("VAT Base Amount" <> 0)) then
                    "Amount Incl. Taxes Excl. VAT" := 0;
                SetDefaultQuantity;
                MODIFY;
            end;
        }

        modify("Line Discount %")
        {
            trigger OnAfterValidate()
            begin
                "Line Discount Amount" :=
                  ROUND(
                    ROUND(Quantity * CalcDiscBase, Currency."Amount Rounding Precision") *
                    "Line Discount %" / 100, Currency."Amount Rounding Precision");
                UpdateAmounts();
                MODIFY;
            end;
        }

        modify("Line Discount Amount")
        {
            trigger OnAfterValidate()
            begin
                DiscBase := CalcDiscBase;
                if ROUND(Quantity * DiscBase, Currency."Amount Rounding Precision") <> 0 then
                    "Line Discount %" :=
                      ROUND(
                        "Line Discount Amount" / ROUND(Quantity * "Unit Price", Currency."Amount Rounding Precision") * 100,
                        0.00001)
                else
                    "Line Discount %" := 0;
                UpdateAmounts();
                MODIFY;
            end;
        }

        modify(Amount)
        {
            trigger OnAfterValidate()
            begin
                case "VAT Calculation Type" of
                    "VAT Calculation Type"::"Normal VAT",
                    "VAT Calculation Type"::"Reverse Charge VAT":
                        begin
                            "Amount Incl. Taxes Excl. VAT" := Amount + "Excise Amount" + "Product Tax Amount";
                            "VAT Base Amount" :=
                            ROUND("Amount Incl. Taxes Excl. VAT" * (1 - SalesHeader."VAT Base Discount %" / 100), Currency."Amount Rounding Precision");
                            "Amount Including VAT" :=
                            ROUND("Amount Incl. Taxes Excl. VAT" + "VAT Base Amount" * "VAT %" / 100, Currency."Amount Rounding Precision");
                            InitOutstandingAmount;
                            MODIFY;
                        end;
                    "VAT Calculation Type"::"Sales Tax":
                        begin
                            "Amount Incl. Taxes Excl. VAT" := Amount + "Excise Amount" + "Product Tax Amount";
                            "VAT Base Amount" := ROUND("Amount Incl. Taxes Excl. VAT", Currency."Amount Rounding Precision");
                            MODIFY;
                        end;
                end;
            end;
        }

        modify("Amount Including VAT")
        {
            trigger OnAfterValidate()
            var
                SalesTaxCalculate: Codeunit "Sales Tax Calculate";
            begin
                case "VAT Calculation Type" of
                    "VAT Calculation Type"::"Normal VAT",
                    "VAT Calculation Type"::"Reverse Charge VAT":
                        begin
                            "Amount Incl. Taxes Excl. VAT" :=
                              ROUND(
                                "Amount Including VAT" /
                                (1 + (1 - SalesHeader."VAT Base Discount %" / 100) * "VAT %" / 100),
                                Currency."Amount Rounding Precision");
                            Amount := "Amount Incl. Taxes Excl. VAT" - "Excise Amount";
                            MODIFY;
                        end;
                    "VAT Calculation Type"::"Full VAT":
                        begin
                            "Amount Incl. Taxes Excl. VAT" := 0;
                            MODIFY;
                        end;
                    "VAT Calculation Type"::"Sales Tax":
                        begin
                            "Amount Incl. Taxes Excl. VAT" :=
                              SalesTaxCalculate.ReverseCalculateTax(
                                "Tax Area Code", "Tax Group Code", "Tax Liable", SalesHeader."Posting Date",
                                "Amount Including VAT", "Quantity (Base)", SalesHeader."Currency Factor");
                            if "Amount Incl. Taxes Excl. VAT" <> 0 then
                                "VAT %" := ROUND(100 * ("Amount Including VAT" - "Amount Incl. Taxes Excl. VAT") / "Amount Incl. Taxes Excl. VAT", 0.00001)
                            else
                                "VAT %" := 0;
                            "Amount Incl. Taxes Excl. VAT" := ROUND("Amount Incl. Taxes Excl. VAT", Currency."Amount Rounding Precision");
                            "VAT Base Amount" := "Amount Incl. Taxes Excl. VAT";
                            Amount := "Amount Incl. Taxes Excl. VAT" - "Excise Amount";
                            "VAT Base Amount" := Amount;
                            MODIFY;
                        end;
                end;
            end;
        }

        modify("VAT Prod. Posting Group")
        {
            trigger OnAfterValidate()
            begin
                VATClause.GET("VAT Clause Code");
                "VAT Clause Description" := VATClause.Description;
                VALIDATE("Prepayment %");
                MODIFY;
            end;
        }
        modify("Line Amount")
        {
            trigger OnAfterValidate()
            begin
                VALIDATE("Line Discount Amount", ROUND(Quantity * CalcDiscBase, Currency."Amount Rounding Precision") - "Line Amount");
                MODIFY;
            end;
        }

        modify("Variant Code")
        {
            trigger OnAfterValidate()
            begin
                GetUnitProductTax;
                MODIFY;
            end;
        }

        modify("Unit of Measure Code")
        {
            trigger OnAfterValidate()
            begin
                case Type of
                    Type::Item:
                        begin
                            GetUnitExcise;
                            GetUnitProductTax;
                            MODIFY;
                        end;
                end;
            end;
        }
        field(46015505; "Unit Excise (LCY)"; Decimal)
        {
            Caption = 'Unit Excise (LCY)';
            DecimalPlaces = 2 : 5;
            Description = 'NAVBG11.0,001';

            trigger OnValidate();
            var
                CurrExchRate: Record "Currency Exchange Rate";
            begin
                TestStatusOpen;
                GetSalesHeader;

                if CurrFieldNo = FIELDNO("Unit Excise (LCY)") then begin
                    TESTFIELD("No.");
                    IF "No." <> Item."No." THEN
                        Item.GET("No.");

                    Item.TESTFIELD("Excise Item");
                end;

                if SalesHeader."Currency Code" <> '' then begin
                    Currency.TESTFIELD("Unit-Amount Rounding Precision");
                    "Unit Excise" :=
                      ROUND(
                        CurrExchRate.ExchangeAmtLCYToFCY(
                          GetDate, SalesHeader."Currency Code",
                          "Unit Excise (LCY)", SalesHeader."Currency Factor"),
                          Currency."Unit-Amount Rounding Precision")
                end else
                    "Unit Excise" := "Unit Excise (LCY)";

                "Excise Amount (LCY)" := "Unit Excise (LCY)" * Quantity;

                VALIDATE("Unit Excise");
                VALIDATE("Line Discount %");

            end;
        }
        field(46015506; "Unit Excise"; Decimal)
        {
            Caption = 'Unit Excise';
            DecimalPlaces = 2 : 5;
            Description = 'NAVBG11.0,001';
            Editable = false;

            trigger OnValidate();
            begin
                if CurrFieldNo = FIELDNO("Unit Excise") then begin
                    TESTFIELD("No.");
                    IF "No." <> Item."No." THEN
                        Item.GET("No.");

                    Item.TESTFIELD("Excise Item");
                end;

                "Excise Amount" := "Unit Excise" * Quantity;
            end;
        }
        field(46015507; "Excise Amount (LCY)"; Decimal)
        {
            Caption = 'Excise Amount (LCY)';
            Description = 'NAVBG11.0,001';
            Editable = false;
        }
        field(46015508; "Excise Amount"; Decimal)
        {
            Caption = 'Excise Amount';
            Description = 'NAVBG11.0,001';
            Editable = false;
        }
        field(46015509; "Calculate Excise (Cust.)"; Boolean)
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
        field(46015510; "Unit Product Tax (LCY)"; Decimal)
        {
            Caption = 'Unit Product Tax (LCY)';
            DecimalPlaces = 2 : 5;
            Description = 'NAVBG11.0,001';

            trigger OnValidate();
            var
                CurrExchRate: Record "Currency Exchange Rate";
            begin
                TestStatusOpen;
                GetSalesHeader;

                if SalesHeader."Currency Code" <> '' then begin
                    Currency.TESTFIELD("Unit-Amount Rounding Precision");
                    "Unit Product Tax" :=
                      ROUND(
                        CurrExchRate.ExchangeAmtLCYToFCY(
                          GetDate, SalesHeader."Currency Code",
                          "Unit Product Tax (LCY)", SalesHeader."Currency Factor"),
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
        field(46015511; "Unit Product Tax"; Decimal)
        {
            Caption = 'Unit Product Tax';
            DecimalPlaces = 2 : 5;
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
        field(46015512; "Product Tax Amount (LCY)"; Decimal)
        {
            Caption = 'Product Tax Amount (LCY)';
            Description = 'NAVBG11.0,001';
            Editable = false;
        }
        field(46015513; "Product Tax Amount"; Decimal)
        {
            Caption = 'Product Tax Amount';
            Description = 'NAVBG11.0,001';
            Editable = false;
        }
        field(46015514; "Calculate Product Tax (Cust.)"; Boolean)
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
        field(46015515; Product; Boolean)
        {
            Caption = 'Product';
            Description = 'NAVBG11.0,001';
            Editable = false;
        }
        field(46015516; "Amount Incl. Taxes Excl. VAT"; Decimal)
        {
            Caption = 'Amount Incl. Taxes Excl. VAT';
            Description = 'NAVBG11.0,001';
            Editable = false;
        }
        field(46015517; "Excise Item"; Boolean)
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
        field(46015518; "Calculate Excise"; Boolean)
        {
            Caption = 'Calculate Excise';
            Description = 'NAVBG11.0,001';
            Editable = false;
        }
        field(46015519; "Product Tax Item"; Boolean)
        {
            Caption = 'Product Tax Item';
            Description = 'NAVBG11.0,001';

            trigger OnValidate();
            begin
                if CurrFieldNo <> FIELDNO("Calculate Product Tax (Cust.)") then
                    VALIDATE("Calculate Product Tax (Cust.)");
            end;
        }
        field(46015520; "Calculate Product Tax"; Boolean)
        {
            Caption = 'Calculate Product Tax';
            Description = 'NAVBG11.0,001';
        }
        field(46015540; "VAT Clause Description"; Text[250])
        {
            Caption = 'VAT Clause Description';
            Description = 'NAVBG11.0.001';
            TableRelation = "VAT Clause";
        }
        field(46015541; "Amount for Print Preview"; Integer)
        {
            Caption = 'Amount for Print Preview';
            Description = 'NAVBG11.0.001';
            TableRelation = "Sales Line"."Line No." WHERE("Document Type" = FIELD("Document Type"),
                                                           "Document No." = FIELD("Document No."));

            trigger OnValidate();
            begin
                if "Amount for Print Preview" <> 0 then
                    if "Quantity and Amount for Print" <> 0 then
                        ERROR(STRSUBSTNO(Text50000, FIELDCAPTION("Amount for Print Preview"), FIELDCAPTION("Quantity and Amount for Print")));
            end;
        }
        field(46015542; "Quantity and Amount for Print"; Integer)
        {
            Caption = 'Quantity and Amount for Print';
            Description = 'NAVBG11.0.001';
            TableRelation = "Sales Line"."Line No." WHERE("Document Type" = FIELD("Document Type"),
                                                           "Document No." = FIELD("Document No."));

            trigger OnValidate();
            begin
                if "Quantity and Amount for Print" <> 0 then
                    if "Amount for Print Preview" <> 0 then
                        ERROR(STRSUBSTNO(Text50000, FIELDCAPTION("Amount for Print Preview"), FIELDCAPTION("Quantity and Amount for Print")));
            end;
        }
        field(46015543; "Outbound Excise Destination"; Code[2])
        {
            Caption = 'Outbound Excise Destination';
            Description = 'NAVBG11.0.001';
            TableRelation = "Excise Destination".Code WHERE("Destination Type" = CONST(Outbound));
        }
        field(46015544; "CN Code"; Code[10])
        {
            Caption = 'CN Code';
            Description = 'NAVBG11.0.001';
        }
        field(46015545; "Alcohol Content/Degree Plato"; Decimal)
        {
            Caption = 'Alcohol Content/Degree Plato';
            Description = 'NAVBG11.0.001';
        }
        field(46015546; "Excise Unit of Measure"; Code[10])
        {
            Caption = 'Excise Unit of Measure';
            Description = 'NAVBG11.0.001';
        }
        field(46015547; "Excise Rate"; Decimal)
        {
            Caption = 'Excise Rate';
            Description = 'NAVBG11.0.001';
        }
        field(46015548; "Excise Charge Acc. Base"; Decimal)
        {
            Caption = 'Excise Charge Acc. Base';
            Description = 'NAVBG11.0.001';
        }
        field(46015549; "Additional Excise Code"; Text[13])
        {
            Caption = 'Additional Excise Code';
            Description = 'NAVBG11.0.001';
            Numeric = true;
        }
        field(46015550; "Do not include in Excise"; Boolean)
        {
            Caption = 'Do not include in Excise';
            Description = 'NAVBG11.0.001';
        }
        field(46015551; "Inbound excise destination"; Code[2])
        {
            Caption = 'Inbound excise destination';
            Description = 'NAVBG11.0.001';
            TableRelation = "Excise Destination".Code WHERE("Destination Type" = CONST(Inbound));
        }
        field(46015552; "Excise Declaration Correction"; Boolean)
        {
            Caption = 'Excise Declaration Correction';
            Description = 'NAVBG11.0.001';
        }
        field(46015553; "Payment Obligation Type"; Code[2])
        {
            Caption = 'Payment Obligation Type';
            Description = 'NAVBG11.0.001';
            TableRelation = "Payment Obligation Type";
        }
        field(46015607; "Tariff No."; Code[10])
        {
            Caption = 'Tariff No.';
            Description = 'NAVE111.0,001';
            TableRelation = "Tariff Number";
        }
        field(46015609; "Country/Region of Origin Code"; Code[10])
        {
            Caption = 'Country/Region of Origin Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Country/Region";
        }
        field(46015610; "VAT Date"; Date)
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
                          GLSetup.TABLECAPTION, FIELDCAPTION("VAT Date"));
                end;
            end;
        }
        field(46015615; Negative; Boolean)
        {
            Caption = 'Negative';
            Description = 'NAVE111.0,001';
        }
    }

    var
        DiscBase: Decimal;
        TotalAmountInclTaxExclVAT: Decimal;
        NewAmountInclTaxExclVAT: Decimal;
        Text017: Label '\The entered information may be disregarded by warehouse operations.';
        GLSetupRead: Boolean;
        Cust: Record Customer;
        CustPostingGroup: Record "Customer Posting Group";
        SalesHeader: Record "Sales Header";
        Currency: Record Currency;
        Item: Record Item;
        Text46012225: Label 'You must check field %1 in %2 to be able to change the %3 field manually.';
        Text46012226: TextConst ENU = 'cannot be changed while there is a related %1=%2 in %3=%4';
        GLSetup: Record "General Ledger Setup";
        VATClause: Record "VAT Clause";
        Text50000: Label 'Only one of the fields "%1", "%2"  can have a value';
        ExciseLabel: Record "Excise Label";
        Text46012227: Label '"This action will lead to the loosing excise labels data that is specified for this sales line.\Do you want to continue?  "';

    trigger OnBeforeDelete()
    begin
        DeleteExciseLabels(true);
    end;

    procedure UpdateExciseAmounts();
    var
        Item: Record Item;
    begin
        "Excise Amount (LCY)" := "Unit Excise (LCY)" * Quantity;
        "Excise Amount" := "Unit Excise" * Quantity;
        Item.GET("No.");
        if Item."Excise Per Exc. Decl. UM (LCY)" > 0 then
            "Excise Charge Acc. Base" := "Excise Amount" / Item."Excise Per Exc. Decl. UM (LCY)";
    end;

    procedure UpdateProductTaxAmounts();
    begin
        "Product Tax Amount (LCY)" := "Unit Product Tax (LCY)" * Quantity;
        "Product Tax Amount" := "Unit Product Tax" * Quantity;
    end;

    procedure CalcDiscBase(): Decimal;
    begin
        TESTFIELD("Document No.");
        IF ("Document Type" <> SalesHeader."Document Type") OR ("Document No." <> SalesHeader."No.") THEN BEGIN
            SalesHeader.GET("Document Type", "Document No.");
            IF SalesHeader."Currency Code" = '' THEN
                Currency.InitRoundingPrecision
            ELSE BEGIN
                SalesHeader.TESTFIELD("Currency Factor");
                Currency.GET(SalesHeader."Currency Code");
                Currency.TESTFIELD("Amount Rounding Precision");
            END;
        END;

        if SalesHeader."Prices Including VAT" then
            exit("Unit Price");

        exit("Unit Price" + "Unit Excise" + "Unit Product Tax");
    end;


    procedure GetUnitExcise();
    var
        UOMMgt: Codeunit "Unit of Measure Management";
    begin
        if (Type <> Type::Item) or ("No." = '') then begin
            VALIDATE("Unit Excise (LCY)", 0);
            exit;
        end;

        if "Calculate Excise" then begin
            TESTFIELD("No.");
            IF "No." <> Item."No." THEN
                Item.GET("No.");

            "Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item, "Unit of Measure Code");

            VALIDATE("Unit Excise (LCY)", Item."Unit Excise (LCY)" * "Qty. per Unit of Measure");
        end else
            VALIDATE("Unit Excise (LCY)", 0);
    end;

    procedure GetUnitProductTax();
    var
        ProductTaxCalcMgt: Codeunit "Product Tax Calc. Mgt.";
    begin
        if (Type <> Type::Item) or ("No." = '') then begin
            VALIDATE("Unit Product Tax (LCY)", 0);
            exit;
        end;

        if "Calculate Product Tax" then begin
            TESTFIELD("No.");
            VALIDATE("Unit Product Tax (LCY)", ProductTaxCalcMgt.CalcTotalTax("No.", "Variant Code", "Unit of Measure Code"));
        end else
            VALIDATE("Unit Product Tax (LCY)", 0);
    END;

    local procedure GetGLSetup();
    begin
        if not GLSetupRead then
            GLSetup.GET;
        GLSetupRead := true;
    end;

    procedure UpdateExciseLabel(PostingDate: Date);
    begin
        ExciseLabel.RESET;
        ExciseLabel.SETRANGE("Entry Type", ExciseLabel."Entry Type"::Sale);
        ExciseLabel.SETRANGE("Document Type", "Document Type");
        ExciseLabel.SETRANGE("Document No.", "Document No.");
        ExciseLabel.SETRANGE("Document Line No.", "Line No.");

        if ExciseLabel.FINDFIRST then
            repeat
                ExciseLabel."Posting Date" := PostingDate;
                ExciseLabel.MODIFY;
            until ExciseLabel.NEXT = 0;
    end;

    procedure DeleteExciseLabels(IsWarning: Boolean);
    begin
        //NAVBG11.0; 001; entire function
        ExciseLabel.RESET;
        ExciseLabel.SETRANGE("Entry Type", ExciseLabel."Entry Type"::Sale);
        ExciseLabel.SETRANGE("Document Type", "Document Type");
        ExciseLabel.SETRANGE("Document No.", "Document No.");
        ExciseLabel.SETRANGE("Document Line No.", "Line No.");

        if ExciseLabel.FINDFIRST then begin
            if IsWarning and (not CONFIRM(Text46012227, false)) then
                ERROR('');

            ExciseLabel.DELETEALL;
        end;
    end;

    procedure ShowExciseLabels();
    var
        Item2: Record Item;
    begin
        TESTFIELD(Type, Type::Item.AsInteger());
        Item2.GET("No.");
        Item2.TESTFIELD("Excise Item");
        TESTFIELD(Quantity);

        ExciseLabel.RESET;
        ExciseLabel.FILTERGROUP := 2;
        ExciseLabel.SETRANGE("Entry Type", ExciseLabel."Entry Type"::Sale);
        ExciseLabel.SETRANGE("Document Type", "Document Type");
        ExciseLabel.SETRANGE("Document No.", "Document No.");
        ExciseLabel.SETRANGE("Document Line No.", "Line No.");
        ExciseLabel.FILTERGROUP := 0;
        //TODO: After adding the page
        //PAGE.RUNMODAL(PAGE::Page46015717,ExciseLabel);
    end;

    procedure GetDefaultBinLoc()
    var
        Location: Record Location;
        WMSManagement: codeunit "WMS Management";
        WhseIntegrationMgt: Codeunit "Whse. Integration Management";
    begin
        IF Type <> Type::Item THEN
            EXIT;

        "Bin Code" := '';
        IF "Drop Shipment" THEN
            EXIT;

        IF ("Location Code" <> '') AND ("No." <> '') THEN BEGIN
            IF "Location Code" = '' THEN
                CLEAR(Location)
            ELSE
                IF Location.Code <> "Location Code" THEN
                    Location.GET("Location Code");
            IF Location."Bin Mandatory" AND NOT Location."Directed Put-away and Pick" THEN BEGIN
                IF ("Qty. to Assemble to Order" > 0) OR IsAsmToOrderRequired THEN
                    IF GetATOBin(Location, "Bin Code") THEN
                        EXIT;

                WMSManagement.GetDefaultBin("No.", "Variant Code", "Location Code", "Bin Code");
                IF NOT IsInbound AND ("Quantity (Base)" <> 0) THEN
                    WhseIntegrationMgt.CheckIfBinDedicatedOnSrcDoc("Location Code", "Bin Code", false);
            END;
        END;
    end;

    local procedure UpdateBaseAmountsBG(NewAmount: Decimal; NewAmountIncludingVAT: Decimal; NewVATBaseAmount: Decimal; NewAmountInclTaxExclVAT: Decimal);
    begin
        if (SalesHeader.Status = SalesHeader.Status::Released) then begin
            Amount := NewAmount;
            "Amount Incl. Taxes Excl. VAT" := NewAmountInclTaxExclVAT;
            "Amount Including VAT" := ROUND(NewAmountIncludingVAT, Currency."Amount Rounding Precision");
            "VAT Base Amount" := NewVATBaseAmount;
        end;

        if not SalesHeader."Prices Including VAT" and (Amount > 0) and (Amount < "Prepmt. Line Amount") then
            "Prepmt. Line Amount" := Amount;
        if SalesHeader."Prices Including VAT" and ("Amount Including VAT" > 0) and ("Amount Including VAT" < "Prepmt. Line Amount") then
            "Prepmt. Line Amount" := "Amount Including VAT";
    end;
}
//
