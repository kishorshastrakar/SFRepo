public class listViewRecords{
    public integer totalRecs=0;
    private integer OffsetSize=0;
    private integer LimitSize=5;
     public String contIdChosen  {get;set;} 
    public listViewRecords(ApexPages.StandardController controller){
    }
    public List<Contact> getLists(){
        totalRecs=[Select Count() from Contact];
               
    List<Contact>alist=Database.query('select  FirstName, LastName, Email, OtherCountry, MobilePhone, OtherState,OtherPostalCode from Contact order by CreatedDate desc LIMIT:LimitSize OFFSET:OffsetSize');                                           
		return alist;
    }
    //to delete Record
     public void deleteData() {      
          Contact[] deletecontact = [SELECT Id  FROM  Contact WHERE Id = :contIdChosen]; 
			try {
  				  delete deletecontact; 
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