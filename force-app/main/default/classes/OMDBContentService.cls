public class OMDBContentService {
	
    /*
    Para ejecutar llamadas a la API:
	***En la clase CallToApi ejecuto un Queueable para updatear 50 registros a la vez

    Map<String, String> myMap = new Map<String, String>();
    myMap.put('t', 'titulo');
    myMap.put('i', 'IMDB ID');
    myMap.put('s', 'Search');     -- No está operativo

    OMDBContentService.searchOMDBContent(myMap);
     */
    @future(callout = true)
    public static void searchOMDBContent(Map<String, String> params) {
        Set<String> keySet = params.keySet();
        String key = '';
        for(String k : keySet) {
            key = k;
        }
        String value = params.get(key);
        Integer statusCode = 0;
        if(key.equals('t') && value.trim() != '' || key.equals('i') && value.trim() != '' || key.equals('s') && value.trim() != '') {
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            List<String> splitted = value.split(' ');
            value = String.join(splitted, '+');
            String url = 'http://www.omdbapi.com/?'+key+'='+value+'&apikey=46bb1c8f&';
            req.setEndpoint(url);
            req.setMethod('GET');
            HttpResponse res = http.send(req);
            System.debug(res.getBody());
            System.debug(res.getStatusCode());
            statusCode = res.getStatusCode();
            
            if(statusCode == 200) {
            	ContentDomain.upsertContent(res.getBody());
        	}
        }
	        
    }
}