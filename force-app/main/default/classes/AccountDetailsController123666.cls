public with sharing class AccountDetailsController123666 {
    
         public id Id;
         public id getId() { return Id;}
         public void setId(id value) { Id=value;}
    
         public boolean Isdeleted;
         public boolean getIsdeleted() { return Isdeleted;}
         public void setIsdeleted(boolean value) { Isdeleted=value;}
    
    
    public Account accStdRecord             {get; set;}
    
    public Account countStdRecord             {get; set;}
    
    
    
    public AccountDetailsController123666( ApexPages.StandardController stdController ){
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
    
	
    
    
    
    
}