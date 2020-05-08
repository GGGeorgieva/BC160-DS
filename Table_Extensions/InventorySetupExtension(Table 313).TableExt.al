tableextension 46015557 "Inventory Setup Extension" extends "Inventory Setup"
{
    // version NAVW111.00,NAVE111.0,NAVBG11.0

    fields
    {
        field(46015615; "Post Neg. Transfers as Corr."; Boolean)
        {
            Caption = 'Post Neg. Transfers as Corr.';
            Description = 'NAVE111.0,001';
        }
        field(46015616; "Post Exp. Cost Conv. as Corr."; Boolean)
        {
            Caption = 'Post Exp. Cost Conv. as Corr.';
            Description = 'NAVE111.0,001';
        }
        field(46015630; "Posting Desc. Code"; Code[10])
        {
            Caption = 'Posting Desc. Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Posting Description" WHERE(Type = CONST("Post Inventory Cost"));
        }
        field(46015631; "Non-Excise Item Transfers"; Option)
        {
            Caption = 'Non-Excise Item Transfers';
            Description = 'NAVBG11.0,001';
            OptionCaption = 'Allow,Confirm,Not Allow';
            OptionMembers = Allow,Confirm,"Not Allow";
        }
        field(46015632; "Outbound Excise Destination"; Code[2])
        {
            Caption = 'Outbound Excise Destination';
            Description = 'NAVBG11.0,001';
            TableRelation = "Excise Destination" WHERE("Destination Type" = CONST(Outbound));

            trigger OnValidate();
            var
                lRecSalesLine: Record "Sales Line";
            begin
            end;
        }
        field(46015633; "Inbound Excise Destination"; Code[2])
        {
            Caption = 'Inbound Excise Destination';
            Description = 'NAVBG11.0,001';
            TableRelation = "Excise Destination" WHERE("Destination Type" = CONST(Inbound));
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.



    //Unsupported feature: PropertyModification on "Text000(Variable 1001)". Please convert manually.

    //var
    //>>>> ORIGINAL VALUE:
    //Text000 : ENU=Some unadjusted value entries will not be covered with the new setting. You must run the Adjust Cost - Item Entries batch job once to adjust these.;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //Text000 : ENU="Some unadjusted value entries will not be covered with the new setting. You must run the Adjust Cost - Item Entries batch job once to adjust these. ";
    //Variable type has not been exported.
}

