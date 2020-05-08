tableextension 46015591 "Transfer Shipment Line Ext." extends "Transfer Shipment Line"
{
    // version NAVW111.00,NAVBG11.0

    fields
    {
        field(46015505; "Inbound Excise Destination"; Code[2])
        {
            Caption = 'Inbound Excise Destination';
            Description = 'NAVBG11.0,001';
            TableRelation = "Excise Destination";
        }
        field(46015506; "Outbound Excise Destination"; Code[2])
        {
            Caption = 'Outbound Excise Destination';
            Description = 'NAVBG11.0,001';
            TableRelation = "Excise Destination";
        }
        field(46015507; "Additional Excise Code"; Text[13])
        {
            Caption = 'Additional Excise Code';
            Description = 'NAVBG11.0,001';
            Numeric = true;
        }
        field(46015508; "Excise Destination"; Code[2])
        {
            Caption = 'Excise Destination';
            Description = 'NAVBG11.0,001';
            TableRelation = "Excise Destination";
        }
        field(46015509; "Unit Excise"; Decimal)
        {
            Caption = 'Unit Excise';
            DecimalPlaces = 2 : 5;
            Description = 'NAVBG11.0,001';
            Editable = false;
        }
        field(46015510; "Excise Amount"; Decimal)
        {
            Caption = 'Excise Amount';
            Description = 'NAVBG11.0,001';
            Editable = false;
        }
        field(46015511; "Excise Item"; Boolean)
        {
            Caption = 'Excise Item';
            Description = 'NAVBG11.0,001';
            Editable = false;
        }
        field(46015512; "Calculate Excise"; Boolean)
        {
            Caption = 'Calculate Excise';
            Description = 'NAVBG11.0,001';
            Editable = true;

            trigger OnValidate();
            var
                lItem: Record Item;
            begin
            end;
        }
        field(46015513; "CN Code"; Code[10])
        {
            Caption = 'CN Code';
            Description = 'NAVBG11.0,001';
        }
        field(46015514; "Alcohol Content/Degree Plato"; Decimal)
        {
            Caption = 'Alcohol Content/Degree Plato';
            Description = 'NAVBG11.0,001';
        }
        field(46015515; "Excise Unit of Measure"; Code[10])
        {
            Caption = 'Excise Unit of Measure';
            Description = 'NAVBG11.0,001';
        }
        field(46015516; "Excise Rate"; Decimal)
        {
            Caption = 'Excise Rate';
            Description = 'NAVBG11.0,001';
        }
        field(46015517; "Excise Charge Acc. Base"; Decimal)
        {
            Caption = 'Excise Charge Acc. Base';
            Description = 'NAVBG11.0,001';
        }
        field(46015518; "Payment Obligation Type"; Code[2])
        {
            Caption = 'Payment Obligation Type';
            Description = 'NAVBG11.0,001';
            TableRelation = "Payment Obligation Type";
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


}

