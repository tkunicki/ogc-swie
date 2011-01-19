package gov.usgs.webservices.ibatis;

import org.apache.ibatis.type.JdbcType;
import org.apache.ibatis.type.TypeHandler;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.util.TimeZone;
/**
 *
 * @author lkranendonk
 */
public class StateCodeTypeHandler implements TypeHandler {

    public StateCodeTypeHandler() {
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
        String state_cd = rs.getString(columnName);
        return getPostalCodeFromSQL(state_cd);
    }

    public static String getPostalCodeFromSQL(String state_cd) {

        String[] state_nm = {"AL","AK","AS","AZ", "AR", "CA", "XX", "CO", "CT", "DE", "DC", "FL", "GA", "GU",
            "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO",
            "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "PR", "RI",
            "SC", "SD", "TN", "TX", "UT", "VT", "VA", "VI", "WA", "WV", "WI", "WY", "PR", "VI" };

        int i = Integer.parseInt(state_cd.trim());
        String postal_nm = state_nm[i];
        //String dateTime = dateString.substring(0, 16);
        //int tzOffset = TimeZone.getTimeZone(dateString.substring(16)).getRawOffset();
        //String plusOrMinus = (tzOffset >= 0) ? "+" : "-";
        //float hoursOffset = Math.abs(tzOffset / 1000 / 60 / 60);
        //int hours = (int) hoursOffset;
        //int minutes = (int) (60 * (hoursOffset - hours));
        //return String.format("%s%s%02d:%02d", dateTime, plusOrMinus, hours, minutes);
        return postal_nm;
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



