table 46015606 "Stat. Reporting Setup"
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

    Caption = 'Stat. Reporting Setup';

    fields
    {
        field(1;"Primary Key";Code[10])
        {
            Caption = 'Primary Key';
        }
        field(27;"Tax Office Number";Code[20])
        {
            Caption = 'Tax Office Number';
        }
        field(40;"Municipality No.";Text[30])
        {
            Caption = 'Municipality No.';
        }
        field(41;Street;Text[50])
        {
            Caption = 'Street';
        }
        field(42;"House No.";Text[30])
        {
            Caption = 'House No.';
        }
        field(43;"Apartment No.";Text[30])
        {
            Caption = 'Apartment No.';
        }
        field(51;"VIES Decl. Auth. Employee No.";Code[20])
        {
            Caption = 'VIES Decl. Auth. Employee No.';
            TableRelation = "Company Officials";
        }
        field(52;"VIES Decl. Filled by Empl. No.";Code[20])
        {
            Caption = 'VIES Decl. Filled by Empl. No.';
            TableRelation = "Company Officials";
        }
        field(54;"VIES Decl. Exp. Obj. Type";Option)
        {
            Caption = 'VIES Decl. Exp. Obj. Type';
            OptionCaption = ',,,Report,,Codeunit';
            OptionMembers = ,,,"Report",,"Codeunit";

            trigger OnValidate();
            begin
                if xRec."VIES Decl. Exp. Obj. Type" <> "VIES Decl. Exp. Obj. Type" then
                  VALIDATE("VIES Decl. Exp. Obj. No.",0);
            end;
        }
        field(55;"VIES Declaration Nos.";Code[10])
        {
            Caption = 'VIES Declaration Nos.';
            TableRelation = "No. Series";
        }
        field(56;"VIES Declaration Report No.";Integer)
        {
            Caption = 'VIES Declaration Report No.';
            TableRelation = Object.ID WHERE (Type=CONST(Report));

            trigger OnValidate();
            begin
                CALCFIELDS("VIES Declaration Report Name");
            end;
        }
        field(57;"VIES Declaration Report Name";Text[30])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE ("Object Type"=CONST(Report),
                                                                           "Object ID"=FIELD("VIES Declaration Report No.")));
            Caption = 'VIES Declaration Report Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(58;"VIES Decl. Exp. Obj. No.";Integer)
        {
            Caption = 'VIES Decl. Exp. Obj. No.';
            TableRelation = Object.ID WHERE (Type=FIELD("VIES Decl. Exp. Obj. Type"));

            trigger OnValidate();
            begin
                CALCFIELDS("VIES Decl. Exp. Obj. Name");
            end;
        }
        field(59;"VIES Decl. Exp. Obj. Name";Text[30])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE ("Object Type"=FIELD("VIES Decl. Exp. Obj. Type"),
                                                                           "Object ID"=FIELD("VIES Decl. Exp. Obj. No.")));
            Caption = 'VIES Decl. Exp. Obj. Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60;"Transaction Type Mandatory";Boolean)
        {
            Caption = 'Transaction Type Mandatory';
        }
        field(61;"Transaction Spec. Mandatory";Boolean)
        {
            Caption = 'Transaction Spec. Mandatory';
        }
        field(62;"Transport Method Mandatory";Boolean)
        {
            Caption = 'Transport Method Mandatory';
        }
        field(63;"Shipment Method Mandatory";Boolean)
        {
            Caption = 'Shipment Method Mandatory';
        }
        field(64;"Tariff No. Mandatory";Boolean)
        {
            Caption = 'Tariff No. Mandatory';
        }
        field(65;"Net Weight Mandatory";Boolean)
        {
            Caption = 'Net Weight Mandatory';
        }
        field(66;"Country/Region of Origin Mand.";Boolean)
        {
            Caption = 'Country/Region of Origin Mand.';
        }
        field(67;"Get Tariff No. From";Option)
        {
            Caption = 'Get Tariff No. From';
            OptionCaption = 'Posted Entries,Item Card';
            OptionMembers = "Posted Entries","Item Card";
        }
        field(68;"Get Net Weight From";Option)
        {
            Caption = 'Get Net Weight From';
            OptionCaption = 'Posted Entries,Item Card';
            OptionMembers = "Posted Entries","Item Card";
        }
        field(69;"Get Country/Region of Origin";Option)
        {
            Caption = 'Get Country/Region of Origin';
            OptionCaption = 'Posted Entries,Item Card';
            OptionMembers = "Posted Entries","Item Card";
        }
        field(70;"Intrastat Rounding Type";Option)
        {
            Caption = 'Intrastat Rounding Type';
            OptionCaption = 'Nearest,Up,Down';
            OptionMembers = Nearest,Up,Down;
        }
        field(71;"No Item Charges in Intrastat";Boolean)
        {
            Caption = 'No Item Charges in Intrastat';

            trigger OnValidate();
            begin
                ItemCharge.RESET;
                ItemCharge.SETRANGE("Incl. in Intrastat Amount",true);
                if ItemCharge.FINDFIRST then
                  ERROR(Text26500,
                    FIELDCAPTION("No Item Charges in Intrastat"),
                    ItemCharge.TABLECAPTION,ItemCharge.FIELDCAPTION("Incl. in Intrastat Amount"));

                ItemCharge.RESET;
                ItemCharge.SETRANGE("Incl. in Intrastat Stat. Value",true);
                if ItemCharge.FINDFIRST then
                  ERROR(Text26500,
                    FIELDCAPTION("No Item Charges in Intrastat"),
                    ItemCharge.TABLECAPTION,ItemCharge.FIELDCAPTION("Incl. in Intrastat Stat. Value"));
            end;
        }
    }

    keys
    {
        key(Key1;"Primary Key")
        {
        }
    }

    fieldgroups
    {
    }

    var
        ItemCharge : Record "Item Charge";
        Text26500 : Label 'You cannot uncheck %1 until you have %2 with checked field %3.';
}

