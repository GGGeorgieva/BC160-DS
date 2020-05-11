tableextension 46015537 "Bank Account Extension" extends "Bank Account"
{
    // version NAVW111.00.00.27667,NAVBG11.0,NAVE111.0

    fields
    {
        //TODO - 
        //Trigger OnInsert; 
        //"No." - OnValidate
        //"Currency Code" - OnValidate
        //Procedure AssistEdit;
        //Custom procedures




        //Unsupported feature: CodeModification on ""No."(Field 1).OnValidate". Please convert manually.

        //trigger "(Field 1)();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        if "No." <> xRec."No." then begin
          GLSetup.GET;
          NoSeriesMgt.TestManual(GLSetup."Bank Account Nos.");
          "No. Series" := '';
        end;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        if "No." <> xRec."No." then begin

          //NAVE111.0; 001; begin
          if LocalizationUsage.UseEastLocalization then
            NoSeriesMgt.TestManual(GetAccountNos)
          else begin
          //NAVE111.0; 001; end

          GLSetup.GET;
          NoSeriesMgt.TestManual(GLSetup."Bank Account Nos.");

          //NAVE111.0; 001; single
          end;

          "No. Series" := '';
        end;
        */
        //end;


        //Unsupported feature: CodeInsertion on ""Bank Account No."(Field 13)". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //begin
        /*
        //NAVE111.0; 001; single
        if LocalizationUsage.UseEastLocalization then
          BGUtils.TestBankAcc("Bank Account No.","Country/Region Code");
        */
        //end;


        //Unsupported feature: CodeModification on ""Currency Code"(Field 22).OnValidate". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        if "Currency Code" = xRec."Currency Code" then
          exit;

        #4..14
          ERROR(
            Text000,
            FIELDCAPTION("Currency Code"));
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..17

        //NAVE111.0; 001; begin
        if "Currency Code" = '' then
          "Exclude from Exch. Rate Adj." := false;
        //NAVE111.0; 001; end
        */
        //end;
        field(46015505; "Bank Code"; Code[10])
        {
            Caption = 'Bank Code';
            Description = 'NAVBG11.0,001';
            Numeric = true;

            trigger OnValidate();
            begin
                BGUtils.TestBankCode("Bank Code", "Country/Region Code");
            end;
        }
        field(46015646; "Account Type"; Option)
        {
            Caption = 'Account Type';
            Description = 'NAVE111.0,001';
            OptionCaption = 'Bank Account,Cash Desk';
            OptionMembers = "Bank Account","Cash Desk";
        }
        field(46015647; "Max. Balance"; Decimal)
        {
            Caption = 'Max. Balance';
            Description = 'NAVE111.0,001';
        }
        field(46015648; "Balance Limit Control"; Option)
        {
            Caption = 'Balance Limit Control';
            Description = 'NAVE111.0,001';
            OptionCaption = 'None,Minimum,Maximum,Both';
            OptionMembers = "None","Min","Max",Both;
        }
        field(46015649; "Cash Order Receipt Nos."; Code[20])
        {
            Caption = 'Cash Order Receipt Nos.';
            Description = 'NAVE111.0,001';
            TableRelation = "No. Series";
        }
        field(46015650; "Cash Order Withdrawal Nos."; Code[20])
        {
            Caption = 'Cash Order Withdrawal Nos.';
            Description = 'NAVE111.0,001';
            TableRelation = "No. Series";
        }
        field(46015651; "Cash Desk Report Nos."; Code[20])
        {
            Caption = 'Cash Desk Report Nos.';
            Description = 'NAVE111.0,001';
            TableRelation = "No. Series";
        }
        field(46015652; "Cash Receipt Limit"; Decimal)
        {
            Caption = 'Cash Receipt Limit';
            Description = 'NAVE111.0,001';
        }
        field(46015653; "Cash Withdrawal Limit"; Decimal)
        {
            Caption = 'Cash Withdrawal Limit';
            Description = 'NAVE111.0,001';
        }
        field(46015654; "Exclude from Exch. Rate Adj."; Boolean)
        {
            Caption = 'Exclude from Exch. Rate Adj.';
            Description = 'NAVE111.0,001';

            trigger OnValidate();
            begin
                TESTFIELD("Currency Code");
                if "Exclude from Exch. Rate Adj." then begin
                    if not CONFIRM(Text46012225) then
                        "Exclude from Exch. Rate Adj." := xRec."Exclude from Exch. Rate Adj."
                end else
                    ERROR(Text46012226, FIELDCAPTION("Exclude from Exch. Rate Adj."));
            end;
        }
        field(46015656; "Cashier No."; Code[20])
        {
            Caption = 'Cashier No.';
            Description = 'NAVE111.0,001';
            TableRelation = Employee;
        }
        field(46015657; "Cash Posting Level"; Option)
        {
            Caption = 'Cash Posting Level';
            Description = 'NAVE111.0,001';
            OptionCaption = 'Cash Order,Cash Desk Report';
            OptionMembers = "Cash Order","Cash Desk Report";
        }
        field(46015660; "Cash Order Balance"; Decimal)
        {
            CalcFormula = Sum ("Cash Order Line"."Line Amount" WHERE("Cash Desk No." = FIELD("No.")));
            Caption = 'Cash Order Balance';
            Description = 'NAVE111.0,001';
            Editable = false;
            FieldClass = FlowField;
        }
        field(46015661; "Cash Order Balance (LCY)"; Decimal)
        {
            CalcFormula = Sum ("Cash Order Line"."Line Amount (LCY)" WHERE("Cash Desk No." = FIELD("No.")));
            Caption = 'Cash Order Balance (LCY)';
            Description = 'NAVE111.0,001';
            Editable = false;
            FieldClass = FlowField;
        }
    }


    //Unsupported feature: CodeModification on "OnInsert". Please convert manually.

    //trigger OnInsert();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    if "No." = '' then begin
      GLSetup.GET;
      GLSetup.TESTFIELD("Bank Account Nos.");
      NoSeriesMgt.InitSeries(GLSetup."Bank Account Nos.",xRec."No. Series",0D,"No.","No. Series");
    end;

    if not InsertFromContact then
      UpdateContFromBank.OnInsert(Rec);

    DimMgt.UpdateDefaultDim(
      DATABASE::"Bank Account","No.",
      "Global Dimension 1 Code","Global Dimension 2 Code");
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    if "No." = '' then begin

      //NAVE111.0; 001; begin
      if LocalizationUsage.UseEastLocalization then
        NoSeriesMgt.InitSeries(GetAccountNos,xRec."No. Series",0D,"No.","No. Series")
      else begin
      //NAVE111.0; 001; end

    #2..4

      //NAVE111.0; 001; single
      end;

    end;

    //NAVE111.0; 001; begin
    if LocalizationUsage.UseEastLocalization then begin
    InitCashDesk;
    if "Account Type" <> "Account Type"::"Cash Desk" then
      if not InsertFromContact then
        UpdateContFromBank.OnInsert(Rec);
    end else
    //NAVE111.0; 001; end

      if not InsertFromContact then
        UpdateContFromBank.OnInsert(Rec);
    #9..12
    */
    //end;

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
        BGUtils: Codeunit "BG Utils";
        CashReportHeader: Record "Cash Report Header";
        Text46012225: Label 'All entries will be excluded from Exchange Rates Adjustment. Do you want to continue?';
        Text46012226: Label 'You cannot uncheck %1.';

}

