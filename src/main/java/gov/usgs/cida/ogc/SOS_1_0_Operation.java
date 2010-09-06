package gov.usgs.cida.ogc;

/**
 * Based on OGC Sensor Observation Service 1.0 standard (document 06-009r6) 
 * at  http://www.opengeospatial.org/standards/sos
 * @author ilinkuo
 *
 */
public enum SOS_1_0_Operation {
	GetCapabilities("core", new String[] {"service", "request"}, new String[] {"Sections","updateSequence","AcceptVersions","AcceptFormats","AcceptLanguages"}),
	DescribeSensor("core", new String[] {"service", "version", "request", "SensorId", "outputFormat"}, null),
	GetObservation("core", null, null),
	;
	
	public final String profile;
	
	private SOS_1_0_Operation(String profile, String[] mandatoryKvpParams, String[] optionalKvpParams) {
		this.profile = profile;
	}
}
