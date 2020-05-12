tableextension 46015592 "Service Header Extension" extends "Service Header"
{
    fields
    {
        modify("Customer Posting Group")
        {
            trigger OnBeforeValidate()
            var
                ServiceMgmtSetup: Record "Service Mgt. Setup";
                SubstCustPostingGrp: Record "Subst. Customer Posting Group";

            begin
                if (CurrFieldNo = FIELDNO("Customer Posting Group")) and ("Customer Posting Group" <> xRec."Customer Posting Group") then begin
                    ServiceMgmtSetup.GET;
                    if ServiceMgmtSetup."Allow Alter Cust. Post. Groups" then begin
                        if not SubstCustPostingGrp.GET(xRec."Customer Posting Group", "Customer Posting Group") then
                            ERROR(Text46012225, xRec."Customer Posting Group", "Customer Posting Group", SubstCustPostingGrp.TABLECAPTION);
                    end else
                        ERROR(Text46012226, FIELDCAPTION("Customer Posting Group"), ServiceMgmtSetup.FIELDCAPTION("Allow Alter Cust. Post. Groups"));
                end;
            end;
        }
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

            trigger OnValidate();
            var
                GLSetup: Record "General Ledger Setup";
            begin
                GLSetup.Get();
                if not GLSetup."Use VAT Date" then
                    TESTFIELD("VAT Date", "Posting Date");
                if "VAT Date" <> xRec."VAT Date" then
                    UpdateServLines(FieldNo("VAT Date"), false);
            end;
        }
        field(46015611; "Postponed VAT"; Boolean)
        {
            Caption = 'Postponed VAT';
            Description = 'NAVE111.0,001';
        }
        field(46015630; "Posting Desc. Code"; Code[10])
        {
            Caption = 'Posting Desc. Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Posting Description" WHERE(Type = CONST("Service Document"));

            trigger OnValidate();
            begin
                GetPostingDescription("Posting Desc. Code", "Posting Description");
            end;
        }
    }

    trigger OnBeforeInsert();
    var
        ServSetup: Record "Service Mgt. Setup";
    begin
        ServSetup.Get();
        VALIDATE("Posting Desc. Code", ServSetup."Posting Desc. Code");
    end;

    trigger OnBeforeModify();
    begin
        VALIDATE("Posting Desc. Code");
    end;

    var

        Text46012225: Label 'You cannot change the %1 to %2 because %3 has not been filled in.';
        Text46012226: Label 'You cannot change %1 until %2 will be checked in setup.';
        Text016: Label 'You have modified %1.\Do you want to update the service lines?';
        ServLine: Record "Service Line";
        ServItemLine: Record "Service Item Line";

    PROCEDURE GetPostingDescription(PostingDescCode: Code[10]; VAR PostingDescription: Text[50]);
    VAR
        PostingDesc: Record "Posting Description";
        RecordReference: RecordRef;
    BEGIN
        //NAVE111.0; 001; entire function
        if PostingDesc.GET(PostingDescCode) then begin
            PostingDesc.TESTFIELD(Type, PostingDesc.Type::"Service Document");
            RecordReference.OPEN(DATABASE::"Service Header");
            RecordReference.GETTABLE(Rec);
            PostingDescription := PostingDesc.ParsePostDescString(PostingDesc, RecordReference);
        end;
    end;

    procedure UpdateServLines(ChangedFieldNo: Integer; AskQuestion: Boolean)
    var
        "Field": Record "Field";
        ConfirmManagement: Codeunit "Confirm Management";
        Question: Text[250];
    begin
        Field.Get(DATABASE::"Service Header", ChangedFieldNo);

        if ServLineExists and AskQuestion then begin
            Question := StrSubstNo(
                Text016,
                Field."Field Caption");
            if not ConfirmManagement.GetResponseOrDefault(Question, true) then
                exit
        end;

        if ServLineExists then begin
            ServLine.LockTable();
            ServLine.Reset();
            ServLine.SetRange("Document Type", "Document Type");
            ServLine.SetRange("Document No.", "No.");

            ServLine.SetRange("Quantity Shipped", 0);
            ServLine.SetRange("Quantity Invoiced", 0);
            ServLine.SetRange("Quantity Consumed", 0);
            ServLine.SetRange("Shipment No.", '');

            if ServLine.Find('-') then
                repeat
                    case ChangedFieldNo of
                        FieldNo("Currency Factor"):
                            if (ServLine."Posting Date" = "Posting Date") and (ServLine.Type <> ServLine.Type::" ") then begin
                                ServLine.Validate("Unit Price");
                                ServLine.Modify(true);
                            end;
                        FieldNo("Posting Date"):
                            begin
                                ServLine.Validate("Posting Date", "Posting Date");
                                ServLine.Modify(true);
                            end;
                        FieldNo("Responsibility Center"):
                            begin
                                ServLine.Validate("Responsibility Center", "Responsibility Center");
                                ServLine.Modify(true);
                                ServItemLine.Reset();
                                ServItemLine.SetRange("Document Type", "Document Type");
                                ServItemLine.SetRange("Document No.", "No.");
                                if ServItemLine.Find('-') then
                                    repeat
                                        ServItemLine.Validate("Responsibility Center", "Responsibility Center");
                                        ServItemLine.Modify(true);
                                    until ServItemLine.Next = 0;
                            end;
                        FieldNo("Order Date"):
                            begin
                                ServLine."Order Date" := "Order Date";
                                ServLine.Modify(true);
                            end;
                        FieldNo("Transaction Type"):
                            begin
                                ServLine.Validate("Transaction Type", "Transaction Type");
                                ServLine.Modify(true);
                            end;
                        FieldNo("Transport Method"):
                            begin
                                ServLine.Validate("Transport Method", "Transport Method");
                                ServLine.Modify(true);
                            end;
                        FieldNo("Exit Point"):
                            begin
                                ServLine.Validate("Exit Point", "Exit Point");
                                ServLine.Modify(true);
                            end;
                        FieldNo(Area):
                            begin
                                ServLine.Validate(Area, Area);
                                ServLine.Modify(true);
                            end;
                        FieldNo("Transaction Specification"):
                            begin
                                ServLine.Validate("Transaction Specification", "Transaction Specification");
                                ServLine.Modify(true);
                            end;
                        FieldNo("Shipping Agent Code"):
                            begin
                                ServLine.Validate("Shipping Agent Code", "Shipping Agent Code");
                                ServLine.Modify(true);
                            end;
                        FieldNo("Shipping Time"):
                            begin
                                ServLine.Validate("Shipping Time", "Shipping Time");
                                ServLine.Modify(true);
                            end;
                        FieldNo("Shipping Agent Service Code"):
                            begin
                                ServLine.Validate("Shipping Agent Service Code", "Shipping Agent Service Code");
                                ServLine.Modify(true);
                            end;
                        else
                            OnUpdateServLineByChangedFieldName(Rec, ServLine, Field."Field Caption");
                    end;
                until ServLine.Next = 0;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUpdateServLineByChangedFieldName(ServiceHeader: Record "Service Header"; var ServiceLine: Record "Service Line"; ChangedFieldName: Text[100])
    begin
    end;
}

