tableextension 46015531 "Gen. Posting Setup Extension" extends "General Posting Setup"
{
    // version NAVW111.00.00.21836,NAVBG11.0

    fields
    {
        field(46015505; "Sales Excise Acc. (Producer)"; Code[20])
        {
            Caption = 'Sales Excise Acc. (Producer)';
            Description = 'NAVBG11.0,001';
            TableRelation = "G/L Account";

            trigger OnValidate();
            begin
                CheckGLAcc("Sales Account");
            end;
        }
        field(46015506; "Sales Product Tax Acc. (Prod.)"; Code[20])
        {
            Caption = 'Sales Product Tax Acc. (Prod.)';
            Description = 'NAVBG11.0,001';
            TableRelation = "G/L Account";

            trigger OnValidate();
            begin
                CheckGLAcc("Sales Account");
            end;
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.

}

