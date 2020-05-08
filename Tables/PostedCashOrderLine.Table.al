table 46015648 "Posted Cash Order Line"
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

    Caption = 'Posted Cash Order Line';

    fields
    {
        field(1;"Cash Desk No.";Code[20])
        {
            Caption = 'Cash Desk No.';
            TableRelation = "Bank Account"."No." WHERE ("Account Type"=CONST("Cash Desk"));
        }
        field(2;"Cash Order No.";Code[20])
        {
            Caption = 'Cash Order No.';
            TableRelation = "Cash Order Header" WHERE ("No."=FIELD("Cash Order No."));
        }
        field(3;"Line No.";Integer)
        {
            Caption = 'Line No.';
        }
        field(4;"Document Type";Option)
        {
            Caption = 'Document Type';
            OptionCaption = '" ,Payment,,,,Refund"';
            OptionMembers = " ",Payment,,,,Refund;
        }
        field(5;"Account Type";Option)
        {
            Caption = 'Account Type';
            OptionCaption = '" ,G/L Account,Customer,Vendor,Bank Account,Fixed Asset"';
            OptionMembers = " ","G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
        }
        field(6;"Account No.";Code[20])
        {
            Caption = 'Account No.';
            TableRelation = IF ("Account Type"=CONST("G/L Account")) "G/L Account"."No."
                            ELSE IF ("Account Type"=CONST(Customer)) Customer."No."
                            ELSE IF ("Account Type"=CONST(Vendor)) Vendor."No."
                            ELSE IF ("Account Type"=CONST("Bank Account")) "Bank Account"."No."
                            ELSE IF ("Account Type"=CONST("Fixed Asset")) "Fixed Asset"."No.";
        }
        field(7;"External Document No.";Code[20])
        {
            Caption = 'External Document No.';
        }
        field(8;"Posting Group";Code[20])
        {
            Caption = 'Posting Group';
            TableRelation = IF ("Account Type"=CONST("Fixed Asset")) "FA Posting Group".Code
                            ELSE IF ("Account Type"=CONST("Bank Account")) "Bank Account Posting Group".Code
                            ELSE IF ("Account Type"=CONST(Customer)) "Customer Posting Group".Code
                            ELSE IF ("Account Type"=CONST(Vendor)) "Vendor Posting Group".Code
                            ELSE IF ("Account Type"=CONST("G/L Account")) "Standard Text";
        }
        field(14;"Applies-To Doc. Type";Option)
        {
            Caption = 'Applies-To Doc. Type';
            OptionCaption = '" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund"';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(15;"Applies-To Doc. No.";Code[20])
        {
            Caption = 'Applies-To Doc. No.';
        }
        field(16;Description;Text[50])
        {
            Caption = 'Description';
        }
        field(17;Amount;Decimal)
        {
            Caption = 'Amount';
        }
        field(18;"Amount (LCY)";Decimal)
        {
            Caption = 'Amount (LCY)';
        }
        field(22;"On Hold";Code[20])
        {
            Caption = 'On Hold';
        }
        field(23;"Advance Letter No.";Code[20])
        {
            Caption = 'Advance Letter No.';
            TableRelation = IF ("Account Type"=CONST(Customer)) "Excise Tax Document" WHERE ("Document Type"=FIELD("Account No."))
                            ELSE IF ("Account Type"=CONST(Vendor)) "Excise Item Detail Code" WHERE (Field4=FIELD("Account No."));
        }
        field(24;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
        }
        field(25;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
        }
        field(26;"Order Type";Option)
        {
            Caption = 'Order Type';
            OptionCaption = 'Receipt,Withdrawal';
            OptionMembers = Receipt,Withdrawal;
        }
        field(27;"Currency Code";Code[20])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(28;"Applies-to ID";Code[20])
        {
            Caption = 'Applies-to ID';
        }
        field(29;Prepayment;Boolean)
        {
            Caption = 'Prepayment';
        }
        field(480;"Dimension Set ID";Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup();
            begin

                  ShowDimensions;
            end;
        }
    }

    keys
    {
        key(Key1;"Cash Desk No.","Order Type","Cash Order No.","Line No.")
        {
            SumIndexFields = Amount,"Amount (LCY)";
        }
    }

    fieldgroups
    {
    }

    var
        DimMgt : Codeunit DimensionManagement;

    procedure ShowDimensions();
    begin

          DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"Cash Order No."));
    end;
}

