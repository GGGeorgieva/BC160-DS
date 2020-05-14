tableextension 46015588 "Value Entry Extension" extends "Value Entry"
{
    // version NAVW111.00.00.22292,NAVBG11.0

    fields
    {
        field(46015505; "Unit Excise"; Decimal)
        {
            Caption = 'Unit Excise';
            DecimalPlaces = 2 : 5;
            Description = 'NAVBG11.0,001';
        }
        field(46015506; "Unit Excise (ACY)"; Decimal)
        {
            Caption = 'Unit Excise (ACY)';
            DecimalPlaces = 2 : 5;
            Description = 'NAVBG11.0,001';
            Editable = false;
        }
        field(46015507; "Excise Amount (Actual)"; Decimal)
        {
            Caption = 'Excise Amount (Actual)';
            Description = 'NAVBG11.0,001';
        }
        field(46015508; "Excise Amount (Actual) (ACY)"; Decimal)
        {
            Caption = 'Excise Amount (Actual) (ACY)';
            Description = 'NAVBG11.0,001';
        }
        field(46015509; Product; Boolean)
        {
            Caption = 'Product';
            Description = 'NAVBG11.0,001';
        }
        field(46015510; "Calculate Excise"; Boolean)
        {
            Caption = 'Calculate Excise';
            Description = 'NAVBG11.0,001';
        }
        field(46015511; "Unit Product Tax"; Decimal)
        {
            Caption = 'Unit Product Tax';
            DecimalPlaces = 2 : 5;
            Description = 'NAVBG11.0,001';
        }
        field(46015512; "Unit Product Tax (ACY)"; Decimal)
        {
            Caption = 'Unit Product Tax (ACY)';
            DecimalPlaces = 2 : 5;
            Description = 'NAVBG11.0,001';
            Editable = false;
        }
        field(46015513; "Product Tax Amount (Actual)"; Decimal)
        {
            Caption = 'Product Tax Amount (Actual)';
            Description = 'NAVBG11.0,001';
        }
        field(46015514; "Product Tax Amount (Act.)(ACY)"; Decimal)
        {
            Caption = 'Product Tax Amount (Act.)(ACY)';
            Description = 'NAVBG11.0,001';
        }
        field(46015515; "Excise Amount (Expected)"; Decimal)
        {
            Caption = 'Excise Amount (Expected)';
            Description = 'NAVBG11.0,001';
        }
        field(46015516; "Excise Amount (Expected) (ACY)"; Decimal)
        {
            Caption = 'Excise Amount (Expected) (ACY)';
            Description = 'NAVBG11.0,001';
        }
        field(46015517; "Product Tax Amount (Expected)"; Decimal)
        {
            Caption = 'Product Tax Amount (Expected)';
            Description = 'NAVBG11.0,001';
        }
        field(46015518; "Product Tax Amount (Exp.)(ACY)"; Decimal)
        {
            Caption = 'Product Tax Amount (Exp.)(ACY)';
            Description = 'NAVBG11.0,001';
        }
        field(46015519; "Calculate Product Tax"; Boolean)
        {
            Caption = 'Calculate Product Tax';
            Description = 'NAVBG11.0,001';
        }
        field(46015606; "Incl. in Intrastat Amount"; Boolean)
        {
            Caption = 'Incl. in Intrastat Amount';
            Description = 'NAVE111.0,001';
        }
        field(46015607; "Incl. in Intrastat Stat. Value"; Boolean)
        {
            Caption = 'Incl. in Intrastat Stat. Value';
            Description = 'NAVE111.0,001';
        }
        field(46015615; "G/L Correction"; Boolean)
        {
            Caption = 'G/L Correction';
            Description = 'NAVE111.0,001';
        }
        field(46015625; "SAD No."; Code[20])
        {
            Caption = 'SAD No.';
            Description = 'NAVE111.0,001';
            Editable = false;
            TableRelation = IF ("Source Type" = CONST(Customer)) "Export SAD Header" WHERE("Customer No." = FIELD("Source No."))
            ELSE
            IF ("Source Type" = CONST(Vendor)) "Import SAD Header" WHERE("Vendor No." = FIELD("Source No."));
        }
    }
    keys
    {
        //TODO HOW KEYS EXTENDED ?
        /*
        key(Key1;"Entry Type","Expected Cost","Calculate Excise","Item No.","Posting Date")
        {
        }
        */
    }
    PROCEDURE AddActualCostBuf(ValueEntry: Record "Value Entry"; NewAdjustedCost: Decimal; NewAdjustedCostACY: Decimal; ItemLedgEntryPostingDate: Date);
    BEGIN
        //NAVE111.0; 001; entire function
        RESET;
        "Entry No." := ValueEntry."Entry No.";
        if FIND then begin
            if ValueEntry."Expected Cost" then begin
                "Cost Amount (Expected)" := "Cost Amount (Expected)" + NewAdjustedCost;
                "Cost Amount (Expected) (ACY)" := "Cost Amount (Expected) (ACY)" + NewAdjustedCostACY;
            end else begin
                "Cost Amount (Actual)" := "Cost Amount (Actual)" + NewAdjustedCost;
                "Cost Amount (Actual) (ACY)" := "Cost Amount (Actual) (ACY)" + NewAdjustedCostACY;
            end;
            MODIFY;
        end else begin
            INIT;
            "Item No." := ValueEntry."Item No.";
            "Document No." := ValueEntry."Document No.";
            "Location Code" := ValueEntry."Location Code";
            "Variant Code" := ValueEntry."Variant Code";
            "Entry Type" := ValueEntry."Entry Type";
            "Item Ledger Entry No." := ValueEntry."Item Ledger Entry No.";
            "Expected Cost" := ValueEntry."Expected Cost";
            if ItemLedgEntryPostingDate = 0D then
                "Posting Date" := ValueEntry."Posting Date"
            else
                "Posting Date" := ItemLedgEntryPostingDate;
            if ValueEntry."Expected Cost" then begin
                "Cost Amount (Expected)" := NewAdjustedCost;
                "Cost Amount (Expected) (ACY)" := NewAdjustedCostACY;
            end else begin
                "Cost Amount (Actual)" := NewAdjustedCost;
                "Cost Amount (Actual) (ACY)" := NewAdjustedCostACY;
            end;
            "Valued By Average Cost" := ValueEntry."Valued By Average Cost";
            "Valuation Date" := ValueEntry."Valuation Date";
            INSERT;
        end;
    END;

    PROCEDURE AddBalanceExpectedCostBuf(ValueEntry: Record "Value Entry"; NewAdjustedCost: Decimal; NewAdjustedCostACY: Decimal);
    BEGIN
        //NAVE111.0; 001; entire function
        if ValueEntry."Expected Cost" or
           (ValueEntry."Entry Type" <> ValueEntry."Entry Type"::"Direct Cost")
        then
            exit;

        RESET;
        "Entry No." := ValueEntry."Entry No.";
        FIND;
        "Cost Amount (Expected)" := NewAdjustedCost;
        "Cost Amount (Expected) (ACY)" := NewAdjustedCostACY;
        MODIFY;
    END;

    PROCEDURE GetCostAmt(): Decimal;
    BEGIN
        //NAVE111.0; 001; entire function
        if "Cost Amount (Actual)" = 0 then
            exit("Cost Amount (Expected)");
        exit("Cost Amount (Actual)");
    END;
}

