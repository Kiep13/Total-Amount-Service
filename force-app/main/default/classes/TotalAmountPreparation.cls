public with sharing class TotalAmountPreparation implements Database.Batchable<sObject>, Database.Stateful {
    public Map<Id, Account> resultedAccounts = new Map<Id, Account>();
    public Map<Id, AccountHierarchy> hierarchy = new Map<Id, AccountHierarchy>();

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, Total_Amount__c, ParentId, ' +
                                         + '(SELECT Amount, StageName FROM Opportunities WHERE StageName = \'Closed Won\') ' +
                                        + 'FROM Account');
    }

    public void execute(Database.BatchableContext bc, List<Account> accounts) {
        for (Account account : accounts) {
            account.Total_Amount__c = 0;
            resultedAccounts.put(account.Id, account);
        }
    }

    public void finish(Database.BatchableContext bc){
        this.buildParts();
        this.rebuildTree();
        Database.executeBatch(new TotalAmountService(hierarchy));
    }

    public void buildParts() {
        for (Account account : resultedAccounts.values()) {
            if(account.ParentId != null && hierarchy.containsKey(account.ParentId)) {
                AccountHierarchy accountParent = hierarchy.get(account.ParentId);
                accountParent.childrens.add(new AccountHierarchy(account));
            } else {
                AccountHierarchy accountHierarchy = new AccountHierarchy(account);
                hierarchy.put(account.Id, accountHierarchy);
            }
        }
    }

    public void rebuildTree() {
        for(AccountHierarchy node: hierarchy.values()) {
            System.debug(node);
            if(node.account.ParentId != null) {
                for(AccountHierarchy parent: hierarchy.values()) {
                    if(parent.isChild(node)) {
                        hierarchy.remove(node.account.Id);
                    }
                }
            }
        }
    }
}
