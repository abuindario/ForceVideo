public class AvatarTriggerHandler {
	public static void getHandler(List<Avatar__c> avatares, List<Avatar__c> oldAvatars, Map<ID, Avatar__c> oldAvatarsMap) {
           	if(Trigger.isBefore && Trigger.isInsert) {
                AvatarTriggerHandler.beforeInsert(avatares);
            } else if(Trigger.isBefore && Trigger.isDelete) {
                AvatarTriggerHandler.beforeDelete(oldAvatars);
            } else if(Trigger.isAfter && Trigger.isInsert || Trigger.isAfter && Trigger.isUpdate) {
                AvatarTriggerHandler.afterInsertUpdate(avatares);
            } else if(Trigger.isBefore && Trigger.isUpdate) {
                AvatarTriggerHandler.beforeUpdate(avatares, oldAvatars);
            }
    }
    
    private static void beforeInsert(List<Avatar__c> avatares) {
       	AvatarTriggerHandler.checkNumAvataresDeCuenta(avatares);
    }
    
    private static void beforeDelete(List<Avatar__c> oldAvatars) {
        AvatarTriggerHandler.evitarEliminarAvatarPrincipal(oldAvatars);
    }  
        
    private static void beforeUpdate(List<Avatar__c> avatares, List<Avatar__c> oldAvatares) {
        AvatarTriggerHandler.debeHaberUnAvatarPrincipal(avatares, oldAvatares);
    }
        
    private static void afterInsertUpdate(List<Avatar__c> avatares) {
        AvatarTriggerHandler.desactivarOtrosAvataresComoPrincipales(avatares);
    }
    
    private static void checkNumAvataresDeCuenta(List<Avatar__c> avatares) {
        List<ID> accountIDs = new List<ID>();
        for(Avatar__c avatar : avatares) {
            accountIDs.add(avatar.Account__c);
        }  
        List<Account> accounts = [SELECT Number_of_avatars__c FROM Account WHERE ID IN :accountIDs];
        for(Account acct : accounts) {
            if(acct.Number_of_avatars__c == 4) {
                Avatar__c avatar;
                for(Avatar__c avt : avatares) {
                    if(avt.Account__c == acct.Id) {
                        avatar = avt;
                    }
                }
                avatar.addError('No es posible tener más de 4 avatares por cuenta');
            }
        }
    }
    
    private static void evitarEliminarAvatarPrincipal(List<Avatar__c> oldAvatarList) {
        for(Avatar__c avt : oldAvatarList) {
            if(avt.Primary_avatar__c == True) {
                avt.addError('No se puede eliminar un avatar principal');
            }
        }
    }   
    
    private static void debeHaberUnAvatarPrincipal(List<Avatar__c> avatares, List<Avatar__c> oldAvatares) {
        List<ID> avatarIDS = new List<ID>();
        List<ID> accountIDs = new List<ID>();
        for (Avatar__c avt : avatares) {
            for (Avatar__c oldAvt : oldAvatares) {
                if(avt.Primary_avatar__c != oldAvt.Primary_avatar__c) {
                    avatarIDS.add(avt.Id);
                    accountIDs.add(avt.Account__c);
                }
            }
        }
        List<Avatar__c> avtToCheck = null;
        if(!avatarIDS.isEmpty() && !accountIDs.isEmpty()) {
            avtToCheck = [SELECT Id FROM Avatar__c WHERE (Id NOT IN :avatarIDs AND Account__c IN :accountIDs AND Primary_avatar__c = True)];
        // System.debug('Lista de avatares Principales: ' + avtToCheck);
            if(avtToCheck != null && avtToCheck.isEmpty()) {
                for(Avatar__c avt : avatares) {
                    avt.addError('No se puede desactivar este avatar como principal, la cuenta debe disponer de un avatar principal. Por favor, asigne otro avatar como principal y este se desactivará automáticamente.');
                }
            } 
        }
    }
    
	private static void desactivarOtrosAvataresComoPrincipales(List<Avatar__c> avatares) {
        List<ID> idAcctToCheck = new List<ID>();
        List<ID> idAvatares = new List<ID>();
        for(Avatar__c avt : avatares) {
            if(avt.Primary_avatar__c == True) { 
                idAcctToCheck.add(avt.Account__c);
                idAvatares.add(avt.Id);
            }
        }
        if(!idAvatares.isEmpty()) {
            List<Avatar__c> avatarList = [SELECT Id, Name, Primary_avatar__c FROM Avatar__c WHERE (Id NOT IN :idAvatares AND Primary_avatar__c = True AND Account__c IN :idAcctToCheck)];
            List<Avatar__c> avToUpdate = new List<Avatar__c>();
            for(Avatar__c av : avatarList) {
                av.Primary_avatar__c = false;
                avToUpdate.add(av);
            }
            if(!avToUpdate.isEmpty()) {
                try {
                	update avToUpdate;
                } catch(System.DmlException e) {
                    for(Avatar__c avt : avatares) {
                        avt.addError('Ha habido un error, no se ha podido completar la operación.');
                    }
                }
            }
        }
    } 
}