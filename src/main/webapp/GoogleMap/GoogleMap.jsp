<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<% String baseURL = request.getRequestURL().toString().replaceAll("/[^/]*$", "");%>

<html>

  <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
    <title>USGS Gauges</title>
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
    <font face="Arial">
    <h1>Surface Water Interoperability Experiment UGSG Gauge Sites</h1>

<!===============================Create Table=========================================>
    <table border=1>
      <tr>
        <td>
           <div id="map" style="width: 840px; height: 640px"></div>
        </td>
        <td width = 350 valign="top" style="text-decoration: underline; color: #4444ff;">
           <div id="side_bar" style="overflow:auto; height:640px;">></div>
        </td>
      </tr>
    </table>

<! ===========================Create Check Boxes==================================>
    <form action="#">

      WI Rivers: <input type="checkbox" id="WIbox" onclick="boxclick(this,'WI')" />&nbsp;&nbsp;
      PA Rivers: <input type="checkbox" id="PAbox" onclick="boxclick(this,'PA')" />&nbsp;&nbsp;
      NY Rivers: <input type="checkbox" id="NYbox" onclick="boxclick(this,'NY')" />&nbsp;&nbsp;
      NJ Rivers: <input type="checkbox" id="NJbox" onclick="boxclick(this,'NJ')" /><br />
      MN Rivers: <input type="checkbox" id="MNbox" onclick="boxclick(this,'MN')" />&nbsp;&nbsp;
      MO Rivers: <input type="checkbox" id="MObox" onclick="boxclick(this,'MO')" />&nbsp;&nbsp;
      IL Rivers: <input type="checkbox" id="ILbox" onclick="boxclick(this,'IL')" />&nbsp;&nbsp;
      IA Rivers: <input type="checkbox" id="IAbox" onclick="boxclick(this,'IA')" /><br />
      ND Rivers: <input type="checkbox" id="NDbox" onclick="boxclick(this,'ND')" />&nbsp;&nbsp;
      SD Rivers: <input type="checkbox" id="SDbox" onclick="boxclick(this,'SD')" />&nbsp;&nbsp;
      OH Rivers: <input type="checkbox" id="OHbox" onclick="boxclick(this,'OH')" /><br />
      IN Rivers: <input type="checkbox" id="INbox" onclick="boxclick(this,'IN')" />&nbsp;&nbsp;
      MI Rivers: <input type="checkbox" id="MIbox" onclick="boxclick(this,'MI')" />&nbsp;&nbsp;
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
      gicons["WI"] = new GIcon(G_DEFAULT_ICON, "red_MarkerA.png");
      gicons["PA"] = new GIcon(G_DEFAULT_ICON, "blue_MarkerA.png");
      gicons["NJ"] = new GIcon(G_DEFAULT_ICON, "darkgreen_MarkerA.png");
      gicons["MO"] = new GIcon(G_DEFAULT_ICON, "orange_MarkerA.png");
      gicons["IL"] = new GIcon(G_DEFAULT_ICON, "green_MarkerA.png");
      gicons["MN"] = new GIcon(G_DEFAULT_ICON, "paleblue_MarkerA.png");
      gicons["IA"] = new GIcon(G_DEFAULT_ICON, "yellow_MarkerA.png");
      gicons["ND"] = new GIcon(G_DEFAULT_ICON, "purple_MarkerA.png");
      gicons["SD"] = new GIcon(G_DEFAULT_ICON, "brown_MarkerA.png");
      gicons["OH"] = new GIcon(G_DEFAULT_ICON, "paleblue_MarkerA.png");
      gicons["MI"] = new GIcon(G_DEFAULT_ICON, "pink_MarkerA.png");
      gicons["IN"] = new GIcon(G_DEFAULT_ICON, "blue_MarkerB.png");
      gicons["NY"] = new GIcon(G_DEFAULT_ICON, "brown_MarkerB.png");
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

//==========================================Create the map================================
      	var map = new GMap2(document.getElementById("map"));
      	map.addControl(new GLargeMapControl());
      	map.addControl(new GMapTypeControl());
      	map.addMapType(G_PHYSICAL_MAP);
      	map.setCenter(new GLatLng(44.55972222, -90.613888889), 5, G_PHYSICAL_MAP);
      	map.enableScrollWheelZoom();

// ====================================Read the data from xxxx.xml=========================

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

      	    var WML2_link = '<a href =' + base_url + '/wml2?request=GetObservation&featureId=' + siteCode[i] + '>GetObservation from this site</a>';
      	    var USGS_link = '<a href ="' + USGS_URL[i] + '">' + siteCode[i] + '</a>';
      	    var wfs_link = '<a href =' + base_url + '/wfs?request=GetFeature&featureId=' + siteCode[i] + '&typename=swml:Discharge>GetFeature from this site</a>';

      	    var information = (siteName[i] + '<br />' + WML2_link + '<br />' + wfs_link + '<br />USGS Station: ' + USGS_link);

      	    var point = new GLatLng(latitude[i], longitude[i]);
      	    var marker = createMarker(point, information, siteName[i], stateNM[i]);
      	    map.addOverlay(marker);
      	}

        show("WI");
        show("NJ");
        show("PA");
        show("MN");
        show("MO");
        show("IL");
        show("IA");
        show("ND");
        show("SD");
        show("IN");
        show("OH");
        show("MI");
        show("NY");
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
  </body>

</html>

