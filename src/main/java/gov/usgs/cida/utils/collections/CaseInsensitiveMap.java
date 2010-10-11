package gov.usgs.cida.utils.collections;


import java.lang.reflect.Array;
import java.util.Map;
import java.util.TreeMap;

/**
 * A Map<String, T> with case-insensitive String lookups
 * 
 * @author ilinkuo
 *
 * @param <T>
 */
public class CaseInsensitiveMap<T> extends TreeMap<String, T> {

	/**
	 * 
	 */
	private static final long serialVersionUID = 279858929205077765L;


	// ======================
	// Public Utility Methods
	// ======================
	/**
	 * Joins an array of string using the given separator. Nulls are not ignored!
	 * 
	 * @param sArray
	 * @param separator
	 * @return
	 * 
	 * Note: this method really belongs elsewhere
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
			} else if (value.getClass().isArray()) {
				int arraySize = Array.getLength(value);
				String[] stringArray = new String[arraySize];
				for (int i = 0; i<arraySize; i++) {
					Object cellValue = Array.get(value, i);
					stringArray[i] = (cellValue == null)? "": cellValue.toString();
				}
				result.put(entry.getKey(), join(stringArray, ","));
			} else {
				result.put(entry.getKey(), value.toString());
			}
		}
		
		return result;
	}
	// ============
	// CONSTRUCTORS
	// ============
	public CaseInsensitiveMap(){
		// Tom found this nice trick
		super(String.CASE_INSENSITIVE_ORDER);
	};
	
	
	public CaseInsensitiveMap(Map<String, T> originalMap){ 
		this();
		this.putAll(originalMap);
	}
	
	

	

}
