package gov.usgs.webservices.ibatis;

import org.apache.ibatis.type.JdbcType;
import org.apache.ibatis.type.TypeHandler;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.CallableStatement;
import java.sql.PreparedStatement;

public class RemarkCDTypeHandler implements TypeHandler {
    public RemarkCDTypeHandler() {
    }
    @Override
    public String getResult(ResultSet rs, String columnName) throws SQLException {
        String remark_cd = rs.getString(columnName);
        String[] Remarks = remark_cd.split(":");
        String RemarkReturn = "";
        String Temp = "";
        for (int i = 0; i < Remarks.length; i++){
            int index = 0;
            for (int j = 0; j < RemarkCDS.length; j++){
                if (Remarks[i].equals(RemarkCDS[j])) {
                    Temp = RemarkCDTranslation[j];
                    break;
                }
            }

            RemarkReturn = RemarkReturn + Temp + ",";
        }
        RemarkReturn = RemarkReturn.substring(0, (RemarkReturn.length() - 1));


        return RemarkReturn;
    }
    public static final String[] RemarkCDS = {"e","1","C","B","R","&","K","X","<",">","E","F",
    "H","h","l","L","I","i","d","D","T","o","a","s","~","g","c","p","r","f","z","U","@","*","&","2"
    };

    public static final String[] RemarkCDTranslation = {
        "Value has been estimated by USGS personnel.",
        "Value is write protected.",
        "Value is affected by ice at the measurement site",
        "Value is affected by backwater at the measurement site.",
        "Rating is undefined for this value.",
        "Value is affected by unspecified reasons.",
        "Value is affected by instrument calibration drift.",
        "Value is erroneous and will not be used.",
        "Actual value is known to be less than reported value.",
        "Actual value is known to be greater than reported value.",
        "Value was computed from an estimated value.",
        "Value was modified due to automated filtering.",
        "Value exceeds 'very high' threshold.",
        "Value exceeds 'high' threshold.",
        "Value exceeds 'low' threshold.",
        "Value exceeds 'very low' threshold.",
        "Value exceeds 'very rapid increase' threshold.",
        "Value exceeds 'rapid increase' threshold.",
        "Value exceeds 'rapid decrease' threshold.",
        "Value exceeds 'very rapid decrease' threshold.",
        "Value exceeds 'standard difference' threshold.",
        "Value was observed in the field.",
        "Value is from paper tape.",
        "Value is from a DCP.",
        "Value is a system interpolated value.",
        "Value recorded by data logger.",
        "Value recorded on strip chart.",
        "Value received by telephone transmission.",
        "Value received by radio transmission.",
        "Value received by machine readable file.",
        "Value received from backup recorder.",
        "Value was not used in the computation of a daily value.",
        "Value was reviewed by USGS personnel.",
        "Value was edited by USGS personnel.",
        "Value was computed from affected unit values by unspecified reasons.",
        "Remark is suppressed and will not print on a publication daily values table."
    };

    @Override
    public Object getResult(CallableStatement cs, int columnIndex) throws SQLException {
        throw new UnsupportedOperationException();
    }

    @Override
    public void setParameter(PreparedStatement ps, int parameterIndex, Object parameter, JdbcType jdbcType) throws SQLException {
        throw new UnsupportedOperationException();
    }
}
