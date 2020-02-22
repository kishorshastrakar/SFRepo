public with sharing class Address_Details_Controller {
    
         public string State;
         public string getState() { return State;}
         public void setState(string value) { State=value;}
    
         public string City;
         public string getCity() { return City;}
         public void setCity(string value) { City=value;}
    
         public double Zip;
         public double getZip() { return Zip;}
         public void setZip(double value) { Zip=value;}
    
    
    public Address__c addStdRecord             {get; set;}
    
    public Address_Details_Controller( ApexPages.StandardController stdController ){
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