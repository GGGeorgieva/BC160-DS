tableextension 46015611 "Vendor Posting Group Ext." extends "Vendor Posting Group"
{
    trigger OnDelete();
    begin
        DeleteSubstPostingGroups;
    end;

    PROCEDURE GetPayablesAccNo(PostingGroupCode: Code[10]): Code[20];
    BEGIN
        //NAVE111.0; 001; entire function
        GET(PostingGroupCode);
        TESTFIELD("Payables Account");
        exit("Payables Account");
    END;

    PROCEDURE DeleteSubstPostingGroups();
    VAR
        SubstVendPostingGroup: Record "Subst. Vendor Posting Group";
    BEGIN
        //NAVE111.0; 001; entire function
        SubstVendPostingGroup.SETRANGE("Parent Vend. Posting Group", Code);
        SubstVendPostingGroup.DELETEALL;
        SubstVendPostingGroup.RESET;
        SubstVendPostingGroup.SETRANGE("Vendor Posting Group", Code);
        SubstVendPostingGroup.DELETEALL;
    END;
}

