public with sharing class AccountHierarchy {

    public Account account;
    public List<AccountHierarchy> childrens;

    public AccountHierarchy(Account account) {
        this.account = account;
        this.childrens = new List<AccountHierarchy>();
    }

    public List<Account> getChilrens() {
        List<Account> accounts = new List<Account>();
        for(AccountHierarchy accountHierarchy: childrens) {
            accounts.add(accountHierarchy.account);
            accounts.addAll(accountHierarchy.getChilrens());
        }
        return accounts;
    }

    public Boolean isChild(AccountHierarchy adoptHierarchy) {
        if(account.Id == adoptHierarchy.account.ParentId) {
            childrens.add(adoptHierarchy);
            return true;
        } else {
            for (AccountHierarchy child : childrens) {
                if(child.isChild(adoptHierarchy)) {
                    return true;
                }
            }
        }
        return false;
    }
}
