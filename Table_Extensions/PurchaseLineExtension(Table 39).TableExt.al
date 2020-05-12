tableextension 46015566 "Purchase Line Extension" extends "Purchase Line"
{
    // version NAVW111.00.00.28629,NAVE111.0,NAVBG11.0

    //TODO

    fields
    {

        //Unsupported feature: CodeModification on "Type(Field 5).OnValidate". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        GetPurchHeader;
        TestStatusOpen;

        #4..24
            FIELDCAPTION(Type),FIELDCAPTION("Prod. Order No."),"Prod. Order No.");

        if Type <> xRec.Type then begin
          if Quantity <> 0 then begin
            ReservePurchLine.VerifyChange(Rec,xRec);
            CALCFIELDS("Reserved Qty. (Base)");
        #31..58
          "Allow Item Charge Assignment" := true
        else
          "Allow Item Charge Assignment" := false;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..27
          //NAVBG11.0; 001; begin
          if LocalizationUsage.UseEastLocalization then
            DeleteExciseLabels(true);
          //NAVBG11.0; 001; end;

        #28..61
        */
        //end;


        //Unsupported feature: CodeModification on ""No."(Field 6).OnValidate". Please convert manually.

        //trigger "(Field 6)();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        "No." := FindRecordMgt.FindNoFromTypedValue(Type,"No.",not "System-Created Entry");

        TestStatusOpen;
        #4..24
            FIELDCAPTION(Type),FIELDCAPTION("Prod. Order No."),"Prod. Order No.");

        if "No." <> xRec."No." then begin
          if (Quantity <> 0) and ItemExists(xRec."No.") then begin
            ReservePurchLine.VerifyChange(Rec,xRec);
            CALCFIELDS("Reserved Qty. (Base)");
        #31..54
        "System-Created Entry" := TempPurchLine."System-Created Entry";
        GetPurchHeader;
        InitHeaderDefaults(PurchHeader);
        UpdateLeadTimeFields;
        UpdateDates;

        #61..74
            CopyFromItemCharge;
        end;

        OnAfterAssignFieldsForNo(Rec,xRec,PurchHeader);

        if HasTypeToFillMandatoryFields and not (Type = Type::"Fixed Asset") then
          VALIDATE("VAT Prod. Posting Group");

        UpdatePrepmtSetupFields;
        #84..123

        PostingSetupMgt.CheckGenPostingSetupPurchAccount("Gen. Bus. Posting Group","Gen. Prod. Posting Group");
        PostingSetupMgt.CheckVATPostingSetupPurchAccount("VAT Bus. Posting Group","VAT Prod. Posting Group");
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..27

          //NAVBG11.0; 001; begin
          if LocalizationUsage.UseEastLocalization then
            DeleteExciseLabels(true);
          //NAVBG11.0; 001; end

        #28..57
        //NAVE111.0; 001; begin
        if LocalizationUsage.UseEastLocalization then begin
          "SAD No." := PurchHeader."SAD No.";
          "VAT Date" := PurchHeader."VAT Date";
        end;
        //NAVE111.0; 001; end

        #58..77

        //NAVE111.0; 001; begin
        if Type in [Type::"G/L Account",Type::Item,Type::"Fixed Asset"] then begin
          if VATPostingSetup.GET("VAT Bus. Posting Group","VAT Prod. Posting Group") and LocalizationUsage.UseEastLocalization then
            VALIDATE("VAT % (Non Deductible)",GetVATDeduction);
        end;
        //NAVE111.0; 001; end
        #78..80

        #81..126
        */
        //end;


        //Unsupported feature: CodeModification on "Quantity(Field 15).OnValidate". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        TestStatusOpen;

        if "Drop Shipment" and ("Document Type" <> "Document Type"::Invoice) then
        #4..71
          Amount := 0;
          "Amount Including VAT" := 0;
          "VAT Base Amount" := 0;
        end;

        UpdatePrePaymentAmounts;

        #79..84
        end;

        CheckWMS;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..74

          //NAVE111.0; 001; begin
          if LocalizationUsage.UseEastLocalization then begin
            "VAT Base (Non Deductible)" := 0;
            "VAT Amount (Non Deductible)" := 0;
          end;
          //NAVE111.0; 001; end

        end;

        //NAVE111.0; 001; begin
        if LocalizationUsage.UseEastLocalization then
          SetDefaultQuantity;
        //NAVE111.0; 001; end
        #76..87
        */
        //end;


        //Unsupported feature: CodeModification on "Amount(Field 29).OnValidate". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        GetPurchHeader;
        Amount := ROUND(Amount,Currency."Amount Rounding Precision");
        case "VAT Calculation Type" of
          "VAT Calculation Type"::"Normal VAT",
          "VAT Calculation Type"::"Reverse Charge VAT":
            begin
              "VAT Base Amount" :=
                ROUND(Amount * (1 - PurchHeader."VAT Base Discount %" / 100),Currency."Amount Rounding Precision");
              "Amount Including VAT" :=
                ROUND(Amount + "VAT Base Amount" * "VAT %" / 100,Currency."Amount Rounding Precision");
            end;
        #12..39

        InitOutstandingAmount;
        UpdateUnitCost;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..8

              //NAVE111.0; 001; begin
              if (Type in [Type::"G/L Account",Type::Item,Type::"Fixed Asset"]) and LocalizationUsage.UseEastLocalization then
                "VAT Base (Non Deductible)" :=
                  ROUND("VAT Base Amount" * "VAT % (Non Deductible)" / 100,Currency."Amount Rounding Precision");
              //NAVE111.0; 001; end

        #9..42
        */
        //end;


        //Unsupported feature: CodeModification on ""Amount Including VAT"(Field 30).OnValidate". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        GetPurchHeader;
        "Amount Including VAT" := ROUND("Amount Including VAT",Currency."Amount Rounding Precision");
        case "VAT Calculation Type" of
        #4..10
                  Currency."Amount Rounding Precision");
              "VAT Base Amount" :=
                ROUND(Amount * (1 - PurchHeader."VAT Base Discount %" / 100),Currency."Amount Rounding Precision");
            end;
          "VAT Calculation Type"::"Full VAT":
            begin
        #17..41

        InitOutstandingAmount;
        UpdateUnitCost;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..13

              //NAVE111.0; 001; begin
              if (Type in [Type::"G/L Account",Type::Item,Type::"Fixed Asset"]) and LocalizationUsage.UseEastLocalization then
                "VAT Base (Non Deductible)" :=
                  ROUND("VAT Base Amount" * "VAT % (Non Deductible)" / 100,Currency."Amount Rounding Precision");
              //NAVE111.0; 001; end

        #14..44
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
        GetPurchHeader;
        "VAT %" := VATPostingSetup."VAT %";
        "VAT Calculation Type" := VATPostingSetup."VAT Calculation Type";
        "VAT Identifier" := VATPostingSetup."VAT Identifier";
        case "VAT Calculation Type" of
          "VAT Calculation Type"::"Reverse Charge VAT",
          "VAT Calculation Type"::"Sales Tax":
        #11..19
            ROUND(
              "Direct Unit Cost" * (100 + "VAT %") / (100 + xRec."VAT %"),
              Currency."Unit-Amount Rounding Precision");
        UpdateAmounts;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..7

        // NAVBG11.0.001 begin
        "VAT Clause Code" := VATPostingSetup."VAT Clause Code";
        VATClause.GET("VAT Clause Code");
        "VAT Clause Description" := VATClause.Description;
        // NAVBG11.0.001 end

        #8..22

        //NAVE111.0; 001; begin
        if (Type in [Type::"G/L Account",Type::Item,Type::"Fixed Asset"]) and LocalizationUsage.UseEastLocalization then
          VALIDATE("VAT % (Non Deductible)",GetVATDeduction);
        //NAVE111.0; 001; end

        UpdateAmounts;

        //NAVE111.0; 001; begin
        if LocalizationUsage.UseEastLocalization then
          VALIDATE("Prepayment %");
        //NAVE111.0; 001; end
        */
        //end;


        //Unsupported feature: CodeModification on ""Prepmt Amt to Deduct"(Field 121).OnValidate". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        if "Prepmt Amt to Deduct" > "Prepmt. Amt. Inv." - "Prepmt Amt Deducted" then
          FIELDERROR(
            "Prepmt Amt to Deduct",
            STRSUBSTNO(Text039,"Prepmt. Amt. Inv." - "Prepmt Amt Deducted"));

        if "Prepmt Amt to Deduct" > "Qty. to Invoice" * "Direct Unit Cost" then
          FIELDERROR(
            "Prepmt Amt to Deduct",
        #9..14
            STRSUBSTNO(Text038,
              "Prepmt. Amt. Inv." - "Prepmt Amt Deducted" -
              (Quantity - "Qty. to Invoice" - "Quantity Invoiced") * "Direct Unit Cost"));
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..5
        //NAVE111.0; 001; begin
        if ("Qty. to Invoice" = Quantity - "Quantity Invoiced") and LocalizationUsage.UseEastLocalization then
          TESTFIELD("Prepmt Amt to Deduct","Prepmt. Amt. Inv." - "Prepmt Amt Deducted");
        //NAVE111.0; 001; end

        #6..17
        */
        //end;
        field(46015539; "VAT Clause Code"; Code[10])
        {
            Caption = 'VAT Clause Code';
            Description = 'NAVBG11.0.001';
            TableRelation = "VAT Clause";
        }
        field(46015540; "VAT Clause Description"; Text[250])
        {
            Caption = 'VAT Clause Description';
            Description = 'NAVBG11.0.001';
            TableRelation = "VAT Clause";
        }
        field(46015543; "Inbound Excise Destination"; Code[2])
        {
            Caption = 'Inbound Excise Destination';
            Description = 'NAVBG11.0.001';
            TableRelation = "Excise Destination";
        }
        field(46015549; "Additional Excise Code"; Text[13])
        {
            Caption = 'Additional Excise Code';
            Description = 'NAVBG11.0.001';
            Numeric = true;
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
                //TO DO
                /*
                if CurrFieldNo = FIELDNO("VAT Date") then begin
                  GetGLSetup;
                  if not GLSetup."Allow VAT Date Change in Lines" then
                    ERROR(Text46012225,
                      GLSetup.FIELDCAPTION("Allow VAT Date Change in Lines"),
                      GLSetup.TABLECAPTION,FIELDCAPTION("VAT Date"));
                end;
                if Type in [Type::"G/L Account",Type::Item,Type::"Fixed Asset"] then begin
                  VATPostingSetup.GET("VAT Bus. Posting Group","VAT Prod. Posting Group");
                  VALIDATE("VAT % (Non Deductible)",GetVATDeduction);
                end;
                */
            end;
        }
        field(46015615; Negative; Boolean)
        {
            Caption = 'Negative';
            Description = 'NAVE111.0,001';
        }
        field(46015625; "SAD No."; Code[20])
        {
            Caption = 'SAD No.';
            Description = 'NAVE111.0,001';
            TableRelation = "Import SAD Header" WHERE("Vendor No." = FIELD("Buy-from Vendor No."));
        }
        field(46015635; "VAT % (Non Deductible)"; Decimal)
        {
            Caption = 'VAT % (Non Deductible)';
            Description = 'NAVE111.0,001';
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate();
            begin
                //TO DO
                /*
                if Type in [Type::"G/L Account",Type::Item,Type::"Fixed Asset"] then begin
                  "VAT Base (Non Deductible)" :=
                    ROUND("Line Amount" * "VAT % (Non Deductible)" / 100,Currency."Amount Rounding Precision");
                  "VAT Amount (Non Deductible)" :=
                    ROUND("VAT Base (Non Deductible)" * "VAT %" / 100,Currency."Amount Rounding Precision");
                end;
                */
            end;
        }
        field(46015636; "VAT Base (Non Deductible)"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            Caption = 'VAT Base (Non Deductible)';
            Description = 'NAVE111.0,001';
            Editable = false;
        }
        field(46015637; "VAT Amount (Non Deductible)"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            Caption = 'VAT Amount (Non Deductible)';
            Description = 'NAVE111.0,001';
            Editable = false;
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
      ReservePurchLine.DeleteLine(Rec);
      if "Receipt No." = '' then
    #5..33
        SalesOrderLine.MODIFY;
      end;
    end;

    NonstockItemMgt.DelNonStockPurch(Rec);

    if "Document Type" = "Document Type"::"Blanket Order" then begin
    #41..69
    // In case we have roundings on VAT or Sales Tax, we should update some other line
    if (Type <> Type::" ") and ("Line No." <> 0) and ("Attached to Line No." = 0) and
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
        DeferralUtilities.GetPurchDeferralDocType,'','',
        "Document Type","Document No.","Line No.");
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    TestStatusOpen;
    //NAVBG11.0; 001; begin
    if LocalizationUsage.UseEastLocalization then
      DeleteExciseLabels(false);
    //NAVBG11.0; 001; end

    #2..36
    #38..72
    then
      VALIDATE(Quantity,0);
    #81..85
    */
    //end;

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
        Vendor: Record Vendor;
        VendorPostingGroup: Record "Vendor Posting Group";

    var
        AbsoluteAdvCorrection: Boolean;
        PrepmtPct: Decimal;

    var
        Text017: Label '\The entered information may be disregarded by warehouse operations.';

    var
        PurchaseSetup: Record "Purchases & Payables Setup";
        Text46012225: Label 'You must check field %1 in %2 to be able to change the %3 field manually.';
        Text46012226: TextConst ENU = 'cannot be changed while there is a related %1=%2 in %3=%4';
        VATClause: Record "VAT Clause";
        ExciseLabel: Record "Excise Label";
        Text46012227: Label '"This action will lead to the loosing excise labels data that is specified for this sales line.\Do you want to continue?  "';
}

