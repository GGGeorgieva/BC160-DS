tableextension 46015561 "Sales Header Extension" extends "Sales Header"
{
    // version NAVW111.00.00.28629,NAVE110.0,NAVBG10.0

    //TODO:
    //Prices Including VAT - OnValidate
    //PROCEDURE GetNoSeriesCode()
    //PROCEDURE GetPostingNoSeriesCode()    

    fields
    {

        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            var
                Cust: Record Customer;
            begin
                Cust.GET("Sell-to Customer No.");
                "Registration No." := Cust."Registration No.";
                "Registration No. 2" := Cust."Registration No. 2";
                "Identification No." := Cust."Identification No.";

                VALIDATE("Transaction Type", Cust."Transaction Type");
                VALIDATE("Transaction Specification", Cust."Transaction Specification");
                VALIDATE("Transport Method", Cust."Transport Method");
                if "Document Type" in ["Document Type"::"Return Order", "Document Type"::"Credit Memo"] then
                    VALIDATE("Shipment Method Code", Cust."Shipment Method Code");

                if "Sell-to Customer No." <> xRec."Sell-to Customer No." then begin
                    ExciseTaxDoc.SETCURRENTKEY("Document Type", "Corresponding Doc. No.");
                    ExciseTaxDoc.SETRANGE(ExciseTaxDoc."Corresponding Doc. No.", "No.");
                    ExciseTaxDoc.SETRANGE(ExciseTaxDoc."Document Type", "Document Type");
                    if ExciseTaxDoc.FINDFIRST then begin
                        ExciseTaxDoc.VALIDATE(ExciseTaxDoc."Sell-to Customer No.", "Sell-to Customer No.");
                        ExciseTaxDoc.VALIDATE(ExciseTaxDoc."Sell-to Customer Name", "Sell-to Customer Name");
                        ExciseTaxDoc.MODIFY;
                    end;
                end;
                "Calculate Excise" := not Cust."Do not calculate Excise";
                MODIFY;
            end;
        }

        modify("Bill-to Customer No.")
        {
            trigger OnAfterValidate()
            var
                CustCheckCreditLimit: Codeunit "Cust-Check Cr. Limit";
                Cust: Record Customer;
            begin
                if GUIALLOWED and (CurrFieldNo <> 0) and ("Document Type".AsInteger() <= "Document Type"::Invoice.AsInteger()) then begin
                    "Amount Including VAT" := 0;
                    case "Document Type" of
                        "Document Type"::Quote, "Document Type"::Invoice:
                            CustCheckCreditLimit.SalesHeaderCheck(Rec);
                        "Document Type"::Order:
                            begin
                                if "Bill-to Customer No." <> xRec."Bill-to Customer No." then begin
                                    SalesLine.SETRANGE("Document Type", SalesLine."Document Type"::Order);
                                    SalesLine.SETRANGE("Document No.", "No.");
                                    SalesLine.CALCSUMS("Outstanding Amount", "Shipped Not Invoiced");
                                    "Amount Including VAT" := SalesLine."Outstanding Amount" + SalesLine."Shipped Not Invoiced";
                                end;
                                CustCheckCreditLimit.SalesHeaderCheck(Rec);
                            end;
                    end;
                    CALCFIELDS("Amount Including VAT");
                end;

                Cust.GET("Bill-to Customer No.");
                "VAT Country/Region Code" := Cust."Country/Region Code";
                "VAT Registration No." := Cust."VAT Registration No.";
                "Industry Code" := Cust."Industry Code";
                "Registration No." := Cust."Registration No.";
                "Identification No." := Cust."Identification No.";
                VALIDATE("VAT Bus. Posting Group", Cust."VAT Bus. Posting Group");
                MODIFY;
            end;
        }

        modify("Posting Date")
        {
            trigger OnAfterValidate()
            var
                SalesSetup: Record "Sales & Receivables Setup";
            begin
                SalesSetup.GET;
                if SalesSetup."Default VAT Date" = SalesSetup."Default VAT Date"::"Posting Date" then
                    VALIDATE("VAT Date", "Posting Date");
                if "Posting Date" <> xRec."Posting Date" then
                    UpdateExciseLabels;
                MODIFY;
            end;
        }

        modify("Customer Posting Group")
        {
            trigger OnBeforeValidate()
            var
                SalesSetup: Record "Sales & Receivables Setup";
            begin
                if (CurrFieldNo = FIELDNO("Customer Posting Group")) and
                  ("Customer Posting Group" <> xRec."Customer Posting Group")
                then begin
                    SalesSetup.GET;
                    if SalesSetup."Allow Alter Posting Groups" then begin
                        if not SubstCustPostingGrp.GET(xRec."Customer Posting Group", "Customer Posting Group") then
                            ERROR(Text46012225, xRec."Customer Posting Group", "Customer Posting Group", SubstCustPostingGrp.TABLECAPTION);
                    end else
                        ERROR(Text46012226, FIELDCAPTION("Customer Posting Group"), SalesSetup.FIELDCAPTION("Allow Alter Posting Groups"));
                end;
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

        modify("Sell-to Customer Name")
        {
            trigger OnAfterValidate()
            begin
                if "Sell-to Customer Name" <> xRec."Sell-to Customer Name" then begin
                    ExciseTaxDoc.SETCURRENTKEY("Document Type", "Corresponding Doc. No.");
                    ExciseTaxDoc.SETRANGE(ExciseTaxDoc."Corresponding Doc. No.", "No.");
                    ExciseTaxDoc.SETRANGE(ExciseTaxDoc."Document Type", "Document Type");
                    if ExciseTaxDoc.FINDFIRST then begin
                        ExciseTaxDoc.VALIDATE(ExciseTaxDoc."Sell-to Customer Name", "Sell-to Customer Name");
                        ExciseTaxDoc.MODIFY;
                    end;
                end;
            end;
        }

        modify("Bill-to Country/Region Code")
        {
            trigger OnAfterValidate()
            var
                CompanyInfo: Record "Company Information";
            begin
                CompanyInfo.GET;
                Export := not ("Bill-to Country/Region Code" in ['', CompanyInfo."Country/Region Code"]);
                VALIDATE("Calculate Excise", not Export);
                VALIDATE("Calculate Product Tax", not Export);
                MODIFY;
            end;
        }

        modify("Document Date")
        {
            trigger OnBeforeValidate()
            var
                SalesSetup: Record "Sales & Receivables Setup";
            begin
                SalesSetup.GET;
                if SalesSetup."Default VAT Date" = SalesSetup."Default VAT Date"::"Document Date" then
                    VALIDATE("VAT Date", "Document Date");
            end;
        }
        modify("VAT Bus. Posting Group")
        {
            trigger OnAfterValidate()
            begin
                if VATBusPostingGroup.GET("VAT Bus. Posting Group") then begin
                    "Unrealized VAT" := VATBusPostingGroup."Unrealized VAT";
                    MODIFY;
                end;
            end;
        }

        modify("Bill-to Contact No.")
        {
            trigger OnAfterValidate()
            var
                Cont: Record Contact;
                ContactBusinessRelationFound: Boolean;
                ContBusinessRelation: Record "Contact Business Relation";
                SearchContact: Record Contact;
            begin
                if not Cont.GET("Bill-to Contact No.") then begin
                    "Bill-to Contact" := '';
                    exit;
                end;
                if Cont.Type = Cont.Type::Person then
                    ContactBusinessRelationFound := ContBusinessRelation.FindByContact(ContBusinessRelation."Link to Table"::Customer.AsInteger(), Cont."No.");
                if not ContactBusinessRelationFound then
                    ContactBusinessRelationFound :=
                      ContBusinessRelation.FindByContact(ContBusinessRelation."Link to Table"::Customer.AsInteger(), Cont."Company No.");
                if not ContactBusinessRelationFound then begin
                    if "Document Type" = "Document Type"::Quote then begin
                        if Cont."Company No." <> '' then
                            SearchContact.GET(Cont."Company No.")
                        else
                            SearchContact.GET(Cont."No.");
                        "Registration No." := SearchContact."Registration No.";
                        "Registration No. 2" := SearchContact."Registration No. 2";
                        MODIFY;
                    end;
                end;
            end;
        }
        modify("Location Code")
        {
            trigger OnAfterValidate()
            var
                Location: Record Location;
            begin
                if "Location Code" <> '' then
                    if Location.GET("Location Code") then begin
                        Area := Location.Area;
                        MODIFY;
                    end;
            end;
        }
        modify("Responsibility Center")
        {
            trigger OnAfterValidate()
            var
                Location: Record Location;
            begin
                if "Location Code" <> '' then
                    if Location.GET("Location Code") then begin
                        Area := Location.Area;
                        MODIFY;
                    end;
            end;
        }

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
                SalesSetup: Record "Sales & Receivables Setup";
                NoSeriesMgt: Codeunit NoSeriesManagement;
            begin
                if "Excise Tax Document No." <> xRec."Excise Tax Document No." then begin
                    SalesSetup.GET;
                    NoSeriesMgt.TestManual(SalesSetup."Excise Tax Document Nos.");
                    "Excise Tax Document No. Series" := '';
                    ExciseTaxDoc.ValidateWithSalesValues(Rec);
                end else
                    ExciseTaxDoc.ValidateWithSalesValues(Rec);
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
            var
                GLSetup: Record "General Ledger Setup";
            begin
                GLSetup.GET;
                if not GLSetup."Use VAT Date" then
                    TESTFIELD("VAT Date", "Posting Date");
                if "VAT Date" <> xRec."VAT Date" then
                    UpdateSalesLines(FIELDCAPTION("VAT Date"), false);
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
                CompanyInfo: Record "Company Information";
            begin
                if BankAcc.GET("Bank No.") then begin
                    "Bank Name" := BankAcc.Name;
                    "Bank Account No." := BankAcc."Bank Account No.";
                    "Bank Branch No." := BankAcc."Bank Branch No.";
                    IBAN := BankAcc.IBAN;
                    "Bank Code" := BankAcc."Bank Code";
                end else begin
                    CompanyInfo.GET;
                    "Bank Name" := CompanyInfo."Bank Name";
                    "Bank Account No." := CompanyInfo."Bank Account No.";
                    "Bank Branch No." := CompanyInfo."Bank Branch No.";
                    IBAN := CompanyInfo.IBAN;
                    "Bank Code" := CompanyInfo."Bank Code";
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
                if "Posting Desc. Code" <> '' then
                    "Posting Description" := GetPostingDescription(Rec);

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
            var
                CompanyInfo: Record "Company Information";
            begin
                CompanyInfo.CheckIBAN(IBAN);
            end;
        }
        field(46015636; "Delivery Person Name"; Text[30])
        {
            Caption = 'Delivery Person Name';
            Description = 'NAVE110.0,001';
        }
        field(46015637; "Identity Card No."; Code[20])
        {
            Caption = 'Identity Card No.';
            Description = 'NAVE110.0,001';
            TableRelation = "Delivery Person";
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
    var
        "+++++++++++": Integer;
        Export: Boolean;
        "+++++++": Integer;
        VATBusPostingGroup: Record "VAT Business Posting Group";
        PostedSeriesNo: Code[20];
        SubstCustPostingGrp: Record "Subst. Customer Posting Group";
        DeliveryPerson: Record "Delivery Person";
        SalesLine: Record "Sales Line";
        CurrencyRateEntered: Boolean;
        Text46012225: Label 'You cannot change the %1 to %2 because %3 has not been filled in.';
        Text46012226: Label 'You cannot change %1 until %2 will be checked in setup.';
        ExciseTaxDoc: Record "Excise Tax Document";

    trigger OnAfterInsert()
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        SalesSetup.GET;
        VALIDATE("Posting Desc. Code", SalesSetup."Posting Desc. Code");
        MODIFY;
    end;

    trigger OnBeforeModify()
    begin
        VALIDATE("Posting Desc. Code");
    end;

    procedure GetPostingDescription(SalesHeader: Record "Sales Header"): Text[50];
    var
        PostingDesc: Record "Posting Description";
        RecordReference: RecordRef;
    begin
        if PostingDesc.GET(SalesHeader."Posting Desc. Code") then begin
            PostingDesc.TESTFIELD(Type, PostingDesc.Type::"Sales Document");
            RecordReference.OPEN(DATABASE::"Sales Header");
            RecordReference.GETTABLE(SalesHeader);
            exit(PostingDesc.ParsePostDescString(PostingDesc, RecordReference));
        end;
    end;

    procedure IsIntrastatTransaction() IsIntrastat: Boolean;
    var
        CountryRegion: Record "Country/Region";
    begin
        exit(CountryRegion.IsIntrastat("VAT Country/Region Code", false));
    END;

    procedure UpdateBankInfo();
    var
        RespCenter: Record "Responsibility Center";
        CompanyInfo: Record "Company Information";
    begin
        if RespCenter.GET("Responsibility Center") then begin
            "Bank Name" := RespCenter."Bank Name";
            "Bank Account No." := RespCenter."Bank Account No.";
            "Bank Branch No." := RespCenter."Bank Branch No.";
            IBAN := RespCenter.IBAN;
        end else begin
            CompanyInfo.GET;
            "Bank Name" := CompanyInfo."Bank Name";
            "Bank Account No." := CompanyInfo."Bank Account No.";
            "Bank Branch No." := CompanyInfo."Bank Branch No.";
            IBAN := CompanyInfo.IBAN;
        end;
    end;

    procedure getAmtInclDisc(InclVat: Boolean): Decimal;
    var
        TempSalesLine: Record "Sales Line" temporary;
        TotalSalesLine: Record "Sales Line";
        TotalSalesLineLCY: Record "Sales Line";
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        TotalAmount1: Decimal;
        TotalAmount2: Decimal;
        VATAmount: Decimal;
        VATAmountText: Text[30];
        ProfitLCY: Decimal;
        ProfitPct: Decimal;
        dateModified: Boolean;
        TotalAdjCostLCY: Decimal;
        SalesPost: Codeunit "Sales-Post";
    begin
        dateModified := false;
        if Rec."Posting Date" = 0D then begin
            dateModified := true;
            Rec."Posting Date" := WORKDATE;
        end;

        CLEAR(SalesLine);
        CLEAR(TotalSalesLine);
        CLEAR(TotalSalesLineLCY);
        CLEAR(SalesPost);

        TotalAdjCostLCY := 0;
        SalesPost.GetSalesLines(Rec, TempSalesLine, 0);
        CLEAR(SalesPost);
        SalesPost.SumSalesLinesTemp(
          Rec, TempSalesLine, 0, TotalSalesLine, TotalSalesLineLCY,
          VATAmount, VATAmountText, ProfitLCY, ProfitPct, TotalAdjCostLCY);

        if "Prices Including VAT" then begin
            TotalAmount2 := TotalSalesLine.Amount;
            TotalAmount1 := TotalSalesLine."Line Amount" - TotalSalesLine."Inv. Discount Amount";
        end else begin
            TotalAmount1 := TotalSalesLine.Amount;
            TotalAmount2 := TotalSalesLine."Amount Including VAT";
        end;

        SalesLine.CalcVATAmountLines(0, Rec, TempSalesLine, TempVATAmountLine);
        TempVATAmountLine.MODIFYALL(Modified, false);
        TempVATAmountLine.CALCSUMS("Amount Including VAT");

        if dateModified then begin
            Rec."Posting Date" := 0D;
        end;

        if InclVat then
            exit(TempVATAmountLine."Amount Including VAT")
        else
            exit(TotalSalesLine.Amount);
    end;

    procedure UpdateExciseLabels();
    begin
        if SalesLinesExist then
            SalesLine.FINDFIRST;
        repeat
            SalesLine.UpdateExciseLabel("Posting Date");
        until SalesLine.NEXT = 0;
    end;

    procedure FindSalesLine(pSaleHeader: Record "Sales Header"): Boolean;
    var
        lRecSalesLines: Record "Sales Line";
    begin
        lRecSalesLines.RESET;
        lRecSalesLines.SETRANGE(lRecSalesLines."Document Type", pSaleHeader."Document Type");
        lRecSalesLines.SETRANGE(lRecSalesLines."Document No.", pSaleHeader."No.");
        lRecSalesLines.SETRANGE(lRecSalesLines."Excise Item", true);
        if lRecSalesLines.FIND('-') then
            exit(true)
        else
            exit(false);
    end;
}

