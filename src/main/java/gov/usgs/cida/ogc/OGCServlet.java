package gov.usgs.cida.ogc;

import gov.usgs.webservices.ibatis.XMLStreamReaderDAO;

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
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

/**
 * Servlet implementation class EchoServlet
 */
public class OGCServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;

	private final static DocumentBuilderFactory documentBuilderFactory;
	private final static XMLStreamReaderDAO streamReaderDAO;
	private final static XMLOutputFactory2 xmlOutputFactory;
	
	private final static String BBOXElementName = "ogc:BBOX";
	private final static String lowerCornerElementName = "gml:lowerCorner";
	private final static String upperCornerElementName = "gml:upperCorner";
	
	private final static Pattern cornerPattern = Pattern.compile("\\s+");
	
	static {
		
		documentBuilderFactory = DocumentBuilderFactory.newInstance();
		xmlOutputFactory = (XMLOutputFactory2)XMLOutputFactory2.newInstance();
		xmlOutputFactory.setProperty(XMLOutputFactory2.IS_REPAIRING_NAMESPACES, false);
		xmlOutputFactory.configureForSpeed();
		
		XMLStreamReaderDAO dao = null;
		try {
			SqlSessionFactoryBuilder ssfb = new SqlSessionFactoryBuilder();
			DefaultSqlSessionFactory ssf = (DefaultSqlSessionFactory)ssfb.build(Resources.getResourceAsReader("configuration.xml"));
			dao = new XMLStreamReaderDAO(ssf);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			streamReaderDAO = dao;
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
		dumpMap(cleanedUpForOurPurposes);
		
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
			XMLStreamReader streamReader = streamReaderDAO.getStreamReader("ogcMapper.observationsSelect", parameterMap);
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
		
		Element bBoxElement = DOMUtil.getElementByTagName(document.getDocumentElement(), BBOXElementName);
		if (bBoxElement != null) {
			Element lowerElement = DOMUtil.getElementByTagName(
					bBoxElement,
					lowerCornerElementName);
			Element upperElement = DOMUtil.getElementByTagName(
					bBoxElement,
					upperCornerElementName);
			if (lowerElement != null && upperElement != null) {
				String lowerText = lowerElement.getTextContent().trim();
				String upperText = upperElement.getTextContent().trim();
				if (lowerText != null && upperText != null) {
					String[] lowerSplit = cornerPattern.split(lowerText);
					String[] upperSplit = cornerPattern.split(upperText);
					if (lowerSplit.length == 2 && upperSplit.length == 2) {
						try {
							float lon0 = Float.parseFloat(lowerSplit[0]);
							float lat0 = Float.parseFloat(lowerSplit[1]);
							float lon1 = Float.parseFloat(upperSplit[0]);
							float lat1 = Float.parseFloat(upperSplit[1]);
							String east = null;
							String west = null;
							String south = null;
							String north = null;
							if (lon0 < lon1) {
								east = upperSplit[0];
								west = lowerSplit[0];
							} else {
								east = lowerSplit[0];
								west = upperSplit[0];
							}
							if (lat0 < lat1) {
								south = lowerSplit[1];
								north = upperSplit[1];
							} else {
								south = upperSplit[1];
								north = lowerSplit[1];
							}
							parameterMap.put("east", east);
							parameterMap.put("west", west);
							parameterMap.put("south", south);
							parameterMap.put("north", north);
						} catch (NumberFormatException e) {
							System.out.println(lowerCornerElementName + " or " + upperCornerElementName + " contain value with invalid number format");
						}
					} else {
						System.out.println(lowerCornerElementName + " or " + upperCornerElementName + " contain an invalid parameter count (expected 2).");
					}
				} else {
					System.out.println(lowerCornerElementName + " or " + upperCornerElementName + " are empty.");
				}
			} else {
				System.out.println(lowerCornerElementName + " or " + upperCornerElementName + " not found.");
			}
		} else {
			System.out.println(BBOXElementName + " : not found.");
		}
		return parameterMap;
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
