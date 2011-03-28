<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<% String baseURL = request.getRequestURL().toString().replaceAll("/[^/]*$", "");%>
<%@ page  language="java" import="java.util.*,java.text.*"%>
<%
    Calendar lastWeek = new GregorianCalendar();
    lastWeek.add(Calendar.DAY_OF_YEAR, -7);

    Date now = new Date();

    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

    String todayFormated = formatter.format(now);
    String lastWeekFormated = formatter.format(lastWeek.getTime());

    String Today = todayFormated;
    String LastWeek = lastWeekFormated;
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

    <font face="Arial">
        <h1>Surface Water Interoperability Experiment USGS Gage Sites</h1>

<!===============================Create Table=========================================>
<center>
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
</center>

<!-- ===========================Create Check Boxes==================================-->
        <form action="#">
          <!--TN Rivers: <input type="checkbox" id="TNbox" onclick="boxclick(this,'TN')" />&nbsp;&nbsp;
          NC Rivers: <input type="checkbox" id="NCbox" onclick="boxclick(this,'NC')" />&nbsp;&nbsp;
          GA Rivers: <input type="checkbox" id="GAbox" onclick="boxclick(this,'GA')" />&nbsp;&nbsp;
          SC Rivers: <input type="checkbox" id="SCbox" onclick="boxclick(this,'SC')" />&nbsp;&nbsp;
          AL Rivers: <input type="checkbox" id="ALbox" onclick="boxclick(this,'AL')" /><br />-->
          NASQAN Coastal Subnetwork: <input type="checkbox" id="Coastalbox" onclick="boxclick(this,'Coastal')" />&nbsp;&nbsp;
          Inactive Gage Stations: <input type="checkbox" id="Inactivebox" onclick="boxclick(this,'Inactive')" /><br />
          WI Rivers: <input type="checkbox" id="WIbox" onclick="boxclick(this,'WI')" />&nbsp;&nbsp;
          MI Rivers: <input type="checkbox" id="MIbox" onclick="boxclick(this,'MI')" />&nbsp;&nbsp;
          PA Rivers: <input type="checkbox" id="PAbox" onclick="boxclick(this,'PA')" />&nbsp;&nbsp;
          NY Rivers: <input type="checkbox" id="NYbox" onclick="boxclick(this,'NY')" /><br />
          NJ Rivers: <input type="checkbox" id="NJbox" onclick="boxclick(this,'NJ')" />&nbsp;&nbsp;
          MN Rivers: <input type="checkbox" id="MNbox" onclick="boxclick(this,'MN')" />&nbsp;&nbsp;
          MO Rivers: <input type="checkbox" id="MObox" onclick="boxclick(this,'MO')" />&nbsp;&nbsp;
          IL Rivers: <input type="checkbox" id="ILbox" onclick="boxclick(this,'IL')" /><br />
          IA Rivers: <input type="checkbox" id="IAbox" onclick="boxclick(this,'IA')" />&nbsp;&nbsp;
          ND Rivers: <input type="checkbox" id="NDbox" onclick="boxclick(this,'ND')" />&nbsp;&nbsp;
          OH Rivers: <input type="checkbox" id="OHbox" onclick="boxclick(this,'OH')" />&nbsp;&nbsp;
          IN Rivers: <input type="checkbox" id="INbox" onclick="boxclick(this,'IN')" /><br />


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
      var today = '<%=Today%>';
      var test = base.length - 10;    // Gets rid of /GoogleMap/ from baseURL
      var base_url = base.substring(0,test);
      var LastWeekStr = '<%=LastWeek%>';

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
                            var marker = createTabbedMarker(point, siteName,  stateNM, siteCode, USGS_URL);
                            map.addOverlay(marker);
                            makeSidebar();
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
                        var marker = createTabbedMarker(point, siteName,  stateNM, siteCode, USGS_URL);
                        map.addOverlay(marker);
                        makeSidebar();
                 });
            });
        }

// ========================Create a tabbed marker============================================
      function createTabbedMarker(point, name, StateNM, Site_no, USGS_URL)
      {
	//var marker = new GMarker(point, {icon: gicons[StateNM]});
        if (StateNM == 'Coastal') {
             var newIcon = MapIconMaker.createMarkerIcon({primaryColor: "#660000"});
        }
        else {
            var newIcon = MapIconMaker.createMarkerIcon({primaryColor: "#3366FF"});
        }
        var marker = new GMarker(point, newIcon);
        marker.mycategory = StateNM;
        marker.myname = name;
        var label1 = 'Current';
	var label2 = 'DV Properties';
        var label3 = 'UV Properties';
        var site = Site_no;
        var USGS_picture = '<img src = "USGS.gif" width="84" height="32"/>';

	GEvent.addListener(marker, "click", function() {
                var sos_url = base_url + "/sos/uv?request=GetObservation&featureId=" + site + "&beginPosition=" + today + '&observedProperty=Discharge';
                $.get(sos_url, function(xml) {
                    $(xml).find("[nodeName=wml2:TimeseriesObservation],TimeseriesObservation").each(function(){
                        var watershed = $(this).find("[nodeName=om:value]").text();
                        var name = $(this).find("[nodeName=gml:name]").text();
                        var USGS_link = $(this).find("[nodeName=sf:sampledFeature]").attr("xlink:href");
                        var units = $(this).find("[nodeName=wml2:unitOfMeasure]").attr("xlink:href");
                        var time_long = $(this).find("[nodeName=wml2:time]:first").text();
                        var time = time_long.substr(0,16);
                        time = time.replace("T"," ");
                        var value = $(this).find("[nodeName=wml2:value]").first().text();
                        var comment = $(this).find("[nodeName=wml2:comment]:first").text();

                        var USGS_link = '<a href = "' + USGS_URL + '" >' + Site_no + '</a>';
                        var Title = '<table cellpadding="10"><tr><td>' + USGS_picture + '</td><td>' + USGS_link + '</td></table>';
                        var Name_html = '<b>' + name + '</b><br />';
                        var Watershed_html = '<b>' + watershed + ' Watershed</b><br />';

                        var html_header = Title + Name_html + Watershed_html;
                        var table_1 = "<center><table border='1'><tr><th colspan='2'> Current Data:<br />" + time + '</tr></th><tr><td>Discharge</td><td>' + value + ' ' + units + ' <b>' + comment +'</b></td></tr></table></center>';

                        var html = html_header + table_1 + '<br />Available data (links to plot)***:<br /><i><font size="1">***links work in Firefox and Chrome (IE and Safari coming soon)</i></font>';
                        var gdaDV_url = base_url + "/sos/dv?request=GetDataAvailablity&featureID=" + Site_no;
                        var gdaUV_url = base_url + "/sos/uv?request=GetDataAvailablity&featureID=" + Site_no;

                        var Plot_table_UV = "<center><table border='1'><tr><td><center><b>Recent Data</b></center></td><td>Begin Time</td><td>End Time</td></tr>";
                        var Plot_table_DV = "<center><table border='1'><tr><td><b><center>Daily Mean</b></center></td><td>Begin Time</td><td>End Time</td></tr>";
                        var xml_UV = LoadXML(gdaUV_url);
                        $(xml_UV).find("[nodeName=gda:FeaturePropertyTemporalRelationship],FeaturePropertyTemporalRelationship").each(function(){
                                var Property = $(this).find("[nodeName=gda:targetProperty]");
                                var Prop = Property.attr("xlink:title");
                                var Parameter_cd_long = Property.attr("xlink:href");
                                var Parameter_cd_array = Parameter_cd_long.split("_");
                                var Parameter_cd = Parameter_cd_array[1];
                                var beginTime_long = $(this).find("[nodeName=gml:beginPosition]").text();
                                var beginTime = beginTime_long.substr(0,16);
                                var beginDate = beginTime.split(" ")[0];
                                var endTime_long = $(this).find("[nodeName=gml:endPosition]").text();
                                var endTime = endTime_long.substr(0,16);
                                var endDate = endTime.split(" ")[0];
                                var Plot_links_UV = '<a href =' + base_url + '/GoogleMap/DischargePlot.jsp?&featureID=' + site + '&observedProperty=' + Parameter_cd + ',UV&beginPosition=' + LastWeekStr + '&endPosition=' + endDate + '>' + Prop + '</a>';
                                Plot_table_UV = Plot_table_UV + '<tr><td>' + Plot_links_UV + '</td><td>' + beginDate + '</td><td>' + endDate + '</td></tr>';
                            });

                            var xml_DV = LoadXML(gdaDV_url);
                            $(xml_DV).find("[nodeName=gda:FeaturePropertyTemporalRelationship],FeaturePropertyTemporalRelationship").each(function(){
                                var Property_DV = $(this).find("[nodeName=gda:targetProperty]");
                                var Prop_DV = Property_DV.attr("xlink:title");
                                var Parameter_cd_long_DV = Property_DV.attr("xlink:href");
                                var Parameter_cd_array_DV = Parameter_cd_long_DV.split("_");
                                var Parameter_cd_DV = Parameter_cd_array_DV[1];
                                var beginTime_long_DV = $(this).find("[nodeName=gml:beginPosition]").text();
                                var beginTime_DV = beginTime_long_DV.substr(0,16);
                                var beginDate_DV = beginTime_DV.split(" ")[0];
                                var endTime_long_DV = $(this).find("[nodeName=gml:endPosition]").text();
                                var endTime_DV = endTime_long_DV.substr(0,16);
                                var endDate_DV = endTime_DV.split(" ")[0];
                                var endDateYear = parseInt(endTime_DV.split("-")[0]) - 1;
                                var beginDateLink = endDateYear.toString() + '-' + endTime_DV.split("-")[1] + '-' + endTime_DV.split("-")[2];

                                Plot_links_DV = '<a href =' + base_url + '/GoogleMap/DischargePlot.jsp?featureID=' + site + '&observedProperty=' + Parameter_cd_DV + ',DV&beginPosition=' + beginDateLink + '&endPosition=' + endDate_DV + '>' + Prop_DV + '</a>';
                                Plot_table_DV = Plot_table_DV + '<tr><td>' + Plot_links_DV + '</td><td>' + beginDate_DV + '</td><td>' + endDate_DV + '</td></tr>';
                            });

                            var table_1 = '<br />' + Plot_table_UV + '</table></center><br />' + Plot_table_DV + '</table></center><br />';
                            marker.openInfoWindowTabsHtml([new GInfoWindowTab(label1,(html + table_1))]);

                        });
                    });
                });

            gmarkers.push(marker);
            return marker;
        }


       function createInactiveMarker(point, html, name, category) {
            var newIcon = MapIconMaker.createMarkerIcon({primaryColor: "#33CC66"});
            var marker = new GMarker(point, newIcon);
            marker.mycategory = category;
            marker.myname = name;
            GEvent.addListener(marker, "click", function() {
                marker.openInfoWindowHtml(html);
            });
            gmarkers.push(marker);
            return marker;
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

        GDownloadUrl("InactiveSites.csv", function(doc) {
            lines = doc.split("\n");
            for (var i = 0; i < lines.length; i++) {
                if (lines[i].length > 1) {
                    parts = lines[i].split(",");
                    var Lat = parseFloat(parts[0]);
                    var Long = parseFloat(parts[1]);
                    var name_in = parts[2];
                    var point = new GLatLng(Lat, Long);
                    var html = "Inactive USGS site: <br />" + name_in;
                    var marker = createInactiveMarker(point, html, name_in, "Inactive");
                    map.addOverlay(marker);
                }
            }
            hide("Inactive");
        });

        var wfs_url = base_url + "/wfs?request=GetFeature";
        xml = LoadXML(wfs_url);
        parseXml(xml);
        
        xml_coastal = LoadXML("wfs_coastal.xml");
        parseXml_Coastal(xml_coastal);

        show("WI");
        show("MI");
        show("NJ");
        show("PA");
        show("MN");
        show("MO");
        show("IL");
        show("IA");
        show("ND");
        show("IN");
        show("OH");
        show("NY");
        show("Coastal");

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

        Page Last Modified: Tuesday, 16-March-2011 16:45:46 CST
      </p>
</div>

<!-- END USGS Footer Template -->
  </body>

</html>
