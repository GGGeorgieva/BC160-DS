table 46015505 "BG Setup"
{
    // version NAVBG11.0

    // -----------------------------------------------------------------------------------------
    // XAPT Solutions
    // MS Dynamics NAV 2015 Localisation
    // 
    // vkv : Vasil Kr Vasilev
    // version : NAVBG8.00
    // 
    // -----------------------------------------------------------------------------------------
    // No.   Sign     Date       Version        Description
    // -----------------------------------------------------------------------------------------
    // 001   vkv      27.10.14   NAVBG8.00      Created table from MS Dynamics NAV 6.00
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
    //                           NAVBG11.0      Added new field : 46015700 - Unrealized VAT Invoice Code
    //                           NAVBG11.0      Added new field : 46015701 - Unrealized VAT Debit Memo Code
    //                           NAVBG11.0      Added new field : 46015702 - Unrealized VAT Credi Memo Code
    // ------------------------------------------------------------------------------------------

    Caption = 'BG Setup';

    fields
    {
        field(1;"Primary Key";Code[10])
        {
            Caption = 'Primary Key';
        }
        field(101;"LCY Description";Text[30])
        {
            Caption = 'LCY Description';
            InitValue = 'лв.';
        }
        field(102;"LCY Fractions";Text[30])
        {
            Caption = 'LCY Fractions';
            InitValue = 'ст.';
        }
        field(103;"Local Currency Type";Option)
        {
            Caption = 'Local Currency Type';
            OptionCaption = 'Masculine,Feminine,Neuter';
            OptionMembers = Masculine,Feminine,Neuter;
        }
        field(104;"BG Country/Region Code";Code[10])
        {
            Caption = 'BG Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(105;"Skip Check for VAT Reg. No.";Boolean)
        {
            Caption = 'Skip Check for VAT Reg. No.';
            InitValue = true;
        }
        field(106;"Skip Check for Identific. No.";Boolean)
        {
            Caption = 'Skip Check for Identific. No.';
            InitValue = true;
        }
        field(107;"Skip Check for Bank Code";Boolean)
        {
            Caption = 'Skip Check for Bank Code';
            InitValue = true;
        }
        field(108;"Skip Check for Bank Acc.";Boolean)
        {
            Caption = 'Skip Check for Bank Acc.';
            InitValue = true;
        }
        field(109;"Skip Check for IDN";Boolean)
        {
            Caption = 'Skip Check for IDN';
            InitValue = true;
        }
        field(110;"Foreigner VAT Reg. No.";Text[20])
        {
            Caption = 'Foreigner VAT Reg. No.';
        }
        field(111;"Foreigner Identification No.";Text[13])
        {
            Caption = 'Foreigner Identification No.';
        }
        field(112;"Skip Check for IBAN";Boolean)
        {
            Caption = 'Skip Check for IBAN';
            InitValue = true;
        }
        field(301;"Commission 1";Text[100])
        {
            Caption = 'Commission 1';
        }
        field(302;"Commission 2";Text[100])
        {
            Caption = 'Commission 2';
        }
        field(303;"Commission 3";Text[100])
        {
            Caption = 'Commission 3';
        }
        field(402;"Manufacturer of excise goods";Boolean)
        {
            Caption = 'Manufacturer of excise goods';
        }
        field(403;"Importer of excise goods";Boolean)
        {
            Caption = 'Importer of excise goods';
        }
        field(404;"Gamble games organizer";Boolean)
        {
            Caption = 'Gamble games organizer';
        }
        field(46015700;"Unrealized VAT Invoice Code";Code[20])
        {
            Caption = 'Unrealized VAT Invoice Code';
            TableRelation = "Document Type".Code;
        }
        field(46015701;"Unrealized VAT Debit Memo Code";Code[20])
        {
            Caption = 'Unrealized VAT Debit Memo Code';
            TableRelation = "Document Type".Code;
        }
        field(46015702;"Unrealized VAT Credi Memo Code";Code[20])
        {
            Caption = 'Unrealized VAT Credi Memo Code';
            TableRelation = "Document Type".Code;
        }
    }

    keys
    {
        key(Key1;"Primary Key")
        {
        }
    }

    fieldgroups
    {
    }
}

