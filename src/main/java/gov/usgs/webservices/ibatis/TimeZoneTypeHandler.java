package gov.usgs.webservices.ibatis;

import org.apache.ibatis.type.JdbcType;
import org.apache.ibatis.type.TypeHandler;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.CallableStatement;
import java.sql.PreparedStatement;

import java.util.TimeZone;


public class TimeZoneTypeHandler implements TypeHandler{

    public TimeZoneTypeHandler() {
    }

    /**
     * ISO 8601 iso-date-time
     * http://tools.ietf.org/html/rfc3339
     *
     * Timestamp as input must be 16 characters with Timezone appended
     * i.e. YYYY-MM-DDTHH:mmTZ
     *
     * Output is similar, but with TZ replaced with offset from UTC
     * i.e.	YYYY-MM-DDTHH:mm[+/-]HH:mm
     *
     * To generalize this, regular expressions can be employed to capture
     * different possible inputs
     */
    @Override
    public String getResult(ResultSet rs, String columnName) throws SQLException {
        String dateString = rs.getString(columnName);
        return getISOTimeZoneFromSQL(dateString);
    }

    public static String getISOTimeZoneFromSQL(String dateString) {
        String dateTime = dateString.substring(0, 16);
        int tzOffset = TimeZone.getTimeZone(dateString.substring(16)).getRawOffset();
        String plusOrMinus = (tzOffset >= 0) ? "+" : "-";
        float hoursOffset = Math.abs(tzOffset / 1000 / 60 / 60);
        int hours = (int) hoursOffset;
        int minutes = (int) (60 * (hoursOffset - hours));
        return String.format("%s%02d:%02d", plusOrMinus, hours, minutes);
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
