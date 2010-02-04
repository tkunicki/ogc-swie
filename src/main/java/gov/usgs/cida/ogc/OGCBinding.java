package gov.usgs.cida.ogc;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import javax.xml.XMLConstants;
import javax.xml.namespace.NamespaceContext;

public abstract class OGCBinding {
	
	public static class GetObservationNamespaceContext implements NamespaceContext {

		public final static Map<String, String> namespaceMap; 
		static {
			namespaceMap = new HashMap<String, String>();
			namespaceMap.put("sos", "http://www.opengis.net/sos/1.0");
			namespaceMap.put("ogc", "http://www.opengis.net/ogc");
			namespaceMap.put("gml", "http://www.opengis.net/gml");
		}
		
		@Override
		public String getNamespaceURI(String prefix) {
			if (prefix == null) {
				throw new NullPointerException("prefix is null");
			}
			String namespaceURI = namespaceMap.get(prefix);
			if (namespaceURI == null) {
				namespaceURI = XMLConstants.NULL_NS_URI;
			}
			return namespaceURI;
		}

		@Override
		public String getPrefix(String namespaceURI) {
			throw new UnsupportedOperationException();
		}

		@Override
		public Iterator<String> getPrefixes(String namespaceURI) {
			throw new UnsupportedOperationException();
		}
	}
}
