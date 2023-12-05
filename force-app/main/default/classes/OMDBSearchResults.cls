public class OMDBSearchResults {
	public List<OMDBContent> Search;
    
    public static List<OMDBContent> parse(String jsonList) {
    	OMDBSearchResults sr = (OMDBSearchResults) JSON.deserialize(jsonList, OMDBSearchResults.class);
        return sr.Search;
    }
}