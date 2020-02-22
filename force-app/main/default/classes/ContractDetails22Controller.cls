public with sharing class ContractDetails22Controller {
    
         public date Startdate;
         public date getStartdate() { return Startdate;}
         public void setStartdate(date value) { Startdate=value;}
    
         public date Enddate;
         public date getEnddate() { return Enddate;}
         public void setEnddate(date value) { Enddate=value;}
    
    
    public Contract conStdRecord             {get; set;}
    
    public ContractDetails22Controller( ApexPages.StandardController stdController ){
        try {
            conStdRecord = (Contract) stdController.getRecord();
            if(conStdRecord.Id != null)
            {
            String query = AccessControlUtility.getViewableFieldsQuery( Contract.getSObjectType(), conStdRecord.Id );
            conStdRecord = Database.query( query );
            }
            List<Schema.SObjectField> viewableFields = AccessControlUtility.getViewableFields( Contract.getSObjectType() );
            if( !AccessControlUtility.isAuthorizedToView( Contract.getSObjectType(), new List<Schema.SObjectField>() ) ){
                conStdRecord = null;
                ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.error, 'Access Control violation: Not authorized to view.' ));
            }
        }catch (Exception e ) {
            ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.error, 'Access Control violation: '+e.getMessage() ));
        }
    }
    
    public void insertRecord( ){
        try {
            List<Schema.SObjectField> cretableFields = AccessControlUtility.getCreatableFields( Contract.getSObjectType() );
            
            if( AccessControlUtility.isAuthorizedToCreate( Contract.getSObjectType(), cretableFields ) ){
                conStdRecord = (Contract) AccessControlUtility.insertAsUser( conStdRecord, cretableFields );
            }else{
                ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.error, 'Access Control violation: Not authorized to insert.' ));
            }
        }catch (Exception e ) {
            ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.error, 'Access Control violation: '+e.getMessage() ));
        }
    }
    
    public void updateRecord( ){
        try {
            List<Schema.SObjectField> updatebleFields = AccessControlUtility.getUpdateableFields( Contract.getSObjectType() );
            
            if( AccessControlUtility.isAuthorizedToUpdate( Contract.getSObjectType(), updatebleFields ) ){
                conStdRecord = (Contract) AccessControlUtility.updateAsUser( conStdRecord, updatebleFields );
            }else{
                ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.error, 'Access Control violation: Not authorized to update.' ));
            }
        }catch (Exception e ) {
            ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.error, 'Access Control violation: '+e.getMessage() ));
        }
    }
    
    
    public void deleteRecord( ){
        try {
            if( AccessControlUtility.isAuthorizedToDelete( Contract.getSObjectType() ) ){
                AccessControlUtility.deleteAsUser( conStdRecord );
            }else{
                ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.error, 'Access Control violation: Not authorized to delete.' ));
            }
        }catch (Exception e ) {
            ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.error, 'Access Control violation: '+e.getMessage() ));
        }
    }
    
}