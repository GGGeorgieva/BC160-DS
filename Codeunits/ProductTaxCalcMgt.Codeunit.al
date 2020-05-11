codeunit 46015511 "Product Tax Calc. Mgt."
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
    // 001   mp       07.11.14                  List of changes :
    //                           NAVBG8.00      Builded from version 6.0
    // -----------------------------------------------------------------------------------------


    trigger OnRun();
    begin
    end;

    procedure CalcPackTypeTax(ItemCode : Code[20];ItemVariantCode : Code[10];ItemUnitOfMeasureCode : Code[10];PackagingType : Option Primary,Secondary,Tertiary) : Decimal;
    var
        ItemPackagingSpecification : Record "Item Packaging Specification";
    begin
        ItemPackagingSpecification.SETRANGE("Item No.",ItemCode);
        ItemPackagingSpecification.SETRANGE("Item Variant Code",ItemVariantCode);
        ItemPackagingSpecification.SETRANGE("Unit of Measure Code",ItemUnitOfMeasureCode);
        case PackagingType of
          PackagingType::Primary:
            ItemPackagingSpecification.SETRANGE("Packaging Type",ItemPackagingSpecification."Packaging Type"::Primary);
          PackagingType::Secondary:
            ItemPackagingSpecification.SETRANGE("Packaging Type",ItemPackagingSpecification."Packaging Type"::Secondary);
          PackagingType::Tertiary:
            ItemPackagingSpecification.SETRANGE("Packaging Type",ItemPackagingSpecification."Packaging Type"::Tertiary);
        end;
        ItemPackagingSpecification.CALCSUMS("Pack.Component Tax Amount");
        exit(ItemPackagingSpecification."Pack.Component Tax Amount");
    end;

    procedure CalcTotalTax(ItemCode : Code[20];ItemVariantCode : Code[10];ItemUnitOfMeasureCode : Code[10]) : Decimal;
    var
        ItemPackagingSpecification : Record "Item Packaging Specification";
        TotalTax : Decimal;
    begin
        ItemPackagingSpecification.SETRANGE("Item No.",ItemCode);
        ItemPackagingSpecification.SETRANGE("Item Variant Code",ItemVariantCode);
        ItemPackagingSpecification.SETRANGE("Unit of Measure Code",ItemUnitOfMeasureCode);
        ItemPackagingSpecification.CALCSUMS("Pack.Component Tax Amount");
        exit(ItemPackagingSpecification."Pack.Component Tax Amount");
    end;

    procedure FillPackCompSpecification();
    var
        PackComponentsSpecification : Record "Pack. Components Specification";
        ItemPackagingSpecification : Record "Item Packaging Specification";
        PackagingComponent : Record "Packaging Component";
        RowNo : Integer;
    begin
        PackComponentsSpecification.DELETEALL;

        RowNo := 0;
        if ItemPackagingSpecification.FIND('-') then
          repeat
            RowNo := RowNo + 1;
            PackComponentsSpecification.INIT;
            with ItemPackagingSpecification do begin
              PackComponentsSpecification."Row No." := RowNo;
              PackComponentsSpecification."Item No." := "Item No.";
              PackComponentsSpecification."Item Variant Code" := "Item Variant Code";
              PackComponentsSpecification."Unit of Measure Code" := "Unit of Measure Code";
              PackComponentsSpecification."Item Variant Description" := "Item Variant Description";
              PackComponentsSpecification."Packaging Type" := "Packaging Type";
              if PackagingComponent.GET("Packaging Component Code") then
                PackComponentsSpecification."Pack. Component Description" := PackagingComponent.Description;
              PackComponentsSpecification."Packaging Material Code" := "Packaging Material Code";
              PackComponentsSpecification."Pack. Component Weight (kg)" := "Pack.Component Weight (kg)";
              PackComponentsSpecification."Product Tax Amount per Kg" := "Product Tax Amount per Kg";
              PackComponentsSpecification."Pack. Component Tax Amount" := "Pack.Component Tax Amount";
              PackComponentsSpecification."Tax Amount per Pack Type" :=
                CalcPackTypeTax("Item No.","Item Variant Code","Unit of Measure Code","Packaging Type");
              PackComponentsSpecification."Total Tax Amount" :=
                CalcTotalTax("Item No.","Item Variant Code","Unit of Measure Code");
            end;
            PackComponentsSpecification.INSERT;
          until ItemPackagingSpecification.NEXT = 0;
    end;

    procedure FillProductTaxMonthDeclaration(StartingDate : Date;EndingDate : Date);
    var
        ProductTaxMonthDeclaration : Record "Product Tax Month. Declaration";
        SalesInvoiceHeader : Record "Sales Invoice Header";
        SalesInvoiceLine : Record "Sales Invoice Line";
        SalesCrMemoHeader : Record "Sales Cr.Memo Header";
        SalesCrMemoLine : Record "Sales Cr.Memo Line";
        PackComponentsSpecification : Record "Pack. Components Specification";
        ItemPackagingSpecification : Record "Item Packaging Specification";
    begin
        if StartingDate > EndingDate then
          ERROR('');

        FillPackCompSpecification();

        ProductTaxMonthDeclaration.DELETEALL;

        SalesInvoiceHeader.SETRANGE("Posting Date",StartingDate,EndingDate);
        if SalesInvoiceHeader.FIND('-') then
          repeat
            if SalesInvoiceHeader."Calculate Product Tax" then begin
              SalesInvoiceLine.RESET;
              SalesInvoiceLine.SETRANGE("Document No.",SalesInvoiceHeader."No.");
              if SalesInvoiceLine.FIND('-') then
                repeat
                  if (SalesInvoiceLine."Calculate Product Tax") and (SalesInvoiceLine.Type = SalesInvoiceLine.Type::Item) then begin
                    ProductTaxMonthDeclaration.INIT;
                    with SalesInvoiceLine do begin
                      ProductTaxMonthDeclaration."Document No." := "Document No.";
                      ProductTaxMonthDeclaration."Line No." := "Line No.";
                      ProductTaxMonthDeclaration."Posting Date" := SalesInvoiceHeader."Posting Date";
                      PackComponentsSpecification.RESET;
                      PackComponentsSpecification.SETRANGE("Item No.","No.");
                      PackComponentsSpecification.SETRANGE("Item Variant Code","Variant Code");
                      PackComponentsSpecification.SETRANGE("Unit of Measure Code","Unit of Measure Code");
                      if PackComponentsSpecification.FIND('-') then
                        ProductTaxMonthDeclaration."Specification Row No." := PackComponentsSpecification."Row No.";
                      ProductTaxMonthDeclaration."Quantity of Packed Goods" := Quantity;
                      ProductTaxMonthDeclaration."Amount of the Product Tax" := "Product Tax Amount (LCY)";
                    end;
                    ProductTaxMonthDeclaration.INSERT;
                  end;
                until SalesInvoiceLine.NEXT = 0;
            end;
          until SalesInvoiceHeader.NEXT = 0;

        SalesCrMemoHeader.SETRANGE("Posting Date",StartingDate,EndingDate);
        if SalesCrMemoHeader.FIND('-') then
          repeat
            if SalesCrMemoHeader."Calculate Product Tax" then begin
              SalesCrMemoLine.RESET;
              SalesCrMemoLine.SETRANGE("Document No.",SalesCrMemoHeader."No.");
              if SalesCrMemoLine.FIND('-') then
                repeat
                  if (SalesCrMemoLine."Calculate Product Tax") and (SalesCrMemoLine.Type = SalesCrMemoLine.Type::Item) then begin
                    ProductTaxMonthDeclaration.INIT;
                    with SalesCrMemoLine do begin
                      ProductTaxMonthDeclaration."Document No." := "Document No.";
                      ProductTaxMonthDeclaration."Line No." := "Line No.";
                      ProductTaxMonthDeclaration."Posting Date" := SalesCrMemoHeader."Posting Date";
                      PackComponentsSpecification.RESET;
                      PackComponentsSpecification.SETRANGE("Item No.","No.");
                      PackComponentsSpecification.SETRANGE("Item Variant Code","Variant Code");
                      PackComponentsSpecification.SETRANGE("Unit of Measure Code","Unit of Measure Code");
                      if PackComponentsSpecification.FIND('-') then
                        ProductTaxMonthDeclaration."Specification Row No." := PackComponentsSpecification."Row No.";
                      ProductTaxMonthDeclaration."Quantity of Packed Goods" := -1 * Quantity;
                      ProductTaxMonthDeclaration."Amount of the Product Tax" := -1 * "Product Tax Amount (LCY)";
                    end;
                    ProductTaxMonthDeclaration.INSERT;
                  end;
                until SalesCrMemoLine.NEXT = 0;
            end;
          until SalesCrMemoHeader.NEXT = 0;

        PackComponentsSpecification.DELETEALL;
    end;

    procedure FillProductTaxYearlyDeclaratio(StartingDate : Date;EndingDate : Date);
    var
        ProductTaxYearlyDeclaration : Record "Product Tax Yearly Declaration";
        SalesInvoiceHeader : Record "Sales Invoice Header";
        SalesInvoiceLine : Record "Sales Invoice Line";
        SalesCrMemoHeader : Record "Sales Cr.Memo Header";
        SalesCrMemoLine : Record "Sales Cr.Memo Line";
        ItemPackagingSpecification : Record "Item Packaging Specification";
    begin
        if StartingDate > EndingDate then
          ERROR('');

        ProductTaxYearlyDeclaration.DELETEALL;

        SalesInvoiceHeader.SETRANGE("Posting Date",StartingDate,EndingDate);
        if SalesInvoiceHeader.FIND('-') then
          repeat
            if SalesInvoiceHeader."Calculate Product Tax" then begin
              SalesInvoiceLine.RESET;
              SalesInvoiceLine.SETRANGE("Document No.",SalesInvoiceHeader."No.");
              if SalesInvoiceLine.FIND('-') then
                repeat
                  if (SalesInvoiceLine."Calculate Product Tax") and (SalesInvoiceLine.Type = SalesInvoiceLine.Type::Item) then begin
                    ProductTaxYearlyDeclaration.INIT;
                    with SalesInvoiceLine do begin
                      ProductTaxYearlyDeclaration."Document No." := "Document No.";
                      ProductTaxYearlyDeclaration."Line No." := "Line No.";
                      ProductTaxYearlyDeclaration."Posting Date" := SalesInvoiceHeader."Posting Date";
                      ProductTaxYearlyDeclaration."Amount of the Product Tax" := "Product Tax Amount (LCY)";
                      ItemPackagingSpecification.RESET;
                      ItemPackagingSpecification.SETRANGE("Item No.","No.");
                      ItemPackagingSpecification.SETRANGE("Item Variant Code","Variant Code");
                      ItemPackagingSpecification.SETRANGE("Unit of Measure Code","Unit of Measure Code");
                      CalculateMaterialTypesWeight(ProductTaxYearlyDeclaration,ItemPackagingSpecification,Quantity);
                    end;
                    ProductTaxYearlyDeclaration.INSERT;
                  end;
                until SalesInvoiceLine.NEXT = 0;
            end;
          until SalesInvoiceHeader.NEXT = 0;

        SalesCrMemoHeader.SETRANGE("Posting Date",StartingDate,EndingDate);
        if SalesCrMemoHeader.FIND('-') then
          repeat
            if SalesCrMemoHeader."Calculate Product Tax" then begin
              SalesCrMemoLine.RESET;
              SalesCrMemoLine.SETRANGE("Document No.",SalesCrMemoHeader."No.");
              if SalesCrMemoLine.FIND('-') then
                repeat
                  if (SalesCrMemoLine."Calculate Product Tax") and (SalesCrMemoLine.Type = SalesCrMemoLine.Type::Item) then begin
                    ProductTaxYearlyDeclaration.INIT;
                    with SalesCrMemoLine do begin
                      ProductTaxYearlyDeclaration."Document No." := "Document No.";
                      ProductTaxYearlyDeclaration."Line No." := "Line No.";
                      ProductTaxYearlyDeclaration."Posting Date" := SalesCrMemoHeader."Posting Date";
                      ProductTaxYearlyDeclaration."Amount of the Product Tax" := -1 * "Product Tax Amount (LCY)";
                      ItemPackagingSpecification.RESET;
                      ItemPackagingSpecification.SETRANGE("Item No.","No.");
                      ItemPackagingSpecification.SETRANGE("Item Variant Code","Variant Code");
                      ItemPackagingSpecification.SETRANGE("Unit of Measure Code","Unit of Measure Code");
                      CalculateMaterialTypesWeight(ProductTaxYearlyDeclaration,ItemPackagingSpecification,Quantity);
                      ProductTaxYearlyDeclaration.Plastic := -1 * ProductTaxYearlyDeclaration.Plastic;
                      ProductTaxYearlyDeclaration."Paper and Cardboard" := -1 * ProductTaxYearlyDeclaration."Paper and Cardboard";
                      ProductTaxYearlyDeclaration.Metals := -1 * ProductTaxYearlyDeclaration.Metals;
                      ProductTaxYearlyDeclaration.Aluminium := -1 * ProductTaxYearlyDeclaration.Aluminium;
                      ProductTaxYearlyDeclaration.Glass := -1 * ProductTaxYearlyDeclaration.Glass;
                      ProductTaxYearlyDeclaration.Wood := -1 * ProductTaxYearlyDeclaration.Wood;
                      ProductTaxYearlyDeclaration.Others := -1 * ProductTaxYearlyDeclaration.Others;
                    end;
                    ProductTaxYearlyDeclaration.INSERT;
                  end;
                until SalesCrMemoLine.NEXT = 0;
            end;
          until SalesCrMemoHeader.NEXT = 0;
    end;

    procedure CalculateMaterialTypesWeight(var ProductTaxYearlyDeclaration : Record "Product Tax Yearly Declaration";var ItemPackagingSpecification : Record "Item Packaging Specification";Quantity : Decimal);
    var
        PackagingMaterialType : Record "Packaging Material Type";
    begin
        ProductTaxYearlyDeclaration.Plastic := 0;
        ProductTaxYearlyDeclaration."Paper and Cardboard" := 0;
        ProductTaxYearlyDeclaration.Metals := 0;
        ProductTaxYearlyDeclaration.Aluminium := 0;
        ProductTaxYearlyDeclaration.Glass := 0;
        ProductTaxYearlyDeclaration.Wood := 0;
        ProductTaxYearlyDeclaration.Others := 0;

        if ItemPackagingSpecification.FIND('-') then
          repeat
            if PackagingMaterialType.GET(ItemPackagingSpecification."Packaging Material Type Code") then begin
              with PackagingMaterialType do begin
                case Name of
                  Name::Plastic:
                    ProductTaxYearlyDeclaration.Plastic := ProductTaxYearlyDeclaration.Plastic +
                      Quantity * ItemPackagingSpecification."Pack.Component Weight (kg)";
                  Name::"Paper and Cardboard":
                    ProductTaxYearlyDeclaration."Paper and Cardboard" := ProductTaxYearlyDeclaration."Paper and Cardboard" +
                     Quantity * ItemPackagingSpecification."Pack.Component Weight (kg)";
                  Name::Metals:
                    ProductTaxYearlyDeclaration.Metals := ProductTaxYearlyDeclaration.Metals +
                      Quantity * ItemPackagingSpecification."Pack.Component Weight (kg)";
                  Name::Aluminium:
                    ProductTaxYearlyDeclaration.Aluminium := ProductTaxYearlyDeclaration.Aluminium +
                      Quantity * ItemPackagingSpecification."Pack.Component Weight (kg)";
                  Name::Glass:
                    ProductTaxYearlyDeclaration.Glass := ProductTaxYearlyDeclaration.Glass +
                      Quantity * ItemPackagingSpecification."Pack.Component Weight (kg)";
                  Name::Wood:
                    ProductTaxYearlyDeclaration.Wood := ProductTaxYearlyDeclaration.Wood +
                      Quantity * ItemPackagingSpecification."Pack.Component Weight (kg)";
                  Name::Others:
                    ProductTaxYearlyDeclaration.Others := ProductTaxYearlyDeclaration.Others +
                      Quantity * ItemPackagingSpecification."Pack.Component Weight (kg)";
                end;
              end;
            end;
          until ItemPackagingSpecification.NEXT = 0;
    end;
}

