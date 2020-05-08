tableextension 46015524 "Customer Extension" extends Customer
{
    // version NAVW111.00.00.27667,NAVBG11.0,DS11.00

    fields
    {
        field(46015505; "Identification No."; Text[13])
        {
            Caption = 'Identification No.';
            Description = 'NAVBG11.0,001';

            trigger OnValidate();
            begin
                DefDim.TestIdentification("Identification No.", "Country/Region Code");
                DefDim.CheckCustIdentification("Identification No.", "No.");
            end;
        }
        field(46015506; "Excise Amount (LCY)"; Decimal)
        {
            CalcFormula = Sum ("Cust. Ledger Entry"."Excise Amount (LCY)" WHERE("Customer No." = FIELD("No."),
                                                                                "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                                "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                                "Posting Date" = FIELD("Date Filter"),
                                                                                "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Excise Amount (LCY)';
            Description = 'NAVBG11.0,001';
            FieldClass = FlowField;
        }
        field(46015507; "Product Tax Amount (LCY)"; Decimal)
        {
            CalcFormula = Sum ("Cust. Ledger Entry"."Product Tax Amount (LCY)" WHERE("Customer No." = FIELD("No."),
                                                                                     "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                                     "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                                     "Posting Date" = FIELD("Date Filter"),
                                                                                     "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Product Tax Amount (LCY)';
            Description = 'NAVBG11.0,001';
            FieldClass = FlowField;
        }
        field(46015605; "Registration No."; Text[20])
        {
            Caption = 'Registration No.';
            Description = 'NAVE111.0,001';

            trigger OnValidate();
            begin
                if "Registration No." <> '' then begin
                    DimValue.SETCURRENTKEY("Registration No.");
                    DimValue.SETRANGE("Registration No.", "Registration No.");
                    if DimValue.FIND('-') then
                        ERROR(Text46012225, FIELDCAPTION("Registration No."));
                    DimValue.RESET;
                end;
            end;
        }
        field(46015606; "Registration No. 2"; Text[20])
        {
            Caption = 'Registration No. 2';
            Description = 'NAVE111.0,001';
        }
        field(46015610; "Transaction Type"; Code[10])
        {
            Caption = 'Transaction Type';
            Description = 'NAVE111.0,001';
            TableRelation = "Transaction Type";
        }
        field(46015611; "Transaction Specification"; Code[10])
        {
            Caption = 'Transaction Specification';
            Description = 'NAVE111.0,001';
            TableRelation = "Transaction Specification";
        }
        field(46015612; "Transport Method"; Code[10])
        {
            Caption = 'Transport Method';
            Description = 'NAVE111.0,001';
            TableRelation = "Transport Method";
        }
        field(46015614; "Industry Code"; Code[20])
        {
            Caption = 'Industry Code';
            Description = 'NAVE111.0,001';
            TableRelation = "Industry Code";
        }
        field(46015648; "Last Statement Date"; Date)
        {
            Caption = 'Last Statement Date';
            Description = 'NAVE111.0,001';
            Editable = false;
        }
        field(46015649; "Payment Bank Account"; Code[10])
        {
            Caption = 'Payment Bank Account';
            Description = 'NAVBG11.0,001';
            TableRelation = "Bank Account";
        }
        field(46015650; "VAT BPG description"; Text[50])
        {
            Caption = 'VAT BPG description';
            Description = 'NAVBG11.0,001';
        }
        field(46015651; "Excise No."; Text[13])
        {
            Caption = 'Excise No.';
            Description = 'NAVBG11.0,001';
        }
        field(46015652; "Excise Registration Type"; Code[2])
        {
            Caption = 'Excise Registration Type';
            Description = 'NAVBG11.0,001';
            TableRelation = "Excise Registration Type";
        }
        field(46015653; "Do not calculate Excise"; Boolean)
        {
            Caption = 'Do Not Calculate Excise';
            Description = 'NAVBG11.0,001';
        }
        field(46015654; "Outbound Excise Destination"; Code[2])
        {
            Caption = 'Outbound Excise Destination';
            Description = 'NAVBG11.0,001';
            TableRelation = "Excise Destination".Code WHERE("Destination Type" = CONST(Outbound));
        }
        field(46015655; "Payment Obligation Type"; Code[2])
        {
            Caption = 'Payment Obligation Type';
            Description = 'NAVBG11.0,001';
            TableRelation = "Payment Obligation Type";
        }
    }
    keys
    {
        key(Key1; "Registration No.")
        {
        }
        key(Key2; "Industry Code")
        {
        }
        key(Key3; "Identification No.")
        {
        }
    }

    procedure GetLinkedVendor(): Code[20];
    VAR
        ContBusRel: Record "Contact Business Relation";
    BEGIN
        //NAVE111.0; 001; entire function
        ContBusRel.SETCURRENTKEY("Link to Table", "No.");
        ContBusRel.SETRANGE("Link to Table", ContBusRel."Link to Table"::Customer);
        ContBusRel.SETRANGE("No.", "No.");
        if ContBusRel.FINDFIRST then begin
            ContBusRel.SETRANGE("Contact No.", ContBusRel."Contact No.");
            ContBusRel.SETRANGE("Link to Table", ContBusRel."Link to Table"::Vendor);
            ContBusRel.SETRANGE("No.");
            if ContBusRel.FINDFIRST then
                exit(ContBusRel."No.");
        end;
    END;
    //Unsupported feature: CodeModification on "OnDelete". Please convert manually.

    //trigger OnDelete();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    ApprovalsMgmt.OnCancelCustomerApprovalRequest(Rec);

    ServiceItem.SETRANGE("Customer No.","No.");
    #4..122
    MyCustomer.DELETEALL;
    VATRegistrationLogMgt.DeleteCustomerLog(Rec);

    DimMgt.DeleteDefaultDim(DATABASE::Customer,"No.");

    CalendarManagement.DeleteCustomizedBaseCalendarData(CustomizedCalendarChange."Source Type"::Customer,"No.");
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..125

    #126..128
    */
    //end;


    //Unsupported feature: CodeModification on "OnModify". Please convert manually.

    //trigger OnModify();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    SetLastModifiedDateTime;
    if IsContactUpdateNeeded then begin
      MODIFY;
      UpdateContFromCust.OnModify(Rec);
      if not FIND then begin
        RESET;
        if FIND then;
      end;
    end;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..8
      end;
    */
    //end;

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
        DefDim: Codeunit "BG Utils";
        DimValue: Record Customer;
        GLSetup: Record "General Ledger Setup";
        DimensionValue: Record "Dimension Value";
        DefaultDimension: Record "Default Dimension";
        DimensionValue2: Record "Dimension Value";
        Text46012225: Label 'Customer with the same %1 already exists.';
}

