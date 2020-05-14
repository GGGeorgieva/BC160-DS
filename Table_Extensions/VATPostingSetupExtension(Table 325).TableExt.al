tableextension 46015555 "VAT Posting Setup Extension" extends "VAT Posting Setup"
{
    fields
    {
        modify("VAT Calculation Type")
        {
            trigger OnBeforeValidate()
            begin
                if ("VAT Calculation Type" <> "VAT Calculation Type"::"Normal VAT") and ("VAT Calculation Type" <> "VAT Calculation Type"::"Full VAT") then
                    TESTFIELD("Allow Non Deductible VAT", false);
            end;
        }
        field(46015505; "Sales VAT Ledger"; Option)
        {
            Caption = 'Sales VAT Ledger';
            Description = 'NAVBG11.0';
            OptionCaption = '" ,VAT Base (No Export),Export VAT Base,VAT Base For Free(no Par.91),Calc. VAT Others"';
            OptionMembers = " ","VAT Base (No Export)","Export VAT Base","VAT Base For Free(no Par.91)","Calc. VAT Others";
        }
        field(46015506; "Purchase VAT Ledger"; Option)
        {
            Caption = 'Purchase VAT Ledger';
            Description = 'NAVBG11.0';
            OptionCaption = '" ,No Tax Credit Right,Full Tax Credit,Part. Tax Credit"';
            OptionMembers = " ","No Tax Credit Right","Full Tax Credit","Part. Tax Credit";
        }
        field(46015507; "Transaction Type"; Option)
        {
            Caption = 'Transaction Type';
            Description = 'NAVBG11.0';
            OptionCaption = 'Purchases,Sales,Both';
            OptionMembers = Purchases,Sales,Both;
        }
        field(46015508; "Purchase VAT Refund Type"; Option)
        {
            Caption = 'Purchase VAT Refund Type';
            Description = 'NAVBG11.0';
            OptionCaption = 'Full Refund,Partial Refund,No Refund';
            OptionMembers = "Full Refund","Partial Refund","No Refund";
        }
        field(46015509; "VAT Classification Code"; Code[10])
        {
            Caption = 'VAT Classification Code';
            Description = 'NAVBG11.0';
            TableRelation = "VAT Classification";
        }
        field(46015510; "Corr. Sales VAT Account"; Code[20])
        {
            Caption = 'Corr. Sales VAT Account';
            Description = 'NAVBG11.0';
            TableRelation = "G/L Account";
        }
        field(46015605; "Sales VAT Postponed Account"; Code[20])
        {
            Caption = 'Sales VAT Postponed Account';
            Description = 'NAVE111.0';
            TableRelation = "G/L Account";

            trigger OnValidate();
            begin
                TestNotSalesTax(FIELDCAPTION("Sales VAT Postponed Account"));

                CheckGLAcc("Sales VAT Postponed Account");
            end;
        }
        field(46015607; "No. of VAT Clauses"; Integer)
        {
            CalcFormula = Count ("VAT Clause Setup" WHERE("VAT Bus. Posting Group" = FIELD("VAT Bus. Posting Group"),
                                                          "VAT Prod. Posting Group" = FIELD("VAT Prod. Posting Group")));
            Caption = 'No. of VAT Clauses';
            Description = 'NAVE111.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(46015610; "Allow Blank VAT Date"; Boolean)
        {
            Caption = 'Allow Blank VAT Date';
            Description = 'NAVE111.0';
        }
        field(46015615; "VIES Purchases"; Boolean)
        {
            Caption = 'VIES Purchases';
            Description = 'NAVE111.0';
        }
        field(46015616; "VIES Sales"; Boolean)
        {
            Caption = 'VIES Sales';
            Description = 'NAVE111.0';
        }
        field(46015635; "Allow Non Deductible VAT"; Boolean)
        {
            Caption = 'Allow Non Deductible VAT';
            Description = 'NAVE111.0';

            trigger OnValidate();
            begin
                if ("VAT Calculation Type" <> "VAT Calculation Type"::"Normal VAT") and ("VAT Calculation Type" <> "VAT Calculation Type"::"Full VAT") then
                    ERROR(VatCalcTypeError);
            end;
        }
        field(46015700; "VAT Chargeable On Recipient"; Option)
        {
            Caption = 'Purchase according to art. 163a of the VAT Act';
            Description = 'NAVBG11.0';
            OptionCaption = '" ,01,02"';
            OptionMembers = " ","01","02";
        }
        field(46015701; "Non Deductible  VAT EAD Acc."; Code[20])
        {
            Caption = 'Non Deductible  VAT EAD Acc.';
            Description = 'NAVBG11.0.007';
        }
    }
    var
        VatCalcTypeError: Label 'VAT Calculation Type must be "Full VAT" or "Normal VAT"';
}

