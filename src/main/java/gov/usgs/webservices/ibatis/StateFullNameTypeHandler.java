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
public class StateFullNameTypeHandler implements TypeHandler {

    public StateFullNameTypeHandler() {
    }

    @Override
    public String getResult(ResultSet rs, String columnName) throws SQLException {
        String state_cd = rs.getString(columnName);
        return getFullStateNameFromSQL(state_cd);
    }

    public static String getFullStateNameFromSQL(String state_cd) {

    
        String[] state_name = {"Alabama","Alaska","AS","Arizona", "Arkansas", "California", "XX", "Colorado", "Connecticut",
            "Delaware", "Washington, D.C.", "Flordia", "Georgia", "Guam","Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas",
            "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri",
            "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota",
            "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Puerto Rico", "Rhode Island","South Carolina", "South Dakota", "Tennessee",
            "Texas", "Utah", "Vermont", "Virginia", "Virgin Islands", "Washington", "West Virginia", "Wisconsin", "Wyoming", "Puerto Rico", "Virgin Islands" };

        int i = Integer.parseInt(state_cd.trim())-1;

        String Full_state_name = state_name[i];

        return Full_state_name;

        
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



