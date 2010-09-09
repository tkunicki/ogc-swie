package gov.usgs.ogc.test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import java.io.IOException;

import org.junit.After;
import org.junit.Assume;
import org.junit.Before;
import org.junit.Test;


public class OGCServicesCharacterizationTest extends HttpTestHelper{
	
	private static final String SOS = "sosbbox";
	private static final String GWML_WATER_WELL = "gwml:WaterWell";
	private static final String XML_MIMETYPE = "text/xml";
	private static final String WFS = "wfs";

	@Before
	public void setUpTests() {
		params = new OgcParams();
		
	}
	
	@After
	public void tearDownTests() {
		params = null;
	}
	
	@Test
	public void testWfsGetCapabiliities() throws IOException {
		SERVICE_NAME = WFS;
		params.request = "GetCapabilities";
		
		
		Response response = call();
//		System.out.println(response.toString());
		assertEquals(Integer.valueOf(200), response.responseCode);
		assertTrue(response.mimeType.contains(XML_MIMETYPE));
		
		// Add host into the key so we can store and compare responses against different hosts
		assertEquals(characterization("WFS#GetCap.url#" + HOST), response.url);
		assertEquals(characterization("WFS#GetCap.content#" + HOST), response.content);
	}
	
	@Test
	public void testWfsDescribeFeatureType() throws IOException {
		SERVICE_NAME = WFS;
		params.request = "DescribeFeatureType";
		
		Response response = call();
		assertEquals(Integer.valueOf(200), response.responseCode);
		assertTrue(response.mimeType.contains(XML_MIMETYPE));
		
		// Add host into the key so we can store and compare responses against different hosts
		assertEquals(characterization("WFS#DescFeature.url#" + HOST), response.url);
		System.out.println(response.content);
		assertEquals(characterization("WFS#DescFeature.content#" + HOST), response.content);
	}
	
	@Test
	public void testWfsGetFeature_byBoundingBox() throws IOException {
		SERVICE_NAME = WFS;
		params.request = "GetFeature";
		params.bBox = "-89.7,42.8,-89.2,43.3";
		params.typeName = GWML_WATER_WELL;
		
		Response response = call();
		assertEquals(Integer.valueOf(200), response.responseCode);
		assertTrue(response.mimeType.contains(XML_MIMETYPE));
		
		// Add host into the key so we can store and compare responses against different hosts
		assertEquals(characterization("WFS#GetFeature_bbox.url#" + HOST), response.url);
		assertEquals(characterization("WFS#GetFeature_bbox.content#" + HOST), response.content);
	}
	
	@Test
	public void testWfsGetFeature_byFeatureId() throws IOException {
		SERVICE_NAME = WFS;
		params.request = "GetFeature";
		params.featureId = "USGS.435629089353901";
		params.typeName = GWML_WATER_WELL;
		
		Response response = call();
		assertEquals(Integer.valueOf(200), response.responseCode);
		assertTrue(response.mimeType.contains(XML_MIMETYPE));
		
		// Add host into the key so we can store and compare responses against different hosts
		assertEquals(characterization("WFS#GetFeature_fId.url#" + HOST), response.url);
		assertEquals(characterization("WFS#GetFeature_fId.content#" + HOST), response.content);
	}

	@Test
	public void testSosGetCapabilities() throws IOException {
		SERVICE_NAME = SOS;
		params.request = "GetCapabilities";
		
		Response response = call();
		System.out.println(response);
		assertEquals(Integer.valueOf(200), response.responseCode);
		assertTrue(response.mimeType.contains(XML_MIMETYPE));
		
		// Add host into the key so we can store and compare responses against different hosts
		assertEquals(characterization("SOS#GetCapabilities.url#" + HOST), response.url);
		assertEquals(characterization("SOS#GetCapabilities#" + HOST), response.content);
	}
	
	@Test
	public void testSosGetObservations_byExtents() throws IOException {
		SERVICE_NAME = SOS;
		params.request = "GetObservation";
		params.north = "43";
		params.south = "42.9";
		params.east = "-89.57";
		params.west = "-89.65";
		
		Response response = call();
		assertEquals(Integer.valueOf(200), response.responseCode);
		assertTrue(response.mimeType.contains(XML_MIMETYPE));
		
		// Add host into the key so we can store and compare responses against different hosts
		assertEquals(characterization("SOS#GetObservations_extents.url#" + HOST), response.url);
		assertEquals(characterization("SOS#GetObservations_extents#" + HOST), response.content);
	}

	
}