package gov.usgs.cida.ogc;

import java.util.List;



public enum WFS_1_1_Operation {
	GetCapabilities(true, new String[] {"request", "typeName", "bBox", "featureId", "maxFeatures"}),
	DescribeFeatureType(true, null),
	GetGMLObject(false, null),
	GetFeature(true, null),
	Transaction(false, null),
	LockFeature(false, null),
	GetFeatureWithLock(false, null)
	;
	
	public final boolean isMandatory;
	public final List<String> handledParameters = null;
	
	WFS_1_1_Operation(boolean isRequired, String[] handledParameters){
		this.isMandatory = isRequired;
	}
	
	public static WFS_1_1_Operation parse(String... value) {
		String operationString = (value == null)? null: value[0];
		if (operationString != null) {
			for (WFS_1_1_Operation op: WFS_1_1_Operation.values()) {
				if (op.name().equalsIgnoreCase(operationString)) return op;
			}
		}
		return null;
	}
}
