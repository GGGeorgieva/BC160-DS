tableextension 46015615 "Acc. Schedule Line Extension" extends "Acc. Schedule Line"
{
    // version NAVW111.00,NAVE111.0

    fields
    {
        modify(Totaling)
        {
            trigger OnBeforeValidate()
            var
                Value: Decimal;
            begin
                case "Totaling Type" of
                    "Totaling Type"::Constant:
                        if (Totaling <> '') then
                            EVALUATE(Value, Totaling);
                end;

                CLEAR(AccSchedManagementExtension);
                if "Totaling Type" <> "Totaling Type"::Custom then
                    AccSchedManagementExtension.ValidateFormula(Rec);
            end;

        }
        modify("Totaling Type")
        {
            trigger OnBeforeValidate()
            begin
                If (xRec."Totaling Type" = "Totaling Type"::Formula) and ("Totaling Type" <> "Totaling Type"::Formula) then
                    Totaling := '';
            end;
        }
        field(46015605; "Source Table"; Option)
        {
            Caption = 'Source Table';
            Description = 'NAVE111.0,001';
            OptionCaption = '" ,VAT Entry,Value Entry,Customer Entry,Vendor Entry"';
            OptionMembers = " ","VAT Entry","Value Entry","Customer Entry","Vendor Entry";
        }

    }
    var
        AccSchedManagementExtension: Codeunit AccScheduleMangementExtension;

}

