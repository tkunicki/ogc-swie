package gov.usgs.cida.ogc.specs;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

/**
 * Based on OGC Sensor Observation Service 1.0 standard (document 06-009r6) 
 * at  http://www.opengeospatial.org/standards/sos
 * @author ilinkuo
 *
 */
public enum WML_1_0_Operation {
	GetCapabilities("core", true, new String[] {"service", "request"}, new String[] {"Sections","updateSequence","AcceptVersions","AcceptFormats","AcceptLanguages"}),
	DescribeSensor("core", true, new String[] {"service", "version", "request", "SensorId", "outputFormat"}, null),
        WaterML2("core", true, new String[] {"service", "version", "request", "SensorId", "outputFormat"}, null),
        waterSampling("core", true, new String[] {"service", "version", "request", "SensorId", "outputFormat"}, null),
        waterResultsCoverage("core", true, new String[] {"service", "version", "request", "SensorId", "outputFormat"}, null),
        waterProperty("core", true, new String[] {"service", "version", "request", "SensorId", "outputFormat"}, null),
        waterProcedure("core", true, new String[] {"service", "version", "request", "SensorId", "outputFormat"}, null),
        waterObservation("core", true, new String[] {"service", "version", "request", "SensorId", "outputFormat"}, null),
        WaterCollection("core", true, new String[] {"service", "version", "request", "SensorId", "outputFormat"}, null),
        observation("core", true, new String[] {"service", "version", "request", "SensorId", "outputFormat"}, null),
        samplingFeature("core", true, new String[] {"service", "version", "request", "SensorId", "outputFormat"}, null),
        spatialSamplingFeature("core", true, new String[] {"service", "version", "request", "SensorId", "outputFormat"}, null),
        timeseriesLite("core", true, new String[] {"service", "version", "request", "SensorId", "outputFormat"}, null),
        GetMap("core", true, new String[] {"service", "version", "request", "SensorId", "outputFormat"}, null),
	GetObservation("core", true, null, null),
	RegisterSensor("trans", false, null, null),
	InsertObservation("opt", false, null, null),
	GetResult("opt", false, null, null),
	GetFeatureOfInterest("opt", false, null, null),
	GetFeatureOfInterestTime("opt", false, null, null),
	GetObservationById("opt", false, null, null),
	DescribeFeatureOfInterest("opt", false, null, null),
	DescribeObservationType("opt", false, null, null),
	DescribeResultModel("opt", false, null, null),
	GetProfile("ext", false, null, null)        
	;
	
	public final String profile;
	public final boolean isMandatory;
	public final List<String> opArguments;
	
	WML_1_0_Operation(String profile, boolean isRequired, String[] args, String[] optArgs){
		this.profile = profile;
		this.isMandatory = isRequired;
		if (args != null) {
			List<String> list = new ArrayList<String>();
			list.addAll(Arrays.asList(args));
			this.opArguments = Collections.unmodifiableList(list);
		} else {
			this.opArguments = Collections.emptyList();
		}
	}
	
	public static WML_1_0_Operation parse(String... value) {
		String operationString = (value == null)? null: value[0];
		if (operationString != null) {
			for (WML_1_0_Operation op: WML_1_0_Operation.values()) {
				if (op.name().equalsIgnoreCase(operationString)) return op;
			}
		}
		return null;
	}
}
