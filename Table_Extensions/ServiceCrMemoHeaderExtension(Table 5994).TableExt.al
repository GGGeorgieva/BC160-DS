tableextension 46015600 "Service Cr.Memo Header Ext." extends "Service Cr.Memo Header"
{
    fields
    {
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
        field(46015610; "VAT Date"; Date)
        {
            Caption = 'VAT Date';
            Description = 'NAVE111.0,001';
        }
        field(46015611; "Postponed VAT"; Boolean)
        {
            Caption = 'Postponed VAT';
            Description = 'NAVE111.0,001';
            Editable = false;
        }
        field(46015618; "Postponed VAT Realized"; Boolean)
        {
            Caption = 'Postponed VAT Realized';
            Description = 'NAVE111.0,001';
            Editable = false;
        }
    }
    var
        Text46012229: Label 'VAT Date %1 is not within your range of allowed VAT dates.\';
        Text46012230: Label 'Correct the date or change VAT posting period.';


    PROCEDURE HandlePostponedVAT(VATDate: Date; Post: Boolean);
    VAR
        CustLedgEntry: Record "Cust. Ledger Entry";
        GenJnlLine: Record "Gen. Journal Line";
        PostGenJnlLine: Codeunit "Gen. Jnl.-Post Line";

    BEGIN
        //NAVE111.0; 001; entire function
        TESTFIELD("Postponed VAT", Post);
        TESTFIELD("Postponed VAT Realized", not Post);
        "VAT Date" := VATDate;
        CheckVATDate;

        if FindCustLedgEntry(CustLedgEntry) then begin
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::"Credit Memo";
            GenJnlLine."Document No." := "No.";
            GenJnlLine."Postponed VAT" := true;
            GenJnlLine."VAT Date" := VATDate;
            GenJnlLine.Correction := Correction;
            GenJnlLine."Posting Date" := VATDate;
            GenJnlLine.Description := CustLedgEntry.Description;
            if Post then begin
                CustLedgEntry.CALCFIELDS("Remaining Amt. (LCY)");
                GenJnlLine.Amount := CustLedgEntry."Remaining Amt. (LCY)";
                //TODO MISSING METHOD PostCustPostponedVAT IN Codeunit "Gen. Jnl.-Post Line";
                //PostGenJnlLine.PostCustPostponedVAT(CustLedgEntry, GenJnlLine);
            end else begin
                //TODO MISSING METHOD ReverseCustPostponedVAT IN Codeunit "Gen. Jnl.-Post Line";
                //PostGenJnlLine.ReverseCustPostponedVAT(GenJnlLine, CustLedgEntry."Transaction No.");
            end;

            "Postponed VAT" := not Post;
            "Postponed VAT Realized" := Post;
        end;
    END;

    PROCEDURE CheckVATDate();
    VAR
        GLSetup: Record "General Ledger Setup";
        GenJnLCheckLine: Codeunit "Gen. Jnl.-Check Line";
    BEGIN
        //NAVE111.0; 001; entire function
        GLSetup.GET;
        if GLSetup."Use VAT Date" then begin
            TESTFIELD("VAT Date");
            //TODO MISSING METHOD VATDateNotAllowed IN Codeunit "Gen. Jnl.-Check Line";
            //if GenJnLCheckLine.VATDateNotAllowed("VAT Date") then
            //    ERROR(Text46012229 + Text46012230, "VAT Date")
            //TODO MISSING METHOD VATPeriodCheck IN Codeunit "Gen. Jnl.-Check Line";
            //GenJnLCheckLine.VATPeriodCheck("VAT Date");
        end;
    END;

    PROCEDURE FindCustLedgEntry(VAR CustLedgEntry: Record "Cust. Ledger Entry"): Boolean;
    VAR
        DimMgt: Codeunit DimensionManagement;
    BEGIN
        //NAVE111.0; 001; entire function
        CustLedgEntry.RESET;
        CustLedgEntry.SETCURRENTKEY("Document No.");
        CustLedgEntry.SETRANGE("Document No.", "No.");
        CustLedgEntry.SETRANGE("Document Type", CustLedgEntry."Document Type"::"Credit Memo");
        CustLedgEntry.SETRANGE("Posting Date", "Posting Date");
        if not CustLedgEntry.FINDFIRST then
            exit(false);

        exit(true);
    END;
}