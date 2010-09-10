package gov.usgs.cida.ogc;

import gov.usgs.cida.ogc.specs.OGC_WFSConstants;
import gov.usgs.cida.ogc.specs.SOS_1_0_Operation;
import gov.usgs.cida.ogc.utils.DOMUtil;
import gov.usgs.cida.ogc.utils.FileResponseUtil;
import gov.usgs.cida.utils.collections.CaseInsensitiveMap;
import gov.usgs.webservices.ibatis.XMLStreamReaderDAO;
import gov.usgs.webservices.stax.XMLStreamUtils;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLDecoder;
import java.nio.CharBuffer;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.stream.XMLStreamReader;
import javax.xml.stream.XMLStreamWriter;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathFactory;

import org.codehaus.stax2.XMLOutputFactory2;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;
import org.w3c.dom.Document;
import org.w3c.dom.Node;

/**
 * Servlet implementation class to handle SOS requests
 */
public class SOSServlet extends HttpServlet {
	
	public static final String SPECIAL_XML_POST_VARIABLE = "requestHack";
	private static final long serialVersionUID = 1L;

//	private final static String XPATH_Envelope = "//sos:GetObservation/sos:featureOfInterest/ogc:BBOX[ogc:PropertyName='gml:location']/gml:Envelope";
	private final static String XPATH_Envelope = "//sos:GetObservation/sos:featureOfInterest/ogc:BBOX/gml:Envelope";
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
	public SOSServlet() {
		super();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	@Override
	@SuppressWarnings("unchecked")
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Map<String, String[]> parameterMap = new CaseInsensitiveMap<String[]>(request.getParameterMap());
		queryAndSend(request, response, parameterMap);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			String contentType = request.getContentType();
			String characterEncoding = request.getCharacterEncoding();
			if ( characterEncoding == null || characterEncoding.length() == 0) {
				characterEncoding = "UTF-8"; // default character encoding if unspecified
			}

			BufferedReader reader = request.getReader();
			CharBuffer buffer = CharBuffer.allocate(128 << 10);
			while ( reader.read(buffer) != -1 &&
					buffer.hasRemaining() );
			
			// Protect against denial of service attacks?
			if (buffer.remaining() == 0 && reader.read() > -1) {
				response.sendError(403, "Request body too large, limited to " + buffer.capacity() + " bytes");
				return;
			}
			
			buffer.flip();
			String documentString = buffer.toString();
	
			// Perform URL decoding, if necessary
			if ("application/x-www-form-urlencoded".equals(contentType)) {
				if (documentString.startsWith(SPECIAL_XML_POST_VARIABLE + "=")) {
					// This is a hack to permit xml to be easily submitted via a form POST.
					// By convention, we are allowing users to post xml if they name it
					// with a POST parameter "request". The problem is that "request" is
					// a reserved key in OGC services, and should not be used.
					documentString = documentString.substring(SPECIAL_XML_POST_VARIABLE.length() + 1);	
				}
				documentString = URLDecoder.decode(documentString, characterEncoding);
			}

			Document document = DOMUtil.createDocument(documentString);
			
			Map<String, String[]> parameterMap = createParameterMapFromDocument(document);
			queryAndSend(request, response, parameterMap);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	private void queryAndSend(HttpServletRequest request, HttpServletResponse response, Map<String, String[]> parameterMap) throws IOException {
		dumpMap(parameterMap);
		// TODO parameterMap may or may not be case-insensitive, depending on path of arrival post or get. Correct this later.
		SOS_1_0_Operation opType = SOS_1_0_Operation.parse(parameterMap.get("request"));
		
		ServletOutputStream outputStream = response.getOutputStream();
		response.setContentType(OGC_WFSConstants.DEFAULT_DESCRIBEFEATURETYPE_OUTPUTFORMAT);
		response.setCharacterEncoding("UTF-8");
		switch (opType) {
			case GetObservation:
				try {
					XMLStreamReader streamReader = getXMLStreamReaderDAO().getStreamReader("sosMapper.observationsSelect", parameterMap);
					XMLStreamWriter streamWriter = xmlOutputFactory.createXMLStreamWriter(outputStream);
					XMLStreamUtils.copy(streamReader, streamWriter);
				} catch (Exception e) {
					e.printStackTrace();
				} finally {
					outputStream.flush();
				}
				break;
			case GetCapabilities:
				String baseURL = request.getRequestURL().toString().replaceFirst(request.getServletPath() + "$", "");
				Map<String, String> replacementMap = new HashMap<String, String>();
				replacementMap.put("base.url", baseURL);

				// Just sending back static file for now.
				String resource = "/ogc/sos/GetCapabilities.xml";
				String errorMessage = "<error>Unable to retrieve resource " + resource + "</error";
				FileResponseUtil.writeToStreamWithReplacements(resource, outputStream, replacementMap,
						errorMessage);
				break;
			case DescribeSensor:
				BufferedWriter writer = FileResponseUtil.wrapAsBufferedWriter(outputStream);
				try {
					writer.append("<error>DescribeSensor REQUEST type to be implemented</error>");
				} catch (Exception e) {
					// TODO: handle exception
				} finally {
					outputStream.flush();
				}
				
				break;
			default:
				writer = FileResponseUtil.wrapAsBufferedWriter(outputStream);
				try {
					writer.append("unrecognized or unhandled REQUEST type = " + opType);
				} catch (Exception e) {
					// TODO: handle exception
				} finally {
					outputStream.flush();
				}
				break;
		}

	}

	private Map<String, String[]> createParameterMapFromDocument(Document document) throws Exception {
		if (document == null) {
			return null;
		}
		// TODO Ask Tom why a LinkedHashMap?
		Map<String, String[]> parameterMap = new LinkedHashMap<String, String[]>();
		
		XPathFactory xpathFactory = XPathFactory.newInstance();
		XPath xpath = xpathFactory.newXPath();
		xpath.setNamespaceContext(new OGCBinding.GetObservationNamespaceContext());
		
		// Currently, the only parameter we are handling is the bounding box
		
		// XPath expressions for the container of the bounding box and the upper and lower corners
		XPathExpression envelopeExpression =  xpath.compile(XPATH_Envelope);
		XPathExpression lowerCornerExpression =  xpath.compile(XPATH_cornerLower);
		XPathExpression upperCornerExpression =  xpath.compile(XPATH_upperCorner);
		
		Object envelopeResult = envelopeExpression.evaluate(document, XPathConstants.NODE);
		if (envelopeResult != null && envelopeResult instanceof Node) {
			Node envelopeNode = (Node)envelopeResult;
			String lowerCornerString = lowerCornerExpression.evaluate(envelopeNode);
			String upperCornerString = upperCornerExpression.evaluate(envelopeNode);
			
			// Parse the coordinates of the bounding box corner parameters
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

	/**
	 * Output request parameters to System.out() for debugging/logging
	 * 
	 * @param m map
	 */
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
