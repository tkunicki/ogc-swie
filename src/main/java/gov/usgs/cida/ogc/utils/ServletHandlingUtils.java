package gov.usgs.cida.ogc.utils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.nio.CharBuffer;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.xml.sax.SAXException;

public class ServletHandlingUtils {
	public static final int BUFFER_CAPACITY = 128 << 10;
	public static final String SPECIAL_XML_POST_VARIABLE = "requestHack";
	
	public static Document extractXMLRequestDocument(HttpServletRequest request) throws IOException, RequestBodyExceededException,
			UnsupportedEncodingException, ParserConfigurationException,
			SAXException {
		String contentType = request.getContentType();
		String characterEncoding = request.getCharacterEncoding();
		if ( characterEncoding == null || characterEncoding.length() == 0) {
			characterEncoding = "UTF-8"; // default character encoding if unspecified
		}
	
		BufferedReader reader = request.getReader();
		CharBuffer buffer = CharBuffer.allocate(BUFFER_CAPACITY);
		while ( reader.read(buffer) != -1 &&
				buffer.hasRemaining() );
		
		// Protect against denial of service attacks?
		if (buffer.remaining() == 0 && reader.read() > -1) {
			throw new RequestBodyExceededException(403, "Request body too large, limited to " + buffer.capacity() + " bytes");
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
		return document;
	}
	
	public static class RequestBodyExceededException extends ServletException {
		/**
		 * 
		 */
		private static final long serialVersionUID = 2730556083230748551L;
		public final Integer errorCode;
		
		public RequestBodyExceededException(String message) {
			super(message);
			errorCode = null;
		}
		public RequestBodyExceededException(int error, String message) {
			super(message);
			this.errorCode = error;
		}
	}

	public static String parseBaseURL(HttpServletRequest request) {
		String baseURL = request.getRequestURL().toString().replaceFirst(request.getServletPath() + "$", "");
		return baseURL;
	}

	/**
	 * Output request parameters to System.out() for debugging/logging
	 * 
	 * @param m map
	 */
	public static void dumpRequestParamsToConsole(Map<String, String[]> m) {
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
	
//	public static 



}
