public class AccountTriggerHandler {
    public static void getHandler(List<Account> accounts, Map<ID, Account> oldAccountsMap) {
        if(!accounts.isEmpty()) {
            if(Trigger.isAfter && Trigger.isInsert) {
                AccountTriggerHandler.afterInsert(accounts);
            } else if(Trigger.isBefore && Trigger.isUpdate) {
               AccountTriggerHandler.beforeUpdate(accounts, oldAccountsMap);
            } else if(Trigger.isBefore && Trigger.isInsert) {
                AccountTriggerHandler.beforeInsert(accounts);
            }
        }
    }
    
    private static void afterInsert(List<Account> accounts) {
        AccountTriggerHandler.crearAvatarPrincipal(accounts);
    }
    
    private static void beforeUpdate(List<Account> accounts, Map<ID, Account> oldAccountsMap) {
        AccountTriggerHandler.calcularFechaFinSuscripcion(accounts, oldAccountsMap);
    }

    private static void beforeInsert(List<Account> accounts) {
        AccountTriggerHandler.calcularFechaFinSuscripcion(accounts);
    }
    
    private static void crearAvatarPrincipal(List<Account> accounts) {
        List<Avatar__c> avatarsToInsert = new List<Avatar__c>();
        for(Account acct : accounts) {
            Avatar__c newAvatar = new Avatar__c(Name=(acct.Name+' primary Avatar'), Account__c = acct.Id, Primary_avatar__c = True);
            avatarsToInsert.add(newAvatar);
        }
        try {
        	insert avatarsToInsert;
        } catch( System.DmlException e ) {
            // Este error podría saltar al cambiar los campos que son obligatorios para insertar un Avatar. 
            for(Account acct : accounts) {
                acct.addError('No se han podido insertar los avatares correctamente.');
            }
        }
    }
    
    private static void calcularFechaFinSuscripcion(List<Account> accounts, Map<ID, Account> oldAccountsMap) {
        for(Account acct : accounts) {
            if(acct.Subscription_duration__c != oldAccountsMap.get(acct.id).Subscription_duration__c || acct.Subscription_start_date__c != oldAccountsMap.get(acct.id).Subscription_start_date__c) {
                acct.Subscription_end_date__c = acct.Subscription_start_date__c.AddMonths(Integer.valueOf(acct.Subscription_duration__c));
            }
        }
    }

    private static void calcularFechaFinSuscripcion(List<Account> accounts) {
        for(Account acct : accounts) {
            acct.Subscription_end_date__c = acct.Subscription_start_date__c.AddMonths(Integer.valueOf(acct.Subscription_duration__c));
        }
    }
}