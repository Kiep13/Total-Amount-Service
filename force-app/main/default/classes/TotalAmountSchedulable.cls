public with sharing class TotalAmountSchedulable implements Schedulable {
    public void execute(SchedulableContext ctx) {
        Database.executeBatch(new TotalAmountService());
    }
}