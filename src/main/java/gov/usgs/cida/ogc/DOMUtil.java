package gov.usgs.cida.ogc;

import java.io.IOException;
import java.io.InputStream;
import java.io.Reader;
import java.io.StringReader;

import javax.servlet.http.HttpServletRequest;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

/**
 * Utility methods for creating w3c Document from Strings and other sources
 * 
 * @author tkunicki
 *
 */
public abstract class DOMUtil {

	private final static DocumentBuilderFactory documentBuilderFactory;

	static {
		documentBuilderFactory = DocumentBuilderFactory.newInstance();
		documentBuilderFactory.setNamespaceAware(true);
	}

	public static Element getElementByTagName(Element parentElement,
			String tagName) {
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

	public static Document createDocument(HttpServletRequest request)
			throws ParserConfigurationException, SAXException, IOException {
		return createDocument(request.getReader());
	}

	public static Document createDocument(String string)
			throws ParserConfigurationException, SAXException, IOException {
		return createDocument(new StringReader(string));
	}

	public static Document createDocument(Reader reader)
			throws ParserConfigurationException, SAXException, IOException {
		return createDocument(new InputSource(reader));
	}

	public static Document createDocument(InputStream inputStream)
			throws ParserConfigurationException, SAXException, IOException {
		return createDocument(new InputSource(inputStream));
	}

	public static Document createDocument(InputSource inputSource)
			throws ParserConfigurationException, SAXException, IOException {
		DocumentBuilder documentBuilder = documentBuilderFactory.newDocumentBuilder();
		Document document = documentBuilder.parse(inputSource);
		return document;
	}

}
