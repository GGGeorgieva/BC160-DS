table 46015626 "SAD Tariff"
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

    Caption = 'SAD Tariff';

    fields
    {
        field(1;"SAD No.";Code[20])
        {
            Caption = 'SAD No.';
            TableRelation = IF (Type=CONST(Import)) "Import SAD Header"
                            ELSE IF (Type=CONST(Export)) "Export SAD Header";
        }
        field(2;"Tariff No.";Code[20])
        {
            Caption = 'Tariff No.';
            TableRelation = "Tariff Number";

            trigger OnValidate();
            begin
                CheckSADStatus("SAD No.");
                TESTFIELD("Tariff No.");
            end;
        }
        field(3;Quantity;Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0:5;

            trigger OnValidate();
            begin
                CheckSADStatus("SAD No.");
                TESTFIELD("Tariff No.");
            end;
        }
        field(4;Amount;Decimal)
        {
            Caption = 'Amount';

            trigger OnValidate();
            begin
                CheckSADStatus("SAD No.");
                TESTFIELD("Tariff No.");
            end;
        }
        field(5;Type;Option)
        {
            Caption = 'Type';
            OptionCaption = 'Import,Export';
            OptionMembers = Import,Export;
        }
    }

    keys
    {
        key(Key1;"SAD No.",Type,"Tariff No.")
        {
        }
    }

    fieldgroups
    {
    }

    procedure CheckSADStatus(SADNo : Code[10]);
    var
        ImpSADHeader : Record "Import SAD Header";
        ExpSADHeader : Record "Export SAD Header";
    begin
        if Type = Type::Import then begin
          ImpSADHeader.GET(SADNo);
          ImpSADHeader.TESTFIELD(Status,ImpSADHeader.Status::Open);
        end else begin
          ExpSADHeader.GET(SADNo);
          ExpSADHeader.TESTFIELD(Status,ExpSADHeader.Status::Open);
        end;
    end;
}

