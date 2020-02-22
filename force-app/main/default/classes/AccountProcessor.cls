global class AccountProcessor implements Database.Batchable <SObject> {
    global Database.QueryLocator start(Database.BatchableContext bc){
        String Query='Select id   , Name   from Account where ' ;//add tpur condition  LeadSource=\'WEB\' and Company=\'PSL\'';
        return Database.getQueryLocator(Query);
            }
    global void execute(Database.BatchableContext bc, List<Account> scope){
        for(Account l: scope){
               
             l.Name ='DreamForce' ; 
        }
        update scope;
    }
    global void finish(Database.BatchableContext bc){
        Id job= bc.getJobId();
        System.debug(job);
    }
}