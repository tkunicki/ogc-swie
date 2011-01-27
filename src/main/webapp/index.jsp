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
    <script src="http://maps.google.com/maps?file=api&amp;v=2&amp;sensor=false&amp;key=ABQIAAAAPDUET0Qt7p2VcSk6JNU1sBSM5jMcmVqUpI7aqV44cW1cEECiThQYkcZUPRJn9vy_TWxWvuLoOfSFBw" type="text/javascript"></script>
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
    <h1>Services Implemented 1.0</h1>
    <table border=0>
        <tr>
          <td>

            <ul>
                <li> <strong>Warning </strong>
                    <dt> The services provided on this page are primarily intended for surface water interoperability experiments for implementing WaterML2
                    and other trial OGC standards such as SOS 2.0.  Since these standards are in flux, the output formatting on this page may change at any time.
                    There is no guarantee that the output will validate with the latest standards.
                    Check the version and log at the bottom of the page for changes and news.
                    </dt>

                </li>
                <p></p>
                <li><strong>Sensor Observation Service</strong>
                    <dl>
                        <dt>GetObservation</dt>
                        <dd>Observation by feature ID:<br />
                            <a href="<%=baseURL%>/wml2?request=GetObservation&featureId=01446500"><%=baseURL%>/wml2?request=GetObservation&featureId=01446500</a>
                        </dd>
                    </dl>
                    <dl>
                        <dd>Observation by feature ID with beginTime:<br />
                            <a href="<%=baseURL%>/wml2?request=GetObservation&featureId=01446500&beginPosition=<%=Old_Date%>"><%=baseURL%>/wml2?request=GetObservation&featureId=01446500&beginPosition=<%=Old_Date%></a>
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
           Markers represent USGS gauging stations on the Mississippi, Delaware, Fox, Wisconsin, Illinois, and Red River of the North. 
           Clicking on a marker brings up a box with the station name, and links to GetObservation, GetFeature, and the public USGS website.<br />
           <i>Does not currently work in IE</i><br>
           <p></p>
           <a href="<%=baseURL%>/GoogleMap/GoogleMap.jsp">Larger Google Map</a>

        </td>
      </tr>
    </table>

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
      gicons["WI"] = new GIcon(G_DEFAULT_ICON, "red_MarkerA.png");
      gicons["PA"] = new GIcon(G_DEFAULT_ICON, "blue_MarkerA.png");
      gicons["NJ"] = new GIcon(G_DEFAULT_ICON, "darkgreen_MarkerA.png");
      gicons["MO"] = new GIcon(G_DEFAULT_ICON, "orange_MarkerA.png");
      gicons["IL"] = new GIcon(G_DEFAULT_ICON, "green_MarkerA.png");
      gicons["MN"] = new GIcon(G_DEFAULT_ICON, "paleblue_MarkerA.png");
      gicons["IA"] = new GIcon(G_DEFAULT_ICON, "yellow_MarkerA.png");
      gicons["ND"] = new GIcon(G_DEFAULT_ICON, "purple_MarkerA.png");
      gicons["SD"] = new GIcon(G_DEFAULT_ICON, "brown_MarkerA.png");

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
      	    if (window.XMLHttpRequest) {
      	        xhttp = new XMLHttpRequest();
      	    }
      	    else {
      	        xhttp = new ActiveXObject("Microsoft.XMLHTTP");
                // This needs work...
      	    }
      	    //xhttp = new XMLHttpRequest();
            xhttp.open("GET", dname, false);
      	    xhttp.send("");

      	    return xhttp.responseXML;
      	}

//=============================== Convert state codes to postal name=====================
        function stateCD_conversion(state_cd) {
            var state_nm = [];
            state_nm = ["AL","AK","AS","AZ", "AR", "CA", "XX", "CO", "CT", "DE", "DC", "FL", "GA", "GU",
            "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO",
            "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "PR", "RI",
            "SC", "SD", "TN", "TX", "UT", "VT", "VA", "VI", "WA", "WV", "WI", "WY", "PR", "VI" ];
            var postal_nm = state_nm[(state_cd-1)];
            return postal_nm;
        }

//==========================================Create the map================================
      	var map = new GMap2(document.getElementById("map"));
      	map.addControl(new GLargeMapControl());
      	map.addControl(new GMapTypeControl());
      	map.addMapType(G_PHYSICAL_MAP);
      	map.setCenter(new GLatLng(45.55972222, -88.613888889), 4, G_PHYSICAL_MAP);
      	map.enableScrollWheelZoom();

// ====================================Read the data from xxxx.xml=========================

        xml = loadXMLDoc("wfs_2.xml");

        var length = xml.length;

        var path = [];
        path[1] = "//*[local-name()='latitude']"
        path[2] = "//*[local-name()='longitude']"
        path[3] = "//*[local-name()='siteName']"
        path[4] = "//*[local-name()='siteCode']"
        path[5] = "//*[local-name()='variableName']"
        path[6] = "//*[local-name()='value']"
        path[7] = "//*[local-name()='note'][@title='stateCd']"

        var latitude = [];
        var longitude = [];
        var siteCode = [];
        var siteName = [];
        var variableName = [];
        var value = [];
        var timeDate = [];
        var note = [];
        var State_code = [];
        var value2 = [];

        var nodes_lat = xml.evaluate(path[1], xml, null, XPathResult.ANY_TYPE, null);
        var nodes_long = xml.evaluate(path[2], xml, null, XPathResult.ANY_TYPE, null);
        var nodes_siteName = xml.evaluate(path[3], xml, null, XPathResult.ANY_TYPE, null);
        var nodes_siteCode = xml.evaluate(path[4], xml, null, XPathResult.ANY_TYPE, null);
        var nodes_variableName = xml.evaluate(path[5], xml, null, XPathResult.ANY_TYPE, null);
        var nodes_value = xml.evaluate(path[6], xml, null, XPathResult.ANY_TYPE, null);
        var nodes_note = xml.evaluate(path[7], xml, null, XPathResult.ANY_TYPE, null);

        var result_lat = nodes_lat.iterateNext();
        var result_long = nodes_long.iterateNext();
        var result_siteName = nodes_siteName.iterateNext();
        var result_siteCode = nodes_siteCode.iterateNext();
        var result_variableName = nodes_variableName.iterateNext();
        var result_value = nodes_value.iterateNext();
        var result_note = nodes_note.iterateNext();

        var i = 0;
        while (result_lat) {
            latitude[i] = result_lat.childNodes[0].nodeValue;
            longitude[i] = result_long.childNodes[0].nodeValue;
            siteName[i] = result_siteName.childNodes[0].nodeValue;
            siteCode[i] = result_siteCode.childNodes[0].nodeValue;
            timeDate[i] = result_value.getAttribute("dateTime");
            value[i] = result_value.childNodes[0].nodeValue;
            variableName[i] = result_variableName.childNodes[0].nodeValue;
            var note = result_note.childNodes[0].nodeValue;
            State_code[i] = stateCD_conversion(note);

            result_note = nodes_note.iterateNext();
            result_variableName = nodes_variableName.iterateNext();
            result_value = nodes_value.iterateNext();
            result_siteName = nodes_siteName.iterateNext();
            result_siteCode = nodes_siteCode.iterateNext();
            result_lat = nodes_lat.iterateNext();
            result_long = nodes_long.iterateNext();

            i++;
        }

        var base = '<%=baseURL%>';
        for (j = 0; j < (i - 1); j++) {
            if (latitude[j] == latitude[j + 1] & longitude[j] == longitude[j + 1] & timeDate[j] == timeDate[j + 1]) {
                var WML2_link = '<a href =' + base + '/wml2?request=GetObservation&featureId=' + siteCode[j] + '>GetObservation</a>';
                var USGS_link = '<a href = "http://waterdata.usgs.gov/' + State_code[j] + '/nwis/uv/?site_no=' + siteCode[j] + '&PARAmeter_cd=00065" >' + siteCode[j] + '</a>';
                var wfs_link = '<a href =' + base + '/wfs?request=GetFeature&featureId=' + siteCode[j] + '&typename=swml:Discharge>GetFeature</a>';
                var information = (siteName[j] + '<br>' + WML2_link + '<br>' + wfs_link + '<br>USGS Site: ' + USGS_link);
                var point = new GLatLng(latitude[j], longitude[j]);

                var marker = createMarker(point, information, siteName[j], State_code[j]);
                map.addOverlay(marker);
                j++;
            }
            else {
                var WML2_link = '<a href =' + base + '/wml2?request=GetObservation&featureId=' + siteCode[j] + '>GetObservation</a>';
                var wfs_link = '<a href =' + base + '/wfs?request=GetFeature&featureId=' + siteCode[j] + '&typename=swml:Discharge>GetFeature</a>';
                var USGS_link = '<a href = "http://waterdata.usgs.gov/' + State_code[j] + '/nwis/uv/?site_no=' + siteCode[j] + '&PARAmeter_cd=00065" >' + siteCode[j] + '</a>';
                var information = (siteName[j] + '<br>' + WML2_link + '<br>' + wfs_link + '<br>USGS Site: ' + USGS_link);
                var point = new GLatLng(latitude[j], longitude[j]);

                var marker = createMarker(point, information, siteName[j], State_code[j]);
                map.addOverlay(marker);
            }
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
