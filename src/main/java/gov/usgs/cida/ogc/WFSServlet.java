package gov.usgs.cida.ogc;

import gov.usgs.webservices.ibatis.XMLStreamReaderDAO;
import gov.usgs.webservices.stax.XMLStreamUtils;
import java.io.BufferedReader;
import java.io.BufferedWriter;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.Reader;
import java.io.Writer;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.stream.XMLStreamReader;
import javax.xml.stream.XMLStreamWriter;

import org.codehaus.stax2.XMLOutputFactory2;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

/**
 * Servlet implementation class WFSServlet
 */
public class WFSServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	
	private final static XMLOutputFactory2 xmlOutputFactory;
	static {
		xmlOutputFactory = (XMLOutputFactory2)XMLOutputFactory2.newInstance();
		xmlOutputFactory.setProperty(XMLOutputFactory2.IS_REPAIRING_NAMESPACES, false);
		xmlOutputFactory.configureForSpeed();
	}
	

	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public WFSServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	@Override
	@SuppressWarnings("unchecked")
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		Map<String, Object> parameters = parseParameterMap((Map<String, String[]>)request.getParameterMap());
		
		response.setContentType("text/xml");
		response.setCharacterEncoding("UTF-8");
		WFS_1_1_Operation opType = WFS_1_1_Operation.parse((String)parameters.get("request"));

		switch(opType) {

			case GetFeature:
				OutputStream outputStream = response.getOutputStream();
				try {
					XMLStreamReader streamReader = getXMLStreamReaderDAO().getStreamReader("wfsMapper.wfsSelect", parameters);
					XMLStreamWriter streamWriter = xmlOutputFactory.createXMLStreamWriter(outputStream);
					XMLStreamUtils.copy(streamReader, streamWriter);
				} catch (Exception e) {
					e.printStackTrace();
				} finally {
					outputStream.flush();
				}
				break;

			case GetCapabilities:
			case DescribeFeatureType:

				String baseURL = request.getRequestURL().toString().replaceFirst(request.getServletPath() + "$", "");
				Map<String, String> replacementMap = new HashMap<String, String>();
				replacementMap.put("base.url", baseURL);

				// Just sending back static file for now.
				String resource = opType == WFS_1_1_Operation.GetCapabilities ?
					"/ogc/wfs/GetCapabilities.xml" :
					"/ogc/wfs/DescribeFeatureType.xml";

				InputStream inputStream = getClass().getResourceAsStream(resource);
				BufferedWriter writer = wrapAsBufferedWriter(response.getWriter());
				try {
					if (inputStream != null) {
						filter (replacementMap,
								wrapAsBufferedReader(inputStream),
								writer);
					} else {
						writer.append("<error>Unable to retrieve resource " + resource + "</error");
					}
				} finally {
					writer.flush();
					if (inputStream != null) {
						try { inputStream.close(); } catch (IOException e) { }
					}
				}
			break;
		}
	}
	
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
	
	private Map<String, Object> parseParameterMap(Map<String, String[]> originalMap) {
		
		WFS_1_1_Operation opType = determineRequestType(originalMap);
		
		if (opType == null)	{
			throw new IllegalArgumentException("REQUEST missing");
		}
		
		Map<String, Object> scrubbedMap = scrub(originalMap, opType);
		switch(opType) {
			case GetFeature:
				return applyGetFeatureBusinessRulesScrubbing(scrubbedMap);
			case GetCapabilities:
			case DescribeFeatureType:
				return scrubbedMap;
			default:
				throw new IllegalArgumentException("Currently not handling REQUEST=" + opType.name());		
		}
	}
	
	private WFS_1_1_Operation determineRequestType(Map<String, String[]> originalMap){
		for (Map.Entry<String, String[]> entry : originalMap.entrySet()) {
			if ("request".equalsIgnoreCase(entry.getKey())) {
				String[] value = entry.getValue();
				if (value != null && value.length > 0) {
					return WFS_1_1_Operation.parse(value[0]);
				}
			}
		}
		return null;
	}

	private Map<String, Object> scrub(Map<String, String[]> originalMap,
			WFS_1_1_Operation opType) {
		Map<String, Object> result = new HashMap<String, Object>();
		List<String> handledParameters = opType.opArguments;
		for (Map.Entry<String, String[]> entry : originalMap.entrySet()) {
			String key = entry.getKey();
			String[] value = entry.getValue();
			boolean isHandled = false;
			if (handledParameters.size() > 0) {
				for (String param: handledParameters) {
					if (param.equalsIgnoreCase(key)) {
						result.put(param, value[0]);
						isHandled = true;
					}
				}
			}
			if (!isHandled){
				// just take the first parameter and lowercase the key.
				result.put(key.toLowerCase(), value[0]);
			}
		}

		return result;
	}

	private Map<String, Object> applyGetFeatureBusinessRulesScrubbing(Map<String, Object> scrubbedMap) {
		String typeName = (String) scrubbedMap.get("typeName");
		String bBox = (String) scrubbedMap.get("bBox");
		String featureId = (String) scrubbedMap.get("featureId");
		String maxFeatures = (String) scrubbedMap.get("maxFeatures");
		if(!"gwml:WaterWell".equals(typeName) && featureId == null) {
			throw new IllegalArgumentException("TYPENAME missing or invalid");
		}
		if(bBox != null) {
			String[] bBoxSplit = bBox.split(",");
			if (bBoxSplit != null && bBoxSplit.length == 4) {
				try {
					float west = Float.parseFloat(bBoxSplit[0]);
					float south = Float.parseFloat(bBoxSplit[1]);
					float east = Float.parseFloat(bBoxSplit[2]);
					float north = Float.parseFloat(bBoxSplit[3]);
					if (Float.isNaN(west) || Float.isNaN(south) || Float.isNaN(east) || Float.isNaN(north)) {
						throw new IllegalArgumentException("BBOX invalid number value");
					}
					if (west > east) {
						String s = bBoxSplit[0]; bBoxSplit[0] = bBoxSplit[2]; bBoxSplit[2] = s;
					}
					if (south > north) {
						String s = bBoxSplit[1]; bBoxSplit[1] = bBoxSplit[3]; bBoxSplit[3] = s;
					}
					scrubbedMap.put("bBox", bBoxSplit);
				} catch (NumberFormatException e) {
					throw new IllegalArgumentException("BBOX invalid number format");
				}
			} else {
				throw new IllegalArgumentException("BBOX invalid argument count");
			}
		}
		if (featureId != null) {
			scrubbedMap.put("featureId", featureId);
		}
		if (maxFeatures != null) {
			try {
				int maxFeaturesI = Integer.parseInt(maxFeatures);
				if (maxFeaturesI > 0) {
					scrubbedMap.put("maxFeatures", maxFeaturesI);
				}
			} catch (NumberFormatException e) {
				throw new IllegalArgumentException("MAXFEATURES invalid number format");
			}
		}
		
		return scrubbedMap;
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

	private final static Pattern REGEXREPLACE_PATTERN = Pattern.compile("\\$\\{([\\w\\.]+)\\}");

	private void filter(Map<String, String> replacementMap, BufferedReader reader, BufferedWriter writer) throws IOException {
		String line = null;
		while ( (line = reader.readLine()) != null) {
			Matcher matcher = REGEXREPLACE_PATTERN.matcher(line);
			StringBuffer filteredLineBuffer = new StringBuffer();
			while (matcher.find()) {
				String key = matcher.group(1);
				String value = replacementMap.get(key);
				if (value == null) {
					// if no key found in replacement map, just put back the original value
					value = matcher.group();
				}
				matcher.appendReplacement(filteredLineBuffer, value);
			}
			matcher.appendTail(filteredLineBuffer);
			writer.append(filteredLineBuffer);
			writer.newLine();
		}
		writer.flush();
	}

	private BufferedWriter wrapAsBufferedWriter(OutputStream outputStream) {
		return new BufferedWriter(new OutputStreamWriter(outputStream));
	}

	private BufferedWriter wrapAsBufferedWriter(Writer writer) {
		return writer instanceof BufferedWriter ?
			(BufferedWriter)writer :
			new BufferedWriter(writer);
	}

	private BufferedReader wrapAsBufferedReader(InputStream inputStream) {
		return new BufferedReader(new InputStreamReader(inputStream));
	}

	private BufferedReader wrapAsBufferedReader(Reader reader) {
		return reader instanceof BufferedReader ?
			(BufferedReader)reader :
			new BufferedReader(reader);
	}
}
