table 46015630 "Posting Desc. Parameter"
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

    Caption = 'Posting Desc. Parameter';

    fields
    {
        field(1; "Posting Desc. Code"; Code[10])
        {
            Caption = 'Posting Desc. Code';
            TableRelation = "Posting Description";
        }
        field(2; "No."; Integer)
        {
            Caption = 'No.';
            InitValue = 1;
            MaxValue = 9;
            MinValue = 1;
        }
        field(3; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Caption,Value,Constant';
            OptionMembers = Caption,Value,Constant;
        }
        field(4; "Field No."; Integer)
        {
            Caption = 'Field No.';
        }
        field(5; "Field Name"; Text[30])
        {
            Caption = 'Field Name';

            trigger OnLookup();
            var
            //TODO MISSING Page "Field List";
            // FieldList : Page "Field List";
            begin
                /* if Type <> Type::Constant then begin
                   SetFieldRange;
                   FieldList.SETTABLEVIEW(Field);
                   FieldList.SETRECORD(Field);
                   FieldList.EDITABLE(false);
                   FieldList.LOOKUPMODE := true;
                   if FieldList.RUNMODAL = ACTION::LookupOK then begin
                     FieldList.GETRECORD(Field);
                     "Field No." := Field."No.";
                     "Field Name" := Field.FieldName;
                   end;
                 end;
                 */
            end;


            trigger OnValidate();
            begin
                TESTFIELD("Field Name");

                if Type <> Type::Constant then begin
                    SetFieldRange;
                    Field.SETFILTER(FieldName, '@' + "Field Name" + '*');
                    if Field.FINDFIRST then begin
                        "Field No." := Field."No.";
                        "Field Name" := Field.FieldName;
                    end else
                        ERROR(Text001, "Field Name");
                end;
            end;
        }
    }

    keys
    {
        key(Key1; "Posting Desc. Code", "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        TESTFIELD("Field Name");
    end;

    var
        Text001: Label 'Field %1 is not found.';
        "Field": Record "Field";

    procedure SetFieldRange();
    var
        PostDescription: Record "Posting Description";
    begin
        Field.RESET;
        PostDescription.GET("Posting Desc. Code");
        case PostDescription.Type of
            PostDescription.Type::"Sales Document":
                Field.SETRANGE(TableNo, DATABASE::"Sales Header");
            PostDescription.Type::"Purchase Document":
                Field.SETRANGE(TableNo, DATABASE::"Purchase Header");
            PostDescription.Type::"Post Inventory Cost":
                Field.SETRANGE(TableNo, DATABASE::"Value Entry");
            PostDescription.Type::"Finance Charge":
                Field.SETRANGE(TableNo, DATABASE::"Finance Charge Memo Header");
            PostDescription.Type::"Service Document":
                Field.SETRANGE(TableNo, DATABASE::"Service Header");
        end;
    end;
}

