package gov.usgs.webservices.ibatis;

import org.apache.ibatis.type.JdbcType;
import org.apache.ibatis.type.TypeHandler;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.CallableStatement;
import java.sql.PreparedStatement;

/**
 *
 * @author lkranendonk
 */
public class USGS_URL_TypeHandler implements TypeHandler {

    public USGS_URL_TypeHandler() {
    }

    @Override
    public String getResult(ResultSet rs, String columnName) throws SQLException {
        String state_cd = rs.getString(columnName);
        return getURLFromSQL(state_cd);
    }

    public static String getURLFromSQL(String state_cd) {

        String[] state_nm = {"AL","AK","AS","AZ", "AR", "CA", "XX", "CO", "CT", "DE", "DC", "FL", "GA", "GU",
            "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO",
            "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "PR", "RI",
            "SC", "SD", "TN", "TX", "UT", "VT", "VA", "VI", "WA", "WV", "WI", "WY", "PR", "VI" };

        String delims = "[.]";
        String[] state_site = state_cd.split(delims);
        String state = state_site[0];
        String site = state_site[1];
        int i = Integer.parseInt(state.trim())-1;
        String postal_nm = state_nm[i];
        String url = "http://waterdata.usgs.gov/".concat(postal_nm).concat("/nwis/uv/?site_no=").concat(site);
        return url;
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



