package gov.usgs.cida.ogc;

public enum ObservedProperties {

    DISCHARGE("00060"),
    GAGEHEIGHT("00065"),
    TEMPERATURE("00010"),
    PRECIPITATION("00045"),
    TURBIDITY("63680"),
    DO("00300"),
    PH("00400");

    final String code;

    ObservedProperties(String code) {
        this.code = code;
    }
}


