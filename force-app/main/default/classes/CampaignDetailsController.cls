public with sharing class CampaignDetailsController {
    
         public id Id;
         public id getId() { return Id;}
         public void setId(id value) { Id=value;}
    
         public string Name;
         public string getName() { return Name;}
         public void setName(string value) { Name=value;}
    
    
    public Campaign camStdRecord             {get; set;}
    
    public CampaignDetailsController( ApexPages.StandardController stdController ){
        try {
            camStdRecord = (Campaign) stdController.getRecord();
            if(camStdRecord.Id != null)
            {
            String query = AccessControlUtility.getViewableFieldsQuery( Campaign.getSObjectType(), camStdRecord.Id );
            camStdRecord = Database.query( query );
            }
            List<Schema.SObjectField> viewableFields = AccessControlUtility.getViewableFields( Campaign.getSObjectType() );
            if( !AccessControlUtility.isAuthorizedToView( Campaign.getSObjectType(), new List<Schema.SObjectField>() ) ){
                camStdRecord = null;
                ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.error, 'Access Control violation: Not authorized to view.' ));
            }
        }catch (Exception e ) {
            ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.error, 'Access Control violation: '+e.getMessage() ));
        }
    }
    
    public void insertRecord( ){
        try {
            List<Schema.SObjectField> cretableFields = AccessControlUtility.getCreatableFields( Campaign.getSObjectType() );
            
            if( AccessControlUtility.isAuthorizedToCreate( Campaign.getSObjectType(), cretableFields ) ){
                camStdRecord = (Campaign) AccessControlUtility.insertAsUser( camStdRecord, cretableFields );
            }else{
                ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.error, 'Access Control violation: Not authorized to insert.' ));
            }
        }catch (Exception e ) {
            ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.error, 'Access Control violation: '+e.getMessage() ));
        }
    }
    
    public void updateRecord( ){
        try {
            List<Schema.SObjectField> updatebleFields = AccessControlUtility.getUpdateableFields( Campaign.getSObjectType() );
            
            if( AccessControlUtility.isAuthorizedToUpdate( Campaign.getSObjectType(), updatebleFields ) ){
                camStdRecord = (Campaign) AccessControlUtility.updateAsUser( camStdRecord, updatebleFields );
            }else{
                ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.error, 'Access Control violation: Not authorized to update.' ));
            }
        }catch (Exception e ) {
            ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.error, 'Access Control violation: '+e.getMessage() ));
        }
    }
    
    
    public void deleteRecord( ){
        try {
            if( AccessControlUtility.isAuthorizedToDelete( Campaign.getSObjectType() ) ){
                AccessControlUtility.deleteAsUser( camStdRecord );
            }else{
                ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.error, 'Access Control violation: Not authorized to delete.' ));
            }
        }catch (Exception e ) {
            ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.error, 'Access Control violation: '+e.getMessage() ));
        }
    }
    
}