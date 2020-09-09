public with sharing class TotalAmountService implements Database.Batchable<sObject>, Database.Stateful {

    public static Map<Id, Account> resultAccount;

    public List<Account> start(Database.BatchableContext bc) {
        resultAccount = new Map<Id, Account>();
        Database.QueryLocator query = Database.getQueryLocator('SELECT Id, Total_Amount__c, ParentId, ' +
                                         + '(SELECT Amount, StageName FROM Opportunities WHERE StageName = \'Closed Won\') ' +
                                        + 'FROM Account');
        Database.QueryLocatorIterator iterator =  query.iterator();
        List<Account> accounts = new List<Account>();
        while (iterator.hasNext()) {
                    Account account = (Account)iterator.next();
                    account.Total_Amount__c = 0;
                    accounts.add(account);
                    resultAccount.put(account.Id, account);
        }

        return accounts;
    }

    public void execute(Database.BatchableContext bc, List<Account> accounts){
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

    public static void updateParentAmount(Account account, Decimal amount) {
        if(account.ParentId != null) {
            Account parentAccount = resultAccount.get(account.ParentId);
            parentAccount.Total_Amount__c += amount;
            updateParentAmount(parentAccount, amount);
            resultAccount.put(account.ParentId, parentAccount); 
        }
        resultAccount.put(account.Id, account); 
    }
}