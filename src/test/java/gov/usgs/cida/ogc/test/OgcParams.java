package gov.usgs.cida.ogc.test;

import java.util.LinkedHashMap;
import java.util.Map;


public class OgcParams {
	
	public enum ParamEnum {
		REQUEST("request"),
		NORTH("north"),
		SOUTH("south"),
		EAST("east"),
		WEST("west"),
		BBOX("bBox"),
		TYPENAME("typeName"),
		FEATUREID("featureId"),
		SERVICE("service"),
		VERSION("version"),
		SRS("srs"),
		LAYERS("layers"),
		FORMAT("format"),
		WIDTH("width"),
		HEIGHT("height");
		
		public String key;
		
		ParamEnum(String key) {
			this.key = key;
		}
	}
	
	private Map<ParamEnum, String> params = new LinkedHashMap<OgcParams.ParamEnum, String>();
	
	public void put(ParamEnum key, String value) {
		params.put(key, value);
	}
	
	public String toQueryString() {
		
		StringBuilder sb = new StringBuilder();
		
		for (Map.Entry<ParamEnum, String> param : params.entrySet()) {
			sb.append(param.getKey().key + "=" + param.getValue() + "&");
		}
		
		// Remove last '&' from string
		return sb.substring(0, sb.length() - 1);
	}
}
