package gov.usgs.cida.ogc;

import gov.usgs.webservices.ibatis.XMLStreamWriterDAO;

import java.io.IOException;
import java.io.OutputStream;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.regex.Pattern;

import javanet.staxutils.XMLStreamUtils;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.stream.XMLStreamReader;
import javax.xml.stream.XMLStreamWriter;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.apache.ibatis.session.defaults.DefaultSqlSessionFactory;
import org.codehaus.stax2.XMLOutputFactory2;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

/**
 * Servlet implementation class EchoServlet
 */
public class OGCServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;

	private final static DocumentBuilderFactory documentBuilderFactory;
	private final static XMLOutputFactory2 xmlOutputFactory;
	
	private final static String BBOXNodeName = "ogc:BBOX";
	private final static String lowerCornerNodeName = "gml:lowerCorner";
	private final static String upperCornerNodeName = "gml:upperCorner";
	private final static Pattern cornerPattern = Pattern.compile("\\s+");
	
	// IS SSF THREAD SAFE?
	private static XMLStreamWriterDAO streamWriterDAO;
	
	static {
		documentBuilderFactory = DocumentBuilderFactory.newInstance();
		xmlOutputFactory = (XMLOutputFactory2)XMLOutputFactory2.newInstance();
		xmlOutputFactory.setProperty(XMLOutputFactory2.IS_REPAIRING_NAMESPACES, false);
		xmlOutputFactory.configureForSpeed();
		

		try {
			SqlSessionFactoryBuilder ssfb = new SqlSessionFactoryBuilder();
			DefaultSqlSessionFactory ssf = (DefaultSqlSessionFactory)ssfb.build(Resources.getResourceAsReader("configuration.xml"));
			streamWriterDAO = new XMLStreamWriterDAO(ssf);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public OGCServlet() {
		super();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Map<String, String[]> original = request.getParameterMap();
		Map<String, Object> cleanedUpForOurPurposes = new LinkedHashMap<String, Object>();
		
		cleanedUpForOurPurposes.put("east", original.get("east")[0]);
		cleanedUpForOurPurposes.put("west", original.get("west")[0]);
		cleanedUpForOurPurposes.put("north", original.get("north")[0]);
		cleanedUpForOurPurposes.put("south", original.get("south")[0]);
		
		queryAndSend(cleanedUpForOurPurposes, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			Document document = createDocumentFromRequest(request);
			Map<String, Object> parameterMap = createParameterMapFromDocument(document);
			dumpMap(parameterMap);
			
			queryAndSend(parameterMap, response);
			
		} catch (ParserConfigurationException e) {
			e.printStackTrace();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	private void queryAndSend(Map<String, Object> parameterMap, HttpServletResponse response) throws IOException {
		response.setContentType("text/xml");
		response.setCharacterEncoding("UTF-8");
		OutputStream outputStream = response.getOutputStream();
		try {
			XMLStreamReader streamReader = streamWriterDAO.getStreamReader("ogcMapper.observationsSelect", parameterMap);
			XMLStreamWriter streamWriter = xmlOutputFactory.createXMLStreamWriter(outputStream);
			XMLStreamUtils.copy(streamReader, streamWriter);
		}catch (Exception e) {
			e.printStackTrace();
		} finally {
			outputStream.flush();
		}
	}

	private Document createDocumentFromRequest(HttpServletRequest request)
			throws ParserConfigurationException, SAXException, IOException {
		DocumentBuilder documentBuilder = documentBuilderFactory.newDocumentBuilder();
		Document document = documentBuilder.parse(request.getInputStream());
		return document;
	}

	private Map<String, Object> createParameterMapFromDocument(Document document) throws Exception {
		if (document == null) {
			return null;
		}
		Map<String, Object> parameterMap = new LinkedHashMap<String, Object>();
		Node bBoxNode = findElementNode(document.getDocumentElement(), BBOXNodeName);
		if (bBoxNode != null) {
			Node lowerCornerNode= findElementNode(bBoxNode, lowerCornerNodeName);
			Node upperCornerNode= findElementNode(bBoxNode, upperCornerNodeName);
			if (lowerCornerNode != null && upperCornerNode != null) {
				String lowerCornerText = lowerCornerNode.getTextContent().trim();
				String upperCornerText = upperCornerNode.getTextContent().trim();
				if (lowerCornerText != null && lowerCornerText.length() > 0 &&
					upperCornerText != null && upperCornerText.length() > 0) {
					String[] lowerCornerSplit = cornerPattern.split(lowerCornerText);
					String[] upperCornerSplit = cornerPattern.split(upperCornerText);
					if (lowerCornerSplit != null && lowerCornerSplit.length == 2 &&
						upperCornerSplit != null && upperCornerSplit.length == 2) {
						try {
							float lon0 = Float.parseFloat(lowerCornerSplit[0]);
							float lat0 = Float.parseFloat(lowerCornerSplit[1]);
							float lon1 = Float.parseFloat(upperCornerSplit[0]);
							float lat1 = Float.parseFloat(upperCornerSplit[1]);
							String east = null;
							String west = null;
							String south = null;
							String north = null;
							if (lon0 < lon1) {
								east = upperCornerSplit[0];
								west = lowerCornerSplit[0];
							} else {
								east = lowerCornerSplit[0];
								west = upperCornerSplit[0];
							}
							if (lat0 < lat1) {
								south = lowerCornerSplit[1];
								north = upperCornerSplit[1];
							} else {
								south = upperCornerSplit[1];
								north = lowerCornerSplit[1];
							}
							parameterMap.put("east", east);
							parameterMap.put("west", west);
							parameterMap.put("south", south);
							parameterMap.put("north", north);
						} catch (NumberFormatException e) {
							System.out.println(lowerCornerNodeName + " or " + upperCornerNodeName + " contain invalid number format");
						}
					}
				} else {
					System.out.println(lowerCornerNodeName + " or " + upperCornerNodeName + " are empty.");
				}
			} else {
				System.out.println(lowerCornerNodeName + " or " + upperCornerNodeName + " not found.");
			}
		} else {
			System.out.println(BBOXNodeName + " : not found.");
		}
		return parameterMap;
	}
	
	private Node findElementNode(Node node, String elementName) {
		Node foundNode = null;
		if (node == null) {
			return null;
		}
		int nodeType = node.getNodeType();
		switch (nodeType) {
		case Node.ELEMENT_NODE:
			if (node.getNodeName().equals(elementName)) {
				foundNode = node;
			} else {
				NodeList childNodes = node.getChildNodes();
				int childNodeCount = childNodes.getLength();
				for (int childNodeIndex = 0; childNodeIndex < childNodeCount && foundNode == null; ++ childNodeIndex) {
					foundNode = findElementNode(childNodes.item(childNodeIndex), elementName);
				}
			}
			break;
		case Node.DOCUMENT_NODE:
			foundNode = findElementNode(((Document)node).getDocumentElement(), elementName);
			break;
		}
		return foundNode;
	}

	private void dumpMap(Map<String, Object> map) {
		System.out.println("Parameters are: ");
		if (map != null && map.size() > 0) {
		for (Map.Entry<String, Object> entry : map.entrySet()) {
			System.out.println(" " + entry.getKey() + "-> " + entry.getValue());
		}
		} else {
			System.out.println("<empty>");
		}
	}
}
