@isTest
class AccountTriggerHandlerTest {
	@isTest
    static void getHandlerTestInsert10Accounts() {
        List<Account> acctToInsert = DataFactory.createAccount(10);
        List<String> acctNames = new List<String>();
        for(Account acct : acctToInsert) {
       		acctNames.add(acct.Name);
        }
        
        Test.startTest();
        insert acctToInsert;
        Test.stopTest();
        
        List<Account> accountsInserted = [SELECT Id, Number_of_avatars__c, Subscription_end_date__c FROM Account WHERE Name IN :acctNames]; 
        for (Account acct : accountsInserted) {
        	Assert.areEqual(1, acct.Number_of_avatars__c, 'Something went wrong');
            Assert.areEqual(Date.today().addMonths(3), acct.Subscription_end_date__c, 'Something went wrong');
        }
        Assert.areEqual(10, accountsInserted.size(), 'No se han insertado todas las cuentas');
    }
    
    @isTest
    static void getHandlerTestInsert250Accounts() {
        List<Account> acctToInsert = DataFactory.createAccount(250);
        List<String> acctNames = new List<String>();
        for(Account acct : acctToInsert) {
       		acctNames.add(acct.Name);
        }

        Test.startTest();
       	insert acctToInsert;
        Test.stopTest();
        
        List<Account> accountsInserted = [SELECT Id, Number_of_avatars__c, Subscription_end_date__c FROM Account WHERE Name IN :acctNames];

        for (Account acct : accountsInserted) {
        	Assert.areEqual(1, acct.Number_of_avatars__c, 'Something went wrong');
            Assert.areEqual(Date.today().addMonths(3), acct.Subscription_end_date__c, 'Something went wrong');
        }
        Assert.areEqual(250, accountsInserted.size(), 'No se han insertado todas las cuentas');
    }
    
    @isTest
    static void getHandlerUpdateDurationAccountTest() {
        List<Account> acctList = DataFactory.createAccount(1);
        insert acctList;
        
        List<ID> acctIDs = new List<ID>();
        for(Account acct : acctList) {
        	acctIDs.add(acct.Id); 
            acct.Subscription_duration__c = '6';
        }
        
        Test.startTest();
        update acctList;
        Test.stopTest();
        
        List<Account> acctsUpdated = [SELECT Id, Subscription_end_date__c FROM Account WHERE Id IN :acctIDs]; 
        for(Account acct : acctsUpdated) {
        	Assert.areEqual(Date.today().addMonths(6), acct.Subscription_end_date__c);
        }
    }
    
    @isTest
    static void getHandlerUpdateDuration250AccountTest() {
        List<Account> acctToInsert = DataFactory.createAccount(250);
        List<ID> acctToInsertIDs = new List<ID>();
        insert acctToInsert;        
        for(Account acct : acctToInsert) {
			acct.Subscription_duration__c = '6';
            acctToInsertIDs.add(acct.Id);
        }
        
        Test.startTest();
        update acctToInsert;
        Test.stopTest();
        
        List<Account> acctUpdated = [SELECT Id, Subscription_end_date__c FROM Account WHERE Id IN :acctToInsertIDs]; 
        for(Account up : acctUpdated) {
        	Assert.areEqual(Date.today().addMonths(6), up.Subscription_end_date__c);            
        }
    }
    
    @isTest
    static void getHandlerUpdateStartDateAccountTest() {
        List<Account> acctList = DataFactory.createAccount(1);
        List<String> nameList = new List<String>();
        for(Account acct : acctList) {
            nameList.add(acct.Name);
        }
        insert acctList;
        List<Account> acctsInserted = [SELECT Id, Subscription_start_date__c, Subscription_end_date__c FROM Account WHERE Name IN :nameList]; 
        List<ID> acctIDs = new List<ID>();
        
        Test.startTest();
        for(Account acct : acctsInserted) {
            acctIDs.add(acct.Id);
        	acct.Subscription_start_date__c = Date.today().addMonths(1);
        }
        update acctsInserted;
        Test.stopTest();
        
        Account acctUpdated = [SELECT Id, Subscription_start_date__c, Subscription_end_date__c FROM Account WHERE Id = :acctIDs]; 

        Assert.areEqual(Date.today().addMonths(4), acctUpdated.Subscription_end_date__c);
    }
    
    @isTest
    static void getHandlerUpdateStartDate250AccountTest() {
        List<Account> acctToInsert = DataFactory.createAccount(250);
        List<ID> acctToInsertIDs = new List<ID>();
        insert acctToInsert;
        for(Account ac : acctToInsert) {
			ac.Subscription_start_date__c = Date.today().addMonths(1);
            acctToInsertIDs.add(ac.Id);
        }
        
        Test.startTest();
        update acctToInsert;
        Test.stopTest();
        
        List<Account> acctUpdated = [SELECT Id, Subscription_end_date__c FROM Account WHERE Id IN :acctToInsertIDs]; 
        for(Account up : acctUpdated) {
        	Assert.areEqual(Date.today().addMonths(4), up.Subscription_end_date__c);            
        }
    }
}