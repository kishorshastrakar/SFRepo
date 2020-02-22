public with sharing class NewApexClass {
    
         public string State;
         public string getState() { return State;}
         public void setState(string value) { State=value;}
    
         public string Line1;
         public string getLine1() { return Line1;}
         public void setLine1(string value) { Line1=value;}
    
    
    public Address__c addStdRecord             {get; set;}
    
    public NewApexClass( ApexPages.StandardController stdController ){
        try {
            addStdRecord = (Address__c) stdController.getRecord();
            if(addStdRecord.Id != null)
            {
            String query = AccessControlUtility.getViewableFieldsQuery( Address__c.getSObjectType(), addStdRecord.Id );
            addStdRecord = Database.query( query );
            }
            List<Schema.SObjectField> viewableFields = AccessControlUtility.getViewableFields( Address__c.getSObjectType() );
            if( !AccessControlUtility.isAuthorizedToView( Address__c.getSObjectType(), new List<Schema.SObjectField>() ) ){
                addStdRecord = null;
                ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.error, 'Access Control violation: Not authorized to view.' ));
            }
        }catch (Exception e ) {
            ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.error, 'Access Control violation: '+e.getMessage() ));
        }
    }
    
    public void insertRecord( ){
        try {
            List<Schema.SObjectField> cretableFields = AccessControlUtility.getCreatableFields( Address__c.getSObjectType() );
            
            if( AccessControlUtility.isAuthorizedToCreate( Address__c.getSObjectType(), cretableFields ) ){
                addStdRecord = (Address__c) AccessControlUtility.insertAsUser( addStdRecord, cretableFields );
            }else{
                ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.error, 'Access Control violation: Not authorized to insert.' ));
            }
        }catch (Exception e ) {
            ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.error, 'Access Control violation: '+e.getMessage() ));
        }
    }
    
    public void updateRecord( ){
        try {
            List<Schema.SObjectField> updatebleFields = AccessControlUtility.getUpdateableFields( Address__c.getSObjectType() );
            
            if( AccessControlUtility.isAuthorizedToUpdate( Address__c.getSObjectType(), updatebleFields ) ){
                addStdRecord = (Address__c) AccessControlUtility.updateAsUser( addStdRecord, updatebleFields );
            }else{
                ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.error, 'Access Control violation: Not authorized to update.' ));
            }
        }catch (Exception e ) {
            ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.error, 'Access Control violation: '+e.getMessage() ));
        }
    }
    
    
}