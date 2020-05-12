tableextension 46015513 "Purch. Rcpt. Header Extension" extends "Purch. Rcpt. Header"
{
    // version NAVW111.00.00.28629,NAVE111.0,NAVBG11.0

    fields
    {
        field(46015542; "Excise Tax Document No."; Code[20])
        {
            Caption = 'Excise Tax Document No.';
            Description = 'NAVBG11.0,001';
        }
        field(46015544; "Excise Document Date"; Date)
        {
            Caption = 'Excise Document Date';
            Description = 'NAVBG11.0,001';
        }
        field(46015545; "Payment Obligation Type"; Code[20])
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
        field(46015605; "Registration No."; Text[20])
        {
            Caption = 'Registration No.';
            Description = 'NAVE111.0,001';
        }
        field(46015606; "Registration No. 2"; Text[20])
        {
            Caption = 'Registration No. 2';
            Description = 'NAVE111.0,001';
        }
        field(46015608; "EU 3-Party Trade"; Boolean)
        {
            Caption = 'EU 3-Party Trade';
            Description = 'NAVE111.0,001';
        }
        field(46015614; "Industry Code"; Code[20])
        {
            Caption = 'Industry Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Industry Code";
        }
        field(46015619; "EU 3-Party Intermediate Role"; Boolean)
        {
            Caption = 'EU 3-Party Intermediate Role';
            Description = 'NAVE111.0,001';
        }
        field(46015700; "Unrealized VAT"; Boolean)
        {
            Caption = 'Unrealized VAT';
            Description = 'NAVBG11.0,001';
        }
    }
    trigger OnBeforeDelete()
    var
        PostPurchDelete: Codeunit "PostPurch-Delete";
    begin
        //TODO: After adding the procedure
        //PostPurchDelete.CheckIfPurchDocDeleteAllowed("Posting Date");
    end;
}

