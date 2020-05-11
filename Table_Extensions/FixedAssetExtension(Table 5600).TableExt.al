tableextension 46015578 "Fixed Asset Extension" extends "Fixed Asset"
{
    // version NAVW111.00.00.26401,NAVE111.0

    fields
    {
        modify("FA Location Code")
        {
            trigger OnBeforeValidate()
            var
                FASetup: Record "FA Setup";
            begin
                FASetup.GET;
                if FASetup."Fixed Asset History" and
                    ("FA Location Code" <> xRec."FA Location Code") then
                    ChangeEntry(FAHistory.Type::Location);
            end;
        }

        modify("Responsible Employee")
        {
            trigger OnBeforeValidate()
            var
                FASetup: Record "FA Setup";
            begin
                FASetup.GET;
                if FASetup."Fixed Asset History" and
                    ("Responsible Employee" <> xRec."Responsible Employee") then
                    ChangeEntry(FAHistory.Type::"Responsible Employee");
            end;
        }

    }
    keys
    {

        //Unsupported feature: Deletion on ""FA Posting Group"(Key)". Please convert manually.

        //TODO
        /*
        key(Key1;"FA Posting Group","FA Subclass Code")
        {
        }
        key(Key2;"FA Location Code","Responsible Employee")
        {
        }
        key(Key3;"Responsible Employee","FA Location Code")
        {
        }
        */
    }

    var
        FAHistory: Record "FA History Entry";
        OKConfirm: Boolean;
        Text46012225: Label 'Do you want to assign new %1 %2 to Fixed Asset %3?';
        Text46012226: Label 'Selected Fixed Asset %1 is disposed and FA Location/Responsible Employee cannot be assigned to it.';
        Text46012227: Label 'Do you want to print FA assignment\discharge report?';

    procedure ChangeEntry(ChangeType: Option Location,"Responsible Employee");
    var
        OldValue: Code[20];
        NewValue: Code[20];
        FADeprBook: Record "FA Depreciation Book";
        FASetup: Record "FA Setup";
    begin
        if Inactive then
            ERROR(Text46012226, "No.");

        FASetup.GET;
        FADeprBook.SETRANGE("FA No.", "No.");
        FADeprBook.SETRANGE("Depreciation Book Code", FASetup."Default Depr. Book");
        if FADeprBook.FINDLAST then
            if FADeprBook."Disposal Date" > 0D then
                ERROR(Text46012226, "No.");

        OKConfirm := true;
        if GUIALLOWED and (CurrFieldNo <> 0) then begin
            if ChangeType = ChangeType::Location then
                OKConfirm := CONFIRM(Text46012225, true, FIELDCAPTION("FA Location Code"), "FA Location Code", "No.")
            else
                OKConfirm := CONFIRM(Text46012225, true, FIELDCAPTION("Responsible Employee"), "Responsible Employee", "No.");
        end;
        if OKConfirm then begin
            case ChangeType of
                ChangeType::Location:
                    begin
                        OldValue := xRec."FA Location Code";
                        NewValue := "FA Location Code";
                    end;
                ChangeType::"Responsible Employee":
                    begin
                        OldValue := xRec."Responsible Employee";
                        NewValue := "Responsible Employee";
                    end;
            end;

            FAHistory.InsertEntry(ChangeType, "No.", OldValue, NewValue, 0, false);

        end else begin
            if ChangeType = ChangeType::Location then
                "FA Location Code" := xRec."FA Location Code"
            else
                "Responsible Employee" := xRec."Responsible Employee";
        end;
    end;

    procedure PrintAssignmentAndDischarge();
    begin
        //TODO
        /*      
          if CONFIRM(Text46012227) then begin

            FAHistory.RESET;
            FAHistory.SETRANGE("FA No.","No.");
            REPORT.RUN(REPORT::"FA Assignment/Discharge",true,false,FAHistory);
          end;
        */
    END;

}

