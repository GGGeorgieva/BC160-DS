tableextension 46015584 "Transfer Header Extension" extends "Transfer Header"
{
    // version NAVW111.00.00.27667,NAVE111.0,NAVBG11.0

    fields
    {

        //Unsupported feature: CodeModification on ""Transfer-from Code"(Field 2).OnValidate". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        TestStatusOpen;

        if ("Transfer-from Code" = "Transfer-to Code") and
        #4..57
            TransLine.SETRANGE("Document No.","No.");
            if TransLine.FINDSET then
              TransLine.DELETEALL(true);
          end else
            "Transfer-from Code" := xRec."Transfer-from Code";
        end;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..60

              //NAVBG11.0; 001; begin
              if LocalizationUsage.UseEastLocalization then begin
                  ExciseTaxDoc.SETCURRENTKEY("Document Type","Corresponding Doc. No.");
                  ExciseTaxDoc.SETRANGE(ExciseTaxDoc."Corresponding Doc. No.","No.");
                  ExciseTaxDoc.SETRANGE(ExciseTaxDoc."Document Type","Excise Tax Document Type");
                  if ExciseTaxDoc.FINDFIRST then begin
                    ExciseTaxDoc.VALIDATE(ExciseTaxDoc."Transfer-From Code","Transfer-from Code");
                    ExciseTaxDoc.MODIFY;
                  end;
              end;
              //NAVBG11.0; 001; end
          end else

            "Transfer-from Code" := xRec."Transfer-from Code";
        end;
        */
        //end;
        field(46015505; "Excise Tax Document No."; Code[20])
        {
            Caption = 'Excise Tax Document No.';

            trigger OnValidate();
            var
                SalesSetup: Record "Sales & Receivables Setup";
            begin
                //TO DO
                /*
                if "Excise Tax Document No." <> xRec."Excise Tax Document No." then begin
                    SalesSetup.GET;
                    NoSeriesMgt.TestManual(SalesSetup."Excise Tax Document Nos.");
                    "Excise Tax Document No. Series" := '';
                    ExciseTaxDoc.ValidateWithTransferValues(Rec);
                end else
                    ExciseTaxDoc.ValidateWithTransferValues(Rec);
                */
            end;
        }
        field(46015506; "Excise Document Date"; Date)
        {
            Caption = 'Excise Document Date';
        }
        field(46015507; "Return Date of AAD"; Date)
        {
            Caption = 'Return Date of AAD';
        }
        field(46015508; "Excise Tax Document No. Series"; Code[10])
        {
            Caption = 'Excise Tax Document No. Series';
            TableRelation = "No. Series";
        }
        field(46015509; "Excise Tax Document Type"; Option)
        {
            Caption = 'Excise Tax Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Transfer Order,Posted Sales Shipment,Posted Sales Invoice,Posted Transfer Receipt,Posted Transfer Shipment';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","Transfer Order","Posted Sales Shipment","Posted Sales Invoice","Posted Transfer Receipt","Posted Transfer Shipment";
        }
        field(46015510; "Outbound Excise Destination"; Code[2])
        {
            Caption = 'Outbound Excise Destination';
            TableRelation = "Excise Destination".Code WHERE("Destination Type" = CONST(Outbound));

            trigger OnValidate();
            var
                lRecTransLine: Record "Transfer Line";
            begin
                lRecTransLine.RESET;
                lRecTransLine.SETRANGE(lRecTransLine."Document No.", "No.");
                lRecTransLine.SETRANGE(lRecTransLine."Excise Item", true);
                if lRecTransLine.FIND('-') then
                    repeat
                        lRecTransLine."Outbound Excise Destination" := "Outbound Excise Destination";
                        lRecTransLine.MODIFY;
                    until lRecTransLine.NEXT = 0;
            end;
        }
        field(46015511; "Inbound Excise Destination"; Code[2])
        {
            Caption = 'Inbound Excise Destination';
            TableRelation = "Excise Destination".Code WHERE("Destination Type" = CONST(Inbound));

            trigger OnValidate();
            var
                lRecTransLine: Record "Transfer Line";
            begin
                lRecTransLine.RESET;
                lRecTransLine.SETRANGE(lRecTransLine."Document No.", "No.");
                lRecTransLine.SETRANGE(lRecTransLine."Excise Item", true);
                if lRecTransLine.FIND('-') then
                    repeat
                        lRecTransLine."Inbound Excise Destination" := "Inbound Excise Destination";
                        lRecTransLine.MODIFY;
                    until lRecTransLine.NEXT = 0;
            end;
        }
        field(46015512; "Payment Obligation Type"; Code[2])
        {
            Caption = 'Payment Obligation Type';
            TableRelation = "Payment Obligation Type";

            trigger OnValidate();
            begin
                UpdateTransLines(Rec, FIELDNO("Payment Obligation Type"));
            end;
        }
        field(46015513; "Excise Charge Ground Code"; Code[20])
        {
            Caption = 'Excise Charge Ground Code';
            TableRelation = "Excise Charge Ground";
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
        ExciseTaxDoc: Record "Excise Tax Document";
}

