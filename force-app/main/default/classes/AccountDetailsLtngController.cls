public class AccountDetailsLtngController {

	
            public id Id;
            public id getId() { return Id;}
            public void setId(id value) { Id=value;}
    
            public string Name;
            public string getName() { return Name;}
            public void setName(string value) { Name=value;}
    
	
  
    public static Account initializeRecord( Id recId ){
        Account accStdRecord;
        try {
            if(recId != null)
            {
            String query = AccessControlUtility.getViewableFieldsQuery( Account.getSObjectType(), recId );
            accStdRecord = Database.query( query );
            }
            List<Schema.SObjectField> viewableFields = AccessControlUtility.getViewableFields( Account.getSObjectType() );
            if( !AccessControlUtility.isAuthorizedToView( Account.getSObjectType(), new List<Schema.SObjectField>() ) ){
                accStdRecord = null;
                throw new AuraHandledException('Access Control violation: Not authorized to view.');
            }
        }catch (Exception e ) {
            throw new AuraHandledException('Access Control violation: '+e.getMessage());
        }
        
        return accStdRecord;
    }
    
 
    public static Account insertRecord( Account accRec ){
        try {
            List<Schema.SObjectField> cretableFields = AccessControlUtility.getCreatableFields( Account.getSObjectType() );
            
            if( AccessControlUtility.isAuthorizedToCreate( Account.getSObjectType(), cretableFields ) ){
                accRec = (Account) AccessControlUtility.insertAsUser( accRec, cretableFields );
            }else{
                throw new AuraHandledException('Access Control violation: Not authorized to insert.');
            }
        }catch (Exception e ) {
            throw new AuraHandledException('Access Control violation: '+e.getMessage());
        }
        return accRec;
    }
    
    
    public static Account updateRecord( Account accRec ){
        try {
            List<Schema.SObjectField> updatebleFields = AccessControlUtility.getUpdateableFields( Account.getSObjectType() );
            
            if( AccessControlUtility.isAuthorizedToUpdate( Account.getSObjectType(), updatebleFields ) ){
                accRec = (Account) AccessControlUtility.updateAsUser( accRec, updatebleFields );
            }else{
                throw new AuraHandledException('Access Control violation: Not authorized to update.');
            }
        }catch (Exception e ) {
            throw new AuraHandledException('Access Control violation: '+e.getMessage());
        }
        return accRec;
    }
    
  
    public static void deleteRecord( Account accRec ){
        try {
            if( AccessControlUtility.isAuthorizedToDelete( Account.getSObjectType() ) ){
                AccessControlUtility.deleteAsUser( accRec );
            }else{
                throw new AuraHandledException('Access Control violation: Not authorized to delete.');
            }
        }catch (Exception e ) {
            throw new AuraHandledException('Access Control violation: '+e.getMessage());
        }
    }
    
}