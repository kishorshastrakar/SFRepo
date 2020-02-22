public class listViewRecords1 {
  public integer totalRecs=0;
    private integer OffsetSize=0;
    private integer LimitSize=5;
     public String contIdChosen  {get;set;} 
    public listViewRecords1(ApexPages.StandardController controller){    }
    public List<Account> getLists(){
        totalRecs=[Select Count() from Account];
            
    List<Account> alist=Database.query('select  Id, Name from Account order by CreatedDate desc  LIMIT:LimitSize OFFSET:OffsetSize');                                           
		return alist;
    }
     public void deleteData() {      
          Account[] deleteaccount = [SELECT Id  FROM  Account WHERE Id = :contIdChosen]; 
			try {
  				  delete deleteaccount;  
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