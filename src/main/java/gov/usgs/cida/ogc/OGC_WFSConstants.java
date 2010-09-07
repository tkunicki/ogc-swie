package gov.usgs.cida.ogc;

/**
 * From 04-094 Web Feature Service Implementation Specification v1.1. All
 * section numbers in this class reference this document unless otherwise 
 * noted.
 * 
 * @author ilinkuo
 * 
 * TODO This class needs to be implemented
 */

public class OGC_WFSConstants {
	// 
	
	public static boolean validateVersionNumber(String versionNumber) {
		// return true if at most three integers separated by decimal points
		// re 04-094 Section 6.2.2
		if (versionNumber !=  null) {
			// TODO test this
			// TODO should throw FormatException with detail of invalid version number?
			return versionNumber.matches("[0-9]+(\\.[0-9]+)?(\\.[0-9]+)?");
		}
		return false;
	}
	
	public static String determineAppropriateVersion(String requestedVersion, String[] serverVersions) {
		return null;
		// TODO implement this according to 6.2.4. Note that this applies *ONLY* to GetCapabilities
	}
	
	/**
	 * Return -1, 0 , 1 if a<b, a=b, a>b, respectively
	 * 
	 * @param a
	 * @param b
	 * @return
	 */
	public static int compareVersions(String a, String b) {
		return 0;
	}
	
	// These are the headers explicitly reference in 6.4 that should be handled
	public static String[] headersList = {"Expires", "Last-Modified", "Content-Lngth", "COntent-Encoding", "Content-Transfer-Encoding"};
	
	// These are explicit encoding type specifications in Table 2b, Section 6.5. 
	// Failure should throw InvalidEncodingTypeException
	// POST requests with xml MUST come in as text/xml
	// POST requests via KVP must be set to ...encoded
	// GET requests have no mimetype
	public static String[] encodingsList = {"text/xml", "application/x-www-form-urlencoded"};
	
	// Section 6.6
	public static String[] normativeNamespaceList = {"http://www.opengeospatial.net/wfs",
		"http://www.opengeospatial.net/gml",
		"http://www.opengeospatial.net/ogc"};
	
	// 7.1 Find out what this means "It is further assumed that a feature 
	// identifier is encoded as described in the OpenGIS® Filter 
	// Encoding Implementation Specification [3]."
	
	public static boolean validateAsNCName(String propertyName) {
		return true; // 7.3 all property names must be valid NCNames, including prefixes
	}
	
	// 7.4.1 XPath use is mandatory for referencing properties of a feature
	
	// 7.4.2 Only abbreviated XPath implementation necessary
	// 1) relative location paths. First step of RLP may be the root of the feature or the 
	// name of the explicit type, e.g. Person/lastname or simply lastname refers to the same
	// 2) [] containig a number must be supported
	// 3) @ in the final step supported
	
	// 7.5 <Native> vendor capabilities allowed
	
	// 7.7 Exception reporting refers to clause 8 of OWS Common 
	
	// 7.7 "For this version of the specification, this value is fixed at 1.1.0"
	public static final String ServiceExceptionReportSchemaVersion = "1.1.0";
	
	// 7.7 "The optional language attribute may be used to indicate the language used. 
	// The code list for the language parameter is defined in IETF RFC 1766."
	
	// 7.8 Common XML Attributes. Does this only apply to exceptions
	public static final String[] commonAttributes = {"version", "service", "handle"};
	
	
	
	
	
}
