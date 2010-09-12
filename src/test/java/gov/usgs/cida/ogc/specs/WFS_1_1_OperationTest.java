package gov.usgs.cida.ogc.specs;

import org.junit.Test;


public class WFS_1_1_OperationTest {
	
	@Test(expected= NullPointerException.class)
	public void enumValueOfUnableToParseNull() {
		WFS_1_1_Operation op = WFS_1_1_Operation.valueOf(null);
		// This test shows why a special parse() operation is needed
	}
}
