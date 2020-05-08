table 46015513 "VAT Classification"
{
    // version NAVBG8.00

    // -----------------------------------------------------------------------------------------
    // XAPT Solutions
    // MS Dynamics NAV 2015 Localisation
    // 
    // mp  : Mile Petachki
    // version : NAVBG8.00
    // 
    // -----------------------------------------------------------------------------------------
    // No.   Sign     Date       Version        Description
    // -----------------------------------------------------------------------------------------
    // 001   mp       27.10.14   NAVBG8.00      Created table from MS Dynamics NAV 6.00
    // ------------------------------------------------------------------------------------------

    Caption = 'VAT Classification';
    //LookupPageID = "VAT Classifications";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Text000: Label 'Local transactions';
        Text001: Label 'Other Cases Normal VAT';
        Text002: Label 'Purchases according to art. 82, p.2-5';
        Text003: Label 'Subject to 0% VAT acc. to Ch.3 of the VAT Act';
        Text004: Label 'Subject to 0% VAT, acc. to art. 140,146 and 173, p.1 and 4 of the VAT Act';
        Text005: Label 'Sales subject to 0% VAT, acc. to art.21, p.3 and art. 22-24 of the VAT Act';
        Text006: Label 'Transactions acc. to art. 69, p.2 of the VAT Act';
        Text007: Label 'Subject to 7% VAT charge';
        Text008: Label 'Intra-community purchases';
        Text009: Label 'Distant sales effected within the territory of another EU member country';
        Text010: Label 'Sales and Intra-community acquisitions exempt from VAT';
        Text011: Label 'Import';
        Text012: Label 'Intermediary in triangular operations';
        Text013: Label 'Intra-community sales';

    procedure InitTable();
    var
        VATClassification: Record "VAT Classification";
    begin
        if not VATClassification.FINDFIRST then begin
            InsertData('', Text000);
            InsertData('01', Text001);
            InsertData('02', Text002);
            InsertData('03', Text003);
            InsertData('04', Text004);
            InsertData('05', Text005);
            InsertData('06', Text006);
            InsertData('07', Text007);
            InsertData('08', Text008);
            InsertData('09', Text009);
            InsertData('10', Text010);
            InsertData('11', Text011);
            InsertData('12', Text012);
            InsertData('13', Text013);
        end;
    end;

    local procedure InsertData(NewCode: Code[10]; NewDescription: Text[100]);
    var
        VATClassification: Record "VAT Classification";
    begin
        VATClassification.Code := NewCode;
        VATClassification.Description := NewDescription;
        VATClassification.INSERT;
    end;
}

