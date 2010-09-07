package gov.usgs.cida.ogc;

import gov.usgs.cida.utils.collections.CaseInsensitiveMap;
import gov.usgs.webservices.ibatis.XMLStreamReaderDAO;
import gov.usgs.webservices.stax.XMLStreamUtils;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.stream.XMLStreamException;
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
		// request pre-processing
		CaseInsensitiveMap<String> params = CaseInsensitiveMap.stringifyValues(request.getParameterMap());
		WFS_1_1_Operation opType = WFS_1_1_Operation.parse(params.get("request"));

		Map<String, Object> parameters = null;
		switch(opType) {
			case GetFeature:
				parameters = applyGetFeatureBusinessRulesScrubbing(params);
				break;
			case GetCapabilities:
			case DescribeFeatureType:
				parameters = new CaseInsensitiveMap<Object>();
				parameters.putAll(params);
				// Note that we don't actually do anything with the parameters at the moment.
				break;
			default:
				throw new IllegalArgumentException("Currently not handling REQUEST=" + opType.name());		
		}
		
		response.setContentType("text/xml");
		response.setCharacterEncoding("UTF-8");
		OutputStream outputStream = response.getOutputStream();
		
		try {
			handleRequest(parameters, outputStream, opType);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			outputStream.flush();
		}
		
	}

	private void handleRequest(Map<String, Object> parameters,
			OutputStream outputStream, WFS_1_1_Operation opType)
			throws ServletException, XMLStreamException, IOException {
		switch(opType) {
			case GetFeature:
				XMLStreamReader streamReader = getXMLStreamReaderDAO().getStreamReader("wfsMapper.wfsSelect", parameters);
				XMLStreamWriter streamWriter = xmlOutputFactory.createXMLStreamWriter(outputStream);
				XMLStreamUtils.copy(streamReader, streamWriter);
				break;
			case DescribeFeatureType:
				// Just sending back static file for now.
				String resource = "/ogc/wfs/DescribeFeatureType.xml";
				InputStream inStream = this.getClass().getResourceAsStream(resource);
				if (inStream != null) {
					copy(inStream, outputStream);
				} else {
					outputStream.write(("<error>Unable to retrieve resource " + resource + "</error").getBytes());
				}
				copy(inStream, outputStream);
				outputStream.flush();
				break;
			case GetCapabilities:
				// Note, should take a look at http://www.java2s.com/Open-Source/Java-Document/GIS/GeoServer/org/geoserver/wfs/CapabilitiesTransformer.java.htm
				// Just sending back static file for now.
				resource = "/ogc/wfs/GetCapabilities.xml";
				inStream = this.getClass().getResourceAsStream(resource);
				if (inStream != null) {
					copy(inStream, outputStream);
				} else {
					outputStream.write(("<error>Unable to retrieve resource " + resource + "</error").getBytes());
				}
				outputStream.flush();
				break;
				
		}
	}
	
    /**
     * Copies InputStream to OutputStream
     * 
     * @param input
     * @param output
     * @return
     * @throws IOException
     * [TODO] move this to a better location
     */
    public static int copy(InputStream input, OutputStream output)
                throws IOException {
        byte[] buffer = new byte[8 << 5]; // 8k buffer size
        int count = 0;
        int n = 0;
        while (-1 != (n = input.read(buffer))) {
            output.write(buffer, 0, n);
            count += n;
        }
        return count;
    }


	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
	

	private Map<String, Object> applyGetFeatureBusinessRulesScrubbing(CaseInsensitiveMap<String> params) {
		CaseInsensitiveMap<Object> result = new CaseInsensitiveMap<Object>();
		result.putAll(params);
		
		String typeName = (String) params.get("typeName");
		String bBox = (String) params.get("bBox");
		String featureId = (String) params.get("featureId");
		String maxFeatures = (String) params.get("maxFeatures");
		
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
					// Is this for Alaska, this switching of order?
					if (west > east) {
						String s = bBoxSplit[0]; bBoxSplit[0] = bBoxSplit[2]; bBoxSplit[2] = s;
					}
					if (south > north) {
						String s = bBoxSplit[1]; bBoxSplit[1] = bBoxSplit[3]; bBoxSplit[3] = s;
					}
					result.put("bBox", bBoxSplit);
				} catch (NumberFormatException e) {
					throw new IllegalArgumentException("BBOX invalid number format");
				}
			} else {
				throw new IllegalArgumentException("BBOX invalid argument count");
			}
		}
		if (featureId != null) {
			result.put("featureId", featureId);
		}
		if (maxFeatures != null) {
			try {
				int maxFeaturesI = Integer.parseInt(maxFeatures);
				if (maxFeaturesI > 0) {
					result.put("maxFeatures", maxFeaturesI);
				}
			} catch (NumberFormatException e) {
				throw new IllegalArgumentException("MAXFEATURES invalid number format");
			}
		}
		
		return result;
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
