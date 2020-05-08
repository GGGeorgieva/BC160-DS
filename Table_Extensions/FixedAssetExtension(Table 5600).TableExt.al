tableextension 46015578 tableextension46015578 extends "Fixed Asset" 
{
    // version NAVW111.00.00.26401,NAVE111.0

    fields
    {

        //Unsupported feature: CodeInsertion on ""FA Location Code"(Field 10)". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //begin
            /*
            //NAVE111.0; 001; begin
            if LocalizationUsage.UseEastLocalization then begin
              FASetup.GET;
              if FASetup."Fixed Asset History" and
                 ("FA Location Code" <> xRec."FA Location Code") then
                ChangeEntry(FAHistory.Type::Location);
            end;
            //NAVE111.0; 001; end
            */
        //end;


        //Unsupported feature: CodeInsertion on ""Responsible Employee"(Field 16)". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //begin
            /*
            //NAVE111.0; 001; begin
            if LocalizationUsage.UseEastLocalization then begin
              FASetup.GET;
              if FASetup."Fixed Asset History" and
                 ("Responsible Employee" <> xRec."Responsible Employee") then
                ChangeEntry(FAHistory.Type::"Responsible Employee");
            end;
            //NAVE111.0; 001; end
            */
        //end;
    }
    keys
    {

        //Unsupported feature: Deletion on ""FA Posting Group"(Key)". Please convert manually.

        key(Key1;"FA Posting Group","FA Subclass Code")
        {
        }
        key(Key2;"FA Location Code","Responsible Employee")
        {
        }
        key(Key3;"Responsible Employee","FA Location Code")
        {
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
        FAHistory : Record "FA History Entry";
        OKConfirm : Boolean;
        Text46012225 : Label 'Do you want to assign new %1 %2 to Fixed Asset %3?';
        Text46012226 : Label 'Selected Fixed Asset %1 is disposed and FA Location/Responsible Employee cannot be assigned to it.';
        Text46012227 : Label 'Do you want to print FA assignment\discharge report?';

    var
        LocalizationUsage : Codeunit "Localization Usage";
}

