@IsTest
public with sharing class TotalAmountServiceTest {
    
    public static Decimal FIRST_ACCOUNT_AMOUNT = 1800;
    public static Decimal SECOND_ACCOUNT_AMOUNT = 1500;
    public static Decimal FOURTH_ACCOUNT_AMOUNT = 900;
    public static Decimal SIXTH_ACCOUNT_AMOUNT = 300;
    
    public static Decimal THIRD_ACCOUNT_AMOUNT = 1200;
    public static Decimal FIFTH_ACCOUNT_AMOUNT = 600;

    public static String INVALID_AMOUNT_MESSAGE = 'Invalid total amount of account';

    @TestSetup
    static void makeData(){

        List<Account> accounts = new List<Account>();

        for(Integer i = 0; i < 6; i++) {
            Account account = new Account(	Name = 'Test ' + i);
            accounts.add(account);
        } 
        
        insert accounts;

        for(Integer i = 0; i < accounts.size()/2 - 1; i++) {
            accounts[i].ParentId = accounts[i + 1].Id;
        }

        for(Integer i = accounts.size()/2; i < accounts.size() - 1; i++) {
            accounts[i].ParentId = accounts[i + 1].Id;
        }

        accounts[accounts.size() - 1].ParentId = accounts[0].Id;

        upsert accounts;

        List<Opportunity> opportunities = new List<Opportunity>();

        for(Account account : accounts) {
            for(Integer i = 0; i < 3; i++) {
                Opportunity opportunity = new Opportunity(Name = 'Test', 
                                                          StageName = 'Closed Won',
                                                          CloseDate = Date.today().addDays(1),
                                                          Amount = 100,
                                                          AccountId = account.Id);
                opportunities.add(opportunity);
            }
            
        }

        insert opportunities;
    }

    @IsTest
    public static void checkTotalAmount() {

        Test.startTest();
        TotalAmountPreparation totalAmountService = new TotalAmountPreparation();
        Id batchId = Database.executeBatch(totalAmountService);
        Test.stopTest();

        List<Account> accounts = [SELECT Total_Amount__c FROM Account];

        for(Integer i = accounts.size(), j = 1; i < accounts.size(); i++) {
            System.assertEquals(300 * j, accounts[i].Total_Amount__c, INVALID_AMOUNT_MESSAGE);
            j++;
        }

        for(Integer i = 0, j = accounts.size()/2 + 1; i < accounts.size()/2; i++) {
            System.assertEquals(300 * j, accounts[i].Total_Amount__c, INVALID_AMOUNT_MESSAGE);
            j++;
        }
    }
}