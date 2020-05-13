tableextension 46015576 "Contact Extension" extends Contact
{
    // version NAVW111.00.00.27667,NAVE111.0
    fields
    {
        modify(Type)
        {
            trigger OnBeforeValidate()
            begin
                IF (CurrFieldNo <> 0) AND ("No." <> '') THEN
                    CASE Type OF
                        Type::Person:
                            begin
                                TESTFIELD("Registration No.", '');
                                TESTFIELD("Registration No. 2", '');
                            end;
                    end;
            end;
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
    }
    trigger OnAfterModify()
    begin
        if ("Registration No." <> xRec."Registration No.") or
           ("Registration No. 2" <> xRec."Registration No. 2")
          then
            CheckDuplLoc;
    end;

    trigger OnAfterInsert()
    begin
        CASE Type OF
            Type::Person:
                begin
                    TESTFIELD("Registration No.", '');
                    TESTFIELD("Registration No. 2", '');
                end;
        end;
    end;

    procedure CheckDuplLoc()
    var
        RMSetup: Record "Marketing Setup";
        DuplMgt: Codeunit DuplicateManagement;
    begin
        RMSetup.GET;
        IF RMSetup."Maintain Dupl. Search Strings" THEN
            DuplMgt.MakeContIndex(Rec);
        IF GUIALLOWED THEN
            IF DuplMgt.DuplicateExist(Rec) THEN BEGIN
                MODIFY;
                COMMIT;
                DuplMgt.LaunchDuplicateForm(Rec);
            END;
    end;

}

