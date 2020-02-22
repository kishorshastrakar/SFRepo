public class AuraComponentApex{
    @AuraEnabled
    public static List<Address__c> fetchRecords(){
     return [select Home_Phone__c,Line1__c,Line2__c,Mobile__c,State__c,City__c,Zip__c from Address__c Order By CreatedDate desc];
    }
	@AuraEnabled
    public static void saveDetails (Address__c regForm1){ 
    	insert regForm1;
    }
}