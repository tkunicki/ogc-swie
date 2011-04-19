<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page  language="java" import="java.util.*,java.text.*"%>

<%
    String featureID = request.getParameter("featureID");
    String Property = request.getParameter("observedProperty");
    String beginPosition = request.getParameter("beginPosition");
    String endPosition = request.getParameter("endPosition");

    String observedProperty = Property.split(",")[0];
    String offering = Property.split(",")[1];
    String service = offering.substring(0,2);
    String stat_cd = offering.substring(2);

    String compare = request.getParameter("compare");

    String baseURL = request.getRequestURL().toString().replaceAll("/[^/]*$", "");
    int test = baseURL.length() - 10;    // Gets rid of /GoogleMap/ from baseURL
    String base_url = baseURL.substring(0,test);
    String sos_url;


    if (service.equalsIgnoreCase("DV")) {

        sos_url = base_url + "/sos/dv?request=GetObservation&featureId=" + featureID + "&offering=" + stat_cd;

    } else if (service.equalsIgnoreCase("UV")) {
        sos_url = base_url + "/sos/uv?request=GetObservation&featureId=" + featureID;
    } else {
        sos_url = base_url + "/sos/uv?request=GetObservation&featureId=" + featureID;
    }

    if (beginPosition != null) {
        if (beginPosition.equalsIgnoreCase("null") || beginPosition.equalsIgnoreCase("")) {
            sos_url = sos_url;
        } else {
            sos_url = sos_url + "&beginPosition=" + beginPosition;
        }
    }


    if (endPosition != null) {
        if (endPosition.equalsIgnoreCase("null") || endPosition.equalsIgnoreCase("")) {
            sos_url = sos_url;
        } else {
            sos_url = sos_url + "&endPosition=" + endPosition;
        }
    }

    if (compare == null){
        if (observedProperty == null) {
            sos_url = sos_url + "&observedProperty=Discharge";
        } else {
            sos_url = sos_url + "&observedProperty=" + observedProperty;
        }
    } else {
        sos_url = sos_url + "&observedProperty=" + observedProperty;
    }

    String Data_link = "<a href =" + sos_url + ">Link to plot data</a>";
    String mapLink = "<a href =" + base_url + ">Return home</a>";
    String gdaDV_url = base_url + "/sos/dv?request=GetDataAvailablity&featureID=" + featureID;
    String gdaUV_url = base_url + "/sos/uv?request=GetDataAvailablity&featureID=" + featureID;

%>


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
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

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

        <script type="text/javascript"  src="jquery-1.4.4.js"></script>
        <script type="text/javascript"  src="jsapi.js"></script>
        <script src="LoadXML.js" type="text/javascript"></script>
        <script src="createPlot.js" type="text/javascript" ></script>

        <title>OGC Services SWIE</title>
        


        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <title>JSP Page</title>
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
        <h1>Surface Water IE 1.5.2</h1>
<table>
    <tr><td>

            <div id="tabPlot" class="tab_content">
                <table border=1" cellpadding="5">
                    <tr>
                        <td>
                            <div id='Station_name' ></div><br />
                            <div id='chart_div' style='width: 700px; height: 500px;'>Loading...<img src = "ajax-loader.gif" /></div><br />
                            Provisional data subject to revision<br /><%=Data_link%><br /><%=mapLink%>
                        </td>
                        <td style="overflow:scroll; height:500px; width:500px">
                            <div id='side_bar_header'>Loading...</div>

                            <form action="DischargePlot.jsp" >
                                <table>
                                    <tr><td>Station ID: </td><td><input type="text" name="featureID" value="<%=featureID%>"/></td></tr>
                                    <tr><td>Begin Date: </td><td><input type="text" name="beginPosition" value="<%=beginPosition%>"/></td></tr>
                                    <tr><td>End Date: </td><td><input type="text" name="endPosition" value="<%=endPosition%>"/></td></tr>
                                    <tr><td></td></tr>
                                </table>

                                <div id='side_bar' style="overflow:scroll; height:400px">Loading...<img src = "ajax-loader.gif" /></div>
                                <input type="submit" value="Submit" />
                            </form>
                        </td>
                    </tr>
                </table>

                <span> <font size="0.5"><br />* References to non-U.S. Department of the Interior (DOI) products do not constitute an endorsement by the DOI. By viewing the Google Visualization API on this web site the user agrees to these
                        <a href="http://code.google.com/apis/visualization/terms.html" target="_blank" title="Opens a new browser window.">Terms of Service set forth by Google</a>.<br /></font></span>
                <br />
            </div>

        </td></tr>
</table>
    <ul>
        <li> <strong>Warning </strong>
            <dt> The services provided on this page are primarily intended for surface water interoperability experiments for implementing WaterML2
            and other trial OGC standards such as SOS 2.0.  Since these standards are in flux, the output formatting on this page may change at any time.
            There is no guarantee that the output will validate with the latest standards. Check the version and log at the bottom of the page for changes and news.
            </dt>
        </li>
        <p />
    </ul>
        <script type='text/javascript'>
            var sos_url = '<%=sos_url%>';
            var gdaDV_url = '<%=gdaDV_url%>';
            var gdaUV_url = '<%=gdaUV_url%>';
            var service = '<%=service%>';
            var stat_cd = '<%=stat_cd%>';
            var observedProperty = '<%=observedProperty%>';

            google.load('visualization', '1', {'packages':['annotatedtimeline']});
            google.setOnLoadCallback(createPlot (sos_url, gdaDV_url, gdaUV_url, service, stat_cd, observedProperty));

        </script>

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

              </p>
        </div>

    </body>
</html>
