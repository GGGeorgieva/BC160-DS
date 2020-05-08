tableextension 46015532 tableextension46015532 extends "VAT Entry" 
{
    // version NAVW111.00.00.21836,NAVE111.0,NAVBG11.0

    fields
    {

        //Unsupported feature: CodeModification on ""Bill-to/Pay-to No."(Field 12).OnValidate". Please convert manually.

        //trigger "(Field 12)();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            VALIDATE(Type);
            if "Bill-to/Pay-to No." = '' then begin
              "Country/Region Code" := '';
              "VAT Registration No." := '';
            end else
              case Type of
                Type::Purchase:
                  begin
                    Vend.GET("Bill-to/Pay-to No.");
                    "Country/Region Code" := Vend."Country/Region Code";
                    "VAT Registration No." := Vend."VAT Registration No.";
                  end;
                Type::Sale:
                  begin
                    Cust.GET("Bill-to/Pay-to No.");
                    "Country/Region Code" := Cust."Country/Region Code";
                    "VAT Registration No." := Cust."VAT Registration No.";
                  end;
              end;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..4

              //NAVE111.0; 001; begin
              if LocalizationUsage.UseEastLocalization then
                "Registration No." := '';
              //NAVE111.0; 001; end

            #5..11

                    //NAVE111.0; 001; begin
                    if LocalizationUsage.UseEastLocalization then
                      "Registration No." := Vend."Registration No.";
                    //NAVE111.0; 001; end

            #12..17

                    //NAVE111.0; 001; begin
                    if LocalizationUsage.UseEastLocalization then
                      "Registration No." := Cust."Registration No.";
                    //NAVE111.0; 001; end

                  end;
              end;
            */
        //end;


        //Unsupported feature: CodeModification on ""EU 3-Party Trade"(Field 13).OnValidate". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            VALIDATE(Type);
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            VALIDATE(Type);

            //NAVE111.0; 001; begin
            if LocalizationUsage.UseEastLocalization then
              if not "EU 3-Party Trade" then
                "EU 3-Party Intermediate Role" := false;
            //NAVE111.0; 001; end
            */
        //end;
        field(46015505;"Debit Memo";Boolean)
        {
            Caption = 'Debit Memo';
            Description = 'NAVBG11.0,001';
        }
        field(46015506;"Sales Protocol";Boolean)
        {
            Caption = 'Sales Protocol';
            Description = 'NAVBG11.0,001';
        }
        field(46015507;"Identification No.";Text[13])
        {
            Caption = 'Identification No.';
            Description = 'NAVBG11.0,001';
        }
        field(46015508;Void;Boolean)
        {
            Caption = 'Void';
            Description = 'NAVBG11.0,001';
        }
        field(46015509;"Void Date";Date)
        {
            Caption = 'Void Date';
            Description = 'NAVBG11.0,001';
        }
        field(46015510;"VAT Subject";Text[30])
        {
            Caption = 'VAT Subject';
            Description = 'NAVBG11.0,001';
        }
        field(46015511;"VAT Type";Option)
        {
            Caption = 'VAT Type';
            Description = 'NAVBG11.0,001';
            OptionCaption = '" ,Purchase,Sale"';
            OptionMembers = " ",Purchase,Sale;
        }
        field(46015512;"Bill-to/Pay-to Name";Text[50])
        {
            Caption = 'Bill-to/Pay-to Name';
            Description = 'NAVBG11.0,001';
        }
        field(46015513;"Do not include in VAT Ledgers";Boolean)
        {
            Caption = 'Do not include in VAT Ledgers';
            Description = 'NAVBG11.0,001';
        }
        field(46015514;"Excise Amount";Decimal)
        {
            Caption = 'Excise Amount';
            Description = 'NAVBG11.0,001';
        }
        field(46015515;"Add.-Currency Excise Amount";Decimal)
        {
            Caption = 'Add.-Currency Excise Amount';
            Description = 'NAVBG11.0,001';
        }
        field(46015516;"VAT Protocol";Boolean)
        {
            Caption = 'VAT Protocol';
            Description = 'NAVBG11.0,001';
        }
        field(46015605;"Registration No.";Text[20])
        {
            Caption = 'Registration No.';
            Description = 'NAVE111.0,001';
        }
        field(46015610;"VAT Date";Date)
        {
            Caption = 'VAT Date';
            Description = 'NAVE111.0,001';
            Editable = false;
        }
        field(46015611;"Postponed VAT";Boolean)
        {
            Caption = 'Postponed VAT';
            Description = 'NAVE111.0,001';
            Editable = false;
        }
        field(46015612;"VAT Identifier";Code[10])
        {
            Caption = 'VAT Identifier';
            Description = 'NAVE111.0,001';
            Editable = false;
        }
        field(46015619;"EU 3-Party Intermediate Role";Boolean)
        {
            Caption = 'EU 3-Party Intermediate Role';
            Description = 'NAVE111.0,001';
            Editable = false;

            trigger OnValidate();
            begin
                if "EU 3-Party Intermediate Role" then
                  "EU 3-Party Trade" := true;
            end;
        }
        field(46015625;"SAD No.";Code[20])
        {
            Caption = 'SAD No.';
            Description = 'NAVE111.0,001';
            Editable = true;
            TableRelation = IF (Type=CONST(Purchase)) "Export SAD Header"
                            ELSE IF (Type=CONST(Sale)) "Import SAD Header";
        }
        field(46015626;"Customs Procedure Code";Code[10])
        {
            Caption = 'Customs Procedure Code';
            Description = 'NAVE111.0,001';
            Editable = false;
            TableRelation = "Custom Procedure";
        }
        field(46015635;"VAT % (Non Deductible)";Decimal)
        {
            Caption = 'VAT % (Non Deductible)';
            Description = 'NAVE111.0,001';
            MaxValue = 100;
            MinValue = 0;
        }
        field(46015636;"VAT Base (Non Deductible)";Decimal)
        {
            Caption = 'VAT Base (Non Deductible)';
            Description = 'NAVE111.0,001';
            Editable = false;
        }
        field(46015637;"VAT Amount (Non Deductible)";Decimal)
        {
            Caption = 'VAT Amount (Non Deductible)';
            Description = 'NAVE111.0,001';
            Editable = false;
        }
        field(46015700;"Unrealized VAT";Boolean)
        {
            Caption = 'Unrealized VAT';
            Description = 'NAVBG11.0,001';
        }
        field(46015701;"VAT Chargeable On Recipient";Option)
        {
            Caption = 'Purchase according to art. 163a of the VAT Act';
            Description = 'NAVBG11.0,001';
            OptionCaption = '" ,01,02"';
            OptionMembers = " ","01","02";
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
        PostponedVAT : Boolean;
        LocalizationUsage : Codeunit "Localization Usage";
        ErrTxt : Label 'ER';
}

