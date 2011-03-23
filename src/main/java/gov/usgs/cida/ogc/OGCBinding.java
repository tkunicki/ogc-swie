package gov.usgs.cida.ogc;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import javax.xml.XMLConstants;
import javax.xml.namespace.NamespaceContext;

public abstract class OGCBinding {

    // These namespaces are for SOS 1.0
    // TODO: [IK] rename this to GetObservation_1_0_NamespaceContext
	public static class GetObservationNamespaceContext implements NamespaceContext {

		public final static Map<String, String> namespaceMap; 
		static {
			namespaceMap = new HashMap<String, String>();
			namespaceMap.put("gml", "http://www.opengis.net/gml");
			namespaceMap.put("ogc", "http://www.opengis.net/ogc");
			namespaceMap.put("sa", "http://www.opengis.net/sampling/1.0");
			namespaceMap.put("sos", "http://www.opengis.net/sos/1.0");
			namespaceMap.put("wfs", "http://www.opengis.net/wfs");
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

        	public static class GetObservation_2_0_NamespaceContext implements NamespaceContext {

		public final static Map<String, String> namespaceMap;
		static {
                    // TODO: Laura fills this out
			namespaceMap = new HashMap<String, String>();
			namespaceMap.put("gml", "http://www.opengis.net/gml/3.2");
			namespaceMap.put("ogc", "http://www.opengis.net/ogc");
			namespaceMap.put("om", "http://www.opengis.net/om/2.0");
			namespaceMap.put("sos", "http://schemas.opengis.net/sos/2.0.0/");
			namespaceMap.put("wfs", "http://www.opengis.net/wfs");
                        namespaceMap.put("xlink", "http://www.w3.org/1999/xlink");
                        namespaceMap.put("xsi", "http://www.w3.org/2001/XMLSchema-instance");
                        namespaceMap.put("fes", "http://www.opengis.net/fes/2.0");

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
