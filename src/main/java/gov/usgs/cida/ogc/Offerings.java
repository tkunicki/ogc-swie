package gov.usgs.cida.ogc;

public enum Offerings {

            MAXIMUM("00001"),
            MINIMUM("00002"),
            MEAN("00003"),
            SUM("00006"),
            MODE("00007"),
            MEDIAN("00008"),
            STD("00009"),
            VARIANCE("00010");
//            HIGHTIDE("00021"),
//            LOWTIDE("00024"),
//            TIDAL_LOW_HIGH("00022"),
//            TIDAL_HIGH_LOW("00023");

            final String code;

            Offerings(String code) {
                this.code = code;
        }
    }