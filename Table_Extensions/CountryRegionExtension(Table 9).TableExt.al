tableextension 46015608 "Country/Region Extension" extends "Country/Region"
{
    procedure IsIntrastat(CountryRegionCode: Code[10]; ShipTo: Boolean): Boolean;
    VAR
        CompanyInfo: Record "Company Information";
    BEGIN
        if CountryRegionCode = '' then
            exit(false);

        GET(CountryRegionCode);
        if "Intrastat Code" = '' then
            exit(false);

        CompanyInfo.GET;

        if CompanyInfo."Ship-to Country/Region Code" <> '' then
            exit(CountryRegionCode <> CompanyInfo."Ship-to Country/Region Code");
        exit(CountryRegionCode <> CompanyInfo."Country/Region Code");
    END;

}

