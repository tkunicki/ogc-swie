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
    String[] Properties = new String[7];
    Properties[0] = "selected";
    String[] Offerings = new String[9];
    Offerings[0] = "selected";

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
            } else {
                dataSet = 9;
            }
    } else if (CommaList != null){
        dataSet = 5;
    } else if (GetFeatureXML != null){
        dataSet = 6;
    } else if (GetDataAvailabilityXML != null){
        dataSet = 7;
    } else if (observedProperty != null){
        GetDataAvailabilityXML = "<?xml version=\"1.0\" ?> <sos:GetDataAvailability version=\"2.0.0\" service=\"SOS\" maxFeatures=\"3\" xmlns:sos=\"http://schemas.opengis.net/sos/2.0.0/\" xmlns:wfs=\"http://www.opengis.net/wfs\" xmlns:ogc=\"http://www.opengis.net/ogc\" xmlns:gml=\"http://www.opengis.net/gml/3.2\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:om=\"http://www.opengis.net/om/2.0\" xmlns:fes=\"http://www.opengis.net/fes/2.0\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" xsi:schemaLocation=\"http://www.opengis.net/sos/2.0 http://schemas.opengis.net/sos/2.0.0/sos.xsd\"> <sos:observedProperty>";
        GetDataAvailabilityXML = GetDataAvailabilityXML + observedProperty + "</sos:observedProperty> <sos:offering>";
        GetDataAvailabilityXML = GetDataAvailabilityXML + offering + "</sos:offering> <ogc:Filter> <ogc:BBOX> <gml:Envelope> <gml:lowerCorner>";
        GetDataAvailabilityXML = GetDataAvailabilityXML + LowLong + " " + LowLat + "</gml:lowerCorner> <gml:upperCorner>";
        GetDataAvailabilityXML = GetDataAvailabilityXML + UpLong + " " + UpLat + "</gml:upperCorner> </gml:Envelope> </ogc:BBOX> </ogc:Filter> </sos:GetDataAvailability>";
        dataSet = 7;
        // Got to figure out enums....
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
        }
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
        dataSet = 9;
    }

    String textbox = "01446500,05082500";
    String UpperLat = "44.0";
    String UpperLong = "-89.0";
    String LowerLat = "43.0";
    String LowerLong = "-90.0";
    String xmlbox = "";
    String XML_Call = base_url;
    String Sites = base_url + "wfs?request=GetFeature&featureId=";

    String Lat;
    String Long;
    Integer Scale;
    String[] Selected = new String[8];
    Selected[5] = "style='visibility:hidden;'";
    Selected[6] = "style='visibility:hidden;'";
    Selected[7] = "style='visibility:hidden;'";
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
            Selected[5] = "selected";
            textbox = site_no;
            break;
        case 6: //XML Input
            Sites = XML_Call  + "wfs";
            Lat = "41.18997026";
            Long = "-96.73343980";
            Scale = 4;
            Selected[6] = "selected";
            xmlbox = GetFeatureXML;
            get = "False";
            Tab = "2";
            break;
        case 7: //GDA Input
            Sites = XML_Call  + "dv/sos";
            Float Lat_float = (Float.valueOf(UpLat) + Float.valueOf(LowLat))/2;
            Float Long_float = (Float.valueOf(UpLong) + Float.valueOf(LowLong))/2;
            Lat = Float.toString(Lat_float);
            Long = Float.toString(Long_float);
            //Lat = "41.18997026";
            //Long = "-96.73343980";
            Scale = 5;
            Selected[7] = "selected";
            xmlbox = GetDataAvailabilityXML;
            get = "False";
            GDA = "True";
            if (observedProperty != null){
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
       default:
            Sites = Sites + "01427207,01427510,01434000,01438500,01457500,01463500,04073365,04073500,04082400,04084445,";
            Sites = Sites + "05344500,05378500,05389500,05391000,05395000,05404000,05407000,05420500,";
            Sites = Sites + "05543500,05543830,05545750,05551540,05552500,05558300,05568500,05586100,07010000,07020500,";
            Sites = Sites + "07022000,05051500,05054000,05082500,04269000,040851385,04010500,04024000,04024430,04027000,";
            Sites = Sites + "04027500,04040000,04045500,04059000,04059500,04067500,04069500,04071765,04085427,04086000,";
            Sites = Sites + "04087000,04092750,04095090,04102500,04121970,04122200,04122500,04137500,04142000,04157000,";
            Sites = Sites + "04159492,04165500,04174500,04176500,04193500,04195820,04198000,04199000,04199500,04200500,";
            Sites = Sites + "04201500,04208000,04212100,04213500,04218000,04231600,04249000,04260500,04263000,04265432,";
            Sites = Sites + "01646580,02226160,02470500,04264331,07374525,07381495,08475000,09522000,11303500,";
            Sites = Sites + "11447650,14246900,15565447";
            Lat = "43.18997026";
            Long = "-96.73343980";
            Scale = 4;
            Selected[0] = "selected";
            break;
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
    <link href="../styles/framework.css" rel="stylesheet" type="text/css" />
<!--this adds or changes styles for CIDA applications -->
    <link href="../styles/mdc.css" rel="stylesheet" type="text/css" media="screen"/>
    <link href="../styles/mdc-print.css" rel="stylesheet" type="text/css" media="print"/>
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
        <link rel="stylesheet" type="text/css" media="screen" href="tooltipv2.css" />

        <script src="http://maps.google.com/maps?file=api&amp;v=2&amp;sensor=false&amp;key=ABQIAAAA_s7fSqhIs_dt6wGcko6mSRT0fazSD1VpH7Mi_uflQ_dFOWTAeBRRlw3A34pENLWUzwjXtIwUQHBc6Q" type="text/javascript"></script>
        <script src="../js/mapiconmaker.js" type="text/javascript"></script>
    <script type="text/javascript">
	$(function() {
		$( "#tabs" ).tabs({
                    selected: <%=Tab%>
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
                <div id="map" style="width: 560px; height: 300px"></div><br />
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
                                    <option value="SWIE" <%=Selected[0]%>>Surface Water IE</option>
                                    <option value="WDM" <%=Selected[1]%>>Kalamazoo</option>
                                    <option value="WI" <%=Selected[2]%>>North Central</option>
                                    <option value="SE" <%=Selected[3]%>>Southeast</option>
                                    <option value="GL" <%=Selected[4]%>>Great Lakes</option>
                                    <option value="UserList" <%=Selected[5]%>>List from comma delimited station number list</option>
                                    <option value="WFS" <%=Selected[6]%>>List from WFS XML</option>
                                    <option value="GDA" <%=Selected[7]%>>List from GDA XML</option>
                                </select>
                            </form>
                                    </td>
                                </tr>
                            </table>
Pre-defined lists of USGS gaging stations are used to populate the map above with markers using a GetFeature query. Clicking on a map marker will send a GetDataAvailability request, populating a table on the right.

                   </div>
                   <div id="tabComma" class="tab_content">
                            Station ID list (comma delimited):
                            <form>
                                <textarea name="CommaList" rows="4" cols="75"><%=textbox%></textarea><br />
                                <input type="submit" value="Load"/>
                            </form>
Create a comma delimited list of USGS stations to populate the map using a GetFeature query. Clicking on a map marker will send a GetDataAvailability request, populating a table on the right.
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
This example uses a GetFeature query post to find all stations within the requested bounding box.
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
This example uses a GetDataAvailability query post to find stations that measure the requested Property/Offering combination.
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
This example populates a GetDataAvailability query to find stations that measure the requested Property/Offering combination.  
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

        document.getElementById("AvailableData").innerHTML ="";

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
