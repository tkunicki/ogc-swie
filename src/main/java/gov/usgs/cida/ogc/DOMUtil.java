package gov.usgs.cida.ogc;

import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public abstract class DOMUtil {

	public static Element getElementByTagName(Element parentElement, String tagName) {
		Element element = null;
		if (parentElement != null) {
			NodeList nodeList = parentElement.getElementsByTagName(tagName);
			if (nodeList != null) {
				Node node = nodeList.item(0);
				if (node != null && node instanceof Element) {
					element = (Element) node;
				}
			}
		}
		return element;
	}
	
}
