<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<% String baseURL = request.getRequestURL().toString().replaceAll("/[^/]*$", "");%>
<%@ page  language="java" import="java.util.*,java.text.*"%>
<%
    Calendar ca = new GregorianCalendar();
    int Day=ca.get(Calendar.DATE);
    int Year=ca.get(Calendar.YEAR);
    int Month=ca.get(Calendar.MONTH)+1;
    int old_Day = Day - 3;
    if (old_Day < 0) {
        old_Day = 1;
        };
    String Month_str = "";
    if (Month < 10) {
        Month_str = '0' + Integer.toString(Month);
        }
    else {
           Month_str = Integer.toString(Month);
       };
    String Day_str = "";
    if (old_Day < 10) {
        Day_str = '0' + Integer.toString(old_Day);
        }
    else {
        Day_str = Integer.toString(old_Day);
       };
    String Old_Date = Integer.toString(Year) + '-' + Month_str + '-' + Day_str;

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

    <title>OGC Services SWIE</title>

    <script src="http://maps.google.com/maps?file=api&amp;v=2&amp;sensor=false&amp;key=ABQIAAAA_s7fSqhIs_dt6wGcko6mSRT0fazSD1VpH7Mi_uflQ_dFOWTAeBRRlw3A34pENLWUzwjXtIwUQHBc6Q" type="text/javascript"></script>
    <script src="GoogleMap/mapiconmaker.js" type="text/javascript"></script>
    <script type="text/javascript" src="GoogleMap/jquery-1.4.4.js"></script>

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
    <font face="Arial">
    <h1>Surface Water IE 1.4</h1>
    <table border=0>
        <tr>
          <td>

            <ul>
                <li> <strong>Warning </strong>
                    <dt> The services provided on this page are primarily intended for surface water interoperability experiments for implementing WaterML2
                    and other trial OGC standards such as SOS 2.0.  Since these standards are in flux, the output formatting on this page may change at any time.
                    There is no guarantee that the output will validate with the latest standards. Check the version and log at the bottom of the page for changes and news.
                    </dt>

                </li>
                <p></p>
                <font size="4" ><li><strong> Sensor Observation Service - Instantaneous Values (UV)</strong></li> </font>
                <p />
                    <dl>
                        <dt><b>GetObservation</b> - featureID(required), beginPosition(optional), endPosition(optional), observedProperty(required)</dt>
                        <dt>Allowed observedProperty are: Discharge, GageHeight, Temperature, Precipitation</dt>
                        <dt>Not every station will have all observedProperty options available, use GetDataAvailablity to find out which stations offer which properties<br />
                        <i>Instantaneous gage height observation by feature ID and begin time:</i></dt>
                        <dd>
                            <a href="<%=baseURL%>/sos/uv?request=GetObservation&featureID=01446500&observedProperty=GageHeight&beginPosition=<%=Old_Date%>"><%=baseURL%>/sos/uv?request=GetObservation&featureId=01446500&observedProperty=GageHeight&beginPosition=<%=Old_Date%></a>
                        </dd>
                        <i>Instantaneous resolution discharge observation by feature ID and begin time:</i><br />
                        <dd>
                            <a href="<%=baseURL%>/sos/uv?request=GetObservation&featureID=01446500&observedProperty=Discharge&beginPosition=<%=Old_Date%>"><%=baseURL%>/sos/uv?request=GetObservation&featureId=01446500&observedProperty=Discharge&beginPosition=<%=Old_Date%></a>
                        </dd>
                        <i>Instantaneous temperature observation by feature ID and begin time:</i><br />
                        <dd>
                            <a href="<%=baseURL%>/sos/uv?request=GetObservation&featureID=05407000&observedProperty=Temperature&beginPosition=<%=Old_Date%>"><%=baseURL%>/sos/uv?request=GetObservation&featureId=05407000&observedProperty=Temperature&beginPosition=<%=Old_Date%></a>
                        </dd>

                    </dl>
                    <dl>
                                <dt><b>GetCapabilities</b></dt>
                                <dd><a href="<%=baseURL%>/sos/uv?request=GetCapabilities"><%=baseURL%>/sos/uv?request=GetCapabilities</a></dd>
                    </dl>
                    <dl>
                                <dt><b>DescribeSensor</b></dt>
                                <dd><a href="<%=baseURL%>/sos/uv?request=DescribeSensor"><%=baseURL%>/sos/uv?request=DescribeSensor</a></dd>
                    </dl>
                    <dl>
                                <dt><b>GetDataAvailablity</b> - featureID, observedProperty, beginPosition and endPostion are all optional. If not used, all the features/properties in the SWIE will be displayed</dt>
                                <i>General:</i>
                                <dd><a href="<%=baseURL%>/sos/uv?request=GetDataAvailablity"><%=baseURL%>/sos/uv?request=GetDataAvailablity</a></dd>
                                <i>GetDataAvailablity by feature ID:</i>
                                <dd><a href="<%=baseURL%>/sos/uv?request=GetDataAvailablity&featureID=05568500"><%=baseURL%>/sos/uv?request=GetDataAvailablity&featureID=05568500</a></dd>
                                <i>GetDataAvailablity by observed property and feature ID:</i>
                                <dd><a href="<%=baseURL%>/sos/uv?request=GetDataAvailablity&observedProperty=Discharge&featureID=05568500"><%=baseURL%>/sos/uv?request=GetDataAvailablity&observedProperty=Discharge&featureID=05568500</a></dd>
                                </dd>
                    </dl>

                    <p></p>
                    <font size="4" ><li><strong>Sensor Observation Service - Daily Mean Values (DV)</strong></li></font>
                    <p />
                    <dl>
                        <dt><b>GetObservation</b> - featureID(required), beginPosition(optional), endPosition(optional), observedProperty(required)</dt>
                        <dt>Allowed observedProperty are: Discharge, GageHeight, Temperature, Precipitation</dt>
                        <dt>Not every station will have all observedProperty options available<br />
                        <i>Daily mean discharge observation by feature ID with begin and end time:</i><br /></dt>
                        <dd>
                            <a href="<%=baseURL%>/sos/dv?request=GetObservation&featureID=01446500&observedProperty=Discharge&beginPosition=1970-01-01&endPosition=1980-01-01"><%=baseURL%>/sos/dv?request=GetObservation&featureId=01446500&observedProperty=Discharge&beginPosition=1970-01-01&endPosition=1980-01-01</a>
                        </dd>
                        <i>Daily mean precipitation observation by feature ID and begin time:</i><br />
                        <dd>
                            <a href="<%=baseURL%>/sos/dv?request=GetObservation&featureID=05407000&observedProperty=Precipitation&beginPosition=<%=Old_Date%>"><%=baseURL%>/sos/dv?request=GetObservation&featureId=05407000&observedProperty=Precipitation&beginPosition=<%=Old_Date%></a>
                        </dd>
                    </dl>

<!--                    <p />
                   <dt><i>GetObservation by via XML HTTP body POST:</i><br /></dt>
                      <dd>  <form name="input" action="<%=baseURL%>/sos/dv?request=GetObservation" method="post">
                                <textarea name="xml" rows="10" cols="90">
<?xml version="1.0" ?>
<GetObservation xmlns="http://www.opengis.net/sos/1.0"
 xmlns:ows="http://www.opengis.net/ows/1.1"
 xmlns:gml="http://www.opengis.net/gml"
 xmlns:ogc="http://www.opengis.net/ogc"
 xmlns:om="http://www.opengis.net/om/1.0"
 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xsi:schemaLocation="http://www.opengis.net/sos/1.0
 http://schemas.opengis.net/sos/1.0.0/sosGetObservation.xsd"
 service="SOS" version="1.0.0" srsName="urn:ogc:def:crs:EPSG:4326">
    <offering>Discharge</offering>
    <procedure>urn:ogc:object:feature:Sensor:IFGI:ifgi-sensor-1</procedure>
    <observedProperty>urn:ogc:def:property:OGC:Discharge</observedProperty>
    <featureOfInterest>
        <ObjectID>USGS.01446500</ObjectID>
    </featureOfInterest>
    <responseFormat>text/xml;subtype=&quot;om/1.0.0&quot;</responseFormat>
</GetObservation>
                                            </textarea><br />
                                            <input type="submit" value="Submit" />
                                        </form>
                    </dd>
                    <p />-->

                    <dl>
                                <dt><b>GetCapabilities</b></dt>
                                <dd><a href="<%=baseURL%>/sos/dv?request=GetCapabilities"><%=baseURL%>/sos/dv?request=GetCapabilities</a></dd>
                    </dl>
                    <dl>
                                <dt><b>DescribeSensor</b></dt>
                                <dd><a href="<%=baseURL%>/sos/dv?request=DescribeSensor"><%=baseURL%>/sos/dv?request=DescribeSensor</a></dd>
                    </dl>
                    <dl>
                                <dt><b>GetDataAvailablity</b> - featureID, observedProperty, beginPosition and endPostion are all optional. If not used, all the features/properties in the SWIE will be displayed</dt>
                                <i>General:</i>
                                <dd><a href="<%=baseURL%>/sos/dv?request=GetDataAvailablity"><%=baseURL%>/sos/dv?request=GetDataAvailablity</a></dd>
                                <i>GetDataAvailablity by feature ID:</i>
                                <dd><a href="<%=baseURL%>/sos/dv?request=GetDataAvailablity&featureID=05568500"><%=baseURL%>/sos/dv?request=GetDataAvailablity&featureID=05568500</a></dd>
                                <i>GetDataAvailablity by observed property and feature ID:</i>
                                <dd><a href="<%=baseURL%>/sos/dv?request=GetDataAvailablity&observedProperty=Discharge&featureID=05568500"><%=baseURL%>/sos/dv?request=GetDataAvailablity&observedProperty=Discharge&featureID=05568500</a></dd>
                                </dd>
                    </dl>
                    <p></p>

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
                        <dd>All features related to SWIE:<br />
                        <a href="<%=baseURL%>/wfs?request=GetFeature"><%=baseURL%>/wfs?request=GetFeature</a>
                        </dd>
                        <p></p>
                    </dl>
                    <dl>
                        <dd>GetFeature by feature ID:<br />
                        <a href="<%=baseURL%>/wfs?request=GetFeature&featureId=01446500"><%=baseURL%>/wfs?request=GetFeature&featureId=01446500</a>
                        </dd>
                        <p></p>
                    </dl>
                    <dl>
                        <dd>GetFeature via XML HTTP body POST:<br />

                        <form name="input" action="<%=baseURL%>/wfs?request=GetFeature" method="post">
                                <textarea name="xml" rows="10" cols="90">
<?xml version="1.0" ?>
<wfs:GetFeature version="1.1.0" service="WFS"
        maxFeatures="3"
    xmlns:wfs="http://www.opengis.net/wfs"
    xmlns:ogc="http://www.opengis.net/ogc"
    xmlns:gml="http://www.opengis.net/gml"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <wfs:Query typeName="swml:Discharge">
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
                                    <p></p>
                                
                                <li><strong>Additional Services</strong>
                                     <dl>
                                                <dt>Example output with comments about content:</dt>
                                                <dd><a href="<%=baseURL%>/sos?request=wml2_Example"><%=baseURL%>/sos?request=wml2_Example</a></dd>
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
                                    <p></p>

                                </li>
                                <li><strong>Log</strong>
                                   <dl>Version 1.4 March 16th, 2011 <br />
                                        <dd> * Updated GetDataObservation </dd>
                                        <dd> * Included GetObservation by XML HTTP body POST </dd>
                                    </dl>
                                    <dl>Version 1.3 March 10th, 2011 <br />
                                        <dd> * Began work on GetDataObservation </dd>
                                        <dd> * removed time from daily mean values </dd>
                                    </dl>
<!--                                    <dl>Version 1.2 February 25th, 2011 <br />
                                        <dd> * Added daily mean value option - mean daily results can be found in /sos/dv </dd>
                                        <dd> * Instantaneous values (variable resolution, depending on the station) are now found at /sos/uv </dd>
                                        <dd> * Added observedProperty option to url.  Discharge, GageHeight....</dd>
                                    </dl>-->
<!--                                    <dl>Version 1.1 February 15th, 2011 <br />
                                        <dd> * Updated maps to work in Chrome/Safari </dd>
                                        <dd> * Updated getObservation to properly account for P/A qualifiers </dd>
                                        <dd> * Updated Master Feature List </dd>
                                    </dl>-->
                                    <p></p>

                                </li>
                    </ul>
                 </td>

        <td width = 500 valign="top" >
           <div id="map" style="width: 460px; height: 360px"></div>
           Markers represent USGS gaging stations on the Mississippi, Delaware, Fox, Wisconsin, Illinois, Red River of the North, NASQAN Coastal Subnetwork, and others near the Great Lakes.
           Clicking on a marker brings up a box with the station name, and links to GetObservation, GetFeature, and the public USGS website.*<br />
           <p></p>
           <a href="<%=baseURL%>/GoogleMap/GoogleMap.jsp">Larger Google Map*</a>

        </td>
      </tr>
    </table>
    </font>

<! ==========================Message if JavaScript is not enabled=======================>

    <noscript><b>JavaScript must be enabled in order for you to use Google Maps.</b>
      However, it seems JavaScript is either disabled or not supported by your browser.
      To view Google Maps, enable JavaScript by changing your browser options, and then
      try again.
    </noscript>


<! ==============================With compatable browsers, do the following===============>
        <script>

     //<![CDATA[
        if (GBrowserIsCompatible()) {
          var gmarkers = [];
          var base_url = '<%=baseURL%>';
          var old_date = '<%=Old_Date%>';
          var wfs_url = base_url + "/wfs?request=GetFeature";

          function LoadXML(filename){
                if (window.XMLHttpRequest) {
                    xhttp = new XMLHttpRequest();
                }
                else {
                    xhttp = new ActiveXObject("Microsoft.XMLHTTP");
                }
                xhttp.open("GET", filename, false);
                xhttp.send("");

                return xhttp.responseXML;
            }

            function parseXml(xml){
                $(xml).find("[nodeName=wfs:FeatureCollection],FeatureCollection").each(function()
                    {
                        $(xml).find("[nodeName=wfs:member],member").each(function()
                        {
                                var siteName = $("[nodeName=gml:name]", this).text();
                                var pos = $("[nodeName=gml:pos]", this).text();
                                var pos_array = pos.split(" ");
                                var latitude = pos_array[0];
                                var longitude = pos_array[1];
                                var pos_name = $("[nodeName=gml:pos]", this).attr("srsName");
                                var siteCode_long = $("[nodeName=wml2:WaterMonitoringPoint]", this).attr("gml:id");
                                var siteCode_array = siteCode_long.split(".");
                                var siteCode = siteCode_array[2];
                                var USGS_URL = $("[nodeName=sf:sampledFeature]", this).attr("xlink:ref");
                                var URL_array = USGS_URL.split("/");
                                var stateNM = URL_array[3];
                                var point = new GLatLng(latitude, longitude);
                                var marker = createMarker(point, siteName,  stateNM, siteCode, USGS_URL);
                                map.addOverlay(marker);

                        });
                    });
                }

            function parseXml_Coastal(xml){
                $(xml).find("[nodeName=wfs:FeatureCollection],FeatureCollection").each(function()
                    {
                        $(xml).find("[nodeName=wfs:member],member").each(function()
                        {
                                var siteName = $("[nodeName=gml:name]", this).text();
                                var pos = $("[nodeName=gml:pos]", this).text();
                                var pos_array = pos.split(" ");
                                var latitude = pos_array[0];
                                var longitude = pos_array[1];
                                var pos_name = $("[nodeName=gml:pos]", this).attr("srsName");
                                var siteCode = $("[nodeName=wml2:WaterMonitoringPoint]", this).attr("gml:id");
                                var USGS_URL = $("[nodeName=sf:sampledFeature]", this).attr("xlink:ref");
                                var URL_array = USGS_URL.split("/");
                                var stateNM = "Coastal";
                                var point = new GLatLng(latitude, longitude);
                                var marker = createMarker(point, siteName,  stateNM, siteCode, USGS_URL);
                                map.addOverlay(marker);
                         });
                    });
                }

// ========================Create a marker============================================
            function createMarker(point, name, StateNM, Site_no, USGS_URL) {
                var newIcon = MapIconMaker.createMarkerIcon({primaryColor: "#3366FF"});
                var marker = new GMarker(point, newIcon);
                marker.mycategory = StateNM;
                marker.myname = name;
                GEvent.addListener(marker, "click", function() {
                    var html = SimpleMarkerHTML(Site_no, USGS_URL, name);
                    marker.openInfoWindowHtml(html);
                    });
                gmarkers.push(marker);
                return marker;
            }

//====================================Create Marker HTML==================================
        function SimpleMarkerHTML(Site_no, USGS_URL, Site_nm){
                    var USGS_picture = '<img src = "GoogleMap/USGS.gif" width="84" height="32"/>';                
                    var Name = '<b>' + Site_nm + '</b><br />';
                    var GetFeature = '<li><a href =' + base_url + '/wfs?request=GetFeature&featureId=' + Site_no + '>GetFeature</a></li>';
                    var USGS_link = '<a href = "' + USGS_URL + '" >' + Site_no + '</a>';
                    var Title = 'Station: ' + USGS_link + '<br />';
                    var WML2_link_uv = '<li><a href =' + base_url + '/sos/uv?request=GetObservation&featureId=' + Site_no + '&observedProperty=Discharge&beginPosition=' + old_date + '>GetObservation - Instantaneous</a></li>';
                    var WML2_link_dv = '<li><a href =' + base_url + '/sos/dv?request=GetObservation&featureId=' + Site_no + '&observedProperty=Discharge&beginPosition=' + old_date + '>GetObservation - Daily Mean</a></li>';
                    var GDA_link_dv = '<li><a href =' + base_url + '/sos/dv?request=GetDataAvailablity&featureId=' + Site_no +'>GetDataAvailablity - Daily Mean</a></li>';
                    var GDA_link_uv = '<li><a href =' + base_url + '/sos/uv?request=GetDataAvailablity&featureId=' + Site_no +'>GetDataAvailablity - Instantaneous</a></li>';
                    var html = USGS_picture + Title + Name + WML2_link_uv + WML2_link_dv + GDA_link_dv + GDA_link_uv;

                    return html
                }

//==========================================Create the map================================
      	var map = new GMap2(document.getElementById("map"));
      	map.addControl(new GLargeMapControl());
      	map.addControl(new GMapTypeControl());
      	map.addMapType(G_PHYSICAL_MAP);
        map.setCenter(new GLatLng(40.55972222, -88.613888889), 4, G_PHYSICAL_MAP);
      	map.enableScrollWheelZoom();

        xml = LoadXML(wfs_url);
        parseXml(xml);

        xml_coastal = LoadXML("GoogleMap/wfs_coastal.xml");
        parseXml_Coastal(xml_coastal);

    }
    else {
            alert("Sorry, the Google Maps API is not compatible with this browser");
        }

    //]]>

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
        URL: <%=baseURL%><br />

       <!-- Page Contact Information: <a href="http://water.usgs.gov/user_feedback_form.html">Water Webserver Team</a><br />-->

        Page Last Modified: Tuesday, 15-Feb-2011 11:45:46 CST
      </p>
</div>

<!-- END USGS Footer Template -->
  </body>

</html>

