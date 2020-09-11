public with sharing class TotalAmountCalculator {

    public Decimal solveTotalAmount(AccountHierarchy node) {
        if(node.account.Total_Amount__c == 0) {
            for(Opportunity opportunity : node.account.Opportunities) {
                node.account.Total_Amount__c += opportunity.Amount;
            }
            for(AccountHierarchy children: node.childrens) {
                node.account.Total_Amount__c += solveTotalAmount(children);
            }
        } 
        return node.account.Total_Amount__c;
    }
}
