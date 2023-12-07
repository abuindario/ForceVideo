public class ContenidoSelector {
    @AuraEnabled(cacheable=true)
    public static List<Content__c> getContenidoPorCliente(String acctID) {
        System.debug(acctID);
        try {
            Account acct = [SELECT Id, Name, Subscription_type__c FROM Account WHERE Id = :acctID];
            if(acct.Subscription_type__c.equals('Movies and documentaries')) {
                System.debug([SELECT Id, Name, Category__c, Content_type__c, url_cartel_c__c FROM Content__c WHERE RecordTypeId = '0122o000000RJflAAG' AND Active_content__c = True]);
                return [SELECT Id, Name, Category__c, Content_type__c, url_cartel_c__c FROM Content__c WHERE RecordTypeId = '0122o000000RJflAAG' AND Active_content__c = True];
            } else if(acct.Subscription_type__c.equals('Series')) {
                System.debug([SELECT Id, Name, Category__c, Content_type__c, url_cartel_c__c FROM Content__c WHERE RecordTypeId = '0122o000000RJfqAAG' AND Active_content__c = True]);
                return [SELECT Id, Name, Category__c, Content_type__c, url_cartel_c__c FROM Content__c WHERE RecordTypeId = '0122o000000RJfqAAG' AND Active_content__c = True];
            } else {
                System.debug([SELECT Id, Name, Category__c, Content_type__c, url_cartel_c__c FROM Content__c WHERE Active_content__c = True]);
                return [SELECT Id, Name, Category__c, Content_type__c, url_cartel_c__c FROM Content__c WHERE Active_content__c = True];
            }
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());

        }
    }

    @AuraEnabled(cacheable = true)
    public static List<Content__c> getAllContent() {
        try {
            return [SELECT Id, Name, Category__c, Content_type__c, url_cartel_c__c FROM Content__c WHERE Active_content__c = True];
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}