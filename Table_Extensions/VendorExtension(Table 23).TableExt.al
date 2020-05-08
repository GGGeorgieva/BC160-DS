tableextension 46015528 "Vendor Extension" extends Vendor
{
    // version NAVW111.00.00.27667,NAVE111.0,NAVBG11.0

    fields
    {
        field(46015505; "Identification No."; Text[13])
        {
            Caption = 'Identification No.';
            Description = 'NAVBG11.0,001';

            trigger OnValidate();
            begin
                DefDim.TestIdentification("Identification No.", "Country/Region Code");
                DefDim.CheckVendIdentification("Identification No.", "No.");
            end;
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
        field(46015646; "Last Statement No."; Integer)
        {
            Caption = 'Last Statement No.';
            Description = 'NAVE111.0,001';
        }
        field(46015647; "Print Statements"; Boolean)
        {
            Caption = 'Print Statements';
            Description = 'NAVE111.0,001';
        }
        field(46015648; "Last Statement Date"; Date)
        {
            Caption = 'Last Statement Date';
            Description = 'NAVE111.0,001';
            Editable = false;
        }
        field(46015649; "VAT BPG description"; Text[50])
        {
            Caption = 'VAT BPG description';
            Description = 'NAVBG11.0,001';
        }
        field(46015650; "Excise No."; Text[13])
        {
            Caption = 'Excise No.';
            Description = 'NAVBG11.0,001';
        }
        field(46015651; "Excise Registration Type"; Code[2])
        {
            Caption = 'Excise Registration Type';
            Description = 'NAVBG11.0,001';
            TableRelation = "Excise Registration Type";
        }
    }


    //Unsupported feature: CodeModification on "OnDelete". Please convert manually.

    //trigger OnDelete();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    ApprovalsMgmt.OnCancelVendorApprovalRequest(Rec);

    MoveEntries.MoveVendorEntries(Rec);
    #4..62
    PurchPrepmtPct.SETRANGE("Vendor No.","No.");
    PurchPrepmtPct.DELETEALL(true);

    VATRegistrationLogMgt.DeleteVendorLog(Rec);

    IntrastatSetup.CheckDeleteIntrastatContact(IntrastatSetup."Intrastat Contact Type"::Vendor,"No.");

    CalendarManagement.DeleteCustomizedBaseCalendarData(CustomizedCalendarChange."Source Type"::Vendor,"No.");
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..65

    #66..70
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
      UpdateContFromVend.OnModify(Rec);
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
        DimValue: Record Vendor;
        DimensionValue: Record "Dimension Value";
        DefaultDimension: Record "Default Dimension";
        GLSetup: Record "General Ledger Setup";
        DimensionValue2: Record "Dimension Value";
        Text46012225: Label 'Vendor with the same %1 already exists.';
}

