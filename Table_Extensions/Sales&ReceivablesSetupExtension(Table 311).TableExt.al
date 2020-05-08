tableextension 46015556 tableextension46015556 extends "Sales & Receivables Setup" 
{
    // version NAVW111.00.00.26401,NAVE111.0,NAVBG11.0

    fields
    {
        field(46015505;"Sales Protocol Nos.";Code[10])
        {
            Caption = 'Sales Protocol Nos.';
            Description = 'NAVBG11.0,001';
            TableRelation = "No. Series";
        }
        field(46015506;"Posted Sales Protocol Nos.";Code[10])
        {
            Caption = 'Posted Sales Protocol Nos.';
            Description = 'NAVBG11.0,001';
            TableRelation = "No. Series";
        }
        field(46015507;"EU VAT Bus. Posting Group";Code[20])
        {
            Caption = 'EU VAT Bus. Posting Group';
            Description = 'NAVBG11.0,001';
            TableRelation = "VAT Business Posting Group";
        }
        field(46015508;"Intr. Jnl. Incl. Item Charges";Boolean)
        {
            Caption = 'Intr. Jnl. Incl. Item Charges';
            Description = 'NAVBG11.0,001';
        }
        field(46015605;"Posted Doc. Deletion to Date";Date)
        {
            Caption = 'Posted Doc. Deletion to Date';
            Description = 'NAVE111.0,001';
        }
        field(46015607;"Delivery Data Mandatory";Boolean)
        {
            Caption = 'Delivery Data Mandatory';
            Description = 'NAVE111.0,001';
        }
        field(46015609;"Default VAT Date";Option)
        {
            Caption = 'Default VAT Date';
            Description = 'NAVE111.0,001';
            OptionCaption = 'Posting Date,Document Date,Blank';
            OptionMembers = "Posting Date","Document Date",Blank;
        }
        field(46015610;"Allow Alter Posting Groups";Boolean)
        {
            Caption = 'Allow Alter Posting Groups';
            Description = 'NAVE111.0,001';
        }
        field(46015614;"Credit Memo Confirmation";Boolean)
        {
            Caption = 'Credit Memo Confirmation';
            Description = 'NAVE111.0,001';

            trigger OnValidate();
            var
                GLSetup : Record "General Ledger Setup";
            begin
                GLSetup.GET;
                GLSetup.TESTFIELD("Use VAT Date");
            end;
        }
        field(46015624;"SAD Tariff Required";Boolean)
        {
            Caption = 'SAD Tariff Required';
            Description = 'NAVE111.0,001';
        }
        field(46015625;"Allow Manual Edit SAD Line";Boolean)
        {
            Caption = 'Allow Manual Edit SAD Line';
            Description = 'NAVE111.0,001';
        }
        field(46015626;"Export Statement Nos.";Code[10])
        {
            Caption = 'Export Statement Nos.';
            Description = 'NAVE111.0,001';
            TableRelation = "No. Series";
        }
        field(46015627;"Multiple Interest Rates";Boolean)
        {
            Caption = 'Multiple Interest Rates';
            Description = 'NAVE111.0,001';
        }
        field(46015630;"Posting Desc. Code";Code[10])
        {
            Caption = 'Posting Desc. Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Posting Description" WHERE (Type=CONST("Sales Document"));
        }
        field(46015631;"Fin. Charge Posting Desc. Code";Code[10])
        {
            Caption = 'Fin. Charge Posting Desc. Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Posting Description" WHERE (Type=CONST("Finance Charge"));
        }
        field(46015700;"Unreal. VAT Prot. Nos.";Code[20])
        {
            Caption = 'Unrealized VAT Protocol Nos.';
            Description = 'NAVBG11.0,001';
            TableRelation = "No. Series".Code;
        }
        field(46015701;"Posted Unreal. VAT Prot. Nos.";Code[20])
        {
            Caption = 'Posted Unrealized VAT Protocol Nos.';
            Description = 'NAVBG11.0,001';
            TableRelation = "No. Series".Code;
        }
        field(46015702;"Protokol VAT Bus. Post. Group";Code[20])
        {
            Caption = 'Protokol VAT Bus. Post. Group';
            Description = 'NAVBG11.0,001';
            TableRelation = "VAT Business Posting Group".Code;
        }
        field(46015703;"Excise Tax Document Nos.";Code[10])
        {
            Caption = 'Excise Tax Document Nos.';
            Description = 'NAVBG11.0,001';
            TableRelation = "No. Series";
        }
        field(46015704;"Check Pyament Obligation";Code[2])
        {
            Caption = 'Check Payment Obligation';
            Description = 'NAVBG11.0,001';
            TableRelation = "Excise Destination" WHERE ("Destination Type"=CONST(Outbound));
        }
        field(46015705;"Inbound for Retrun";Code[2])
        {
            Caption = 'Inbound for Retrun';
            Description = 'NAVBG11.0,001';
            TableRelation = "Excise Destination" WHERE ("Destination Type"=CONST(Inbound));
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.

}

