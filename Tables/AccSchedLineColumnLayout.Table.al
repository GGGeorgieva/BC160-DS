table 46015510 "Acc. Sched. Line Column Layout"
{
    // version NAVBG8.00

    // -----------------------------------------------------------------------------------------
    // XAPT Solutions
    // MS Dynamics NAV 2015 Localisation
    // 
    // mp  : Mile Petachki
    // version : NAVBG8.00
    // 
    // -----------------------------------------------------------------------------------------
    // No.   Sign     Date       Version        Description
    // -----------------------------------------------------------------------------------------
    // 001   mp       27.10.14   NAVBG8.00      Created table from MS Dynamics NAV 6.00
    // ------------------------------------------------------------------------------------------

    Caption = 'Acc. Sched. Line Column Layout';
    //DrillDownPageID = 46012126;
    //LookupPageID = 46012126;

    fields
    {
        field(1; "Column Layout Name"; Code[10])
        {
            Caption = 'Column Layout Name';
            TableRelation = "Column Layout Name";
        }
        field(2; "Column Line No."; Integer)
        {
            Caption = 'Column Line No.';
            TableRelation = "Column Layout"."Line No." WHERE("Column Layout Name" = FIELD("Column Layout Name"));

            trigger OnValidate();
            var
                ColumnLayout: Record "Column Layout";
            begin
                ColumnLayout.GET("Column Layout Name", "Column Line No.");

                TRANSFERFIELDS(ColumnLayout);
            end;
        }
        field(3; "Column No."; Code[10])
        {
            Caption = 'Column No.';

            trigger OnLookup();
            var
                ColumnLayout: Record "Column Layout";
            begin
                ColumnLayout.SETRANGE("Column Layout Name", "Column Layout Name");

                if PAGE.RUNMODAL(489, ColumnLayout) = ACTION::LookupOK then
                    VALIDATE("Column Line No.", ColumnLayout."Line No.");
            end;
        }
        field(4; "Column Header"; Text[30])
        {
            Caption = 'Column Header';
        }
        field(5; "Column Layout"; Option)
        {
            Caption = 'Column Layout';
            InitValue = "Net Change";
            OptionCaption = 'Formula,Net Change,Balance To Date,Beginning Balance,From the Beginning of the Year,to the End of the Fiscal Year,Whole Fiscal Year';
            OptionMembers = Formula,"Net Change","Balance To Date","Beginning Balance","From the Beginning of the Year","to the End of the Fiscal Year","Whole Fiscal Year";
        }
        field(6; "Ledger Entry Type"; Option)
        {
            Caption = 'Ledger Entry Type';
            OptionCaption = 'G/L Entries,Budget G/L Entries';
            OptionMembers = "G/L Entries","Budget G/L Entries";
        }
        field(7; "Amount Type"; Option)
        {
            Caption = 'Amount Type';
            OptionCaption = 'Net Amount,Debit Amount,Credit Amount';
            OptionMembers = "Net Amount","Debit Amount","Credit Amount";
        }
        field(8; Formula; Code[80])
        {
            Caption = 'Formula';

            trigger OnValidate();
            begin
                AccSchedLine.CheckFormula(Formula);
            end;
        }
        field(9; "Comparison Date Formula"; DateFormula)
        {
            Caption = 'Comparison Date Formula';
        }
        field(10; "Show Opposite Sign"; Boolean)
        {
            Caption = 'Show Opposite Sign';
        }
        field(11; Show; Option)
        {
            Caption = 'Show';
            InitValue = Always;
            NotBlank = true;
            OptionCaption = 'Always,Never,When Positive,When Negative';
            OptionMembers = Always,Never,"When Positive","When Negative";
        }
        field(12; "Rounding Factor"; Option)
        {
            Caption = 'Rounding Factor';
            OptionCaption = 'None,1,1000,1000000';
            OptionMembers = "None","1","1000","1000000";
        }
        field(13; "Include Closing Date"; Boolean)
        {
            Caption = 'Include Closing Date';
        }
        field(14; "Comparison Period Formula"; Code[20])
        {
            Caption = 'Comparison Period Formula';

            trigger OnValidate();
            var
                Steps: Integer;
                Type: Option " ",Period,"Fiscal year","Fiscal Halfyear","Fiscal Quarter";
                RangeFromType: Option Int,CP,LP;
                RangeToType: Option Int,CP,LP;
                RangeFromInt: Integer;
                RangeToInt: Integer;
            begin
                ParsePeriodFormula(
                  "Comparison Period Formula",
                  Steps, Type, RangeFromType, RangeToType, RangeFromInt, RangeToInt);
                if "Comparison Period Formula" <> '' then
                    CLEAR("Comparison Date Formula");
            end;
        }
        field(46012166; "Schedule Name"; Code[10])
        {
            Caption = 'Schedule Name';
        }
        field(46012167; "Schedule Line No."; Integer)
        {
            Caption = 'Schedule Line No.';
        }
        field(46012168; "Schedule Row No."; Code[20])
        {
            CalcFormula = Lookup ("Acc. Schedule Line"."Row No." WHERE("Schedule Name" = FIELD("Schedule Name"),
                                                                       "Line No." = FIELD("Schedule Line No.")));
            Caption = 'Schedule Row No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(46012169; Disabled; Boolean)
        {
            Caption = 'Disabled';
            InitValue = false;
        }
    }

    keys
    {
        key(Key1; "Schedule Name", "Schedule Line No.", "Column Layout Name", "Column Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        AccSchedLine: Record "Acc. Schedule Line" temporary;
        Text001: Label '%1 is not a valid Period Formula';
        Text002: Label 'P';
        Text003: Label 'FY';
        Text004: Label 'CP';
        Text005: Label 'LP';

    procedure ParsePeriodFormula(Formula: Code[20]; var Steps: Integer; var Type: Option " ",Period,"Fiscal Year"; var RangeFromType: Option Int,CP,LP; var RangeToType: Option Int,CP,LP; var RangeFromInt: Integer; var RangeToInt: Integer);
    var
        OriginalFormula: Code[20];
    begin
        // <PeriodFormula> ::= <signed integer> <formula> | blank
        // <signed integer> ::= <sign> <positive integer> | blank
        // <sign> ::= + | - | blank
        // <positive integer> ::= <digit 1-9> <digits>
        // <digit 1-9> ::= 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
        // <digits> ::= 0 <digits> | <digit 1-9> <digits> | blank
        // <formula> ::= P | FY <range> | FH <range> | FQ <range>
        // <range> ::= blank | [<range2>]
        // <range2> ::= <index> .. <index> | <index>
        // <index> ::= <positive integer> | CP | LP

        OriginalFormula := Formula;
        Formula := DELCHR(Formula);

        if not ParseFormula(Formula, Steps, Type) then
            ERROR(Text001, OriginalFormula);

        if Type = Type::"Fiscal Year" then
            if not ParseRange(Formula, RangeFromType, RangeFromInt, RangeToType, RangeToInt) then
                ERROR(Text001, OriginalFormula);

        if Formula <> '' then
            ERROR(Text001, OriginalFormula);
    end;

    local procedure ParseFormula(var Formula: Code[20]; var Steps: Integer; var Type: Option " ",Period,"Fiscal year","Fiscal Halfyear","Fiscal Quarter"): Boolean;
    begin
        Steps := 0;
        Type := Type::" ";

        if Formula = '' then
            exit(true);

        if not ParseSignedInteger(Formula, Steps) then
            exit(false);

        if Formula = '' then
            exit(false);

        if not ParseType(Formula, Type) then
            exit(false);

        exit(true);
    end;

    local procedure ParseSignedInteger(var Formula: Code[20]; var Int: Integer): Boolean;
    begin
        Int := 0;

        case COPYSTR(Formula, 1, 1) of
            '-':
                begin
                    Formula := COPYSTR(Formula, 2);
                    if not ParseInt(Formula, Int, false) then
                        exit(false);
                    Int := -Int;
                end;
            '+':
                begin
                    Formula := COPYSTR(Formula, 2);
                    if not ParseInt(Formula, Int, false) then
                        exit(false);
                end;
            else begin
                    if not ParseInt(Formula, Int, true) then
                        exit(false);
                end;
        end;
        exit(true);
    end;

    local procedure ParseInt(var Formula: Code[20]; var Int: Integer; AllowNotInt: Boolean): Boolean;
    var
        IntegerStr: Code[20];
    begin
        if COPYSTR(Formula, 1, 1) in ['1' .. '9'] then
            repeat
                IntegerStr := IntegerStr + COPYSTR(Formula, 1, 1);
                Formula := COPYSTR(Formula, 2);
                if Formula = '' then
                    exit(false);
            until not (COPYSTR(Formula, 1, 1) in ['0' .. '9'])
        else
            exit(AllowNotInt);
        EVALUATE(Int, IntegerStr);
        exit(true);
    end;

    local procedure ParseType(var Formula: Code[20]; var Type: Option " ",Period,"Fiscal Year"): Boolean;
    begin
        case ReadToken(Formula) of
            Text002:
                Type := Type::Period;
            Text003:
                Type := Type::"Fiscal Year";
            else
                exit(false);
        end;
        exit(true);
    end;

    local procedure ParseRange(var Formula: Code[20]; var FromType: Option Int,CP,LP; var FromInt: Integer; var ToType: Option Int,CP,LP; var ToInt: Integer): Boolean;
    begin
        FromType := FromType::CP;
        ToType := ToType::CP;

        if Formula = '' then
            exit(true);

        if not ParseToken(Formula, '[') then
            exit(false);

        if not ParseIndex(Formula, FromType, FromInt) then
            exit(false);
        if Formula = '' then
            exit(false);

        if COPYSTR(Formula, 1, 1) = '.' then begin
            if not ParseToken(Formula, '..') then
                exit(false);
            if not ParseIndex(Formula, ToType, ToInt) then
                exit(false);
        end else begin
            ToType := FromType;
            ToInt := FromInt;
        end;

        if not ParseToken(Formula, ']') then
            exit(false);

        exit(true);
    end;

    local procedure ParseIndex(var Formula: Code[20]; var IndexType: Option Int,CP,LP; var Index: Integer): Boolean;
    begin
        if Formula = '' then
            exit(false);

        if ParseInt(Formula, Index, false) then
            IndexType := IndexType::Int
        else
            case ReadToken(Formula) of
                Text004:
                    IndexType := IndexType::CP;
                Text005:
                    IndexType := IndexType::LP;
                else
                    exit(false);
            end;

        exit(true);
    end;

    local procedure ParseToken(var Formula: Code[20]; Token: Code[20]): Boolean;
    begin
        if COPYSTR(Formula, 1, STRLEN(Token)) <> Token then
            exit(false);
        Formula := COPYSTR(Formula, STRLEN(Token) + 1);
        exit(true)
    end;

    local procedure ReadToken(var Formula: Code[20]): Code[20];
    var
        Token: Code[20];
        p: Integer;
    begin
        for p := 1 to STRLEN(Formula) do begin
            if COPYSTR(Formula, p, 1) in ['[', ']', '.'] then begin
                Formula := COPYSTR(Formula, STRLEN(Token) + 1);
                exit(Token);
            end;
            Token := Token + COPYSTR(Formula, p, 1);
        end;

        Formula := '';
        exit(Token);
    end;
}

