public with sharing class TotalAmountPreparation implements Database.Batchable<sObject>, Database.Stateful {
    public Map<Id, AccountHierarchy> hierarchy = new Map<Id, AccountHierarchy>();

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, Total_Amount__c, ParentId, ' +
                                         + '(SELECT Amount, StageName FROM Opportunities WHERE StageName = \'Closed Won\') ' +
                                        + 'FROM Account');
    }

    public void execute(Database.BatchableContext bc, List<Account> accounts) {
        for (Account account : accounts) {

            account.Total_Amount__c = 0;
            AccountHierarchy accountHierarchy = new AccountHierarchy(account);
            Boolean findedPosition = false;

            if(account.ParentId != null) {
                for(AccountHierarchy parent: hierarchy.values()) {
                    if(parent.isChild(accountHierarchy)) {
                        findedPosition = true;
                        break;
                    }
                }
            }

            if(!findedPosition) {
                hierarchy.put(account.Id, accountHierarchy);
            }

            for(AccountHierarchy node: hierarchy.values()) {
                if(node.account.ParentId == account.Id) {
                    accountHierarchy.childrens.add(node);
                    hierarchy.remove(node.account.Id);
                }
            }
        }
    }

    public void finish(Database.BatchableContext bc){
        Database.executeBatch(new TotalAmountService(hierarchy));
    }
}
