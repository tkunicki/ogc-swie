<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"  "http://www.w3.org/TR/html4/loose.dtd">

<%@ page  language="java" import="java.util.*,java.text.*"%>
<%
    String baseURL = request.getRequestURL().toString().replaceAll("/[^/]*$", "");
    Calendar lastWeek = new GregorianCalendar();
    lastWeek.add(Calendar.DAY_OF_YEAR, -7);

    Date now = new Date();

    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

    String todayFormated = formatter.format(now);
    String lastWeekFormated = formatter.format(lastWeek.getTime());

    String Today = todayFormated;
    String LastWeek = lastWeekFormated;
    String dataSetString = request.getParameter("dataSet");
    String[] CommaList = request.getParameterValues("CommaList");

    int dataSet;
    if (dataSetString != null) {
            if (dataSetString.equalsIgnoreCase("SWIE")) {
                dataSet = 1;
            } else if (dataSetString.equalsIgnoreCase("WDM")) {
                dataSet = 2;
            } else if (dataSetString.equalsIgnoreCase("WI")) {
                dataSet = 3;
            } else if (dataSetString.equalsIgnoreCase("SE")) {
                dataSet = 4;
            } else if (dataSetString.equalsIgnoreCase("User")) {
                dataSet = 5;
            } else {
                dataSet = 6;
            }
    } else if (CommaList != null){
        dataSet = 5;
    } else {
        dataSet = 6;
    }

    String Sites = baseURL + "/wfs?request=GetFeature&featureId=";
    String Lat;
    String Long;
    Integer Scale;
    String[] Selected = new String[5];
    switch (dataSet) {
        case 1:     // SWIE
            Sites = Sites + "01427207,01427510,01434000,01438500,01457500,01463500,04073365,04073500,04082400,04084445,";
            Sites = Sites + "040851385,05344500,05378500,05389500,05391000,05395000,05404000,05407000,05420500,";
            Sites = Sites + "05543500,05543830,05545750,05551540,05552500,05558300,05568500,05586100,07010000,07020500,";
            Sites = Sites + "07022000,05051500,05054000,05082500,04269000,040851385,04010500,04024000,04024430,04027000,";
            Sites = Sites + "04027500,04040000,04045500,04059000,04059500,04067500,04069500,04071765,04085427,04086000,";
            Sites = Sites + "04087000,04092750,04095090,04102500,04121970,04122200,04122500,04137500,04142000,04157000,";
            Sites = Sites + "04159492,04165500,04174500,04176500,04193500,04195820,04198000,04199000,04199500,04200500,";
            Sites = Sites + "04201500,04208000,04212100,04213500,04218000,04231600,04249000,04260500,04263000,04265432,";
            Sites = Sites + "01578310,01646580,02226160,02470500,04264331,07374525,07381495,08475000,09522000,11303500,";
            Sites = Sites + "11447650,14246900,15565447";
            Lat = "41.18997026";
            Long = "-96.73343980";
            Scale = 4;
            Selected[0] = "selected";
            Selected[1] = null;
            Selected[2] = null;
            Selected[3] = null;
            Selected[4] = null;
            break;
        case 2:     // Kalamazoo
            Sites = Sites + "04102850,04103010,04103500,04104000,04104500,04104945,04105000,04105500,04105700,04105800,";
            Sites = Sites + "04106000,04106180,04106190,04106300,04106320,04106400,04106500,04106906,04107850,04108000,";
            Sites = Sites + "04108500,04108600,04108660";
            Lat = "43.18997026";
            Long = "-84.73343980";
            Scale = 6;
            Selected[0] = null;
            Selected[1] = "selected";
            Selected[2] = null;
            Selected[4] = null;

            break;
        case 3: //WI UP
            Sites = Sites + "04031000,04043275,04065106,04067958,04074950,05362000,";
            Sites = Sites + "04043126,04043150,04043238,04040000,04033000,04027000";
            Lat = "45.18997026";
            Long = "-89.73343980";
            Scale = 6;
            Selected[0] = null;
            Selected[1] = null;
            Selected[2] = "selected";
            Selected[3] = null;
            Selected[4] = null;
            break;
        case 4: //TN NC AL
            Sites = Sites + "03497300,03498500,03538830,03539600,";
            Sites = Sites + "03566000,03528000,03409500,03527220,03566525,03455000,03461500,03467609,";
            Sites = Sites + "03415000,03535000,03535400,03410210,03465500,03518500,03539778,03539800,";
            Sites = Sites + "03540500,02398000,03544970,03479000,03453500,03460000,03459500,03450000,";
            Sites = Sites + "03451500,03456991,03456100,03513000,03505550,03503000,03504000,02399200,";
            Sites = Sites + "02399200,02176930,02177000,02178400,02181580";
            Lat = "36.18997026";
            Long = "-84.73343980";
            Scale = 6;
            Selected[0] = null;
            Selected[1] = null;
            Selected[2] = null;
            Selected[3] = "selected";
            Selected[4] = null;
            break;
        case 5: //User Input
            String site_no = "";
            for (int i = 0; i<CommaList.length; i++) {
                site_no = site_no + CommaList[i] + ",";
            }
            Sites = Sites + site_no.substring(0, site_no.length() - 1);

            Lat = "41.18997026";
            Long = "-96.73343980";
            Scale = 4;
            Selected[0] = null;
            Selected[1] = null;
            Selected[2] = null;
            Selected[3] = null;
            Selected[4] = "selected";
            break;
        default:
            Sites = Sites + "01427207,01427510,01434000,01438500,01457500,01463500,04073365,04073500,04082400,04084445,";
            Sites = Sites + "040851385,05344500,05378500,05389500,05391000,05395000,05404000,05407000,05420500,";
            Sites = Sites + "05543500,05543830,05545750,05551540,05552500,05558300,05568500,05586100,07010000,07020500,";
            Sites = Sites + "07022000,05051500,05054000,05082500,04269000,040851385,04010500,04024000,04024430,04027000,";
            Sites = Sites + "04027500,04040000,04045500,04059000,04059500,04067500,04069500,04071765,04085427,04086000,";
            Sites = Sites + "04087000,04092750,04095090,04102500,04121970,04122200,04122500,04137500,04142000,04157000,";
            Sites = Sites + "04159492,04165500,04174500,04176500,04193500,04195820,04198000,04199000,04199500,04200500,";
            Sites = Sites + "04201500,04208000,04212100,04213500,04218000,04231600,04249000,04260500,04263000,04265432,";
            Sites = Sites + "01578310,01646580,02226160,02470500,04264331,07374525,07381495,08475000,09522000,11303500,";
            Sites = Sites + "11447650,14246900,15565447";
            Lat = "41.18997026";
            Long = "-96.73343980";
            Scale = 4;
            Selected[0] = "selected";
            Selected[1] = null;
            Selected[2] = null;
            Selected[3] = null;
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

    <meta http-equiv="content-type" content="text/html; charset=UTF-8"/>

    <title>OGC Services</title>

    <style type="text/css">
        body {
/*                background: #f0f0f0;*/
                margin: 8px;
                padding: 0;
/*                font: 12px normal Verdana, Arial, Helvetica, sans-serif;*/
/*                color: #444;*/
        }
        h1 {font-size: 3em;
            margin: 1px 0;
            font: 18px Helvetica;
        }
        .container {width: 900px; margin: 10px auto;}
        ul.tabs {
                margin: 0;
                padding: 0;
                float: left;
                list-style: none;
                height: 25px;
                border-bottom: 1px solid #999;
                border-left: 1px solid #999;
                width: 100%;
        }
        ul.tabs li {
                float: left;
                margin: 0;
                padding: 0;
                height: 24px;
                line-height: 24px;
                border: 1px solid #999;
                border-left: none;
                margin-bottom: -1px;
                background: #e0e0e0;
                overflow: hidden;
                position: relative;
        }
        ul.tabs li a {
                text-decoration: none;
                color: #000;
                display: block;
                font-size: 1.1em;
                padding: 0 20px;
                border: 1px solid #fff;
                outline: none;
        }
        ul.tabs li a:hover {
                background: #ccc;
        }
        html ul.tabs li.active, html ul.tabs li.active a:hover  {
                background: #fff;
                border-bottom: 1px solid #fff;
        }
        .tab_container {
                border: 1px solid #999;
                border-top: none;
                clear: both;
                float: left;
                width: 100%;
                background: #fff;
                -moz-border-radius-bottomright: 5px;
                -khtml-border-radius-bottomright: 5px;
                -webkit-border-bottom-right-radius: 5px;
                -moz-border-radius-bottomleft: 5px;
                -khtml-border-radius-bottomleft: 5px;
                -webkit-border-bottom-left-radius: 5px;
        }
        .tab_content {
                padding: 20px;
/*                font-size: 1.2em;*/
        }
/*        .tab_content h2 {
                font-weight: normal;
                padding-bottom: 10px;
                border-bottom: 1px dashed #ddd;
                font-size: 1.8em;
        }
        .tab_content h3 a{
                color: #254588;
        }*/
/*        .tab_content img {
                float: left;
                margin: 0 20px 20px 0;
                border: 1px solid #ddd;
                padding: 5px;
        }*/
        #StationName{
            width:130px;
            height:45px;
            }

</style>
    <script src="http://maps.google.com/maps?file=api&amp;v=2&amp;sensor=false&amp;key=ABQIAAAA_s7fSqhIs_dt6wGcko6mSRT0fazSD1VpH7Mi_uflQ_dFOWTAeBRRlw3A34pENLWUzwjXtIwUQHBc6Q" type="text/javascript"></script>    
    
    <script type="text/javascript"src="http://www.google.com/jsapi?key=ABQIAAAA_s7fSqhIs_dt6wGcko6mSRT0fazSD1VpH7Mi_uflQ_dFOWTAeBRRlw3A34pENLWUzwjXtIwUQHBc6Q"></script>
    <script src="js/jquery-1.6.js"></script>
    <script src="js/LoadXML.js" type="text/javascript"></script>
    <script src="js/parseXML.js" type="text/javascript"></script>
    <script src="js/mapiconmaker.js" type="text/javascript"></script>
    <script src="js/CreateMarker.js" type="text/javascript"></script>
    <script src="js/LoadXMLGDA.js" type="text/javascript"></script>

    <script type="text/javascript">

        $(document).ready(function() {

                //Default Action
                $(".tab_content").hide(); //Hide all content
                $("ul.tabs li:first").addClass("active").show(); //Activate first tab
                $(".tab_content:first").show(); //Show first tab content

                //On Click Event
                $("ul.tabs li").click(function() {
                        $("ul.tabs li").removeClass("active"); //Remove any "active" class
                        $(this).addClass("active"); //Add "active" class to selected tab
                        $(".tab_content").hide(); //Hide all tab content
                        var activeTab = $(this).find("a").attr("href"); //Find the rel attribute value to identify the active tab + content
                        $(activeTab).fadeIn(); //Fade in the active content
                        return false;
                });

        });


    </script>

  </head>

  <body onunload="GUnload()">

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

<!===============================Create Table=========================================>

    <h1>Surface Water Interoperability Experiment 1.8</h1>

    <table>
        <tr>
                   <td rowspan="2">
                   <table  style="width:135px">
                       <tr height="50">
                       </tr>
                       <tr>
                        <td rowspan="2" style="width:300px">
                            <table>
                                <tr>
                                    <td>
                                        <center><b>Navigation</b></center>
                                    </td>
                                </tr>
                                <tr height="10"></tr>
                                <tr>
                                    <td>
                                        <li><a href="<%=baseURL%>"> <b>OGC Services</b></a></li>
                                        <li><a href="<%=baseURL%>/MapFiles/Map.jsp"> Interactive Map</a></li>
                                        <li><a href="<%=baseURL%>/DischargePlot.jsp"> Timeseries Plot</a></li>
                                    </td>
                                </tr>
                            </table>

                        </td>
                       </tr>
                   </table>
                   </td>
            <td>
                <div class="container">

                    <ul class="tabs">
<!--                        <li><a href="#tabUnitValues">SOS Unit Values</a></li>-->
                        <li><a href="#tabUnitValues">SOS Unit Values</a></li>
                        <li><a href="#tabDaily">SOS Daily Values</a></li>
                        <li><a href="#tabGDA">GDA</a></li>
                        <li><a href="#tabWFS">WFS</a></li>
                        <li><a href="#tabMap">Map</a></li>
                        <li><a href="#tabMisc">Miscellaneous</a></li>
                    </ul>


                <div class="tab_container">
                        <div id="tabUnitValues" class="tab_content">
                            <font size="4" ><li><strong> Sensor Observation Service - Unit Values</strong></li> </font>
                                <p />
                                    <dl>
                                        <dt><b>GetObservation</b> - featureID(required), observedProperty(required), offering (required), beginPosition(optional), endPosition(optional), Interval(optional), Latest(optional)</dt><br />
                                        <dd>observedProperty: Discharge, GageHeight, Temperature, Precipitation, Turbidity, DO, pH </dd>
                                        <dd>beginPostion: YYYY-MM-DD, YYYY-MM, YYYY <i>(defaults to earliest record)</i></dd>
                                        <dd>endPostion: YYYY-MM-DD, YYYY-MM, YYYY <i>(defaults to most recent record)</i></dd>
                                        <dd>Interval: Today, ThisWeek <i>Future plan to implement ISO-8601 Duration option</i></dd>
                                        <dd>Latest: only the most recent data point is reported</dd>
                                        <dd>offering: UNIT <i>(defaults to UNIT)</i></dd>
                                        <br /><i>Gage height observation by feature ID and begin time:</i>
                                        <dd>
                                            <a href="<%=baseURL%>/uv/sos?request=GetObservation&featureID=01446500&observedProperty=GageHeight&offering=UNIT&beginPosition=<%=LastWeek%>"><%=baseURL%>/uv/sos?request=GetObservation&featureId=01446500&offering=UNIT&observedProperty=GageHeight&beginPosition=<%=LastWeek%></a>
                                        </dd>
                                        <br /><i>Discharge observation by feature ID and begin time:</i><br />
                                        <dd>
                                            <a href="<%=baseURL%>/uv/sos?request=GetObservation&featureID=01446500&offering=UNIT&observedProperty=Discharge&beginPosition=<%=LastWeek%>"><%=baseURL%>/uv/sos?request=GetObservation&featureId=01446500&offering=UNIT&observedProperty=Discharge&beginPosition=<%=LastWeek%></a>
                                        </dd>
                                        <br /><i>Latest discharge observation by feature ID:</i><br />
                                        <dd>
                                            <a href="<%=baseURL%>/uv/sos?request=GetObservation&featureID=05407000&offering=UNIT&observedProperty=Discharge&Latest"><%=baseURL%>/uv/sos?request=GetObservation&featureId=05407000&offering=UNIT&observedProperty=Discharge&Latest</a>
                                        </dd>
                                        <br /><i>Temperature observation by feature ID for this week:</i><br />
                                        <dd>
                                            <a href="<%=baseURL%>/uv/sos?request=GetObservation&featureID=05407000&offering=UNIT&observedProperty=Temperature&Interval=ThisWeek"><%=baseURL%>/uv/sos?request=GetObservation&featureId=05407000&offering=UNIT&observedProperty=Temperature&Interval=ThisWeek</a>
                                        </dd>
                                        <br /><i>Collection Example:</i>
                                        <dd>
                                            <a href="<%=baseURL%>/uv/sos?request=GetObservation&featureID=01446500,05082500&observedProperty=Discharge,DO&offering=UNIT&beginPosition=<%=Today%>"><%=baseURL%>/uv/sos?request=GetObservation&featureId=01446500,05082500&offering=UNIT&observedProperty=Discharge,DO&beginPosition=<%=Today%></a>
                                        </dd>

                                    </dl>
                                   <p />
                                   <dt><i>GetObservation via XML HTTP body POST:</i><br /></dt>
                                      <dd>  <form name="input" action="<%=baseURL%>/uv/sos?request=GetObservation" method="post">
                                                <textarea name="xml" rows="10" cols="90">
<?xml version="1.0" ?>
<sos:GetObservation version="2.0.0" service="SOS"
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
    <sos:featureOfInterest>01446500</sos:featureOfInterest>
    <sos:observedProperty>Discharge</sos:observedProperty>
    <sos:temporalFilter>
        <fes:ValueReference>phenomenonTime</fes:ValueReference>
        <gml:TimeInstant gml:id='beginPosition'>
            <gml:timePosition><%=LastWeek%></gml:timePosition>
        </gml:TimeInstant>
        <gml:TimeInstant gml:id='endPosition'>
            <gml:timePosition><%=Today%></gml:timePosition>
        </gml:TimeInstant>
    </sos:temporalFilter>
</sos:GetObservation>

                                                            </textarea><br />
                                                            <input type="submit" value="Submit" />
                                                        </form>
                                    </dd>
                                    <p />

                                    <dl>
                                                <dt><b>GetCapabilities</b></dt>
                                                <dd><a href="<%=baseURL%>/uv/sos?request=GetCapabilities"><%=baseURL%>/uv/sos?request=GetCapabilities</a></dd>
                                    </dl>
                                    <dl>
                                                <dt><b>DescribeSensor</b></dt>
                                                <dd><a href="<%=baseURL%>/uv/sos?request=DescribeSensor"><%=baseURL%>/uv/sos?request=DescribeSensor</a></dd>
                                    </dl>

                        </div>
                        <div id="tabDaily" class="tab_content">
                            <font size="4" ><li><strong>Sensor Observation Service - WaterML2</strong></li></font>

                            <dl>
                                <dt><b>GetObservation</b> - featureID(required), offering(required), observedProperty(required), beginPosition(optional), endPosition(optional), Interval(optional), Latest(optional)</dt><br />
                                <dd>observedProperty: Discharge, GageHeight, Temperature, Precipitation, Turbidity, DO, pH </dd>
                                <dd>offering: Unit, Mean, Maximum, Minimum, Variance, Mode, STD, SUM</dd>
                                <dd>beginPostion: YYYY-MM-DD, YYYY-MM, YYYY <i>(defaults to earliest record)</i></dd>
                                <dd>endPostion: YYYY-MM-DD, YYYY-MM, YYYY <i>(defaults to most recent record)</i></dd>
                                <dd>Interval: Today, ThisWeek, ThisYear <i>Future plan to implement ISO-8601 Duration option</i></dd>
                                <dd>Latest: only the most recent data point is reported</dd>
                                <br /><i>Daily mean discharge observation by feature ID with begin and end time:</i><br />
                                <dd>
                                    <a href="<%=baseURL%>/dv/sos?request=GetObservation&featureID=01446500&observedProperty=Discharge&beginPosition=1970-01-01&endPosition=1971-01-01&offering=Mean"><%=baseURL%>/dv/sos?request=GetObservation&featureId=01446500&observedProperty=Discharge&beginPosition=1970-01-01&endPosition=1971-01-01&offering=Mean</a>
                                </dd>
                                <br /><i>Daily maximum temperature observations by feature ID and begin time:</i><br />
                                <dd>
                                    <a href="<%=baseURL%>/dv/sos?request=GetObservation&featureID=05082500&observedProperty=Temperature&beginPosition=2010-01-01&offering=Maximum"><%=baseURL%>/dv/sos?request=GetObservation&featureId=05407000&observedProperty=Precipitation&beginPosition=2010-01-01&offering=Maximum</a>
                                </dd>
                                <br /><i>Daily mean discharge observations by feature ID this year:</i><br />
                                <dd>
                                    <a href="<%=baseURL%>/dv/sos?request=GetObservation&featureID=05082500&observedProperty=Discharge&Interval=ThisYear&offering=Mean"><%=baseURL%>/dv/sos?request=GetObservation&featureId=05407000&observedProperty=Discharge&Interval=ThisYear&offering=Mean</a>
                                </dd>
                                <br /><i>Latest daily mean discharge observations by feature ID:</i><br />
                                <dd>
                                    <a href="<%=baseURL%>/dv/sos?request=GetObservation&featureID=05082500&observedProperty=Discharge&offering=Mean&Latest"><%=baseURL%>/dv/sos?request=GetObservation&featureId=05407000&observedProperty=Discharge&offering=Mean&Latest</a>
                                </dd>
                                <br /><i>Collection Example:</i>
                                <dd>
                                    <a href="<%=baseURL%>/dv/sos?request=GetObservation&featureID=01446500,05082500&observedProperty=Discharge,DO&offering=Mean,Maximum&beginPosition=<%=LastWeek%>"><%=baseURL%>/dv/sos?request=GetObservation&featureId=01446500,05082500&offering=Mean,Maximum&observedProperty=Discharge,DO&beginPosition=<%=LastWeek%></a>
                                </dd>
                            </dl>
                            <p />
                            <dt><i>GetObservation via XML HTTP body POST:</i><br /></dt>
                            <dd>  <form name="input" action="<%=baseURL%>/dv/sos?request=GetObservation" method="post">
                                                <textarea name="xml" rows="10" cols="90">
<?xml version="1.0" ?>
<sos:GetObservation version="2.0.0" service="SOS"
    xmlns:sos="http://schemas.opengis.net/sos/2.0.0/"
    xmlns:wfs="http://www.opengis.net/wfs"
    xmlns:ogc="http://www.opengis.net/ogc"
    xmlns:gml="http://www.opengis.net/gml/3.2"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:om="http://www.opengis.net/om/2.0"
    xmlns:fes="http://www.opengis.net/fes/2.0"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xsi:schemaLocation="http://www.opengis.net/sos/2.0 http://schemas.opengis.net/sos/2.0.0/sos.xsd">
    <sos:featureOfInterest>05082500</sos:featureOfInterest>
    <sos:observedProperty>DO</sos:observedProperty>
    <sos:offering>Maximum</sos:offering>
    <sos:temporalFilter>
        <fes:ValueReference>phenomenonTime</fes:ValueReference>
        <gml:TimeInstant gml:id='beginPosition'>
            <gml:timePosition><%=LastWeek%></gml:timePosition>
        </gml:TimeInstant>
        <gml:TimeInstant gml:id='endPosition'>
            <gml:timePosition><%=Today%></gml:timePosition>
        </gml:TimeInstant>
    </sos:temporalFilter>
</sos:GetObservation>

                                                            </textarea><br />
                                                            <input type="submit" value="Submit" />
                                                        </form>
                                    </dd>
                                    <p />
                                    <dl>
                                                <dt><b>GetCapabilities</b></dt>
                                                <dd><a href="<%=baseURL%>/dv/sos?request=GetCapabilities"><%=baseURL%>/dv/sos?request=GetCapabilities</a></dd>
                                    </dl>
                                    <dl>
                                                <dt><b>DescribeSensor</b></dt>
                                                <dd><a href="<%=baseURL%>/dv/sos?request=DescribeSensor"><%=baseURL%>/dv/sos?request=DescribeSensor</a></dd>
                                    </dl>

                        </div>
                        <div id="tabGDA" class="tab_content">
                                <font size="4" ><li><strong> Get Data Availability</strong></li> </font>
                                    <dl>
                                                <dt><b>GetDataAvailability</b> - featureID, offering, and observedProperty are all optional. If not used, all the features/properties in the SWIE will be displayed.  Additionally, a bounding box is supported in the XML post.</dt>
                                                <br /><i>GetDataAvailability by feature ID and offering:</i>
                                                <dd><a href="<%=baseURL%>/dv/sos?request=GetDataAvailability&featureID=05082500&offering=mean"><%=baseURL%>/dv/sos?request=GetDataAvailability&featureID=05082500&offering=mean</a></dd>
                                                <br /><i>GetDataAvailability by observed property and feature ID:</i>
                                                <dd><a href="<%=baseURL%>/dv/sos?request=GetDataAvailability&observedProperty=Discharge&featureID=05568500"><%=baseURL%>/dv/sos?request=GetDataAvailability&observedProperty=Discharge&featureID=05568500</a></dd>
                                                <br /><i>General (very large file / long load time):</i>
                                                <dd><a href="<%=baseURL%>/dv/sos?request=GetDataAvailability"><%=baseURL%>/dv/sos?request=GetDataAvailability</a></dd>
                                                <br /><i>GetDataAvailability via XML HTTP body POST by feature ID:</i><br />
                                      <dd>  <form name="input" action="<%=baseURL%>/dv/sos?request=GetDataAvailability" method="post">
                                                <textarea name="xml" rows="10" cols="90">
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
       <sos:featureOfInterest>05082500</sos:featureOfInterest>
       <sos:observedProperty>Discharge</sos:observedProperty>
       <sos:offering>MEAN</sos:offering>
</sos:GetDataAvailability>

                                                            </textarea><br />
                                                            <input type="submit" value="Submit" />
                                                        </form>
                                    </dd>
                                      <br /><i>GetDataAvailability via XML HTTP body POST by bounding box:</i><br />
                                      <dd>  <form name="input" action="<%=baseURL%>/dv/sos?request=GetDataAvailability" method="post">
                                                <textarea name="xml" rows="10" cols="90">
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
       <sos:observedProperty>Discharge</sos:observedProperty>
       <sos:offering>MEAN</sos:offering>
       <ogc:Filter>
          <ogc:BBOX>
            <gml:Envelope>
              <gml:lowerCorner>-90 43</gml:lowerCorner>
              <gml:upperCorner>-89.2 43.7</gml:upperCorner>
            </gml:Envelope>
          </ogc:BBOX>
       </ogc:Filter>
</sos:GetDataAvailability>

                                                            </textarea><br />
                                                            <input type="submit" value="Submit" />
                                                        </form>
                                    </dd>
                                    <p />
                                    </dl>
                        </div>

                        <div id="tabWFS" class="tab_content">
                            <font size="4" ><li><strong>Web Feature Service</strong></li></font>

                                    <dl>
                                                <dt>GetCapabilities</dt>
                                                <dd><a href="<%=baseURL%>/wfs?request=GetCapabilities"><%=baseURL%>/wfs?request=GetCapabilities</a></dd>
                                    </dl>
                                    <dl>
                                                <dt>DescribeFeatureType</dt>
                                                <dd><a href="<%=baseURL%>/wfs?request=DescribeFeatureType"><%=baseURL%>/wfs?request=DescribeFeatureType</a></dd>
                                    </dl>

                                    <dt>GetFeature</dt>
                                    <dl>
                                        <dd>GetFeature by feature ID:<br />
                                        <a href="<%=baseURL%>/wfs?request=GetFeature&featureId=01446500"><%=baseURL%>/wfs?request=GetFeature&featureId=01446500</a>
                                        </dd>
                                        <p></p>
                                    </dl>
                                    <dl>
                                        <dd>GetFeature by multiple feature ID's:<br />
                                        <a href="<%=baseURL%>/wfs?request=GetFeature&featureId=01446500,05082500"><%=baseURL%>/wfs?request=GetFeature&featureId=01446500,05082500</a>
                                        </dd>
                                        <p></p>
                                    </dl>
                                        <dl>
                                        <dd>GetFeature by bounding box via XML HTTP body POST (maximum of 150 features):<br />

                                        <form name="input" action="<%=baseURL%>/wfs?request=GetFeature" method="post">
                                                <textarea name="xml" rows="10" cols="90">
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
          <gml:lowerCorner>-90 43</gml:lowerCorner>
          <gml:upperCorner>-89.2 43.7</gml:upperCorner>
        </gml:Envelope>
      </ogc:BBOX>
    </ogc:Filter>
  </wfs:Query>
</wfs:GetFeature>
                                                                </textarea><br></br>
                                                            <input type="submit" value="Submit" />
                                                        </form>
                                                        </dd>
                                                    </dl>
                                        <dl>
                                        <dd>GetFeature by featureID via XML HTTP body POST:<br />

                                        <form name="input" action="<%=baseURL%>/wfs?request=GetFeature" method="post">
                                                <textarea name="xml" rows="10" cols="90">
<?xml version="1.0" ?>
<wfs:GetFeature version="1.1.0" service="WFS"
        maxFeatures="3"
    xmlns:wfs="http://www.opengis.net/wfs"
    xmlns:ogc="http://www.opengis.net/ogc"
    xmlns:gml="http://www.opengis.net/gml"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <wfs:Query>
    <ogc:Filter>
        <ogc:GmlObjectId gml:id="01446500,04010500" />
    </ogc:Filter>
  </wfs:Query>
</wfs:GetFeature>
                                                                </textarea><br></br>
                                                            <input type="submit" value="Submit" />
                                                        </form>
                                                        </dd>
                                                    </dl>
                        </div>
                        <div id="tabMap" class="tab_content">
                            <center>
                                <table cellpadding="5">
                                    <tr>
                                        <th rowspan="2">
                                            <div id="map" style="width: 560px; height: 400px"></div>
                                        </th>
                                        <td valign="top">
                                            <table style="width:300px">
                                                <tr>
                                                    <td style="vertical-align:bottom"">
                                                        <i><b>Current Marker:</b></i>
                                                    </td>
                                                    <td align="right">
                                                        Number of Markers:<br />
                                                        <b><div id="FeatureNumber"></div></b>
                                                    </td>
                                                </tr>
                                            </table>
                                            <center>
                                                <div id="StationInfo" style="height:15px; width:300px">Click on a marker for GetDataAvailability demonstration</div>
                                            </center>
                                            
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div id="AvailableDataHeader"></div>
                                            <div id="AvailableData" style="overflow:auto; height: 275px;">Click on a marker for GetDataAvailability demonstration</div>
                                        </td>
                                    </tr>
                                </table>
                            </center>

                        <span> <font size="0.5"><br />* References to non-U.S. Department of the Interior (DOI) products do not constitute an endorsement by the DOI. By viewing the Google Maps API on this web site the user agrees to these
                        <a href="http://code.google.com/apis/maps/terms.html" target="_blank" title="Opens a new browser window.">Terms of Service set forth by Google</a>.<br /></font></span>
                        </div>
                    
                    <div id="tabMisc" class="tab_content">
        <li><strong>Additional Services</strong>
             <dl>
                        <dt>Example output with comments about content:</dt>
                        <dd><a href="<%=baseURL%>/sos?request=wml2_Example"><%=baseURL%>/sos?request=wml2_Example</a></dd>
            </dl>
             <dl>
                        <dt>Plot Examples:</dt>
                        <dd><a href="<%=baseURL%>/DischargePlot.jsp"><%=baseURL%>/DischargePlot.jsp</a></dd>
            </dl>
             <dl>
                        <dt>Interactive Map:</dt>
                        <dd><a href="<%=baseURL%>/MapFiles/Map.jsp"><%=baseURL%>/MapFiles/Map.jsp</a></dd>
            </dl>
            <dl>Required External Schemas<br />
                <dd>
                    <a href="WaterML2_Schemas.jsp">WaterML2 and other external schemas</a>
                </dd>
            </dl>
            <dl>CSIRO WaterML2 validation tool (external link)<br />
                <dd>
                    <a href="http://services.iwis.csiro.au/WaterML2Validation/">CSIRO WaterML2 Validation</a>
                </dd>
            </dl>
            <p />
        </li>
        <li><strong>Log</strong>
            <dl>Version 1.8 May 11th, 2011 <br />
                <dd> * Fixed spelling mistake (Availablity to Availability) </dd>
                <dd> * Included interactive map </dd>
            </dl>
            <dl>Version 1.7 May 6th, 2011 <br />
                <dd> * Added Collections wrapper to getObservations, this allows multiple features to be requested </dd>
                <dd> * Added ability for multiple properties to be requested </dd>
            </dl>
            <dl>Version 1.6 April 26th, 2011 <br />
                <dd> * Merged unit and daily getDataAvailability into one service  </dd>
                <dd> * Added bounding box to getDataAvailability </dd>
                <dd> * Added ability to call multiple features in WFS </dd>
                <dd> * Added ability to call multiple plot lines </dd>
            </dl>
<!--            <dl>Version 1.5 March 22th, 2011 <br />
                <dd> * Added offering to daily data service (getObservation and getDataAvailability  </dd>
                <dd> * Continued to try to improve the efficiency of plot displays </dd>
            </dl>-->
        </li>
            </div>
        </div>
   </div>

</td></tr>

</table>

<!--==========================Message if JavaScript is not enabled=======================-->

    <noscript><b>JavaScript must be enabled in order for you to use Google Maps.</b>
      However, it seems JavaScript is either disabled or not supported by your browser.
      To view Google Maps, enable JavaScript by changing your browser options, and then
      try again.
    </noscript>


<!--==============================With compatible browsers, do the following===============-->
        <script type="text/javascript">
//<![CDATA[
if (GBrowserIsCompatible()) {

    var clickedIcon = MapIconMaker.createMarkerIcon({primaryColor: "#660000"});
    var newIcon = MapIconMaker.createMarkerIcon({primaryColor: "#3366FF"});
    var point_ini = new GLatLng(0, 0);
    var ActiveMarker = new GMarker(point_ini, clickedIcon);
//    var Sites = '<%=Sites%>';
//    var Lat = '<%=Lat%>';
//    var Long = '<%=Long%>';
//    var Scale = <%=Scale%>;
    var base_url = '<%=baseURL%>';
    var today = '<%=Today%>';
    var LastWeekStr = '<%=LastWeek%>';

    //==========================================Create the map================================
    var map = new GMap2(document.getElementById("map"));
    map.addControl(new GLargeMapControl());
    map.addControl(new GMapTypeControl());
    map.addMapType(G_PHYSICAL_MAP);
    map.setCenter(new GLatLng(40.55972222, -95.613888889), 4, G_PHYSICAL_MAP);
//    map.setCenter(new GLatLng(Lat, Long), Scale, G_PHYSICAL_MAP);
    map.enableScrollWheelZoom();
    map.addOverlay(ActiveMarker);

    var wfs_url = base_url + "/wfs?request=GetFeature";
    xml = LoadXML(wfs_url);
//    parseXML(xml);

}
else {
    alert("Sorry, the Google Maps API is not compatible with this browser");
}
//]]>
        </script>
    <ul>
        <li> <strong>Warning </strong>
            <dt> The services provided on this page are primarily intended for surface water interoperability experiments for implementing WaterML2
            and other trial OGC standards such as SOS 2.0.  Since these standards are in flux, the output formatting on this page may change at any time.
            There is no guarantee that the output will validate with the latest standards. Check the version and log at the bottom of the page for changes and news.
            </dt>
        </li>
        <p />
    </ul>

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
        URL: <%=baseURL%><br />

       <!-- Page Contact Information: <a href="http://water.usgs.gov/user_feedback_form.html">Water Webserver Team</a><br />-->

       <script type="text/javascript">
            document.write("Last updated: " + document.lastModified +"");
        </script>
      </p>
</div>

<!-- END USGS Footer Template -->
  </body>

</html>

