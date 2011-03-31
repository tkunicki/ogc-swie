package gov.usgs.cida.ogc;

public enum Interval {

            LATEST("1"),
            LATESTDAY("2"),
            LATESTWEEK("3");

            final String code;

            Interval(String code) {
                this.code = code;
        }
    }