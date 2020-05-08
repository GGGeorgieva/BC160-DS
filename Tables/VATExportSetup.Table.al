table 46015506 "VAT Export Setup"
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

    Caption = 'VAT Export Setup';

    fields
    {
        field(1;"Primary Key";Code[10])
        {
            Caption = 'Primary Key';
        }
        field(3;"Sales VAT Subject";Text[30])
        {
            Caption = 'Sales VAT Subject';
        }
        field(4;"Purchase VAT Subject";Text[30])
        {
            Caption = 'Purchase VAT Subject';
        }
        field(5;"VAT for Export %";Decimal)
        {
            Caption = 'VAT for Export %';
        }
        field(6;"Incl. Sales with Custom Decl.";Boolean)
        {
            Caption = 'Incl. Sales with Custom Decl.';
        }
        field(7;"Incl. Purch. with Custom Decl.";Boolean)
        {
            Caption = 'Incl. Purch. with Custom Decl.';
        }
        field(10;"Generate Date";Date)
        {
            Caption = 'Generate Date';
        }
        field(11;"Sales Generated From";Date)
        {
            Caption = 'Sales Generated From';
        }
        field(12;"Sales Generated To";Date)
        {
            Caption = 'Sales Generated To';
        }
        field(13;"Purchases Generated From";Date)
        {
            Caption = 'Purchases Generated From';
        }
        field(14;"Purchases Generated To";Date)
        {
            Caption = 'Purchases Generated To';
        }
        field(15;"Declaration Signed-Off By";Text[50])
        {
            Caption = 'Declaration Signed-Off By';
        }
        field(16;"Job Position";Text[30])
        {
            Caption = 'Job Position';
        }
        field(21;"Authorized Person";Text[50])
        {
            Caption = 'Authorized Person';
        }
        field(22;"VAT Registration Date";Date)
        {
            Caption = 'VAT Registration Date';
        }
        field(23;"Registration Expiring Date";Date)
        {
            Caption = 'Registration Expiring Date';
        }
        field(24;"Declaration File";Text[250])
        {
            Caption = 'Declaration File';
            InitValue = 'A:\DEKLAR.TXT';
        }
        field(25;"Sales File";Text[250])
        {
            Caption = 'Sales File';
            InitValue = 'A:\PRODAGBI.TXT';
        }
        field(26;"Purchases File";Text[250])
        {
            Caption = 'Purchases File';
            InitValue = 'A:\POKUPKI.TXT';
        }
        field(27;"Export Type";Option)
        {
            Caption = 'Export Type';
            OptionCaption = 'Removable Disk,Hard Disk';
            OptionMembers = "Removable Disk","Hard Disk";
        }
        field(28;"File Rotation Size (Bytes)";Integer)
        {
            BlankZero = true;
            Caption = 'File Rotation Size (Bytes)';
            MinValue = 0;
        }
        field(29;"VIES Declaration File Name";Text[250])
        {
            Caption = 'VIES Declaration File Name';
            InitValue = 'A:\VIES.TXT';
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

    trigger OnInsert();
    begin

          if "Sales VAT Subject" = '' then
            "Sales VAT Subject" := Text16200;
          if "Purchase VAT Subject" = '' then
            "Purchase VAT Subject" := Text16201;
    end;

    var
        Text16200 : Label 'SALES';
        Text16201 : Label 'PURCHASES';
}

