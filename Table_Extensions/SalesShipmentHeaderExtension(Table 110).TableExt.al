tableextension 46015508 "Sales Shipment Header Ext." extends "Sales Shipment Header"
{
    // version NAVW111.00.00.24232,NAVE18.00,NAVBG8.00

    fields
    {
        field(46015517; "VAT Bank No."; Code[20])
        {
            Caption = 'VAT Bank No.';
            Description = 'NAVBG8.00,001';
            TableRelation = "Bank Account";
        }
        field(46015530; "Bank Code"; Code[10])
        {
            Caption = 'Bank Code';
            Description = 'NAVBG8.00,001';
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
            TableRelation = "No. Series";

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
        field(46015605; "Registration No."; Text[20])
        {
            Caption = 'Registration No.';
            Description = 'NAVE18.00,001';
        }
        field(46015606; "Registration No. 2"; Text[20])
        {
            Caption = 'Registration No. 2';
            Description = 'NAVE18.00,001';
        }
        field(46015614; "Industry Code"; Code[20])
        {
            Caption = 'Industry Code';
            Description = 'NAVE18.00,001';
            TableRelation = "Industry Group";
        }
        field(46015615; "Bank No."; Code[20])
        {
            Caption = 'Bank No.';
            Description = 'NAVE18.00,001';
            TableRelation = "Bank Account";
        }
        field(46015616; "Bank Name"; Text[50])
        {
            Caption = 'Bank Name';
            Description = 'NAVE18.00,001';
        }
        field(46015617; "Bank Account No."; Text[30])
        {
            Caption = 'Bank Account No.';
            Description = 'NAVE18.00,001';
        }
        field(46015619; "EU 3-Party Intermediate Role"; Boolean)
        {
            Caption = 'EU 3-Party Intermediate Role';
            Description = 'NAVE18.00,001';
        }
        field(46015631; "Bank Branch No."; Text[20])
        {
            Caption = 'Bank Branch No.';
            Description = 'NAVE18.00,001';
        }
        field(46015632; IBAN; Code[50])
        {
            Caption = 'IBAN';
            Description = 'NAVE18.00,001';
        }
        field(46015636; "Delivery Person Name"; Text[30])
        {
            Caption = 'Delivery Person Name';
            Description = 'NAVE18.00,001';
            //This property is currently not supported
            //TestTableRelation = false;
            //TO DO
            //ValidateTableRelation = false;
        }
        field(46015637; "Identity Card No."; Code[20])
        {
            Caption = 'Identity Card No.';
            Description = 'NAVE18.00,001';
        }
        field(46015638; "Identity Card Authority"; Text[50])
        {
            Caption = 'Identity Card Authority';
            Description = 'NAVE18.00,001';
        }
        field(46015639; "Vehicle Reg. No."; Code[10])
        {
            Caption = 'Vehicle Reg. No.';
            Description = 'NAVE18.00,001';
        }
        field(46015640; "Delivery Transport Method"; Code[10])
        {
            Caption = 'Delivery Transport Method';
            Description = 'NAVE18.00,001';
            TableRelation = "Transport Method";
        }
        field(46015641; "Expedition Date"; Date)
        {
            Caption = 'Expedition Date';
            Description = 'NAVE18.00,001';
        }
        field(46015642; "Expedition Time"; Time)
        {
            Caption = 'Expedition Time';
            Description = 'NAVE18.00,001';
        }
        field(46015700; "Unrealized VAT"; Boolean)
        {
            Caption = 'Unrealized VAT';
            Description = 'NAVBG8.00,001';
        }
    }


    //Unsupported feature: CodeInsertion on "OnDelete". Please convert manually.

    //trigger (Variable: ExciseTaxDoc)();
    //Parameters and return type have not been exported.
    //begin
    /*
    */
    //end;


    //Unsupported feature: CodeModification on "OnDelete". Please convert manually.

    //trigger OnDelete();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    TESTFIELD("No. Printed");
    LOCKTABLE;
    PostSalesDelete.DeleteSalesShptLines(Rec);
    #4..9

    if CertificateOfSupply.GET(CertificateOfSupply."Document Type"::"Sales Shipment","No.") then
      CertificateOfSupply.DELETE(true);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    //NAVE18.00; 001; single
    if LocalizationUsage.UseEastLocalization then
      PostSalesDelete.CheckIfSalesDocDeleteAllowed("Posting Date");

    #1..12

    //NAVBG11.0; 001; begin
    if LocalizationUsage.UseEastLocalization then begin
      ExciseTaxDoc.SETCURRENTKEY("Document Type","Corresponding Doc. No.");
      ExciseTaxDoc.SETRANGE(ExciseTaxDoc."Corresponding Doc. No.","No.");
      ExciseTaxDoc.SETRANGE(ExciseTaxDoc."Document Type",ExciseTaxDoc."Document Type"::"Posted Sales Shipment");
      ExciseTaxDoc.DELETEALL;
    end;
    //NAVBG11.0; 001; end
    */
    //end;

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
        ExciseTaxDoc: Record "Excise Tax Document";

}

