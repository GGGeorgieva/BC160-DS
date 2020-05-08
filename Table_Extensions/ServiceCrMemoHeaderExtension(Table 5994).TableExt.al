tableextension 46015600 "Service Cr.Memo Header Ext." extends "Service Cr.Memo Header"
{
    // version NAVW111.00.00.23019,NAVE111.0

    fields
    {
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
        field(46015610; "VAT Date"; Date)
        {
            Caption = 'VAT Date';
            Description = 'NAVE111.0,001';
        }
        field(46015611; "Postponed VAT"; Boolean)
        {
            Caption = 'Postponed VAT';
            Description = 'NAVE111.0,001';
            Editable = false;
        }
        field(46015618; "Postponed VAT Realized"; Boolean)
        {
            Caption = 'Postponed VAT Realized';
            Description = 'NAVE111.0,001';
            Editable = false;
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
        Text46012229: Label 'VAT Date %1 is not within your range of allowed VAT dates.\';
        Text46012230: Label 'Correct the date or change VAT posting period.';
}

