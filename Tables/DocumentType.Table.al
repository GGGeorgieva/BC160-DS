table 46015511 "Document Type"
{
    // version NAVBG11.0

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
    // 
    // -----------------------------------------------------------------------------------------
    // Dynamic Solutions
    // MS Dynamics NAV 2017 Localisation
    // 
    // 
    // -----------------------------------------------------------------------------------------
    // No.   Sign     Date       Version        Description
    // -----------------------------------------------------------------------------------------
    // 001                                     List of changes :
    //                          NAVBG11.0     Changed the lenght of the filed Description from 30 to 250
    //                          NAVBG11.0     Changed function:  GetDocTypeDescription()
    // -----------------------------------------------------------------------------------------

    Caption = 'Document Type';
    //LookupPageID = "Document Types";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[250])
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
        Text001: Label 'Invoice';
        Text002: Label 'Debit Memo';
        Text003: Label 'Credit Memo';
        Text004: Label 'TaxInv.';
        Text005: Label 'TaxD.Memo';
        Text006: Label 'TaxCr.Memo';
        Text007: Label 'Cust.Decl.';
        Text008: Label 'Sales Stat.';
        Text009: Label 'Protocol ot other document';
        Text011: Label 'Invoice - Cash Accounting';
        Text012: Label 'Debit Memo - Casg Accounting';
        Text013: Label 'Credit Memo - Cash Accounting';
        Text014: Label 'VoidTaxInv.';
        Text015: Label 'VoidTaxD.Memo';
        Text016: Label 'VoidTaxCr.Memo';
        Text017: Label 'VoidCust.Decl.';
        Text018: Label 'VoidSales Stat.';
        Text019: Label 'VoidProtocol';
        Text91: Label 'Prot. of chargeable tax under Art. 151c (3) of the VAT Act';
        Text92: Label 'Prot. of credit for input tax under Art. 151d (8) of the law';
        Text93: Label 'art 151v(7) with a recip. who does not apply the regime';
        Text94: Label 'art 151v(8), with a recip. who applying the regime';
        Text95: Label 'Prot. on the free provision of foodstuffs,Art. 6(4), item 4';
        Text81: Label 'Sales Statement';
        Text82: Label 'Statement of sales under a special taxation';

    procedure GetDocTypeDescription(Type: Code[10]): Code[60];
    begin
        case Type of
            '01':
                exit(Text001);
            '02':
                exit(Text002);
            '03':
                exit(Text003);
            //  '04' : EXIT(Text004);    //NAVBG11.0
            //  '05' : EXIT(Text005);    //NAVBG11.0
            //  '06' : EXIT(Text006);    //NAVBG11.0
            '07':
                exit(Text007);
            //  '08' : EXIT(Text008);    //NAVBG11.0
            '09':
                exit(Text009);
            '11':
                exit(Text011);
            '12':
                exit(Text012);
            '13':
                exit(Text013);
            //  '14' : EXIT(Text014);    //NAVBG11.0
            //  '15' : EXIT(Text015);    //NAVBG11.0
            //  '16' : EXIT(Text016);    //NAVBG11.0
            //  '17' : EXIT(Text017);    //NAVBG11.0
            //  '18' : EXIT(Text018);    //NAVBG11.0
            //  '19' : EXIT(Text019);    //NAVBG11.0
            '91':
                exit(Text91);       //NAVBG11.0
            '92':
                exit(Text92);       //NAVBG11.0
            '93':
                exit(Text93);       //NAVBG11.0
            '94':
                exit(Text94);       //NAVBG11.0
            '95':
                exit(Text95);       //NAVBG11.0
            '81':
                exit(Text81);       //NAVBG11.0
            '82':
                exit(Text82);       //NAVBG11.0
        end;
    end;

    procedure InitDocTypes();
    var
        I: Integer;
    begin
        DELETEALL;
        //FOR I := 1 TO 19 DO BEGIN    //NAVBG11.0
        for I := 1 to 95 do begin      //NAVBG11.0
            INIT;
            if I < 10 then
                Code := '0' + FORMAT(I)
            else
                Code := FORMAT(I);
            Description := GetDocTypeDescription(Code);
            if Description <> '' then
                INSERT;
        end;
    end;
}

