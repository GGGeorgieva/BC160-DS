tableextension 46015547 "Reminder Header Extension" extends "Reminder Header"
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
        #4..26
        "Shortcut Dimension 1 Code" := Cust."Global Dimension 1 Code";
        "Shortcut Dimension 2 Code" := Cust."Global Dimension 2 Code";
        "VAT Registration No." := Cust."VAT Registration No.";
        Cust.TESTFIELD("Customer Posting Group");
        "Customer Posting Group" := Cust."Customer Posting Group";
        "Gen. Bus. Posting Group" := Cust."Gen. Bus. Posting Group";
        #33..36
        "Fin. Charge Terms Code" := Cust."Fin. Charge Terms Code";
        VALIDATE("Reminder Terms Code");

        CreateDim(DATABASE::Customer,"Customer No.");
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..29

        //NAVE111.0; 001; begin
        if LocalizationUsage.UseEastLocalization then begin
          "Registration No." := Cust."Registration No.";
          "Registration No. 2" := Cust."Registration No. 2";
        end;
        //NAVE111.0; 001; end

        #30..39
        //NAVE111.0; 001; begin
        if LocalizationUsage.UseEastLocalization then
          UpdateBankInfo;
        //NAVE111.0; 001; end

        CreateDim(DATABASE::Customer,"Customer No.");
        */
        //end;
        field(46015605; "Registration No."; Text[20])
        {
            Caption = 'Registration No.';
            Description = 'NAVE111.0,001';
        }
        field(46015606; "Registration No. 2"; Text[20])
        {
            Caption = 'Registration No. 2';
            Description = 'NAVE111.0,001';
        }
        field(46015615; "Bank No."; Code[20])
        {
            Caption = 'Bank No.';
            Description = 'NAVE111.0,001';
            TableRelation = "Bank Account";

            trigger OnValidate();
            begin
                //TO DO
                //UpdateBankInfo;
            end;
        }
        field(46015616; "Bank Name"; Text[50])
        {
            Caption = 'Bank Name';
            Description = 'NAVE111.0,001';
        }
        field(46015617; "Bank Account No."; Text[30])
        {
            Caption = 'Bank Account No.';
            Description = 'NAVE111.0,001';
        }
        field(46015625; "Multiple Interest Rates"; Boolean)
        {
            Caption = 'Multiple Interest Rates';
            Description = 'NAVE111.0,001';
        }
        field(46015631; "Bank Branch No."; Text[20])
        {
            Caption = 'Bank Branch No.';
            Description = 'NAVE111.0,001';
        }
        field(46015632; IBAN; Code[50])
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
    ReminderIssue.DeleteHeader(Rec,IssuedReminderHeader);

    ReminderLine.SETRANGE("Reminder No.","No.");
    ReminderLine.DELETEALL;

    ReminderCommentLine.SETRANGE(Type,ReminderCommentLine.Type::Reminder);
    ReminderCommentLine.SETRANGE("No.","No.");
    ReminderCommentLine.DELETEALL;
    #9..16
        IssuedReminderHeader.PrintRecords(true,false,false)
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
      DtldReminderLine.SETRANGE("Reminder No.","No.");
      DtldReminderLine.DELETEALL;
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
      SalesSetup.TESTFIELD("Reminder Nos.");
      SalesSetup.TESTFIELD("Issued Reminder Nos.");
      NoSeriesMgt.InitSeries(
        SalesSetup."Reminder Nos.",xRec."No. Series","Posting Date",
        "No.","No. Series");
    end;
    "Posting Description" := STRSUBSTNO(Text000,"No.");
    if ("No. Series" <> '') and
       (SalesSetup."Reminder Nos." = SalesSetup."Issued Reminder Nos.")
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
    */
    //end;

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
        CompanyInfo: Record "Company Information";
        DtldReminderLine: Record "Detailed Reminder Line";
}

