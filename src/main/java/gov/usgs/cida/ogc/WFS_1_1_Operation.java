package gov.usgs.cida.ogc;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;



/**
 * Based on OGC Web Feature Service 1.1 standard 
 * at http://www.opengeospatial.org/standards/wfs
 * @author ilinkuo
 *
 */
public enum WFS_1_1_Operation {
	GetCapabilities(true, null),
	DescribeFeatureType(true, null),
	GetGMLObject(false, null),
	GetFeature(true, new String[] {"request", "typeName", "bBox", "featureId", "maxFeatures"}),
	Transaction(false, null),
	LockFeature(false, null),
	GetFeatureWithLock(false, null)
	;
	
	public final boolean isMandatory;
	public final List<String> opArguments;
	
	WFS_1_1_Operation(boolean isRequired, String[] args){
		this.isMandatory = isRequired;
		if (args != null) {
			List<String> list = new ArrayList<String>();
			list.addAll(Arrays.asList(args));
			this.opArguments = Collections.unmodifiableList(list);
		} else {
			this.opArguments = Collections.emptyList();
		}
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
