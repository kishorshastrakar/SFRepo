public with sharing class AssetDetailsController {
    
         public string Productcode;
         public string getProductcode() { return Productcode;}
         public void setProductcode(string value) { Productcode=value;}
    
         public string Name;
         public string getName() { return Name;}
         public void setName(string value) { Name=value;}
    
    
    public Asset assStdRecord             {get; set;}
    
    public AssetDetailsController( ApexPages.StandardController stdController ){
        try {
            assStdRecord = (Asset) stdController.getRecord();
            if(assStdRecord.Id != null)
            {
            String query = AccessControlUtility.getViewableFieldsQuery( Asset.getSObjectType(), assStdRecord.Id );
            assStdRecord = Database.query( query );
            }
            List<Schema.SObjectField> viewableFields = AccessControlUtility.getViewableFields( Asset.getSObjectType() );
            if( !AccessControlUtility.isAuthorizedToView( Asset.getSObjectType(), new List<Schema.SObjectField>() ) ){
                assStdRecord = null;
                ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.error, 'Access Control violation: Not authorized to view.' ));
            }
        }catch (Exception e ) {
            ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.error, 'Access Control violation: '+e.getMessage() ));
        }
    }
    
    public void insertRecord( ){
        try {
            List<Schema.SObjectField> cretableFields = AccessControlUtility.getCreatableFields( Asset.getSObjectType() );
            
            if( AccessControlUtility.isAuthorizedToCreate( Asset.getSObjectType(), cretableFields ) ){
                assStdRecord = (Asset) AccessControlUtility.insertAsUser( assStdRecord, cretableFields );
            }else{
                ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.error, 'Access Control violation: Not authorized to insert.' ));
            }
        }catch (Exception e ) {
            ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.error, 'Access Control violation: '+e.getMessage() ));
        }
    }
    
    public void updateRecord( ){
        try {
            List<Schema.SObjectField> updatebleFields = AccessControlUtility.getUpdateableFields( Asset.getSObjectType() );
            
            if( AccessControlUtility.isAuthorizedToUpdate( Asset.getSObjectType(), updatebleFields ) ){
                assStdRecord = (Asset) AccessControlUtility.updateAsUser( assStdRecord, updatebleFields );
            }else{
                ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.error, 'Access Control violation: Not authorized to update.' ));
            }
        }catch (Exception e ) {
            ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.error, 'Access Control violation: '+e.getMessage() ));
        }
    }
    
    
}