@IsTest
public with sharing class TotalAmountSchedulableTest {

    public static String CRON_EXP = '0 0 0 ? * 5';
    public static String SCHEDULABLE_JOB_TITLE = 'TotalAmountSchedulable';

    public static String NOT_EXPECT_JOBS = 'Not expect any async jobs';
    public static String EXPECTED_SCHEDULABLE_JOB = 'Expected one schedulable job';
    public static String WRONG_SCHEDULABLE_TITLE = 'Invalid schedulable job\'s title';
    public static String EXPECTED_BATCH_JOB = 'Expected one batch job';

    @IsTest
    public static void checkSchedulableExecuting() {

        List<AsyncApexJob> jobsBefore = [select Id, ApexClassID, ApexClass.Name, Status, JobType from AsyncApexJob];
        System.assertEquals(0, jobsBefore.size(), NOT_EXPECT_JOBS);
    
        Test.startTest();
        String jobId = System.schedule(SCHEDULABLE_JOB_TITLE, CRON_EXP, new TotalAmountSchedulable());
        Test.stopTest();

        List<AsyncApexJob> jobsScheduled = [select Id, ApexClassID, ApexClass.Name, Status, JobType from AsyncApexJob where JobType = 'ScheduledApex'];
        System.assertEquals(1, jobsScheduled.size(), EXPECTED_SCHEDULABLE_JOB);
        System.assertEquals(SCHEDULABLE_JOB_TITLE, jobsScheduled[0].ApexClass.Name, WRONG_SCHEDULABLE_TITLE);
    
        List<AsyncApexJob> jobsApexBatch = [select Id, ApexClassID, ApexClass.Name, Status, JobType from AsyncApexJob where JobType = 'BatchApex'];
        System.assertEquals(1, jobsApexBatch.size(), EXPECTED_BATCH_JOB);
    
    }
}