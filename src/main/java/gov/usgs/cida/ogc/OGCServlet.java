package gov.usgs.cida.ogc;

import gov.usgs.webservices.ibatis.IXMLStreamReaderDAO;
import gov.usgs.webservices.ibatis.XMLStreamReaderDAO;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLDecoder;
import java.nio.CharBuffer;
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
import javax.xml.stream.XMLStreamReader;
import javax.xml.stream.XMLStreamWriter;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathFactory;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.apache.ibatis.session.defaults.DefaultSqlSessionFactory;
import org.codehaus.stax2.XMLOutputFactory2;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;
import org.w3c.dom.Document;
import org.w3c.dom.Node;

/**
 * Servlet implementation class OGCServlet
 */
public class OGCServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;

	private final static String XPATH_Envelope = "//sos:GetObservation/sos:featureOfInterest/ogc:BBOX[ogc:PropertyName='gml:location']/gml:Envelope";
	private final static String XPATH_cornerLower = "gml:lowerCorner/text()";
	private final static String XPATH_upperCorner = "gml:upperCorner/text()";
	
	private final static Pattern PATTERN_cornerSplit = Pattern.compile("\\s+");
	
	private final static XMLOutputFactory2 xmlOutputFactory;
	
	static {
		xmlOutputFactory = (XMLOutputFactory2)XMLOutputFactory2.newInstance();
		xmlOutputFactory.setProperty(XMLOutputFactory2.IS_REPAIRING_NAMESPACES, false);
		xmlOutputFactory.configureForSpeed();
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
			String contentType = request.getContentType();
			String characterEncoding = request.getCharacterEncoding();
			if ( characterEncoding == null || characterEncoding.length() == 0) {
				characterEncoding = "UTF-8";
			}

			BufferedReader reader = request.getReader();
			CharBuffer buffer = CharBuffer.allocate(128 << 10);
			while ( reader.read(buffer) != -1 &&
					buffer.hasRemaining() );
			
			if (buffer.remaining() == 0 && reader.read() > -1) {
				response.sendError(403, "Request body too large, limited to " + buffer.capacity() + " bytes");
				return;
			}
			
			buffer.flip();
			String documentString = buffer.toString();
	
			if ("application/x-www-form-urlencoded".equals(contentType)) {
				if (documentString.startsWith("request=")) {
					documentString = documentString.substring(8);	
				}
				documentString = URLDecoder.decode(documentString, characterEncoding);
			}

			Document document = DOMUtil.createDocument(documentString);
			
			Map<String, String[]> parameterMap = createParameterMapFromDocument(document);
			queryAndSend(parameterMap, response);
			
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
			XMLStreamReader streamReader = getXMLStreamReaderDAO().getStreamReader("ogcMapper.observationsSelect", parameterMap);
			XMLStreamWriter streamWriter = xmlOutputFactory.createXMLStreamWriter(outputStream);
			XMLStreamUtils.copy(streamReader, streamWriter);
		}catch (Exception e) {
			e.printStackTrace();
		} finally {
			outputStream.flush();
		}
	}

	private Map<String, String[]> createParameterMapFromDocument(Document document) throws Exception {
		if (document == null) {
			return null;
		}
		Map<String, String[]> parameterMap = new LinkedHashMap<String, String[]>();
		
		XPathFactory xpathFactory = XPathFactory.newInstance();
		XPath xpath = xpathFactory.newXPath();
		xpath.setNamespaceContext(new OGCBinding.GetObservationNamespaceContext());
		XPathExpression envelopeExpression =  xpath.compile(XPATH_Envelope);
		XPathExpression lowerCornerExpression =  xpath.compile(XPATH_cornerLower);
		XPathExpression upperCornerExpression =  xpath.compile(XPATH_upperCorner);
		
		Object envelopeResult = envelopeExpression.evaluate(document, XPathConstants.NODE);
		if (envelopeResult != null && envelopeResult instanceof Node) {
			Node envelopeNode = (Node)envelopeResult;
			String lowerCornerString = lowerCornerExpression.evaluate(envelopeNode);
			String upperCornerString = upperCornerExpression.evaluate(envelopeNode);
			if (lowerCornerString != null && upperCornerString != null) {
				String[] lowerSplit = PATTERN_cornerSplit.split(lowerCornerString.trim());
				String[] upperSplit = PATTERN_cornerSplit.split(upperCornerString.trim());
				if (lowerSplit.length == 2 && upperSplit.length == 2) {
					try {
						float lon0 = Float.parseFloat(lowerSplit[0]);
						float lat0 = Float.parseFloat(lowerSplit[1]);
						float lon1 = Float.parseFloat(upperSplit[0]);
						float lat1 = Float.parseFloat(upperSplit[1]);
						if (Float.isNaN(lon0) || Float.isNaN(lat0) || Float.isNaN(lon1) || Float.isNaN(lat1)) {
							System.err.println("invalid number format");
						} else {
							if (lon0 < lon1) {
								parameterMap.put("east", new String[] { upperSplit[0]} );
								parameterMap.put("west", new String[] { lowerSplit[0]} );
							} else {
								parameterMap.put("east", new String[] { lowerSplit[0] } );
								parameterMap.put("west", new String[] { upperSplit[0] } );
							}
							if (lat0 < lat1) {
								parameterMap.put("south", new String[] { lowerSplit[1] } );
								parameterMap.put("north", new String[] { upperSplit[1] } );
							} else {
								parameterMap.put("south", new String[] { upperSplit[1] } );
								parameterMap.put("north", new String[] { lowerSplit[1] } );
							}
						}
					} catch (NumberFormatException e) {
						System.out.println(XPATH_cornerLower + " or " + XPATH_upperCorner + " contain value with invalid number format");
					}
				} else {
					System.out.println(XPATH_cornerLower + " or " + XPATH_upperCorner + " contain an invalid parameter count (expected 2, whitespace delimited).");
				}
			} else {
				System.out.println(XPATH_cornerLower + " or " + XPATH_upperCorner + " not found.");
			}
		} else {
			System.out.println(XPATH_Envelope + " : not found.");
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
	
	private XMLStreamReaderDAO getXMLStreamReaderDAO() throws ServletException {
		XMLStreamReaderDAO xmlStreamReaderDAO = null;
		ApplicationContext ac = WebApplicationContextUtils.getWebApplicationContext(getServletContext());
		if (ac != null) {
			Object o = ac.getBean("xmlStreamReaderDAO");
			if (o != null && o instanceof XMLStreamReaderDAO) {
				xmlStreamReaderDAO = (XMLStreamReaderDAO)o;
			}
		}
		if(xmlStreamReaderDAO == null) {
			throw new ServletException("Configuation error, unable to obtain reference to XMLStreamReaderDAO");
		}
		return xmlStreamReaderDAO;
	}
}
