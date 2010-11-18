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
		if (value != null && value.startsWith("USGS")) {
			// We don't really care whether the delimiter is USGS- or USGS.
			return "USGS." + value.substring(5);
		}
		return value;
	}
}
