public class TableViewController{
    public List<Address__c> dataList {get; set;}   
    public TableViewController(){    
        dataList = Database.query('select  State__c, Line1__c from Address__c order by CreatedDate desc ');                                           
    }
}