package gov.usgs.cida.ogc;

public enum Offerings {

    MAXIMUM("00001"),
    MINIMUM("00002"),
    MEAN("00003"),
    SUM("00006"),
    MODE("00007"),
    MEDIAN("00008"),
    STD("00009"),
    VARIANCE("00010"),
    UNIT("00000");

    final String code;

    Offerings(String code) {
        this.code = code;
    }
}