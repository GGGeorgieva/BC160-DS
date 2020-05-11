codeunit 46015505 "BG Utils"
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

    var
        Text16208: Label 'and';
        Text16209: Label 'minus';
        Text16210: Label 'one thousand';
        Text16211: Label 'thousands';
        Text16212: Label 'million';
        Text16213: Label 'millions';
        Text16214: Label 'billion';
        Text16215: Label 'billions';
        Text16216: Label 'trillion';
        Text16217: Label 'trillions';
        Text16218: Label '" "';
        Text16219: Label 'one hundred';
        Text16220: Label '" hundreds"';
        Text16221: Label '" hundreds"';
        Text16222: Label 'zero';
        Text16223: Label 'one';
        Text16224: Label 'one';
        Text16225: Label 'one';
        Text16226: Label 'two';
        Text16227: Label 'two';
        Text16228: Label 'three';
        Text16229: Label 'four';
        Text16230: Label 'five';
        Text16231: Label 'six';
        Text16232: Label 'seven';
        Text16233: Label 'eight';
        Text16234: Label 'nine';
        Text16235: Label 'point';
        Text16236: Label 'ten';
        Text16237: Label 'eleven';
        Text16238: Label 'twelve';
        Text16239: Label 'thirteen';
        Text16240: Label 'fourteen';
        Text16241: Label 'fifteen';
        Text16242: Label 'sixteen';
        Text16243: Label 'seventeen';
        Text16244: Label 'eighteen';
        Text16245: Label 'nineteen';
        Text16246: Label 'twenty';
        Text16247: Label 'thirty';
        Text16248: Label 'forty';
        Text16249: Label 'fifty';
        Text16250: Label 'sixty';
        Text16251: Label 'seventy';
        Text16252: Label 'eighty';
        Text16253: Label 'ninety';
        Text16254: Label 'and';
        Text16255: Label 'Invalid IDN No.';
        Text16256: Label 'Invalid Passport No.';
        Text16257: Label 'Invalid Identification No.';
        Text16258: Label 'Invalid Bank Account No.';
        Text16259: Label 'Invalid Bank Code';
        Text16260: Label 'Invalid VAT Reg. No.';
        Text16261: Label 'Document No. should be maximum 10 characters long.';
        ff: Boolean;
        fi: Boolean;
        BGSetup: Record "BG Setup";
        dlgBar: Dialog;
        Text16262: Label 'This Identification number has already been entered for the following customers:\ %1';
        Text16263: Label 'This Identification number has already been entered for the following vendors:\ %1';
        Text16264: Label 'Invalid IBAN';
        Text52002: Label '" and"';
        BGTxt: Label 'BG';
        SmallCharsTxt: Label 'абвгдежзийклмнопрстуфхцчшщъюяьabcdefghijklmnopqrstuvwxyz';
        BigCharsTxt: Label 'АБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЮЯЬABCDEFGHIJKLMNOPQRSTUVWXYZ';
        DigitsTxt: Label '0123456789';
        ZeroTxt: Label '0000000000';
        FormatTxt: Label '<INTEGER,12><FILLER CHARACTER,0><DECIMALS,3>';
        AndTxt: Label 'and';

    procedure NumsToWords(number: Decimal; curCode: Code[20]): Text[250];
    begin
        case GLOBALLANGUAGE of
            1026:
                exit(NumsToWordsBG(number, curCode));
            1033:
                exit(NumsToWordsBG(number, curCode));
            else
                exit(FORMAT(number) + ' ' + curCode);
        end;
    end;

    procedure NumsToWordsBG(number: Decimal; curCode: Code[20]): Text[250];
    var
        cur: Record Currency;
        glSetup: Record "General Ledger Setup";
        bgSetup: Record "BG Setup";
        rod: Integer;
        ch: Integer;
        sm: Text[250];
        s: Text[250];
        ss: Text[250];
        s3: Text[250];
        s2: Text[250];
        i: Integer;
        curDesc: Text[30];
        curDescCents: Text[30];
        exitStr: Text[250];
        "---LOCAL---": Integer;
        lPos: Integer;
        bPrint: Boolean;
        sAnd: Text[5];
        ss21: Text[250];
        ss22: Text[250];
        ss23: Text[250];
    begin
        if curCode = '' then begin
            bgSetup.GET;
            glSetup.GET;
            rod := bgSetup."Local Currency Type";
            curDesc := glSetup."LCY Code";
            if bgSetup."LCY Description" <> '' then
                curDesc := bgSetup."LCY Description";
            curDescCents := bgSetup."LCY Fractions";
        end else begin
            cur.GET(curCode);
            rod := cur."Currency Gender";
            curDesc := cur.Code;
            if cur.Description <> '' then
                curDesc := cur.Description;
            curDescCents := '';
        end;

        sm := '';
        if number < 0 then begin
            number := -number;
            sm := Text16209 + ' ';
        end;

        s := FORMAT(number, 0, FormatTxt);

        if number < 1 then
            exitStr := sm + NumsToWords_N(0) + ' ' + curDesc + ' ' + Trim(Trim(Text16218)) + ' ' + Right(s, 2) + ' ' + curDescCents
        else begin
            ss := '';
            ff := false;
            for i := 0 to 3 do begin
                s3 := COPYSTR(s, 10 - i * 3, 3);
                s2 := '';
                s2 := NumsToWords_V3(s3, NumsToWords_N3R(i, rod));
                if (s3 = '001') and (i = 1) then
                    s2 := '';
                if s3 <> '000' then
                    s2 := s2 + NumsToWords_N3(i, s3 <> '001') + ' ';
                if (s3 <> '000') and (not fi) and (not ff) then begin
                    if Trim(Text16208) <> '' then
                        s2 := Trim(Text16208) + ' ' + s2;
                    ff := true;
                end;
                ss := s2 + ss;
            end;

            ss := Trim(ss);
            if COPYSTR(ss, 1, STRLEN(Trim(Text16208)) + 1) = Trim(Text16208) + ' ' then
                ss := Right(ss, STRLEN(ss) - STRLEN(Trim(Text16208)));
            ss := Trim(ss);

            if (GLOBALLANGUAGE = 1026) and (Text16208 <> AndTxt) then begin
                bPrint := false;
                for i := STRLEN(ss) downto 1 do begin
                    if (ss[i] = ' ') and (bPrint = false) then begin
                        ss := COPYSTR(ss, 1, i) + Text16208 + ' ' + COPYSTR(ss, i + 1, STRLEN(ss) - i);
                        bPrint := true;
                    end;
                end;

                lPos := STRPOS(ss, Text52002);
                if lPos > 0 then begin
                    ss21 := COPYSTR(ss, 1, lPos + 2);
                    ss22 := COPYSTR(ss, 1, lPos);
                    ss23 := COPYSTR(ss, lPos + 3, STRLEN(ss) - (lPos + 2));
                    lPos := STRPOS(ss21, Text52002);
                    if lPos > 0 then
                        ss := ss22 + ss23;
                end;
                if (number > 20000) and (number div 20000 > 0) then begin
                    lPos := STRPOS(ss, ' ');
                    if lPos > 0 then
                        ss := COPYSTR(ss, 1, lPos) + Text16208 + ' ' + COPYSTR(ss, lPos + 1, STRLEN(ss) - lPos);
                end;
            end;

            if curCode <> '' then
                exitStr := sm + ss + ' ' + Text16235 + ' ' + Right(s, 2) + ' ' + curDesc
            else
                exitStr := sm + ss + ' ' + curDesc + ' ' + Trim(Text16208) + ' ' + Right(s, 2) + ' ' + curDescCents;
        end;

        exitStr[1] := upper(FORMAT(exitStr[1])) [1];

        exit(exitStr);
    end;

    procedure NumsToWords_V3(s: Text[250]; rod: Integer): Text[250];
    var
        s1: Text[250];
        ss: Text[250];
        ch: Integer;
    begin
        fi := false;
        s1 := '';
        ch := DigitVal(s[1]);
        case ch of
            1:
                s1 := Text16219;
            2, 3:
                s1 := NumsToWords_N(ch) + Text16220;
            4 .. 9:
                s1 := NumsToWords_N(ch) + Text16221;
        end;
        s1 := s1 + ' ';

        ch := DigitVal(s[2]);
        if (s[1] <> '0') and ((ch = 1) or ((Right(s, 1) = '0') and (ch <> 0))) then begin
            if Trim(Text16218) <> '' then
                s1 := s1 + Trim(Text16218) + ' ';
            fi := true;
        end;

        if (s[1] <> '0') and ((s[2] <> '0') or (s[3] <> '0')) then
            if Trim(Text16254) <> '' then
                s1 := s1 + Trim(Text16254) + ' ';

        case ch of
            1:
                begin
                    s1 := s1 + NumsToWords_N1(DigitVal(RightChar(s))) + ' ';
                    exit(s1);
                end;
            2:
                s1 := s1 + Text16246 + ' ';
            3:
                s1 := s1 + Text16247 + ' ';
            4:
                s1 := s1 + Text16248 + ' ';
            5:
                s1 := s1 + Text16249 + ' ';
            6:
                s1 := s1 + Text16250 + ' ';
            7:
                s1 := s1 + Text16251 + ' ';
            8:
                s1 := s1 + Text16252 + ' ';
            9:
                s1 := s1 + Text16253 + ' ';
        end;

        if (Right(s, 1) <> '0') and ((COPYSTR(s, 1, 2) <> '00')) then begin
            if Trim(Text16218) <> '' then
                s1 := s1 + Trim(Text16218) + ' ';
            fi := true;
        end;

        ch := DigitVal(s[STRLEN(s)]);
        case ch of
            1:
                s1 := s1 + NumsToWords_NR1(rod) + ' ';
            2:
                s1 := s1 + NumsToWords_NR2(rod) + ' ';
            3 .. 9:
                s1 := s1 + NumsToWords_N(ch) + ' ';
        end;

        exit(s1);
    end;

    procedure NumsToWords_N3R(int: Integer; rod: Integer): Integer;
    begin
        case int of
            0:
                exit(rod);
            1:
                exit(1);
            2:
                exit(rod);
            3:
                exit(rod);
            4:
                exit(rod);
        end;
    end;

    procedure NumsToWords_N3(int: Integer; mult: Boolean): Text[30];
    var
        s: Text[30];
    begin
        if not mult then
            case int of
                0:
                    exit('');
                1:
                    exit(Text16210);
                2:
                    exit(Text16212);
                3:
                    exit(Text16214);
                4:
                    exit(Text16216);
            end
        else
            case int of
                0:
                    exit('');
                1:
                    exit(Text16211);
                2:
                    exit(Text16213);
                3:
                    exit(Text16215);
                4:
                    exit(Text16217);
            end;

        exit(s);
    end;

    procedure NumsToWords_NR1(int: Integer): Text[30];
    begin
        case int of
            0:
                exit(Text16223);
            1:
                exit(Text16224);
            2:
                exit(Text16225);
        end;
    end;

    procedure NumsToWords_NR2(int: Integer): Text[30];
    begin
        case int of
            0:
                exit(Text16227);
            1:
                exit(Text16226);
            2:
                exit(Text16226);
        end;
    end;

    procedure NumsToWords_N1(int: Integer): Text[30];
    begin
        case int of
            0:
                exit(Text16236);
            1:
                exit(Text16237);
            2:
                exit(Text16238);
            3:
                exit(Text16239);
            4:
                exit(Text16240);
            5:
                exit(Text16241);
            6:
                exit(Text16242);
            7:
                exit(Text16243);
            8:
                exit(Text16244);
            9:
                exit(Text16245);
        end;
    end;

    procedure NumsToWords_N(int: Integer): Text[30];
    begin
        case int of
            0:
                exit(Text16222);
            1:
                exit(Text16225);
            2:
                exit(Text16226);
            3:
                exit(Text16228);
            4:
                exit(Text16229);
            5:
                exit(Text16230);
            6:
                exit(Text16231);
            7:
                exit(Text16232);
            8:
                exit(Text16233);
            9:
                exit(Text16234);
        end;
    end;

    procedure dlgBarOpen(p_txtCaption: Text[250]);
    begin
        dlgBar.OPEN(p_txtCaption + ' @1@@@@@@@@@@@@@@@@@');
    end;

    procedure dlgBarUpdate(p_intCurPos: Integer; p_intMaxPos: Integer);
    begin
        dlgBar.UPDATE(1, ROUND(p_intCurPos / p_intMaxPos * 10000, 1));
    end;

    procedure dlgBarClose();
    begin
        dlgBar.CLOSE;
    end;

    procedure ResultDebitCredit(gjl: Record "Gen. Journal Line"): Boolean;
    begin
        exit(((gjl.Amount > 0) and (not gjl.Correction)) or
              ((gjl.Amount < 0) and gjl.Correction));
    end;

    procedure SetCorrectionToFillCredit(var gjl: Record "Gen. Journal Line");
    begin
        if ResultDebitCredit(gjl) then
            gjl.Correction := not gjl.Correction;
    end;

    procedure SetCorrectionToFillDebit(var gjl: Record "Gen. Journal Line");
    begin
        if not ResultDebitCredit(gjl) then
            gjl.Correction := not gjl.Correction;
    end;

    procedure TestVatRegNo(VatRegNo: Text[30]; IdentificationNo: Text[30]);
    begin
        BGSetup.GET;
        if (BGSetup."Skip Check for VAT Reg. No.") or (VatRegNo = '') or (VatRegNo = BGSetup."Foreigner VAT Reg. No.") then
            exit;

        if BGTxt + IdentificationNo <> VatRegNo then
            ERROR(Text16260);
    end;

    procedure TestIdentification(IdentificationNo: Text[30]; CountryCode: Code[10]);
    begin
        BGSetup.GET;
        if (BGSetup."Skip Check for Identific. No.") or
           (IdentificationNo = '') or
           (IdentificationNo = BGSetup."Foreigner Identification No.") then
            exit;

        if not CheckIdentification(IdentificationNo) then
            ERROR(Text16257);
    end;

    procedure TestIDN(egn: Code[10]; CountryCode: Code[10]);
    begin
        BGSetup.GET;
        if (BGSetup."Skip Check for IDN") or (egn = '') then
            exit;

        if not CheckIDN(egn) then
            ERROR(Text16255);
    end;

    procedure TestIBAN(iban: Code[50]; CountryCode: Code[10]);
    begin
        BGSetup.GET;
        if (BGSetup."Skip Check for IBAN") or (iban = '') then
            exit;

        if not CheckIBAN(iban) then
            ERROR(Text16264);
    end;

    procedure TestBankAcc(bankAccNo: Code[30]; CountryCode: Code[10]);
    begin
        BGSetup.GET;
        if (BGSetup."Skip Check for Bank Acc.") or (bankAccNo = '') then
            exit;

        if not CheckBankAccCode(bankAccNo) then
            ERROR(Text16258);
    end;

    procedure TestBankCode(bankCode: Code[30]; CountryCode: Code[10]);
    begin
        BGSetup.GET;
        if (BGSetup."Skip Check for Bank Code") or (bankCode = '') then
            exit;

        if not CheckBankCode(bankCode) then
            ERROR(Text16259);
    end;

    procedure TestInvoiceNo(DocNo: Code[20]; CountryCode: Code[10]);
    begin
        BGSetup.GET;
        if (DocNo = '') then
            exit;

        if not CheckInvoiceNo(DocNo) then
            ERROR(Text16261);
    end;

    procedure CheckIDN(egn: Code[10]): Boolean;
    var
        crc: Integer;
        hasError: Boolean;
        len: Integer;
    begin
        len := STRLEN(egn);
        hasError := not (isNum(egn) and (len = 10));

        if not hasError then begin
            crc := DigitVal(egn[1]) * 2 + DigitVal(egn[2]) * 4 + DigitVal(egn[3]) * 8 + DigitVal(egn[4]) * 5 + DigitVal(egn[5]) * 10 +
                   DigitVal(egn[6]) * 9 + DigitVal(egn[7]) * 7 + DigitVal(egn[8]) * 3 + DigitVal(egn[9]) * 6;
            crc := (crc mod 11) mod 10;
            hasError := crc <> DigitVal(egn[10]);
        end;

        exit(not hasError);
    end;

    procedure CheckIBAN(IBAN: Code[50]): Boolean;
    var
        crc: Decimal;
        hasError: Boolean;
        len: Integer;
    begin
        len := STRLEN(IBAN);
        hasError := not (len = 28);

        if hasError then
            exit(not hasError);

        if not hasError then begin
            crc := Modul(IBAN, 97);

            hasError := crc <> 1;
        end;

        exit(not hasError);
    end;

    procedure CheckPassport(passno: Text[10]): Boolean;
    var
        len: Integer;
        hasError: Boolean;
    begin
        if passno = '' then
            exit(true);
        len := STRLEN(passno);
        hasError := not (
                    ((len = 9) and isNum(passno)) or
                    ((len = 8) and isAlpha(FORMAT(passno[1])) and isNum(COPYSTR(passno, 2, 7)))
                    );

        if hasError then
            ERROR(Text16256);

        exit(not hasError);
    end;

    procedure CheckIdentification(bulstat: Text[13]): Boolean;
    var
        i: Integer;
        len: Integer;
        num: Text[30];
        hasError: Boolean;
        crc: Decimal;
        "sum": Decimal;
    begin
        if (bulstat = '') then
            exit(true);

        len := STRLEN(bulstat);

        //9,13
        hasError := not (isNum(bulstat) and (len in [9, 10, 13]));

        if (not hasError) then begin
            //9
            if (not hasError) and (len = 8) then begin
                sum := 0;
                for i := 1 to 8 do
                    sum := sum + i * DigitVal(bulstat[i]);
                crc := sum mod 11;
                if crc = 10 then begin
                    sum := 0;
                    for i := 3 to 10 do
                        sum := sum + i * DigitVal(bulstat[i - 2]);
                end;
                crc := sum mod 11;
                if crc = 10 then
                    crc := 0;
                hasError := DigitVal(bulstat[9]) <> crc;
            end;

            // 10
            if (not hasError) and (len = 10) then begin
                TestIDN(bulstat, '');
            end;

            //13
            if (not hasError) and (len = 13) then begin
                sum := 2 * DigitVal(bulstat[9]) + 7 * DigitVal(bulstat[10]) + 3 * DigitVal(bulstat[11]) + 5 * DigitVal(bulstat[12]);
                crc := sum mod 11;
                if crc = 10 then
                    sum := 4 * DigitVal(bulstat[9]) + 9 * DigitVal(bulstat[10]) + 5 * DigitVal(bulstat[11]) + 7 * DigitVal(bulstat[12]);
                crc := sum mod 11;
                if crc = 10 then
                    crc := 0;
                hasError := DigitVal(bulstat[13]) <> crc;
            end;
        end;

        exit(not hasError);
    end;

    procedure CheckVatRegNo(TaxNo: Text[20]): Boolean;
    var
        len: Integer;
        hasError: Boolean;
        checknum: Integer;
        TaxNumSum: Integer;
        ic: Integer;
        "code": Integer;
    begin
        if (TaxNo = '') then
            exit(true);
        len := STRLEN(TaxNo);
        hasError := not ((len = 10) and isNum(TaxNo));

        if (not hasError) then begin
            checknum := DigitVal(TaxNo[10]);
            TaxNumSum := 0;
            for ic := 1 to 9 do begin
                code := DigitVal(TaxNo[ic]);
                case ic of
                    1, 2, 3:
                        TaxNumSum += code * (5 - ic);
                    else
                        TaxNumSum += code * (11 - ic);
                end;
            end;
            TaxNumSum := (11 - (TaxNumSum mod 11)) mod 11;
            hasError := (TaxNumSum = 10) or (TaxNumSum <> checknum);
            if not hasError then
                hasError := (TaxNo = ZeroTxt)
            else
                hasError := not CheckIDN(TaxNo);
        end;

        exit(not hasError);
    end;

    procedure CheckInvoiceNo(DocNo: Code[20]): Boolean;
    var
        len: Integer;
        hasError: Boolean;
    begin
        len := STRLEN(DocNo);
        hasError := (len > 10);
        exit(not hasError);
    end;

    procedure CheckBankCode(TestStr: Text[30]): Boolean;
    var
        ic: Integer;
        CheckNum: Integer;
        ErrCode: Integer;
        BankCodeSum: Integer;
        len: Integer;
        hasError: Boolean;
    begin
        if TestStr = '' then
            exit(false);

        len := STRLEN(TestStr);
        hasError := not ((len = 8) and isNum(TestStr));

        if not hasError then begin
            CheckNum := DigitVal(TestStr[8]);
            BankCodeSum := 0;
            for ic := 1 to 7 do
                BankCodeSum := BankCodeSum + DigitVal(TestStr[ic]) * Mod11(ic);
            BankCodeSum := (BankCodeSum mod 11) mod 10;
            hasError := BankCodeSum <> CheckNum;
        end;

        exit(not hasError);
    end;

    procedure CheckBankAccCode(TestStr: Text[30]): Boolean;
    var
        ic: Integer;
        CheckNum: Integer;
        ErrCode: Integer;
        BankAccSum: Integer;
        len: Integer;
        hasError: Boolean;
    begin
        if TestStr = '' then
            exit(false);

        len := STRLEN(TestStr);
        hasError := not ((len = 10) and isNum(TestStr));

        if not hasError then begin
            CheckNum := DigitVal(TestStr[10]);
            BankAccSum := 0;
            for ic := 1 to 9 do
                BankAccSum := BankAccSum + DigitVal(TestStr[ic]) * Mod11(ic);
            BankAccSum := (BankAccSum mod 11) mod 10;
            hasError := BankAccSum <> CheckNum;
        end;

        exit(not hasError);
    end;

    procedure isAlpha(str: Text[30]): Boolean;
    var
        alpha: Text[250];
    begin
        alpha := SmallCharsTxt + BigCharsTxt;
        exit(DELCHR(str, '<>', alpha) = '');
    end;

    procedure isNum(str: Text[30]): Boolean;
    var
        alpha: Text[250];
    begin
        alpha := DigitsTxt;
        exit(DELCHR(str, '<>', alpha) = '');
    end;

    procedure DigitVal(c: Char) res: Integer;
    begin
        res := c - '0';
    end;

    procedure Mod11(power: Integer): Integer;
    var
        ic: Integer;
        "sum": Integer;
    begin
        sum := 1;
        for ic := 1 to power do
            sum := sum * 2;

        exit(sum mod 11);
    end;

    procedure upper(str: Text[250]): Text[250];
    var
        fromChars: Text[250];
        toChars: Text[250];
    begin
        fromChars := SmallCharsTxt;
        toChars := BigCharsTxt;
        exit(CONVERTSTR(str, fromChars, toChars));
    end;

    procedure lower(str: Text[250]): Text[250];
    var
        fromChars: Text[250];
        toChars: Text[250];
    begin
        fromChars := BigCharsTxt;
        toChars := SmallCharsTxt;
        exit(CONVERTSTR(str, fromChars, toChars));
    end;

    procedure Trim(buf: Text[250]): Text[250];
    var
        i: Integer;
    begin
        exit(DELCHR(buf, '<>', ' '));
    end;

    procedure Right(text: Text[250]; "count": Integer): Text[250];
    begin
        exit(COPYSTR(text, STRLEN(text) - count + 1, count));
    end;

    procedure RightChar(text: Text[250]): Char;
    begin
        exit(text[STRLEN(text)]);
    end;

    procedure FormatCurrency(Amount: Decimal; CurCode: Code[20]): Decimal;
    var
        Currency: Record Currency;
    begin
        if CurCode = '' then
            exit(ROUND(Amount));
        Currency.GET(CurCode);
        exit(ROUND(Amount, Currency."Amount Rounding Precision"));
    end;

    procedure CheckCustIdentification(Bulstat: Text[20]; Number: Code[20]);
    var
        Cust: Record Customer;
        Check: Boolean;
        Finish: Boolean;
        t: Text[250];
    begin
        Check := true;
        t := '';
        Cust.SETCURRENTKEY("Identification No.");
        Cust.SETRANGE("Identification No.", Bulstat);
        Cust.SETFILTER("No.", '<>%1', Number);
        if Cust.FIND('-') then begin
            Check := false;
            Finish := false;
            repeat
                if Cust."No." <> Number then begin
                    if t = '' then
                        t := Cust."No."
                    else
                        if STRLEN(t) + STRLEN(Cust."No.") + 5 <= MAXSTRLEN(t) then
                            t := t + ', ' + Cust."No."
                        else begin
                            t := t + '...';
                            Finish := true;
                        end;
                end;
            until (Cust.NEXT = 0) or Finish;
        end;
        if Check = false then
            MESSAGE(Text16262, t);
    end;

    procedure CheckVendIdentification(Bulstat: Text[20]; Number: Code[20]);
    var
        Vend: Record Vendor;
        Check: Boolean;
        Finish: Boolean;
        t: Text[250];
    begin
        Check := true;
        t := '';
        Vend.SETCURRENTKEY("Identification No.");
        Vend.SETRANGE("Identification No.", Bulstat);
        Vend.SETFILTER("No.", '<>%1', Number);
        if Vend.FIND('-') then begin
            Check := false;
            Finish := false;
            repeat
                if Vend."No." <> Number then begin
                    if t = '' then
                        t := Vend."No."
                    else
                        if STRLEN(t) + STRLEN(Vend."No.") + 5 <= MAXSTRLEN(t) then
                            t := t + ', ' + Vend."No."
                        else begin
                            t := t + '...';
                            Finish := true;
                        end;
                end;
            until (Vend.NEXT = 0) or Finish;
        end;
        if Check = false then
            MESSAGE(Text16263, t);
    end;

    procedure Modul(Delimo: Code[50]; Delitel: Decimal): Decimal;
    var
        len: Integer;
        i: Integer;
        j: Integer;
        Del1: Integer;
        Ost: Integer;
        Res: Decimal;
        ResTxt: Text[250];
    begin
        i := 0;
        Ost := 0;
        len := STRLEN(Delimo);

        repeat
            i := i + 1;
            j := 1;
            EVALUATE(Del1, FORMAT(Ost) + COPYSTR(Delimo, i, j));

            while (Del1 < Delitel) do begin
                j := j + 1;
                EVALUATE(Del1, FORMAT(Ost) + COPYSTR(Delimo, i, j));
            end;

            i += j - 1;
            Ost := Del1 mod Delitel;
        until i >= len;

        exit(Ost);
    end;
}

