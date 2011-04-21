<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page  language="java" import="java.util.*,java.text.*"%>

<%
    Calendar lastWeek = new GregorianCalendar();
    Calendar lastYear = new GregorianCalendar();
    lastWeek.add(Calendar.DAY_OF_YEAR, -7);
    lastYear.add(Calendar.YEAR, -1);

    Date now = new Date();

    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

    String todayFormated = formatter.format(now);
    String lastWeekFormated = formatter.format(lastWeek.getTime());
    String lastYearFormated = formatter.format(lastYear.getTime());

    String Today = todayFormated;
    String LastWeek = lastWeekFormated;
    String LastYear = lastYearFormated;

    String baseURL = request.getRequestURL().toString().replaceAll("/[^/]*$", "");
    int test = baseURL.length() - 10;    // Gets rid of /GoogleMap/ from baseURL
    String base_url = baseURL.substring(0,test);
    String sos_url;
    String service;
    String observedProperty;
    String offering;
    String stat_cd;
    String gdaUV_url = base_url + "/sos/uv?request=GetDataAvailablity&featureID=";
    String gdaDV_url = base_url + "/sos/dv?request=GetDataAvailablity&featureID=";
    sos_url = "";
    service = "";
    stat_cd = "";
    observedProperty = "";

    String featureID = request.getParameter("featureID");
    String[] Property = request.getParameterValues("observedProperty");
    String beginPosition = request.getParameter("beginPosition");
    String endPosition = request.getParameter("endPosition");

    String[] obsProp;

    String[] stat_cdArray;
    String[] serviceArray;
    String[] sos_urlArray;
    String[] offeringArray;

    String Data_link = "";
    String mapLink = "<a href =" + base_url + ">Return home</a>";

    if (Property != null) {

        obsProp = new String[Property.length];
        stat_cdArray = new String[Property.length];
        serviceArray = new String[Property.length];
        sos_urlArray = new String[Property.length];
        offeringArray = new String[Property.length];

        for (int i = 0; i < Property.length; i++){

            obsProp[i] = Property[i].split(",")[0];
            offeringArray[i] = Property[i].split(",")[1];
            serviceArray[i] = offeringArray[i].substring(0, 2);
            stat_cdArray[i] = offeringArray[i].substring(2);

            if (serviceArray[i].equalsIgnoreCase("DV")) {
                sos_urlArray[i] = base_url + "/sos/dv?request=GetObservation&featureId=" + featureID + "&offering=" + stat_cdArray[i] + "&observedProperty=" + obsProp[i];

            } else if (serviceArray[i].equalsIgnoreCase("UV")) {
                sos_urlArray[i] = base_url + "/sos/uv?request=GetObservation&featureId=" + featureID + "&offering=UNIT&observedProperty=" + obsProp[i];
            } else {
                sos_urlArray[i] = base_url + "/sos/uv?request=GetObservation&featureId=" + featureID + "&offering=UNIT&observedProperty=" + obsProp[i];
            }

            if (beginPosition != null) {
                if (beginPosition.equalsIgnoreCase("null") || beginPosition.equalsIgnoreCase("")) {
                    sos_urlArray[i] = sos_urlArray[i];
                } else {
                    sos_urlArray[i] = sos_urlArray[i] + "&beginPosition=" + beginPosition;
                }
            }
            if (endPosition != null) {
                if (endPosition.equalsIgnoreCase("null") || endPosition.equalsIgnoreCase("")) {
                    sos_urlArray[i] = sos_urlArray[i];
                } else {
                    sos_urlArray[i] = sos_urlArray[i] + "&endPosition=" + endPosition;
                }
            }

             Data_link = Data_link + "<a href =" + sos_urlArray[i] + ">Link to plot data: offering=" + stat_cdArray[i] + "&observedProperty=" + obsProp[i] + "</a><br />";
             sos_url = sos_url + sos_urlArray[i] + ",";
             service = service + serviceArray[i] + ",";
             stat_cd = stat_cd + stat_cdArray[i] + ",";
             observedProperty = observedProperty + obsProp[i] + ",";

        }
        sos_url = sos_url.substring(0, (sos_url.length() - 1));
        service = service.substring(0, (service.length() - 1));
        stat_cd = stat_cd.substring(0, (stat_cd.length() - 1));
        observedProperty = observedProperty.substring(0, (observedProperty.length() - 1));
        gdaDV_url = gdaDV_url + featureID;
        gdaUV_url = gdaUV_url + featureID;
    } else {
        if (featureID != null) {
            sos_url = base_url + "/sos/dv?request=GetObservation&offering=00003&observedProperty=00060&Interval=ThisYear&featureID=" + featureID;
            service = "DV";
            stat_cd = "00003";
            observedProperty = "00060";
            gdaDV_url = gdaDV_url + featureID;
            gdaUV_url = gdaUV_url + featureID;
            beginPosition = LastYear;
            endPosition = Today;
                   } else {
            sos_url = base_url + "/sos/dv?request=GetObservation&featureId=05082500&offering=00003&observedProperty=00060&Interval=ThisYear";
            featureID = "05082500";
            service = "DV";
            stat_cd = "00003";
            observedProperty = "00060";
            gdaDV_url = gdaDV_url + "05082500";
            gdaUV_url = gdaUV_url + "05082500";
            beginPosition = LastYear;
            endPosition = Today;
        }
   }
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

        <title>OGC Services SWIE</title>
        <script type='text/javascript' src='https://www.google.com/jsapi'></script>
        <script type="text/javascript" src="jquery-1.5.1.js"></script>
        <script src="LoadXML.js" type="text/javascript"></script>
        <script type="text/javascript" src="createMultiPlot.js"></script>
        <script type='text/javascript'>
            var gdaDV_url = '<%=gdaDV_url%>';
            var gdaUV_url = '<%=gdaUV_url%>';

            var sos_url = '<%=sos_url%>';
            var service = '<%=service%>';
            var stat_cd = '<%=stat_cd%>';
            var observedProperty = '<%=observedProperty%>';
            var featureID = '<%=featureID%>';
            var base_url = '<%=base_url%>';

            google.load('visualization', '1', {'packages':['annotatedtimeline']});
            google.setOnLoadCallback(createMultiPlot (sos_url, gdaDV_url, gdaUV_url, service, stat_cd, observedProperty));

        </script>


        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

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
        <h1>Surface Water IE Plotting Example</h1>

                <table border="1" cellpadding="5">
                    <tr>
                        <td>
                            <div id='Station_name' ></div><br />
                            <div id='chart_div' style='width: 700px; height: 500px;'>Loading...<img alt="Spinner"  src = "ajax-loader.gif" /></div><br />
                            <table style='width: 700px'>
                                <tr>
                                    <td>
                                         Provisional data subject to revision<br /><%=Data_link%><%=mapLink%>
                                    </td>
                                    <td>
                                        Zoomed Range:
                                        <div id='Zoom' ></div>
                                    </td>
                                </tr>
                            </table>

                        </td>
                        <td style="overflow:scroll; height:500px; width:500px">
                            <div id='side_bar_header'>Loading...</div>
                            Click on the requested properties and hit the Submit button at the bottom. Alternatively, choose a new station ID, and click the 'Get New Station'
                            to re-populate available data chart.<br /><br />
                            <b>Warning!</b> Multi-line plots are supported, but choosing too much data will cause the load time to be slow.  Firefox seems to work best for large data sets.<br /><br />
                            <form action="DischargePlot.jsp" >
                                <table>
                                    <tr><td><input type="submit" value="Get New Station:" tabindex="1"/></td><td><input type="text" name="featureID" value="<%=featureID%>" tabindex="1"/></td></tr>
                                </table>
                            </form>
                            <form action="DischargePlot.jsp" >
                                <table>
                                    <tr><td><input type="hidden" name="featureID" value="<%=featureID%>"/></td></tr>
                                    <tr><td>Begin Date: </td><td><input type="text" name="beginPosition" value="<%=beginPosition%>" tabindex="2"/></td></tr>
                                    <tr><td>End Date: </td><td><input type="text" name="endPosition" value="<%=endPosition%>" tabindex="3"/></td></tr>
                                    <tr><td></td></tr>
                                </table>
                                    <div id='side_bar' style="overflow:scroll; height: 250px; width:475px">Loading...<img alt="Spinner"  src = "ajax-loader.gif" /></div><br />
                                    <input type="submit" value="Submit" tabindex="4"/>
                            </form>
                        </td>
                    </tr>
                </table>

        <span> <font size="0.5"><br />* References to non-U.S. Department of the Interior (DOI) products do not constitute an endorsement by the DOI. By viewing the Google Visualization API on this web site the user agrees to these
        <a href="http://code.google.com/apis/visualization/terms.html" target="_blank" title="Opens a new browser window.">Terms of Service set forth by Google</a>.<br /></font></span>
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

              </p>
        </div>
    </body>
</html>
