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
       
	public final static String MAX_FEATURE = "maxFeatures";
	public final static String BBOX = "BBOX";
	public final static String REQUEST = "REQUEST";
	public final static String TYPENAME = "TYPENAME";
	
	private final static Pattern PATTERN_SPLIT_BBOX = Pattern.compile(",");
	
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
		Map<String, String[]> parameterMap = new HashMap<String, String[]>((Map<String, String[]>)request.getParameterMap());
		
		parseParameterMap(parameterMap);
		
		response.setContentType("text/xml");
		response.setCharacterEncoding("UTF-8");
		OutputStream outputStream = response.getOutputStream();
		try {
			XMLStreamReader streamReader = getXMLStreamReaderDAO().getStreamReader("wfsMapper.wfsSelect", parameterMap);
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
	
	private void parseParameterMap(Map<String, String[]> parameterMap) {
		String[] bBox = parameterMap.get(BBOX);
		if(bBox != null && bBox.length == 1) {
			String[] split = PATTERN_SPLIT_BBOX.split(bBox[0]);
			if (split != null && split.length == 4) {
				try {
					float lon0 = Float.parseFloat(split[0]);
					float lat0 = Float.parseFloat(split[1]);
					float lon1 = Float.parseFloat(split[2]);
					float lat1 = Float.parseFloat(split[3]);
					if (Float.isNaN(lon0) || Float.isNaN(lat0) || Float.isNaN(lon1) || Float.isNaN(lat1)) {
						System.err.println("invalid number format");
					} else {
						if (lon0 < lon1) {
							parameterMap.put("east", new String[] { split[2]} );
							parameterMap.put("west", new String[] { split[0]} );
						} else {
							parameterMap.put("east", new String[] { split[0] } );
							parameterMap.put("west", new String[] { split[2] } );
						}
						if (lat0 < lat1) {
							parameterMap.put("south", new String[] { split[1] } );
							parameterMap.put("north", new String[] { split[3] } );
						} else {
							parameterMap.put("south", new String[] { split[3] } );
							parameterMap.put("north", new String[] { split[1] } );
						}
					}
				} catch (NumberFormatException e) {
					// error
				}
			} else {
				// error
			}
		} else {
			// error
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
