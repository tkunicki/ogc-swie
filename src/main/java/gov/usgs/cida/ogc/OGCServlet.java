package gov.usgs.cida.ogc;

import gov.usgs.webservices.ibatis.IXMLStreamReaderDAO;
import gov.usgs.webservices.ibatis.XMLStreamReaderDAO;

import java.io.IOException;
import java.io.OutputStream;
import java.util.Arrays;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
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
import org.xml.sax.SAXException;

/**
 * Servlet implementation class EchoServlet
 */
public class OGCServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;

	private final static DocumentBuilderFactory documentBuilderFactory;
	private final static IXMLStreamReaderDAO streamReaderDAO;
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
		
		IXMLStreamReaderDAO dao = null;
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
	@SuppressWarnings("unchecked")
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Map<String, String[]> parameterMap = request.getParameterMap();
		queryAndSend(parameterMap , response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			Document document = createDocumentFromRequest(request);
			Map<String, String[]> parameterMap = createParameterMapFromDocument(document);
			queryAndSend(parameterMap, response);
		} catch (ParserConfigurationException e) {
			e.printStackTrace();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	private void queryAndSend(Map<String, String[]> parameterMap, HttpServletResponse response) throws IOException {
		dumpMap(parameterMap);
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

	private Map<String, String[]> createParameterMapFromDocument(Document document) throws Exception {
		if (document == null) {
			return null;
		}
		Map<String, String[]> parameterMap = new LinkedHashMap<String, String[]>();
		
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
							parameterMap.put("east", new String[] { east } );
							parameterMap.put("west", new String[] { west } );
							parameterMap.put("south", new String[] { south } );
							parameterMap.put("north", new String[] { north } );
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

	private void dumpMap(Map<String, String[]> m) {
		System.out.println("Parameters are: ");
		if (m != null && m.size() > 0) {
			for (Map.Entry<String, String[]> e : m.entrySet()) {
				System.out.print(" " + e.getKey() + "-> ");
				List<String> v = Arrays.asList(e.getValue());
				Iterator<String> i = v.iterator();
				if ( i.hasNext()) {
					System.out.print(i.next());
					while (i.hasNext()) {
						System.out.print(", " + i.next());
					}
				} else {
					System.out.print("[empty]");
				}
				System.out.println();
			}
		} else {
			System.out.println("[empty]");
		}
	}
}
