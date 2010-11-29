package gov.usgs.cida.ogc;

import java.util.Map;

public abstract class USGS_OGC_BusinessRules {

	public static Map<String, String[]> cleanFeatureId(Map<String, String[]> parameterMap) {
		String[] featureParam = parameterMap.get(OGCBusinessRules.FEATURE_ID);
		if (featureParam != null && featureParam[0] != null) {
			featureParam[0] = cleanFeatureId(featureParam[0]);
		}
		return parameterMap;
	}

	public static String cleanFeatureId(String value) {
		if (value != null){
			// arbitrarily limiting the prefix to between 3 and 7 characters, inclusive
			if (value.indexOf('-')> 2 && value.indexOf('-')< 7){
				return value.replaceFirst("-", ".");
			}
		}
		return value;
	}
}
