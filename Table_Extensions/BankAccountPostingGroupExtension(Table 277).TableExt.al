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
                CheckGLAcc("G/L Interim Account No.");
            end;
        }
    }
    procedure CheckGLAcc(AccNo: Code[20])
    var
        GLAcc: Record "G/L Account";
    begin
        if AccNo <> '' then begin
            GLAcc.GET(AccNo);
            GLAcc.CheckGLAcc;
        end;
    end;

}

