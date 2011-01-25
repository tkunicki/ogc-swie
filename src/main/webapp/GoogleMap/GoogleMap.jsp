<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<% String baseURL = request.getRequestURL().toString().replaceAll("/[^/]*$", "");%>

<html>

  <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
    <title>USGS Gauges</title>
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
      NJ Rivers: <input type="checkbox" id="NJbox" onclick="boxclick(this,'NJ')" /><br />
      MN Rivers: <input type="checkbox" id="MNbox" onclick="boxclick(this,'MN')" />&nbsp;&nbsp;
      MO Rivers: <input type="checkbox" id="MObox" onclick="boxclick(this,'MO')" />&nbsp;&nbsp;
      IL Rivers: <input type="checkbox" id="ILbox" onclick="boxclick(this,'IL')" />&nbsp;&nbsp;
      IA Rivers: <input type="checkbox" id="IAbox" onclick="boxclick(this,'IA')" /><br />
      ND Rivers: <input type="checkbox" id="NDbox" onclick="boxclick(this,'ND')" />&nbsp;&nbsp;
      SD Rivers: <input type="checkbox" id="SDbox" onclick="boxclick(this,'SD')" />&nbsp;&nbsp;
    </form>

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
    //Should figure out a default marker
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
      	map.setCenter(new GLatLng(44.55972222, -90.613888889), 5, G_PHYSICAL_MAP);
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
        var test = base.length - 10;    // Gets rid of /GoogleMap/ from baseURL
        var base_url = base.substring(0,test);

        for (j = 0; j < (i - 1); j++) {
            if (latitude[j] == latitude[j + 1] & longitude[j] == longitude[j + 1] & timeDate[j] == timeDate[j + 1]) {
                var WML2_link = '<a href =' + base_url + '/wml2?request=GetObservation&featureId=' + siteCode[j] + '>GetObservation from this site</a>';
                var USGS_link = '<a href = "http://waterdata.usgs.gov/' + State_code[j] + '/nwis/uv/?site_no=' + siteCode[j] + '&PARAmeter_cd=00065" >' + siteCode[j] + '</a>';
                var wfs_link = '<a href =' + base_url + '/wfs?request=GetFeature&featureId=' + siteCode[j] + '&typename=swml:Discharge>GetFeature from this site</a>';
                var Data_link = '<img src = "http://waterdata.usgs.gov/nwisweb/graph?site_no=' + siteCode[j] + '&parm_cd=00065" width="576" height="400" alt="USGS Water-data graph"/>';
                var information = (WML2_link + '<br>' + wfs_link + '<br>USGS Station: ' + USGS_link + '<br>' + siteName[j] + '<br>' + Data_link);
                var point = new GLatLng(latitude[j], longitude[j]);

                var data_tab_next = value[j + 1] + ' ' + variableName[j + 1] + '<br>';
                var data_tab = data_tab_next + value[j] + ' ' + variableName[j] + '<br>' + timeDate[j];

                var marker_PA = createMarker(point, information, siteName[j], State_code[j]);
                map.addOverlay(marker_PA);
                j++;
            }
            else {
                var WML2_link = '<a href =' + base_url + '/wml2?request=GetObservation&featureId=' + siteCode[j] + '>GetObservation from this site</a>';
                var wfs_link = '<a href =' + base_url + '/wfs?request=GetFeature&featureId=' + siteCode[j] + '&typename=swml:Discharge>GetFeature from this site</a>';
                var USGS_link = '<a href = "http://waterdata.usgs.gov/' + State_code[j] + '/nwis/uv/?site_no=' + siteCode[j] + '&PARAmeter_cd=00065" >' + siteCode[j] + '</a>';
                var Data_link = '<img src = "http://waterdata.usgs.gov/nwisweb/graph?site_no=' + siteCode[j] + '&parm_cd=00065" width="576" height="400" alt="USGS Water-data graph"/>';

                var information = (WML2_link + '<br>' + wfs_link + '<br>USGS Station: ' + USGS_link + '<br>' + siteName[j] + '<br>' + Data_link);
                var point = new GLatLng(latitude[j], longitude[j]);

                var data_tab = value[j] + ' ' + variableName[j] + '<br>' + timeDate[j] + '<br>';

                var marker_PA = createMarker(point, information, siteName[j], State_code[j]);
                map.addOverlay(marker_PA);
            }
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
