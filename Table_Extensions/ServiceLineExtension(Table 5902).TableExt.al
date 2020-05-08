tableextension 46015593 "Service Line Extension" extends "Service Line"
{
    // version NAVW111.00.00.26401,NAVE111.0

    fields
    {

        //Unsupported feature: CodeModification on ""Qty. to Invoice"(Field 17).OnValidate". Please convert manually.

        //trigger  to Invoice"(Field 17)();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        if "Qty. to Invoice" < 0 then
          FIELDERROR("Qty. to Invoice",Text029);

        if "Qty. to Invoice" > 0 then begin
          "Qty. to Consume" := 0;
          "Qty. to Consume (Base)" := 0;
        end;

        if "Qty. to Invoice" = MaxQtyToInvoice then
          InitQtyToInvoice
        else
          "Qty. to Invoice (Base)" := CalcBaseQty("Qty. to Invoice");
        if ("Qty. to Invoice" * Quantity < 0) or
           (ABS("Qty. to Invoice") > ABS(MaxQtyToInvoice))
        then
          ERROR(
            Text000,
            MaxQtyToInvoice);
        if ("Qty. to Invoice (Base)" * "Quantity (Base)" < 0) or
           (ABS("Qty. to Invoice (Base)") > ABS(MaxQtyToInvoiceBase))
        then
          ERROR(
            Text001,
            MaxQtyToInvoiceBase);
        "VAT Difference" := 0;

        if (xRec."Qty. to Consume" <> "Qty. to Consume") or
           (xRec."Qty. to Consume (Base)" <> "Qty. to Consume (Base)")
        then
          VALIDATE("Line Discount %")
        else begin
          CalcInvDiscToInvoice;
          UpdateAmounts;
        end;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..25
        CalcInvDiscToInvoice;
        UpdateAmounts;
        */
        //end;
        field(46015610; "VAT Date"; Date)
        {
            Caption = 'VAT Date';
            Description = 'NAVE111.0,001';

            trigger OnValidate();
            begin
                //TO DO
                /*
                if CurrFieldNo = FIELDNO("VAT Date") then begin
                  GetGLSetup;
                  if not GLSetup."Allow VAT Date Change in Lines" then
                    ERROR(Text46012225,
                      GLSetup.FIELDCAPTION("Allow VAT Date Change in Lines"),
                      GLSetup.TABLECAPTION,FIELDCAPTION("VAT Date"));
                end;
                */
            end;
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
        Text050: Label '\The entered information may be disregarded by warehouse operations.';

    var
        Text020: Label 'Change %1 from %2 to %3?';
        GLSetupRead: Boolean;
        GLSetup: Record "General Ledger Setup";
        Text46012225: Label 'You must check field %1 in %2 to be able to change the %3 field manually.';
}

