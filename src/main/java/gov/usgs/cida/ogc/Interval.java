package gov.usgs.cida.ogc;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

public enum Interval {
            LATEST,
            TODAY,
            TOMORROW;


    }




//public enum Interval {
//
//    LATEST("1") {
//        public String getFormattedSQLString() {
//            return null;
//        }
//    },
//    TODAY("2") {
//        public String getFormattedSQLString() {
//            Date now = new Date();
//            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
//            String todayFormated = formatter.format(now);
//            String Today = todayFormated;
//            return Today;
//        }
//    },
//
//    LATESTWEEK("3") {
//        public String getFormattedSQLString() {
//            Calendar lastWeek = new GregorianCalendar();
//            lastWeek.add(Calendar.DAY_OF_YEAR, -7);
//            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
//            String lastWeekFormated = formatter.format(lastWeek.getTime());
//            String LastWeek = lastWeekFormated;
//            return LastWeek;
//        }
//    };
//    final String code;
//
//    Interval(String code) {
//        this.code = code;
//    }
//
//    public abstract String getFormattedSQLString();
//}
//public enum Interval {
//    LATEST,
//    TODAY,
//    LASTWEEK;
//}
//
//public class Interval {
//
//        Interval (){
//            this.code = code;
//        }
//    }
//}
