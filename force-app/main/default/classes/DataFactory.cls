@isTest
public class DataFactory {
    public static List<Account> createAccount(Integer quantity) {
        List<Account> acctList = new List<Account>();
        for(Integer i=0; i<quantity; i++) {
           	acctList.add(new Account(Name='Test '+i, Subscription_type__c='Total', Subscription_duration__c='3', 
                                      Subscription_start_date__c=Date.today()));
        }
        return acctList;
    }
    
    public static List<Avatar__c> createAvatar(Integer quantity, Account accountRelated) {
        List<Avatar__c> avtList = new List<Avatar__c>();
        for(Integer i=0; i<quantity; i++) {
            avtList.add(new Avatar__c(Name='Avatar '+i, Account__c=accountRelated.Id));
        }
        return avtList;
    }
}