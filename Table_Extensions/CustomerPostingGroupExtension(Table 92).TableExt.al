tableextension 46015610 "Cust. Post. Group Extension" extends "Customer Posting Group"
{
    // version NAVW111.00.00.24742,NAVE111.0
    trigger OnBeforeDelete()
    begin
        DeleteSubstPostingGroups;
    end;

    procedure GetReceivablesAccNo(PostingGroupCode: Code[10]): Code[20];
    begin
        //NAVE111.0; 001; entire function
        GET(PostingGroupCode);
        TESTFIELD("Receivables Account");
        exit("Receivables Account");
    end;

    procedure DeleteSubstPostingGroups();
    var
        SubstCustPostingGroup: Record "Subst. Customer Posting Group";
    begin
        //NAVE111.0; 001; entire function
        SubstCustPostingGroup.SETRANGE("Parent Cust. Posting Group", Code);
        SubstCustPostingGroup.DELETEALL;
        SubstCustPostingGroup.RESET;
        SubstCustPostingGroup.SETRANGE("Customer Posting Group", Code);
        SubstCustPostingGroup.DELETEALL;
    end;
}

