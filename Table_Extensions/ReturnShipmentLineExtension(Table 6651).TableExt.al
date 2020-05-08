tableextension 46015598 tableextension46015598 extends "Return Shipment Line" 
{
    // version NAVW111.00,NAVBG11.0

    fields
    {
        field(46015543;"Inbound Excise Destination";Code[2])
        {
            Caption = 'Inbound Excise Destination';
            Description = 'NAVBG11.0,001';
            TableRelation = Table16229;
        }
        field(46015549;"Additional Excise Code";Text[13])
        {
            Caption = 'Additional Excise Code';
            Description = 'NAVBG11.0,001';
            Numeric = true;
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.

}

