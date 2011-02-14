<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<% String baseURL = request.getRequestURL().toString().replaceAll("/[^/]*$", "");%>
<%@ page  language="java" import="java.util.*,java.text.*"%>
<%
    Calendar ca = new GregorianCalendar();
    //ca = ca.set(Calendar.DATE, -7)
    int Day=ca.get(Calendar.DATE);
    int Year=ca.get(Calendar.YEAR);
    int Month=ca.get(Calendar.MONTH)+1;
    String Today = Integer.toString(Year) + '-' + Integer.toString(Month) + '-' + Integer.toString(Day);
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

        <script type="text/javascript" src="jquery-1.4.4.js"></script>
        <script src="http://maps.google.com/maps?file=api&amp;v=2&amp;sensor=false&amp;key=ABQIAAAA_s7fSqhIs_dt6wGcko6mSRT0fazSD1VpH7Mi_uflQ_dFOWTAeBRRlw3A34pENLWUzwjXtIwUQHBc6Q" type="text/javascript"></script>
        <script src="mapiconmaker.js" type="text/javascript"></script>
    </head>

    <body>
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

        <table border=1>
          <tr>
            <td>
               <div id="map" style="width: 840px; height: 500px"></div>
            </td>
            <td width = 350 valign="top" style="text-decoration: underline; color: #4444ff;">
               <div id="side_bar" style="overflow:auto; height:500px;">></div>
            </td>
          </tr>
        </table>

<!-- ===========================Create Check Boxes==================================-->
        <form action="#">
          TN Rivers: <input type="checkbox" id="TNbox" onclick="boxclick(this,'TN')" />&nbsp;&nbsp;
          NC Rivers: <input type="checkbox" id="NCbox" onclick="boxclick(this,'NC')" />&nbsp;&nbsp;
          GA Rivers: <input type="checkbox" id="GAbox" onclick="boxclick(this,'GA')" />&nbsp;&nbsp;
          SC Rivers: <input type="checkbox" id="SCbox" onclick="boxclick(this,'SC')" />&nbsp;&nbsp;
          AL Rivers: <input type="checkbox" id="ALbox" onclick="boxclick(this,'AL')" /><br />
          WI Rivers: <input type="checkbox" id="WIbox" onclick="boxclick(this,'WI')" />&nbsp;&nbsp;
          MI Rivers: <input type="checkbox" id="MIbox" onclick="boxclick(this,'MI')" /><br />
          PA Rivers: <input type="checkbox" id="PAbox" onclick="boxclick(this,'PA')" />&nbsp;&nbsp;
          NY Rivers: <input type="checkbox" id="NYbox" onclick="boxclick(this,'NY')" />&nbsp;&nbsp;
          NJ Rivers: <input type="checkbox" id="NJbox" onclick="boxclick(this,'NJ')" /><br />
          MN Rivers: <input type="checkbox" id="MNbox" onclick="boxclick(this,'MN')" />&nbsp;&nbsp;
          MO Rivers: <input type="checkbox" id="MObox" onclick="boxclick(this,'MO')" />&nbsp;&nbsp;
          IL Rivers: <input type="checkbox" id="ILbox" onclick="boxclick(this,'IL')" />&nbsp;&nbsp;
          IA Rivers: <input type="checkbox" id="IAbox" onclick="boxclick(this,'IA')" /><br />
          ND Rivers: <input type="checkbox" id="NDbox" onclick="boxclick(this,'ND')" />&nbsp;&nbsp;
          OH Rivers: <input type="checkbox" id="OHbox" onclick="boxclick(this,'OH')" />&nbsp;&nbsp;
          IN Rivers: <input type="checkbox" id="INbox" onclick="boxclick(this,'IN')" />&nbsp;&nbsp;
          NASQAN Coastal Subnetwork: <input type="checkbox" id="Coastalbox" onclick="boxclick(this,'Coastal')" />&nbsp;&nbsp;


    <!--      Inactive Gage Stations: <input type="checkbox" id="Inactivebox" onclick="boxclick(this,'Inactive')" /><br />-->
        </form>

        <noscript><b>JavaScript must be enabled in order for you to use Google Maps.</b>
          However, it seems JavaScript is either disabled or not supported by your browser.
          To view Google Maps, enable JavaScript by changing your browser options, and then
          try again.
        </noscript>
        
        <script>
    //<![CDATA[
        if (GBrowserIsCompatible()) {
          var gmarkers = [];
          var base = '<%=baseURL%>';
          var test = base.length - 10;    // Gets rid of /GoogleMap/ from baseURL
          var base_url = base.substring(0,test);

            //$(document).ready(function(){
            function LoadXML(filename){
                $.ajax({
                    type: "GET",
                    url: filename,
                    //url:"http://nwisvaws02.er.usgs.gov/ogc-swie/wfs?request=GetFeature",
                    dataType: "xml",
                    success: parseXml,
                    error: errorHandler
               });
            }

            function LoadCoastalXML(filename){
                //alert("Tried to load");
                $.ajax({
                    type: "GET",
                    url: filename,
                    dataType: "xml",
                    success: parseXml_Coastal,
                    error: errorHandler
               });
            }

            function LoadSOSXML(filename){
                //alert("Tried to load");
                $.ajax({
                    type: "GET",
                    url: filename,
                    dataType: "xml",
                    success: parseXml_SOS,
                    error: errorHandler
               });
            }

            function parseXml(xml){
                //alert("go namespace");
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
                                var stateNM = URL_array[3];
                                var point = new GLatLng(latitude, longitude);
                                var marker = createMarker(point, siteName,  stateNM, siteCode, base_url, USGS_URL);
                                map.addOverlay(marker);

                        });
                    });
                }

            function parseXml_Coastal(xml){
                //alert("go namespace");
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
                                var marker = createMarker(point, siteName,  stateNM, siteCode, base_url, USGS_URL);
                                map.addOverlay(marker);
                         });
                    });
                }

            function errorHandler(a,b,c){
                alert(a);
                alert(b);
                alert(c);
            }

// ======================= Create an associative array of GIcons() =======================
              var gicons = [];

              gicons["WI"] = MapIconMaker.createMarkerIcon({primaryColor: "#33CC66"});
              gicons["MI"] = MapIconMaker.createMarkerIcon({primaryColor: "#3366FF"});
              gicons["TN"] = MapIconMaker.createMarkerIcon({primaryColor: "#FF9933"});
              gicons["NC"] = MapIconMaker.createMarkerIcon({primaryColor: "#3366FF"});
              gicons["AL"] = MapIconMaker.createMarkerIcon({primaryColor: "#660000"});
              gicons["GA"] = MapIconMaker.createMarkerIcon({primaryColor: "#660000"});
              gicons["SC"] = MapIconMaker.createMarkerIcon({primaryColor: "#660000"});
              gicons["PA"] = MapIconMaker.createMarkerIcon({primaryColor: "#33CC66"});
              gicons["NY"] = MapIconMaker.createMarkerIcon({primaryColor: "#3366FF"});
              gicons["NJ"] = MapIconMaker.createMarkerIcon({primaryColor: "#FF9933"});
              gicons["MN"] = MapIconMaker.createMarkerIcon({primaryColor: "#3366FF"});
              gicons["MO"] = MapIconMaker.createMarkerIcon({primaryColor: "#660000"});
              gicons["IL"] = MapIconMaker.createMarkerIcon({primaryColor: "#660000"});
              gicons["IA"] = MapIconMaker.createMarkerIcon({primaryColor: "#660000"});
              gicons["ND"] = MapIconMaker.createMarkerIcon({primaryColor: "#660000"});
              gicons["OH"] = MapIconMaker.createMarkerIcon({primaryColor: "#660000"});
              gicons["IN"] = MapIconMaker.createMarkerIcon({primaryColor: "#660000"});
              gicons["Coastal"] = MapIconMaker.createMarkerIcon({primaryColor: "#660000"});

// ========================Create a marker============================================
            function createMarker(point, name, StateNM, Site_no, base_url, USGS_URL) {
                var marker = new GMarker(point, {icon: gicons[StateNM]});
                //var newIcon = MapIconMaker.createMarkerIcon({primaryColor: "#3366FF"});
                //var marker = new GMarker(point, newIcon);
                marker.mycategory = StateNM;
                marker.myname = name;
                GEvent.addListener(marker, "click", function() {
                    var html = SimpleMarkerHTML(Site_no, base_url, USGS_URL, name);
                    marker.openInfoWindowHtml(html);
                    });
                gmarkers.push(marker);
                return marker;
            }

//====================================Create Marker HTML==================================
        function SimpleMarkerHTML(Site_no, base_url, USGS_URL, Site_nm){
                    var USGS_picture = '<img src = "USGS.gif" width="84" height="32"/>      ';
                    var Title = 'Station: ' + Site_no + '<br /><br />';
                    var Name = '<b>' + Site_nm + '</b><br /><br />';
                    var GetFeature = '<li><a href =' + base_url + '/wfs?request=GetFeature&featureId=' + Site_no + '>GetFeature</a></li>';
                    var USGS_link = '<li><a href = "' + USGS_URL + '" >Station Home Page</a></li>';
                    var WML2_link = '<li><a href =' + base_url + '/wml2?request=GetObservation&featureId=' + Site_no + '>GetObservation</a></li>';

                    var html = USGS_picture + Title + Name + GetFeature + WML2_link + USGS_link;

                    return html
                }

        function MarkerHTML(Site_no, base_url, USGS_URL, Site_nm){
            var USGS_picture = '<img src = "USGS.gif" width="84" height="32"/>      ';
            var Title = 'Station: ' + Site_no + '<br /><br />';
            var Name = '<b>' + Site_nm + '</b><br /><br />';
            var GetFeature = '<li><a href =' + base_url + '/wfs?request=GetFeature&featureId=' + Site_no + '>GetFeature</a></li>';
            var USGS_link = '<li><a href = "' + USGS_URL + '" >Station Home Page</a></li>';
            var WML2_link = '<li><a href =' + base_url + '/wml2?request=GetObservation&featureId=' + Site_no + '>GetObservation</a></li>';
            var sos_url = base_url + "/wml2?request=GetObservation&featureId=" + Site_no + '&beginPosition=' + '<%=Today%>';
            //loadSOSXML(sos_url);
            $.ajax({
                    type: "GET",
                    url: sos_url,
                    dataType: "xml",
                    success: parseXml_SOS,
                    error: errorHandler
               });

            var TimeSeries = xmlDoc_SOS.getElementsByTagName("wml2:WaterMonitoringObservation")[0].getElementsByTagName("om:result")[0].getElementsByTagName("wml2:Timeseries");
            var x = TimeSeries[0].getElementsByTagName("wml2:point")[0].getElementsByTagName("wml2:TimeValuePair");
            var Time = x[0].getElementsByTagName("wml2:time")[0].childNodes[0].nodeValue;
            var Value = x[0].getElementsByTagName("wml2:value")[0].childNodes[0].nodeValue;

            var Units = TimeSeries[0].getElementsByTagName("wml2:defaultTimeValuePair")[0].getElementsByTagName("wml2:TimeValuePair")[0].getElementsByTagName("wml2:unitOfMeasure")[0].getAttribute("xlink:href");

            if (x[0].getElementsByTagName("wml2:comment")[0]){
                var Comment = x[0].getElementsByTagName("wml2:comment")[0].childNodes[0].nodeValue;
                var html_1 = USGS_picture + Title + Name + "<table border='1'><tr><th colspan='2'> Latest Reading:<br />" + Time + '</tr></th><tr><td>Discharge:</td><td>' + Value + ' ' + Units + ' <b>' + Comment +'</b></td></tr>';
            }
            else {
                var html_1 = USGS_picture + Title + Name + "<table border='1'><tr><th colspan='2'> Latest Reading:<br />" + Time + '</tr></th><tr><td>Discharge:</td><td>' + Value + ' ' + Units + '</td></tr>';
            }

            // If we add the daily stats, this could be cool:
            //if (x[0].getElementsByTagName("wml2:mean")[0]){
            //    var Mean = x[0].getElementsByTagName("wml2:mean")[0].childNodes[0].nodeValue;
            //    var Min = x[0].getElementsByTagName("wml2:min")[0].childNodes[0].nodeValue;
            //    var Max = x[0].getElementsByTagName("wml2:max")[0].childNodes[0].nodeValue;
            //    html_1 = html_1 + '<tr><td>Historical mean for this day</td><td>' + Mean + ' ' + Units + '</td></tr>';
            //    html_1 +=  '<tr><td>Historical min for this day</td><td>' + Min + ' ' + Units + '</td></tr>';
            //    html_1 +=  '<tr><td>Historical max for this day</td><td>' + Max + ' ' + Units + '</td></tr>';
            //}

            var html_2 = '</table>' + USGS_link + '<br /><strong>WaterML2</strong><br />' + GetFeature + WML2_link;
            var html = html_1 + html_2;
            return html
        }

// ===================================== Shows markers =================================
          function show(category) {
            for (var i=0; i<gmarkers.length; i++) {
              if (gmarkers[i].mycategory == category) {
                gmarkers[i].show();
              }
            }
            document.getElementById(category+"box").checked = true;
          }

// ===================================== Hides markers ===================================
          function hide(category) {
            for (var i=0; i<gmarkers.length; i++) {
              if (gmarkers[i].mycategory == category) {
                gmarkers[i].hide();
              }
            }
            document.getElementById(category+"box").checked = false;
            map.closeInfoWindow();
          }

// =================================== Checkbox has been clicked =======================
      function boxclick(box,category) {
        if (box.checked) {
          show(category);
        } else {
          hide(category);
        }
        // == rebuild the side bar
        makeSidebar();
      }

// =======================================Click identifier ==============================
      function myclick(i) {
        GEvent.trigger(gmarkers[i], "click");
      }

//================================= Rebuilds sidebar =======================================
      function makeSidebar() {
        var html = "";
        for (var i=0; i<gmarkers.length; i++) {
          if (!gmarkers[i].isHidden()) {
            html += '<a href="javascript:myclick(' + i + ')">' + gmarkers[i].myname + '<\/a><br>';
          }
        }
        document.getElementById("side_bar").innerHTML = html;
      }

//==========================================Create the map================================
      	var map = new GMap2(document.getElementById("map"));
      	map.addControl(new GLargeMapControl());
      	map.addControl(new GMapTypeControl());
      	map.addMapType(G_PHYSICAL_MAP);
        map.setCenter(new GLatLng(40.55972222, -95.613888889), 4, G_PHYSICAL_MAP);
      	map.enableScrollWheelZoom();

        var wfs_url = base_url + "/wfs?request=GetFeature";
        LoadXML(wfs_url);
        //LoadXML("wfs_SE.xml");
        LoadCoastalXML("wfs_coastal.xml");

        show("WI");
        show("TN");
        show("NC");
        show("AL");
        show("GA");
        show("SC");
        show("MI");
        hide("NJ");
        hide("PA");
        hide("MN");
        hide("MO");
        hide("IL");
        hide("IA");
        hide("ND");
        hide("IN");
        hide("OH");
        hide("NY");
        hide("Coastal");
        makeSidebar();

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
        <br />

       <!-- Page Contact Information: <a href="http://water.usgs.gov/user_feedback_form.html">Water Webserver Team</a><br />-->

        Page Last Modified: Tuesday, 08-Feb-2011 16:45:46 CST
      </p>
</div>

<!-- END USGS Footer Template -->
  </body>

</html>
