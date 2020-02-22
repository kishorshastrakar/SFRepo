public class CreateRecord{
    public  Contact  contact {get;set;} 
    
//Please Do not Select ID 
    public CreateRecord(){
        if(ApexPages.CurrentPage().getparameters().get('id')!=null){
          contact =  [
             SELECT Id	,FirstName,LastName,Email,OtherCountry,MobilePhone,OtherState,OtherPostalCode
            FROM Contact   WHERE Id =: ApexPages.CurrentPage().getparameters().get('id')
             
             ];
        }else{
            contact = new Contact();
        }
    }
    public PageReference save(){
         PageReference pg=new PageReference('/apex/CreateRecordVFPage');
        try {
       			 upsert  contact;
       			 pg.setRedirect(true);
       			  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Record Saved Successfully'));
            } catch (DmlException e) {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Failed to Update')); 
                }        
                return pg;
    }  
 
    //VFPageName = VF Page To Redirect
     public PageReference cancel(){
        PageReference pg=new PageReference('/apex/CreateRecordVFPage');
        pg.setRedirect(true);
        return pg;     
    }
    
}