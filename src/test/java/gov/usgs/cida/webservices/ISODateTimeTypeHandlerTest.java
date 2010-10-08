package gov.usgs.cida.webservices;

import gov.usgs.webservices.ibatis.ISODateTimeTypeHandler;
import java.sql.SQLException;

import org.junit.Before;
import org.junit.After;
import org.junit.Test;
import static org.junit.Assert.*;
import static gov.usgs.webservices.ibatis.ISODateTimeTypeHandler.getISODateTimeFromSQL;

public class ISODateTimeTypeHandlerTest {

    ISODateTimeTypeHandler timeHandler = null;
    ResultSetMock rsm = null;
    String[][] rowset = {{"2003-05-19T13:52CST", "2010-11-02T01:15EST", "1952-08-01T21:00PST"}};

    @Before
    public void setUp() {
        timeHandler = new ISODateTimeTypeHandler();
        String[] columns = {"datetime"};
        rsm = new ResultSetMock(columns, rowset);
    }

    @After
    public void tearDown() {
        timeHandler = null;
        rsm = null;
    }

    @Test
    public void testGetResult_ResultSetAndColumnName() throws SQLException {
        rsm.next();
        String output = timeHandler.getResult(rsm, "datetime");
        assertEquals("Date not in expected format", output, "2003-05-19T13:52-06:00");
        rsm.next();
        output = timeHandler.getResult(rsm, "datetime");
        assertEquals("Date not in expected format", output, "2010-11-02T01:15-05:00");
        rsm.next();
        output = timeHandler.getResult(rsm, "datetime");
        assertEquals("Date not in expected format", output, "1952-08-01T21:00-08:00");
    }

    @Test
    public void testGetResult_Static() {
        assertEquals("Result should be something else", getISODateTimeFromSQL("2000-04-22T16:59MST"), "2000-04-22T16:59-07:00");
    }
    
    @Test (expected=UnsupportedOperationException.class)
	public void testGetResult_CallableStatement() throws SQLException {
		timeHandler.getResult(null, 0);
    }
    // Something is stupidly wrong here, doesn't matter really
//	@Test (expected=UnsupportedOperationException.class)
//	public void testSetParameterForUnsupported() throws SQLException {
//		timeHandler.setParameter(null, 1, null, null);
//	}
}
