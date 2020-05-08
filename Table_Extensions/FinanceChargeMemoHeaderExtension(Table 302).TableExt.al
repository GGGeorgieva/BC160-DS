tableextension 46015548 tableextension46015548 extends "Finance Charge Memo Header" 
{
    // version NAVW111.00.00.27667,NAVE111.0

    fields
    {

        //Unsupported feature: CodeModification on ""Customer No."(Field 2).OnValidate". Please convert manually.

        //trigger "(Field 2)();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            if CurrFieldNo = FIELDNO("Customer No.") then
              if Undo then begin
                "Customer No." := xRec."Customer No.";
            #4..19
            "Shortcut Dimension 1 Code" := Cust."Global Dimension 1 Code";
            "Shortcut Dimension 2 Code" := Cust."Global Dimension 2 Code";
            "VAT Registration No." := Cust."VAT Registration No.";
            Cust.TESTFIELD("Customer Posting Group");
            "Customer Posting Group" := Cust."Customer Posting Group";
            "Gen. Bus. Posting Group" := Cust."Gen. Bus. Posting Group";
            "VAT Bus. Posting Group" := Cust."VAT Bus. Posting Group";
            "Tax Area Code" := Cust."Tax Area Code";
            "Tax Liable" := Cust."Tax Liable";
            VALIDATE("Fin. Charge Terms Code",Cust."Fin. Charge Terms Code");

            CreateDim(DATABASE::Customer,"Customer No.");
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..22

            //NAVE111.0; 001; begin
            if LocalizationUsage.UseEastLocalization then begin
              "Registration No." := Cust."Registration No.";
              "Registration No. 2" := Cust."Registration No. 2";
            end;
            //NAVE111.0; 001; end

            #23..30
            //NAVE111.0; 001; begin
            if LocalizationUsage.UseEastLocalization then
              UpdateBankInfo;
            //NAVE111.0; 001; end

            CreateDim(DATABASE::Customer,"Customer No.");
            */
        //end;


        //Unsupported feature: CodeInsertion on ""Customer Posting Group"(Field 17)". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //begin
            /*
            //NAVE111.0; 001; begin
            if LocalizationUsage.UseEastLocalization then
              if CurrFieldNo = FIELDNO("Customer Posting Group") then begin
                SalesSetup.GET;
                if SalesSetup."Allow Alter Posting Groups" then begin
                  if not SubstCustPostingGrp.GET(xRec."Customer Posting Group","Customer Posting Group") then
                    ERROR(Text46012225,xRec."Customer Posting Group","Customer Posting Group",SubstCustPostingGrp.TABLECAPTION);
                end else
                  ERROR(Text46012226,FIELDCAPTION("Customer Posting Group"),SalesSetup.FIELDCAPTION("Allow Alter Posting Groups"));
              end;
            //NAVE111.0; 001; end
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
        field(46015615;"Bank No.";Code[20])
        {
            Caption = 'Bank No.';
            Description = 'NAVE111.0,001';
            TableRelation = "Bank Account";

            trigger OnValidate();
            begin
                UpdateBankInfo;
            end;
        }
        field(46015616;"Bank Name";Text[50])
        {
            Caption = 'Bank Name';
            Description = 'NAVE111.0,001';
        }
        field(46015617;"Bank Account No.";Text[30])
        {
            Caption = 'Bank Account No.';
            Description = 'NAVE111.0,001';
        }
        field(46015625;"Multiple Interest Rates";Boolean)
        {
            Caption = 'Multiple Interest Rates';
            Description = 'NAVE111.0,001';
        }
        field(46015626;"Tax Amount";Decimal)
        {
            Caption = 'Tax Amount';
            Description = 'NAVE111.0,001';
        }
        field(46015630;"Posting Desc. Code";Code[10])
        {
            Caption = 'Posting Desc. Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Posting Description" WHERE (Type=CONST("Finance Charge"));

            trigger OnValidate();
            begin
                GetPostingDescription("Posting Desc. Code","Posting Description");
            end;
        }
        field(46015631;"Bank Branch No.";Text[20])
        {
            Caption = 'Bank Branch No.';
            Description = 'NAVE111.0,001';
        }
        field(46015632;IBAN;Code[50])
        {
            Caption = 'IBAN';
            Description = 'NAVE111.0,001';

            trigger OnValidate();
            begin
                CompanyInfo.CheckIBAN(IBAN);
            end;
        }
    }


    //Unsupported feature: CodeModification on "OnDelete". Please convert manually.

    //trigger OnDelete();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        FinChrgMemoIssue.DeleteHeader(Rec,IssuedFinChrgMemoHdr);

        FinChrgMemoLine.SETRANGE("Finance Charge Memo No.","No.");
        FinChrgMemoLine.DELETEALL;

        FinChrgMemoCommentLine.SETRANGE(Type,FinChrgMemoCommentLine.Type::"Finance Charge Memo");
        FinChrgMemoCommentLine.SETRANGE("No.","No.");
        FinChrgMemoCommentLine.DELETEALL;
        #9..16
            IssuedFinChrgMemoHdr.PrintRecords(true,false,false)
          end;
        end;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..5
        //NAVE111.0; 001; begin
        if LocalizationUsage.UseEastLocalization then begin
          DtldFinChargeMemoLine.SETRANGE("Finance Charge Memo No.","No.");
          DtldFinChargeMemoLine.DELETEALL;
        end;
        //NAVE111.0; 001; end

        #6..19
        */
    //end;


    //Unsupported feature: CodeModification on "OnInsert". Please convert manually.

    //trigger OnInsert();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        SalesSetup.GET;
        if "No." = '' then begin
          SalesSetup.TESTFIELD("Fin. Chrg. Memo Nos.");
          SalesSetup.TESTFIELD("Issued Fin. Chrg. M. Nos.");
          NoSeriesMgt.InitSeries(
            SalesSetup."Fin. Chrg. Memo Nos.",xRec."No. Series","Posting Date",
            "No.","No. Series");
        end;
        "Posting Description" := STRSUBSTNO(Text000,"No.");
        if ("No. Series" <> '') and
           (SalesSetup."Fin. Chrg. Memo Nos." = SalesSetup."Issued Fin. Chrg. M. Nos.")
        #12..19
        if GETFILTER("Customer No.") <> '' then
          if GETRANGEMIN("Customer No.") = GETRANGEMAX("Customer No.") then
            VALIDATE("Customer No.",GETRANGEMIN("Customer No."));
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..8

        //NAVE111.0; 001; begin
        if LocalizationUsage.UseEastLocalization then
          "Multiple Interest Rates" := SalesSetup."Multiple Interest Rates";
        //NAVE111.0; 001; end

        #9..22

        //NAVE111.0; 001; begin
        if LocalizationUsage.UseEastLocalization then
          VALIDATE("Posting Desc. Code",SalesSetup."Fin. Charge Posting Desc. Code");
        //NAVE111.0; 001; end
        */
    //end;


    //Unsupported feature: CodeInsertion on "OnModify". Please convert manually.

    //trigger OnModify();
    //Parameters and return type have not been exported.
    //begin
        /*
        //NAVE111.0; 001; begin
        if LocalizationUsage.UseEastLocalization then
          VALIDATE("Posting Desc. Code");
        //NAVE111.0; 001; end
        */
    //end;

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
        DtldFinChargeMemoLine : Record "Detailed Fin. Charge Memo Line";
        SubstCustPostingGrp : Record "Subst. Customer Posting Group";
        CompanyInfo : Record "Company Information";
        Text46012225 : Label 'You cannot change the %1 to %2 because %3 has not been filled in.';
        Text46012226 : Label 'You cannot change %1 until %2 will be checked in setup.';
        LocalizationUsage : Codeunit "Localization Usage";
}

