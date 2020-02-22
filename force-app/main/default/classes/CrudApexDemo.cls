public class CrudApexDemo{
    public integer totalRecs=0;
    private integer OffsetSize=0;
    private integer LimitSize=5;
     public String contIdChosen  {get;set;} 
    public CrudApexDemo(ApexPages.StandardController controller){
    }
    public List<Address__c> getLists(){
        totalRecs=[Select Count() from Address__c];
             
    List<Address__c>alist=Database.query('select  State__c, Line1__c, Line2__c, City__c,Zip__c from Address__c order by CreatedDate desc LIMIT:LimitSize OFFSET:OffsetSize');                                           
		return alist;
    }
    //to delete Record
     public void deleteData() {      
          Address__c[] deleteaddress = [SELECT Id  FROM  Address__c WHERE Id = :contIdChosen]; 
			try {
  				  delete deleteaddress; 
				} catch (DmlException e) {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Failed to Delete')); 
                }
    }
    public void FirstPage(){
        OffsetSize=0;
        getLists();
    }
    public void previous(){
        OffsetSize=OffsetSize-LimitSize;
        getLists();
    }
    public void next(){
        OffsetSize=OffsetSize+LimitSize;
        getLists();
    }
    public void LastPage(){
        OffsetSize=totalrecs-math.mod(totalRecs, LimitSize);
        getLists();
    }
    public boolean getprev(){
        if(OffsetSize==0){
            return true;
        }
        else{
            return false;
        }
    }
    public boolean getnxt(){
        if((OffsetSize+LimitSize)>totalRecs)
            return true;
        else
            return false;
    }
    public Integer getTotal_size() {
        return totalRecs;
    }
    public Integer getPageNumber() {
        return OffsetSize/LimitSize + 1;
    }
    public Integer getTotalPages() {
        if (math.mod(totalRecs, LimitSize) > 0) {
            return totalRecs/LimitSize + 1;
        }
        else {
            return (totalRecs/LimitSize);
        }
    }
   
}