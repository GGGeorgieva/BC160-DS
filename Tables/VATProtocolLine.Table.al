table 46015515 "VAT Protocol Line"
{
    // version NAVBG11.0

    // -----------------------------------------------------------------------------------------
    // XAPT Solutions
    // MS Dynamics NAV 2015 Localisation
    // 
    // mp  : Mile Petachki
    // version : NAVBG8.00
    // 
    // -----------------------------------------------------------------------------------------
    // No.   Sign     Date       Version        Description
    // -----------------------------------------------------------------------------------------
    // 001   mp       27.10.14   NAVBG8.00      Created table from MS Dynamics NAV 6.00
    //                           NAVBG8.00      Changed field : 3 - Type
    // ------------------------------------------------------------------------------------------
    // 
    // -----------------------------------------------------------------------------------------
    // Dynamic Solutions
    // MS Dynamics NAV 2017 Localisation
    // 
    // 
    // -----------------------------------------------------------------------------------------
    // No.   Sign     Date       Version        Description
    // -----------------------------------------------------------------------------------------
    // 001                                     List of changes :
    //                          NAVBG11.0     Added field : VAT Clause Code
    //                                        Added field : VAT Caluse Description
    // -----------------------------------------------------------------------------------------

    Caption = 'VAT Protocol Line';

    fields
    {
        field(1;"Document No.";Code[20])
        {
            Caption = 'Document No.';
        }
        field(2;"Line No.";Integer)
        {
            Caption = 'Line No.';
        }
        field(3;Type;Option)
        {
            Caption = 'Type';
            Description = 'NAVBG8.00';
            OptionCaption = ',G/L Account,Item,Resource,Fixed Asset,Charge (Item),Payment';
            OptionMembers = ,"G/L Account",Item,Resource,"Fixed Asset","Charge (Item)",Payment;

            trigger OnValidate();
            begin

                  TempVATProtocolLine := Rec;
                  INIT;
                  Type := TempVATProtocolLine.Type;
                  "System-Created Entry" := TempVATProtocolLine."System-Created Entry";
                  GetVATProtocolHeader;
                  "Document Type" := VATProtocolHeader."Document Type";
            end;
        }
        field(4;"No.";Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type=CONST("G/L Account")) "G/L Account"
                            ELSE IF (Type=CONST(Item)) Item
                            ELSE IF (Type=CONST(Resource)) Resource
                            ELSE IF (Type=CONST("Fixed Asset")) "Fixed Asset"
                            ELSE IF (Type=CONST("Charge (Item)")) "Item Charge";

            trigger OnValidate();
            begin
                TempVATProtocolLine := Rec;
                INIT;
                Type := TempVATProtocolLine.Type;
                "No." := TempVATProtocolLine."No.";
                GetVATProtocolHeader;

                if "No." = '' then
                  exit;
                Quantity := TempVATProtocolLine.Quantity;

                "System-Created Entry" := TempVATProtocolLine."System-Created Entry";

                GetVATProtocolHeader;
                "Document Type" := VATProtocolHeader."Document Type";
                "VAT Bus. Posting Group" := VATProtocolHeader."VAT Bus. Posting Group";
                "Bal. VAT Bus. Posting Group" := VATProtocolHeader."Bal. VAT Bus. Posting Group";

                case Type of
                  Type::"G/L Account":
                    begin
                      GLAcc.GET("No.");
                      Description := GLAcc.Name;
                      "VAT Prod. Posting Group" := GLAcc."VAT Prod. Posting Group";
                    end;
                  Type::Item:
                    begin
                      GetItem;
                      GetGLSetup;
                      Description := Item.Description;
                      "Description 2" := Item."Description 2";
                      "VAT Prod. Posting Group" := Item."VAT Prod. Posting Group";
                      if "Document Type" = "Document Type"::Purchase then
                        "Unit of Measure Code" := Item."Purch. Unit of Measure"
                      else
                        "Unit of Measure Code" := Item."Sales Unit of Measure";
                    end;
                  Type::Resource:
                    begin
                      if "Document Type" = "Document Type"::Purchase then
                        ERROR(Text003);
                      Res.GET("No.");
                      Description := Res.Name;
                      "Description 2" := Res."Name 2";
                      "Unit of Measure Code" := Res."Base Unit of Measure";
                      "VAT Prod. Posting Group" := Res."VAT Prod. Posting Group";
                    end;
                  Type::"Fixed Asset":
                    begin
                      FA.GET("No.");
                      GetFAPostingGroup;
                      Description := FA.Description;
                      "Description 2" := FA."Description 2";
                    end;
                  Type::"Charge (Item)":
                    begin
                      ItemCharge.GET("No.");
                      Description := ItemCharge.Description;
                      "VAT Prod. Posting Group" := ItemCharge."VAT Prod. Posting Group";
                    end;
                end;

                if (Type <> Type::"Fixed Asset") and (Type <> Type::"G/L Account") then
                  VALIDATE("VAT Prod. Posting Group");
                Quantity := xRec.Quantity;
                VALIDATE("Unit of Measure Code");

                CreateDim(
                  DimMgt.TypeToTableID3(Type),"No.");
            end;
        }
        field(5;Description;Text[50])
        {
            Caption = 'Description';
        }
        field(6;"Description 2";Text[50])
        {
            Caption = 'Description 2';
        }
        field(7;"Unit of Measure";Text[10])
        {
            Caption = 'Unit of Measure';

            trigger OnValidate();
            begin
                if Type = Type::Item then begin
                  GetItem;
                  "Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure");

                  //* PurchPriceCalcMgt.FindVATProtocolPrice(Rec,FIELDNO("Unit of Measure"));

                  GetGLSetup;
                  VALIDATE("Unit Price (LCY)",ROUND("Unit Price (LCY)" * "Qty. per Unit of Measure",GLSetup."Unit-Amount Rounding Precision"));
                end;
            end;
        }
        field(9;Quantity;Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0:5;

            trigger OnValidate();
            begin
                if (xRec.Quantity <> Quantity) then begin
                  "VAT Base Amount (LCY)" := ROUND("Unit Price (LCY)" * Quantity,Currency."Amount Rounding Precision");
                  VALIDATE("VAT %");
                end;

                if (xRec.Quantity <> Quantity) and (Quantity = 0) and
                  (("VAT Base Amount (LCY)"<>0) or ("VAT Amount (LCY)" <> 0))
                then begin
                  "VAT Base Amount (LCY)" := 0;
                  "VAT Amount (LCY)" := 0;
                end;
            end;
        }
        field(10;"Unit Price (LCY)";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price (LCY)';

            trigger OnValidate();
            begin
                TESTFIELD("No.");
                if xRec."Unit Price (LCY)" <> "Unit Price (LCY)" then begin
                  "VAT Base Amount (LCY)" := ROUND("Unit Price (LCY)" * Quantity,Currency."Amount Rounding Precision");
                  VALIDATE("VAT %");
                end;
            end;
        }
        field(11;"VAT Base Amount (LCY)";Decimal)
        {
            Caption = 'VAT Base Amount (LCY)';

            trigger OnValidate();
            begin
                "Unit Price (LCY)" := ROUND("VAT Base Amount (LCY)" / Quantity,GLSetup."Unit-Amount Rounding Precision");
                VALIDATE("VAT %");
            end;
        }
        field(12;"VAT Amount (LCY)";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'VAT Amount (LCY)';
            Editable = false;
        }
        field(15;"Document Type";Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Purchase,Sale';
            OptionMembers = Purchase,Sale;
        }
        field(30;"VAT Bus. Posting Group";Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";

            trigger OnValidate();
            begin
                VALIDATE("VAT Prod. Posting Group");
            end;
        }
        field(31;"VAT Prod. Posting Group";Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";

            trigger OnValidate();
            begin

                VATPostingSetup.GET("VAT Bus. Posting Group","VAT Prod. Posting Group");
                VATPostingSetup.TESTFIELD("VAT Calculation Type",VATPostingSetup."VAT Calculation Type"::"Full VAT");

                case "Document Type" of
                  "Document Type"::Purchase:
                    begin
                      VATPostingSetup.TESTFIELD("Reverse Chrg. VAT Acc.");
                      VATPostingSetup.TESTFIELD("Purchase VAT Account");
                      "Sales VAT Account" := VATPostingSetup."Reverse Chrg. VAT Acc.";
                      "Purch. VAT Account" := VATPostingSetup."Purchase VAT Account";
                    end;
                  "Document Type"::Sale:
                    begin
                      VATPostingSetup.TESTFIELD("Sales VAT Account");
                      VATPostingSetup.TESTFIELD("Corr. Sales VAT Account");
                      "Sales VAT Account" := VATPostingSetup."Sales VAT Account";
                      "Purch. VAT Account" := VATPostingSetup."Corr. Sales VAT Account";
                    end;
                end;

                "VAT Calculation Type" := VATPostingSetup."VAT Calculation Type";
                "VAT Identifier" := VATPostingSetup."VAT Identifier";
                VALIDATE("VAT %",VATPostingSetup."VAT %");

                // NAVBG11.0.001 begin
                "VAT Clause Code" := VATPostingSetup."VAT Clause Code";
                VATClause.GET("VAT Clause Code");
                "VAT Caluse Description" := VATClause.Description;
                // NAVBG11.0.001 end
            end;
        }
        field(32;"VAT %";Decimal)
        {
            Caption = 'VAT %';
            DecimalPlaces = 0:5;
            Editable = false;

            trigger OnValidate();
            begin
                "VAT Amount (LCY)" := ROUND("VAT Base Amount (LCY)" * "VAT %" / 100 ,Currency."Amount Rounding Precision");
            end;
        }
        field(35;"Sales VAT Account";Code[20])
        {
            Caption = 'Sales VAT Account';
            TableRelation = "G/L Account";

            trigger OnValidate();
            begin
                GLAcc.GET("Sales VAT Account");
                CheckGLAcc;
            end;
        }
        field(36;"Purch. VAT Account";Code[20])
        {
            Caption = 'Purch. VAT Account';
            TableRelation = "G/L Account";

            trigger OnValidate();
            begin
                GLAcc.GET("Purch. VAT Account");
                CheckGLAcc;
            end;
        }
        field(40;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(1));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
            end;
        }
        field(41;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(2));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
            end;
        }
        field(52;"Work Type Code";Code[10])
        {
            Caption = 'Work Type Code';
            TableRelation = "Work Type";

            trigger OnValidate();
            var
                WorkType : Record "Work Type";
            begin
                if Type = Type::Resource then begin
                  if WorkType.GET("Work Type Code") then
                    VALIDATE("Unit of Measure Code",WorkType."Unit of Measure Code");
                  FindResUnitCost;
                end;
            end;
        }
        field(61;"Bal. VAT Bus. Posting Group";Code[10])
        {
            Caption = 'Bal. VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(77;"VAT Calculation Type";Option)
        {
            Caption = 'VAT Calculation Type';
            Editable = false;
            OptionCaption = 'Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax';
            OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        }
        field(102;Compressed;Boolean)
        {
            Caption = 'Compressed';

            trigger OnValidate();
            begin
                if Compressed then begin
                  Description := STRSUBSTNO(Text004,"VAT Bus. Posting Group","VAT Prod. Posting Group");
                  "Description 2" := '';
                  "Qty. per Unit of Measure" := 1;
                  Quantity := 1;
                end;
            end;
        }
        field(103;"System-Created Entry";Boolean)
        {
            Caption = 'System-Created Entry';
        }
        field(106;"VAT Identifier";Code[10])
        {
            Caption = 'VAT Identifier';
            Editable = false;
        }
        field(480;"Dimension Set ID";Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup();
            begin
                ShowDimensions;
            end;
        }
        field(5404;"Qty. per Unit of Measure";Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0:5;
            Editable = false;
            InitValue = 1;
        }
        field(5407;"Unit of Measure Code";Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE ("Item No."=FIELD("No."))
                            ELSE IF (Type=CONST(Resource)) "Resource Unit of Measure".Code WHERE ("Resource No."=FIELD("No."))
                            ELSE "Unit of Measure";

            trigger OnValidate();
            var
                UnitOfMeasureTranslation : Record "Unit of Measure Translation";
                ResUnitofMeasure : Record "Resource Unit of Measure";
            begin
                if "Unit of Measure Code" = '' then
                  "Unit of Measure" := ''
                else begin
                  if not UnitOfMeasure.GET("Unit of Measure Code") then
                    UnitOfMeasure.INIT;
                  "Unit of Measure" := UnitOfMeasure.Description;
                  if VATProtocolHeader."Language Code" <> '' then begin
                    UnitOfMeasureTranslation.SETRANGE(Code,"Unit of Measure Code");
                    UnitOfMeasureTranslation.SETRANGE("Language Code",VATProtocolHeader."Language Code");
                    if UnitOfMeasureTranslation.FIND('-') then
                      "Unit of Measure" := UnitOfMeasureTranslation.Description;
                  end;
                end;
                case Type of
                  Type::Item:
                    begin
                      TESTFIELD("No.");
                      GetItem;
                      "Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code");
                    end;
                  Type::Resource:
                    begin
                      if "Unit of Measure Code" = '' then begin
                        GetResource;
                        "Unit of Measure Code" := Resource."Base Unit of Measure";
                      end;
                      ResUnitofMeasure.GET("No.","Unit of Measure Code");
                      "Qty. per Unit of Measure" := ResUnitofMeasure."Qty. per Unit of Measure";
                    end;
                  Type::"G/L Account",Type::"Fixed Asset",Type::"Charge (Item)":
                       "Qty. per Unit of Measure" := 1;
                end;
                VALIDATE(Quantity);
            end;
        }
        field(5602;"Depreciation Book Code";Code[10])
        {
            Caption = 'Depreciation Book Code';
            TableRelation = "Depreciation Book";

            trigger OnValidate();
            begin
                GetFAPostingGroup;
            end;
        }
        field(5603;"VAT Clause Code";Code[10])
        {
            Caption = 'VAT Clause Code';
            Description = 'NAVBG11.0.001';
            TableRelation = "VAT Clause";
        }
        field(5604;"VAT Caluse Description";Text[250])
        {
            Caption = 'VAT Caluse Description';
            Description = 'NAVBG11.0.001';
            TableRelation = "VAT Clause";
        }
    }

    keys
    {
        key(Key1;"Document No.","Line No.")
        {
            SumIndexFields = "VAT Base Amount (LCY)";
        }
        key(Key2;"VAT Prod. Posting Group")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnModify();
    begin
        "System-Created Entry" := false;
    end;

    var
        TempVATProtocolLine : Record "VAT Protocol Line";
        VATProtocolHeader : Record "VAT Protocol Header";
        GLSetup : Record "General Ledger Setup";
        Vendor : Record Vendor;
        GLAcc : Record "G/L Account";
        Item : Record Item;
        Currency : Record Currency;
        CurrExchRate : Record "Currency Exchange Rate";
        VATPostingSetup : Record "VAT Posting Setup";
        StdTxt : Record "Standard Text";
        FA : Record "Fixed Asset";
        UnitOfMeasure : Record "Unit of Measure";
        ItemCharge : Record "Item Charge";
        SKU : Record "Stockkeeping Unit";
        DocDim : Record "Dimension Set Entry";
        PurchInvHeader : Record "Purch. Inv. Header";
        PurchInvLine : Record "Purch. Inv. Line";
        PurchCrMemoHeader : Record "Purch. Cr. Memo Hdr.";
        PurchCrMemoLine : Record "Purch. Cr. Memo Line";
        UOMMgt : Codeunit "Unit of Measure Management";
        PurchPriceCalcMgt : Codeunit "Purch. Price Calc. Mgt.";
        DimMgt : Codeunit DimensionManagement;
        GLSetupRead : Boolean;
        Text001 : Label 'You have to define Full VAT for internal invoice VAT setup %1 %2';
        Text002 : Label 'cannot be specified without %1';
        Text003 : Label 'You cannot purchase resources.';
        Resource : Record Resource;
        Text004 : Label 'Compressed line. VAT Groups: %1 %2';
        Res : Record Resource;
        VATClause : Record "VAT Clause";

    procedure GetVATProtocolHeader();
    begin
        TESTFIELD("Document No.");
        if "Document No." <> VATProtocolHeader."No." then
          VATProtocolHeader.GET("Document No.");
    end;

    local procedure GetItem();
    begin
        TESTFIELD("No.");
        if Item."No." <> "No." then
          Item.GET("No.");
    end;

    local procedure GetGLSetup();
    begin
        if not GLSetupRead then
          GLSetup.GET;
        GLSetupRead := true;
    end;

    local procedure CheckGLAcc();
    begin
        GLAcc.CheckGLAcc;
        GLAcc.TESTFIELD("Direct Posting",true);
    end;

    procedure CalcVATAmountLines(var VATProtocolHeader : Record "VAT Protocol Header";var VATAmountLine : Record "VAT Amount Line");
    begin
        VATAmountLine.DELETEALL;
        SETRANGE("Document No.",VATProtocolHeader."No.");
        if FIND('-') then
          repeat
            VATAmountLine.INIT;
            VATAmountLine."VAT Identifier" := "VAT Identifier";
            VATAmountLine."VAT Calculation Type" := "VAT Calculation Type";
            VATAmountLine."VAT %" := "VAT %";
            VATAmountLine."VAT Base" := "VAT Base Amount (LCY)";
            VATAmountLine."VAT Amount" := "VAT Amount (LCY)";
            VATAmountLine."Amount Including VAT" := "VAT Base Amount (LCY)" + "VAT Amount (LCY)";
            VATAmountLine."Line Amount" := "VAT Base Amount (LCY)";
            VATAmountLine.InsertLine;
          until NEXT = 0;
    end;

    procedure ShowDimensions();
    var
        DocDim : Record "Dimension Set Entry";
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2 %3',"Document Type","Document No.","Line No."));
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    end;

    procedure CreateDim(Type1 : Integer;No1 : Code[20]);
    var
        SourceCodeSetup : Record "Source Code Setup";
        TableID : array [10] of Integer;
        No : array [10] of Code[20];
        TableNo : Integer;
    begin
        SourceCodeSetup.GET;
        TableID[1] := Type1;
        No[1] := No1;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        "Dimension Set ID" :=
          DimMgt.GetDefaultDimID(
            TableID,No,SourceCodeSetup.Sales,
            "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",
            "Dimension Set ID",DATABASE::Customer);
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    end;

    procedure ValidateShortcutDimCode(FieldNumber : Integer;var ShortcutDimCode : Code[20]);
    begin

          DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
    end;

    procedure LookupShortcutDimCode(FieldNumber : Integer;var ShortcutDimCode : Code[20]);
    begin

          DimMgt.LookupDimValueCode(FieldNumber,ShortcutDimCode);
          ValidateShortcutDimCode(FieldNumber,ShortcutDimCode);
    end;

    procedure ShowShortcutDimCode(var ShortcutDimCode : array [8] of Code[20]);
    begin

          DimMgt.GetShortcutDimensions("Dimension Set ID",ShortcutDimCode);
    end;

    procedure GetResource();
    begin
        TESTFIELD("No.");
        if "No." <> Resource."No." then
          Resource.GET("No.");
    end;

    local procedure FindResUnitCost();
    var
        ResCost : Record "Resource Cost";
        ResFindUnitCost : Codeunit "Resource-Find Cost";
    begin
        ResCost.INIT;
        ResCost.Code := "No.";
        ResCost."Work Type Code" := "Work Type Code";
        ResFindUnitCost.RUN(ResCost);
        VALIDATE("Unit Price (LCY)",ResCost."Unit Cost" * "Qty. per Unit of Measure");
    end;

    local procedure GetFAPostingGroup();
    var
        LocalGLAcc : Record "G/L Account";
        FAPostingGr : Record "FA Posting Group";
        FADeprBook : Record "FA Depreciation Book";
        FASetup : Record "FA Setup";
    begin
        if (Type <> Type::"Fixed Asset") or ("No." = '') then
          exit;
        if "Depreciation Book Code" = '' then begin
          FASetup.GET;
          "Depreciation Book Code" := FASetup."Default Depr. Book";
          if not FADeprBook.GET("No.","Depreciation Book Code") then
            "Depreciation Book Code" := '';
          if "Depreciation Book Code" = '' then
            exit;
        end;
        FADeprBook.GET("No.","Depreciation Book Code");
        FADeprBook.TESTFIELD("FA Posting Group");
        FAPostingGr.GET(FADeprBook."FA Posting Group");
        FAPostingGr.TESTFIELD("Acquisition Cost Account");
        LocalGLAcc.GET(FAPostingGr."Acquisition Cost Account");
        LocalGLAcc.CheckGLAcc;
        LocalGLAcc.TESTFIELD("Gen. Prod. Posting Group");
        VALIDATE("VAT Prod. Posting Group",LocalGLAcc."VAT Prod. Posting Group");
    end;
}

