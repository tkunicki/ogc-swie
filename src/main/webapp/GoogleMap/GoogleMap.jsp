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

        <script type="text/javascript" src="jquery-1.5.1.js"></script>
        <script src="http://maps.google.com/maps?file=api&amp;v=2&amp;sensor=false&amp;key=ABQIAAAA_s7fSqhIs_dt6wGcko6mSRT0fazSD1VpH7Mi_uflQ_dFOWTAeBRRlw3A34pENLWUzwjXtIwUQHBc6Q" type="text/javascript"></script>
        <script src="mapiconmaker.js" type="text/javascript"></script>
        <script src="LoadXML.js" type="text/javascript"></script>
        <script src="CreateMarker.js" type="text/javascript"></script>
        <script src="CreateSidebarGDA.js" type="text/javascript"></script>
        <script src="createInactiveMarker.js" type="text/javascript"></script>
        <script src="parseXML.js" type="text/javascript"></script>
        <script src="parseInactiveSites.js" type="text/javascript"></script>
        <script src="parseXML_Coastal.js" type="text/javascript"></script>
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
    <table border ="1">
        <tr>
            <th rowspan="2">
                <div id="map" style="width: 700px; height: 500px"></div>
            </th>
            <td width = 350 valign="top">
                <center>
                    <br />
                    <img src = "USGS.gif" width="84" height="32"/><br /><br />
                    <div id="StationInfo" style="height:50px; width:400px">Click on a marker for data availability</div>
                </center>

            </td>
        </tr>
        <tr>
            <td>
                <div id="AvailableData" style="overflow:scroll; height: 450px; width:400px"></div>
            </td>
        </tr>
    </table>
</center>

<!-- ===========================Create Check Boxes==================================-->

        <noscript><b>JavaScript must be enabled in order for you to use Google Maps.</b>
          However, it seems JavaScript is either disabled or not supported by your browser.
          To view Google Maps, enable JavaScript by changing your browser options, and then
          try again.
        </noscript>
    </font>

        <script type="text/javascript">
if (GBrowserIsCompatible()) {

    var clickedIcon = MapIconMaker.createMarkerIcon({primaryColor: "#660000"});
    var newIcon = MapIconMaker.createMarkerIcon({primaryColor: "#3366FF"});
    var point_ini = new GLatLng(0, 0);
    var ActiveMarker = new GMarker(point_ini, clickedIcon);
    var gmarkers = [];

    var base = '<%=baseURL%>';
    var today = '<%=Today%>';
    var test = base.length - 10;    // Gets rid of /GoogleMap/ from baseURL
    var base_url = base.substring(0,test);
    var LastWeekStr = '<%=LastWeek%>';

function parseXML(xml){
    $(xml).find('[nodeName="wfs:FeatureCollection"],FeatureCollection').each(function()
    {
        $(xml).find('[nodeName="wfs:member"],member').each(function()
        {
            var siteName = $('[nodeName="gml:name"],name', this).text();
            var pos = $('[nodeName="gml:pos"],pos', this).text();
            var pos_array = pos.split(" ");
            var latitude = pos_array[0];
            var longitude = pos_array[1];
            var pos_name = $('[nodeName="gml:pos"],pos', this).attr("srsName");
            var siteCode_long = $('[nodeName="wml2:WaterMonitoringPoint"],WaterMonitoringPoint', this).attr("gml:id");
            var siteCode_array = siteCode_long.split(".");
            var siteCode = siteCode_array[2];
            var USGS_URL = $('[nodeName="sf:sampledFeature"],sampledFeature', this).attr("xlink:ref");
            var URL_array = USGS_URL.split("/");
            var stateNM = URL_array[3];
            var watershed = $('[nodeName="om:value"],value', this).text();
            var point = new GLatLng(latitude, longitude);
            var marker = createMarker(point, siteName,  stateNM, siteCode, USGS_URL, base_url, watershed);
            map.addOverlay(marker);
            makeSidebar();
        });
    });
}


    // =======================================Click identifier ==============================
    function myclick(i) {

        GEvent.trigger(gmarkers[i], "click");
    }

    //================================= Rebuilds sidebar =======================================
function makeSidebar()
{
    var html = "";
    for (var i=0; i<gmarkers.length; i++) {
        if (!gmarkers[i].isHidden()) {
            html += '<a href="javascript:myclick(' + i + ')">' + gmarkers[i].myname + '<\/a><br>';
        }
    }

    //html = createSidebarGDA(point, name, StateNM, Site_no, USGS_URL, base_url)
    document.getElementById("AvailableData").innerHTML = html;
}

function createMarker(point, name, StateNM, Site_no, USGS_URL, base_url, watershed)
{
    var marker = new GMarker(point, newIcon);

    marker.mycategory = StateNM;
    marker.myname = name;

    var label1 = 'Site information';
    var site = Site_no;

    GEvent.addListener(marker, "click", function() {

        var USGS_link = '<a href = "' + USGS_URL + '" >' + Site_no + '</a>';

        var Name_html = '<b>' + name + '</b><br />';
        var Watershed_html = '<b>' + watershed + ' Watershed</b><br />';
        var html_header = Name_html + Watershed_html;
        document.getElementById("StationInfo").innerHTML = html_header;
        document.getElementById("AvailableData").innerHTML = "Loading...";

        var sos_url = base_url + "/sos/uv?request=GetObservation&featureId=" + site + "&observedProperty=Discharge&latest";
        $.get(sos_url, function(xml) {
            $(xml).find('[nodeName="wml2:TimeseriesObservation"],TimeseriesObservation').each(function(){
                var units = $(this).find('[nodeName="wml2:unitOfMeasure"]').attr("uom");
                var time_long = $(this).find('[nodeName="wml2:time"]:first').text();
                var time = time_long.substr(0,16);
                time = time.replace("T"," ");
                var value = $(this).find('[nodeName="wml2:value"]').first().text();
                var comment = $(this).find('[nodeName="wml2:comment"]:first').text();
                var table_1 = "Latest reading:<br /><center><table border='1'><tr><td>Discharge</td><td>" + time + '</td><td>' + value + ' ' + units + ' <b>' + comment +'</b></td></tr></table></center>';

                var html = table_1 + '<br />Available data:';
                var gdaDV_url = base_url + "/sos/dv?request=GetDataAvailablity&featureID=" + Site_no + "&offering=00003";
                var gdaUV_url = base_url + "/sos/uv?request=GetDataAvailablity&featureID=" + Site_no + "&offering=UNIT";

                var Plot_table_UV = "<center><table border='1'><tr><td><center><b>Recent Data</b></center></td><td>Begin Time</td><td>End Time</td></tr>";
                var Plot_table_DV = "<center><table border='1'><tr><td><b><center>Daily Mean</b></center></td><td>Begin Time</td><td>End Time</td></tr>";
                var xml_UV = LoadXML(gdaUV_url);

                $(xml_UV).find('[nodeName="gda:FeaturePropertyTemporalRelationship"],FeaturePropertyTemporalRelationship').each(function(){
                    var Property = $(this).find('[nodeName="gda:targetProperty"],targetProperty');
                    var Prop = Property.attr("xlink:title");
                    var Parameter_cd_long = Property.attr("xlink:href");
                    var Parameter_cd_array = Parameter_cd_long.split("_");
                    var Parameter_cd = Parameter_cd_array[1];
                    var beginTime_long = $(this).find('[nodeName="gml:beginPosition"],beginPosition').text();
                    var beginTime = beginTime_long.substr(0,16);
                    var beginDate = beginTime.split(" ")[0];
                    var endTime_long = $(this).find('[nodeName="gml:endPosition"],endPosition').text();
                    var endTime = endTime_long.substr(0,16);
                    var endDate = endTime.split(" ")[0];
                    var Plot_links_UV = '<a href =' + base_url + '/GoogleMap/DischargePlot.jsp?&featureID=' + site + '&observedProperty=' + Parameter_cd + ',UVUNIT&beginPosition=' + LastWeekStr + '&endPosition=' + endDate + '>' + Prop + '</a>';
                    Plot_table_UV = Plot_table_UV + '<tr><td>' + Plot_links_UV + '</td><td>' + beginDate + '</td><td>' + endDate + '</td></tr>';
                });

                var xml_DV = LoadXML(gdaDV_url);
                $(xml_DV).find('[nodeName="gda:FeaturePropertyTemporalRelationship"],FeaturePropertyTemporalRelationship').each(function(){
                    var Property_DV = $(this).find('[nodeName="gda:targetProperty"],targetProperty');
                    var Prop_test = Property_DV.attr("xlink:title");
                    var Prop_DV = Prop_test.substring(0,Prop_test.lastIndexOf(' ('));
                    var Parameter_cd_long_DV = Property_DV.attr("xlink:href");
                    var Parameter_cd_array_DV = Parameter_cd_long_DV.split("_");
                    var Parameter_cd_DV = Parameter_cd_array_DV[1];
                    var beginTime_long_DV = $(this).find('[nodeName="gml:beginPosition"],beginPosition').text();
                    var beginTime_DV = beginTime_long_DV.substr(0,16);
                    var beginDate_DV = beginTime_DV.split(" ")[0];
                    var endTime_long_DV = $(this).find('[nodeName="gml:endPosition"],endPosition').text();
                    var endTime_DV = endTime_long_DV.substr(0,16);
                    var endDate_DV = endTime_DV.split(" ")[0];
                    var endDateYear = parseInt(endTime_DV.split("-")[0]) - 1;
                    var beginDateLink = endDateYear.toString() + '-' + endTime_DV.split("-")[1] + '-' + endTime_DV.split("-")[2];

                    Plot_links_DV = '<a href =' + base_url + '/GoogleMap/DischargePlot.jsp?featureID=' + site + '&observedProperty=' + Parameter_cd_DV + ',DV00003&beginPosition=' + beginDateLink + '&endPosition=' + endDate_DV + '>' + Prop_DV + '</a>';
                    Plot_table_DV = Plot_table_DV + '<tr><td>' + Plot_links_DV + '</td><td>' + beginDate_DV + '</td><td>' + endDate_DV + '</td></tr>';
                });

                var table_2 = html + '<br />' + Plot_table_UV + '</table></center><br />' + Plot_table_DV + '</table></center><br />';

                //marker.openInfoWindowTabsHtml([new GInfoWindowTab(label1,html)]);
                ActiveMarker.hide();
                ActiveMarker = new GMarker(point, clickedIcon);
                map.addOverlay(ActiveMarker);
                document.getElementById("AvailableData").innerHTML = table_2;


            });
        });
    });

    gmarkers.push(marker);
    return marker;
}

    //==========================================Create the map================================
    var map = new GMap2(document.getElementById("map"));
    map.addControl(new GLargeMapControl());
    map.addControl(new GMapTypeControl());
    map.addMapType(G_PHYSICAL_MAP);
    map.setCenter(new GLatLng(40.55972222, -95.613888889), 4, G_PHYSICAL_MAP);
    map.enableScrollWheelZoom();

//    parseInactiveSites();
    var wfs_url = base_url + "/wfs?request=GetFeature";
    xml = LoadXML(wfs_url);
    parseXML(xml);

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
