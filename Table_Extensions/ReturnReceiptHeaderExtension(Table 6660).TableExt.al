tableextension 46015601 "Return Receipt Header Ext." extends "Return Receipt Header"
{
    // version NAVW111.00.00.20783,NAVE111.0,NAVBG11.0

    fields
    {
        field(46015542; "Excise Tax Document No."; Code[20])
        {
            Caption = 'Excise Tax Document No.';
            Description = 'NAVBG11.0,001';
        }
        field(46015543; "Excise Charge Ground Code"; Code[20])
        {
            Caption = 'Excise Charge Ground Code';
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
        field(46015614; "Industry Code"; Code[20])
        {
            Caption = 'Industry Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Industry Code";
        }
    }
    trigger OnBeforeDelete()
    var
        PostSalesDelete: codeunit "PostSales-Delete";
    begin
        //TODO: After adding the procedure
        //PostSalesDelete.CheckIfSalesDocDeleteAllowed("Posting Date");
    end;
}

