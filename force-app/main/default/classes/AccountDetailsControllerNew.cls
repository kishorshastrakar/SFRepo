public with sharing class AccountDetailsControllerNew {
    
         public string Name;
         public string getName() { return Name;}
         public void setName(string value) { Name=value;}
    
    
    public Account accStdRecord             {get; set;}
    
    public AccountDetailsControllerNew( ApexPages.StandardController stdController ){
        try {
            accStdRecord = (Account) stdController.getRecord();
            if(accStdRecord.Id != null)
            {
            String query = AccessControlUtility.getViewableFieldsQuery( Account.getSObjectType(), accStdRecord.Id );
            accStdRecord = Database.query( query );
            }
            List<Schema.SObjectField> viewableFields = AccessControlUtility.getViewableFields( Account.getSObjectType() );
            if( !AccessControlUtility.isAuthorizedToView( Account.getSObjectType(), new List<Schema.SObjectField>() ) ){
                accStdRecord = null;
                ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.error, 'Access Control violation: Not authorized to view.' ));
            }
        }catch (Exception e ) {
            ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.error, 'Access Control violation: '+e.getMessage() ));
        }
    }
    
    public void insertRecord( ){
        try {
            List<Schema.SObjectField> cretableFields = AccessControlUtility.getCreatableFields( Account.getSObjectType() );
            
            if( AccessControlUtility.isAuthorizedToCreate( Account.getSObjectType(), cretableFields ) ){
                accStdRecord = (Account) AccessControlUtility.insertAsUser( accStdRecord, cretableFields );
            }else{
                ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.error, 'Access Control violation: Not authorized to insert.' ));
            }
        }catch (Exception e ) {
            ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.error, 'Access Control violation: '+e.getMessage() ));
        }
    }
    
    public void updateRecord( ){
        try {
            List<Schema.SObjectField> updatebleFields = AccessControlUtility.getUpdateableFields( Account.getSObjectType() );
            
            if( AccessControlUtility.isAuthorizedToUpdate( Account.getSObjectType(), updatebleFields ) ){
                accStdRecord = (Account) AccessControlUtility.updateAsUser( accStdRecord, updatebleFields );
            }else{
                ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.error, 'Access Control violation: Not authorized to update.' ));
            }
        }catch (Exception e ) {
            ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.error, 'Access Control violation: '+e.getMessage() ));
        }
    }
    
    
}