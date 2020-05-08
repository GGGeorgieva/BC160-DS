table 46015650 "Cash Report Line"
{
    // version NAVE18.00

    // -----------------------------------------------------------------------------------------
    // XAPT Solutions
    // MS Dynamics NAV 2015 Localisation
    // 
    // mp  : Mile Petachki
    // version : NAVE18.00
    // 
    // -----------------------------------------------------------------------------------------
    // No.   Sign     Date       Version        Description
    // -----------------------------------------------------------------------------------------
    // 001   mp       27.10.14   NAVE18.00      Created table from MS Dynamics NAV 6.00
    // ------------------------------------------------------------------------------------------

    Caption = 'Cash Report Line';

    fields
    {
        field(1;"Cash Desk No.";Code[20])
        {
            Caption = 'Cash Desk No.';
            TableRelation = "Bank Account" WHERE ("Account Type"=CONST("Cash Desk"));
        }
        field(2;"Cash Desk Report No.";Code[20])
        {
            Caption = 'Cash Desk Report No.';
            TableRelation = "Cash Report Header"."No." WHERE ("Cash Desk No."=FIELD("Cash Desk No."));
        }
        field(3;"Line No.";Integer)
        {
            Caption = 'Line No.';
        }
        field(5;"Cash Order Type";Option)
        {
            Caption = 'Cash Order Type';
            Editable = false;
            OptionCaption = 'Receipt,Withdrawal';
            OptionMembers = Receipt,Withdrawal;
        }
        field(6;"Cash Order No.";Code[20])
        {
            Caption = 'Cash Order No.';
            TableRelation = IF (Status=CONST(Issued)) "Cash Order Header"."No." WHERE ("Cash Desk No."=FIELD("Cash Desk No."))
                            ELSE IF (Status=CONST(Posted)) "Posted Cash Order Header"."No." WHERE ("Cash Desk No."=FIELD("Cash Desk No."));
        }
        field(7;"Pay-to/Receive-from Name";Text[50])
        {
            Caption = 'Pay-to/Receive-from Name';
            Editable = false;
        }
        field(8;"Posting Date";Date)
        {
            Caption = 'Posting Date';
            Editable = false;
        }
        field(10;Amount;Decimal)
        {
            Caption = 'Amount';
            Editable = false;
        }
        field(11;"Amount (LCY)";Decimal)
        {
            Caption = 'Amount (LCY)';
            Editable = false;
        }
        field(12;Correction;Boolean)
        {
            Caption = 'Correction';
            Editable = false;
        }
        field(13;Prepayment;Boolean)
        {
            Caption = 'Prepayment';
        }
        field(15;Status;Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = '" ,Issued,Posted"';
            OptionMembers = " ",Issued,Posted;
        }
    }

    keys
    {
        key(Key1;"Cash Desk No.","Cash Desk Report No.","Line No.")
        {
            SumIndexFields = Amount,"Amount (LCY)";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        TestStatusOpen;
    end;

    trigger OnInsert();
    begin
        TestStatusOpen;
    end;

    trigger OnModify();
    begin
        TestStatusOpen;
    end;

    trigger OnRename();
    begin
        TestStatusOpen;
    end;

    var
        CashReptHeader : Record "Cash Report Header";

    procedure TestStatusOpen();
    begin
        if "Cash Desk Report No." <> '' then begin
          CashReptHeader.GET("Cash Desk No.","Cash Desk Report No.");
          CashReptHeader.TESTFIELD(Status,CashReptHeader.Status::Open);
        end;
    end;
}

