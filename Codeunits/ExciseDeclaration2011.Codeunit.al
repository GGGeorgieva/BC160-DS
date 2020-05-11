codeunit 46015691 "Excise Declaration 2011"
{
    // version NAVBG11.0

    // -----------------------------------------------------------------------------------------
    // Dynamic Solutions
    // MS Dynamics NAV 2017 Localisation
    // 
    // 
    // -----------------------------------------------------------------------------------------
    // No.   Sign     Date       Version        Description
    // -----------------------------------------------------------------------------------------
    // 001                        NAVBG11.0
    // -----------------------------------------------------------------------------------------
    //TODO MISSING AUTOMATION VARIABLES
    /*
        trigger OnRun();
        begin
        end;

        var
            XML: Codeunit "Excise XML DOM Management";

            xDoc: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{F5078F32-C551-11D3-89B9-0000F81FE221}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.DOMDocument30";
            xDeclaration: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
            xCustomer: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
            xDeclarer: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
            xReportingPeriod: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
            xTaxPeriod: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
            xAppliedDocuments: Automation  "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
            xExciseGoods: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
            xWarehouseStockLog: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
            xWarehouseGoods: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
            xExciseLabels: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
            FormatTxt1: Label '<Sign><Integer><Decimals><Comma,.>';
            FormatTxt2: Label '<Day,2><Month,2><Year4>';
            FormatTxt3: Label '<Integer,8><Filler Character,0>';

        procedure InitDeclaration(KindOf: Text[30]; TypeOf: Text[30]; PreparationDate: Date; CustomsOffice: Text[10]; AmountValue: Decimal): Boolean;
        var
            xNew: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
        begin
            if not ISCLEAR(xDoc) then
                exit(false);
            CREATE(xDoc, true, true);
            XML.SetNormalCase;
            xDoc.loadXML := '<?xml version="1.0" encoding="UTF-8"?><Declaration/>';
            xDeclaration := xDoc.documentElement;
            XML.AddElement(xDeclaration, 'KindOfDeclaration', KindOf, '', xNew);
            XML.AddElement(xDeclaration, 'TypeOfDeclaration', TypeOf, '', xNew);
            XML.AddElement(xDeclaration, 'IsCorrectionDeclaration', 'false', '', xNew);
            XML.AddElement(xDeclaration, 'IsDelayedReporting', 'false', '', xNew);
            XML.AddElement(xDeclaration, 'PreparationDate', FORMAT(PreparationDate, 0, FormatTxt2), '', xNew);
            XML.AddElement(xDeclaration, 'CustomsOffice', CustomsOffice, '', xNew);
            XML.AddElement(xDeclaration, 'TotalAmountOfExciseDuty', FormatExciseNum(ROUND(AmountValue, 0.01)), '', xNew);

            exit(true);
        end;

        procedure SetDeclarationCorrection(RefNumber: Text[26]);
        begin
        end;

        procedure SetDeclarationDelayed(RefNumber: Text[26]);
        begin
        end;

        procedure SetDeclarationTotalAmount(AmountValue: Decimal);
        var
            xNode: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
        begin
            XML.FindNode(xDeclaration, 'TotalAmountOfExciseDuty', xNode);
            if not ISCLEAR(xNode) then
                xNode.text := FormatExciseNum(ROUND(AmountValue, 0.01));
        end;

        procedure SaveToFile(FilePath: Text[250]);
        begin
            xDoc.save(FilePath);
        end;

        procedure SetCustomer(LegalEntity: Text[6]; SIC: Text[13]; ExciseNumber: Text[13]; NotificationNumber: Text[13]);
        var
            xNew: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
        begin
            XML.AddElement(xDeclaration, 'Customer', '', '', xCustomer);
            XML.AddElement(xCustomer, 'LegalEntity', LegalEntity, '', xNew);
            if SIC <> '' then
                XML.AddElement(xCustomer, 'SIC', SIC, '', xNew);
            if ExciseNumber <> '' then
                XML.AddElement(xCustomer, 'ExciseNumber', ExciseNumber, '', xNew);
            if NotificationNumber <> '' then
                XML.AddElement(xCustomer, 'NotificationNumber', NotificationNumber, '', xNew);
        end;

        procedure SetDeclarer(Name: Text[128]; Egn: Text[10]);
        var
            xNew: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
        begin
            XML.AddElement(xDeclaration, 'Declarer', '', '', xDeclarer);
            XML.AddElement(xDeclarer, 'Name', Name, '', xNew);
            XML.AddElement(xDeclarer, 'Egn', Egn, '', xNew);
        end;

        procedure SetReportingPeriod(ReceivingDate: Date);
        var
            xNew: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
            xTaxPeriod: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
        begin
            XML.AddElement(xDeclaration, 'ReportingPeriod', '', '', xReportingPeriod);
            XML.AddElement(xReportingPeriod, 'ReceivingDate', FORMAT(ReceivingDate, 0, FormatTxt2), '', xNew);
        end;

        procedure SetRPTaxPeriod(Start: Date; Ende: Date);
        var
            xNew: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
        begin
            XML.AddElement(xReportingPeriod, 'TaxPeriod', '', '', xTaxPeriod);
            XML.AddElement(xTaxPeriod, 'Start', FORMAT(Start, 0, FormatTxt2), '', xNew);
            XML.AddElement(xTaxPeriod, 'End', FORMAT(Ende, 0, FormatTxt2), '', xNew);
        end;

        procedure AddAppliedDocument(DocumentType: Text[2]; PurposeOfeAD: Text[2]; Description: Text[60]; DocumentNumber: Text[30]; DocumentDate: Date);
        var
            xNew: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
            xNewDoc: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
        begin
            if ISCLEAR(xAppliedDocuments) then
                XML.AddElement(xDeclaration, 'AppliedDocuments', '', '', xAppliedDocuments);

            XML.AddElement(xAppliedDocuments, 'AppliedDocument', '', '', xNewDoc);
            XML.AddElement(xNewDoc, 'DocumentType', DocumentType, '', xNew);

            if PurposeOfeAD <> '' then
                XML.AddElement(xNewDoc, 'PurposeOfeAD', PurposeOfeAD, '', xNew);

            if Description <> '' then
                XML.AddElement(xNewDoc, 'Description', Description, '', xNew);

            XML.AddElement(xNewDoc, 'DocumentNumber', DocumentNumber, '', xNew);
            XML.AddElement(xNewDoc, 'DocumentDate', FORMAT(DocumentDate, 0, FormatTxt2), '', xNew);
        end;

        procedure AddExciseGood(SequenceNumber: Integer; BrandName: Text[6]; Trademark: Text[250]; APCode: Text[4]; CNCode: Text[8]; AdditionalCode: Text[15]; Measure: Text[3]; IntendedUseOfProduct: Text[2]; Purpose: Text[3]; var xNewGood: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode");
        var
            xNew: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
        begin
            if ISCLEAR(xExciseGoods) then
                XML.AddElement(xDeclaration, 'ExciseGoods', '', '', xExciseGoods);
            XML.AddElement(xExciseGoods, 'ExciseGood', '', '', xNewGood);
            XML.AddElement(xNewGood, 'SequenceNumber', FORMAT(SequenceNumber), '', xNew);
            XML.AddElement(xNewGood, 'BrandName', BrandName, '', xNew);
            XML.AddElement(xNewGood, 'Trademark', Trademark, '', xNew);
            XML.AddElement(xNewGood, 'APCode', APCode, '', xNew);
            XML.AddElement(xNewGood, 'CNCode', CNCode, '', xNew);
            XML.AddElement(xNewGood, 'Measure', Measure, '', xNew);
            XML.AddElement(xNewGood, 'AdditionalCode', AdditionalCode, '', xNew);

            if IntendedUseOfProduct <> '' then
                XML.AddElement(xNewGood, 'IntendedUseOfProduct', IntendedUseOfProduct, '', xNew);
            if Purpose <> '' then
                XML.AddElement(xNewGood, 'Purpose', Purpose, '', xNew);
        end;

        procedure AddExciseGoodALL(SequenceNumber: Integer; BrandName: Text[6]; Trademark: Text[250]; APCode: Text[4]; CNCode: Text[8]; AdditionalCode: Text[15]; Measure: Text[3]; IntendedUseOfProduct: Text[2]; Purpose: Text[3]; QuantityOfGoods: Decimal; Degree: Decimal; PricePerPack: Decimal; Pieces: Decimal; TaxBase: Decimal; SpecificDutySmallQuantities: Decimal; ExciseDuty: Decimal; TotalAmountPrice: Decimal; ValoremDutyRate: Decimal; SpecificDuty: Decimal; ValoremDuty: Decimal; DutyAmount: Decimal; Payment: Integer; PaidDuty: Decimal; AvailableAmount: Decimal; ReceivedAmount: Decimal; UsedAmount: Decimal; RemainingAmount: Decimal; QuantityUsedEnergyProducts: Decimal);
        var
            xNew: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
            xNewGood: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
        begin
            if ISCLEAR(xExciseGoods) then
                XML.AddElement(xDeclaration, 'ExciseGoods', '', '', xExciseGoods);
            XML.AddElement(xExciseGoods, 'ExciseGood', '', '', xNewGood);
            XML.AddElement(xNewGood, 'SequenceNumber', FORMAT(SequenceNumber), '', xNew);
            XML.AddElement(xNewGood, 'BrandName', BrandName, '', xNew);
            XML.AddElement(xNewGood, 'Trademark', Trademark, '', xNew);
            XML.AddElement(xNewGood, 'APCode', APCode, '', xNew);
            XML.AddElement(xNewGood, 'CNCode', CNCode, '', xNew);
            XML.AddElement(xNewGood, 'Measure', Measure, '', xNew);
        end;

        procedure SetExciseGood_R505(AvailableAmount: Decimal; ReceivedAmount: Decimal; UsedAmount: Decimal; RemainingAmount: Decimal; QuantityUsedEnergyProducts: Decimal; var xGood: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode");
        var
            xNew: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
            xNewGood: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
        begin
            if ISCLEAR(xExciseGoods) then
                exit;
            if ISCLEAR(xGood) then
                exit;

            XML.AddElement(xGood, 'AvailableAmount', FormatExciseNum(ROUND(AvailableAmount, 0.001)), '', xNew);
            XML.AddElement(xGood, 'ReceivedAmount', FormatExciseNum(ROUND(ReceivedAmount, 0.001)), '', xNew);
            XML.AddElement(xGood, 'UsedAmount', FormatExciseNum(ROUND(UsedAmount, 0.001)), '', xNew);
            XML.AddElement(xGood, 'RemainingAmount', FormatExciseNum(ROUND(RemainingAmount, 0.001)), '', xNew);
            XML.AddElement(xGood, 'QuantityUsedEnergyProducts', FormatExciseNum(ROUND(QuantityUsedEnergyProducts, 0.001)), '', xNew);
        end;




        procedure SetExciseGoodQtyOfGoods(QuantityOfGoods: Decimal; var xGood: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode");
        var
            xNew: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
            xNewGood: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
        begin
            if ISCLEAR(xExciseGoods) then
                exit;
            if ISCLEAR(xGood) then
                exit;
            XML.AddElement(xGood, 'QuantityOfGoods', FormatExciseNum(ROUND(QuantityOfGoods, 0.001)), '', xNew);
        end;

        procedure SetExciseGoodDutyPayment(ValoremDuty: Decimal; DutyAmount: Decimal; Payment: Text[2]; PaidDuty: Decimal; var xGood: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode");
        var
            xNew: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
            xNewGood: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
        begin
            if ISCLEAR(xExciseGoods) then
                exit;
            if ISCLEAR(xGood) then
                exit;

            XML.AddElement(xGood, 'ValoremDuty', FormatExciseNum(ROUND(ValoremDuty, 0.01)), '', xNew);
            XML.AddElement(xGood, 'DutyAmount', FormatExciseNum(ROUND(DutyAmount, 0.01)), '', xNew);
            XML.AddElement(xGood, 'Payment', Payment, '', xNew);
            XML.AddElement(xGood, 'PaidDuty', FormatExciseNum(ROUND(PaidDuty, 0.01)), '', xNew);
        end;

        procedure SetExciseGoodAlcohol(Degree: Decimal; TaxBase: Decimal; ExciseDuty: Decimal; var xGood: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode");
        var
            xNew: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
            xNewGood: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
        begin
            if ISCLEAR(xExciseGoods) then
                exit;
            if ISCLEAR(xGood) then
                exit;

            XML.AddElement(xGood, 'Degree', FormatExciseNum(ROUND(Degree, 0.01)), '', xNew);
            XML.AddElement(xGood, 'TaxBase', FormatExciseNum(ROUND(TaxBase, 0.001)), '', xNew);
            XML.AddElement(xGood, 'ExciseDuty', FormatExciseNum(ROUND(ExciseDuty, 0.001)), '', xNew);
        end;

        procedure SetExciseGoodTabaco(PricePerPack: Decimal; Pieces: Decimal; SpecDutySmallQtys: Decimal; ExciseDuty: Decimal; TotalAmountPrice: Decimal; ValoremDutyRate: Decimal; SpecificDuty: Decimal; var xGood: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode");
        var
            xNew: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
            xNewGood: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
        begin
            if ISCLEAR(xExciseGoods) then
                exit;
            if ISCLEAR(xGood) then
                exit;

            XML.AddElement(xGood, 'PricePerPack', FormatExciseNum(ROUND(PricePerPack, 0.01)), '', xNew);
            XML.AddElement(xGood, 'Pieces', FormatExciseNum(ROUND(Pieces, 0.001)), '', xNew);
            XML.AddElement(xGood, 'SpecificDutySmallQuantities', FormatExciseNum(ROUND(SpecDutySmallQtys, 0.000001)), '', xNew);
            XML.AddElement(xGood, 'ExciseDuty', FormatExciseNum(ROUND(ExciseDuty, 0.000001)), '', xNew);
            XML.AddElement(xGood, 'TotalAmountPrice', FormatExciseNum(ROUND(TotalAmountPrice, 0.01)), '', xNew);
            XML.AddElement(xGood, 'ValoremDutyRate', FormatExciseNum(ROUND(ValoremDutyRate, 0.000001)), '', xNew);
            XML.AddElement(xGood, 'SpecificDuty', FormatExciseNum(ROUND(SpecificDuty, 0.01)), '', xNew);
        end;

        procedure SetExciseGoodEnergy(TaxBase: Decimal; ExciseDuty: Decimal; var xGood: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode");
        var
            xNew: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
            xNewGood: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
        begin
            if ISCLEAR(xExciseGoods) then
                exit;
            if ISCLEAR(xGood) then
                exit;
            XML.AddElement(xGood, 'TaxBase', FORMAT(ROUND(TaxBase, 0.001), 0, 1), '', xNew);
            XML.AddElement(xGood, 'ExciseDuty', FORMAT(ROUND(ExciseDuty, 0.001), 0, 1), '', xNew);
        end;

        procedure AddWarehouseGood(SeqNo: Integer; BrandName: Text[6]; TradeName: Text[250]; CNCode: Text[8]; AdditionalCode: Text[15]; APCode: Text[4]; Measure: Text[3]; InitialAmount: Decimal; FinalAmount: Decimal; TranspLosses: Decimal; StorageLosses: Decimal; var xWhGood: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode");
        var
            xNew: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
        begin

            if ISCLEAR(xWarehouseStockLog) then
                XML.AddElement(xDeclaration, 'WarehouseStockLog', '', '', xWarehouseStockLog);
            if ISCLEAR(xWarehouseGoods) then
                XML.AddElement(xWarehouseStockLog, 'WarehouseGoods', '', '', xWarehouseGoods);

            XML.AddElement(xWarehouseGoods, 'WarehouseGood', '', '', xWhGood);
            XML.AddElement(xWhGood, 'SequenceNumber', FORMAT(SeqNo), '', xNew);
            XML.AddElement(xWhGood, 'BrandName', BrandName, '', xNew);
            XML.AddElement(xWhGood, 'TradeName', TradeName, '', xNew);
            XML.AddElement(xWhGood, 'CNCode', CNCode, '', xNew);
            XML.AddElement(xWhGood, 'AdditionalCode', AdditionalCode, '', xNew);
            XML.AddElement(xWhGood, 'APCode', APCode, '', xNew);
            XML.AddElement(xWhGood, 'Measure', Measure, '', xNew);
            XML.AddElement(xWhGood, 'InitialAmount', FormatExciseNum(ROUND(InitialAmount, 0.001)), '', xNew);
            XML.AddElement(xWhGood, 'FinalAmount', FormatExciseNum(ROUND(FinalAmount, 0.001)), '', xNew);
            XML.AddElement(xWhGood, 'TransportationLosses', FormatExciseNum(ROUND(TranspLosses, 0.001)), '', xNew);
            XML.AddElement(xWhGood, 'StorageLosses', FormatExciseNum(ROUND(StorageLosses, 0.001)), '', xNew);
        end;

        procedure AddStorredWhGood(SeqNo: Integer; DeclaredGoodsQuantity: Decimal; ActualStoredGoods: Decimal; DocumentNumber: Text[30]; DocumentDate: Date; GoodsEntryMethod: Text[2]; var xWhGood: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode"; var xStorredGood: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode");
        var
            xNew: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
            xWhStorredGoods: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
        begin
            if ISCLEAR(xWhGood) then
                exit;
            XML.FindNode(xWhGood, 'StoredGoods', xWhStorredGoods);
            if ISCLEAR(xWhStorredGoods) then
                XML.AddElement(xWhGood, 'StoredGoods', '', '', xWhStorredGoods);
            XML.AddElement(xWhStorredGoods, 'StoredGood', '', '', xStorredGood);
            XML.AddElement(xStorredGood, 'SequenceNumber', FORMAT(SeqNo), '', xNew);
            XML.AddElement(xStorredGood, 'DeclaredGoodsQuantity', FormatExciseNum(ROUND(DeclaredGoodsQuantity, 0.001)), '', xNew);
            XML.AddElement(xStorredGood, 'ActualStoredGoods', FormatExciseNum(ROUND(ActualStoredGoods, 0.001)), '', xNew);
            XML.AddElement(xStorredGood, 'DocumentNumber', DocumentNumber, '', xNew);
            XML.AddElement(xStorredGood, 'DocumentDate', FORMAT(DocumentDate, 0, FormatTxt2), '', xNew);
            XML.AddElement(xStorredGood, 'GoodsEntryMethod', GoodsEntryMethod, '', xNew);
        end;

        procedure AddRemovedWhGood(SeqNo: Integer; QuantityToRemove: Decimal; DocumentNumber: Text[30]; DocumentDate: Date; DocNoForReducedRate: Text[30]; DocumentReturnDate: Date; ProductPurpose: Text[3]; var xWhGood: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode"; var xRemovedGood: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode");
        var
            xWhRemovedGoods: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
            xNew: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
        begin
            if ISCLEAR(xWhGood) then
                exit;
            XML.FindNode(xWhGood, 'RemovedGoods', xWhRemovedGoods);
            if ISCLEAR(xWhRemovedGoods) then
                XML.AddElement(xWhGood, 'RemovedGoods', '', '', xWhRemovedGoods);
            XML.AddElement(xWhRemovedGoods, 'RemovedGood', '', '', xRemovedGood);

            XML.AddElement(xRemovedGood, 'SequenceNumber', FORMAT(SeqNo), '', xNew);
            XML.AddElement(xRemovedGood, 'QuantityToRemove', FormatExciseNum(ROUND(QuantityToRemove, 0.001)), '', xNew);
            XML.AddElement(xRemovedGood, 'DocumentNumber', DocumentNumber, '', xNew);
            XML.AddElement(xRemovedGood, 'DocumentDate', FORMAT(DocumentDate, 0, FormatTxt2), '', xNew);

            if DocNoForReducedRate <> '' then
                XML.AddElement(xRemovedGood, 'DocumentNumberForReducedRate', DocNoForReducedRate, '', xNew);
            if DocumentReturnDate <> 0D then
                XML.AddElement(xRemovedGood, 'DocumentReturnDate', FORMAT(DocumentReturnDate, 0, FormatTxt2), '', xNew);
            XML.AddElement(xRemovedGood, 'ProductPurpose', ProductPurpose, '', xNew);
        end;

        procedure AddWarehouseExciseLabel(SeqNo: Integer; LabelType: Text[3]; Capacity: Decimal; AlcoholicStrength: Decimal; SellPrice: Decimal; AvailableLabels: Integer; RemainingLabels: Integer; var xWhExLabel: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode");
        var
            xNew: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
        begin

            if ISCLEAR(xWarehouseStockLog) then
                XML.AddElement(xDeclaration, 'WarehouseStockLog', '', '', xWarehouseStockLog);
            if ISCLEAR(xExciseLabels) then
                XML.AddElement(xWarehouseStockLog, 'ExciseLabels', '', '', xExciseLabels);

            XML.AddElement(xExciseLabels, 'ExciseLabel', '', '', xWhExLabel);

            XML.AddElement(xWhExLabel, 'SequenceNumber', FORMAT(SeqNo), '', xNew);
            XML.AddElement(xWhExLabel, 'LabelType', LabelType, '', xNew);
            XML.AddElement(xWhExLabel, 'Capacity', FormatExciseNum(ROUND(Capacity, 0.0001)), '', xNew);

            if AlcoholicStrength >= 0 then
                XML.AddElement(xWhExLabel, 'AlcoholicStrength', FormatExciseNum(ROUND(AlcoholicStrength, 0.01)), '', xNew);
            if SellPrice >= 0 then
                XML.AddElement(xWhExLabel, 'SellPrice', FormatExciseNum(ROUND(SellPrice, 0.01)), '', xNew);

            XML.AddElement(xWhExLabel, 'AvailableLabels', FORMAT(AvailableLabels), '', xNew);
            XML.AddElement(xWhExLabel, 'RemainingLabels', FORMAT(RemainingLabels), '', xNew);
        end;

        procedure AddReceivedExLabel(SeqNo: Integer; DocumentNumber: Text[30]; DocumentDate: Date; NewlyReceivedLables: Integer; LabelEmission: Integer; LabelSeria: Text[2]; LabelStartNumber: Integer; LabelEndNumber: Integer; var xWhExLabel: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode");
        var
            xNew: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
            xReceivedLabels: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
            xRcvLabel: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
        begin
            if ISCLEAR(xWhExLabel) then
                exit;
            XML.FindNode(xWhExLabel, 'ReceivedExciseLabels', xReceivedLabels);
            if ISCLEAR(xReceivedLabels) then
                XML.AddElement(xWhExLabel, 'ReceivedExciseLabels', '', '', xReceivedLabels);

            XML.AddElement(xReceivedLabels, 'ReceivedExciseLabel', '', '', xRcvLabel);

            XML.AddElement(xRcvLabel, 'SequenceNumber', FORMAT(SeqNo), '', xNew);
            XML.AddElement(xRcvLabel, 'DocumentNumber', DocumentNumber, '', xNew);
            XML.AddElement(xRcvLabel, 'DocumentDate', FORMAT(DocumentDate, 0, FormatTxt2), '', xNew);
            XML.AddElement(xRcvLabel, 'NewlyReceivedLables', FORMAT(NewlyReceivedLables), '', xNew);
            XML.AddElement(xRcvLabel, 'LabelEmission', FORMAT(LabelEmission), '', xNew);
            XML.AddElement(xRcvLabel, 'LabelSeria', LabelSeria, '', xNew);
            XML.AddElement(xRcvLabel, 'LabelStartNumber', FORMAT(LabelStartNumber, 8, FormatTxt3), '', xNew);
            XML.AddElement(xRcvLabel, 'LabelEndNumber', FORMAT(LabelEndNumber, 8, FormatTxt3), '', xNew);
        end;

        procedure AddUsedExLabel(SeqNo: Integer; UsedAmount: Integer; LabelEmission: Integer; LabelSeria: Text[2]; LabelStartNumber: Integer; LabelEndNumber: Integer; var xWhExLabel: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode");
        var
            xNew: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
            xUsedLabels: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
            xUsedLabel: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
        begin
            if ISCLEAR(xWhExLabel) then
                exit;
            XML.FindNode(xWhExLabel, 'UsedExciseLabels', xUsedLabels);
            if ISCLEAR(xUsedLabels) then
                XML.AddElement(xWhExLabel, 'UsedExciseLabels', '', '', xUsedLabels);

            XML.AddElement(xUsedLabels, 'UsedExciseLabel', '', '', xUsedLabel);

            XML.AddElement(xUsedLabel, 'SequenceNumber', FORMAT(SeqNo), '', xNew);
            XML.AddElement(xUsedLabel, 'UsedAmount', FORMAT(UsedAmount), '', xNew);
            XML.AddElement(xUsedLabel, 'LabelEmission', FORMAT(LabelEmission), '', xNew);
            XML.AddElement(xUsedLabel, 'LabelSeria', LabelSeria, '', xNew);
            XML.AddElement(xUsedLabel, 'LabelStartNumber', FORMAT(LabelStartNumber, 8, FormatTxt3), '', xNew);
            XML.AddElement(xUsedLabel, 'LabelEndNumber', FORMAT(LabelEndNumber, 8, FormatTxt3), '', xNew);
        end;

        procedure AddReturnedExLabel(SeqNo: Integer; UsedAmount: Integer; LabelEmission: Integer; LabelSeria: Text[2]; LabelStartNumber: Integer; LabelEndNumber: Integer; var xWhExLabel: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode");
        var
            xNew: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
            xReturnedLabels: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
            xRetLabel: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
        begin
            if ISCLEAR(xWhExLabel) then
                exit;
            XML.FindNode(xWhExLabel, 'ReturnedExciseLabels', xReturnedLabels);
            if ISCLEAR(xReturnedLabels) then
                XML.AddElement(xWhExLabel, 'ReturnedExciseLabels', '', '', xReturnedLabels);

            XML.AddElement(xReturnedLabels, 'ReturnedExciseLabel', '', '', xRetLabel);

            XML.AddElement(xRetLabel, 'SequenceNumber', FORMAT(SeqNo), '', xNew);
            XML.AddElement(xRetLabel, 'UsedAmount', FORMAT(UsedAmount), '', xNew);
            XML.AddElement(xRetLabel, 'LabelEmission', FORMAT(LabelEmission), '', xNew);
            XML.AddElement(xRetLabel, 'LabelSeria', LabelSeria, '', xNew);
            XML.AddElement(xRetLabel, 'LabelStartNumber', FORMAT(LabelStartNumber), '', xNew);
            XML.AddElement(xRetLabel, 'LabelEndNumber', FORMAT(LabelEndNumber), '', xNew);
        end;

        procedure GetNodeExciseGoodBy(sXpathFilter: Text[250]; var xNode: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode"): Boolean;
        begin
            // Usage example:
            // IF GetNodeExciseGoodBy('SequenceNumber=''' + '1' + '''' ,xNode) THEN
            //   MESSAGE(xNode.text);

            CLEAR(xNode);
            XML.FindNode(xExciseGoods, 'ExciseGood[' + sXpathFilter + ']', xNode);
            if ISCLEAR(xNode) then
                exit(false)
            else
                exit(true);
        end;

        procedure GetNodeWarehouseGoodBy(sXpathFilter: Text[250]; var xNode: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode"): Boolean;
        begin
            CLEAR(xNode);
            XML.FindNode(xWarehouseGoods, 'WarehouseGood[' + sXpathFilter + ']', xNode);
            if ISCLEAR(xNode) then
                exit(false)
            else
                exit(true);
        end;

        procedure GetNodeWarehouseLabelBy(sXpathFilter: Text[250]; var xNode: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode"): Boolean;
        begin
            CLEAR(xNode);
            XML.FindNode(xExciseLabels, 'ExciseLabel[' + sXpathFilter + ']', xNode);
            if ISCLEAR(xNode) then
                exit(false)
            else
                exit(true);
        end;

        procedure FormatExciseNum(Num: Decimal): Text[30];
        begin
            exit(FORMAT(Num, 0, FormatTxt1));
        end;

        procedure SetExciseGoodQtyOfGoodsBefore(QuantityOfGoods: Decimal; BeforeNodeName: Text[250]; var xGood: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode");
        var
            xNew: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
            xNewGood: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
        begin
            if ISCLEAR(xExciseGoods) then
                exit;
            if ISCLEAR(xGood) then
                exit;
            XML.AddElementBefore(xGood, 'QuantityOfGoods', FormatExciseNum(ROUND(QuantityOfGoods, 0.001)), '', BeforeNodeName, xNew);
        end;

        procedure AddExciseGoodADType(SequenceNumber: Integer; BrandName: Text[6]; Trademark: Text[250]; APCode: Text[4]; CNCode: Text[8]; Measure: Text[3]; AdditionalCode: Text[15]; QuantityOfGoods: Decimal; IntendedUseOfProduct: Text[2]; Purpose: Text[3]; DutyAmount: Decimal; Payment: Text[2]; PaidDuty: Decimal; Degree: Decimal; TaxBase: Decimal; ExciseDuty: Decimal; var xNewGood: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode");
        var
            xNew: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
        begin
            if ISCLEAR(xExciseGoods) then
                XML.AddElement(xDeclaration, 'ExciseGoods', '', '', xExciseGoods);
            XML.AddElement(xExciseGoods, 'ExciseGood', '', '', xNewGood);

            XML.AddElement(xNewGood, 'SequenceNumber', FORMAT(SequenceNumber), '', xNew);
            XML.AddElement(xNewGood, 'BrandName', BrandName, '', xNew);
            XML.AddElement(xNewGood, 'Trademark', Trademark, '', xNew);
            XML.AddElement(xNewGood, 'APCode', APCode, '', xNew);
            XML.AddElement(xNewGood, 'CNCode', CNCode, '', xNew);
            XML.AddElement(xNewGood, 'Measure', Measure, '', xNew);
            XML.AddElement(xNewGood, 'AdditionalCode', AdditionalCode, '', xNew);
            XML.AddElement(xNewGood, 'QuantityOfGoods', FormatExciseNum(ROUND(QuantityOfGoods, 0.001)), '', xNew);
            XML.AddElement(xNewGood, 'IntendedUseOfProduct', IntendedUseOfProduct, '', xNew);
            XML.AddElement(xNewGood, 'Purpose', Purpose, '', xNew);
            XML.AddElement(xNewGood, 'DutyAmount', FormatExciseNum(ROUND(DutyAmount, 0.01)), '', xNew);
            XML.AddElement(xNewGood, 'Payment', Payment, '', xNew);
            XML.AddElement(xNewGood, 'PaidDuty', FormatExciseNum(ROUND(PaidDuty, 0.01)), '', xNew);
            XML.AddElement(xNewGood, 'Degree', FormatExciseNum(ROUND(Degree, 0.01)), '', xNew);
            //XML.AddElement(xNewGood,'TaxBase', FormatExciseNum(ROUND(TaxBase,0.001)) ,'',xNew);
            XML.AddElement(xNewGood, 'TaxBase', FormatExciseNum(ROUND(TaxBase, 0.01)), '', xNew);  // error in spec, temporary
            XML.AddElement(xNewGood, 'ExciseDuty', FormatExciseNum(ROUND(ExciseDuty, 0.001)), '', xNew);
        end;

        procedure AddExciseGoodEDType(SequenceNumber: Integer; BrandName: Text[6]; Trademark: Text[250]; APCode: Text[4]; CNCode: Text[8]; Measure: Text[3]; AdditionalCode: Text[15]; QuantityOfGoods: Decimal; IntendedUseOfProduct: Text[2]; Purpose: Text[3]; DutyAmount: Decimal; Payment: Text[2]; PaidDuty: Decimal; TaxBase: Decimal; ExciseDuty: Decimal; var xNewGood: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode");
        var
            xNew: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
        begin
            if ISCLEAR(xExciseGoods) then
                XML.AddElement(xDeclaration, 'ExciseGoods', '', '', xExciseGoods);
            XML.AddElement(xExciseGoods, 'ExciseGood', '', '', xNewGood);

            XML.AddElement(xNewGood, 'SequenceNumber', FORMAT(SequenceNumber), '', xNew);
            XML.AddElement(xNewGood, 'BrandName', BrandName, '', xNew);
            XML.AddElement(xNewGood, 'Trademark', Trademark, '', xNew);
            XML.AddElement(xNewGood, 'APCode', APCode, '', xNew);
            XML.AddElement(xNewGood, 'CNCode', CNCode, '', xNew);
            XML.AddElement(xNewGood, 'Measure', Measure, '', xNew);
            XML.AddElement(xNewGood, 'AdditionalCode', AdditionalCode, '', xNew);
            XML.AddElement(xNewGood, 'QuantityOfGoods', FormatExciseNum(ROUND(QuantityOfGoods, 0.001)), '', xNew);
            XML.AddElement(xNewGood, 'IntendedUseOfProduct', IntendedUseOfProduct, '', xNew);
            XML.AddElement(xNewGood, 'Purpose', Purpose, '', xNew);
            XML.AddElement(xNewGood, 'DutyAmount', FormatExciseNum(ROUND(DutyAmount, 0.01)), '', xNew);
            XML.AddElement(xNewGood, 'Payment', Payment, '', xNew);
            XML.AddElement(xNewGood, 'PaidDuty', FormatExciseNum(ROUND(PaidDuty, 0.01)), '', xNew);
            XML.AddElement(xNewGood, 'TaxBase', FormatExciseNum(ROUND(TaxBase, 0.01)), '', xNew);  // error in spec, temporary
            XML.AddElement(xNewGood, 'ExciseDuty', FormatExciseNum(ROUND(ExciseDuty, 0.001)), '', xNew);
        end;

        procedure GetNodeAppliedDocumentBy(sXpathFilter: Text[250]; var xNode: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode"): Boolean;
        begin
            // Usage example:
            // IF GetNodeAppliedDocumentBy('DocumentNumber=''' + '1' + '''' ,xNode) THEN
            //   MESSAGE(xNode.text);

            CLEAR(xNode);
            XML.FindNode(xAppliedDocuments, 'AppliedDocument[' + sXpathFilter + ']', xNode);
            if ISCLEAR(xNode) then
                exit(false)
            else
                exit(true);
        end;

        procedure ExistsAppliedDocument(DocNo: Text[30]): Boolean;
        var
            xNode: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
        begin
            exit(GetNodeAppliedDocumentBy('DocumentNumber=''' + DocNo + '''', xNode));
        end;

        procedure CreateComment(var xNode: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode"; CommentText: Text[1024]);
        var
            xComment: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF88-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMComment";
        begin
            if not (ISCLEAR(xNode)) and (CommentText <> '') then begin
                xComment := xNode.ownerDocument.createComment(CommentText);
                if not ISCLEAR(xComment) then
                    xNode.appendChild(xComment);
            end;
        end;

        procedure SetExciseGoodEnergy2013(Density: Decimal; CarbonDioxideQnt: Decimal; CalorificAbility: Decimal; CarbonDioxideDutyRate: Decimal; CalorificDutyRate: Decimal; TotalCarbonDioxideQnt: Decimal; TotalCalorificAbility: Decimal; AvailableAmountEnergyProducts: Decimal; SoldQuantityEnergyProducts: Decimal; var xGood: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode");
        var
            xNew: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
            xNewGood: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
        begin
            if ISCLEAR(xExciseGoods) then
                exit;
            if ISCLEAR(xGood) then
                exit;

            XML.AddElement(xGood, 'Density', FormatExciseNum(ROUND(Density, 0.001)), '', xNew);
            XML.AddElement(xGood, 'CarbonDioxideQnt', FormatExciseNum(ROUND(CarbonDioxideQnt, 0.001)), '', xNew);
            XML.AddElement(xGood, 'CalorificAbility', FormatExciseNum(ROUND(CalorificAbility, 0.001)), '', xNew);
            XML.AddElement(xGood, 'CarbonDioxideDutyRate', FormatExciseNum(ROUND(CarbonDioxideDutyRate, 0.001)), '', xNew);
            XML.AddElement(xGood, 'CalorificDutyRate', FormatExciseNum(ROUND(CalorificDutyRate, 0.001)), '', xNew);
            XML.AddElement(xGood, 'TotalCarbonDioxideQnt', FormatExciseNum(ROUND(TotalCarbonDioxideQnt, 0.001)), '', xNew);
            XML.AddElement(xGood, 'TotalCalorificAbility', FormatExciseNum(ROUND(TotalCalorificAbility, 0.001)), '', xNew);
            XML.AddElement(xGood, 'AvailableAmountEnergyProducts', FormatExciseNum(ROUND(AvailableAmountEnergyProducts, 0.001)), '', xNew);
            XML.AddElement(xGood, 'SoldQuantityEnergyProducts', FormatExciseNum(ROUND(SoldQuantityEnergyProducts, 0.001)), '', xNew);
        end;

        //event xDoc();
        //begin
        /*
        */
    //end;

    //event xDoc();
    //begin
    /*
    */
    //end;
}

