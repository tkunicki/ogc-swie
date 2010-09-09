package gov.usgs.cida.testanddebug;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import org.junit.Test;

public class ComparerTest {

	private static final String COMPARED_OBJECT = "Fred Flinstone";

	@Test
	public void testComparer() {
		Comparer comparer = new Comparer(COMPARED_OBJECT);

		assertEquals(comparer, COMPARED_OBJECT);
	}

	@Test
	public void testCompare() {
		Comparer comparer = new Comparer(COMPARED_OBJECT);
		assertTrue(comparer.compare(COMPARED_OBJECT));
	}

	@Test
	public void testToString() {
		Comparer comparer = new Comparer(COMPARED_OBJECT);
		assertEquals(
				"The comparer's toString() method should return the string value of the compared object",
				comparer.toString(), COMPARED_OBJECT);
	}

	@Test
	public void testSerializeFormat() {
		Comparer comparer = new Comparer(COMPARED_OBJECT);
		assertEquals("{objValue:Fred Flinstone,\n" +
				"objClass:java.lang.String,\n" +
				"objHashCode:-2030313627}", comparer.serialize());
	}

	@Test
	public void testSerializeDeserializeRoundTrip() throws ClassNotFoundException {
		Comparer comparer = new Comparer(COMPARED_OBJECT);

		Comparer reconstitutedComparer = Comparer.deserialize(comparer.serialize());

		assertEquals(comparer.toString(), reconstitutedComparer.toString());
		assertEquals(comparer.hashCode(), reconstitutedComparer.hashCode());
		assertEquals(reconstitutedComparer, COMPARED_OBJECT);
		assertTrue(reconstitutedComparer.compare(COMPARED_OBJECT));
	}

}
