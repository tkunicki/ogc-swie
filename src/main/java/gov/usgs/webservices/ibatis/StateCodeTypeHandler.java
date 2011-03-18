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
public class StateCodeTypeHandler implements TypeHandler {

    public StateCodeTypeHandler() {
    }

    @Override
    public String getResult(ResultSet rs, String columnName) throws SQLException {
        String state_cd = rs.getString(columnName);
        return getPostalNameFromSQL(state_cd);
    }

    public static final String[] POSTAL_NAME = {"AL","AK","AS","AZ", "AR", "CA", "XX", "CO", "CT", "DE", "DC", "FL", "GA", "GU",
            "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO",
            "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "PR", "RI",
            "SC", "SD", "TN", "TX", "UT", "VT", "VA", "VI", "WA", "WV", "WI", "WY", "PR", "VI" };

    // public protected [package=default] private
    public static final String[] STATE_NAME = {"Alabama","Alaska","AS","Arizona", "Arkansas", "California", "XX", "Colorado", "Connecticut",
            "Delaware", "Washington, D.C.", "Flordia", "Georgia", "Guam","Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas",
            "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri",
            "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota",
            "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Puerto Rico", "Rhode Island","South Carolina", "South Dakota", "Tennessee",
            "Texas", "Utah", "Vermont", "Virginia", "Virgin Islands", "Washington", "West Virginia", "Wisconsin", "Wyoming", "Puerto Rico", "Virgin Islands" };

    public static String getPostalNameFromSQL(String state_cd) {
       int i = Integer.parseInt(state_cd.trim())-1;

        return POSTAL_NAME[i];
    }

    public static String getStateNameFromSQL(String state_cd) {
       int i = Integer.parseInt(state_cd.trim())-1;

        return STATE_NAME[i];

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



