tableextension 46015554 "Item Ledger Entry Extension" extends "Item Ledger Entry"
{
    // version NAVW111.00.00.27667,NAVE111.0,NAVBG11.0

    fields
    {
        field(46015505; "Excise Amount"; Decimal)
        {
            CalcFormula = Sum ("Value Entry"."Excise Amount (Actual)" WHERE("Item Ledger Entry No." = FIELD("Entry No.")));
            Caption = 'Excise Amount';
            Description = 'NAVBG11.0,001';
            Editable = false;
            FieldClass = FlowField;
        }
        field(46015506; "Excise Amount (ACY)"; Decimal)
        {
            CalcFormula = Sum ("Value Entry"."Excise Amount (Actual) (ACY)" WHERE("Item Ledger Entry No." = FIELD("Entry No.")));
            Caption = 'Excise Amount (ACY)';
            Description = 'NAVBG11.0,001';
            Editable = false;
            FieldClass = FlowField;
        }
        field(46015507; "Product Tax Amount"; Decimal)
        {
            CalcFormula = Sum ("Value Entry"."Product Tax Amount (Actual)" WHERE("Item Ledger Entry No." = FIELD("Entry No.")));
            Caption = 'Product Tax Amount';
            Description = 'NAVBG11.0,001';
            Editable = false;
            FieldClass = FlowField;
        }
        field(46015508; "Product Tax Amount (ACY)"; Decimal)
        {
            CalcFormula = Sum ("Value Entry"."Product Tax Amount (Act.)(ACY)" WHERE("Item Ledger Entry No." = FIELD("Entry No.")));
            Caption = 'Product Tax Amount (ACY)';
            Description = 'NAVBG11.0,001';
            Editable = false;
            FieldClass = FlowField;
        }
        field(46015509; "Excise Amount (Expected)"; Decimal)
        {
            CalcFormula = Sum ("Value Entry"."Excise Amount (Expected)" WHERE("Item Ledger Entry No." = FIELD("Entry No.")));
            Caption = 'Excise Amount (Expected)';
            Description = 'NAVBG11.0,001';
            Editable = false;
            FieldClass = FlowField;
        }
        field(46015510; "Excise Amount (Expected) (ACY)"; Decimal)
        {
            CalcFormula = Sum ("Value Entry"."Excise Amount (Expected) (ACY)" WHERE("Item Ledger Entry No." = FIELD("Entry No.")));
            Caption = 'Excise Amount (Expected) (ACY)';
            Description = 'NAVBG11.0,001';
            Editable = false;
            FieldClass = FlowField;
        }
        field(46015511; "Product Tax Amount (Expected)"; Decimal)
        {
            CalcFormula = Sum ("Value Entry"."Product Tax Amount (Expected)" WHERE("Item Ledger Entry No." = FIELD("Entry No.")));
            Caption = 'Product Tax Amount (Expected)';
            Description = 'NAVBG11.0,001';
            Editable = false;
            FieldClass = FlowField;
        }
        field(46015512; "Product Tax Amount (Exp.)(ACY)"; Decimal)
        {
            CalcFormula = Sum ("Value Entry"."Product Tax Amount (Exp.)(ACY)" WHERE("Item Ledger Entry No." = FIELD("Entry No.")));
            Caption = 'Product Tax Amount (Exp.)(ACY)';
            Description = 'NAVBG11.0,001';
            Editable = false;
            FieldClass = FlowField;
        }
        field(46015515; "Transport Country/Region Code"; Code[10])
        {
            Caption = 'Transport Country/Region Code';
            Description = 'NAVBG11.0,001';
            TableRelation = "Country/Region";
        }
        field(46015605; "Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Shipment Method";
        }
        field(46015607; "Tariff No."; Code[10])
        {
            Caption = 'Tariff No.';
            Description = 'NAVE111.0,001';
            TableRelation = "Tariff Number";
        }
        field(46015608; "Net Weight"; Decimal)
        {
            Caption = 'Net Weight';
            DecimalPlaces = 0 : 5;
            Description = 'NAVE111.0,001';
        }
        field(46015609; "Country/Region of Origin Code"; Code[10])
        {
            Caption = 'Country/Region of Origin Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Country/Region";
        }
        field(46015611; "Intrastat Transaction"; Boolean)
        {
            Caption = 'Intrastat Transaction';
            Description = 'NAVE111.0,001';
        }
        field(46015615; "SAD No."; Code[20])
        {
            Caption = 'SAD No.';
            Description = 'NAVE111.0,001';
            Editable = false;
            TableRelation = IF ("Source Type" = CONST(Customer)) "Export SAD Header" WHERE("Customer No." = FIELD("Source No."))
            ELSE
            IF ("Source Type" = CONST(Vendor)) "Import SAD Header" WHERE("Vendor No." = FIELD("Source No."));
        }
        field(46015616; "Outbound Excise Destination"; Code[2])
        {
            Caption = 'Outbound Excise Destination';
            Description = 'NAVBG11.0,001';
        }
        field(46015617; "Inbound Excise Destination"; Code[2])
        {
            Caption = 'Inbound Excise Destination';
            Description = 'NAVBG11.0,001';
        }
        field(46015618; "Additional Excise Code"; Text[13])
        {
            Caption = 'Additional Excise Code';
            Description = 'NAVBG11.0,001';
            Numeric = true;
        }
        field(46015619; "Payment Obligation Type"; Code[2])
        {
            Caption = 'Payment Obligation Type';
            Description = 'NAVBG11.0,001';
        }
        field(46015620; "Excise Lables"; Boolean)
        {
            Caption = 'Excise Lables';
            Description = 'NAVBG11.0,001';
        }
        field(46015621; "Show In Excise Declar"; Boolean)
        {
            Caption = 'Show In Excise Declar';
            Description = 'NAVBG11.0,001';
        }
        field(46015622; "Exclude from Declaration"; Boolean)
        {
            Caption = 'Exclude from Declaration';
            Description = 'NAVBG11.0,001';
        }
        field(46015623; "Excise Correction"; Boolean)
        {
            Caption = 'Excise Correction';
            Description = 'NAVBG11.0,001';
        }
        field(46015624; "Excise Declaration Correction"; Boolean)
        {
            Caption = 'Excise Declaration Correction';
            Description = 'NAVBG11.0,001';
        }
    }
    keys
    {
        //TO DO
        /*
        key(Key1;"Entry Type","Source No.","Document No.")
        {
        }
        key(Key2;"Item No.","Payment Obligation Type","Outbound Excise Destination")
        {
        }
        */
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.

}

