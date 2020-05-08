table 46015507 "VAT Ledger"
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

    Caption = 'VAT Ledger';

    fields
    {
        field(1;Type;Option)
        {
            Caption = 'Type';
            OptionCaption = 'Purchase,Sales';
            OptionMembers = Purchase,Sales;
        }
        field(3;Description;Text[100])
        {
            Caption = 'Description';

            trigger OnValidate();
            begin
                TestStatus;
            end;
        }
        field(4;"Period Start Date";Date)
        {
            Caption = 'Period Start Date';

            trigger OnValidate();
            begin
                TestStatus;
                "Period Start Date" := CALCDATE('<-CM>',"Period Start Date");
                "Period End Date" := CALCDATE('<CM>',"Period Start Date");
                ComposeDescription();
            end;
        }
        field(5;"Period End Date";Date)
        {
            Caption = 'Period End Date';
        }
        field(6;Status;Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Released';
            OptionMembers = Open,Released;
        }
        field(9;Branch;Integer)
        {
            Caption = 'Branch';
        }
        field(10;"Coefficient Current Year";Decimal)
        {
            Caption = 'Coefficient Current Year';

            trigger OnValidate();
            begin
                TestStatus;
            end;
        }
        field(11;"Coefficient Previous Year";Decimal)
        {
            Caption = 'Coefficient Previous Year';

            trigger OnValidate();
            begin
                TestStatus;
            end;
        }
        field(14;Created;Boolean)
        {
            Caption = 'Created';
            Editable = false;
        }
        field(15;Exported;Boolean)
        {
            Caption = 'Exported';
            Editable = false;
        }
        field(20;"Authorized Person";Text[30])
        {
            Caption = 'Authorized Person';

            trigger OnValidate();
            begin
                TestStatus;
            end;
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

    trigger OnDelete();
    begin
        TestStatus;
        VATLedgerLine.SETRANGE(Type,Type);
        VATLedgerLine.SETRANGE("Period Start Date","Period Start Date");
        if VATLedgerLine.FINDFIRST then
          VATLedgerLine.DELETEALL;
    end;

    trigger OnInsert();
    begin
        TESTFIELD("Period Start Date");
    end;

    trigger OnModify();
    begin
        TESTFIELD("Period Start Date");
        TestStatus;
    end;

    trigger OnRename();
    begin
        TestStatus;
    end;

    var
        Text001 : Label 'Purchase VAT Ledger by %1';
        Text002 : Label 'Sales VAT Ledger by %1';
        VATLedgerLine : Record "VAT Ledger Line";
        ChangeLogMgt : Codeunit "Change Log Management";
        VATLedgersMgt : Codeunit "VAT Ledgers Management";
        RecRef : RecordRef;
        xRecRef : RecordRef;

    procedure ComposeDescription();
    begin
        if Type = Type::Purchase then
          Description := STRSUBSTNO(Text001,FORMAT("Period Start Date",0,'<Month Text> <Year4>'))
        else
          Description := STRSUBSTNO(Text002,FORMAT("Period Start Date",0,'<Month Text> <Year4>'));
    end;

    procedure GetPeriodDescription() : Text[100];
    begin
        exit(FORMAT("Period Start Date",0,'<Month Text> <Year4>'));
    end;

    procedure CreateVATLedger();
    begin
        TestStatus;
        TESTFIELD("Period Start Date");
        TESTFIELD("Period End Date");
        case Type of
          Type::Sales:
            VATLedgersMgt.GenerateSales(Rec);
          Type::Purchase:
            VATLedgersMgt.GeneratePurch(Rec);
        end;
    end;

    procedure PrintVATLedger();
    var
        VATLedger : Record "VAT Ledger";
    begin
        VATLedger := Rec;
        VATLedger.SETRECFILTER;
        case Type of
          Type::Sales:
            REPORT.RUNMODAL(REPORT::"Sales VAT Ledger",true,false,VATLedger);
          Type::Purchase:
            REPORT.RUNMODAL(REPORT::"Purch. VAT Ledger",true,false,VATLedger);
        end;
    end;

    procedure TestStatus();
    begin
        TESTFIELD(Status,Status::Open);
    end;

    procedure Reopen();
    begin
        if Status = Status::Released then begin
          xRecRef.GETTABLE(Rec);
          Status := Status::Open;
          MODIFY;
          RecRef.GETTABLE(Rec);
          ChangeLogMgt.LogModification(RecRef);
        end;
    end;

    procedure Release();
    begin
        if Status = Status::Open then begin
          xRecRef.GETTABLE(Rec);
          Status := Status::Released;
          MODIFY;
          RecRef.GETTABLE(Rec);
          ChangeLogMgt.LogModification(RecRef);
        end;
    end;

    procedure Lookup();
    var
        VATSalesList : Page "VAT Sales Ledger List";
        VATPurchList : Page "VAT Purch. Ledger List";
    begin
        case Type of
          Type::Sales:
            begin
              VATSalesList.LOOKUPMODE(true);
              VATSalesList.SETRECORD(Rec);
              if VATSalesList.RUNMODAL = ACTION::LookupOK then
                VATSalesList.GETRECORD(Rec);
            end;
          Type::Purchase:
            begin
              VATPurchList.LOOKUPMODE(true);
              VATPurchList.SETRECORD(Rec);
              if VATPurchList.RUNMODAL = ACTION::LookupOK then
                VATPurchList.GETRECORD(Rec);
            end;
        end;
    end;
}

