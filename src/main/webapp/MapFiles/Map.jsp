<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@ page  language="java" import="java.util.*,java.text.*"%>

<%

    String baseURL = request.getRequestURL().toString().replaceAll("/[^/]*$", "");
    String base_url =  baseURL.substring(0,baseURL.length() - 8);
    Calendar lastWeek = new GregorianCalendar();
    lastWeek.add(Calendar.DAY_OF_YEAR, -7);

    Date now = new Date();

    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

    String todayFormated = formatter.format(now);
    String lastWeekFormated = formatter.format(lastWeek.getTime());

    String Today = todayFormated;
    String LastWeek = lastWeekFormated;

    String dataSetString = request.getParameter("dataSet");
    String GetFeatureXML = request.getParameter("xml");
    String GetDataAvailabilityXML = request.getParameter("GDAxml");
    String observedProperty = request.getParameter("observedProperty");
    String offering = request.getParameter("offering");
    String UpLat = request.getParameter("UpperLat");
    String UpLong = request.getParameter("UpperLong");
    String LowLat = request.getParameter("LowerLat");
    String LowLong = request.getParameter("LowerLong");
    String Tab = "0";
    String[] Properties = new String[8];
    Properties[0] = "selected";
    String[] Offerings = new String[9];
    Offerings[0] = "selected";
    String[] Selected = new String[40];
    String Lat;
    String Long;
    String XML_Call = base_url;
    String Sites = base_url + "wfs?request=GetFeature&featureId=";
    Integer Scale;
    String textbox = "01446500,05082500";
    String UpperLat = "44.0";
    String UpperLong = "-89.0";
    String LowerLat = "43.0";
    String LowerLong = "-90.0";
    String xmlbox = "";

    if (GetFeatureXML != null){
        GetFeatureXML = GetFeatureXML.replaceAll("\\s+", " ");
        }
    if ( GetDataAvailabilityXML != null){
         GetDataAvailabilityXML =  GetDataAvailabilityXML.replaceAll("\\s+", " ");
        }

    String[] CommaList = request.getParameterValues("CommaList");
    String get = "True";
    String GDA = "False";

    int dataSet;
    if (dataSetString != null) {
        // Got to figure out enums....
            if (dataSetString.equalsIgnoreCase("SWIE")) {
                dataSet = 1;
            } else if (dataSetString.equalsIgnoreCase("WDM")) {
                dataSet = 2;
            } else if (dataSetString.equalsIgnoreCase("WI")) {
                dataSet = 3;
            } else if (dataSetString.equalsIgnoreCase("SE")) {
                dataSet = 4;
            } else if (dataSetString.equalsIgnoreCase("UserList")) {
                dataSet = 5;
            } else if (dataSetString.equalsIgnoreCase("WFS")) {
                dataSet = 6;
            } else if (dataSetString.equalsIgnoreCase("GDA")) {
                dataSet = 7;
            } else if (dataSetString.equalsIgnoreCase("GL")) {
                dataSet = 8;
            } else if (dataSetString.equalsIgnoreCase("OH_Black")) {
                dataSet = 11;
            } else if (dataSetString.equalsIgnoreCase("NY_Buffalo")) {
                Sites = XML_Call + "wfs";
                UpLat = "42.881562";
                LowLat = "42.850633";
                LowLong = "-78.890824";
                UpLong = "-78.809176";
                Selected[6] = "selected";
                dataSet = 9;
            } else if (dataSetString.equalsIgnoreCase("MI_Clinton")) {
                GDA = "True";
                Sites = XML_Call + "dv/sos";
                UpLat = "42.946255";
                LowLat = "42.369895";
                LowLong = "-83.521823";
                UpLong = "-82.769277";
                Selected[7] = "selected";
                dataSet = 9;
            } else if (dataSetString.equalsIgnoreCase("OH_Cuyahoga")) {
                GDA = "True";
                Sites = XML_Call + "dv/sos";
                UpLat = "41.588189";
                LowLat = "40.992589";
                LowLong = "-81.835897";
                UpLong = "-81.292815";
                Selected[8] = "selected";
                dataSet = 9;
            } else if (dataSetString.equalsIgnoreCase("MI_Deer")) {
                GDA = "False";
                Sites = XML_Call + "wfs";
                UpLat = "46.556820";
                LowLat = "46.447536";
                LowLong = "-87.804871";
                UpLong = "-87.380144";
                Selected[9] = "selected";
                dataSet = 9;
            } else if (dataSetString.equalsIgnoreCase("MI_Detroit")) {
                GDA = "True";
                Sites = XML_Call + "dv/sos";
                UpLat = "42.704404";
                LowLat = "42.040509";
                LowLong = "-83.652877";
                UpLong = "-82.777644";
                Selected[10] = "selected";
                dataSet = 9;
            } else if (dataSetString.equalsIgnoreCase("NY_Eighteen")) {
                GDA = "False";
                Sites = XML_Call + "wfs";
                UpLat = "43.340909";
                LowLat = "43.137289";
                LowLong = "-78.797217";
                UpLong = "-78.513546";
                Selected[11] = "selected";
                dataSet = 9;
            } else if (dataSetString.equalsIgnoreCase("IN_Grandcalumet")) {
                GDA = "False";
                Sites = XML_Call + "wfs";
                UpLat = "41.760071";
                LowLat = "41.606395";
                LowLong = "-87.524709";
                UpLong = "-87.259419";
                Selected[12] = "selected";
                dataSet = 9;
            } else if (dataSetString.equalsIgnoreCase("MI_Kalamazoo")) {
                GDA = "True";
                Sites = XML_Call + "dv/sos";
                UpLat = "42.831620";
                LowLat = "41.975650";
                LowLong = "-86.219588";
                UpLong = "-84.451412";
                Selected[13] = "selected";
                dataSet = 9;
            } else if (dataSetString.equalsIgnoreCase("OH_Maumee")) {
                GDA = "True";
                Sites = XML_Call + "dv/sos";
                UpLat = "41.732851";
                LowLat = "41.357315";
                LowLong = "-83.884821";
                UpLong = "-83.061323";
                Selected[14] = "selected";
                dataSet = 9;
            } else if (dataSetString.equalsIgnoreCase("MI_Menominee")) {
                GDA = "True";
                Sites = XML_Call + "dv/sos";
                UpLat = "46.733787";
                LowLat = "45.064101";
                LowLong = "-89.077873";
                UpLong = "-87.501951";
                Selected[15] = "selected";
                dataSet = 9;
            } else if (dataSetString.equalsIgnoreCase("WI_Milwaukee")) {
                dataSet = 10;
            } else if (dataSetString.equalsIgnoreCase("MI_Muskegonlake")) {
                GDA = "True";
                Sites = XML_Call + "dv/sos";
                UpLat = "43.384612";
                LowLat = "43.189551";
                LowLong = "-86.352132";
                UpLong = "-85.903600";
                Selected[17] = "selected";
                dataSet = 9;
            } else if (dataSetString.equalsIgnoreCase("NY_Niagara")) {
                GDA = "False";
                Sites = XML_Call + "wfs";
                UpLat = "43.263355";
                LowLat = "42.811803";
                LowLong = "-79.076271";
                UpLong = "-78.858363";
                Selected[18] = "selected";
                dataSet = 9;
            } else if (dataSetString.equalsIgnoreCase("NY_Oswego")) {
                GDA = "False";
                Sites = XML_Call + "wfs";
                UpLat = "43.473991";
                LowLat = "43.446402";
                LowLong = "-76.531727";
                UpLong = "-76.500779";
                Selected[19] = "selected";
                dataSet = 9;
            } else if (dataSetString.equalsIgnoreCase("PA_PresqueIsle")) {
                GDA = "False";
                Sites = XML_Call + "wfs";
                UpLat = "42.162684";
                LowLat = "42.113121";
                LowLong = "-80.151499";
                UpLong = "-80.077424";
                Selected[20] = "selected";
                dataSet = 9;
            } else if (dataSetString.equalsIgnoreCase("MI_Raisin")) {
                GDA = "True";
                Sites = XML_Call + "dv/sos";
                UpLat = "42.257750";
                LowLat = "41.652318";
                LowLong = "-84.459701";
                UpLong = "-83.324048";
                Selected[21] = "selected";
                dataSet = 9;
            } else if (dataSetString.equalsIgnoreCase("NY_Rochester")) {
                GDA = "False";
                Sites = XML_Call + "wfs";
                UpLat = "43.339662";
                LowLat = "43.175139";
                LowLong = "-77.756398";
                UpLong = "-77.432446";
                Selected[22] = "selected";
                dataSet = 9;
            } else if (dataSetString.equalsIgnoreCase("MI_Rouge")) {
                GDA = "True";
                Sites = XML_Call + "dv/sos";
                UpLat = "42.646446";
                LowLat = "42.226238";
                LowLong = "-83.654179";
                UpLong = "-83.076605";
                Selected[23] = "selected";
                dataSet = 9;
            } else if (dataSetString.equalsIgnoreCase("MI_Saginaw")) {
                GDA = "True";
                Sites = XML_Call + "dv/sos";
                UpLat = "44.511562";
                LowLat = "42.513383";
                LowLong = "-85.3280329";
                UpLong = "-82.812625";
                Selected[24] = "selected";
                dataSet = 9;
            } else if (dataSetString.equalsIgnoreCase("WI_Sheboygan")) {
                GDA = "False";
                Sites = XML_Call + "wfs";
                UpLat = "43.755541";
                LowLat = "43.720441";
                LowLong = "-87.812581";
                UpLong = "-87.692693";
                Selected[25] = "selected";
                dataSet = 9;
            } else if (dataSetString.equalsIgnoreCase("MI_StClair")) {
                GDA = "True";
                Sites = XML_Call + "dv/sos";
                UpLat = "43.685902";
                LowLat = "42.131778";
                LowLong = "-83.189464";
                UpLong = "-81.568797";
                Selected[26] = "selected";
                dataSet = 9;
            } else if (dataSetString.equalsIgnoreCase("NY_StLawrence")) {
                GDA = "False";
                Sites = XML_Call + "wfs";
                UpLat = "45.015901";
                LowLat = "44.931629";
                LowLong = "-74.935712";
                UpLong = "-74.637861";
                Selected[27] = "selected";
                dataSet = 9;
            } else if (dataSetString.equalsIgnoreCase("MN_StLouis")) {
                GDA = "True";
                Sites = XML_Call + "dv/sos";
                UpLat = "47.784754";
                LowLat = "46.316812";
                LowLong = "-93.208055";
                UpLong = "-91.456459";
                Selected[28] = "selected";
                dataSet = 9;
            } else if (dataSetString.equalsIgnoreCase("MI_StMarys")) {
                GDA = "True";
                Sites = XML_Call + "dv/sos";
                UpLat = "47.371094";
                LowLat = "45.954590";
                LowLong = "-85.176651";
                UpLong = "-82.421875";
                Selected[29] = "selected";
                dataSet = 9;
            } else if (dataSetString.equalsIgnoreCase("MI_TorchLake")) {
                GDA = "False";
                Sites = XML_Call + "wfs";
                UpLat = "47.196807";
                LowLat = "47.126543";
                LowLong = "-88.476051";
                UpLong = "-88.392539";
                Selected[30] = "selected";
                dataSet = 9;
            } else if (dataSetString.equalsIgnoreCase("IL_Waukegan")) {
                GDA = "False";
                Sites = XML_Call + "wfs";
                UpLat = "42.419105";
                LowLat = "42.319276";
                LowLong = "-87.842729";
                UpLong = "-87.801955";
                Selected[31] = "selected";
                dataSet = 9;
            } else if (dataSetString.equalsIgnoreCase("MI_WhiteLake")) {
                GDA = "True";
                Sites = XML_Call + "dv/sos";
                UpLat = "43.701845";
                LowLat = "43.350233";
                LowLong = "-86.439162";
                UpLong = "-85.596305";
                Selected[32] = "selected";
                dataSet = 9;
			} else if (dataSetString.equalsIgnoreCase("FIE")){
				dataSet = 12;
            } else {
                dataSet = 100;
            }
    } else if (CommaList != null){
        dataSet = 5;
    } else if (GetFeatureXML != null){
        dataSet = 6;
    } else if (GetDataAvailabilityXML != null){
        dataSet = 7;
    } else if (observedProperty != null){
        GetDataAvailabilityXML = "<?xml version=\"1.0\" ?> <sos:GetDataAvailability version=\"2.0.0\" service=\"SOS\" maxFeatures=\"3\" xmlns:sos=\"http://schemas.opengis.net/sos/2.0.0/\" xmlns:wfs=\"http://www.opengis.net/wfs\" xmlns:ogc=\"http://www.opengis.net/ogc\" xmlns:gml=\"http://www.opengis.net/gml/3.2\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:om=\"http://www.opengis.net/om/2.0\" xmlns:fes=\"http://www.opengis.net/fes/2.0\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" xsi:schemaLocation=\"http://www.opengis.net/sos/2.0 http://schemas.opengis.net/sos/2.0.0/sos.xsd\">";
        if (observedProperty.equals("All")) {
        } else {
            GetDataAvailabilityXML = GetDataAvailabilityXML + "<sos:observedProperty>" + observedProperty + "</sos:observedProperty>";
        }
        GetDataAvailabilityXML = GetDataAvailabilityXML + "<sos:offering>" + offering + "</sos:offering> <ogc:Filter> <ogc:BBOX> <gml:Envelope> <gml:lowerCorner>";
        GetDataAvailabilityXML = GetDataAvailabilityXML + LowLong + " " + LowLat + "</gml:lowerCorner> <gml:upperCorner>";
        GetDataAvailabilityXML = GetDataAvailabilityXML + UpLong + " " + UpLat + "</gml:upperCorner> </gml:Envelope> </ogc:BBOX> </ogc:Filter> </sos:GetDataAvailability>";
        dataSet = 7;
        // Got to figure out enums....
        Properties[0] = "";
        if (observedProperty.equalsIgnoreCase("Discharge")) {
             Properties[0] = "selected";
        } else if (observedProperty.equalsIgnoreCase("GageHeight")) {
            Properties[1] = "selected";
        } else if (observedProperty.equalsIgnoreCase("Temperature")) {
            Properties[2] = "selected";
        } else if (observedProperty.equalsIgnoreCase("Precipitation")) {
            Properties[3] = "selected";
        } else if (observedProperty.equalsIgnoreCase("DO")) {
            Properties[4] = "selected";
        } else if (observedProperty.equalsIgnoreCase("Turbidity")) {
            Properties[5] = "selected";
        } else if (observedProperty.equalsIgnoreCase("pH")) {
            Properties[6] = "selected";
        } else if (observedProperty.equalsIgnoreCase("All")) {
            Properties[7] = "selected";
        }
        Offerings[0] = "";
        if (offering.equalsIgnoreCase("MEAN")) {
             Offerings[0] = "selected";
        } else if (offering.equalsIgnoreCase("MAXIMUM")) {
            Offerings[1] = "selected";
        } else if (offering.equalsIgnoreCase("MINIMUM")) {
            Offerings[2] = "selected";
        } else if (offering.equalsIgnoreCase("SUM")) {
            Offerings[3] = "selected";
        } else if (offering.equalsIgnoreCase("MODE")) {
            Offerings[4] = "selected";
        } else if (offering.equalsIgnoreCase("MEDIAN")) {
            Offerings[5] = "selected";
        } else if (offering.equalsIgnoreCase("STD")) {
            Offerings[6] = "selected";
        } else if (offering.equalsIgnoreCase("VARIANCE")) {
            Offerings[7] = "selected";
        } else if (offering.equalsIgnoreCase("UNIT")) {
            Offerings[8] = "selected";
        }
    } else {
        dataSet = 100;
    }

    String GetFeatureXMLText = "<?xml version=\"1.0\" ?> <wfs:GetFeature version=\"1.1.0\" service=\"WFS\" maxFeatures=\"3\" xmlns:wfs=\"http://www.opengis.net/wfs\" xmlns:ogc=\"http://www.opengis.net/ogc\" xmlns:gml=\"http://www.opengis.net/gml\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"><wfs:Query>";
    GetFeatureXMLText = GetFeatureXMLText + "<ogc:Filter> <ogc:BBOX> <gml:Envelope> <gml:lowerCorner>";

    String GetDataAvailabilityXMLText = "<?xml version=\"1.0\" ?> <sos:GetDataAvailability version=\"2.0.0\" service=\"SOS\" maxFeatures=\"3\" xmlns:sos=\"http://schemas.opengis.net/sos/2.0.0/\" xmlns:wfs=\"http://www.opengis.net/wfs\" xmlns:ogc=\"http://www.opengis.net/ogc\" xmlns:gml=\"http://www.opengis.net/gml/3.2\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:om=\"http://www.opengis.net/om/2.0\" xmlns:fes=\"http://www.opengis.net/fes/2.0\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" xsi:schemaLocation=\"http://www.opengis.net/sos/2.0 http://schemas.opengis.net/sos/2.0.0/sos.xsd\">";
    GetDataAvailabilityXMLText = GetDataAvailabilityXMLText + "<ogc:Filter> <ogc:BBOX> <gml:Envelope> <gml:lowerCorner>";


       switch (dataSet) {
        case 1:     // SWIE
            Sites = Sites + "01427207,01427510,01434000,01438500,01457500,01463500,04073365,04073500,04082400,04084445,05344500,05378500,05389500,05391000,05395000,05404000,05407000,05420500,05543500,05543830,05545750,05551540,05552500,05558300,05568500,05586100,07010000,07020500,";
            Sites = Sites + "07022000,05051500,05054000,05082500,04269000,040851385,04010500,04024000,04024430,04027000,";
            Sites = Sites + "04027500,04040000,04045500,04059000,04059500,04067500,04069500,04071765,04085427,04086000,";
            Sites = Sites + "04087000,04092750,04095090,04102500,04121970,04122200,04122500,04137500,04142000,04157000,";
            Sites = Sites + "04159492,04165500,04174500,04176500,04193500,04195820,04198000,04199000,04199500,04200500,";
            Sites = Sites + "04201500,04208000,04212100,04213500,04218000,04231600,04249000,04260500,04263000,04265432,";
            Sites = Sites + "01646580,02226160,02470500,04264331,07374525,07381495,08475000,09522000,11303500,11447650,14246900,15565447";
            Lat = "43.18997026";
            Long = "-96.73343980";
            Scale = 4;
            Selected[0] = "selected";
            break;
        case 2:     // Kalamazoo
            Sites = Sites + "04102850,04103010,04103500,04104000,04104500,04104945,04105000,04105500,04105700,04105800,";
            Sites = Sites + "04106000,04106180,04106190,04106300,04106320,04106400,04106500,04106906,04107850,04108000,";
            Sites = Sites + "04108500,04108600,04108660";
            Lat = "42.18997026";
            Long = "-85.53343980";
            Scale = 6;
            Selected[1] = "selected";
            break;

        case 3: //WI UP
            Sites = Sites + "04031000,04043275,04065106,04067958,04074950,05362000,";
            Sites = Sites + "04043126,04043150,04043238,04040000,04033000,04027000";
            Lat = "46.18997026";
            Long = "-89.73343980";
            Scale = 6;
            Selected[2] = "selected";

            break;
        case 4: //TN NC AL
            Sites = Sites + "03497300,03498500,03538830,03539600,";
            Sites = Sites + "03566000,03528000,03409500,03527220,03566525,03455000,03461500,03467609,";
            Sites = Sites + "03415000,03535000,03535400,03410210,03465500,03518500,03539778,03539800,";
            Sites = Sites + "03540500,02398000,03544970,03479000,03453500,03460000,03459500,03450000,";
            Sites = Sites + "03451500,03456991,03456100,03513000,03505550,03503000,03504000,02399200,";
            Sites = Sites + "02399200,02176930,02177000,02178400,02181580";
            Lat = "35.68997026";
            Long = "-84.73343980";
            Scale = 6;
            Selected[3] = "selected";
            break;
        case 5: //User Input
            String site_no = "";
            for (int i = 0; i<CommaList.length; i++) {
                site_no = site_no + CommaList[i] + ",";
            }
            site_no = site_no.substring(0, site_no.length() - 1);
            Sites = Sites + site_no;
            Tab = "1";
            Lat = "41.18997026";
            Long = "-96.73343980";
            Scale = 4;
            Selected[6] = "selected";
            textbox = site_no;
            break;
        case 6: //XML Input
            Sites = XML_Call  + "wfs";
            Lat = "41.18997026";
            Long = "-96.73343980";
            Scale = 4;
            Selected[7] = "selected";
            xmlbox = GetFeatureXML;
            get = "False";
            Tab = "2";
            break;
        case 7: //GDA Input
            Sites = XML_Call  + "dv/sos";
            Lat = "41.18997026";
            Long = "-96.73343980";
            Scale = 5;
            Selected[5] = "selected";
            xmlbox = GetDataAvailabilityXML;
            get = "False";
            GDA = "True";
            if (observedProperty != null){
                Float Lat_float = (Float.valueOf(UpLat) + Float.valueOf(LowLat))/2;
                Float Long_float = (Float.valueOf(UpLong) + Float.valueOf(LowLong))/2;
                Lat = Float.toString(Lat_float);
                Long = Float.toString(Long_float);
                Tab = "4";
                UpperLat = UpLat;
                UpperLong = UpLong;
                LowerLat = LowLat;
                LowerLong = LowLong;
            } else {
                Tab = "3";
            }
            break;
        case 8:
            Sites = Sites + "04010500,04024430,04027000,04027500,04040000,04045500,04059000,04059500,04067500,04069500,";
            Sites = Sites + "04071765,040851385,04085427,04086000,04087000,04092750,04095090,04102500,04122200,04122500,04137500,04142000,04157000,04159492,04176500,04195820,04198000,04199000,04199500,04200500,";
            Sites = Sites + "04201500,04208000,04212100,04213500,04218000,04231600,04249000,04260500,04263000,04264331,04269000";
            Lat = "45.18997026";
            Long = "-85.73343980";
            Scale = 5;
            Selected[4] = "selected";
            break;
        case 9:
            get = "False";
            GetFeatureXML = GetFeatureXMLText + LowLong + " " + LowLat + "</gml:lowerCorner> <gml:upperCorner>";
            GetFeatureXML =  GetFeatureXML + UpLong + " " + UpLat + "</gml:upperCorner> </gml:Envelope> </ogc:BBOX> </ogc:Filter> </wfs:Query></wfs:GetFeature>";

            GetDataAvailabilityXML = GetDataAvailabilityXMLText + LowLong + " " + LowLat + "</gml:lowerCorner> <gml:upperCorner>";
            GetDataAvailabilityXML = GetDataAvailabilityXML + UpLong + " " + UpLat + "</gml:upperCorner> </gml:Envelope> </ogc:BBOX> </ogc:Filter> </sos:GetDataAvailability>";

            Float Lat_float = (Float.valueOf(UpLat) + Float.valueOf(LowLat))/2;
            Float Long_float = (Float.valueOf(UpLong) + Float.valueOf(LowLong))/2;
            Lat = Float.toString(Lat_float);
            Long = Float.toString(Long_float);
            Tab = "0";
            UpperLat = UpLat;
            UpperLong = UpLong;
            LowerLat = LowLat;
            LowerLong = LowLong;
            Scale = 6;
            break;
       case 10:
            Sites = Sites + "04087142,04087170,04087159,04087160,040871602,040871488,040871472,040871482,040871478";
            Lat = "43.0";
            Long = "-87.93343980";
            Scale = 10;
            Selected[16] = "selected";
            break;
       case 11:
            Sites = Sites + "04200500,04199500";
            Lat = "41.50";
            Long = "-82.15";
            Scale = 9;
            Selected[5] = "selected";
            break;
        case 12:
            Sites = Sites + "05114000,05113600,05116000,05116500,05117500,05119410,05120000,05120500,05122000,05123400,05123510,05124000";
            Lat = "48.55972222";
            Long = "-101.5";
            Scale = 6;
            Selected[33] = "selected";
            break;
       default:
            Sites = Sites + "05114000,05113600,05116000,05116500,05117500,05119410,05120000,05120500,05122000,05123400,05123510,05124000";
            Lat = "48.55972222";
            Long = "-101.5";
            Scale = 6;
            Selected[33] = "selected";
            break;
            //Sites = Sites + "01427207,01427510,01434000,01438500,01457500,01463500,04073365,04073500,04082400,04084445,";
            //Sites = Sites + "05344500,05378500,05389500,05391000,05395000,05404000,05407000,05420500,";
            //Sites = Sites + "05543500,05543830,05545750,05551540,05552500,05558300,05568500,05586100,07010000,07020500,";
            //Sites = Sites + "07022000,05051500,05054000,05082500,04269000,040851385,04010500,04024000,04024430,04027000,";
            //Sites = Sites + "04027500,04040000,04045500,04059000,04059500,04067500,04069500,04071765,04085427,04086000,";
            //Sites = Sites + "04087000,04092750,04095090,04102500,04121970,04122200,04122500,04137500,04142000,04157000,";
            //Sites = Sites + "04159492,04165500,04174500,04176500,04193500,04195820,04198000,04199000,04199500,04200500,";
            //Sites = Sites + "04201500,04208000,04212100,04213500,04218000,04231600,04249000,04260500,04263000,04265432,";
            //Sites = Sites + "01646580,02226160,02470500,04264331,07374525,07381495,08475000,09522000,11303500,";
            //Sites = Sites + "11447650,14246900,15565447";
            //Lat = "43.18997026";
            //Long = "-96.73343980";
            //Scale = 4;
            //Selected[0] = "selected";
            //break;
    };

 %>
<html>
    <head>
		<meta name="publisher" content="USGS"/>
		<meta name="description" content="Home page for water resources information from the US Geological Survey."/>
		<meta name="keywords" content="USGS, U.S. Geological Survey, water, earth science, hydrology, hydrologic, data, streamflow, stream, river, lake, flood, drought, quality, basin, watershed, environment, ground water, groundwater"/>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
		<meta name="publisher" content="USGS - U.S. Geological Survey, Water Resources"/>
		<meta name="expires" content="never"/>

		<link href="http://www.usgs.gov/styles/common.css" rel="stylesheet" type="text/css"/>
		<link href="http://www.usgs.gov/frameworkfiles/styles/custom.css" rel="stylesheet" type="text/css" />
		<link href="http://www.usgs.gov/frameworkfiles/styles/framework.css" rel="stylesheet" type="text/css" />

		<link href="../styles/custom-theme/jquery.ui.all.css" rel="stylesheet"/>
		<meta http-equiv="content-type" content="text/html; charset=UTF-8"/>

		<title>OGC Services SWIE</title>

		<style type="text/css">
			h1 {font-size: 3em;
				margin: 1px 0;
				font: 18px Helvetica;
			}
		</style>

        <script type="text/javascript" src="../js/jquery-1.6.js"></script>
        <script src="../js/LoadXML.js" type="text/javascript"></script>
        <script src="../js/LoadXMLGDA.js" type="text/javascript"></script>
        <script src="../js/LoadXMLPost.js" type="text/javascript"></script>
        <script src="../js/parseXML.js" type="text/javascript"></script>
        <script src="../js/parseGDAXML.js" type="text/javascript"></script>
        <script src="../js/CreateMarker.js" type="text/javascript"></script>
        <script src="../js/jquery.ui.core.min.js" type="text/javascript" ></script>
        <script src="../js/jquery.ui.widget.min.js" type="text/javascript" ></script>
        <script src="../js/jquery-ui-1.8.12.custom.min.js" type="text/javascript" ></script>
<!--        <link rel="stylesheet" type="text/css" media="screen" href="tooltipv2.css" />-->

        <script src="http://maps.google.com/maps?file=api&amp;v=3&amp;sensor=false&amp;key=ABQIAAAA_s7fSqhIs_dt6wGcko6mSRT0fazSD1VpH7Mi_uflQ_dFOWTAeBRRlw3A34pENLWUzwjXtIwUQHBc6Q" type="text/javascript"></script>
        <script src="../js/mapiconmaker.js" type="text/javascript"></script>
		
		<script type="text/javascript">
			$(function() {
				$( "#tabs" ).tabs({
					selected: <%=Tab%>,
					ajaxOptions: {
						error: function( xhr, status, index, anchor ) {
						$( anchor.hash ).html(
							"Couldn't load this tab. We'll try to fix this as soon as possible. ");
						}
					}
				});
			});

		</script>
    </head>

<body>
    <table cellpadding="0" cellspacing="0" width="100%">
        <tr>
            <td width="100%" valign="top"><!-- START header and top navigation section -->
            <!-- BEGIN USGS Header Template -->
                <div id="usgscolorband">
                        <div id="usgsbanner">
                                <div id="usgsidentifier"><a href="http://www.usgs.gov/"><img src="http://www.usgs.gov/images/header_graphic_usgsIdentifier_white.jpg" alt="USGS - science for a changing world" title="U.S. Geological Survey Home Page" width="178" height="72" /></a></div>

                                <div id="usgsccsabox">
                                        <div id="usgsccsa">
                                          <br /><a href="http://www.usgs.gov/">USGS Home</a>
                                          <br /><a href="http://www.usgs.gov/ask/">Contact USGS</a>
                                          <br /><a href="http://search.usgs.gov/">Search USGS</a>
                                        </div>
                                </div>

                        </div>
                </div>

                <div id="usgstitle">
                        <p>Water Resources of the United States</p>
                </div>
    <!-- END USGS Header Template -->
            </td>
        </tr>
    </table>

        <h1>Surface Water Interoperability Experiment USGS Gage Sites</h1><br />

<!--===============================Create Table=========================================-->

<table>
    <tr>
        <td>
<table>
        <tr>
           <td>
           <table  style="width:135px">
               <tr height="50">
               </tr>
               <tr>
                <td style="width:300px">
                    <table>
                        <tr>
                            <td>
                                <center><b>Navigation</b></center>
                            </td>
                        </tr>
                        <tr height="10"></tr>
                        <tr>
                            <td>
                                <li><a href="<%=base_url%>"> OGC Services</a></li>
                                <li><a href="<%=base_url%>MapFiles/Map.jsp"> <b>Interactive Map</b></a></li>
                                <li><a href="<%=base_url%>DischargePlot.jsp"> Timeseries Plot</a></li>
                            </td>
                        </tr>
                    </table>

                </td>
               </tr>
           </table>
           </td>
            <td>
                <div id="map" style="width: 660px; height: 350px"></div><br />
            </td>

        </tr>
        <tr>
            <td COLSPAN="2">
                <div id="tabs">
                    <ul>
                        <li><a href="#tabList">Pre-Defined Lists</a></li>
                        <li><a href="#tabComma">User-Defined List</a></li>
                        <li><a href="#tabWFS">GetFeature</a></li>
                        <li><a href="#tabGDA">GetDataAvailability</a></li>
                        <li><a href="#tabUI">User Interface</a></li>
                    </ul>

                    <div id="tabList" class="tab_content">
                            <table cellpadding="15">
                                <tr>
                                    <td>
                                        Pre-Defined<br />Data Set:<br />
                                    </td>
                                    <td>
                            <form>
                                <select name="dataSet" onChange="form.submit()" value="Load">
                                    <option value="FIE" <%=Selected[33]%>>Forecasting IE</option>
									<option value="SWIE" <%=Selected[0]%>>Surface Water IE</option>
                                    <option value="WDM" <%=Selected[1]%>>Kalamazoo</option>
                                    <option value="GL" <%=Selected[4]%>>Great Lakes</option>
                                    <option value="OH_Black" <%=Selected[5]%>>AOC - Black River, OH</option>
<!--                                    <option value="NY_Buffalo" <%=Selected[6]%>>AOC - Buffalo River, NY</option>-->
                                    <option value="MI_Clinton" <%=Selected[7]%>>AOC - Clinton River, MI</option>
                                    <option value="OH_Cuyahoga" <%=Selected[8]%>>AOC - Cuyahoga River, OH</option>
                                    <option value="MI_Deer" <%=Selected[9]%>>AOC - Deer Lake, MI</option>
                                    <option value="MI_Detroit" <%=Selected[10]%>>AOC - Detroit River, MI</option>
                                    <option value="NY_Eighteen" <%=Selected[11]%>>AOC - Eighteen Mile Creek, NY</option>
                                    <option value="IN_Grandcalumet" <%=Selected[12]%>>AOC - Grand Calumet River, IN</option>
                                    <option value="MI_Kalamazoo" <%=Selected[13]%>>AOC - Kalamazoo River, MI</option>
                                    <option value="OH_Maumee" <%=Selected[14]%>>AOC - Maumee River, OH</option>
                                    <option value="MI_Menominee" <%=Selected[15]%>>AOC - Menominee River, MI</option>
                                    <option value="WI_Milwaukee" <%=Selected[16]%>>AOC - Milwaukee Estuary, WI</option>
                                    <option value="MI_Muskegonlake" <%=Selected[17]%>>AOC - Muskegon Lake, MI</option>
                                    <option value="NY_Niagara" <%=Selected[18]%>>AOC - Niagara River, NY</option>
                                    <option value="NY_Oswego" <%=Selected[19]%>>AOC - Oswego River, NY</option>
<!--                                    <option value="PA_PresqueIsle" <%=Selected[20]%>>AOC - Presque Isle Bay, PA</option>-->
                                    <option value="MI_Raisin" <%=Selected[21]%>>AOC - Raisin River, MI</option>
                                    <option value="NY_Rochester" <%=Selected[22]%>>AOC - Rochester Embayment, NY</option>
                                    <option value="MI_Rouge" <%=Selected[23]%>>AOC - Rouge River, MI</option>
                                    <option value="MI_Saginaw" <%=Selected[24]%>>AOC - Saginaw River, MI</option>
                                    <option value="WI_Sheboygan" <%=Selected[25]%>>AOC - Sheboygan River, WI</option>
                                    <option value="MI_StClair" <%=Selected[26]%>>AOC - St. Clair River, MI</option>
<!--                                    <option value="NY_StLawrence" <%=Selected[27]%>>AOC - St. Lawrence River, NY</option>-->
                                    <option value="MN_StLouis" <%=Selected[28]%>>AOC - St. Louis River, MN</option>
                                    <option value="MI_StMary" <%=Selected[29]%>>AOC - St. Marys River, MI</option>
<!--                                    <option value="MI_TorchLake" <%=Selected[30]%>>AOC - Torch Lake, MI</option>-->
                                    <option value="IL_Waukegan" <%=Selected[31]%>>AOC - Waukegan Harbor River, IL</option>
                                    <option value="MI_WhiteLake" <%=Selected[32]%>>AOC - White Lake, MI</option>
                                    <option value="WI" <%=Selected[2]%>>North Central</option>
                                    <option value="SE" <%=Selected[3]%>>Southeast</option>
                                </select>
                            </form>
                                    </td>
                                </tr>
                            </table>
Pre-defined lists of USGS gaging stations are used to populate the map above with markers using a GetFeature or GetDataAvailability query. Clicking on a map marker will send a GetDataAvailability request, populating a table on the right.
All AOC options (area of concern) are determined by a GetDataAvailability call with a bounding box determined by the EPA: (<a href="http://www.epa.gov/glnpo/aoc/">http://www.epa.gov/glnpo/aoc/</a>)

                   </div>
                   <div id="tabComma" class="tab_content">
                            Station ID list (comma delimited):
                            <form>
                                <textarea name="CommaList" rows="4" cols="75"><%=textbox%></textarea><br />
                                <input type="submit" value="Load"/>
                            </form>
Create a comma delimited list of USGS stations to populate the map using a GetFeature query. Clicking on a map marker will send a GetDataAvailability request, populating a table on the right. A maximum of 750 markers can be displayed on the map.
                   </div>
                   <div id="tabWFS" class="tab_content">
                        GetFeature via XML HTTP body: <br /><b>Warning!</b> Use caution with bounding box - may take long to load with large bounding box
                            <form>
                                <textarea name="xml" rows="4" cols="75">
<?xml version="1.0" ?>
<wfs:GetFeature version="1.1.0" service="WFS"
        maxFeatures="3"
    xmlns:wfs="http://www.opengis.net/wfs"
    xmlns:ogc="http://www.opengis.net/ogc"
    xmlns:gml="http://www.opengis.net/gml"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <wfs:Query>
    <ogc:Filter>
      <ogc:BBOX>
        <gml:Envelope>
          <gml:lowerCorner>-90.0 43.0</gml:lowerCorner>
          <gml:upperCorner>-89.5 43.5</gml:upperCorner>
        </gml:Envelope>
      </ogc:BBOX>
    </ogc:Filter>
  </wfs:Query>
</wfs:GetFeature>
                                </textarea><br />
                                <input type="submit" value="Load"/>
                            </form>
This example uses a GetFeature query post to find all stations within the requested bounding box.  A maximum of 750 markers can be displayed on the map.
                   </div>
                   <div id="tabGDA" class="tab_content">
                        GetDataAvailability via XML HTTP body: <br /><b>Warning!</b> Use caution with bounding box - may take long to load with large bounding box
                            <form>
                                <textarea name="GDAxml" rows="4" cols="75">
<?xml version="1.0" ?>
<sos:GetDataAvailability version="2.0.0" service="SOS"
    maxFeatures="3"
    xmlns:sos="http://schemas.opengis.net/sos/2.0.0/"
    xmlns:wfs="http://www.opengis.net/wfs"
    xmlns:ogc="http://www.opengis.net/ogc"
    xmlns:gml="http://www.opengis.net/gml/3.2"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:om="http://www.opengis.net/om/2.0"
    xmlns:fes="http://www.opengis.net/fes/2.0"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xsi:schemaLocation="http://www.opengis.net/sos/2.0 http://schemas.opengis.net/sos/2.0.0/sos.xsd">
       <sos:observedProperty>GageHeight</sos:observedProperty>
       <sos:offering>MEAN</sos:offering>
       <ogc:Filter>
          <ogc:BBOX>
            <gml:Envelope>
              <gml:lowerCorner>-90 43</gml:lowerCorner>
              <gml:upperCorner>-88.0 45.0</gml:upperCorner>
            </gml:Envelope>
          </ogc:BBOX>
       </ogc:Filter>
</sos:GetDataAvailability>
                                </textarea><br />
                                <input type="submit" value="Load"/>
                            </form>
This example uses a GetDataAvailability query post to find stations that measure the requested Property/Offering combination. A maximum of 750 markers can be displayed on the map.
                   </div>
                    <div id="tabUI" class="tab_content">

                            <form>
                                <center>
                                Observed Property:
                                <select name="observedProperty">
                                    <option value="Discharge" <%=Properties[0]%>>Discharge</option>
                                    <option value="GageHeight" <%=Properties[1]%>>Gage Height</option>
                                    <option value="Temperature" <%=Properties[2]%>>Temperature</option>
                                    <option value="Precipitation" <%=Properties[3]%>>Precipitation</option>
                                    <option value="DO" <%=Properties[4]%>>Dissolved Oxygen</option>
                                    <option value="Turbidity" <%=Properties[5]%>>Turbidity</option>
                                    <option value="pH" <%=Properties[6]%>>pH</option>
                                    <option value="All" <%=Properties[7]%>>All</option>
                                </select>
                                Offering:
                                <select name="offering">
                                    <option value="MEAN" <%=Offerings[0]%>>Daily Mean</option>
                                    <option value="MAXIMUM" <%=Offerings[1]%>>Daily Maximum</option>
                                    <option value="MINIMUM" <%=Offerings[2]%>>Daily Minimum</option>
                                    <option value="SUM" <%=Offerings[3]%>>Daily Sum</option>
                                    <option value="MODE" <%=Offerings[4]%>>Daily Mode</option>
                                    <option value="MEDIAN" <%=Offerings[5]%>>Daily Median</option>
                                    <option value="STD" <%=Offerings[6]%>>Daily Standard Deviation</option>
                                    <option value="VARIANCE" <%=Offerings[7]%>>Daily Variance</option>
                                    <option value="UNIT" <%=Offerings[8]%>>Real Time</option>
                                </select></center><br /><br />
                                Bounding Box:<br />
                                <center><b>Upper Latitude </b><input name="UpperLat" rows="1" cols="15" value="<%=UpperLat%>"></input></center><br />
                                <center><b>Western Longitude</b> <input type="text" name="LowerLong" rows="1" cols="15" value="<%=LowerLong%>"></input><b>Eastern Longitude </b><input name="UpperLong" type="text" value="<%=UpperLong%>"></input></center><br /><br />
                                <center><b>Lower Latitude</b> <input name="LowerLat" rows="1" cols="15" value="<%=LowerLat%>"></input></center><br />
                                <input type="submit" value="Load"/>
                            </form>
This example populates a GetDataAvailability query to find stations that measure the requested Property/Offering combination. A maximum of 750 markers can be displayed on the map.
                    </div>

                </div>

            </td>
        </tr>
    </table>
        </td>
        <td>
    <table>
        <tr>

            <td valign="top">
                <table style="width:400px">
                    <tr>
                        <td>
                            <i><b>Current Marker:</b></i>
                        </td>
                        <td align="right">
                            Number of Markers:<br />
                            <b><div id="FeatureNumber"></div></b>
<!--                            <img src = "../img/USGS.gif" width="84" height="31" alighn="right"/><br />-->
                        </td>
                    </tr>
                </table>
                <center>
                    <div id="StationInfo" style="height:15px; width:400px">Click on a marker for data availability demonstration</div>
                </center>

            </td>
        </tr>
        <tr>
            <td>
                <div id="AvailableDataHeader"></div>
                <div id="AvailableData" style="overflow:auto; height: 375px; width:400px"></div>
            </td>
        </tr>
    </table>
        </td>
    </tr>
</table>
<!-- ===========================Create Check Boxes==================================-->


        <noscript><b>JavaScript must be enabled in order for you to use Google Maps.</b>
          However, it seems JavaScript is either disabled or not supported by your browser.
          To view Google Maps, enable JavaScript by changing your browser options, and then
          try again.
        </noscript>

        <script>

        if (GBrowserIsCompatible()) {
           
            var clickedIcon = MapIconMaker.createMarkerIcon({primaryColor: "#660000"});
            var newIcon = MapIconMaker.createMarkerIcon({primaryColor: "#3366FF"});
            var point_ini = new GLatLng(0, 0);
            var ActiveMarker = new GMarker(point_ini, clickedIcon);
            var gmarkers = [];
            var base = '<%=baseURL%>';
            var Sites = '<%=Sites%>';
            var Lat = '<%=Lat%>';
            var Long = '<%=Long%>';
            var Scale = <%=Scale%>;
            var Get = '<%=get%>';
            var GDA = '<%=GDA%>';
            var today = '<%=Today%>';
            var test = base.length - 8;    // Gets rid of /MapFiles/ from baseURL
            var base_url = base.substring(0,test);
            var LastWeekStr = '<%=LastWeek%>';

            var dataXML = '<%=GetFeatureXML%>';
            var GDAdataXML = '<%=GetDataAvailabilityXML%>';

//================================= Rebuilds sidebar =======================================
      function makeSidebar() {
        var html = "";
        for (var i=0; i<gmarkers.length; i++) {
          if (!gmarkers[i].isHidden()) {
            html += '<a href="javascript:myclick(' + i + ')">' + gmarkers[i].myname + '<\/a><br>';
          }
        }
        document.getElementById("AvailableData").innerHTML = html;
      }

//==========================================Create the map================================
      	var map = new GMap2(document.getElementById("map"));
      	map.addControl(new GLargeMapControl());
      	map.addControl(new GMapTypeControl());
      	map.addMapType(G_PHYSICAL_MAP);
        map.setCenter(new GLatLng(Lat, Long), Scale, G_PHYSICAL_MAP);
      	map.enableScrollWheelZoom();
        pane = map.getPane(G_MAP_MARKER_SHADOW_PANE);
        pane.style.display = "none";
        
        var wfs_url = Sites;
        document.getElementById("AvailableData").innerHTML = 'Loading...<img src = "../img/ajax-loader.gif"/>';
        if (Get == 'True'){
            xml = LoadXML(wfs_url);
        } else if (Get == 'False' & GDA == 'False'){
            xml = LoadXMLPOST(wfs_url,dataXML);
            parseXML(xml);
        } else if (Get == 'False' & GDA == 'True'){
            xml = LoadXMLPOST(wfs_url,GDAdataXML);
            parseGDAXML(xml,base_url);
        }


//        google.maps.addListener(map,'rangechange',function(){
//            document.getElementById("AvailableData").innerHTML ="";
//            var bounds = new google.maps.LatLngBounds();
//
//            var UpperLat = bounds.getNorthEast().lat().toString();
//            var LowerLat = bounds.getSouthWest().lat().toString();
//            var EasternLong = bounds.getNorthEast().lng().toString();
//            var WesternLong = bounds.getSouthWest().lng().toString();
//
//            document.getElementById("UpperLat").innerHTML = UpperLat;
//            document.getElementById("LowerLat").innerHTML = LowerLat;
//            document.getElementById("EasternLong").innerHTML = EasternLong;
//            document.getElementById("WesternLong").innerHTML = WesternLong;
//        });

    }
    else {
            alert("Sorry, the Google Maps API is not compatible with this browser");
        }
        </script>


        <span> <font size="0.5"><br />* References to non-U.S. Department of the Interior (DOI) products do not constitute an endorsement by the DOI. By viewing the Google Maps API on this web site the user agrees to these
        <a href="http://code.google.com/apis/maps/terms.html" target="_blank" title="Opens a new browser window.">Terms of Service set forth by Google</a>.<br /></font></span>
        <br />
        <!-- BEGIN USGS Footer Template -->

<div id="linksfooterbar">
   <!-- <p id="usgsfooterbar">-->
	<a href="http://www.usgs.gov/" title="USGS Home page.">USGS Home</a>
	<a href="http://water.usgs.gov/" title="USGS Water Resources of the United States">Water</a>
	<a href="http://www.usgs.gov/climate_landuse/" title="USGS Climate and Land Use Change">Climate Change</a>
	<a href="http://www.usgs.gov/core_science_systems/" title="USGS Core Science Systems">Science Systems</a>
	<a href="http://www.usgs.gov/ecosystems/" title="USGS Ecosystems">Ecosystems</a>
	<a href="http://www.usgs.gov/resources_envirohealth/" title="USGS Energy, Minerals, and Environmental Health">Energy, Minerals, &amp; Env. Health</a>
	<a href="http://www.usgs.gov/natural_hazards/" title="USGS Natural Hazards">Hazards</a>
        <a href="http://internal.usgs.gov/" title="USGS Intranet home page">USGS Intranet</a>
   <!-- </p>-->
</div>
<div id="usgsfooter">
      <p id="usgsfooterbar">
        <a href="http://www.usgs.gov/accessibility.html" title="Accessibility Policy (Section 508)">Accessibility</a>
        <a href="http://www.usgs.gov/foia/" title="Freedom of Information Act">FOIA</a>
        <a href="http://www.usgs.gov/privacy.html" title="Privacy policies of the U.S. Geological Survey.">Privacy</a>
        <a href="http://www.usgs.gov/policies_notices.html" title="Policies and notices that govern information posted on USGS Web sites.">Policies and Notices</a>
      </p>

      <p id="usgsfootertext">
        <a href="http://www.takepride.gov/"><img src="http://www.usgs.gov/images/footer_graphic_takePride.jpg" alt="Take Pride in America logo" title="Take Pride in America Home Page" width="60" height="58"/></a>
	<a href="http://firstgov.gov/"><img src="http://www.usgs.gov/images/footer_graphic_usagov.jpg" alt="USA.gov logo" width="90" height="26" style="float: right; margin-right: 10px;" title="USAGov: Government Made Easy."/></a>
        <a href="http://www.doi.gov/">U.S. Department of the Interior</a> |
        <a href="http://www.usgs.gov/">U.S. Geological Survey</a><br />
        <br />

       <!-- Page Contact Information: <a href="http://water.usgs.gov/user_feedback_form.html">Water Webserver Team</a><br />-->

        Page Last Modified: Tuesday, 16-March-2011 16:45:46 CST
      </p>
</div>

<!-- END USGS Footer Template -->
  </body>

</html>
