package gov.usgs.cida.utils.collections;


import junit.framework.TestCase;

import org.junit.Before;
import org.junit.Test;

/**
 * @author ilinkuo
 *
 *	TODO Fill in these stubs
 */
public class CaseInsensitiveMapTest extends TestCase {
	CaseInsensitiveMap<String> ciStringMap;
	
	@Before
	public void setup() {
		
	}
	
	@Test
	public void testCIMap_CaseInsensitivityLookup() {
		ciStringMap = new CaseInsensitiveMap<String>();
		String MISERABLE_FAILURE = "miserable failure";
		ciStringMap.put("George Bush", MISERABLE_FAILURE);
		
		assertEquals(1, ciStringMap.size());
		
		assertEquals(MISERABLE_FAILURE, ciStringMap.get("George Bush"));
		assertEquals(MISERABLE_FAILURE, ciStringMap.get("george bush"));
		assertEquals(MISERABLE_FAILURE, ciStringMap.get("geOrGe BuSh"));
		
	}
	
	
	
}
