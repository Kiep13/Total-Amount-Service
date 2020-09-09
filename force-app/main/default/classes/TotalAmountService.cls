public with sharing class TotalAmountService implements Database.Batchable<sObject>, Database.Stateful {

    public Map<Id, Account> resultAccount;

    public TotalAmountService() {
        resultAccount = new Map<Id, Account>();
        List<Account> accounts = [SELECT Id, Total_Amount__c, ParentId, 
                                    (SELECT Amount, StageName FROM Opportunities WHERE StageName = 'Closed Won')
                                    FROM Account];
        for(Account account : accounts) {
            account.Total_Amount__c = 0;
            resultAccount.put(account.Id, account);
        }
    }

    public List<Account> start(Database.BatchableContext bc) {
        return resultAccount.values();
    }

    public void execute(Database.BatchableContext bc, List<Account> accounts){
        System.debug(resultAccount);

        for (Account account : accounts) {

            Account storedAccount = resultAccount.get(account.Id);

            Decimal amount = 0;
            for(Opportunity opportunity : storedAccount.Opportunities) {
                amount += opportunity.Amount;
            }
            storedAccount.Total_Amount__c += amount; 
            updateParentAmount(storedAccount, amount);
            resultAccount.put(account.Id, storedAccount);  
        }

    }

    public void finish(Database.BatchableContext bc){
        upsert resultAccount.values();
    }

    public void updateParentAmount(Account account, Decimal amount) {
        if(account.ParentId != null) {
            Account parentAccount = (Account)resultAccount.get(account.ParentId);
            parentAccount.Total_Amount__c += amount;
            updateParentAmount(parentAccount, amount);
            resultAccount.put(account.ParentId, parentAccount); 
        }
        resultAccount.put(account.Id, account); 
    }
}