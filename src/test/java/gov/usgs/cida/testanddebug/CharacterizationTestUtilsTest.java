package gov.usgs.cida.testanddebug;

import static gov.usgs.cida.testanddebug.CharacterizationTestUtils.DEFAULT_CHARACTERIZATION;
import static gov.usgs.cida.testanddebug.CharacterizationTestUtils.characterization;
import static gov.usgs.cida.testanddebug.CharacterizationTestUtils.characterize;
import static gov.usgs.cida.testanddebug.CharacterizationTestUtils.defaultFileSuffix;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNotSame;
import static org.junit.Assert.assertSame;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import java.util.Map;

import org.junit.Before;
import org.junit.Test;

public class CharacterizationTestUtilsTest {
	Map<String, Comparer> characterizations = DEFAULT_CHARACTERIZATION;

	@Before
	public void resetCharacterizations(){
		characterizations.clear();
	}

	@Test
	public void testBaseDirectoryConfiguration() {
		assertNotNull("If this is null, then the configuration of "
				+ CharacterizationTestUtils.class.getSimpleName()
				+ " is not correct", CharacterizationTestUtils.BASE_DIRECTORY);
		assertTrue(CharacterizationTestUtils.BASE_DIRECTORY.exists());
	}

	@Test
	public void testCharacterizeMapOfStringComparerObjectObject() {
		//fail("Not yet implemented");
	}

	@Test
	public void testCharacterize() {
		characterize("aKey", "carol");
		assertEquals(characterization("aKey"), "carol");
	}

	@Test(expected=AssertionError.class)
	public void testCharacterize_doesNotMatchWrongCharacterization() {
		characterize("aKey", "carol");
		assertEquals(characterization("aKey"), "ted");
	}

	@Test
	public void testCharacterizationMapOfStringComparerObject() {
		//fail("Not yet implemented");
	}

	@Test
	public void testCharacterization() {
		String key = "bob";

		assertEquals("The first invocation of characterization records", characterization(key), "carol");
		assertNotSame("The subsequent invocations compare", characterization(key), "ted");
		assertEquals("The subsequent invocations compare", characterization(key), "carol");
	}

	@Test
	public void testCharacterization_CannotBeUsedWith_assertSame() {
		String key = "bob";
		try {
			assertSame("The first invocation of characterization records", characterization(key), "carol");
			fail("Shouldn't get here, expect to fail");
		} catch (AssertionError e) {
			// characterization methods can only be used with assertEquals(), not assertSame()
		}
		assertNotSame("The subsequent invocations compare", characterization(key), "ted");
		try {
			assertSame("The subsequent invocations compare", characterization(key), "carol");
			fail("Shouldn't get here, expect to fail");
		} catch (AssertionError e) {
			// characterization methods can only be used with assertEquals(), not assertSame()
		}
	}

	@Test
	public void testConvertClassToPath() {
		String result = CharacterizationTestUtils.convertClassToPath(CharacterizationTestUtilsTest.class);
		assertTrue("One of these strings will match, depending on OS platform",
				result.endsWith("gov/usgs/cida/testanddebug/CharacterizationTestUtilsTest")
				|| result.endsWith("gov\\usgs\\cida\\testanddebug\\CharacterizationTestUtilsTest")
				);
	}

	@Test
	public void testConvertClassToPropertiesPath() {
		String result = CharacterizationTestUtils.convertClassToPropertiesPath(CharacterizationTestUtilsTest.class);
		assertTrue("One of these strings will match, depending on OS platform",
				result.endsWith("gov/usgs/cida/testanddebug/CharacterizationTestUtilsTest." + defaultFileSuffix)
				|| result.endsWith("gov\\usgs\\cida\\testanddebug\\CharacterizationTestUtilsTest." + defaultFileSuffix)
				);
	}

}
