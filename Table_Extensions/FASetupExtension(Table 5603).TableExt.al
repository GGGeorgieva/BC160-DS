tableextension 46015575 "FA Setup Extension" extends "FA Setup"
{
    // version NAVW111.00,NAVE111.0

    fields
    {
        field(46015633; "Fixed Asset History"; Boolean)
        {
            Caption = 'Fixed Asset History';
            Description = 'NAVE111.0,001';
            //TODO
            /*
            trigger OnValidate();
            var
                InitFAHistory : Report "Initialize FA History";
            begin
                if "Fixed Asset History" then begin
                  CLEAR(InitFAHistory);
                  InitFAHistory.RUNMODAL;
                end;
            end;
            */
        }
    }

}

