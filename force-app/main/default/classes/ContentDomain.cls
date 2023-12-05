public class ContentDomain {
    public static void upsertContent(String contentString) {
        Content__c content;
        String msg = '';
        try {
        	content = OMDBContent.toRecord(OMDBContent.parse(contentString));
        } catch(Exception e) {
           msg = e.getMessage();
        } finally {
        	if(msg.length() > 0) {
                List<Content__c> contentList = new List<Content__c>();
                List<OMDBContent> results = OMDBSearchResults.parse(contentString);
                System.debug('Debug Dario' + results);
           		for(OMDBContent cnt : results) {
                    content = OMDBContent.toRecord(cnt);
                    contentList.add(content);
            	}
                try {
                    upsert contentList;
                } catch(System.DmlException e) {
                    System.debug('Content insertion failed: ' + e.getMessage());
                }
        	} else {
                try {
                    upsert content;
                } catch(System.DmlException e) {
                    System.debug('Content insertion failed: ' + e.getMessage());
                } 
        	}
        }
    }
}