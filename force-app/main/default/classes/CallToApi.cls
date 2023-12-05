public class CallToApi implements Queueable {
    private String imdbId;
    
    public CallToApi(String imdbId) {
        this.imdbId = imdbId;
    }
    /*
    He ejecutado este Queueable para updatear todos los contenidos que estaban en la base de datos sin tener que ir uno por uno.
    
    List<Content__c> contentList = [SELECT IMDBId__c FROM Content__c LIMIT 50];
    List<String> imdbList = new List<String>();
    for(Content__c cnt : contentList) {
    imdbList.add(cnt.IMDBId__c);
    }
    for(String id : imdbList) {
    CallToApi cta = new CallToApi(id);
    ID jobID = System.enqueueJob(cta);
    }
    */
    public void execute(QueueableContext context) {
        String id = this.imdbId;
        Map<String, String> myMap = new Map<String, String>();
        myMap.put('i', id);
        OMDBContentService.searchOMDBContent(myMap);
    }
}