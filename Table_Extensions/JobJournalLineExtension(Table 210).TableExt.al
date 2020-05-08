tableextension 46015526 tableextension46015526 extends "Job Journal Line" 
{
    // version NAVW111.00.00.26401,NAVE111.0

    fields
    {

        //Unsupported feature: CodeModification on "Quantity(Field 10).OnValidate". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            "Quantity (Base)" := CalcBaseQty(Quantity);
            UpdateAllAmounts;

            #4..6
            CheckItemAvailable;
            if Item."Item Tracking Code" <> '' then
              ReserveJobJnlLine.VerifyQuantity(Rec,xRec);
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..9

            //NAVE111.0; 001; begin
            if LocalizationUSage.UseEastLocalization then begin
              GLSetup.GET;
              if GLSetup."Mark Neg. Qty as Correction" then
                Correction := Quantity < 0;
            end;
            //NAVE111.0; 001; end
            */
        //end;
        field(46015605;"Shipment Method Code";Code[10])
        {
            Caption = 'Shipment Method Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Shipment Method";
        }
        field(46015607;"Tariff No.";Code[10])
        {
            Caption = 'Tariff No.';
            Description = 'NAVE111.0,001';
            TableRelation = "Tariff Number";
        }
        field(46015608;"Net Weight";Decimal)
        {
            Caption = 'Net Weight';
            DecimalPlaces = 0:5;
            Description = 'NAVE111.0,001';
        }
        field(46015609;"Country/Region of Origin Code";Code[10])
        {
            Caption = 'Country/Region of Origin Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Country/Region";
        }
        field(46015611;"Intrastat Transaction";Boolean)
        {
            Caption = 'Intrastat Transaction';
            Description = 'NAVE111.0,001';
            Editable = false;
        }
        field(46015615;Correction;Boolean)
        {
            Caption = 'Correction';
            Description = 'NAVE111.0,001';
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
        StatReportingSetup : Record "Stat. Reporting Setup";
        LocalizationUSage : Codeunit "Localization Usage";
        Text46012225 : Label '%1 is required for Item %2.';
}

