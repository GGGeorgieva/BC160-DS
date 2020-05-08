tableextension 46015525 "Cust. Ledger Entry Extension" extends "Cust. Ledger Entry"
{
    // version NAVW111.00.00.27667,NAVE111.0,NAVBG11.0

    fields
    {

        modify("On Hold")
        {
            trigger OnAfterValidate()
            var
                GenJnlLine: Record "Gen. Journal Line";
            begin
                GenJnlLine.RESET;
                GenJnlLine.SETRANGE("Account Type", GenJnlLine."Account Type"::Customer);
                GenJnlLine.SETRANGE("Account No.", "Customer No.");
                GenJnlLine.SETRANGE("Applies-to Doc. Type", "Document Type");
                GenJnlLine.SETRANGE("Applies-to Doc. No.", "Document No.");
                GenJnlLine.SETRANGE(Compensation, true);
                if GenJnlLine.FINDFIRST then
                    ERROR(
                      Text46012225,
                      GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Line No.");
            end;
        }

        field(46015505; "Excise Amount (LCY)"; Decimal)
        {
            Caption = 'Excise Amount (LCY)';
            Description = 'NAVBG11.0,001';
        }
        field(46015506; "Product Tax Amount (LCY)"; Decimal)
        {
            Caption = 'Product Tax Amount (LCY)';
            Description = 'NAVBG11.0,001';
        }
        field(46015610; "VAT Date"; Date)
        {
            Caption = 'VAT Date';
            Description = 'NAVE111.0,001';
            Editable = false;
        }
        field(46015615; Compensation; Boolean)
        {
            Caption = 'Compensation';
            Description = 'NAVE111.0,001';
        }
        field(46015700; "Unrealized VAT"; Boolean)
        {
            Caption = 'Unrealized VAT';
            Description = 'NAVBG11.0,001';
        }
    }
    keys
    {

        // key(Key1;"Customer No.","Currency Code","Customer Posting Group","Document Type")
        // {
        //  }
        //  key(Key2;"Document No.","Posting Date","Currency Code")
        //  {
        //  }
        //  key(Key3;"Customer No.","Customer Posting Group",Prepayment,"Posting Date")
        //  {
        //  }
        //  key(Key4;"Document Type","Document No.")
        //  {
        //  }
    }



    var
        Text46012225: Label 'The operation is prohibited, until journal line of Journal Template Name = ''%1'', Journal Batch Name = ''%2'', Line No. = ''%3'' is deleted or posted.';
}

