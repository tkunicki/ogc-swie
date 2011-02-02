<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<% String baseURL = request.getRequestURL().toString().replaceAll("/[^/]*$", "");%>
<%@ page  language="java" import="java.util.*,java.text.*"%>
<%
    Calendar ca = new GregorianCalendar();
    //ca = ca.set(Calendar.DATE, -7)
    int Day=ca.get(Calendar.DATE);
    int Year=ca.get(Calendar.YEAR);
    int Month=ca.get(Calendar.MONTH)+1;
    int old_Day = Day - 7;
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
    <meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
    <title>OGC Services SWIE</title>
    <script src="http://maps.google.com/maps?file=api&amp;v=2&amp;sensor=false&amp;key=ABQIAAAA_s7fSqhIs_dt6wGcko6mSRT0fazSD1VpH7Mi_uflQ_dFOWTAeBRRlw3A34pENLWUzwjXtIwUQHBc6Q" type="text/javascript"></script>
    <script type="text/javascript" src="jquery-1.4.4.js">
        function httpBodyPost(url, reqTextId) {
                var reqXML = unescapeHTML(document.getElementById(reqTextId).innerHTML);
                var xhr = new XMLHttpRequest();
                xhr.open("POST", url, false);
                xhr.send(reqXML);
                // only tested in firefox, probably doesn't work in IE
                window.location="data:text/xml," + xhr.responseText;
        }

        // makes xml not entityized
        function unescapeHTML(html) {
                var tmpDiv = document.createElement("DIV");
                tmpDiv.innerHTML = html;
                return tmpDiv.textContent;
        }


    </script>


  </head>

  <body onunload="GUnload()">

<!===============================Create Table=========================================>
    <font face="Arial">
    <h1>Surface Water IE 1.0</h1>
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
                <li><strong>Sensor Observation Service</strong>
                    <dl>
                        <dt>GetObservation - featureID, beginPosition, endPosition can be specified in URL</dt>
                        <dd>Observation by feature ID:<br />
                            <a href="<%=baseURL%>/wml2?request=GetObservation&featureID=01446500"><%=baseURL%>/wml2?request=GetObservation&featureId=01446500</a>
                        </dd>
                    </dl>
                    <dl>
                        <dd>Observation by feature ID with beginTime:<br />
                            <a href="<%=baseURL%>/wml2?request=GetObservation&featureID=01446500&beginPosition=<%=Old_Date%>"><%=baseURL%>/wml2?request=GetObservation&featureId=01446500&beginPosition=<%=Old_Date%></a>
                        </dd>
                    </dl>
                    <dl>
                                <dt>GetCapabilities</dt>
                                <dd><a href="<%=baseURL%>/sos?request=GetCapabilities"><%=baseURL%>/sos?request=GetCapabilities</a></dd>
                    </dl>
                    <dl>
                                <dt>DescribeSensor</dt>
                                <dd><a href="<%=baseURL%>/sos?request=DescribeSensor"><%=baseURL%>/sos?request=DescribeSensor</a></dd>
                    </dl>
                </li>
                    <p></p>

                <li><strong>Web Feature Service</strong>
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
                        <a href="<%=baseURL%>/wfs?request=GetFeature&typename=swml:Discharge"><%=baseURL%>/wfs?request=GetFeature&typename=swml:Discharge</a>
                        </dd>
                        <p></p>
                    </dl>
                    <dl>
                        <dd>GetFeature by feature ID:<br />
                        <a href="<%=baseURL%>/wfs?request=GetFeature&typename=swml:Discharge&featureId=01446500"><%=baseURL%>/wfs?request=GetFeature&typename=swml:Discharge&featureId=01446500</a>
                        </dd>
                        <p></p>
                    </dl>
                    <dl>
                        <dd>GetFeature by via XML HTTP body POST:<br />

                        <form name="input" action="<%=baseURL%>/wfs?request=GetFeature&typename=swml:Discharge" method="post">
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
                                </li>

                                <li><strong>Additional Services</strong>
                                    <dl>Required External Schemas<br />
                                        <dd>
                                            <a href="WaterML2_Schemas.jsp">WaterML2 and other external schemas</a>
                                        </dd>
                                    </dl>
                                    <p></p>

                                </li>
                                <li><strong>Log</strong>
                                    <dl>Version 1.0 January 28, 2011 <br />
                                        <dd> Initial release </dd>
                                    </dl>
                                    <p></p>

                                </li>
                    </ul>
                 </td>

        <td width = 500 valign="top" >
           <div id="map" style="width: 460px; height: 360px"></div>
           <i> <font size ="2"> Map works in IE and Firefox.  Future versions will include Safari and Chrome</i></font><br />
           Markers represent USGS gaging stations on the Mississippi, Delaware, Fox, Wisconsin, Illinois, Red River of the North, and others near the Great Lakes.
           Clicking on a marker brings up a box with the station name, and links to GetObservation, GetFeature, and the public USGS website.<br />
           <p></p>
           <a href="<%=baseURL%>/GoogleMap/GoogleMap.jsp">Larger Google Map</a>

        </td>
      </tr>
    </table>
    </font>
<! ===========================Create Check Boxes==================================>


<! ==========================Message if JavaScript is not enabled=======================>

    <noscript><b>JavaScript must be enabled in order for you to use Google Maps.</b>
      However, it seems JavaScript is either disabled or not supported by your browser.
      To view Google Maps, enable JavaScript by changing your browser options, and then
      try again.
    </noscript>


<! ==============================With compatable browsers, do the following===============>
   <script type="text/javascript">

    if (GBrowserIsCompatible()) {
      var gmarkers = [];

// ======================= Create an associative array of GIcons() =====================
      var gicons = [];
      gicons["WI"] = new GIcon(G_DEFAULT_ICON, "GoogleMap/red_MarkerW.png");
      gicons["PA"] = new GIcon(G_DEFAULT_ICON, "GoogleMap/blue_MarkerP.png");
      gicons["NJ"] = new GIcon(G_DEFAULT_ICON, "GoogleMap/darkgreen_MarkerN.png");
      gicons["MO"] = new GIcon(G_DEFAULT_ICON, "GoogleMap/orange_MarkerM.png");
      gicons["IL"] = new GIcon(G_DEFAULT_ICON, "GoogleMap/orange_MarkerI.png");
      gicons["MN"] = new GIcon(G_DEFAULT_ICON, "GoogleMap/purple_MarkerM.png");
      gicons["IA"] = new GIcon(G_DEFAULT_ICON, "GoogleMap/yellow_MarkerI.png");
      gicons["ND"] = new GIcon(G_DEFAULT_ICON, "GoogleMap/purple_MarkerN.png");
      gicons["OH"] = new GIcon(G_DEFAULT_ICON, "GoogleMap/red_MarkerO.png");
      gicons["MI"] = new GIcon(G_DEFAULT_ICON, "GoogleMap/paleblue_MarkerM.png");
      gicons["IN"] = new GIcon(G_DEFAULT_ICON, "GoogleMap/blue_MarkerI.png");
      gicons["NY"] = new GIcon(G_DEFAULT_ICON, "GoogleMap/green_MarkerN.png");

// ========================Create a marker============================================

    function createMarker(point, html, name, category) {

        var marker = new GMarker(point, gicons[category]);
        marker.mycategory = category;
        marker.myname = name;

        GEvent.addListener(marker, "click", function() {
            marker.openInfoWindowHtml(html);
        });

        gmarkers.push(marker);
        return marker;
    }

//==========================================Load XML file================================
      	function loadXMLDoc(dname) {
            if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
                xmlhttp = new XMLHttpRequest();
            }
            else {// code for IE6, IE5
                xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
            }

            xmlhttp.open("GET", dname, false);
            xmlhttp.send();
            xmlDoc = xmlhttp.responseXML;
            return xmlDoc
        }

//==========================================Create the map================================
      	var map = new GMap2(document.getElementById("map"));
      	map.addControl(new GLargeMapControl());
      	map.addControl(new GMapTypeControl());
      	map.addMapType(G_PHYSICAL_MAP);
      	map.setCenter(new GLatLng(45.55972222, -88.613888889), 4, G_PHYSICAL_MAP);
      	map.enableScrollWheelZoom();

// ====================================Read the data from xxxx.xml=========================

        var base_url = '<%=baseURL%>';
        var wfs_url = base_url + "/wfs?request=GetFeature&typename=swml:Discharge";
        xmlDoc = loadXMLDoc(wfs_url);

      	var x = xmlDoc.getElementsByTagName("wfs:member");

      	var latitude = [];
      	var longitude = [];
      	var siteCode = [];
      	var siteName = [];
      	var USGS_URL = [];
        var stateNM = [];

      	for (i = 0; i < x.length; i++) {
      	    siteName[i] = x[i].getElementsByTagName("om:featureOfInterest")[0].getElementsByTagName("gml:name")[0].childNodes[0].nodeValue;
      	    var pos = x[i].getElementsByTagName("om:featureOfInterest")[0].getElementsByTagName("wml2:WaterMonitoringPoint")[0].getElementsByTagName("sams:shape")[0].getElementsByTagName("gml:Point")[0].getElementsByTagName("gml:pos")[0].childNodes[0].nodeValue;
      	    var pos_array = pos.split(" ");
      	    latitude[i] = pos_array[0];
      	    longitude[i] = pos_array[1];
      	    USGS_URL[i] = x[i].getElementsByTagName("om:featureOfInterest")[0].getElementsByTagName("wml2:WaterMonitoringPoint")[0].getElementsByTagName("sf:sampledFeature")[0].getAttribute("xlink:ref");
      	    var URL_array = USGS_URL[i].split("/");
            stateNM[i] = URL_array[3];
            siteCode[i] = x[i].getElementsByTagName("om:featureOfInterest")[0].getElementsByTagName("wml2:WaterMonitoringPoint")[0].getAttribute("gml:id");

      	    var WML2_link = '<a href =' + base_url + '/wml2?request=GetObservation&featureId=' + siteCode[i] + '>GetObservation from this site</a>';
      	    var USGS_link = '<a href ="' + USGS_URL[i] + '">' + siteCode[i] + '</a>';
      	    var wfs_link = '<a href =' + base_url + '/wfs?request=GetFeature&featureId=' + siteCode[i] + '&typename=swml:Discharge>GetFeature from this site</a>';

      	    var information = (siteName[i] + '<br />' + WML2_link + '<br />' + wfs_link + '<br />USGS Station: ' + USGS_link);

      	    var point = new GLatLng(latitude[i], longitude[i]);
      	    var marker = createMarker(point, information, siteName[i], stateNM[i]);
      	    map.addOverlay(marker);
      	}
}   // goes with compatiblity check

//===============================If browser is not compatible===================================

    else {
      alert("Sorry, the Google Maps API is not compatible with this browser");
    }

    // This Javascript is based on code based on examples from:
    // Community Church Javascript Team
    // http://www.bisphamchurch.org.uk/
    // http://econym.org.uk/gmap/

    </script>

  </body>

</html>

