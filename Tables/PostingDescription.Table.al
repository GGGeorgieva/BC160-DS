table 46015629 "Posting Description"
{
    // version NAVE18.00

    // -----------------------------------------------------------------------------------------
    // XAPT Solutions
    // MS Dynamics NAV 2015 Localisation
    // 
    // mp  : Mile Petachki
    // version : NAVE18.00
    // 
    // -----------------------------------------------------------------------------------------
    // No.   Sign     Date       Version        Description
    // -----------------------------------------------------------------------------------------
    // 001   mp       27.10.14   NAVE18.00      Created table from MS Dynamics NAV 6.00
    // ------------------------------------------------------------------------------------------

    Caption = 'Posting Description';
    //DrillDownPageID = "Posting Descriptions";
    //LookupPageID = "Posting Descriptions";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(3; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Sales Document,Purchase Document,Post Inventory Cost,Finance Charge,Service Document';
            OptionMembers = "Sales Document","Purchase Document","Post Inventory Cost","Finance Charge","Service Document";

            trigger OnValidate();
            begin
                if (Code <> '') and (Type <> xRec.Type) then begin
                    PostDescriptionParams.RESET;
                    PostDescriptionParams.SETRANGE("Posting Desc. Code", Code);
                    PostDescriptionParams.DELETEALL;
                end;
            end;
        }
        field(4; "Posting Description Formula"; Text[50])
        {
            Caption = 'Posting Description Formula';
        }
        field(5; "Validate on Posting"; Boolean)
        {
            Caption = 'Validate on Posting';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        PostDescriptionParams.RESET;
        PostDescriptionParams.SETRANGE("Posting Desc. Code", Code);
        PostDescriptionParams.DELETEALL;
    end;

    var
        PostDescriptionParams: Record "Posting Desc. Parameter";

    procedure ParsePostDescString(PostDescription: Record "Posting Description"; RecordReference: RecordRef): Text[50];
    var
        "Field": Record "Field";
        FieldReference: FieldRef;
        ParamNo: Integer;
        SubStrPosition: Integer;
        ParamValue: Text[50];
        ParseLine: Text[1024];
        SubStr: Text[30];
        SpcChar: Char;
    begin
        PostDescription.TESTFIELD("Posting Description Formula");
        ParseLine := PostDescription."Posting Description Formula";
        SpcChar := 1;

        for ParamNo := 1 to 9 do begin
            SubStr := '%' + FORMAT(ParamNo);
            if PostDescriptionParams.GET(PostDescription.Code, ParamNo) and
               (STRPOS(ParseLine, SubStr) > 0)
            then begin
                SubStrPosition := STRPOS(ParseLine, SubStr);
                if PostDescriptionParams.Type <> PostDescriptionParams.Type::Constant then begin
                    FieldReference := RecordReference.FIELD(PostDescriptionParams."Field No.");
                    EVALUATE(Field.Type, FORMAT(FieldReference.TYPE));
                end;
                repeat
                    ParseLine := DELSTR(ParseLine, SubStrPosition, STRLEN(SubStr));
                    case PostDescriptionParams.Type of
                        PostDescriptionParams.Type::Value:
                            begin
                                if Field.Type = Field.Type::Option then
                                    ParamValue := GetSelectedOption(FieldReference)
                                else
                                    ParamValue := COPYSTR(FORMAT(FieldReference.VALUE), 1, MAXSTRLEN(ParamValue));
                            end;
                        PostDescriptionParams.Type::Caption:
                            ParamValue := COPYSTR(FORMAT(FieldReference.CAPTION), 1, MAXSTRLEN(ParamValue));
                        PostDescriptionParams.Type::Constant:
                            ParamValue := COPYSTR(FORMAT(PostDescriptionParams."Field Name"), 1, MAXSTRLEN(ParamValue));
                    end;
                    ParamValue := CONVERTSTR(ParamValue, '%', FORMAT(SpcChar));
                    ParseLine := INSSTR(ParseLine, ParamValue, SubStrPosition);
                    SubStrPosition := STRPOS(ParseLine, SubStr);
                until (SubStrPosition = 0);
            end;
        end;
        ParseLine := CONVERTSTR(ParseLine, FORMAT(SpcChar), '%');
        exit(COPYSTR(ParseLine, 1, 50));
    end;

    procedure GetSelectedOption(FieldReference: FieldRef): Text[50];
    var
        SelectedOptionNo: Option;
        OptionNo: Option;
        OptionString: Text[1024];
        CurrOptionString: Text[1024];
    begin
        OptionString := FieldReference.OPTIONCAPTION;
        SelectedOptionNo := FieldReference.VALUE;
        while OptionString <> '' do begin
            if STRPOS(OptionString, ',') = 0 then begin
                CurrOptionString := OptionString;
                OptionString := '';
            end else begin
                CurrOptionString := COPYSTR(OptionString, 1, STRPOS(OptionString, ',') - 1);
                OptionString := COPYSTR(OptionString, STRPOS(OptionString, ',') + 1);
            end;
            if OptionNo = SelectedOptionNo then
                exit(COPYSTR(CurrOptionString, 1, 50));
            OptionNo := OptionNo + 1;
        end;
    end;
}

