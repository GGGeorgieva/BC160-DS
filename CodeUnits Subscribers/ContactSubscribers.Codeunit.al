codeunit 46015804 "Contact Subscribers"
{
    [EventSubscriber(ObjectType::Table, Database::Contact, 'OnBeforeIsUpdateNeeded', '', true, true)]
    local procedure CalcUpdateNeeded(Contact: Record Contact; xContact: Record Contact; var UpdateNeeded: Boolean)
    begin
        UpdateNeeded :=
              (Contact.Name <> xContact.Name) or
              (Contact."Search Name" <> xContact."Search Name") or
              (Contact."Name 2" <> xContact."Name 2") or
              (Contact.Address <> xContact.Address) or
              (Contact."Address 2" <> xContact."Address 2") or
              (Contact.City <> xContact.City) or
              (Contact."Phone No." <> xContact."Phone No.") or
              (Contact."Telex No." <> xContact."Telex No.") or
              (Contact."Territory Code" <> xContact."Territory Code") or
              (Contact."Currency Code" <> xContact."Currency Code") or
              (Contact."Language Code" <> xContact."Language Code") or
              (Contact."Salesperson Code" <> xContact."Salesperson Code") or
              (Contact."Country/Region Code" <> xContact."Country/Region Code") or
              (Contact."Fax No." <> xContact."Fax No.") or
              (Contact."Telex Answer Back" <> xContact."Telex Answer Back") or
              (Contact."VAT Registration No." <> xContact."VAT Registration No.") or
              (Contact."Post Code" <> xContact."Post Code") or
              (Contact.County <> xContact.County) or
              (Contact."E-Mail" <> xContact."E-Mail") or
              (Contact."Home Page" <> xContact."Home Page")
              or (Contact."Registration No." <> xContact."Registration No.") or
              (Contact."Registration No. 2" <> xContact."Registration No. 2")
    end;
}