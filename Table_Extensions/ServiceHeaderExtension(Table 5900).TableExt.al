tableextension 46015592 tableextension46015592 extends "Service Header" 
{
    // version NAVW111.00.00.27667,NAVE111.0.001,NAVBG11.0

    fields
    {

        //Unsupported feature: CodeInsertion on ""Customer Posting Group"(Field 31)". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        var
            ServiceMgmtSetup : Record "Service Mgt. Setup";
            SubstCustPostingGrp : Record "Subst. Customer Posting Group";
        //begin
            /*
            //NAVE111.0.001; 001; begin
            if LocalizationUsage.UseEastLocalization then
              if (CurrFieldNo = FIELDNO("Customer Posting Group")) and
                 ("Customer Posting Group" <> xRec."Customer Posting Group")
              then begin
                ServiceMgmtSetup.GET;
                if ServiceMgmtSetup."Allow Alter Cust. Post. Groups" then begin
                  if not SubstCustPostingGrp.GET(xRec."Customer Posting Group","Customer Posting Group") then
                    ERROR(Text46012225,xRec."Customer Posting Group","Customer Posting Group",SubstCustPostingGrp.TABLECAPTION);
                end else
                  ERROR(Text46012226,FIELDCAPTION("Customer Posting Group"),ServiceMgmtSetup.FIELDCAPTION("Allow Alter Cust. Post. Groups"));
              end;
            //NAVE111.0.001; 001; end
            */
        //end;
        field(46015605;"Registration No.";Text[20])
        {
            Caption = 'Registration No.';
            Description = 'NAVE111.0,001';
        }
        field(46015606;"Registration No. 2";Text[20])
        {
            Caption = 'Registration No. 2';
            Description = 'NAVE111.0,001';
        }
        field(46015610;"VAT Date";Date)
        {
            Caption = 'VAT Date';
            Description = 'NAVE111.0,001';

            trigger OnValidate();
            begin
                GLSetup.GET;
                if not GLSetup."Use VAT Date" then
                  TESTFIELD("VAT Date","Posting Date");
                if "VAT Date" <> xRec."VAT Date" then
                  UpdateServLines(FIELDCAPTION("VAT Date"),false);
            end;
        }
        field(46015611;"Postponed VAT";Boolean)
        {
            Caption = 'Postponed VAT';
            Description = 'NAVE111.0,001';
        }
        field(46015630;"Posting Desc. Code";Code[10])
        {
            Caption = 'Posting Desc. Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Posting Description" WHERE (Type=CONST("Service Document"));

            trigger OnValidate();
            begin
                GetPostingDescription("Posting Desc. Code","Posting Description");
            end;
        }
    }


    //Unsupported feature: CodeModification on "OnInsert". Please convert manually.

    //trigger OnInsert();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        ServSetup.GET ;
        if "No." = '' then begin
          TestNoSeries;
        #4..26
        if GETFILTER("Contact No.") <> '' then
          if GETRANGEMIN("Contact No.") = GETRANGEMAX("Contact No.") then
            VALIDATE("Contact No.",GETRANGEMIN("Contact No."));
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..29

        //NAVE111.0; 001; begin
        if LocalizationUsage.UseEastLocalization then
          VALIDATE("Posting Desc. Code",ServSetup."Posting Desc. Code");
        //NAVE111.0; 001; ends
        */
    //end;


    //Unsupported feature: CodeModification on "OnModify". Please convert manually.

    //trigger OnModify();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        UpdateServiceOrderChangeLog(xRec);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        UpdateServiceOrderChangeLog(xRec);

        //NAVE111.0; 001; begin
        if LocalizationUsage.UseEastLocalization then
          VALIDATE("Posting Desc. Code");
        //NAVE111.0; 001; end
        */
    //end;

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
        LocalizationUsage : Codeunit "Localization Usage";
        Text46012225 : Label 'You cannot change the %1 to %2 because %3 has not been filled in.';
        Text46012226 : Label 'You cannot change %1 until %2 will be checked in setup.';
}

