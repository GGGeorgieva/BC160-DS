codeunit 46015805 "Customer Subscribers"
{
    [EventSubscriber(ObjectType::Table, Database::"Customer", 'OnBeforeIsContactUpdateNeeded', '', true, true)]
    local procedure CalcUpdateNeeded(Customer: Record Customer; xCustomer: Record Customer; var UpdateNeeded: Boolean)
    var
        CustContUpdate: Codeunit "CustCont-Update";
    begin
        UpdateNeeded :=
            (Customer.Name <> xCustomer.Name) or
            (Customer."Search Name" <> xCustomer."Search Name") or
            (Customer."Name 2" <> xCustomer."Name 2") or
            (Customer.Address <> xCustomer.Address) or
            (Customer."Address 2" <> xCustomer."Address 2") or
            (Customer.City <> xCustomer.City) or
            (Customer."Phone No." <> xCustomer."Phone No.") or
            (Customer."Telex No." <> xCustomer."Telex No.") or
            (Customer."Territory Code" <> xCustomer."Territory Code") or
            (Customer."Currency Code" <> xCustomer."Currency Code") or
            (Customer."Language Code" <> xCustomer."Language Code") or
            (Customer."Salesperson Code" <> xCustomer."Salesperson Code") or
            (Customer."Country/Region Code" <> xCustomer."Country/Region Code") or
            (Customer."Fax No." <> xCustomer."Fax No.") or
            (Customer."Telex Answer Back" <> xCustomer."Telex Answer Back") or
            (Customer."VAT Registration No." <> xCustomer."VAT Registration No.") or
            (Customer."Post Code" <> xCustomer."Post Code") or
            (Customer.County <> xCustomer.County) or
            (Customer."E-Mail" <> xCustomer."E-Mail") or
            (Customer."Home Page" <> xCustomer."Home Page") or
            (Customer.Contact <> xCustomer.Contact)
            or (Customer."Registration No." <> xCustomer."Registration No.") or
            (Customer."Registration No. 2" <> xCustomer."Registration No. 2");
        if not UpdateNeeded and not Customer.ISTEMPORARY then
            UpdateNeeded := CustContUpdate.ContactNameIsBlank(Customer."No.");
    end;
}