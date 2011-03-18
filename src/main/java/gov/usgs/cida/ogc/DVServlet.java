package gov.usgs.cida.ogc;

import com.ctc.wstx.stax.WstxOutputFactory;
import gov.usgs.cida.ogc.specs.OGC_WFSConstants;
import gov.usgs.cida.ogc.specs.SOS_1_0_Operation;
import gov.usgs.cida.ogc.utils.FileResponseUtil;
import gov.usgs.cida.ogc.utils.ServletHandlingUtils;
import gov.usgs.cida.ogc.utils.ServletHandlingUtils.RequestBodyExceededException;
import gov.usgs.cida.utils.collections.CaseInsensitiveMap;
import gov.usgs.webservices.ibatis.XMLStreamReaderDAO;
import gov.usgs.webservices.stax.XMLStreamUtils;

import java.io.BufferedWriter;
import java.io.IOException;
import java.util.HashMap;
import java.util.LinkedHashMap;
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
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.codehaus.stax2.XMLOutputFactory2;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;
import org.w3c.dom.Document;
import org.w3c.dom.Node;

/**
 * Servlet implementation class to handle WML requests
 */
public class DVServlet extends HttpServlet {

	private static final String OBSERVATION_ID = "observationId";
	private static final String DEFAULT_ENCODING = "UTF-8";
	private static final long serialVersionUID = 1L;
	//private final static String XPATH_Envelope = "//sos:GetObservation/sos:featureOfInterest/ogc:BBOX[ogc:PropertyName='gml:location']/gml:Envelope";
	private final static String XPATH_Envelope = "//sos:GetObservation/sos:featureOfInterest/ogc:BBOX/gml:Envelope";
	private final static String XPATH_cornerLower = "gml:lowerCorner/text()";
	private final static String XPATH_upperCorner = "gml:upperCorner/text()";
	//private final static String XPATH_filter = "//ogc:Filter";
	private final static String XPATH_eventTime = "//wml:eventTime";
	private final static String XPATH_featureId = "//sos:GetObservation/gml:identifier/text()";
        private final static String XPATH_observedProperty = "//om:observedProperty/@xlink:title";
	private static final String XPATH_observationId = "//sos:ObservationId";
        private static final String XPATH_beginPosition = "//om:result/sos:domainExtent/gml:TimePeriod/gml:beginPosition/text()";
        private static final String XPATH_endPosition = "//om:result/sos:domainExtent/gml:TimePeriod/gml:endPosition/text()";
	private final static Pattern PATTERN_cornerSplit = Pattern.compile("\\s+");
	private final static XMLOutputFactory2 xmlOutputFactory;

	static {
		xmlOutputFactory = new WstxOutputFactory();
		xmlOutputFactory.setProperty(XMLOutputFactory2.IS_REPAIRING_NAMESPACES, false);
		xmlOutputFactory.configureForSpeed();
	}

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public DVServlet() {
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
                parameterMap = applyBusinessRules(parameterMap);
		queryAndSend(request, response, parameterMap);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws RequestBodyExceededException, IOException {
		try {
			Document document = ServletHandlingUtils.extractXMLRequestDocument(request);
			Map<String, String[]> parameterMap = createParameterMapFromDocument(document);
			// we're going to treat this as a GetObservation by default if not specified
                        parameterMap = applyBusinessRules(parameterMap);
			queryAndSend(request, response, parameterMap);

		} catch (RequestBodyExceededException rbe) {
			// If we get errors in the request parsing, then just send the error
			int errorCode = (rbe.errorCode != null)? rbe.errorCode: 403; // 403 as default value for error code
			rbe.printStackTrace();
			response.sendError(errorCode, rbe.getMessage());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

        private Map<String, String[]> applyBusinessRules(Map<String, String[]> parameters){
            if (parameters.get("request") == null) {
                parameters.put("request", new String[] {SOS_1_0_Operation.GetObservation.name()});
            }

            String[] observedProperties = parameters.get(OGCBusinessRules.observedProperty);
            if (observedProperties != null && observedProperties.length > 0){
                String observedProperty = observedProperties[0];
            
                if (observedProperty.equalsIgnoreCase("Discharge")) {
                    observedProperty = "00060";
                } else if (observedProperty.equalsIgnoreCase("GageHeight")) {
                    observedProperty = "00065";
                } else if (observedProperty.equalsIgnoreCase("Temperature")) {
                    observedProperty = "00010";
                } else if (observedProperty.equalsIgnoreCase("Precipitation")) {
                    observedProperty = "00045";
                }

                parameters.put(OGCBusinessRules.observedProperty, new String[] {observedProperty});
            }
            return parameters;

        }

	private void queryAndSend(HttpServletRequest request, HttpServletResponse response, Map<String, String[]> parameterMap) throws IOException {
		ServletHandlingUtils.dumpRequestParamsToConsole(parameterMap);
		// TODO parameterMap may or may not be case-insensitive, depending on path of arrival post or get. Correct this later.
		SOS_1_0_Operation opType = SOS_1_0_Operation.parse(parameterMap.get("request"));

		ServletOutputStream outputStream = response.getOutputStream();
		response.setContentType(OGC_WFSConstants.DEFAULT_DESCRIBEFEATURETYPE_OUTPUTFORMAT);
		response.setCharacterEncoding(DEFAULT_ENCODING);
		switch (opType) {

			case GetObservationById:
				parameterMap = cleanObservationId(parameterMap);
				if (parameterMap.get(OGCBusinessRules.FEATURE_ID) == null) {
					// for us, the observationId is really the featureId
					parameterMap.put(OGCBusinessRules.FEATURE_ID, parameterMap.get(OBSERVATION_ID));
				}
				// intentional fall through to GetObservation
			case GetObservation:
				parameterMap = USGS_OGC_BusinessRules.cleanFeatureId(parameterMap);


				try {
					XMLStreamReader streamReader = getXMLStreamReaderDAO().getStreamReader("dvMapper.observationsSelect", parameterMap);
					XMLStreamWriter streamWriter = xmlOutputFactory.createXMLStreamWriter(outputStream);
					XMLStreamUtils.copy(streamReader, streamWriter);
				} catch (Exception e) {
					e.printStackTrace();
				} finally {
					outputStream.flush();
				}
				break;
			case GetDataAvailablity:
				parameterMap = USGS_OGC_BusinessRules.cleanFeatureId(parameterMap);

				try {
					XMLStreamReader streamReader = getXMLStreamReaderDAO().getStreamReader("dataMapper.dataSelect_1", parameterMap);
					XMLStreamWriter streamWriter = xmlOutputFactory.createXMLStreamWriter(outputStream);
					XMLStreamUtils.copy(streamReader, streamWriter);
				} catch (Exception e) {
					e.printStackTrace();
				} finally {
					outputStream.flush();
				}
                                break;
			case GetHistoricalData:
				parameterMap = USGS_OGC_BusinessRules.cleanFeatureId(parameterMap);

				try {
					XMLStreamReader streamReader = getXMLStreamReaderDAO().getStreamReader("dataMapper.dataHistorySelect", parameterMap);
					XMLStreamWriter streamWriter = xmlOutputFactory.createXMLStreamWriter(outputStream);
					XMLStreamUtils.copy(streamReader, streamWriter);
				} catch (Exception e) {
					e.printStackTrace();
				} finally {
					outputStream.flush();
				}
                                break;
			case GetCapabilities:
			{
				Map<String, String> replacementMap = new HashMap<String, String>();
				replacementMap.put("base.url", ServletHandlingUtils.parseBaseURL(request));

				// Just sending back static file for now.
				String resource = "/ogc/sos/dv" + opType.name() + ".xml";
				String errorMessage = "<error>Unable to retrieve resource " + resource + "</error";
				FileResponseUtil.writeToStreamWithReplacements(resource, outputStream, replacementMap,
						errorMessage);
			}
                        break;
			case GetProfile:
			case DescribeSensor:
			{
				Map<String, String> replacementMap = new HashMap<String, String>();
				replacementMap.put("base.url", ServletHandlingUtils.parseBaseURL(request));

				// Just sending back static file for now.
				String resource = "/ogc/sos/" + opType.name() + ".xml";
				String errorMessage = "<error>Unable to retrieve resource " + resource + "</error";
				FileResponseUtil.writeToStreamWithReplacements(resource, outputStream, replacementMap,
						errorMessage);
			}
                        break;
                        default:
				BufferedWriter writer = FileResponseUtil.wrapAsBufferedWriter(outputStream);
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

	private Map<String, String[]> cleanObservationId(Map<String, String[]> parameterMap) {
		String[] obsParam = parameterMap.get(OBSERVATION_ID);
		if (obsParam != null && obsParam[0] != null) {
			String obsId = obsParam[0];
			if (obsId.startsWith("obs.")) {
				// Parsing out the id we're currently putting into wml2:WaterMonitoringObservation/gml:identifier
				obsId = obsId.substring(4);
				obsParam[0] = obsId;
			}
		}
		return parameterMap;
	}

	private Map<String, String[]> createParameterMapFromDocument(Document document) throws Exception {
		if (document == null) {
			return null;
		}

		// LinkedHashMap retains iteration order, useful for diffing debug output. It's Tom's favorite
		Map<String, String[]> parameterMap = new LinkedHashMap<String, String[]>();

		XPathFactory xpathFactory = XPathFactory.newInstance();
		XPath xpath = xpathFactory.newXPath();
		xpath.setNamespaceContext(new OGCBinding.GetObservation_2_0_NamespaceContext());
//==========================================
		{ // parse service
			XPathExpression serviceExpression = xpath.compile("/*");
			Node serviceNode = (Node) serviceExpression.evaluate(document, XPathConstants.NODE);
			parameterMap.put("request", new String[] {serviceNode.getLocalName()});
		}


		// XPath expressions for the container of the bounding box and the upper and lower corners
		XPathExpression envelopeExpression =  xpath.compile(XPATH_Envelope);
		Object envelopeResult = envelopeExpression.evaluate(document, XPathConstants.NODE);
		if (envelopeResult != null && envelopeResult instanceof Node) {

			// We are necessarily in the GetObservations element, by the expression for XPATH_Envelope
			{	// bad logic. Refactor out
				parameterMap.put("request", new String[] {"GetObservation"});
			}

			extractBBox(parameterMap, xpath, (Node) envelopeResult);
		} else {
			System.out.println(XPATH_Envelope + " : not found.");
		}
		{
			// Handle observation ID
			XPathExpression obsIdExpression = xpath.compile(XPATH_observationId);
			Object obsIDResult = obsIdExpression.evaluate(document, XPathConstants.NODE);
			if (obsIDResult != null && obsIDResult instanceof Node) {
				Node obsIdNode = (Node)obsIDResult;
				String obsId = obsIdNode.getTextContent();
				parameterMap.put("observationId", new String[] {obsId});
			}
		}

		{
			// Handle feature ID
			XPathExpression featureIdExpression = xpath.compile(XPATH_featureId);
			Object featureIDResult = featureIdExpression.evaluate(document, XPathConstants.NODE);
			if (featureIDResult != null && featureIDResult instanceof Node) {
				Node featureIdNode = (Node)featureIDResult;
				String featureId = featureIdNode.getTextContent();

				parameterMap.put(OGCBusinessRules.FEATURE_ID, new String[] {featureId});
			}
		}

                {
			// Handle observedProperty
			XPathExpression observedPropertyExpression = xpath.compile(XPATH_observedProperty);
			Object observedPropertyResult = observedPropertyExpression.evaluate(document, XPathConstants.NODE);
			if (observedPropertyResult != null && observedPropertyResult instanceof Node) {
				Node observedPropertyNode = (Node)observedPropertyResult;
				String observedProperty = observedPropertyNode.getTextContent();    
                                        if (observedProperty.equalsIgnoreCase("Discharge")) {
                                            observedProperty = "00060";
                                        } else if (observedProperty.equalsIgnoreCase("GageHeight")) {
                                            observedProperty = "00065";
                                        } else if (observedProperty.equalsIgnoreCase("Temperature")) {
                                            observedProperty = "00010";
                                        } else if (observedProperty.equalsIgnoreCase("Precipitation")) {
                                            observedProperty = "00045";
                                        }
                                parameterMap.put(OGCBusinessRules.observedProperty, new String[] {observedProperty});				
			}
		}

		{
			//Handle Filter
			XPathExpression filterExpression = xpath.compile(XPATH_eventTime);
			Object filterResult = filterExpression.evaluate(document, XPathConstants.NODE);
			Map<String, String[]> filters = parseOGCTemporalFilter(xpath, filterResult);
			parameterMap.putAll(filters);
		}

		{
			// Handle the value constraints

			//			parse for sos:result
			//			parse for greaterThan, PropertyIsEqualTo?
			//					PropertyIsLessThan?
			//							PropertyIsNotEqualTo?
			//							PropertyIsGreaterThan?
			//							PropertyIsLessThanOrEqualTo?
			//							PropertyIsGreaterThanOrEqualTo?
			//							PropertyIsBetween?
			//			into 4 params:
			//				greaterThan, greaterThanOrEqual, lessThan, lessThanOrEqual
			//			and then process


		}
		return parameterMap;
	}

	public static String retrieveXPathAsString(XPathExpression expression, Document doc) {
		Object result;
		try {
			result = expression.evaluate(doc, XPathConstants.NODE);
			if (result != null && result instanceof Node) {
				Node node = (Node) result;
				return node.getTextContent();
			}
		} catch (XPathExpressionException e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * Parsing the temporal elements of OGC:Filter. Note that this is far from a
	 * complete implementation of parsing for Filter Encoding specification.
	 * Currently, it only parses three of the four temporal filters, ignoring
	 * properties and other aspects.
	 * 
	 * @param xpath
	 * @param filterResult
	 * @return
	 * @throws XPathExpressionException
	 */
	private Map<String, String[]> parseOGCTemporalFilter(XPath xpath, Object filterResult) throws XPathExpressionException {
		Map<String, String[]> filters = new LinkedHashMap<String, String[]>();
		// TODO: Indicate/record the property that the filter is working on.
		// Will need a different structure than the simple map. We don't care at
		// the moment because all of our data times are the same
		if (filterResult != null && filterResult instanceof Node) {
			Node filterNode = (Node) filterResult;

			// Look for TM_DURING
			XPathExpression tmDuringExpression = xpath.compile("//ogc:TM_During");
			Object tmDuringResult = tmDuringExpression.evaluate(filterNode,XPathConstants.NODE);
			if (tmDuringResult != null && tmDuringResult instanceof Node) {

				Node tmDuringNode = (Node) tmDuringResult;

				XPathExpression beginPositionExpression = xpath.compile("//gml:beginPosition");
				String beginPosition = beginPositionExpression.evaluate(tmDuringNode);
				XPathExpression endPositionExpression = xpath.compile("//gml:endPosition");
				String endPosition = endPositionExpression.evaluate(tmDuringNode);

				// TODO, change this parsing to include time of day
				filters.put("beginPosition", new String[] {truncateTimeOfDay(beginPosition)});
				filters.put("endPosition", new String[] {truncateTimeOfDay(endPosition)});
			}

			// Look for TM_After
			XPathExpression tmAfterExpression = xpath.compile("//ogc:TM_After");
			Object tmAfterResult = tmAfterExpression.evaluate(filterNode,XPathConstants.NODE);
			if (tmAfterResult != null && tmAfterResult instanceof Node) {
				Node tmAfterNode = (Node) tmAfterResult;

				XPathExpression tmPositionExpression = xpath.compile("//gml:timePosition");
				String timePosition = tmPositionExpression.evaluate(tmAfterNode);

				filters.put("beginPosition", new String[] {truncateTimeOfDay(timePosition)});
			}

			// Look for TM_Before
			XPathExpression tmBeforeExpression = xpath.compile("//ogc:TM_Before");
			Object tmBeforeResult = tmBeforeExpression.evaluate(filterNode,XPathConstants.NODE);
			if (tmBeforeResult != null && tmBeforeResult instanceof Node) {
				Node tmBeforeNode = (Node) tmBeforeResult;

				XPathExpression tmPositionExpression = xpath.compile("//gml:timePosition");
				String timePosition = tmPositionExpression.evaluate(tmBeforeNode);

				filters.put("endPosition", new String[] {truncateTimeOfDay(timePosition)});
			}

			// We're not looking for TM_Equal (or is it TM_Equals)

			//
			//			String featureId = filterNode.getTextContent();
			//			filters.put("featureId", new String[] {featureId});
		}
		return filters;
	}

	/**
	 * Remove time of day, leaving only date, from time expressions of the form 2008-04-01T17:47:00+02
	 * @param beginPosition
	 * @return
	 */
	private String truncateTimeOfDay(String beginPosition) {
		if (beginPosition == null) return null;
		if (beginPosition.length() >= 11 && beginPosition.charAt(10) == 'T') {
			return beginPosition.substring(0,10);
		}
		return null; // unrecognized time format
	}

	protected void extractBBox(Map<String, String[]> parameterMap, XPath xpath, Node envelopeNode)
	throws XPathExpressionException {
		XPathExpression lowerCornerExpression =  xpath.compile(XPATH_cornerLower);
		XPathExpression upperCornerExpression =  xpath.compile(XPATH_upperCorner);

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
