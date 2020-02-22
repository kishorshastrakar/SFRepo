/************************************************************************************************************
* @author - Persistent
* @date     28-02-2018
* @description - This class will handle logic to check if logged in user has acess to fields or
*				create or update or delete record. If user doesn't have access exception will thrown 
*				
*               
*   
*************************************************************************************************************/
public class AccessControlUtility {
    
    /*******************************************************************************************************
    * @author   Persistent
	* @date     28-02-2018
    * @description  This method will check if logged in user has access to fields from supplied field set 
    *				
    * @param    devObj - SObject in context for which field accessibility needs to be checked  
    			fieldsToSet - Field set from which fields should be populated in object        
    * @return   SObject 
    ********************************************************************************************************/
    public static SObject viewAsUser(SObject devObj, List<Schema.SObjectField> fieldsToSet) {
        // start from a fresh sObject of same type and only set fields the user is allowed to set
        sObject cleanObj = devObj.getSObjectType().newSObject();

        // set all fields that were requested and the user has permission to set - throw an exception if a field was requested 
        //and user can't set and in ALL_OR_NONE mode           
        for (Schema.SObjectField field : fieldsToSet) {
            if (field.getDescribe().isAccessible() ) {
                cleanObj.put(field, devObj.get(field));
            }
        }
        
        return cleanObj;
    }
    
     /*******************************************************************************************************
    * @author   Persistent
	* @date     28-02-2018
    * @description  This method will check accessibility of logged in user to insert supplied object 
    *				has access to
    * @param    devObj - SObject in context for which user accessibility needs to be checked  
    			fieldsToSet - Field set from which fields should be populated in object        
    * @return   SObject 
    ********************************************************************************************************/
    public static SObject insertAsUser(SObject devObj, List<Schema.SObjectField> fieldsToSet) {
        if (devObj == null || fieldsToSet == null || fieldsToSet.size() == 0)
            throw new AccountAccessControlException('null or empty parameter');
        
        Schema.DescribeSObjectResult d = devObj.getSObjectType().getDescribe();
        if (d.isCreateable() == false) 
            throw new AccountAccessControlException('Access Violation');

        // start from a fresh sObject of same type and only set fields the user is allowed to set
        sObject cleanObj = devObj.getSObjectType().newSObject();

        // set all fields that were requested and the user has permission to set - throw an exception if a field was requested 
        //and user can't set and in ALL_OR_NONE mode           
        for (Schema.SObjectField field : fieldsToSet) {
            if (field.getDescribe().isCreateable() == false) {
                // field is not allowed to be created by current user
                throw new AccountAccessControlException('Access Violation');
            }
            else {
                // user has permission to set fieldName and it was request by the developer - so set it
                // if the developer did not set this field and it is required, we should get an exception 
                // when we set it here, or when we perform the actual insert.
                if( devObj.get(field) != NULL )
                    cleanObj.put(field, devObj.get(field));
            }
        }
        
        try {
            // call dbInsert() to enforce sharing rules if required
            dbInsert(cleanObj);
        } catch (Exception e) {
            throw new AccountAccessControlException('Failed to insert object: '+e.getMessage());
        }
        return cleanObj;
    }
    
     /*******************************************************************************************************
    * @author   Persistent
	* @date     28-02-2018
    * @description  Method to insert any sObject 
    *				
    * @param    obj - SObject to be inserted  
    			   
    * @return   void 
    ********************************************************************************************************/    
    public static void dbInsert(sObject obj) { 
        insert obj; 
    }
    
    /*******************************************************************************************************
    * @author   Persistent
	* @date     28-02-2018
    * @description  This method will check accessibility of logged in user to insert supplied object 
    *				has access to
    * @param    devObj - SObject in context for which user accessibility needs to be checked  
    			fieldsToSet - Field set from which fields should be populated in object        
    * @return   SObject 
    ********************************************************************************************************/
    
    public static SObject updateAsUser(SObject devObj, List<Schema.SObjectField> fieldsToUpdate) {
        if (devObj == null || fieldsToUpdate == null || fieldsToUpdate.size() == 0)
            throw new AccountAccessControlException('null or empty parameter');
        
        Schema.DescribeSObjectResult d = devObj.getSObjectType().getDescribe();
        if (d.isUpdateable() == false) 
            throw new AccountAccessControlException('Access Violation');
                                                    
        // first load the existing object as current user (enforcing sharing based on sharing mode)
        SObject cleanObj = getObject(devObj);
        if (cleanObj == null)
            throw new AccountAccessControlException('Record does not exist or not shared with current user');

        // set all fields that were requested and the user has permission to update - throw an exception 
        //if a field was requested and user can't update and in ALL_OR_NONE mode         
        for (Schema.SObjectField field : fieldsToUpdate) {
            if (field.getDescribe().isUpdateable() == false) {
                // field is not allowed to be updated by current user
                throw new AccountAccessControlException('Access Violation');
            }
            else {
                // user has permission to update fieldName and it was request by the developer - so update it
                if( devObj.get(field) != NULL )
                    cleanObj.put(field, devObj.get(field));
            }
        }
        
        try {
            // call dbUpdate() to enforce sharing rules if required
            dbUpdate(cleanObj);
        } catch (Exception e) {
            throw new AccountAccessControlException('Failed to update object: '+e.getMessage());
        }
        return cleanObj;
    }
    
    /*******************************************************************************************************
    * @author   Persistent
	* @date     28-02-2018
    * @description  This method will fetch all the fields for supplied sobject record id 
    *				has access to
    * @param    sobj - this object will contain the id for record for which field values should be fetched  
    			        
    * @return   SObject 
    ********************************************************************************************************/
    private static SObject getObject(sObject obj) {
        String Soql = 'SELECT Id FROM ' + obj.getSObjectType().getDescribe().getName() + ' WHERE Id=\'' + String.escapeSingleQuotes(obj.Id) + '\'';
        List<SObject> res;
        try {
            // call dbQuery() to enforce sharing rules if required
            res = dbQuery(Soql);
        } catch (Exception e) {
            throw new AccountAccessControlException('Failed to query object: '+e.getMessage());
        }
        
        if (res.isEmpty() == True) {
            return null;
        }
        else { 
            return res.get(0);
        }
    }
    
    /*******************************************************************************************************
    * @author   Persistent
	* @date     28-02-2018
    * @description  This method will query and return result from supplied query string 
    *				has access to
    * @param    query - String query which needs to be executed  
    			        
    * @return   List<Sobject> - List of result set from query 
    ********************************************************************************************************/
    private static List<SObject> dbQuery(String query){ 
        return Database.query(query); 
    }
    
    /*******************************************************************************************************
    * @author   Persistent
	* @date     28-02-2018
    * @description  Method to insert any sObject 
    *				
    * @param    obj - SObject to be updated  
    			  
    * @return   void 
    ********************************************************************************************************/    
    public static void dbUpdate(sObject obj){ 
        update obj; 
    }
    
    /*******************************************************************************************************
    * @author   Persistent
	* @date     28-02-2018
    * @description  This method will delete the supplied Sobject record
    * @param    sobj - this object will contain the id for record   
    			        
    * @return   void 
    ********************************************************************************************************/
    public static void deleteAsUser(SObject devObj) {
        if (devObj == null)
            throw new AccountAccessControlException('null parameter');
        
        Schema.DescribeSObjectResult d = devObj.getSObjectType().getDescribe();
        if (d.isDeletable() == false) 
            throw new AccountAccessControlException('Access Violation');

        try {
            // call dbDelete() to enforce sharing rules if required
            dbDelete(devObj);
        } catch (Exception e) {
            throw new AccountAccessControlException('Failed to delete object: '+e.getMessage());
        }
    }
    
    /*******************************************************************************************************
    * @author   Persistent
	* @date     28-02-2018
    * @description  This method will fetch all the fields for supplied sobject record id 
    *				has access to
    * @param    sobj - this object will contain the id for record for which field values should be fetched  
    			        
    * @return   SObject 
    ********************************************************************************************************/
    public static void dbDelete(sObject obj) { 
        delete obj;
    }
    
    public static String getViewableFieldsQuery(SObjectType someObjType, Id recId ) {
        List<Schema.SObjectField> viewableFields = getViewableFields(someObjType);
        
        String fieldQuery = '';
        for( Schema.SObjectField fld : viewableFields ){
            fieldQuery += fld.getDescribe().getName()+', ';
        }
        fieldQuery = fieldQuery.removeEnd(', ');
        
        String query = '';
        if( String.isBlank(fieldQuery) ){
            query = 'Select id from '+someObjType.getDescribe().getName()+' where id = \''+recId+'\'';
        }else{
            query = 'Select '+fieldQuery+' from '+someObjType.getDescribe().getName()+' where id = \''+recId+'\'';
        }
        
        return query;
    }
    
    
    public static String getQueryForFilteredList(SObjectType someObjType, list<String> filterFields, list<String> filterValues, String conditionANDOR, 
    												String orderby, String orderType ) {
        List<Schema.SObjectField> viewableFields = getViewableFields(someObjType);
        
        String fieldQuery = '';
        for( Schema.SObjectField fld : viewableFields ){
            fieldQuery += fld.getDescribe().getName()+', ';
        }
        fieldQuery = fieldQuery.removeEnd(', ');
        
        String query = '';
        if( String.isBlank(fieldQuery) ){
            query = 'Select id from '+someObjType.getDescribe().getName();
        }else{
            query = 'Select '+fieldQuery+' from '+someObjType.getDescribe().getName();
        }
        
        //Add where clause with filter criteria in 'AND' or 'OR' logic as mentioned in 'conditionANDOR'
        if(filterFields != null && filterValues != null && filterFields.size() > 0 && filterValues.size() > 0 && filterFields.size() == filterValues.size()){
        	query += ' where ';
        	
        	//if no logical condition mentioned, set it default as 'AND'
        	if(String.isBlank(conditionANDOR)){
        		conditionANDOR = 'AND';
        	}
        	
	        for(Integer i = 0; i < filterFields.size(); i++){
	        	query += filterFields[i] + ' = \'' + filterValues[i] +'\' '+conditionANDOR;
	        }
	        query = query.removeEnd(conditionANDOR);
	    }
        
        //add order clause 
        if(!String.isBlank(orderby)){
        	query += ' order by '+orderby;
        	
        	if(String.isBlank(orderType)){
        		orderType = 'ASC NULLS FIRST';
        	}
        	query += ' '+orderType;
        }
        
        
        //Add limit clause
        query += ' limit '+(Limits.getLimitQueryRows() - Limits.getQueryRows());
        return query;
    }
    
    public static Map<String, Map<String, Schema.SObjectField>> FIELD_CACHE = new Map<String, Map<String, Schema.SObjectField>>();
    
    // Shortcut function
    public static Map<String,Schema.SObjectField> getFieldMap(SObjectType someType){
        return fieldMapFor(someType);
    }
    
    public static Map<String, Schema.SObjectField> fieldMapFor(Schema.SObjectType objectType) {
        Map<String, Schema.SObjectField> fieldMap = null;
        Schema.DescribeSObjectResult d = objectType.getDescribe(); // added since we use this more than once
        String sobjName = d.getName();
        //String normalizedObjectType = sobjName.toLowerCase(); // not needed    
        if (FIELD_CACHE.containsKey(sobjName)) {
            fieldMap = FIELD_CACHE.get(sobjName);
        } else {
            fieldMap = d.fields.getMap();
            // cache it for next use
            FIELD_CACHE.put(sobjName, fieldMap);
        }

        return fieldMap;
    }
        
    public static List<Schema.SObjectField> getViewableFields(SObject someObj) {
        return getViewableFields(someObj.getSObjectType());
    }
    
    public static List<Schema.SObjectField> getUpdateableFields(SObject someObj) {
        return getUpdateableFields(someObj.getSObjectType());
    }
    
    public static List<Schema.SObjectField> getCreatableFields(SObject someObj) {
        return getCreatableFields(someObj.getSObjectType());
    }
    
    public static boolean isAuthorizedToView(Schema.SObjectType someType, List<Schema.SObjectField> fields) {
        // check at object-level first
        if (!someType.getDescribe().isAccessible()){
            return false;
        }
        
        // check each field
        for (Schema.SObjectField f : fields) {
            if (!f.getDescribe().isAccessible()){
                return false;
            }
        }
        return true;
    }
    
    public static boolean isAuthorizedToUpdate(Schema.SObjectType someType, List<Schema.SObjectField> fields) {
        // check at object-level first
        if (!someType.getDescribe().isUpdateable()){
            return false;
        }
        
        // check each field
        for (Schema.SObjectField f : fields) {
            if (!f.getDescribe().isUpdateable()){
                return false;
            }
        }
        return true;
    }
        
    public static boolean isAuthorizedToCreate(Schema.SObjectType someType, List<Schema.SObjectField> fields) {
        // check at object-level first
        if (!someType.getDescribe().isCreateable()){
            return false;
        }
        
        // check each field
        for (Schema.SObjectField f : fields) {
            if (!f.getDescribe().isCreateable()){
                return false;
            }
        }
        return true;
    }
    
    public static boolean isAuthorizedToDelete(Schema.SObjectType someType) {
        // we only need to check CRUD
        return someType.getDescribe().isDeletable();
    }    
    
    public static List<Schema.SObjectField> getViewableFields(SObjectType someType) {
        Map<String,Schema.SObjectField> fieldsMap = getFieldMap(someType);
        return getViewableFields(fieldsMap);
    }
    
    public static List<Schema.SObjectField> getUpdateableFields(SObjectType someType) {
        Map<String,Schema.SObjectField> fieldsMap = getFieldMap(someType);
        return getUpdateableFields(fieldsMap);
    }
    
    public static List<Schema.SObjectField> getCreatableFields(SObjectType someType) {
        Map<String,Schema.SObjectField> fieldsMap = getFieldMap(someType);
        return getCreatableFields(fieldsMap);
    }
    
    public static List<Schema.SObjectField> getViewableFields(Map<String,Schema.SObjectField> fieldsMap) {
        List<Schema.SObjectField> fields = new List<Schema.SObjectField>{};
        for(String key:fieldsMap.keySet()) {
            if(fieldsMap.get(key).getDescribe().isAccessible()) {
                fields.add(fieldsMap.get(key));
            }
        }
        return fields;
    }
    
    public static List<Schema.SObjectField> getUpdateableFields(Map<String,Schema.SObjectField> fieldsMap) {
        List<Schema.SObjectField> fields = new List<Schema.SObjectField>{};
        for(String key:fieldsMap.keySet()) {
            if(fieldsMap.get(key).getDescribe().isUpdateable()) {
                fields.add(fieldsMap.get(key));
            }
        }
        return fields;
    }
    
    public static List<Schema.SObjectField> getCreatableFields(Map<String,Schema.SObjectField> fieldsMap) {
        List<Schema.SObjectField> fields = new List<Schema.SObjectField>{};
        for(String key:fieldsMap.keySet()) {
            if(fieldsMap.get(key).getDescribe().isCreateable()) {
                fields.add(fieldsMap.get(key));
            }
        }
        return fields;
    }
    
    public class AccountAccessControlException extends Exception {
        
    }
    
    
    public static list<SelectOption> getPicklistValues(SObject objApi, String fldApi){       
		
       /* Get a list of picklist values from an existing object field.*/
      list<SelectOption> options 				= new list<SelectOption>();      
      Schema.sObjectType objType 				= objApi.getSObjectType();	// Get the object type of the SObject.     
      Schema.DescribeSObjectResult objDescribe 	= objType.getDescribe(); // Describe the SObject using its object type.            
      map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); // Get a map of fields for the SObject      
      list<Schema.PicklistEntry> values 		= fieldMap.get(fldApi).getDescribe().getPickListValues(); // Get the list of picklist values for this field.
       
        
      /* *Add these values to the orgPicklstValues list.*/
      for (Schema.PicklistEntry a : values){
      	options.add(new SelectOption(a.getLabel(), a.getValue()));
      }
      return options;        
        
    }  
}