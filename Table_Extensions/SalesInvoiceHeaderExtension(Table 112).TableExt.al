tableextension 46015509 "Sales Invoice Header Extension" extends "Sales Invoice Header"
{
    // version NAVW111.00.00.20783,NAVE111.0,NAVBG11.0
    //TODO:
    //trigger OnBeforeDelete()
    //PROCEDURE SendProfile()
    //PROCEDURE PrintRecords()
    //PROCEDURE Voiding

    fields
    {
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
            TableRelation = "Sales Invoice Header"."No." WHERE("Sell-to Customer No." = FIELD("Sell-to Customer No."));
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
        field(46015514; "Sales Location"; Text[30])
        {
            Caption = 'Sales Location';
            Description = 'NAVBG11.0,001';
        }
        field(46015515; "Do not include in VAT Ledgers"; Boolean)
        {
            Caption = 'Do not include in VAT Ledgers';
            Description = 'NAVBG11.0,001';
        }
        field(46015517; "VAT Bank No."; Code[20])
        {
            Caption = 'VAT Bank No.';
            Description = 'NAVBG11.0,001';
            TableRelation = "Bank Account";
        }
        field(46015518; "Calculate Excise"; Boolean)
        {
            Caption = 'Calculate Excise';
            Description = 'NAVBG11.0,001';
            InitValue = true;
        }
        field(46015519; "Excise Amount (LCY)"; Decimal)
        {
            CalcFormula = Sum ("Sales Invoice Line"."Excise Amount (LCY)" WHERE("Document No." = FIELD("No.")));
            Caption = 'Excise Amount (LCY)';
            Description = 'NAVBG11.0,001';
            Editable = false;
            FieldClass = FlowField;
        }
        field(46015520; "Excise Amount"; Decimal)
        {
            CalcFormula = Sum ("Sales Invoice Line"."Excise Amount" WHERE("Document No." = FIELD("No.")));
            Caption = 'Excise Amount';
            Description = 'NAVBG11.0,001';
            Editable = false;
            FieldClass = FlowField;
        }
        field(46015521; "Calculate Product Tax"; Boolean)
        {
            Caption = 'Calculate Product Tax';
            Description = 'NAVBG11.0,001';
            InitValue = true;
        }
        field(46015522; "Product Tax Amount (LCY)"; Decimal)
        {
            CalcFormula = Sum ("Sales Invoice Line"."Product Tax Amount (LCY)" WHERE("Document No." = FIELD("No.")));
            Caption = 'Product Tax Amount (LCY)';
            Description = 'NAVBG11.0,001';
            Editable = false;
            FieldClass = FlowField;
        }
        field(46015523; "Product Tax Amount"; Decimal)
        {
            CalcFormula = Sum ("Sales Invoice Line"."Product Tax Amount" WHERE("Document No." = FIELD("No.")));
            Caption = 'Product Tax Amount';
            Description = 'NAVBG11.0,001';
            Editable = false;
            FieldClass = FlowField;
        }
        field(46015526; "VAT Exempt Ground"; Code[10])
        {
            Caption = 'VAT Exempt Ground';
            Description = 'NAVBG11.0,001';
        }
        field(46015527; "Composed By"; Text[30])
        {
            Caption = 'Composed By';
            Description = 'NAVBG11.0,001';
        }
        field(46015528; "BP Documents Receipt Date"; Date)
        {
            Caption = 'BP Documents Receipt Date';
            Description = 'NAVBG11.0,001';
        }
        field(46015529; "VAT Protocol"; Boolean)
        {
            Caption = 'VAT Protocol';
            Description = 'NAVBG11.0,001';
        }
        field(46015530; "Bank Code"; Code[10])
        {
            Caption = 'Bank Code';
            Description = 'NAVBG11.0,001';
        }
        field(46015540; Appendix; Code[20])
        {
            Caption = 'Appendix';
            Description = 'NAVBG11.0,001';
        }
        field(46015541; "Country of Origin"; Code[10])
        {
            Caption = 'Country of Origin';
            Description = 'NAVBG11.0,001';
            TableRelation = "Country/Region";
        }
        field(46015542; "Excise Tax Document No."; Code[20])
        {
            Caption = 'Excise Tax Document No.';
            Description = 'NAVBG11.0,001';

            trigger OnValidate();
            var
                lRecSalesLine: Record "Sales Line";
            begin
            end;
        }
        field(46015543; "Excise Charge Ground Code"; Code[20])
        {
            Caption = 'Excise Charge Ground Code';
            Description = 'NAVBG11.0,001';
            TableRelation = "Excise Charge Ground";

            trigger OnValidate();
            var
                lRecSalesLine: Record "Sales Line";
            begin
            end;
        }
        field(46015544; "Excise Document Date"; Date)
        {
            Caption = 'Excise Document Date';
            Description = 'NAVBG11.0,001';
        }
        field(46015545; "Payment Obligation Type"; Code[2])
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
        field(46015547; "Excise Tax Document No. Series"; Code[10])
        {
            Caption = 'Excise Tax Document No. Series';
            Description = 'NAVBG11.0,001';
            TableRelation = "No. Series";
        }
        field(46015548; "Dispatched by"; Text[50])
        {
            Caption = 'Dispatched by';
            Description = 'NAVBG11.0,001';
        }
        field(46015549; "Tariff No."; Text[50])
        {
            Caption = 'Tariff No.';
            Description = 'NAVBG11.0,001';
        }
        field(46015550; "Outbound Excise Destination"; Code[2])
        {
            Caption = 'Outbound Excise Destination';
            Description = 'NAVBG11.0,001';
            TableRelation = "Excise Destination";

            trigger OnValidate();
            var
                lRecSalesLine: Record "Sales Line";
            begin
            end;
        }
        field(46015551; "Do not include in Excise"; Boolean)
        {
            Caption = 'Do not include in Excise';
            Description = 'NAVBG11.0,001';

            trigger OnValidate();
            var
                lRecSalesLine: Record "Sales Line";
            begin
            end;
        }
        field(46015552; "Excise Declaration Correction"; Boolean)
        {
            Caption = 'Excise Declaration Correction';
            Description = 'NAVBG11.0,001';

            trigger OnValidate();
            var
                lRecSalesLine: Record "Sales Line";
            begin
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
            Description = 'NAVE111.0,001';
        }
        field(46015606; "Registration No. 2"; Text[20])
        {
            Caption = 'Registration No. 2';
            Description = 'NAVE111.0,001';
        }
        field(46015610; "VAT Date"; Date)
        {
            Caption = 'VAT Date';
            Description = 'NAVE111.0,001';
        }
        field(46015614; "Industry Code"; Code[20])
        {
            Caption = 'Industry Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Industry Code";
        }
        field(46015615; "Bank No."; Code[20])
        {
            Caption = 'Bank No.';
            Description = 'NAVE111.0,001';
            TableRelation = "Bank Account";
        }
        field(46015616; "Bank Name"; Text[50])
        {
            Caption = 'Bank Name';
            Description = 'NAVE111.0,001';
        }
        field(46015617; "Bank Account No."; Text[30])
        {
            Caption = 'Bank Account No.';
            Description = 'NAVE111.0,001';
        }
        field(46015619; "EU 3-Party Intermediate Role"; Boolean)
        {
            Caption = 'EU 3-Party Intermediate Role';
            Description = 'NAVE111.0,001';
        }
        field(46015623; "Reversed By Cr. Memo No."; Code[20])
        {
            Caption = 'Reversed By Cr. Memo No.';
            Description = 'NAVE111.0,001';
        }
        field(46015625; "SAD No."; Code[20])
        {
            Caption = 'SAD No.';
            Description = 'NAVE111.0,001';
            TableRelation = "Export SAD Header" WHERE("Customer No." = FIELD("Sell-to Customer No."));
        }
        field(46015626; "Customs Procedure Code"; Code[10])
        {
            Caption = 'Customs Procedure Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Custom Procedure";
        }
        field(46015627; "SAD Export No."; Code[20])
        {
            Caption = 'SAD Export No.';
            Description = 'NAVE111.0,001';
        }
        field(46015628; "SAD Export Date"; Date)
        {
            Caption = 'SAD Export Date';
            Description = 'NAVE111.0,001';
        }
        field(46015631; "Bank Branch No."; Text[20])
        {
            Caption = 'Bank Branch No.';
            Description = 'NAVE111.0,001';
        }
        field(46015632; IBAN; Code[50])
        {
            Caption = 'IBAN';
            Description = 'NAVE111.0,001';
        }
        field(46015636; "Delivery Person Name"; Text[30])
        {
            Caption = 'Delivery Person Name';
            Description = 'NAVE111.0,001';
        }
        field(46015637; "Identity Card No."; Code[20])
        {
            Caption = 'Identity Card No.';
            Description = 'NAVE111.0,001';
        }
        field(46015638; "Identity Card Authority"; Text[50])
        {
            Caption = 'Identity Card Authority';
            Description = 'NAVE111.0,001';
        }
        field(46015639; "Vehicle Reg. No."; Code[10])
        {
            Caption = 'Vehicle Reg. No.';
            Description = 'NAVE111.0,001';
        }
        field(46015640; "Delivery Transport Method"; Code[10])
        {
            Caption = 'Delivery Transport Method';
            Description = 'NAVE111.0,001';
            TableRelation = "Transport Method";
        }
        field(46015641; "Expedition Date"; Date)
        {
            Caption = 'Expedition Date';
            Description = 'NAVE111.0,001';
        }
        field(46015642; "Expedition Time"; Time)
        {
            Caption = 'Expedition Time';
            Description = 'NAVE111.0,001';
        }
        field(46015643; "Security No."; Code[13])
        {
            Caption = 'Security No.';
            Description = 'NAVE111.0,001';
        }
        field(46015700; "Unrealized VAT"; Boolean)
        {
            Caption = 'Unrealized VAT';
            Description = 'NAVBG11.0,001';
        }
    }

    var
        ExciseTaxDoc: Record "Excise Tax Document";
        Text46012125: Label 'The purpose of this voiding is to show correctly the voided document in VAT ledgers in accordance with Bulgarian law. The voiding does not create any reversed entries. In order to void the entries a credit memo must be posted. Do you want to continue?';
        Text46012126: Label 'The document is already voided.';
        Text46012127: Label 'Document %1 was voided.';

    trigger OnBeforeDelete()
    var
        PostSalesDelete: Codeunit "PostSales-Delete";
    begin
        //TODO: After adding the procedure
        //PostSalesDelete.CheckIfSalesDocDeleteAllowed("Posting Date")
    end;

    trigger OnDelete()
    begin
        ExciseTaxDoc.SETCURRENTKEY("Document Type", "Corresponding Doc. No.");
        ExciseTaxDoc.SETRANGE(ExciseTaxDoc."Corresponding Doc. No.", "No.");
        ExciseTaxDoc.SETRANGE(ExciseTaxDoc."Document Type", ExciseTaxDoc."Document Type"::"Posted Sales Invoice");
        ExciseTaxDoc.DELETEALL;
    end;

    procedure Voiding();
    var
        VATEntry: Record "VAT Entry";
    //TODO: after adding the page
    //VoidDate : Page "Void Date Input";
    begin
        if Void then
            ERROR(Text46012126);
        //TODO: After Adding the page
        /*
          if VoidDate.RUNMODAL = ACTION::OK then begin
            VoidDate.GetVoidDate("Void Date");
            if "Void Date" = 0D then
              exit;
          end;
          */

        if not CONFIRM(Text46012125) then
            exit;

        VATEntry.RESET;
        VATEntry.SETRANGE(Type, VATEntry.Type::Sale);
        VATEntry.SETRANGE("Document No.", "No.");
        VATEntry.SETRANGE("Posting Date", "Posting Date");
        if VATEntry.FIND('-') then
            repeat
                VATEntry.Void := true;
                VATEntry."Void Date" := "Void Date";
                VATEntry.MODIFY;
            until VATEntry.NEXT = 0;

        Void := true;
        MODIFY;

        MESSAGE(Text46012127, "No.");
    end;
}
//

