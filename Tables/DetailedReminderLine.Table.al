table 46015640 "Detailed Reminder Line"
{
    // version NAVE18.00

    // -----------------------------------------------------------------------------------------
    // XAPT Solutions
    // MS Dynamics NAV 2015 Localisation
    // 
    // mp  : Mile Petachki
    // version : NAVE18.00
    // 
    // -----------------------------------------------------------------------------------------
    // No.   Sign     Date       Version        Description
    // -----------------------------------------------------------------------------------------
    // 001   mp       27.10.14   NAVE18.00      Created table from MS Dynamics NAV 6.00
    // ------------------------------------------------------------------------------------------

    Caption = 'Detailed Reminder Line';
    //DrillDownPageID = "Detailed Reminder Lines";
    //LookupPageID = "Detailed Reminder Lines";

    fields
    {
        field(1; "Reminder No."; Code[20])
        {
            Caption = 'Reminder No.';
            TableRelation = "Reminder Header";
        }
        field(2; "Reminder Line No."; Integer)
        {
            Caption = 'Reminder Line No.';
            NotBlank = true;
            TableRelation = "Reminder Line"."Line No.";
        }
        field(3; "Detailed Customer Entry No."; Integer)
        {
            Caption = 'Detailed Customer Entry No.';
            TableRelation = "Detailed Cust. Ledg. Entry"."Entry No.";
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
            Editable = false;
        }
        field(5; Days; Integer)
        {
            Caption = 'Days';
        }
        field(6; "Interest Rate"; Decimal)
        {
            Caption = 'Interest Rate';
        }
        field(7; "Interest Amount"; Decimal)
        {
            Caption = 'Interest Amount';
        }
        field(8; "Interest Base Amount"; Decimal)
        {
            Caption = 'Interest Base Amount';
        }
        field(9; "Entry Type"; Option)
        {
            CalcFormula = Lookup ("Detailed Cust. Ledg. Entry"."Entry Type" WHERE("Entry No." = FIELD("Detailed Customer Entry No.")));
            Caption = 'Entry Type';
            FieldClass = FlowField;
            OptionCaption = ',Initial Entry,Application,Unrealized Loss,Unrealized Gain,Realized Loss,Realized Gain,Payment Discount,Payment Discount (VAT Excl.),Payment Discount (VAT Adjustment),Appln. Rounding,Correction of Remaining Amount,Payment Tolerance,Payment Discount Tolerance,Payment Tolerance (VAT Excl.),Payment Tolerance (VAT Adjustment),Payment Discount Tolerance (VAT Excl.),Payment Discount Tolerance (VAT Adjustment)';
            OptionMembers = ,"Initial Entry",Application,"Unrealized Loss","Unrealized Gain","Realized Loss","Realized Gain","Payment Discount","Payment Discount (VAT Excl.)","Payment Discount (VAT Adjustment)","Appln. Rounding","Correction of Remaining Amount","Payment Tolerance","Payment Discount Tolerance","Payment Tolerance (VAT Excl.)","Payment Tolerance (VAT Adjustment)","Payment Discount Tolerance (VAT Excl.)","Payment Discount Tolerance (VAT Adjustment)";
        }
        field(10; "Posting Date"; Date)
        {
            CalcFormula = Lookup ("Detailed Cust. Ledg. Entry"."Posting Date" WHERE("Entry No." = FIELD("Detailed Customer Entry No.")));
            Caption = 'Posting Date';
            FieldClass = FlowField;
        }
        field(11; "Document Type"; enum "Gen. Journal Document Type")
        {
            CalcFormula = Lookup ("Detailed Cust. Ledg. Entry"."Document Type" WHERE("Entry No." = FIELD("Detailed Customer Entry No.")));
            Caption = 'Document Type';
            FieldClass = FlowField;
        }
        field(12; "Document No."; Code[20])
        {
            CalcFormula = Lookup ("Detailed Cust. Ledg. Entry"."Document No." WHERE("Entry No." = FIELD("Detailed Customer Entry No.")));
            Caption = 'Document No.';
            FieldClass = FlowField;
        }
        field(13; "Base Amount"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Lookup ("Detailed Cust. Ledg. Entry".Amount WHERE("Entry No." = FIELD("Detailed Customer Entry No.")));
            Caption = 'Base Amount';
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Reminder No.", "Reminder Line No.", "Detailed Customer Entry No.", "Line No.")
        {
            SumIndexFields = "Interest Amount", "Interest Base Amount";
        }
    }

    fieldgroups
    {
    }
}

