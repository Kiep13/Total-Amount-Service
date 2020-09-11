public with sharing class TotalAmountService implements Database.Batchable<sObject>, Database.Stateful {

    public Map<Id, AccountHierarchy> hierarchy;
    public TotalAmountCalculator amountCalculator;

    public TotalAmountService(Map<Id, AccountHierarchy> hierarchyMap) {
        hierarchy = hierarchyMap;
        amountCalculator = new TotalAmountCalculator();
    }

    public List<Account> start(Database.BatchableContext bc) {
        List<Account> accounts = new List<Account>();
        for(AccountHierarchy accountHierarchy: hierarchy.values()) {
            accounts.add(accountHierarchy.account);
        }
        return accounts;
    }

    public void execute(Database.BatchableContext bc, List<Account> accounts){

        List<Account> results = new List<Account>();
        for (Account account : accounts) {
            AccountHierarchy node = hierarchy.get(account.Id);
            amountCalculator.solveTotalAmount(node);

            results.add(node.account);
            results.addAll(node.getChilrens());
            hierarchy.remove(account.Id);
        }
        update results;
    }

    public void finish(Database.BatchableContext bc){
    }
}