package gov.usgs.cida.ogc;

import gov.usgs.webservices.ibatis.XMLStreamReaderDAO;

import java.io.IOException;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;

import javanet.staxutils.XMLStreamUtils;

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
	@SuppressWarnings("unchecked")
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		Object parameters = parseParameterMap((Map<String, String[]>)request.getParameterMap());
		
		response.setContentType("text/xml");
		response.setCharacterEncoding("UTF-8");
		OutputStream outputStream = response.getOutputStream();
		try {
			XMLStreamReader streamReader = getXMLStreamReaderDAO().getStreamReader("wfsMapper.wfsSelect", parameters);
			XMLStreamWriter streamWriter = xmlOutputFactory.createXMLStreamWriter(outputStream);
			XMLStreamUtils.copy(streamReader, streamWriter);
		} catch (XMLStreamException e) {
			e.printStackTrace();
		} finally {
			outputStream.flush();
		}
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
	
	private Object parseParameterMap(Map<String, String[]> originalMap) {
		
		Map<String, Object> scrubbedMap = new HashMap<String, Object>();
		
		String request = null;
		String typeName = null;
		String bBox = null;
		String featureId = null;
		String maxFeatures = null;
		for (Map.Entry<String, String[]> entry : originalMap.entrySet()) {
			String key = entry.getKey();
			String[] value = entry.getValue();
			if ("request".equalsIgnoreCase(key)) {
				if (value != null && value.length > 0) { request = value[0]; }
			} else if ("typeName".equalsIgnoreCase(key)) {
				if (value != null && value.length > 0) { typeName = value[0]; }
			} else if ("bBox".equalsIgnoreCase(key)) {
				if (value != null && value.length > 0) { bBox = value[0]; }
			} else if ("featureId".equalsIgnoreCase(key)) {
				if (value != null && value.length > 0) { featureId = value[0]; }
			} else if ("maxFeatures".equalsIgnoreCase(key)) {
				if (value != null && value.length > 0) { maxFeatures = value[0]; }
			}
		}
		
		if(!"GetFeature".equalsIgnoreCase(request)) {
			throw new IllegalArgumentException("REQUEST missing or invalid");
		}
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
}
