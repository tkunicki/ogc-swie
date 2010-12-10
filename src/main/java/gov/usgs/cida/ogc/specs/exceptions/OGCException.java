package gov.usgs.cida.ogc.specs.exceptions;

public abstract class OGCException extends Exception {
	private static final long serialVersionUID = -5731571112109990650L;
	public abstract String getReferenceDocumentNumber();

	public abstract String getReferenceDocumentName();
	
	public abstract String getReferenceDocumentSection();
	
	// OGC mandated properties See 04-094 7.7 Exception Reporting
	public abstract String getCode();
	public abstract String getLocator();
	public abstract String getHandle();

	
	
	
}
