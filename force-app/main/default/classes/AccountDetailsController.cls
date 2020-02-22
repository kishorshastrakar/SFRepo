public with sharing class AccountDetailsController {
    
     
         public String Name;
         public String getName() { return Name;}
         public void setName(String value) { Name=value;}
    
         public String Accountnumber;
         public String getAccountnumber() { return Accountnumber;}
         public void setAccountnumber(String value) { Accountnumber=value;}
    
    

    public Account accStdRecord             {get; set;}
    
    public AccountDetailsController( ApexPages.StandardController stdController ){
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
    
    public void deleteRecord( ){
        try {
            if( AccessControlUtility.isAuthorizedToDelete( Account.getSObjectType() ) ){
                AccessControlUtility.deleteAsUser( accStdRecord );
            }else{
                ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.error, 'Access Control violation: Not authorized to delete.' ));
            }
        }catch (Exception e ) {
            ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.error, 'Access Control violation: '+e.getMessage() ));
        }
    }
}