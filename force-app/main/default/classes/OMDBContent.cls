public class OMDBContent {
	String Actors;
    String Awards;
    String BoxOffice;
    String Country;
    String Director;
    String DVD;
    String Genre;
    String imdbID;
    String imdbRating;
    String imdbVotes;
    String Language;
    String Metascore;
    String Plot;
    String Poster;
    String Production;
    String Rated;
    List<Objratings> Ratings;
    String Released;
    String Response;
    String Runtime;
    String Title;
    String Type;
    String Website;
    String Writer;
    String Year;
    
    public static OMDBContent parse(String jsonString) {
    	return((OMDBContent) JSON.deserialize(jsonString, OMDBContent.class));
    }
        
    public static Content__c toRecord(OMDBContent record) {
        List<String> IMDBs = new List<String>();
        IMDBs.add(record.imdbID);
        List<Content__c> contentList = [SELECT Id, IMDBId__c, Category__c, Content_type__c, RecordTypeId FROM Content__c WHERE IMDBId__c IN :IMDBs];
        Content__c content;
        if(contentList.isEmpty()) {
            content = new Content__c();
        } else {
            content = contentList.get(0);
        }
        content.Actor__c = record.Actors;
        content.Awards__c = record.Awards;
        List<String> categories = record.Genre.split(',');
        List<String> cats = new List<String>();
        for(String cat : categories) {
            if(!cats.contains(cat)) {
            	cats.add(cat);
            }
        } 
        if(cats.contains('null')) {
            Integer index = cats.indexOf('null');
            cats.remove(index);
        }
        content.Category__c = string.join(cats, ';');
        content.IMDBId__c = record.imdbID;
        // content.Rating__c = record.imdbRating;
        content.Synopsis__c = record.Plot;
        content.url_cartel_c__c = record.Poster;
        String dateRecieved = record.Released;
        List<String> dateParts = dateRecieved.split(' ');
        if(dateParts.contains('Jan')) {
            Integer index = dateParts.indexOf('Jan');
            dateParts.set(index, '1');
        } else if(dateParts.contains('Feb')) {
            Integer index = dateParts.indexOf('Feb');
            dateParts.set(index, '2');
        } else if(dateParts.contains('Mar')) {
            Integer index = dateParts.indexOf('Mar');
            dateParts.set(index, '3');
        } else if(dateParts.contains('Apr')) {
            Integer index = dateParts.indexOf('Apr');
            dateParts.set(index, '4');
        } else if(dateParts.contains('May')) {
            Integer index = dateParts.indexOf('May');
            dateParts.set(index, '5');
        } else if(dateParts.contains('Jun')) {
            Integer index = dateParts.indexOf('Jun');
            dateParts.set(index, '6');
        } else if(dateParts.contains('Jul')) {
            Integer index = dateParts.indexOf('Jul');
            dateParts.set(index, '7');
        } else if(dateParts.contains('Aug')) {
            Integer index = dateParts.indexOf('Aug');
            dateParts.set(index, '8');
        } else if(dateParts.contains('Sep')) {
            Integer index = dateParts.indexOf('Sep');
            dateParts.set(index, '9');
        } else if(dateParts.contains('Oct')) {
            Integer index = dateParts.indexOf('Oct');
            dateParts.set(index, '10');
        } else if(dateParts.contains('Nov')) {
            Integer index = dateParts.indexOf('Nov');
            dateParts.set(index, '11');
        } else if(dateParts.contains('Dec')) {
            Integer index = dateParts.indexOf('Dec');
            dateParts.set(index, '12');
        }
        String day = dateParts.get(0);
        String month = dateParts.get(1);
        String year = dateParts.get(2);
        content.Publication_date__c = Date.newInstance(Integer.valueOf(year), Integer.valueOf(month), Integer.valueOf(day));
        String duration = record.Runtime;
        String dur = duration.substring(0, duration.length() - 3);
        content.Duration__c = Integer.valueOf(dur.trim());
        content.Content_status__c = 'Active';
        content.Name = record.Title;
        String type = record.Type;
        if(type != null) {
            if(type.equals('series')) {
                content.RecordTypeId = '0122o000000RJfqAAG';
                content.Content_type__c = 'Serie';
            } else if(type.equals('movie')) {
                content.RecordTypeId = '0122o000000RJflAAG';
                content.Content_type__c = 'Movie';        
            } else if(type.equals('documentary')) {
                content.RecordTypeId = '0122o000000RJflAAG';
                content.Content_type__c = 'Documentary';
            }
        } 
        content.Title__c = record.Title;
        content.Director__c = record.Director;
        return content;
    }
    
    class Objratings {
        String Source;
        String Value;
	}
}