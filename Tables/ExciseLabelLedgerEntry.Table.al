table 46015699 "Excise Label Ledger Entry"
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

    Caption = 'Excise Label Ledger Entry';
    //DrillDownPageID = "Excise Label Ledger Entries";
    //LookupPageID = "Excise Label Ledger Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Purchase,Sale,Positive Adjmt.,Negative Adjmt.,Transfer,Consumption,Output';
            OptionMembers = Purchase,Sale,"Positive Adjmt.","Negative Adjmt.",Transfer,Consumption,Output;
        }
        field(3; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Item Journal';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","Item Journal";
        }
        field(4; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(5; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
        }
        field(7; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            Editable = false;
            TableRelation = Item;

            trigger OnValidate();
            var
                ICPartner: Record "IC Partner";
                ItemCrossReference: Record "Item Cross Reference";
            begin
            end;
        }
        field(8; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(9; "Series No. From"; Text[15])
        {
            Caption = 'Series No. From';
        }
        field(10; "Series No. To"; Text[15])
        {
            Caption = 'Series No. To';
            Editable = false;
        }
        field(11; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Item Journal Template";
        }
        field(12; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Item Journal Batch".Name WHERE("Journal Template Name" = FIELD("Journal Template Name"));
        }
        field(13; "Item Ledger Entry No."; Integer)
        {
            Caption = 'Item Ledger Entry No.';
            TableRelation = "Item Ledger Entry";
        }
        field(14; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }

    procedure GetNextEntryNo(): Integer;
    var
        ExciseLabelLedgEntry: Record "Excise Label Ledger Entry";
    begin
        if ExciseLabelLedgEntry.FINDLAST then
            exit(ExciseLabelLedgEntry."Entry No." + 1)
        else
            exit(1);
    end;
}

