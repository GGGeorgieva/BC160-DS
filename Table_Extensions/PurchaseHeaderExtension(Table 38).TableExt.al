tableextension 46015562 "Purchase Header Extension" extends "Purchase Header"
{
    // version NAVW111.00.00.28629,NAVE111.0,NAVBG11.0

    fields
    {

        //Unsupported feature: CodeModification on ""Buy-from Vendor No."(Field 2).OnValidate". Please convert manually.

        //trigger "(Field 2)();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        if "No." = '' then
          InitRecord;
        TESTFIELD(Status,Status::Open);
        #4..37
        "Tax Liable" := Vend."Tax Liable";
        "VAT Country/Region Code" := Vend."Country/Region Code";
        "VAT Registration No." := Vend."VAT Registration No.";
        VALIDATE("Lead Time Calculation",Vend."Lead Time Calculation");
        "Responsibility Center" := UserSetupMgt.GetRespCenter(1,Vend."Responsibility Center");
        ValidateEmptySellToCustomerAndLocation;
        #44..83

        if (xRec."Buy-from Vendor No." <> '') and (xRec."Buy-from Vendor No." <> "Buy-from Vendor No.") then
          RecallModifyAddressNotification(GetModifyVendorAddressNotificationId);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..40

        //NAVE111.0; 001; begin
        if LocalizationUsage.UseEastLocalization then begin
          "Registration No." := Vend."Registration No.";
          "Registration No. 2" := Vend."Registration No. 2";
          "Identification No." := Vend."Identification No.";
        end;
        //NAVE111.0; 001; end

        #41..86
        //NAVE111.0; 001; begin
        if LocalizationUsage.UseEastLocalization then begin
          VALIDATE("Transaction Type",Vend."Transaction Type");
          VALIDATE("Transaction Specification",Vend."Transaction Specification");
          VALIDATE("Transport Method",Vend."Transport Method");
        end;
        //NAVE111.0; 001; end

        //NAVBG11.0; 001; begin
        if LocalizationUsage.UseBulgarianLocalization then
          VALIDATE( "VAT Bus. Posting Group", Vend."VAT Bus. Posting Group" );
        //NAVBG11.0; 001; end
        */
        //end;


        //Unsupported feature: CodeModification on ""Pay-to Vendor No."(Field 4).OnValidate". Please convert manually.

        //trigger "(Field 4)();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        TESTFIELD(Status,Status::Open);
        if (xRec."Pay-to Vendor No." <> "Pay-to Vendor No.") and
           (xRec."Pay-to Vendor No." <> '')
        then begin
        #5..26
        "Pay-to Name" := Vend.Name;
        "Pay-to Name 2" := Vend."Name 2";
        CopyPayToVendorAddressFieldsFromVendor(Vend,false);
        if not SkipPayToContact then
          "Pay-to Contact" := Vend.Contact;
        "Payment Terms Code" := Vend."Payment Terms Code";
        #33..60
        VALIDATE("Currency Code");
        VALIDATE("Creditor No.",Vend."Creditor No.");

        OnValidatePurchaseHeaderPayToVendorNo(Vend);

        if "Document Type" = "Document Type"::Order then
        #67..88

        if (xRec."Pay-to Vendor No." <> '') and (xRec."Pay-to Vendor No." <> "Pay-to Vendor No.") then
          RecallModifyAddressNotification(GetModifyPayToVendorAddressNotificationId);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        TESTFIELD(Status,Status::Open);

        //NAVE111.0; 001; begin
        if ("SAD No." <> '') and LocalizationUsage.UseEastLocalization then begin
          SADHeader.GET("SAD No.");
          if (SADHeader."Vendor No." <> '') and (SADHeader."Vendor No." <> "Pay-to Vendor No.") then
            FIELDERROR("Pay-to Vendor No.");
        end;
        //NAVE111.0; 001; end

        #2..29

        //NAVE111.0; 001; begin
        if LocalizationUsage.UseEastLocalization then begin
          "VAT Country/Region Code" := Vend."Country/Region Code";
          "Industry Code" := Vend."Industry Code";
        end;
        //NAVE111.0; 001; end

        #30..63
        //NAVE111.0; 001; begin
        if LocalizationUsage.UseEastLocalization then begin
          "Registration No." := Vend."Registration No.";
          "Registration No. 2" := Vend."Registration No. 2";
          "Identification No." := Vend."Identification No.";
        end;
        //NAVE111.0; 001; end
        #64..91
        */
        //end;


        //Unsupported feature: CodeModification on ""Posting Date"(Field 20).OnValidate". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        TestNoSeriesDate(
          "Posting No.","Posting No. Series",
          FIELDCAPTION("Posting No."),FIELDCAPTION("Posting No. Series"));
        #4..10
        if "Incoming Document Entry No." = 0 then
          VALIDATE("Document Date","Posting Date");

        if ("Document Type" in ["Document Type"::Invoice,"Document Type"::"Credit Memo"]) and
           not ("Posting Date" = xRec."Posting Date")
        then
        #17..27

        if PurchLinesExist then
          JobUpdatePurchLines(SkipJobCurrFactorUpdate);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..13
        //NAVE111.0; 001; begin
        if LocalizationUsage.UseEastLocalization then begin
          PurchSetup.GET;
          if PurchSetup."Default VAT Date" = PurchSetup."Default VAT Date"::"Posting Date" then
            VALIDATE("VAT Date","Posting Date");
        end;
        //NAVE111.0; 001; end

        #14..30

        //NAVBG11.0; 001; begin
        if LocalizationUsage.UseEastLocalization then
          if "Posting Date" <> xRec."Posting Date" then
            UpdateExciseLabels;
        //NAVBG11.0; 011; end
        */
        //end;


        //Unsupported feature: CodeInsertion on ""Vendor Posting Group"(Field 31)". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //begin
        /*
        //NAVE111.0; 001; begin
        if (CurrFieldNo = FIELDNO("Vendor Posting Group")) and
           ("Vendor Posting Group" <> xRec."Vendor Posting Group") and
           LocalizationUsage.UseEastLocalization
        then begin
          PurchSetup.GET;
          if PurchSetup."Allow Alter Posting Groups" then begin
            if not SubstVendPostingGrp.GET(xRec."Vendor Posting Group","Vendor Posting Group") then
              ERROR(Text46012225,xRec."Vendor Posting Group","Vendor Posting Group",SubstVendPostingGrp.TABLECAPTION);
          end else
            ERROR(Text46012226,FIELDCAPTION("Vendor Posting Group"),PurchSetup.FIELDCAPTION("Allow Alter Posting Groups"));
        end;
        //NAVE111.0; 001; end
        */
        //end;


        //Unsupported feature: CodeModification on ""Currency Code"(Field 32).OnValidate". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        if not (CurrFieldNo in [0,FIELDNO("Posting Date")]) or ("Currency Code" <> xRec."Currency Code") then
          TESTFIELD(Status,Status::Open);
        if (CurrFieldNo <> FIELDNO("Currency Code")) and ("Currency Code" = xRec."Currency Code") then
          UpdateCurrencyFactor
        else
        #6..17
              if "Currency Factor" <> xRec."Currency Factor" then
                ConfirmUpdateCurrencyFactor;
            end;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        if not (CurrFieldNo in [0,FIELDNO("Posting Date")]) or ("Currency Code" <> xRec."Currency Code") then
          TESTFIELD(Status,Status::Open);

        //NAVE111.0; 001; begin
        if LocalizationUsage.UseEastLocalization then begin
                if ("SAD No." <> '') then begin
                  SADHeader.GET("SAD No.");
                  if SADHeader."Customs Currency Code" <> "Currency Code" then
                    FIELDERROR("Currency Code");
                end;
                if (CurrFieldNo <> FIELDNO("Currency Code")) and ("Currency Code" = xRec."Currency Code") and
                  (CurrFieldNo <> FIELDNO("SAD No.")) then
                    UpdateCurrencyFactor
                else
                  if "Currency Code" <> xRec."Currency Code" then begin
                    UpdateCurrencyFactor;
                    if PurchLinesExist then
                      if CONFIRM(ChangeCurrencyQst,false,FIELDCAPTION("Currency Code")) then begin
                        SetHideValidationDialog(true);
                        RecreatePurchLines(FIELDCAPTION("Currency Code"));
                        SetHideValidationDialog(false);
                      end else
                        ERROR(Text018,FIELDCAPTION("Currency Code"));
                  end else
                    if "Currency Code" <> '' then begin
                      UpdateCurrencyFactor;
                      if "Currency Factor" <> xRec."Currency Factor" then
                        ConfirmUpdateCurrencyFactor;
                    end;

        end else
        //NAVE111.0; 001; end
        #3..20
        */
        //end;


        //Unsupported feature: CodeModification on ""Applies-to Doc. No."(Field 53).OnLookup". Please convert manually.

        //trigger  No();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        TESTFIELD("Bal. Account No.",'');
        VendLedgEntry.SETCURRENTKEY("Vendor No.",Open,Positive,"Due Date");
        VendLedgEntry.SETRANGE("Vendor No.","Pay-to Vendor No.");
        #4..28
            "Currency Code",VendLedgEntry."Currency Code",GenJnlLine."Account Type"::Vendor,true);
          "Applies-to Doc. Type" := VendLedgEntry."Document Type";
          "Applies-to Doc. No." := VendLedgEntry."Document No.";
        end;
        CLEAR(ApplyVendEntries);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..31

          //NAVE111.0; 001; begin
          if LocalizationUsage.UseEastLocalization then
            if "Applies-to Doc. Type" = "Applies-to Doc. Type"::Invoice then begin
              "To Invoice No." := "Applies-to Doc. No.";
              "To Invoice Date" := VendLedgEntry."Posting Date";
            end else begin
              "To Invoice No." := '';
              "To Invoice Date" := 0D;
            end;
          //NAVE111.0; 001; end

        end;
        CLEAR(ApplyVendEntries);
        */
        //end;


        //Unsupported feature: CodeModification on ""Applies-to Doc. No."(Field 53).OnValidate". Please convert manually.

        //trigger  No();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        if "Applies-to Doc. No." <> '' then
          TESTFIELD("Bal. Account No.",'');

        if ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") and (xRec."Applies-to Doc. No." <> '') and
           ("Applies-to Doc. No." <> '')
        #6..11
          else
            if ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") and ("Applies-to Doc. No." = '') then
              SetAmountToApply(xRec."Applies-to Doc. No.","Buy-from Vendor No.");
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        if "Applies-to Doc. No." <> '' then
          TESTFIELD("Bal. Account No.",'')

        //NAVE111.0; 001; begin
        else
          if LocalizationUsage.UseEastLocalization then
            VALIDATE("To Invoice No.",'');
        //NAVE111.0; 001; end
        #3..14
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

        //NAVE111.0; 001; begin
        if LocalizationUsage.UseEastLocalization then
          if "Applies-to Doc. Type" = "Applies-to Doc. Type"::Invoice then begin
            "To Invoice No." := "Applies-to Doc. No.";
            "To Invoice Date" := VendLedgEntry."Posting Date";
          end else begin
            "To Invoice No." := '';
            "To Invoice Date" := 0D;
          end;
        //NAVE111.0; 001; end
        */
        //end;


        //Unsupported feature: CodeInsertion on ""VAT Bus. Posting Group"(Field 116).OnValidate". Please convert manually.

        //trigger (Variable: VATBusPostingGroup)();
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
        if (xRec."Buy-from Vendor No." = "Buy-from Vendor No.") and
           (xRec."VAT Bus. Posting Group" <> "VAT Bus. Posting Group")
        then
          RecreatePurchLines(FIELDCAPTION("VAT Bus. Posting Group"));
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..5

        //NAVBG11.0; 001; begin
        if VATBusPostingGroup.GET( "VAT Bus. Posting Group" ) and LocalizationUsage.UseBulgarianLocalization then
          "Unrealized VAT" := VATBusPostingGroup."Unrealized VAT";
        //NAVBG11.0; 001; end
        */
        //end;
        field(46015505; "Identification No."; Text[13])
        {
            Caption = 'Identification No.';
            Description = 'NAVBG11.0,001';
        }
        field(46015507; "Debit Memo"; Boolean)
        {
            Caption = 'Debit Memo';
            Description = 'NAVBG11.0,001';
        }
        field(46015508; "To Invoice No."; Code[20])
        {
            Caption = 'To Invoice No.';
            Description = 'NAVBG11.0,001';
            TableRelation = "Purch. Inv. Header"."No." WHERE("Buy-from Vendor No." = FIELD("Buy-from Vendor No."));

            trigger OnValidate();
            var
                PurchInvHeader: Record "Purch. Inv. Header";
            begin
                if "To Invoice No." <> '' then begin
                    TESTFIELD("Applies-to Doc. No.", '');
                    if PurchInvHeader.GET("To Invoice No.") then
                        "To Invoice Date" := PurchInvHeader."Posting Date";
                end else begin
                    TESTFIELD("Applies-to Doc. No.", '');
                    "To Invoice Date" := 0D;
                end;
            end;
        }
        field(46015509; "To Invoice Date"; Date)
        {
            Caption = 'To Invoice Date';
            Description = 'NAVBG11.0,001';
        }
        field(46015510; Void; Boolean)
        {
            Caption = 'Void';
            Description = 'NAVBG11.0,001';
        }
        field(46015511; "Void Date"; Date)
        {
            Caption = 'Void Date';
            Description = 'NAVBG11.0,001';
        }
        field(46015512; "VAT Subject"; Text[30])
        {
            Caption = 'VAT Subject';
            Description = 'NAVBG11.0,001';
            NotBlank = true;
        }
        field(46015513; "Sales Protocol"; Boolean)
        {
            Caption = 'Sales Protocol';
            Description = 'NAVBG11.0,001';
        }
        field(46015515; "Do not include in VAT Ledgers"; Boolean)
        {
            Caption = 'Do not include in VAT Ledgers';
            Description = 'NAVBG11.0,001';
        }
        field(46015526; "VAT Exempt Ground"; Code[10])
        {
            Caption = 'VAT Exempt Ground';
            Description = 'NAVBG11.0,001';
            TableRelation = "Ground for VAT Protocol".Code WHERE(Type = CONST("VAT Exempt"));
        }
        field(46015527; "Composed By"; Text[30])
        {
            Caption = 'Composed By';
            Description = 'NAVBG11.0,001';
        }
        field(46015535; "Transport Country/Region Code"; Code[10])
        {
            Caption = 'Transport Country/Region Code';
            Description = 'NAVBG11.0,001';
            TableRelation = "Country/Region";
        }
        field(46015540; "Appendix No."; Code[20])
        {
            Caption = 'Appendix No.';
            Description = 'NAVBG11.0,001';
        }
        field(46015542; "Excise Tax Document No."; Code[20])
        {
            Caption = 'Excise Tax Document No.';
            Description = 'NAVBG11.0,001';
        }
        field(46015544; "Excise Document Date"; Date)
        {
            Caption = 'Excise Document Date';
            Description = 'NAVBG11.0,001';
        }
        field(46015545; "Payment Obligation Type"; Code[20])
        {
            Caption = 'Payment Obligation Type';
            Description = 'NAVBG11.0,001';
            TableRelation = "Payment Obligation Type";
        }
        field(46015546; "Return Date of AAD"; Date)
        {
            Caption = 'Return Date of AAD';
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
        field(46015608; "EU 3-Party Trade"; Boolean)
        {
            Caption = 'EU 3-Party Trade';
            Description = 'NAVE111.0,001';

            trigger OnValidate();
            begin
                if not "EU 3-Party Trade" then
                    "EU 3-Party Intermediate Role" := false;
            end;
        }
        field(46015610; "VAT Date"; Date)
        {
            Caption = 'VAT Date';
            Description = 'NAVE111.0,001';

            trigger OnValidate();
            begin
                //TO DO
                /*
                GLSetup.GET;
                if not GLSetup."Use VAT Date" then
                    TESTFIELD("VAT Date", "Posting Date");
                if "VAT Date" <> xRec."VAT Date" then
                    UpdatePurchLines(FIELDCAPTION("VAT Date"), true)
                */
            end;
        }
        field(46015614; "Industry Code"; Code[20])
        {
            Caption = 'Industry Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Industry Code";
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
            TableRelation = "Import SAD Header";

            trigger OnValidate();
            begin
                //TO DO
                /*
                  if "SAD No." <> xRec."SAD No." then begin
                      if "SAD No." <> '' then begin
                          PurchSetup.GET;
                          if not PurchSetup."Allow LCY in Import SAD" then begin
                              SADHeader.GET("SAD No.");
                              SADHeader.TESTFIELD("Customs Currency Code");
                              if (SADHeader."Customs Currency Code" <> '') and (SADHeader."Customs Currency Code" <> "Currency Code") then begin
                                  "Currency Code" := SADHeader."Customs Currency Code";
                                  VALIDATE("Currency Code");
                              end;
                          end;
                          UpdatePurchLines(FIELDCAPTION("SAD No."), true);
                      end;
                  end;
                  */
            end;
        }
        field(46015626; "Customs Procedure Code"; Code[10])
        {
            Caption = 'Customs Procedure Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Custom Procedure";
        }
        field(46015630; "Posting Desc. Code"; Code[10])
        {
            Caption = 'Posting Desc. Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Posting Description" WHERE(Type = CONST("Purchase Document"));

            trigger OnValidate();
            begin
                //TO DO
                /*
                if "Posting Desc. Code" <> '' then
                    "Posting Description" := GetPostingDescription(Rec);
                */
            end;
        }
        field(46015700; "Unrealized VAT"; Boolean)
        {
            Caption = 'Unrealized VAT';
            Description = 'NAVBG11.0,001';
        }
    }


    //Unsupported feature: CodeModification on "OnInsert". Please convert manually.

    //trigger OnInsert();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    InitInsert;

    if GETFILTER("Buy-from Vendor No.") <> '' then
      if GETRANGEMIN("Buy-from Vendor No.") = GETRANGEMAX("Buy-from Vendor No.") then
        VALIDATE("Buy-from Vendor No.",GETRANGEMIN("Buy-from Vendor No."));

    if "Purchaser Code" = '' then
      SetDefaultPurchaser;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..5
    //NAVE111.0; 001; begin
    if LocalizationUsage.UseEastLocalization then
      VALIDATE("Posting Desc. Code",PurchSetup."Posting Desc. Code");
    //NAVE111.0; 001; end
    #6..8

    //NAVE111.0; 001; begin
    if LocalizationUsage.UseEastLocalization then
      VALIDATE("Posting Desc. Code");
    //NAVE111.0; 001; end
    */
    //end;

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
        VATBusPostingGroup: Record "VAT Business Posting Group";

    var
        SADHeader: Record "Import SAD Header";
        SubstVendPostingGrp: Record "Subst. Vendor Posting Group";
        Text047: Label '"Deleting this document will cause a gap in the number series for prepayment credit memos. "';
        Text46012225: Label 'You cannot change the %1 to %2 because %3 has not been filled in.';
        Text46012226: Label 'You cannot change %1 until %2 will be checked in setup.';
}

