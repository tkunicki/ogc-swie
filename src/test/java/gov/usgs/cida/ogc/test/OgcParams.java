package gov.usgs.cida.ogc.test;

public class OgcParams {
	public String request;
	public String north;
	public String south;
	public String east;
	public String west;
	public String bBox;
	public String typeName;
	public String featureId;

	public String toQueryString() {
		return  "dummy=" + (bBox != null ? "&bBox=" + bBox  : "")
				+ (east != null ? "&east=" + east  : "")
				+ (featureId != null ? "&featureId=" + featureId  : "")
				+ (north != null ? "&north=" + north  : "")
				// TODO  fix case sensitivity
				+ (request != null ? "&request=" + request  : "")
				+ (south != null ? "&south=" + south : "")
				+ (typeName != null ? "&typeName=" + typeName : "")
				+ (west != null ? "&west=" + west : "");
	}
	
	

}
