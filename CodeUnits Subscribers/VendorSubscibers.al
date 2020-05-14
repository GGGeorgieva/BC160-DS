codeunit 46015811 "Vendor Subscibers"
{
    [EventSubscriber(ObjectType::Table, database::Vendor, 'OnBeforeIsContactUpdateNeeded', '', true, true)]
    local procedure IsContactUpdateNeededBG(var UpdateNeeded: Boolean; Vendor: Record Vendor; xVendor: Record Vendor)
    begin
        UpdateNeeded :=
                            (Vendor.Name <> xVendor.Name) or
                            (Vendor."Search Name" <> xVendor."Search Name") or
                            (Vendor."Name 2" <> xVendor."Name 2") or
                            (Vendor.Address <> xVendor.Address) or
                            (Vendor."Address 2" <> xVendor."Address 2") or
                            (Vendor.City <> xVendor.City) or
                            (Vendor."Phone No." <> xVendor."Phone No.") or
                            (Vendor."Telex No." <> xVendor."Telex No.") or
                            (Vendor."Territory Code" <> xVendor."Territory Code") or
                            (Vendor."Currency Code" <> xVendor."Currency Code") or
                            (Vendor."Language Code" <> xVendor."Language Code") or
                            (Vendor."Purchaser Code" <> xVendor."Purchaser Code") or
                            (Vendor."Country/Region Code" <> xVendor."Country/Region Code") or
                            (Vendor."Fax No." <> xVendor."Fax No.") or
                            (Vendor."Telex Answer Back" <> xVendor."Telex Answer Back") or
                            (Vendor."VAT Registration No." <> xVendor."VAT Registration No.") or
                            (Vendor."Post Code" <> xVendor."Post Code") or
                            (Vendor.County <> xVendor.County) or
                            (Vendor."E-Mail" <> xVendor."E-Mail") or
                            (Vendor."Home Page" <> xVendor."Home Page")
                            or (Vendor."Registration No." <> xVendor."Registration No.") or
                            (Vendor."Registration No. 2" <> xVendor."Registration No. 2")
    end;
}
