tableextension 46015593 "Service Line Extension" extends "Service Line"
{
    fields
    {
        field(46015610; "VAT Date"; Date)
        {
            Caption = 'VAT Date';
            Description = 'NAVE111.0,001';

            trigger OnValidate();
            var
                GetGLSetup: Record "General Ledger Setup";
            begin
                GetGLSetup.Get();
                if CurrFieldNo = FIELDNO("VAT Date") then begin
                    if not GLSetup."Allow VAT Date Change in Lines" then
                        ERROR(Text46012225,
                        GLSetup.FIELDCAPTION("Allow VAT Date Change in Lines"),
                        GLSetup.TABLECAPTION, FIELDCAPTION("VAT Date"));
                end;
            end;
        }
    }
    var
        Text050: Label '\The entered information may be disregarded by warehouse operations.';
        Text020: Label 'Change %1 from %2 to %3?';
        GLSetupRead: Boolean;
        GLSetup: Record "General Ledger Setup";
        Text46012225: Label 'You must check field %1 in %2 to be able to change the %3 field manually.';

    PROCEDURE ItemAvailability(AvailabilityType: Option "Date","Variant","Location","Bin");
    VAR
        ItemAvailByDate: Page "Item Availability by Periods";
        ItemAvailByVar: Page "Item Availability by Variant";
        ItemAvailByLoc: Page "Item Availability by Location";
        Item: Record Item;
        ServHeader: Record "Service Header";
    BEGIN
        //NAVE111.0; 001; entire function
        GetServHeader;
        TESTFIELD(Type, Type::Item.AsInteger());
        TESTFIELD("No.");
        Item.RESET;
        Item.GET("No.");
        Item.SETRANGE("No.", "No.");
        Item.SETRANGE("Date Filter", 0D, ServHeader."Response Date");

        case AvailabilityType of
            AvailabilityType::Date:
                begin
                    Item.SETRANGE("Variant Filter", "Variant Code");
                    Item.SETRANGE("Location Filter", "Location Code");
                    CLEAR(ItemAvailByDate);
                    ItemAvailByDate.SETRECORD(Item);
                    ItemAvailByDate.SETTABLEVIEW(Item);
                    ItemAvailByDate.RUNMODAL;
                end;
            AvailabilityType::Variant:
                begin
                    Item.SETRANGE("Location Filter", "Location Code");
                    CLEAR(ItemAvailByVar);
                    ItemAvailByVar.LOOKUPMODE(true);
                    ItemAvailByVar.SETRECORD(Item);
                    ItemAvailByVar.SETTABLEVIEW(Item);
                    if ItemAvailByVar.RUNMODAL = ACTION::LookupOK then
                        if "Variant Code" <> ItemAvailByVar.GetLastVariant then
                            if
                               CONFIRM(
                                 Text020, true, FIELDCAPTION("Variant Code"), "Variant Code",
                                 ItemAvailByVar.GetLastVariant)
                            then
                                VALIDATE("Variant Code", ItemAvailByVar.GetLastVariant);
                end;
            AvailabilityType::Location:
                begin
                    Item.SETRANGE("Variant Filter", "Variant Code");
                    CLEAR(ItemAvailByLoc);
                    ItemAvailByLoc.LOOKUPMODE(true);
                    ItemAvailByLoc.SETRECORD(Item);
                    ItemAvailByLoc.SETTABLEVIEW(Item);
                    if ItemAvailByLoc.RUNMODAL = ACTION::LookupOK then
                        if "Location Code" <> ItemAvailByLoc.GetLastLocation then
                            if
                               CONFIRM(
                                 Text020, true, FIELDCAPTION("Location Code"), "Location Code",
                                 ItemAvailByLoc.GetLastLocation)
                            then
                                VALIDATE("Location Code", ItemAvailByLoc.GetLastLocation);
                end;
        end;
    END;

    PROCEDURE GetGLSetup();
    BEGIN
        if not GLSetupRead then
            GLSetup.GET;
        GLSetupRead := true;
    END;
}

