table 46015687 "Acc. Schedule Result History"
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

    Caption = 'Acc. Schedule Result History';

    fields
    {
        field(1;"Result Code";Code[20])
        {
            Caption = 'Result Code';
            TableRelation = "Acc. Schedule Result Header";
        }
        field(2;"Row No.";Integer)
        {
            Caption = 'Row No.';
        }
        field(3;"Column No.";Integer)
        {
            Caption = 'Column No.';
        }
        field(4;"Variant No.";Integer)
        {
            Caption = 'Variant No.';
        }
        field(10;"New Value";Decimal)
        {
            Caption = 'New Value';
        }
        field(11;"Old Value";Decimal)
        {
            Caption = 'Old Value';
        }
        field(12;"User ID";Code[50])
        {
            Caption = 'User ID';
        }
        field(13;"Modified DateTime";DateTime)
        {
            Caption = 'Modified DateTime';
        }
    }

    keys
    {
        key(Key1;"Result Code","Row No.","Column No.","Variant No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        "User ID" := USERID;
        "Modified DateTime" := CURRENTDATETIME;
    end;
}

