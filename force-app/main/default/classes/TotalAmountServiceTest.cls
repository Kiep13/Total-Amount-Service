@IsTest
public with sharing class TotalAmountServiceTest {
    
    
    public static Decimal FIRST_ACCOUNT_AMOUNT = 1800;
    public static Decimal SECOND_ACCOUNT_AMOUNT = 1500;
    public static Decimal THIRD_ACCOUNT_AMOUNT = 1200;
    public static Decimal FOURTH_ACCOUNT_AMOUNT = 900;
    public static Decimal FIFTH_ACCOUNT_AMOUNT = 600;
    public static Decimal SIXTH_ACCOUNT_AMOUNT = 300;
    public static String INVALID_AMOUNT_MESSAGE = 'Invalid total amount of account';

    @TestSetup
    static void makeData(){

        List<Account> accounts = new List<Account>();

        for(Integer i = 0; i < 6; i++) {
            Account account = new Account(	Name = 'Test ' + i);
            accounts.add(account);
        } 
        
        insert accounts;

        accounts[1].ParentId = accounts[0].Id;
        accounts[2].ParentId = accounts[1].Id;
        accounts[3].ParentId = accounts[2].Id;
        accounts[4].ParentId = accounts[3].Id;
        accounts[5].ParentId = accounts[4].Id;

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
        TotalAmountService totalAmountService = new TotalAmountService();
        Id batchId = Database.executeBatch(totalAmountService);
        Test.stopTest();

        List<Account> accounts = [SELECT Total_Amount__c FROM Account];

        System.assertEquals(FIRST_ACCOUNT_AMOUNT, accounts[0].Total_Amount__c, INVALID_AMOUNT_MESSAGE);
        System.assertEquals(SECOND_ACCOUNT_AMOUNT, accounts[1].Total_Amount__c, INVALID_AMOUNT_MESSAGE);
        System.assertEquals(THIRD_ACCOUNT_AMOUNT, accounts[2].Total_Amount__c, INVALID_AMOUNT_MESSAGE);
        System.assertEquals(FOURTH_ACCOUNT_AMOUNT, accounts[3].Total_Amount__c, INVALID_AMOUNT_MESSAGE);
        System.assertEquals(FIFTH_ACCOUNT_AMOUNT, accounts[4].Total_Amount__c, INVALID_AMOUNT_MESSAGE);
        System.assertEquals(SIXTH_ACCOUNT_AMOUNT, accounts[5].Total_Amount__c, INVALID_AMOUNT_MESSAGE);
    }
}