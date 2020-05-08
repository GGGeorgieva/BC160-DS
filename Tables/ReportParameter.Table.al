table 46015704 "Report Parameter"
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

    Caption = 'Report Parameter';

    fields
    {
        field(1;ID;Integer)
        {
            Caption = 'ID';
        }
        field(2;IntValue;Integer)
        {
            Caption = 'IntValue';
        }
        field(3;TextValue;Text[250])
        {
            Caption = 'TextValue';
        }
        field(7;DecValue;Decimal)
        {
            Caption = 'DecValue';
        }
        field(9;BoolValue;Boolean)
        {
            Caption = 'BoolValue';
        }
        field(10;DateValue;Date)
        {
            Caption = 'DateValue';
        }
        field(11;TimeValue;Time)
        {
            Caption = 'TimeValue';
        }
        field(12;DateForValue;DateFormula)
        {
            Caption = 'DateForValue';
        }
        field(13;BigIntValue;BigInteger)
        {
            Caption = 'BigIntValue';
        }
        field(14;DurationValue;Duration)
        {
            Caption = 'DurationValue';
        }
        field(15;GuidValue;Guid)
        {
            Caption = 'GuidValue';
        }
        field(16;RecIDValue;RecordID)
        {
            Caption = 'RecIDValue';
        }
        field(17;DateTimeValue;DateTime)
        {
            Caption = 'DateTimeValue';
        }
        field(18;"User ID";Code[50])
        {
            Caption = 'User ID';
            Description = 'NAVE18.00';
            TableRelation = User;
        }
        field(19;"Report ID";Integer)
        {
            Caption = 'Report ID';
        }
    }

    keys
    {
        key(Key1;"User ID","Report ID",ID)
        {
        }
    }

    fieldgroups
    {
    }
}

