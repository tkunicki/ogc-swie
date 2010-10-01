package gov.usgs.webservices.ibatis;

import org.apache.ibatis.type.JdbcType;
import org.apache.ibatis.type.TypeHandler;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;

import java.util.TimeZone;

// This class should be in the webservice-ibatis module, but there's some
// Oracle *and* tomcat specific stuff in here, need to wait for Tomcat7 
// and it's DBCP 1.4 implementation of JDBC 4.0 for to remove need for
// vendor specific code.
public class DateTimeTypeHandler implements TypeHandler {
	
	public DateTimeTypeHandler() {

	}
	
	@Override
	public Object getResult(ResultSet rs, String columnName) throws SQLException {
		String dateString = rs.getString(columnName);
		String dateTime = dateString.substring(0, 16);
		int tzOffset = TimeZone.getTimeZone(dateString.substring(16)).getRawOffset();
		String plusOrMinus = (tzOffset >= 0) ? "+" : "-";
		float hoursOffset = Math.abs(tzOffset / 1000 / 60 / 60);
		int hours = (int)hoursOffset;
		int minutes = (int)(60 * (hoursOffset - hours));  
		return String.format("%s%s%02d:%02d", dateTime, plusOrMinus, hours, minutes);
	}

	@Override
	public Object getResult(CallableStatement cs, int columnIndex) throws SQLException {
		throw new UnsupportedOperationException();
	}

	@Override
	public void setParameter(PreparedStatement ps, int parameterIndex, Object parameter, JdbcType jdbcType) throws SQLException {
		throw new UnsupportedOperationException();
	}

}
