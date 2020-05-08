tableextension 46015539 "Bank Acc. Post. Gr. Extension" extends "Bank Account Posting Group"
{
    // version NAVW111.00,NAVE111.0

    fields
    {
        field(46015645; "G/L Interim Account No."; Code[20])
        {
            Caption = 'G/L Interim Account No.';
            Description = 'NAVE111.0,001';
            TableRelation = "G/L Account";

            trigger OnValidate();
            begin
                // CheckGLAcc("G/L Interim Account No.");
            end;
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.

}

