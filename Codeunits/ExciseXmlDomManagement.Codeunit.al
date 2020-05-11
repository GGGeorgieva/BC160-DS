codeunit 46015690 "Excise XML DOM Management"
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
            NormalCaseMode: Boolean;

        procedure AddElement(var XMLNode: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{F6D90F11-9C73-11D3-B32E-00C04F990BB4}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.DOMDocument"; NodeName: Text[250]; NodeText: Text[250]; NameSpace: Text[250]; var CreatedXMLNode: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode") ExitStatus: Integer;
        var
            NewChildNode: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
        begin
            if not NormalCaseMode then
                NodeName := UPPERCASE(NodeName);
            NewChildNode := XMLNode.ownerDocument.createNode('element', NodeName, NameSpace);

            if ISCLEAR(NewChildNode) then begin
                ExitStatus := 50;
                exit;
            end;

            if NodeText <> '' then
                NewChildNode.text := NodeText;

            XMLNode.appendChild(NewChildNode);
            CreatedXMLNode := NewChildNode;

            ExitStatus := 0;
        end;

        procedure AddAttribute(var XMLNode: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode"; Name: Text[260]; NodeValue: Text[260]) ExitStatus: Integer;
        var
            XMLNewAttributeNode: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
        begin
            if not NormalCaseMode then
                Name := UPPERCASE(Name);
            XMLNewAttributeNode := XMLNode.ownerDocument.createAttribute(Name);

            if ISCLEAR(XMLNewAttributeNode) then begin
                ExitStatus := 60;
                exit(ExitStatus)
            end;

            if NodeValue <> '' then
                XMLNewAttributeNode.nodeValue := NodeValue;

            XMLNode.attributes.setNamedItem(XMLNewAttributeNode);
        end;

        procedure FindNode(XMLRootNode: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode"; NodePath: Text[250]; var FoundXMLNode: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode"): Boolean;
        begin
            if ISCLEAR(XMLRootNode) then
                exit(false);

            if not NormalCaseMode then
                NodePath := UPPERCASE(NodePath);
            FoundXMLNode := XMLRootNode.selectSingleNode(NodePath);

            if ISCLEAR(FoundXMLNode) then
                exit(false)
            else
                exit(true);
        end;

        procedure FindNodeText(XMLRootNode: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode"; NodePath: Text[250]): Text[260];
        var
            FoundXMLNode: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
        begin
            if ISCLEAR(XMLRootNode) then
                exit('');

            if not NormalCaseMode then
                NodePath := UPPERCASE(NodePath);
            FoundXMLNode := XMLRootNode.selectSingleNode(NodePath);

            if ISCLEAR(FoundXMLNode) then
                exit('')
            else
                exit(FoundXMLNode.text);
        end;

        procedure FindNodes(XMLRootNode: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode"; NodePath: Text[250]; var ReturnedXMLNodeList: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF82-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNodeList"): Boolean;
        begin
            if not NormalCaseMode then
                NodePath := UPPERCASE(NodePath);
            ReturnedXMLNodeList := XMLRootNode.selectNodes(NodePath);

            if ISCLEAR(ReturnedXMLNodeList) then
                exit(false)
            else
                exit(true);
        end;

        procedure SetNormalCase();
        begin
            NormalCaseMode := true;
        end;

        procedure AddElementBefore(var XMLNode: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{F6D90F11-9C73-11D3-B32E-00C04F990BB4}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.DOMDocument"; NodeName: Text[250]; NodeText: Text[250]; NameSpace: Text[250]; BeforeNodeName: Text[250]; var CreatedXMLNode: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode") ExitStatus: Integer;
        var
            NewChildNode: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
            BeforeNode: Automation "'{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0:'{2933BF80-7B36-11D2-B20E-00C04F983E60}':''{F5078F18-C551-11D3-89B9-0000F81FE221}' 3.0'.IXMLDOMNode";
        begin
            if not NormalCaseMode then
                NodeName := UPPERCASE(NodeName);
            NewChildNode := XMLNode.ownerDocument.createNode('element', NodeName, NameSpace);

            if ISCLEAR(NewChildNode) then begin
                ExitStatus := 50;
                exit;
            end;

            if not FindNode(XMLNode, BeforeNodeName, BeforeNode) then begin
                ExitStatus := 50;
                exit;
            end;

            if NodeText <> '' then
                NewChildNode.text := NodeText;


            XMLNode.insertBefore(NewChildNode, BeforeNode);
            CreatedXMLNode := NewChildNode;

            ExitStatus := 0;
        end;
        */
}

