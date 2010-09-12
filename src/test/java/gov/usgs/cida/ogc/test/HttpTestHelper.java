package gov.usgs.cida.ogc.test;
import gov.usgs.cida.testanddebug.CharacterizationTestHelper;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;

import com.gargoylesoftware.htmlunit.WebClient;
import com.gargoylesoftware.htmlunit.WebRequestSettings;
import com.gargoylesoftware.htmlunit.WebResponse;



public class HttpTestHelper extends CharacterizationTestHelper{

protected static final String HOST = "localhost:8088";
protected static final String PROTOCOL = "http://";
protected static final String WEBAPP_CONTEXT = "/ogc-ie"; //"/ogc-ie-old"
protected static final String SERVICE_ADDRESS = PROTOCOL + HOST + WEBAPP_CONTEXT;
protected static String SERVICE_NAME = null;
protected HttpURLConnection httpConn = null;
protected OgcParams params;
	
	public static class Response{
		public final String content;
		public final String url;
		public final String mimeType;
		public final Integer responseCode;
		
		public Response(String content, String URL, String mimeType, int responseCode) {
			this.content = content;
			this.url = URL;
			this.mimeType = mimeType;
			this.responseCode = responseCode;
		}

		@Override
		public String toString() {
			return "Response [\n\tcontent=" + content + "\n\tmimeType=" + mimeType
					+ "\n\tresponseCode=" + responseCode + "\n\turl=" + url + "\n]";
		}
		
	}
	
	/**
	 * Returns a reader for handling large responses.
	 * 
	 * @param fullAddress
	 * @return
	 * @throws IOException
	 */
	protected BufferedReader readConnection(String fullAddress) throws IOException {
		URL serviceURL = new URL(fullAddress);
		URLConnection connection = serviceURL.openConnection();
		BufferedReader reader = null;
		if (connection instanceof HttpURLConnection) {
			httpConn = (HttpURLConnection)connection;
			httpConn.getResponseCode();
			try {
				httpConn.connect();
				reader = new BufferedReader(new InputStreamReader(httpConn.getInputStream()));
			}
			catch (IOException ioe) {
				reader = new BufferedReader(new InputStreamReader(httpConn.getErrorStream()));
			}
		}
		return reader;
	}

	
	protected boolean connectRESTAndTestContains(String responseRegex)	throws IOException {
		String url = buildRestUrl();
		BufferedReader reader = readConnection(url);
		if (reader == null) return false;
		
		String line;
		while ((line = reader.readLine()) != null) {
			if (line.contains(responseRegex)) {
				reader.close();
				return true;
			}
		}
		reader.close();
		return false;
	}

	protected boolean connectSOAPAndTestContains(String soapResponseRegex) throws IOException {
		WebClient webClient = new WebClient();

		WebRequestSettings wrs = buildBusinessSoapRequest();

		WebResponse resp = webClient.loadWebResponse(wrs);
		String xmlResponse = resp.getContentAsString();
		return xmlResponse.contains(soapResponseRegex);
	}
	
	protected WebRequestSettings buildBusinessSoapRequest() {
		// TODO Figure out how to extract this business-specific logic
		String namespace = SERVICE_ADDRESS + "/" + SERVICE_NAME;
		//WebRequestSettings wrs = qwParams.getSoapRequest(namespace, WITH_SERVICE, SERVICE_METHOD);
		return null;
	}
	
	protected String connectAndGetResultString() throws MalformedURLException, IOException {
		String queryString = buildRestUrl();
		BufferedReader reader = readConnection(queryString);
		String line;
		StringBuffer response = new StringBuffer();
		while((line = reader.readLine()) != null) {
			response.append(line);
		}
		reader.close();
		return response.toString();
	}
	
	protected Response call() throws IOException {
		String queryString = buildRestUrl();
		String mimeType = null;
		int responseCode = 0;
		BufferedReader reader = null;
		{
			URL serviceURL = new URL(queryString);
			URLConnection connection = serviceURL.openConnection();
			
			
			if (connection instanceof HttpURLConnection) {
				httpConn = (HttpURLConnection)connection;
				responseCode = httpConn.getResponseCode();
				mimeType = httpConn.getContentType();
				
				try {
					httpConn.connect();
					reader = new BufferedReader(new InputStreamReader(httpConn.getInputStream()));
				}
				catch (IOException ioe) {
					reader = new BufferedReader(new InputStreamReader(httpConn.getErrorStream()));
				}
			}
			
		}
		
		String line;
		StringBuffer response = new StringBuffer();
		while((line = reader.readLine()) != null) {
			response.append(line);
		}
		reader.close();
		
		return new Response(response.toString(), queryString, mimeType, responseCode);
		
	}
	
	protected String buildRestUrl() throws UnsupportedEncodingException {
		// TODO extract this business-specific logic
		return SERVICE_ADDRESS + "/" + SERVICE_NAME + "?" + params.toQueryString();

	}
	
	protected int getLastResponseCode() throws IOException {
		if (httpConn != null) {
			return httpConn.getResponseCode();
		}
		return -1;
	}
}
