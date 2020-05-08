tableextension 46015570 tableextension46015570 extends "Detailed Vendor Ledg. Entry" 
{
    // version NAVW111.00.00.20783,NAVE111.0

    fields
    {
        field(46015625;"Vendor Posting Group";Code[10])
        {
            Caption = 'Vendor Posting Group';
            Description = 'NAVE111.0,001';
            TableRelation = "Vendor Posting Group";
        }
    }
    keys
    {

        //Unsupported feature: PropertyChange on ""Entry No."(Key)". Please convert manually.


        //Unsupported feature: PropertyChange on ""Vendor Ledger Entry No.","Entry Type","Posting Date"(Key)". Please convert manually.

    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.

}

