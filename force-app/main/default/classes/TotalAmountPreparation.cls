public with sharing class TotalAmountPreparation implements Database.Batchable<sObject>, Database.Stateful {
    public static Map<Id, Account> resultedAccounts = new Map<Id, Account>();

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, Total_Amount__c, ParentId, ' +
                                         + '(SELECT Amount, StageName FROM Opportunities WHERE StageName = \'Closed Won\') ' +
                                        + 'FROM Account');
    }

    public void execute(Database.BatchableContext bc, List<Account> accounts){
        for (Account account : accounts) {
            resultedAccounts.add(account);
        }

    }

    public void finish(Database.BatchableContext bc){
        Database.executeBatch(resultedAccounts);
    }
}
