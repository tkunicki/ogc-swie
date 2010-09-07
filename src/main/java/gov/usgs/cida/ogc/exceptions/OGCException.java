package gov.usgs.cida.ogc.exceptions;

public abstract class OGCException extends Exception {
	
	public abstract String getReferenceDocumentNumber();

	public abstract String getReferenceDocumentName();
	
	public abstract String getReferenceDocumentSection();
	
	
}
