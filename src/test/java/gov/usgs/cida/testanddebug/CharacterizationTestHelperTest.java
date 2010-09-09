package gov.usgs.cida.testanddebug;


import static junit.framework.Assert.assertEquals;
import static junit.framework.Assert.assertNotNull;
import static junit.framework.Assert.assertTrue;

import java.io.File;

import org.junit.Test;


public class CharacterizationTestHelperTest extends CharacterizationTestHelper{


	@Test
	public void testPropertiesFileLocation() {
		assertEquals(characterization("testValue1"), "Spiderman");

		String relativePath = CharacterizationTestUtils.convertClassToPropertiesPath(this.getClass());
		File testValuePropertiesFile = new File(CharacterizationTestUtils.BASE_DIRECTORY, relativePath);
		assertNotNull(testValuePropertiesFile);
		assertTrue(testValuePropertiesFile.exists());
	}

	@Test
	public void testCharacterizationMapSaveModes() {
		// TODO
	}

}
