package gov.usgs.cida.testanddebug;

import static gov.usgs.cida.testanddebug.CharacterizationTestUtils.DEFAULT_CHARACTERIZATION;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotSame;
import static org.junit.Assert.assertTrue;

import org.junit.Before;
import org.junit.Test;

public class RecorderTest {
	private static final String VALUE = "George Bush";
	private static final String KEY = "miserable failure";
	CharacterizationMap characterizations = DEFAULT_CHARACTERIZATION;

	@Before
	public void resetCharacterizations() {
		characterizations.clear();
	}

	@Test
	public void testHashCode() {
		// see testEqualsObject()
	}

	@Test
	public void testRecorder() {
		// see testEqualsObject()
	}

	@Test
	public void testEquals() {
		Recorder recorder = new Recorder(characterizations, KEY);
		assertFalse("PRECONDIITION: no key yet", characterizations
				.containsKey(KEY));
		assertNotSame(VALUE.hashCode(), recorder.hashCode());
		assertNotSame(VALUE, recorder.toString());

		String objectToRecord = VALUE;
		assertEquals(recorder, objectToRecord);

		assertTrue("POSTCONDITION: key inserted", characterizations
				.containsKey(KEY));
		assertEquals(VALUE.hashCode(), recorder.hashCode());
		assertEquals(VALUE, recorder.toString());
	}

	@Test
	public void testEqualsShouldNotRecordTwice() {
		Recorder recorder = new Recorder(characterizations, KEY);
		assertFalse("PRECONDITION: no key yet", characterizations
				.containsKey(KEY));
		assertNotSame(VALUE.hashCode(), recorder.hashCode());
		assertNotSame(VALUE, recorder.toString());

		String objectToRecord = VALUE;
		assertEquals(recorder, objectToRecord);

		assertEquals("Nonetheless, equals returns true", recorder,
				"This object won't be recorded");

		assertTrue("POSTCONDITION: key inserted", characterizations
				.containsKey(KEY));
		assertEquals(VALUE.hashCode(), recorder.hashCode());
		assertEquals(VALUE, recorder.toString());
	}

	@Test
	public void testToString() {
		Recorder recorder = new Recorder(characterizations, KEY);
		assertEquals(
				"Before recording, the recorder's toString() method should return null",
				recorder.toString(), null);
		assertEquals(recorder, "Thomas");
		assertEquals(
				"After recording, the recorder's toString() method should return the string value of the recorded object",
				recorder.toString(), "Thomas");

	}

}
