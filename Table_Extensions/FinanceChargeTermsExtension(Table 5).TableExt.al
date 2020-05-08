tableextension 46015571 "Finance Charge Terms Extension" extends "Finance Charge Terms"
{
    // version NAVW19.00,NAVW17.00,NAVE111.0

    fields
    {
        field(46015625; "Grace Tax Period"; DateFormula)
        {
            Caption = 'Grace Tax Period';
            Description = 'NAVE111.0,001';
        }
    }
    trigger OnBeforeDelete()
    begin
        MultipleInterestRate.SETRANGE("Finance Charge Code", Code);
        MultipleInterestRate.DELETEALL;
    end;

    var
        MultipleInterestRate: Record "Multiple Interest Rate";
}

