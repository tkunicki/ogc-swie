package gov.usgs.cida.ogc.test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
import gov.usgs.cida.ogc.test.OgcParams.ParamEnum;

import java.io.IOException;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;


public class OGCServicesCharacterizationTest extends HttpTestHelper{
	
	private static final String SOS = "sosbbox";
	private static final String GWML_WATER_WELL = "gwml:WaterWell";
	private static final String XML_MIMETYPE = "text/xml";
	private static final String WFS = "wfs";
	private static final String WMS = "wms";

	@Before
	public void setUpTests() {
		//params = new OgcParams();
		
	}
	
	@After
	public void tearDownTests() {
		//params = null;
	}
	
	@Test
	public void testWMSGetCapabiities() throws IOException {
		SERVICE_ADDRESS = MAPVIEWER_SERVICE_ADDRESS;
		SERVICE_NAME = WMS;
		
		OgcParams params = new OgcParams();
		params.put(ParamEnum.SERVICE, "WMS");
		params.put(ParamEnum.VERSION, "1.1.1");
		params.put(ParamEnum.REQUEST, "GetCapabilities");
		
		Response response = call(params);
		assertEquals(Integer.valueOf(200), response.responseCode);
		assertTrue(response.mimeType.contains(XML_MIMETYPE));
		assertTrue(!response.content.equals(""));
		
		//"?REQUEST=GetMap&VERSION=1.1.1&FORMAT=image/gif&SERVICE=WMS&BBOX=-90,43,-89,44&SRS=EPSG:4326&LAYERS=GW_SITES&WIDTH=580&HEIGHT=500"
		// Add host into the key so we can store and compare responses against different hosts
		assertEquals(characterization("WMS#GetCap.url#" + HOST), response.url);
		assertEquals(characterization("WMS#GetCap.content#" + HOST), response.content);
	}
	
	@Test
	public void testWMSGetMap() throws IOException {
		SERVICE_ADDRESS = MAPVIEWER_SERVICE_ADDRESS;
		SERVICE_NAME = WMS;
		
		OgcParams params = new OgcParams();
		params.put(ParamEnum.SERVICE, "WMS");
		params.put(ParamEnum.VERSION, "1.1.1");
		params.put(ParamEnum.REQUEST, "GETMAP");
		params.put(ParamEnum.FORMAT, "IMAGE/GIF");
		params.put(ParamEnum.BBOX, "-90,43,-89,44");
		params.put(ParamEnum.SRS, "EPSG:4326");
		params.put(ParamEnum.LAYERS, "GW_SITES");
		params.put(ParamEnum.WIDTH, "580");
		params.put(ParamEnum.HEIGHT, "500");
		
		Response response = call(params);
		assertEquals(Integer.valueOf(200), response.responseCode);
		assertTrue(response.mimeType.equals("image/gif"));
	}
	
	@Test
	public void testWfsGetCapabiliities() throws IOException {
		SERVICE_ADDRESS = LOCAL_SERVICE_ADDRESS;
		SERVICE_NAME = WFS;
		
		OgcParams params = new OgcParams();
		params.put(ParamEnum.REQUEST, "GetCapabilities");
		
		Response response = call(params);
//		System.out.println(response.toString());
		assertEquals(Integer.valueOf(200), response.responseCode);
		assertTrue(response.mimeType.contains(XML_MIMETYPE));
		assertTrue(!response.content.equals(""));
		
		// Add host into the key so we can store and compare responses against different hosts
		assertEquals(characterization("WFS#GetCap.url#" + HOST), response.url);
		assertEquals(characterization("WFS#GetCap.content#" + HOST), response.content);
	}
	
	@Test
	public void testWfsDescribeFeatureType() throws IOException {
		SERVICE_ADDRESS = LOCAL_SERVICE_ADDRESS;
		SERVICE_NAME = WFS;
		
		OgcParams params = new OgcParams();
		params.put(ParamEnum.REQUEST, "DESCRIBEFEATURETYPE");
		params.put(ParamEnum.TYPENAME, GWML_WATER_WELL);
		
		Response response = call(params);
		assertEquals(Integer.valueOf(200), response.responseCode);
		assertTrue(response.mimeType.contains(XML_MIMETYPE));
		assertTrue(!response.content.equals(""));
		
		// Add host into the key so we can store and compare responses against different hosts
		assertEquals(characterization("WFS#DescFeature.url#" + HOST), response.url);
		assertEquals(characterization("WFS#DescFeature.content#" + HOST), response.content);
	}
	
	@Test
	public void testWfsGetFeature_byBoundingBox() throws IOException {
		SERVICE_ADDRESS = LOCAL_SERVICE_ADDRESS;
		SERVICE_NAME = WFS;
		
		OgcParams params = new OgcParams();
		params.put(ParamEnum.REQUEST, "GETFEATURE");
		params.put(ParamEnum.BBOX, "-89.7,42.8,-89.2,43.3");
		params.put(ParamEnum.TYPENAME, GWML_WATER_WELL);
		
		Response response = call(params);
		assertEquals(Integer.valueOf(200), response.responseCode);
		assertTrue(response.mimeType.contains(XML_MIMETYPE));
		assertTrue(!response.content.equals(""));
		
		// Add host into the key so we can store and compare responses against different hosts
		assertEquals(characterization("WFS#GetFeature_bbox.url#" + HOST), response.url);
		assertEquals(characterization("WFS#GetFeature_bbox.content#" + HOST), response.content);
	}
	
	@Test
	public void testWfsGetFeature_byFeatureId() throws IOException {
		SERVICE_ADDRESS = LOCAL_SERVICE_ADDRESS;
		SERVICE_NAME = WFS;
		
		OgcParams params = new OgcParams();
		params.put(ParamEnum.REQUEST, "GETFEATURE");
		params.put(ParamEnum.FEATUREID, "USGS.425856089320601");
		params.put(ParamEnum.TYPENAME, GWML_WATER_WELL);
		
		Response response = call(params);
		assertEquals(Integer.valueOf(200), response.responseCode);
		assertTrue(response.mimeType.contains(XML_MIMETYPE));
		assertTrue(!response.content.equals(""));
		
		// Add host into the key so we can store and compare responses against different hosts
		assertEquals(characterization("WFS#GetFeature_fId.url#" + HOST), response.url);
		assertEquals(characterization("WFS#GetFeature_fId.content#" + HOST), response.content);
	}

	@Test
	public void testSosGetCapabilities() throws IOException {
		SERVICE_ADDRESS = LOCAL_SERVICE_ADDRESS;
		SERVICE_NAME = SOS;
		
		OgcParams params = new OgcParams();
		params.put(ParamEnum.REQUEST, "GETCAPABILITIES");
		
		Response response = call(params);
		System.out.println(response);
		assertEquals(Integer.valueOf(200), response.responseCode);
		assertTrue(response.mimeType.contains(XML_MIMETYPE));
		assertTrue(!response.content.equals(""));
		
		// Add host into the key so we can store and compare responses against different hosts
		assertEquals(characterization("SOS#GetCapabilities.url#" + HOST), response.url);
		assertEquals(characterization("SOS#GetCapabilities.content#" + HOST), response.content);
	}
	
	@Test
	public void testSosGetObservations_byExtents() throws IOException {
		SERVICE_ADDRESS = LOCAL_SERVICE_ADDRESS;
		SERVICE_NAME = SOS;
		
		OgcParams params = new OgcParams();
		params.put(ParamEnum.REQUEST, "GETOBSERVATION");
		params.put(ParamEnum.NORTH, "43");
		params.put(ParamEnum.SOUTH, "42.9");
		params.put(ParamEnum.EAST, "-89.57");
		params.put(ParamEnum.WEST, "-89.65");
		
		Response response = call(params);
		assertEquals(Integer.valueOf(200), response.responseCode);
		assertTrue(response.mimeType.contains(XML_MIMETYPE));
		assertTrue(!response.content.equals(""));
		
		// Add host into the key so we can store and compare responses against different hosts
		assertEquals(characterization("SOS#GetObservations_extents.url#" + HOST), response.url);
		assertEquals(characterization("SOS#GetObservations_extents.content#" + HOST), response.content);
	}
	
	@Test
	public void testSosGetObservations_byFeatureId() throws IOException {
		SERVICE_ADDRESS = LOCAL_SERVICE_ADDRESS;
		SERVICE_NAME = SOS;
		
		OgcParams params = new OgcParams();
		params.put(ParamEnum.REQUEST, "GETOBSERVATION");
		params.put(ParamEnum.FEATUREID, "USGS.425856089320601");
		
		Response response = call(params);
		assertEquals(Integer.valueOf(200), response.responseCode);
		assertTrue(response.mimeType.contains(XML_MIMETYPE));
		assertTrue(!response.content.equals(""));
		
		// Add host into the key so we can store and compare responses against different hosts
		assertEquals(characterization("SOS#GetObservations_fid.url#" + HOST), response.url);
		assertEquals(characterization("SOS#GetObservations_fid.content#" + HOST), response.content);
	}

	
}
