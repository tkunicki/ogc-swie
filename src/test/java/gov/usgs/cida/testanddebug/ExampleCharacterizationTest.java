package gov.usgs.cida.testanddebug;

import static junit.framework.Assert.assertEquals;

import org.junit.Test;


public class ExampleCharacterizationTest extends CharacterizationTestHelper {
	@Test
	public void testSomeMethod() {
		String[] testValues= {"John", "Paul", "George", "Ringo", "PeteBest"};

		for (int i=0; i<testValues.length; i++) {
			assertEquals(characterization(i), makeFakeHTTPResponse("&band=Beatles&name=" + testValues[i]));
		}
		
		//assertEquals(characterization("Tom"), makeFakeHTTPResponse("&band=Beatles&name=" + "Kunicki"));
	}

	public String makeFakeHTTPResponse(String queryString) {
		String[] pairs = queryString.split("&");
		String name=null;
		for (String nameValuePair: pairs) {
			if (nameValuePair.startsWith("name")) {
				name = nameValuePair.substring(4);
			}
		}
		return "Hello, " + name + "!";
		//		for (int i=0; i<testValues.length; i++) {
		//		assertEquals(characterization(i), makeFakeHTTPResponse("&band=Beatles&name=" + testValues[i]));
		//	}
	}
}
