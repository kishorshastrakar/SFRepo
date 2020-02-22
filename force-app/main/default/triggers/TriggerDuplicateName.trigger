trigger TriggerDuplicateName on Account (before insert,before Update) {
  // code_block
   
     Map<String, Account> AccountNameMap = new Map<String, Account>();
     for (Account Account : System.Trigger.new) {
         
         if ((Account.Name   != null) && (System.Trigger.isInsert || (Account.Name != System.Trigger.oldMap.get(Account.Id).Name))) {
             
                        if (AccountNameMap.containsKey(Account.Name)) {
                            Account.Name.addError('Another new Account has the '+ 'same name .');
                         } else {
                               AccountNameMap.put(Account.Name, Account);
                          }
             }
     }
     
        for (Account Account : [SELECT Name FROM Account WHERE Name IN :AccountNameMap.KeySet()]) 
        {
            Account newAccount = AccountNameMap.get(Account.Name);
            newAccount.Name.addError('A Account with this name '+ '  already exists.');
        }

}