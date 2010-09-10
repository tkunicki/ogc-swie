package gov.usgs.cida.ogc.specs.exceptions;

public abstract class OGCException extends Exception {
	
	public abstract String getReferenceDocumentNumber();

	public abstract String getReferenceDocumentName();
	
	public abstract String getReferenceDocumentSection();
	
	// OGC mandated properties See 04-094 7.7 Exception Reporting
	public abstract String getCode();
	public abstract String getLocator();
	public abstract String getHandle();

	
	
	
}
