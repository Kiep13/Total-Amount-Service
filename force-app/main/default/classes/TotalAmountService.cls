public with sharing class TotalAmountService implements Database.Batchable<sObject>, Database.Stateful {

    public Map<Id, AccountHierarchy> hierarchy;

    public TotalAmountService(Map<Id, AccountHierarchy> accounts) {
        hierarchy = accounts;
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, Total_Amount__c, ParentId, ' +
                    + '(SELECT Amount, StageName FROM Opportunities WHERE StageName = \'Closed Won\') ' +
                + 'FROM Account');
    }

    public void execute(Database.BatchableContext bc, List<Account> accounts){

        for (Account account : accounts) {

            if(hierarchy.containsKey(account.Id)) {
                AccountHierarchy accountHierarchy = hierarchy.get(account.Id);
                accountHierarchy.solveTotalAmount();
            }
        }

    }

    public void finish(Database.BatchableContext bc){
        List<Account> results = new List<Account>();
        for(AccountHierarchy node: hierarchy.values()) {
            results.add(node.account);
            results.addAll(node.getChilrens());
        }
        upsert results;
    }
}