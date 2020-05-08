table 46015509 "VAT Declaration"
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

    Caption = 'VAT Declaration';

    fields
    {
        field(1;Type;Option)
        {
            Caption = 'Type';
            OptionCaption = 'Monthly VAT Declaration,VIES Declaration';
            OptionMembers = "Monthly VAT Declaration","VIES Declaration";
        }
        field(4;"Period Start Date";Date)
        {
            Caption = 'Period Start Date';

            trigger OnValidate();
            begin
                "Period Start Date" := CALCDATE('<-CM>',"Period Start Date");
            end;
        }
        field(10;"Employee ID";Text[15])
        {
            Caption = 'Employee ID';
        }
        field(11;"Employee Name";Text[150])
        {
            Caption = 'Employee Name';
        }
        field(12;"Employee Position";Text[50])
        {
            Caption = 'Employee Position';
        }
        field(13;"Employee Position Type";Option)
        {
            Caption = 'Employee Position Type';
            OptionCaption = 'Authorized Person,Procurator';
            OptionMembers = "Authorized Person",Procurator;
        }
        field(14;"Employee City";Text[50])
        {
            Caption = 'Employee City';
        }
        field(15;"Employee Post Code";Code[4])
        {
            Caption = 'Employee Post Code';
            Numeric = true;
        }
        field(16;"Employee Address";Text[150])
        {
            Caption = 'Employee Address';
        }
        field(20;"Coefficient Art.73, p.5";Decimal)
        {
            Caption = 'Coefficient Art.73, p.5';
        }
        field(21;"Annual VAT Correction";Decimal)
        {
            Caption = 'Annual VAT Correction';
        }
        field(22;"VAT Deducted Art.92,p.1";Decimal)
        {
            Caption = 'VAT Deducted Art.92,p.1';
        }
        field(23;"VAT Effectively Paid";Decimal)
        {
            Caption = 'VAT Effectively Paid';
        }
        field(24;"VAT refund.45 days-Art.91,p.2";Decimal)
        {
            Caption = 'VAT refund.45 days-Art.91,p.2';
        }
        field(25;"VAT refund.30 days-Art.91,p.3";Decimal)
        {
            Caption = 'VAT refund.30 days-Art.91,p.3';
        }
        field(26;"VAT refund.30 days-Art.91,p.4";Decimal)
        {
            Caption = 'VAT refund.30 days-Art.91,p.4';
        }
    }

    keys
    {
        key(Key1;Type,"Period Start Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        TESTFIELD("Period Start Date");
    end;

    trigger OnModify();
    begin
        TESTFIELD("Period Start Date");
    end;
}

