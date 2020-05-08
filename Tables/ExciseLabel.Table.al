table 46015698 "Excise Label"
{
    // version NAVBG11.0

    // -----------------------------------------------------------------------------------------
    // Dynamic Solutions
    // MS Dynamics NAV 2017 Localisation
    // 
    // 
    // -----------------------------------------------------------------------------------------
    // No.   Sign     Date       Version        Description
    // -----------------------------------------------------------------------------------------
    // 001                        NAVBG11.0
    // -----------------------------------------------------------------------------------------

    Caption = 'Excise Label';

    fields
    {
        field(2;"Entry Type";Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Purchase,Sale,Positive Adjmt.,Negative Adjmt.,Transfer,Consumption,Output';
            OptionMembers = Purchase,Sale,"Positive Adjmt.","Negative Adjmt.",Transfer,Consumption,Output;
        }
        field(3;"Document Type";Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Item Journal';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","Item Journal";
        }
        field(4;"Document No.";Code[20])
        {
            Caption = 'Document No.';
        }
        field(5;"Document Line No.";Integer)
        {
            Caption = 'Document Line No.';
        }
        field(6;"Line No.";Integer)
        {
            Caption = 'Line No.';
        }
        field(7;"Item No.";Code[20])
        {
            Caption = 'Item No.';
            Editable = false;
            TableRelation = Item;

            trigger OnValidate();
            var
                ICPartner : Record "IC Partner";
                ItemCrossReference : Record "Item Cross Reference";
            begin
            end;
        }
        field(8;Quantity;Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0:5;

            trigger OnValidate();
            begin
                VALIDATE("Series No. From");
            end;
        }
        field(9;"Series No. From";Text[15])
        {
            Caption = 'Series No. From';

            trigger OnValidate();
            begin
                if "Series No. From" <> '' then begin
                  if INCSTR("Series No. From") = '' then
                    ERROR(Text001, FIELDCAPTION("Series No. From"));

                  if Quantity > 0 then
                    "Series No. To" := IncrementNoText("Series No. From", Quantity - 1);
                end;
            end;
        }
        field(10;"Series No. To";Text[15])
        {
            Caption = 'Series No. To';
        }
        field(11;"Journal Template Name";Code[20])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Item Journal Template";
        }
        field(12;"Journal Batch Name";Code[20])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Item Journal Batch".Name WHERE ("Journal Template Name"=FIELD("Journal Template Name"));
        }
        field(14;"Posting Date";Date)
        {
            Caption = 'Posting Date';
        }
    }

    keys
    {
        key(Key1;"Entry Type","Document Type","Document No.","Document Line No.","Journal Template Name","Journal Batch Name","Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        TESTFIELD("Series No. From");
    end;

    var
        Text001 : Label '%1 must contain a number';
        Text002 : Label 'The number %1 cannot be extended to more than 20 characters.';
        Qnt : Decimal;
        LineNo : Integer;

    procedure CreateNewLine();
    begin
        if "Journal Template Name" = '' then
          case "Entry Type" of
            "Entry Type"::Sale:
              CreateNewSalesLine;
            "Entry Type"::Purchase:
              CreateNewPurchLine;
          end
        else
          CreateJnlLine();
    end;

    procedure CreateNewSalesLine();
    var
        SalesHeader : Record "Sales Header";
        SalesLine : Record "Sales Line";
        ExciseLabel : Record "Excise Label";
    begin
        SalesLine.SETRANGE("Document Type","Document Type");
        SalesLine.SETRANGE("Document No.","Document No.");
        SalesLine.SETRANGE("Line No.","Document Line No.");
        if SalesLine.FINDFIRST then begin
          ExciseLabel.COPY(Rec);
          if ExciseLabel.FINDFIRST then
            repeat
              Qnt := Qnt + ExciseLabel.Quantity;
            until ExciseLabel.NEXT = 0;

          LineNo := ExciseLabel."Line No.";

          INIT;
          if Qnt < SalesLine.Quantity then
            Quantity := SalesLine.Quantity - Qnt
          else
            Quantity := 0;
          "Item No." := SalesLine."No.";
          "Line No." := LineNo + 10000;
          SalesHeader.GET(SalesLine."Document Type",SalesLine."Document No.");
          "Posting Date" := SalesHeader."Posting Date";
        end;
    end;

    procedure CreateNewPurchLine();
    var
        PurchHeader : Record "Purchase Header";
        PurchLine : Record "Purchase Line";
        ExciseLabel : Record "Excise Label";
    begin
        PurchLine.SETRANGE("Document Type","Document Type");
        PurchLine.SETRANGE("Document No.","Document No.");
        PurchLine.SETRANGE("Line No.","Document Line No.");
        if PurchLine.FINDFIRST then begin
          ExciseLabel.COPY(Rec);
          if ExciseLabel.FINDFIRST then
            repeat
              Qnt := Qnt + ExciseLabel.Quantity;
            until ExciseLabel.NEXT = 0;

          LineNo := ExciseLabel."Line No.";

          INIT;
          if Qnt < PurchLine.Quantity then
            Quantity := PurchLine.Quantity - Qnt
          else
            Quantity := 0;
          "Item No." := PurchLine."No.";
          "Line No." := LineNo + 10000;
          PurchHeader.GET(PurchLine."Document Type",PurchLine."Document No.");
          "Posting Date" := PurchHeader."Posting Date";
        end;
    end;

    procedure CreateJnlLine();
    var
        ItemJnlLine : Record "Item Journal Line";
        ExciseLabel : Record "Excise Label";
    begin
        ItemJnlLine.SETRANGE("Entry Type","Entry Type");
        ItemJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
        ItemJnlLine.SETRANGE("Journal Batch Name","Journal Batch Name");
        ItemJnlLine.SETRANGE("Line No.","Document Line No.");
        if ItemJnlLine.FINDFIRST then begin
          ExciseLabel.COPY(Rec);
          if ExciseLabel.FINDFIRST then
            repeat
              Qnt := Qnt + ExciseLabel.Quantity;
            until ExciseLabel.NEXT = 0;

          LineNo := ExciseLabel."Line No.";

          INIT;
          if Qnt < ItemJnlLine.Quantity then
            Quantity := ItemJnlLine.Quantity - Qnt
          else
            Quantity := 0;
          "Document No." := ItemJnlLine."Document No.";
          "Item No." := ItemJnlLine."Item No.";
          "Line No." := LineNo + 10000;
          "Document Type" := "Document Type"::"Item Journal";
          "Posting Date" := ItemJnlLine."Posting Date";
        end;
    end;

    local procedure IncrementNoText(No : Text[15];IncrementByNo : Decimal) : Text[15];
    var
        DecimalNo : Decimal;
        StartPos : Integer;
        EndPos : Integer;
        NewNo : Text[30];
    begin
        GetIntegerPos(No,StartPos,EndPos);
        EVALUATE(DecimalNo,COPYSTR(No,StartPos,EndPos - StartPos + 1));
        NewNo := FORMAT(DecimalNo + IncrementByNo,0,1);
        ReplaceNoText(No,NewNo,0,StartPos,EndPos);
        exit(No);
    end;

    local procedure GetIntegerPos(No : Text[15];var StartPos : Integer;var EndPos : Integer);
    var
        IsDigit : Boolean;
        i : Integer;
    begin
        StartPos := 0;
        EndPos := 0;
        if No <> '' then begin
          i := STRLEN(No);
          repeat
            IsDigit := No[i] in ['0'..'9'];
            if IsDigit then begin
              if EndPos = 0 then
                EndPos := i;
              StartPos := i;
            end;
            i := i - 1;
          until (i = 0) or (StartPos <> 0) and not IsDigit;
        end;
    end;

    local procedure ReplaceNoText(var No : Text[15];NewNo : Text[15];FixedLength : Integer;StartPos : Integer;EndPos : Integer);
    var
        StartNo : Text[15];
        EndNo : Text[15];
        ZeroNo : Text[15];
        NewLength : Integer;
        OldLength : Integer;
    begin
        if StartPos > 1 then
          StartNo := COPYSTR(No,1,StartPos - 1);
        if EndPos < STRLEN(No) then
          EndNo := COPYSTR(No,EndPos + 1);
        NewLength := STRLEN(NewNo);
        OldLength := EndPos - StartPos + 1;
        if FixedLength > OldLength then
          OldLength := FixedLength;
        if OldLength > NewLength then
          ZeroNo := PADSTR('',OldLength - NewLength,'0');
        if STRLEN(StartNo) + STRLEN(ZeroNo) + STRLEN(NewNo) + STRLEN(EndNo)  > 15 then
          ERROR(
            Text002,
            No);
        No := StartNo + ZeroNo + NewNo + EndNo;
    end;
}

