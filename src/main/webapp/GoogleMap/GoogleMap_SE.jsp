<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<% String baseURL = request.getRequestURL().toString().replaceAll("/[^/]*$", "");%>
<html>

  <head>
    <meta name="publisher" content="USGS">
    <meta name="description" content="Home page for water resources information from the US Geological Survey.">
    <meta name="keywords" content="USGS, U.S. Geological Survey, water, earth science, hydrology, hydrologic, data, streamflow, stream, river, lake, flood, drought, quality, basin, watershed, environment, ground water, groundwater">

    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">

    <meta name="publisher" content="USGS - U.S. Geological Survey, Water Resources">
    <meta name="expires" content="never">
       <link href="/style/msie.css" rel="stylesheet" type="text/css">
   <link href="http://www.usgs.gov/styles/common.css" rel="stylesheet" type="text/css">
   <link href="/style/custom.css" rel="stylesheet" type="text/css">
   <link href="/style/leftnav.css" rel="stylesheet" type="text/css">
   <link href="/style/water.css" rel="stylesheet" type="text/css">
   <link href="/style/topnav.css" rel="stylesheet" type="text/css">
<!-- <link href="/style/media.css" rel="stylesheet" type="text/css" media="print"> -->
    <link href="/style/homepage.css" rel="stylesheet" type="text/css">

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

<body><table cellpadding="0" cellspacing="0" width="100%">
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
            <p>Center for Integrated Data Analytics</p>
    </div>
<!-- END USGS Header Template -->

            </td>
        </tr>
    </table>

    <font face="Arial">
    <h1>Southeast USGS Gage Sites</h1>
<script src="http://maps.google.com/maps?file=api&amp;v=2&amp;sensor=false&amp;key=ABQIAAAA_s7fSqhIs_dt6wGcko6mSRT0fazSD1VpH7Mi_uflQ_dFOWTAeBRRlw3A34pENLWUzwjXtIwUQHBc6Q" type="text/javascript"></script>
<!===============================Create Table=========================================>
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

<! ===========================Create Check Boxes==================================>
    <form action="#">
      TN Rivers: <input type="checkbox" id="TNbox" onclick="boxclick(this,'TN')" />&nbsp;&nbsp;
      NC Rivers: <input type="checkbox" id="NCbox" onclick="boxclick(this,'NC')" />&nbsp;&nbsp;
      GA Rivers: <input type="checkbox" id="GAbox" onclick="boxclick(this,'GA')" />&nbsp;&nbsp;
      SC Rivers: <input type="checkbox" id="SCbox" onclick="boxclick(this,'SC')" />&nbsp;&nbsp;
      AL Rivers: <input type="checkbox" id="ALbox" onclick="boxclick(this,'AL')" /><br />
      WI Rivers: <input type="checkbox" id="WIbox" onclick="boxclick(this,'WI')" />&nbsp;&nbsp;
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
      MI Rivers: <input type="checkbox" id="MIbox" onclick="boxclick(this,'MI')" /><br />
      
      Inactive Gage Stations: <input type="checkbox" id="Inactivebox" onclick="boxclick(this,'Inactive')" /><br />
    </form>

<! ==========================Message if JavaScript is not enabled=======================>

    <noscript><b>JavaScript must be enabled in order for you to use Google Maps.</b>
      However, it seems JavaScript is either disabled or not supported by your browser.
      To view Google Maps, enable JavaScript by changing your browser options, and then
      try again.
    </noscript>
    </font>

<! ==============================With compatable browsers, do the following===============>

    <script type="text/javascript">

    if (GBrowserIsCompatible()) {
      var gmarkers = [];
      var base = '<%=baseURL%>';
      var test = base.length - 10;    // Gets rid of /GoogleMap/ from baseURL
      var base_url = base.substring(0,test);

// ======================= Create an associative array of GIcons() =======================
      var gicons = [];
      gicons["WI"] = new GIcon(G_DEFAULT_ICON, "red_MarkerW.png");
      gicons["PA"] = new GIcon(G_DEFAULT_ICON, "blue_MarkerP.png");
      gicons["NJ"] = new GIcon(G_DEFAULT_ICON, "darkgreen_MarkerN.png");
      gicons["MO"] = new GIcon(G_DEFAULT_ICON, "orange_MarkerM.png");
      gicons["IL"] = new GIcon(G_DEFAULT_ICON, "orange_MarkerI.png");
      gicons["MN"] = new GIcon(G_DEFAULT_ICON, "purple_MarkerM.png");
      gicons["IA"] = new GIcon(G_DEFAULT_ICON, "yellow_MarkerI.png");
      gicons["ND"] = new GIcon(G_DEFAULT_ICON, "purple_MarkerN.png");
      gicons["OH"] = new GIcon(G_DEFAULT_ICON, "red_MarkerO.png");
      gicons["MI"] = new GIcon(G_DEFAULT_ICON, "paleblue_MarkerM.png");
      gicons["IN"] = new GIcon(G_DEFAULT_ICON, "blue_MarkerI.png");
      gicons["NY"] = new GIcon(G_DEFAULT_ICON, "green_MarkerN.png");
      gicons["TN"] = new GIcon(G_DEFAULT_ICON, "orange_MarkerT.png");
      gicons["NC"] = new GIcon(G_DEFAULT_ICON, "blue_MarkerN.png");
      gicons["AL"] = new GIcon(G_DEFAULT_ICON, "red_MarkerA.png");
      gicons["GA"] = new GIcon(G_DEFAULT_ICON, "red_MarkerG.png");
      gicons["SC"] = new GIcon(G_DEFAULT_ICON, "red_MarkerG.png");
      //gicons["Inactive"] = new GIcon(G_DEFAULT_ICON, "red_MarkerB.png");
      //gicons["ca01"] = new GIcon(G_DEFAULT_ICON, "blue_MarkerB.png");

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

//==========================================Load XML file================================
      function loadXMLDoc(dname) {
          if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
              xmlhttp = new XMLHttpRequest();
          }
          else {// code for IE6, IE5
              xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
          }
          //xmlhttp = new XMLHttpRequest();
          xmlhttp.open("GET", dname, false);
          xmlhttp.send();
          xmlDoc = xmlhttp.responseXML;
          return xmlDoc
      }

//====================================Create Marker HTML==================================
    function MarkerHTML(StateNM, Site_no, base_url, USGS_URL, Site_nm){
        var USGS_picture = '<img src = "USGS.gif" width="84" height="32"/>      ';
        var Title = 'Station: ' + Site_no + '<br />';
        var Name = '<b>' + Site_nm + '</b><br /><br />';
        var GetFeature = '<li><a href =' + base_url + '/wfs?request=GetFeature&featureId=' + Site_no + '>GetFeature from this site</a></li><br />';
        var USGS_link = '<li><a href = "' + USGS_URL + '" >Station Home Page</a></li><br />';
        var WML2_link = '<li><a href =' + base_url + '/wml2?request=GetObservation&featureId=' + Site_no + '>GetObservation from this site</a></li><br />';
        var html = USGS_picture + Title + Name + GetFeature + WML2_link + USGS_link;
        return html
    }

//==========================================Create the map================================
      	var map = new GMap2(document.getElementById("map"));
      	map.addControl(new GLargeMapControl());
      	map.addControl(new GMapTypeControl());
      	map.addMapType(G_PHYSICAL_MAP);
      	//map.setCenter(new GLatLng(35.96501528, -84.17866200), 7, G_PHYSICAL_MAP);
        map.setCenter(new GLatLng(40.55972222, -95.613888889), 4, G_PHYSICAL_MAP);
      	map.enableScrollWheelZoom();

// ====================================Read the data from xxxx.xml=========================
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

      	            var marker = createMarker(point, html, name_in, "Inactive");
      	            map.addOverlay(marker);
      	        }
      	    }
      	    hide("Inactive");
      	});

        var wfs_url = base_url + "/wfs?request=GetFeature&typename=swml:Discharge";
        xmlDoc = loadXMLDoc(wfs_url);

      	//xmlDoc = loadXMLDoc("wfs.xml");

      	var x = xmlDoc.getElementsByTagName("wfs:member");

      	var latitude = [];
      	var longitude = [];
      	var siteCode = [];
      	var siteName = [];
      	var USGS_URL = [];
      	var stateNM = [];

      	var base = '<%=baseURL%>';
      	var test = base.length - 10;    // Gets rid of /GoogleMap/ from baseURL
      	var base_url = base.substring(0, test);


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

      	    //var WML2_link = '<a href =' + base_url + '/wml2?request=GetObservation&featureId=' + siteCode[i] + '>GetObservation from this site</a>';
      	    //var USGS_link = '<a href ="' + USGS_URL[i] + '">' + siteCode[i] + '</a>';
      	    //var wfs_link = '<a href =' + base_url + '/wfs?request=GetFeature&featureId=' + siteCode[i] + '&typename=swml:Discharge>GetFeature from this site</a>';

      	    //var information = (siteName[i] + '<br />' + WML2_link + '<br />' + wfs_link + '<br />USGS Station: ' + USGS_link);
            var information = MarkerHTML(stateNM[i], siteCode[i], base_url, USGS_URL[i], siteName[i]);

      	    var point = new GLatLng(latitude[i], longitude[i]);
      	    var marker = createMarker(point, information, siteName[i], stateNM[i]);
      	    map.addOverlay(marker);
      	}

        show("WI");
        hide("NJ");
        hide("PA");
        hide("MN");
        hide("MO");
        hide("IL");
        hide("IA");
        hide("ND");
        hide("IN");
        hide("OH");
        hide("MI");
        hide("NY");
        show("TN");
        show("NC");
        show("AL");
        show("GA");
        show("SC");
        makeSidebar();

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

<!-- BEGIN USGS Footer Template -->
<br class="clear">

<p id="linksfooterbar">
	<a href="http://www.usgs.gov/" title="USGS Home page.">USGS Home</a>

	<a href="http://water.usgs.gov/" title="USGS Water Resources of the United States">Water</a>
	<a href="http://www.usgs.gov/climate_landuse/" title="USGS Climate and Land Use Change">Climate Change</a>
	<a href="http://www.usgs.gov/core_science_systems/" title="USGS Core Science Systems">Science Systems</a>
	<a href="http://www.usgs.gov/ecosystems/" title="USGS Ecosystems">Ecosystems</a>
	<a href="http://www.usgs.gov/resources_envirohealth/" title="USGS Energy, Minerals, and Environmental Health">Energy, Minerals, &amp; Env. Health</a>

	<a href="http://www.usgs.gov/natural_hazards/" title="USGS Natural Hazards">Hazards</a>
    <a href="http://internal.usgs.gov/" title="USGS Intranet home page">USGS Intranet</a>
</p>

    <div id="usgsfooter">
      <p id="usgsfooterbar">
        <a href="http://www.usgs.gov/accessibility.html" title="Accessibility Policy (Section 508)">Accessibility</a>
        <a href="http://www.usgs.gov/foia/" title="Freedom of Information Act">FOIA</a>

        <a href="http://www.usgs.gov/privacy.html" title="Privacy policies of the U.S. Geological Survey.">Privacy</a>
        <a href="http://www.usgs.gov/policies_notices.html" title="Policies and notices that govern information posted on USGS Web sites.">Policies and Notices</a>
      </p>

      <p id="usgsfootertext">
<a href="http://www.takepride.gov/"><img src="http://www.usgs.gov/images/footer_graphic_takePride.jpg" alt="Take Pride in America logo" title="Take Pride in America Home Page" width="60" height="58"></a>
		<a href="http://firstgov.gov/"><img src="http://www.usgs.gov/images/footer_graphic_usagov.jpg" alt="USA.gov logo" width="90" height="26" style="float: right; margin-right: 10px;" title="USAGov: Government Made Easy."></a>
        <a href="http://www.doi.gov/">U.S. Department of the Interior</a> |
        <a href="http://www.usgs.gov/">U.S. Geological Survey</a><br />




        URL: http://water.usgs.gov/<br />

        Page Contact Information: <a href="http://water.usgs.gov/user_feedback_form.html">Water Webserver Team</a><br />

        Page Last Modified: Thursday, 09-Dec-2010 07:40:46 EST
      </p>
    </div>
<!-- END USGS Footer Template -->

    </div>
    <!-- END CONTAINER -->


  </body>

</html>

