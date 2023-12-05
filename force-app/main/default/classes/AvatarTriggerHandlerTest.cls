@isTest
class AvatarTriggerHandlerTest {
	@isTest
    static void beforeInsertAvatarsTest() {
        // Create Accounts
		List<Account> acctList = DataFactory.createAccount(1);
        insert acctList;
        
        // Create Avatars
        List<Avatar__c> avatarList = new List<Avatar__c>();
        for(Account acct : acctList) {
        	avatarList = DataFactory.createAvatar(3, acct);
        }
        
        // Insert Avatars
        Test.StartTest();
        insert avatarList;
        Test.StopTest();
        
        // Get Account IDs
        List<ID> acctIDs = new List<ID>();
        for(Account acct : acctList) {
            acctIDs.add(acct.Id);
        }
        List<Account> accountList = [SELECT Id, Number_of_avatars__c FROM Account WHERE Id = :acctIDs];
        Assert.AreEqual(true, accountList.size() > 0, 'No se han creado las Accounts');
        for(Account acct : accountList) {
        	Assert.AreEqual(4, acct.Number_of_avatars__c, 'Ha habido un error con la inserción de los avatares');
        }
    }
    
    @isTest
    static void beforeInsertMoreAvatarsThanPossibleTest() {
        // Create Accounts
		List<Account> acctList = DataFactory.createAccount(1);
        insert acctList;
        
        // Create Avatars
        List<Avatar__c> avatarList = new List<Avatar__c>();
        for(Account acct : acctList) {
        	avatarList = DataFactory.createAvatar(3, acct);
        }
        insert avatarList;
        
        //Create 1 Avatar
        List<Avatar__c> avtList = new List<Avatar__c>();
        for(Account acct : acctList) {
            Avatar__c avt = new Avatar__c(Name='Avatar 5', Account__c = acct.Id);
            avtList.add(avt);
        }
        
        String msg = '';
        Test.StartTest();
        try {
            insert avtList;
        } catch(System.DmlException e) {
            msg = e.getMessage();
            System.debug('mess ' + e.getMessage() + ', my msg ' + msg);
        }
        Test.StopTest();
        
        Assert.areEqual(true, msg.contains('No es posible tener más de 4 avatares por cuenta'));
    }
    
    @isTest
    static void beforeDeletePrimaryAvatarTest() {
        // Create Accounts
		List<Account> acctList = DataFactory.createAccount(1);
        insert acctList;
        
        // Create Avatars
        List<Avatar__c> avatarList = new List<Avatar__c>();
        for(Account acct : acctList) {
        	avatarList = DataFactory.createAvatar(3, acct);
        }
        insert avatarList;
        
        List<ID> acctIDs = new List<ID>();
        for(Account acct : acctList) {
            acctIDs.add(acct.Id);
        }
        List<Avatar__c> avtList = [SELECT Id, Name, Primary_avatar__c, Account__c FROM Avatar__c WHERE Account__c = :acctIDs AND Primary_avatar__c = True];
        
        String msg;
        Test.StartTest();
        try {
        	delete avtList;
        } catch(System.DmlException e) {
            msg = e.getMessage();
        }
        Test.StopTest();
        
        Assert.areEqual(true, msg.contains('No se puede eliminar un avatar principal'));
    }
    
    @isTest
    static void beforeDeleteNoPrimaryAvatarTest() {
        // Create Accounts
		List<Account> acctList = DataFactory.createAccount(1);
        insert acctList;
        
        // Create Avatars
        List<Avatar__c> avatarList = new List<Avatar__c>();
        for(Account acct : acctList) {
        	avatarList = DataFactory.createAvatar(3, acct);
        }
        insert avatarList;
        
        List<ID> acctIDs = new List<ID>();
        for(Account acct : acctList) {
            acctIDs.add(acct.Id);
        }
        List<Avatar__c> avtList = [SELECT Id, Name, Primary_avatar__c, Account__c FROM Avatar__c WHERE Account__c = :acctIDs AND Primary_avatar__c = False];
        
        String msg;
        Test.StartTest();
        try {
        	delete avtList;
        } catch(System.DmlException e) {
            msg = e.getMessage();
        }
        Test.StopTest();
        
        Assert.AreEqual(true, avtList.size() > 0);
        Assert.AreEqual(true, String.isEmpty(msg));
    }
    
    @isTest
    static void debeHaberUnAvatarPrincipalTest() {
        // Create Accounts
		List<Account> acctList = DataFactory.createAccount(1);
        insert acctList;
        
        // Create Avatars
        List<Avatar__c> avatarList = new List<Avatar__c>();
        for(Account acct : acctList) {
        	avatarList = DataFactory.createAvatar(3, acct);
        }
        insert avatarList;
        
        List<ID> acctIDs = new List<ID>();
        for(Account acct : acctList) {
            acctIDs.add(acct.Id);
        }
        List<Avatar__c> avtList = [SELECT Id, Primary_avatar__c FROM Avatar__c WHERE Account__c IN :acctIDs AND Primary_avatar__c = True];
        for(Avatar__c avt : avtList) {
            avt.Primary_avatar__c = False;
        }
        
        String msg = '';
        Test.StartTest();
        try {
        	update avtList;
        } catch(Exception e) {
			msg = e.getMessage();            
        }
        Test.StopTest();
        
        Assert.AreEqual(true, avtList.size() > 0);
        Assert.AreEqual(true, msg.contains('No se puede desactivar este avatar como principal, la cuenta debe disponer de un avatar principal. Por favor, asigne otro avatar como principal y este se desactivará automáticamente.'));
    }
    
    @isTest
    static void desactivarOtrosAvataresComoPrincipalesTest() {
        // Create Accounts
		List<Account> acctList = DataFactory.createAccount(1);
        insert acctList;
        
        // Create Avatars
        List<Avatar__c> avatarList = new List<Avatar__c>();
        for(Account acct : acctList) {
        	avatarList = DataFactory.createAvatar(3, acct);
        }
        insert avatarList;
        
        Avatar__c avatarNew = [SELECT Id, Name, Primary_avatar__c, Account__c FROM Avatar__c WHERE Primary_avatar__c = False LIMIT 1];
        Avatar__c avatarOld = [SELECT Id, Name, Primary_avatar__c, Account__c FROM Avatar__c WHERE Primary_avatar__c = True LIMIT 1];
        
        Test.StartTest();
        avatarNew.Primary_avatar__c = True;
        update avatarNew;
        Test.StopTest();
        
        Avatar__c toTest = [SELECT Id, Primary_avatar__c FROM Avatar__c WHERE Id = :avatarOld.Id];
        Assert.areEqual(True, avatarNew.Primary_avatar__c);
        Assert.areEqual(False, toTest.Primary_avatar__c);
    }
}