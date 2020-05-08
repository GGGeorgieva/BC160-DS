table 46015514 "VAT Protocol Header"
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
    //                           NAVBG8.00      Added new field : 46015700 - "Protocol Type"
    //                           NAVBG8.00      Added new field : 46015701 - "Apply-to Payment Entry"
    //                           NAVBG8.00      Added new field : 46015702 - "Date of Chargeable Tax"
    //                           NAVBG8.00      Changded function : InitRecord()
    //                           NAVBG8.00      Changded function : GetNoSeriesCode()
    //                           NAVBG8.00      Added new field : 46015703 - Protocol Subtype
    //                           NAVBG8.00      Added new field : 46015704 - Date of Tax Credit
    //                           NAVBG8.00      Create new function : ApplyToPaymentEntryValidate()
    //                           NAVBG8.00      Create new function : ApplyToPaymentEntryLookup()
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
    //                           NAVBG11.0      Added new field : 46015705 - Payment No.
    //                           NAVBG11.0      Added new field : 46015706 - Payment Date
    //                           NAVBG11.0      Added new field : 46015707 - Payment Due
    //                           NAVBG11.0      Added new field : 46015708 - Payment Amount
    //                           NAVBG11.0      Added new field : 46015709 - VAT Base
    //                           NAVBG11.0      Added new field : 46015710 - VAT %
    //                           NAVBG11.0      Added new field : 46015711 - VAT Amount Due
    // ------------------------------------------------------------------------------------------

    Caption = 'VAT Protocol Header';
    DataCaptionFields = "No.";

    fields
    {
        field(1;"No.";Code[20])
        {
            Caption = 'No.';

            trigger OnValidate();
            begin
                if "No." <> xRec."No." then begin
                  GLSetup.GET;
                  NoSeriesMgt.TestManual(GetNoSeriesCode);
                  "No. Series" := '';
                end;
            end;
        }
        field(2;"Document Type";Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Purchase,Sale';
            OptionMembers = Purchase,Sale;
        }
        field(3;"CV No.";Code[20])
        {
            Caption = 'CV No.';
            TableRelation = IF ("Document Type"=CONST(Purchase)) Vendor
                            ELSE IF ("Document Type"=CONST(Sale)) Customer;

            trigger OnValidate();
            begin
                case "Document Type" of
                  "Document Type"::Purchase:
                    begin
                      if LineExist then begin
                        if CONFIRM(STRSUBSTNO(Text002,"No.")) then begin
                          GetVend("CV No.");
                          VATProtocolLine.DELETEALL(true);
                        end else
                          "CV No." := xRec."CV No.";
                      end else
                        GetVend("CV No.");

                      CreateDim(DATABASE::Vendor,"CV No.");
                    end;
                  "Document Type"::Sale:
                    begin
                      if LineExist then begin
                        if CONFIRM(STRSUBSTNO(Text002,"No.")) then begin
                          GetCust("CV No.");
                          VATProtocolLine.DELETEALL(true);
                        end else
                          "CV No." := xRec."CV No.";
                      end else
                        GetCust("CV No.");

                      CreateDim(DATABASE::Customer,"CV No.");
                    end;
                end;
            end;
        }
        field(4;Address;Text[50])
        {
            Caption = 'Address';
        }
        field(5;"Address 2";Text[50])
        {
            Caption = 'Address 2';
        }
        field(6;City;Text[50])
        {
            Caption = 'City';
        }
        field(7;"Phone No.";Text[20])
        {
            Caption = 'Phone No.';
        }
        field(8;"Post Code";Code[20])
        {
            Caption = 'Post Code';
            TableRelation = "Post Code";
        }
        field(9;"Country/Region Code";Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region" WHERE ("EU Country/Region Code"=FILTER(<>''));
        }
        field(10;"Fax No.";Text[20])
        {
            Caption = 'Fax No.';
        }
        field(12;Name;Text[50])
        {
            Caption = 'Name';
        }
        field(13;"Name 2";Text[50])
        {
            Caption = 'Name 2';
        }
        field(19;"VAT Registration No.";Text[20])
        {
            Caption = 'VAT Registration No.';
        }
        field(20;"Registration No.";Text[20])
        {
            Caption = 'Registration No.';
        }
        field(21;"Identification No.";Text[13])
        {
            Caption = 'Identification No.';
        }
        field(22;"Posting Description";Text[50])
        {
            Caption = 'Posting Description';
        }
        field(28;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(1));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
                MODIFY;
            end;
        }
        field(29;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(2));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
                MODIFY;
            end;
        }
        field(30;"Composed By";Text[30])
        {
            Caption = 'Composed By';
        }
        field(39;Amount;Decimal)
        {
            CalcFormula = Sum("VAT Protocol Line"."VAT Base Amount (LCY)" WHERE ("Document No."=FIELD("No.")));
            Caption = 'Amount';
            FieldClass = FlowField;
        }
        field(40;"Document Date";Date)
        {
            Caption = 'Document Date';

            trigger OnValidate();
            begin
                if "VAT Date" = 0D then
                  VALIDATE("VAT Date","Document Date");
            end;
        }
        field(41;"Posting Date";Date)
        {
            Caption = 'Posting Date';
        }
        field(42;"VAT Date";Date)
        {
            Caption = 'VAT Date';
        }
        field(45;"Language Code";Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
        }
        field(47;"No. Printed";Integer)
        {
            Caption = 'No. Printed';
            Editable = false;
        }
        field(50;"No. Series";Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(51;"Posting No. Series";Code[10])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";

            trigger OnValidate();
            begin
                if "Posting No. Series" <> '' then begin
                  GLSetup.GET;
                  TestNoSeries;
                  NoSeriesMgt.TestSeries(GetPostingNoSeriesCode,"Posting No. Series");
                end;
                TESTFIELD("Posting No.",'');
            end;
        }
        field(52;"Posting No.";Code[20])
        {
            Caption = 'Posting No.';
        }
        field(60;"VAT Bus. Posting Group";Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";

            trigger OnValidate();
            begin
                if LineExist then
                  VATProtocolLine.MODIFYALL("VAT Bus. Posting Group","VAT Bus. Posting Group");
            end;
        }
        field(61;"Bal. VAT Bus. Posting Group";Code[10])
        {
            Caption = 'Bal. VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";

            trigger OnValidate();
            begin
                if LineExist then
                  VATProtocolLine.MODIFYALL("Bal. VAT Bus. Posting Group","Bal. VAT Bus. Posting Group");
            end;
        }
        field(65;"Last Posting No.";Code[20])
        {
            Caption = 'Last Posting No.';
            Editable = false;
            TableRelation = "Posted VAT Protocol Header";
        }
        field(75;"EU 3-Party Trade";Boolean)
        {
            Caption = 'EU 3-Party Trade';
        }
        field(82;"Ground For Issue";Code[10])
        {
            Caption = 'Ground For Issue';
            TableRelation = "Ground for VAT Protocol".Code WHERE (Type=CONST(Issue));
        }
        field(83;"Ground For VAT Exempt";Code[10])
        {
            Caption = 'Ground For VAT Exempt';
            TableRelation = "Ground for VAT Protocol".Code WHERE (Type=CONST("VAT Exempt"));
        }
        field(85;"Corr. VAT Protocol No.";Code[20])
        {
            Caption = 'Corr. VAT Protocol No.';
            TableRelation = "Posted VAT Protocol Header"."No." WHERE ("Document Type"=FIELD("Document Type"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup();
            var
                PostedVATProtocolHeader : Record "Posted VAT Protocol Header";
            begin

                case "Document Type" of
                  "Document Type"::Sale:
                    if PAGE.RUNMODAL(46015540, PostedVATProtocolHeader) = ACTION::LookupOK then
                      "Corr. VAT Protocol No." := PostedVATProtocolHeader."No.";
                  "Document Type"::Purchase:
                    if PAGE.RUNMODAL(46015530, PostedVATProtocolHeader) = ACTION::LookupOK then
                      "Corr. VAT Protocol No." := PostedVATProtocolHeader."No.";
                end;
            end;

            trigger OnValidate();
            var
                PostedVATProtocolHeader : Record "Posted VAT Protocol Header";
                MakeVATProtocol : Codeunit "Make VAT Protocol";
            begin

                if "Corr. VAT Protocol No." = '' then
                  "Posting No." := '';

                if PostedVATProtocolHeader.GET("Corr. VAT Protocol No.") then begin
                  TESTFIELD("Document Type",PostedVATProtocolHeader."Document Type");
                  MODIFY;
                  MakeVATProtocol.VATProtocol(PostedVATProtocolHeader,Rec,false,true);
                end;
            end;
        }
        field(98;Correction;Boolean)
        {
            Caption = 'Correction';
        }
        field(100;"Original Doc. Type";Option)
        {
            Caption = 'Original Doc. Type';
            OptionCaption = '" ,Invoice,Credit Memo"';
            OptionMembers = " ",Invoice,"Credit Memo";
        }
        field(101;"Original Doc. No.";Code[20])
        {
            Caption = 'Original Doc. No.';
            TableRelation = IF ("Document Type"=CONST(Purchase),
                                "Original Doc. Type"=CONST(Invoice)) "Purch. Inv. Header"."No."
                                ELSE IF ("Document Type"=CONST(Purchase),
                                         "Original Doc. Type"=CONST("Credit Memo")) "Purch. Cr. Memo Hdr."."No."
                                         ELSE IF ("Document Type"=CONST(Sale),
                                                  "Original Doc. Type"=CONST(Invoice)) "Sales Invoice Header"."No."
                                                  ELSE IF ("Document Type"=CONST(Sale),
                                                           "Original Doc. Type"=CONST("Credit Memo")) "Sales Cr.Memo Header"."No.";
            ValidateTableRelation = false;
        }
        field(480;"Dimension Set ID";Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup();
            begin
                ShowDocDim;
            end;
        }
        field(481;"New Dimension Set ID";Integer)
        {
            Caption = 'New Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup();
            begin
                ShowDocDim;
            end;
        }
        field(46015700;"Protocol Type";Option)
        {
            Caption = 'Protocol Type';
            Description = 'NAVBG8.00';
            Editable = false;
            OptionCaption = '" ,Protocol,Unrealized VAT"';
            OptionMembers = " ",Protocol,"Unrealized VAT";
        }
        field(46015701;"Apply-to Payment Entry";Integer)
        {
            BlankZero = true;
            Caption = 'Apply-to Payment Entry';
            Description = 'NAVBG8.00';
        }
        field(46015702;"Date of Chargeable Tax";Date)
        {
            Caption = 'Date on which tax is chargeable';
            Description = 'NAVBG8.00';
        }
        field(46015703;"Protocol Subtype";Code[20])
        {
            Caption = 'Protocol Subtype';
            Description = 'NAVBG8.00';
            TableRelation = "Document Type".Code;
        }
        field(46015704;"Date of Tax Credit";Date)
        {
            Caption = 'Date of entitlement to tax credit';
            Description = 'NAVBG8.00';
        }
        field(46015705;"Payment No.";Code[20])
        {
            Caption = 'Payment No.';
            Description = 'NAVBG8.00';
        }
        field(46015706;"Payment Date";Date)
        {
            Caption = 'Payment Date';
            Description = 'NAVBG8.00';
        }
        field(46015707;"Payment Due";Decimal)
        {
            Caption = 'Payment Due';
            Description = 'NAVBG8.00';
        }
        field(46015708;"Payment Amount";Decimal)
        {
            Caption = 'Payment Amount';
            Description = 'NAVBG8.00';
        }
        field(46015709;"VAT Base";Decimal)
        {
            Caption = 'VAT Base';
            Description = 'NAVBG8.00';
        }
        field(46015710;"VAT %";Decimal)
        {
            Caption = 'VAT %';
            Description = 'NAVBG8.00';
        }
        field(46015711;"VAT Amount Due";Decimal)
        {
            Caption = 'VAT Amount Due';
            Description = 'NAVBG8.00';
        }
        field(46015712;"VAT Subject";Text[30])
        {
            Caption = 'VAT Subject';
            Description = 'NAVBG8.00';
        }
    }

    keys
    {
        key(Key1;"No.")
        {
        }
        key(Key2;"Original Doc. Type","Original Doc. No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin

        if LineExist then
          VATProtocolLine.DELETEALL(true);
    end;

    trigger OnInsert();
    begin
        GLSetup.GET;

        if "No." = '' then begin
          TestNoSeries;
          NoSeriesMgt.InitSeries(GetNoSeriesCode,xRec."No. Series","Posting Date","No.","No. Series");
        end;

        InitRecord;
    end;

    trigger OnRename();
    begin
        ERROR(Text003,TABLECAPTION);
    end;

    var
        GLSetup : Record "General Ledger Setup";
        CompanyInfo : Record "Company Information";
        Vendor : Record Vendor;
        PostCode : Record "Post Code";
        VATProtocolLine : Record "VAT Protocol Line";
        NoSeriesMgt : Codeunit NoSeriesManagement;
        Text001 : Label 'Do you want to change %1 in VAT Protocol lines?';
        Text002 : Label 'There are lines for document %1. Do you want to delete VAT Protocol lines?';
        DimMgt : Codeunit DimensionManagement;
        DocDim : Record "Dimension Set Entry";
        Text003 : Label 'You cannot rename a %1.';
        Customer : Record Customer;
        SaleSetup : Record "Sales & Receivables Setup";
        PurchaseSetup : Record "Purchases & Payables Setup";
        CustLedgerEntry : Record "Cust. Ledger Entry";
        VendLedgerEntry : Record "Vendor Ledger Entry";
        Text50001 : Label 'Protocol,Protocol for unrealized VAT';
        Text50002 : Label 'Choose protocol type ...';
        Text50003 : Label '<>''''';
        Text50004 : Label '%1|%2';

    procedure InitRecord();
    var
        PurchSetup : Record "Purchases & Payables Setup";
        SalesSetup : Record "Sales & Receivables Setup";
    begin
        if ("No. Series" <> '') and
          (GLSetup."VAT Protocol Nos." = GLSetup."Posted VAT Protocol Nos.")
        then
          "Posting No. Series" := "No. Series"
        else
          NoSeriesMgt.SetDefaultSeries("Posting No. Series",GLSetup."Posted VAT Protocol Nos.");


        //NAVBG8.00; 001; begin
        if "Protocol Type" = "Protocol Type"::"Unrealized VAT" then begin
          case "Document Type" of
            "Document Type"::Purchase : begin
              if not PurchSetup.GET then
                PurchSetup.INIT;
              PurchSetup.TESTFIELD( "Posted Unreal. VAT Prot. Nos." );
              NoSeriesMgt.SetDefaultSeries("Posting No. Series", PurchSetup."Posted Unreal. VAT Prot. Nos." );
            end;
            "Document Type"::Sale : begin
              if not SalesSetup.GET then
                SalesSetup.INIT;
              SalesSetup.TESTFIELD( "Posted Unreal. VAT Prot. Nos." );
              NoSeriesMgt.SetDefaultSeries("Posting No. Series", SalesSetup."Posted Unreal. VAT Prot. Nos." );
            end;
          end;
        end;
        //NAVBG8.00; 001; end


        if "Posting Date" = 0D then
          "Posting Date" := WORKDATE;
        if "Document Date" = 0D then
          VALIDATE("Document Date",WORKDATE);

        case "Document Type" of
          "Document Type"::Purchase:
            begin


              //NAVBG8.00; 001; single
              if "Protocol Type" in [ "Protocol Type"::" ", "Protocol Type"::Protocol ] then begin

              PurchSetup.GET;
              PurchSetup.TESTFIELD("EU VAT Bus. Posting Group");
              "VAT Bus. Posting Group" := PurchSetup."EU VAT Bus. Posting Group";
              SalesSetup.GET;
              SalesSetup.TESTFIELD("EU VAT Bus. Posting Group");
              "Bal. VAT Bus. Posting Group" := SalesSetup."EU VAT Bus. Posting Group";


              //NAVBG8.00; 001;begin
              end;

              if "Protocol Type" = "Protocol Type"::"Unrealized VAT" then begin
                PurchSetup.TESTFIELD( "Protokol VAT Bus. Post. Group" );
                "VAT Bus. Posting Group" := PurchSetup."Protokol VAT Bus. Post. Group";
                if "Document Type" = "Document Type"::Purchase then
                  "Bal. VAT Bus. Posting Group" := PurchSetup."Protokol VAT Bus. Post. Group";
              end;
              //NAVBG8.00; 001; end

            end;
          "Document Type"::Sale:
            begin


              //NAVBG8.00; 001; begin
              SalesSetup.GET;
              if "Protocol Type" in [ "Protocol Type"::" ", "Protocol Type"::Protocol ] then begin
              //NAVBG8.00; 001; end

              SalesSetup.GET;
              SalesSetup.TESTFIELD("EU VAT Bus. Posting Group");
              "VAT Bus. Posting Group" := SalesSetup."EU VAT Bus. Posting Group";


              //NAVBG8.00; 001; begin
              end;

              if "Protocol Type" = "Protocol Type"::"Unrealized VAT" then begin
                SalesSetup.TESTFIELD( "Protokol VAT Bus. Post. Group" );
                "VAT Bus. Posting Group" := SalesSetup."Protokol VAT Bus. Post. Group";
              end;
              //NAVBG8.00; 001; end

            end;
        end;

        //NAVBG8.00; 001; begin
        if "Protocol Type" = "Protocol Type"::"Unrealized VAT" then begin
          if not GLSetup.GET then
            GLSetup.INIT;
          GLSetup.TESTFIELD( "Unreal. VAT Prot. Code" );
          "Protocol Subtype" := GLSetup."Unreal. VAT Prot. Code";
        end;
        //NAVBG8.00; 001; end
    end;

    procedure AssistEdit(OldInvoiceHeader : Record "VAT Protocol Header") : Boolean;
    begin
        GLSetup.GET;
        TestNoSeries;
        if NoSeriesMgt.SelectSeries(GetNoSeriesCode,OldInvoiceHeader."No. Series","No. Series") then begin
          GLSetup.GET;
          TestNoSeries;
          NoSeriesMgt.SetSeries("No.");
          exit(true);
        end;
    end;

    local procedure TestNoSeries() : Boolean;
    begin
        GLSetup.TESTFIELD("VAT Protocol Nos.");
        GLSetup.TESTFIELD("Posted VAT Protocol Nos.");
    end;

    local procedure GetNoSeriesCode() : Code[10];
    begin

        //NAVBG8.00; 001; begin
        if "Protocol Type" = "Protocol Type"::" " then
          "Protocol Type" := STRMENU( Text50001, 1, Text50002 );

        case "Protocol Type" of
          "Protocol Type"::"Unrealized VAT" : begin
            if not SaleSetup.GET then
              SaleSetup.INIT;
            if not PurchaseSetup.GET then
              PurchaseSetup.INIT;
            case "Document Type" of
              "Document Type"::Sale : begin
                SaleSetup.TESTFIELD( "Unreal. VAT Prot. Nos." );
                exit( SaleSetup."Unreal. VAT Prot. Nos." );
              end;
              "Document Type"::Purchase : begin
                PurchaseSetup.TESTFIELD( "Unreal. VAT Prot. Nos." );
                exit( PurchaseSetup."Unreal. VAT Prot. Nos." );
              end;
            end;
          end;
        end;
        //NAVBG8.00; 001; end

        exit(GLSetup."VAT Protocol Nos.");
    end;

    local procedure GetPostingNoSeriesCode() : Code[10];
    begin
        exit(GLSetup."Posted VAT Protocol Nos.");
    end;

    local procedure GetVend(VendNo : Code[20]);
    begin
        if "CV No." <> Vendor."No." then
          Vendor.GET("CV No.");

        Name := Vendor.Name;
        "Name 2" := Vendor."Name 2";
        Address := Vendor.Address;
        "Address 2" := Vendor."Address 2";
        City := Vendor.City;
        "Post Code" := Vendor."Post Code";
        "Phone No." := Vendor."Phone No.";
        "Fax No." := Vendor."Fax No.";
        "VAT Registration No." := Vendor."VAT Registration No.";
        "Identification No." := Vendor."Identification No.";
        "Country/Region Code" := Vendor."Country/Region Code";
    end;

    local procedure GetCust(VendNo : Code[20]);
    begin
        if "CV No." <> Customer."No." then
          Customer.GET("CV No.");

        Name := Customer.Name;
        "Name 2" := Customer."Name 2";
        Address := Customer.Address;
        "Address 2" := Customer."Address 2";
        City := Customer.City;
        "Post Code" := Customer."Post Code";
        "Phone No." := Customer."Phone No.";
        "Fax No." := Customer."Fax No.";
        "VAT Registration No." := Customer."VAT Registration No.";
        "Identification No." := Customer."Identification No.";
        "Country/Region Code" := Customer."Country/Region Code";
    end;

    procedure LineExist() : Boolean;
    begin
        VATProtocolLine.RESET;
        VATProtocolLine.SETRANGE("Document No.","No.");
        exit(VATProtocolLine.FIND('-'));
    end;

    procedure CreateDim(Type1 : Integer;No1 : Code[20]);
    var
        SourceCodeSetup : Record "Source Code Setup";
        TableID : array [10] of Integer;
        No : array [10] of Code[20];
    begin
        TableID[1] := Type1;
        No[1] := No1;

        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        "Dimension Set ID" :=
          DimMgt.GetDefaultDimID(
            TableID,No,SourceCodeSetup."VAT Protocol",
            "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",0,0);
    end;

    procedure ValidateShortcutDimCode(FieldNumber : Integer;var ShortcutDimCode : Code[20]);
    var
        OldDimSetID : Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
        if "No." <> '' then
          MODIFY;

        if OldDimSetID <> "Dimension Set ID" then begin
          MODIFY;
        end;
    end;

    procedure ShowDocDim();
    var
        DocDim : Record "Dimension Set Entry";
        OldDimSetID : Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet2(
            "Dimension Set ID",STRSUBSTNO('%1 %2',"Document Type","No."),
            "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
        if OldDimSetID <> "Dimension Set ID" then begin
          MODIFY;
        end;
    end;

    procedure ApplyToPaymentEntryValidate();
    var
        VATProtokolLines : Record "VAT Protocol Line";
        LastLine : Integer;
        SalesInvoiceLine : Record "Sales Invoice Line";
        SalesCrMemoLine : Record "Sales Cr.Memo Line";
        PurchInvoiceLine : Record "Purch. Inv. Line";
        PurchCrMemoLine : Record "Purch. Cr. Memo Line";
        PayedBaseAmount : Decimal;
        TempSalesLine : Record "Sales Line" temporary;
    begin

          //NAVBG8.00; 001; entire function
          if not GLSetup.GET then
            GLSetup.INIT;
          GLSetup.TESTFIELD( "Inv. Rounding Precision (LCY)" );

          VATProtokolLines.RESET;
          VATProtokolLines.SETRANGE( "Document No.", "No." );
          VATProtokolLines.SETRANGE( Type, VATProtokolLines.Type::Payment );
          VATProtokolLines.DELETEALL;

          if "Apply-to Payment Entry" = 0 then exit;

          TESTFIELD( "Protocol Type", "Protocol Type"::"Unrealized VAT" );
          TESTFIELD( "CV No." );
          TESTFIELD( "Original Doc. No." );

          // Get last line no
          VATProtokolLines.RESET;
          VATProtokolLines.SETRANGE( "Document No.", "No." );
          if VATProtokolLines.FINDLAST then
            LastLine := VATProtokolLines."Line No.";
          LastLine += 10000;

          VATProtokolLines.RESET;
          VATProtokolLines.INIT;
          VATProtokolLines."Document No." := "No.";
          VATProtokolLines."Line No." := LastLine;
          VATProtokolLines."Document Type" := "Document Type";
          VATProtokolLines.Type := VATProtokolLines.Type::Payment;
          VATProtokolLines."No." := FORMAT( "Apply-to Payment Entry" );
          VATProtokolLines."Qty. per Unit of Measure" := 1;
          VATProtokolLines.Quantity := 1;

          case "Document Type" of
            "Document Type"::Purchase : begin
              VendLedgerEntry.RESET;
              VendLedgerEntry.GET( "Apply-to Payment Entry" ); // !important to be without IF .. THEN
              VendLedgerEntry.TESTFIELD( "Vendor No.", "CV No." );
              "Date of Tax Credit" := VendLedgerEntry."Document Date";
              "Posting Date" := VendLedgerEntry."Document Date";
              "Document Date" := VendLedgerEntry."Document Date";
              "VAT Date" := VendLedgerEntry."Document Date";

              VATProtokolLines.Description := VendLedgerEntry.Description;
              VendLedgerEntry.CALCFIELDS( Amount );
              VATProtokolLines."Unit Price (LCY)" := ABS( VendLedgerEntry.Amount );

              case "Original Doc. Type" of
                "Original Doc. Type"::Invoice : begin
                  PurchInvoiceLine.RESET;
                  PurchInvoiceLine.SETRANGE( "Document No.", "Original Doc. No." );
                  PurchInvoiceLine.SETFILTER( Type, Text50003 );
                  if PurchInvoiceLine.FINDFIRST then
                    VATProtokolLines."VAT Prod. Posting Group" := PurchInvoiceLine."VAT Prod. Posting Group";
                end;
                "Original Doc. Type"::"Credit Memo" : begin
                  PurchCrMemoLine.RESET;
                  PurchCrMemoLine.SETRANGE( "Document No.", "Original Doc. No." );
                  PurchCrMemoLine.SETFILTER( Type, Text50003 );
                  if PurchCrMemoLine.FINDFIRST then
                    VATProtokolLines."VAT Prod. Posting Group" := PurchCrMemoLine."VAT Prod. Posting Group";
                end;
              end;

            end;
            "Document Type"::Sale : begin
              CustLedgerEntry.RESET;
              CustLedgerEntry.GET( "Apply-to Payment Entry" ); // !important to be without IF .. THEN
              CustLedgerEntry.TESTFIELD( "Customer No.", "CV No." );
              "Date of Chargeable Tax" := CustLedgerEntry."Document Date";
              "Document Date" := CustLedgerEntry."Document Date";
              "Posting Date" := CustLedgerEntry."Document Date";
              "VAT Date" := CustLedgerEntry."Document Date";

              VATProtokolLines.Description := CustLedgerEntry.Description;
              CustLedgerEntry.CALCFIELDS( Amount );
              VATProtokolLines."Unit Price (LCY)" := ABS( CustLedgerEntry.Amount );

              case "Original Doc. Type" of
                "Original Doc. Type"::Invoice : begin
                  SalesInvoiceLine.RESET;
                  SalesInvoiceLine.SETRANGE( "Document No.", "Original Doc. No." );
                  SalesInvoiceLine.SETFILTER( Type, Text50003 );
                  if SalesInvoiceLine.FINDFIRST then
                    VATProtokolLines."VAT Prod. Posting Group" := SalesInvoiceLine."VAT Prod. Posting Group";
                end;
                "Original Doc. Type"::"Credit Memo" : begin
                  SalesCrMemoLine.RESET;
                  SalesCrMemoLine.SETRANGE( "Document No.", "Original Doc. No." );
                  SalesCrMemoLine.SETFILTER( Type, Text50003 );
                  if SalesCrMemoLine.FINDFIRST then
                    VATProtokolLines."VAT Prod. Posting Group" := SalesCrMemoLine."VAT Prod. Posting Group";
                end;
              end;

            end;
          end;

          VATProtokolLines.VALIDATE( "VAT Bus. Posting Group", "VAT Bus. Posting Group" );
          VATProtokolLines.VALIDATE( "Bal. VAT Bus. Posting Group", "Bal. VAT Bus. Posting Group" );

          // VAT Calculations
          if VATProtokolLines."VAT %" = 0 then
            PayedBaseAmount := VATProtokolLines."Unit Price (LCY)"
          else begin
            TempSalesLine.INIT;
            TempSalesLine."Document Type" := TempSalesLine."Document Type"::Order;
            TempSalesLine."VAT Bus. Posting Group" := VATProtokolLines."VAT Bus. Posting Group";
            TempSalesLine."VAT Prod. Posting Group" := VATProtokolLines."VAT Prod. Posting Group";
            TempSalesLine."VAT %" := VATProtokolLines."VAT %";
            TempSalesLine.VALIDATE( "Amount Including VAT", VATProtokolLines."Unit Price (LCY)" );
            PayedBaseAmount := TempSalesLine.Amount;
          end;
          VATProtokolLines.VALIDATE( "VAT Base Amount (LCY)", PayedBaseAmount );

          VATProtokolLines.INSERT( true );
    end;

    procedure ApplyToPaymentEntryLookup() : Boolean;
    begin

          //NAVBG8.00; 001; entire function
          TESTFIELD( "Protocol Type", "Protocol Type"::"Unrealized VAT" );
          TESTFIELD( "CV No." );

          case "Document Type" of
            "Document Type"::Purchase : begin
              VendLedgerEntry.RESET;
              VendLedgerEntry.FILTERGROUP( 2 );
              VendLedgerEntry.SETRANGE( "Vendor No.", "CV No." );
              VendLedgerEntry.SETFILTER( "Document Type", Text50004, VendLedgerEntry."Document Type"::Payment,
                                                                     VendLedgerEntry."Document Type"::Refund );
              VendLedgerEntry.FILTERGROUP( 4 );
              if PAGE.RUNMODAL( 0, VendLedgerEntry ) = ACTION::LookupOK then begin
                VALIDATE( "Apply-to Payment Entry", VendLedgerEntry."Entry No." );
                exit( true );
              end;
            end;
            "Document Type"::Sale : begin
              CustLedgerEntry.RESET;
              CustLedgerEntry.FILTERGROUP( 2 );
              CustLedgerEntry.SETRANGE( "Customer No.", "CV No." );
              CustLedgerEntry.SETFILTER( "Document Type", Text50004, CustLedgerEntry."Document Type"::Payment,
                                                                     CustLedgerEntry."Document Type"::Refund );
              CustLedgerEntry.FILTERGROUP( 4 );
              if PAGE.RUNMODAL( 0, CustLedgerEntry ) = ACTION::LookupOK then begin
                VALIDATE( "Apply-to Payment Entry", CustLedgerEntry."Entry No." );
                exit( true );
              end;
            end;
          end;
    end;
}

