package gov.usgs.cida.utils.collections;


import java.util.HashMap;
import java.util.Map;

/**
 * A Map<T> with case-insensitive String lookups
 * 
 * @author ilinkuo
 *
 * @param <T>
 */
public class CaseInsensitiveMap<T> extends CanonicalKeyMap<String, T> {

	// ======================
	// Public Utility Methods
	// ======================
	/**
	 * Joins an array of string using the given separator. Nulls are not ignored!
	 * 
	 * @param sArray
	 * @param separator
	 * @return
	 */
	public static String join(String[] sArray, String separator) {
		StringBuilder sb = new StringBuilder();
	    for (int i=0; i < sArray.length; i++) {
	        if (i != 0) sb.append(separator);
	  	    sb.append(sArray[i]);
	  	}
	  	return sb.toString();
	}
	
	/**
	 * Takes a given Map<String, ?> and makes a best effort to convert all values into Strings
	 * 
	 * @param map
	 * @return a case-insensitive Map<String, String>
	 */
	public static CaseInsensitiveMap<String> stringifyValues(Map<String, ?> map){
		CaseInsensitiveMap<String> result = new CaseInsensitiveMap<String>();
		for (Map.Entry<String, ?> entry: map.entrySet()) {
			Object value = entry.getValue();
			if (value == null) {
				result.put(entry.getKey(), null);
			} else if (value instanceof String[]) {
				String[] stringArray = (String[]) value;
				result.put(entry.getKey(), join(stringArray, ","));
			} else {
				result.put(entry.getKey(), value.toString());
			}
		}
		
		return result;
	}
	
	// ================
	// Instance Methods
	// ================
	public String toCanonicalKey(String key) {
		return (key == null)? null: key.toLowerCase();
	}

	@Override
	public String toCanonicalKey(Object key) {
		return (key == null)? null: key.toString().toLowerCase();
	}
	
	public CaseInsensitiveMap<String> asMapOfStrings(){
		return stringifyValues(this);		
	}
	

	

}
