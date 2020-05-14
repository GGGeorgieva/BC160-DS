tableextension 46015566 "Purchase Line Extension" extends "Purchase Line"
{
    // version NAVW111.00.00.28629,NAVE111.0,NAVBG11.0

    //TODO
    //procedure ShowExciseLabels

    fields
    {
        modify(type)
        {
            trigger OnAfterValidate()
            begin
                if Type <> xRec.Type then
                    DeleteExciseLabels(true);
            end;
        }
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                if "No." <> xRec."No." then
                    DeleteExciseLabels(true);
            end;
        }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                if (xRec.Quantity <> Quantity) and (Quantity = 0) and
                        ((Amount <> 0) or ("Amount Including VAT" <> 0) or ("VAT Base Amount" <> 0))
                    then begin
                    "VAT Base (Non Deductible)" := 0;
                    "VAT Amount (Non Deductible)" := 0;
                end;
                SetDefaultQuantity;
                MODIFY;
            end;
        }
        modify(Amount)
        {
            trigger OnAfterValidate()
            var
                Currency: Record Currency;
            begin
                case "VAT Calculation Type" of
                    "VAT Calculation Type"::"Normal VAT",
                    "VAT Calculation Type"::"Reverse Charge VAT":
                        begin
                            Currency.GET("Currency Code");
                            if (Type in [Type::"G/L Account", Type::Item, Type::"Fixed Asset"]) then begin
                                "VAT Base (Non Deductible)" :=
                                  ROUND("VAT Base Amount" * "VAT % (Non Deductible)" / 100, Currency."Amount Rounding Precision");
                                MODIFY;
                            end;
                        end;
                end;
            end;
        }
        modify("Amount Including VAT")
        {
            trigger OnAfterValidate()
            var
                Currency: Record Currency;
            begin
                case "VAT Calculation Type" of
                    "VAT Calculation Type"::"Normal VAT",
                    "VAT Calculation Type"::"Reverse Charge VAT":
                        begin
                            Currency.GET("Currency Code");
                            if (Type in [Type::"G/L Account", Type::Item, Type::"Fixed Asset"]) then begin
                                "VAT Base (Non Deductible)" :=
                                  ROUND("VAT Base Amount" * "VAT % (Non Deductible)" / 100, Currency."Amount Rounding Precision");
                                MODIFY;
                            end;
                        end;
                end;
            end;
        }
        modify("VAT Prod. Posting Group")
        {
            trigger OnAfterValidate()
            var
                VATPostingSetup: Record "VAT Posting Setup";
            begin
                VATPostingSetup.GET("VAT Bus. Posting Group", "VAT Prod. Posting Group");
                "VAT Clause Code" := VATPostingSetup."VAT Clause Code";
                VATClause.GET("VAT Clause Code");
                "VAT Clause Description" := VATClause.Description;

                if (Type in [Type::"G/L Account", Type::Item, Type::"Fixed Asset"]) then
                    VALIDATE("VAT % (Non Deductible)", GetVATDeduction);

                VALIDATE("Prepayment %");
                MODIFY;
            end;
        }
        modify("Prepmt Amt to Deduct")
        {
            trigger OnBeforeValidate()
            begin
                if ("Qty. to Invoice" = Quantity - "Quantity Invoiced") then
                    TESTFIELD("Prepmt Amt to Deduct", "Prepmt. Amt. Inv." - "Prepmt Amt Deducted");
            end;
        }

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
            var
                GLSetup: Record "General Ledger Setup";
                VATPostingSetup: Record "VAT Posting Setup";
            begin
                if CurrFieldNo = FIELDNO("VAT Date") then begin
                    GLSetup.GET;
                    if not GLSetup."Allow VAT Date Change in Lines" then
                        ERROR(Text46012225,
                          GLSetup.FIELDCAPTION("Allow VAT Date Change in Lines"),
                          GLSetup.TABLECAPTION, FIELDCAPTION("VAT Date"));
                end;
                if Type in [Type::"G/L Account", Type::Item, Type::"Fixed Asset"] then begin
                    VATPostingSetup.GET("VAT Bus. Posting Group", "VAT Prod. Posting Group");
                    VALIDATE("VAT % (Non Deductible)", GetVATDeduction);
                end;
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
            var
                Currency: Record Currency;
            begin
                if Type in [Type::"G/L Account", Type::Item, Type::"Fixed Asset"] then begin
                    Currency.GET("Currency Code");
                    "VAT Base (Non Deductible)" :=
                      ROUND("Line Amount" * "VAT % (Non Deductible)" / 100, Currency."Amount Rounding Precision");
                    "VAT Amount (Non Deductible)" :=
                      ROUND("VAT Base (Non Deductible)" * "VAT %" / 100, Currency."Amount Rounding Precision");
                end;
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

    var
        Vendor: Record Vendor;
        VendorPostingGroup: Record "Vendor Posting Group";
        AbsoluteAdvCorrection: Boolean;
        PrepmtPct: Decimal;
        Text017: Label '\The entered information may be disregarded by warehouse operations.';
        PurchaseSetup: Record "Purchases & Payables Setup";
        Text46012225: Label 'You must check field %1 in %2 to be able to change the %3 field manually.';
        Text46012226: TextConst ENU = 'cannot be changed while there is a related %1=%2 in %3=%4';
        VATClause: Record "VAT Clause";
        ExciseLabel: Record "Excise Label";
        Text46012227: Label '"This action will lead to the loosing excise labels data that is specified for this sales line.\Do you want to continue?  "';

    procedure GetVATDeduction(): Decimal;
    var
        NonDeductVATSetup: Record "Non Deductible VAT Setup";
        VatPostingSetup: Record "VAT Posting Setup";
    begin
        if VATPostingSetup.GET("VAT Bus. Posting Group", "VAT Prod. Posting Group") then begin
            if (VATPostingSetup."VAT Calculation Type" = VATPostingSetup."VAT Calculation Type"::"Normal VAT") and
              VATPostingSetup."Allow Non Deductible VAT"
            then begin
                NonDeductVATSetup.RESET;
                NonDeductVATSetup.SETRANGE("VAT Bus. Posting Group", VATPostingSetup."VAT Bus. Posting Group");
                NonDeductVATSetup.SETRANGE("VAT Prod. Posting Group", VATPostingSetup."VAT Prod. Posting Group");
                NonDeductVATSetup.SETRANGE("From Date", 0D, "VAT Date");
                if NonDeductVATSetup.FINDLAST then begin
                    NonDeductVATSetup.TESTFIELD("Non Deductible VAT %");
                    exit(NonDeductVATSetup."Non Deductible VAT %");
                end
            end;
            exit(0);
        end;
    end;

    procedure ShowExciseLabels();
    var
        Item2: Record Item;
    begin
        TESTFIELD(Type, Type::Item.AsInteger());
        Item2.GET("No.");
        Item2.TESTFIELD("Excise Item");

        ExciseLabel.FILTERGROUP := 2;
        ExciseLabel.SETRANGE("Entry Type", ExciseLabel."Entry Type"::Purchase);
        ExciseLabel.SETRANGE("Document Type", "Document Type");
        ExciseLabel.SETRANGE("Document No.", "Document No.");
        ExciseLabel.SETRANGE("Document Line No.", "Line No.");
        ExciseLabel.FILTERGROUP := 0;
        //TODO: After adding the page
        //PAGE.RUNMODAL(PAGE::Page46015717,ExciseLabel);
    end;

    procedure DeleteExciseLabels(IsWarning: Boolean);
    begin
        ExciseLabel.SETRANGE("Entry Type", ExciseLabel."Entry Type"::Purchase);
        ExciseLabel.SETRANGE("Document Type", "Document Type");
        ExciseLabel.SETRANGE("Document No.", "Document No.");
        ExciseLabel.SETRANGE("Document Line No.", "Line No.");

        if ExciseLabel.FINDFIRST then begin
            if IsWarning and (not CONFIRM(Text46012227, false)) then
                ERROR('');

            ExciseLabel.DELETEALL;
        end;
    end;

    procedure UpdateExciseLabel(PostingDate: Date);
    begin
        ExciseLabel.RESET;
        ExciseLabel.SETRANGE("Entry Type", ExciseLabel."Entry Type"::Purchase);
        ExciseLabel.SETRANGE("Document Type", "Document Type");
        ExciseLabel.SETRANGE("Document No.", "Document No.");
        ExciseLabel.SETRANGE("Document Line No.", "Line No.");

        if ExciseLabel.FINDFIRST then
            repeat
                ExciseLabel."Posting Date" := PostingDate;
                ExciseLabel.MODIFY;
            until ExciseLabel.NEXT = 0;
    end;
}
//

