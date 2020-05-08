tableextension 46015576 "Contact Extension" extends Contact
{
    // version NAVW111.00.00.27667,NAVE111.0

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
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
        LocalizationUsage: Codeunit "Localization Usage";
}

