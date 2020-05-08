tableextension 46015536 tableextension46015536 extends Item 
{
    // version NAVW111.00.00.27667,NAVBG11.0

    fields
    {
        field(46015505;"Unit Excise (LCY)";Decimal)
        {
            Caption = 'Unit Excise (LCY)';
            Description = 'NAVBG11.0,001';
        }
        field(46015506;"Degree / KW";Decimal)
        {
            Caption = 'Degree / KW';
            DecimalPlaces = 2:5;
            Description = 'NAVBG11.0,001';
        }
        field(46015507;Product;Boolean)
        {
            Caption = 'Product';
            Description = 'NAVBG11.0,001';
        }
        field(46015508;"Excise Item";Boolean)
        {
            Caption = 'Excise Item';
            Description = 'NAVBG11.0,001';
        }
        field(46015509;"Excise Decl. Unit of Measure";Code[10])
        {
            Caption = 'Excise Decl. Unit of Measure';
            Description = 'NAVBG11.0,001';
            TableRelation = "Item Unit of Measure".Code WHERE ("Item No."=FIELD("No."));
        }
        field(46015510;"Excise Per Exc. Decl. UM (LCY)";Decimal)
        {
            Caption = 'Excise Per Exc. Decl. UM (LCY)';
            DecimalPlaces = 2:5;
            Description = 'NAVBG11.0,001';
        }
        field(46015511;"Product Tax Item";Boolean)
        {
            Caption = 'Product Tax Item';
            Description = 'NAVBG11.0,001';
        }
        field(46015512;"Excise Classification Type";Code[10])
        {
            Caption = 'Excise Classification Type';
            TableRelation = "Excise Classification Type";
        }
        field(46015513;"Excise Destination";Code[2])
        {
            Caption = 'Excise Destination';
            Description = 'NAVBG11.0,001';
            TableRelation = "Excise Destination";
        }
        field(46015514;"Additional Excise Code";Text[13])
        {
            Caption = 'Additional Excise Code';
            Description = 'NAVBG11.0,001';
            Numeric = true;
        }
        field(46015515;"Inventory on Date";Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE ("Item No."=FIELD("No."),
                                                                  "Location Code"=FIELD("Location Filter"),
                                                                  "Drop Shipment"=CONST(false),
                                                                  "Posting Date"=FIELD("Date Filter")));
            Caption = 'Inventory on Date';
            DecimalPlaces = 0:5;
            Description = 'NAVBG11.0,001';
            Editable = false;
            FieldClass = FlowField;
        }
        field(46015516;"Excise Sales Price Percent";Decimal)
        {
            Caption = 'Excise Sales Price Percent';
            Description = 'NAVBG11.0,001';
        }
        field(46015517;"Alc.%";Code[5])
        {
            Caption = 'Alc.%';
            Description = 'NAVBG11.0,001';
        }
        field(46015518;"Excise Lables";Boolean)
        {
            Caption = 'Excise Lables';
            Description = 'NAVBG11.0,001';
        }
        field(46015519;APCode;Text[4])
        {
            Caption = 'AP Code';
            Description = 'NAVBG11.0,001';
        }
        field(46015520;"Brand Name";Text[10])
        {
            Caption = 'Brand Name';
            Description = 'NAVBG11.0,001';
        }
        field(46015521;Purpose;Text[4])
        {
            Caption = 'Purpose';
            Description = 'NAVBG11.0,001';
        }
    }
    keys
    {
        key(Key1;"Additional Excise Code")
        {
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
        ItemPackagingSpecification : Record "Item Packaging Specification";
        LocalizationUsage : Codeunit "Localization Usage";
}

