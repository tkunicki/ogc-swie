<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page  language="java" import="java.util.*,java.text.*"%>

<% String baseURL = request.getRequestURL().toString().replaceAll("/[^/]*$", "");%>

<% 
    String featureID = request.getParameter("featureID");
    String Property = request.getParameter("observedProperty");
    String beginPosition = request.getParameter("beginPosition");
    String endPosition = request.getParameter("endPosition");
    String offering = request.getParameter("offering");

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

        <title>OGC Services SWIE</title>
        <script type="text/javascript" src="jquery-1.4.4.js"></script>
        <script type='text/javascript' src='https://www.google.com/jsapi'></script>
        <script type='text/javascript'>
        google.load('visualization', '1', {'packages':['annotatedtimeline']});
        google.setOnLoadCallback(drawChart);

        var base = '<%=baseURL%>';
        var test = base.length - 10;    // Gets rid of /GoogleMap/ from baseURL
        var base_url = base.substring(0,test);
        var site = '<%=featureID%>';
        var Property = '<%=Property%>';
        var beginPosition = '<%=beginPosition%>';
        var endPosition = '<%=endPosition%>';
        var offering = '<%=offering%>';

        if (offering == 'DV') {
            var sos_url = base_url + "/sos/dv?request=GetObservation&featureId=" + site;
        }
        else if (offering == 'UV') {
            var sos_url = base_url + "/sos/uv?request=GetObservation&featureId=" + site;
        }
        else {
            var sos_url = base_url + "/sos/uv?request=GetObservation&featureId=" + site;
        }

        if (Property == 'null') {
            var sos_url = sos_url + '&observedProperty=Discharge';
        }
        else {
            var sos_url = sos_url + '&observedProperty=' + Property;
        }

        if (beginPosition != 'null') {
            var sos_url = sos_url + '&beginPosition=' + beginPosition;
        }

        if (endPosition != 'null') {
            var sos_url = sos_url + '&endPosition=' + endPosition;
        }
        var Data_link = '<a href =' + sos_url + '>Link to plot data</a>';

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

        function drawChart() {
            var data = new google.visualization.DataTable();

            var time = [];
            var value = [];
            var index = [];
            var name = '';
            var units = '';
            var PropertyName = '';
            var i = 0;
            var xml = LoadXML(sos_url);
            $(xml).find("[nodeName=wml2:WaterMonitoringObservation],WaterMonitoringObservation").each(function()
            {
                name = $("[nodeName=gml:name]", this).text();
                PropertyName = $("[nodeName=om:observedProperty]", this).attr("xlink:title");
                $(xml).find("[nodeName=wml2:Timeseries],Timeseries").each(function()
                {
                    units = $("[nodeName=wml2:unitOfMeasure]", this).attr("xlink:href");
                    
                    $(xml).find("[nodeName=wml2:point],point").each(function()
                            {
                                i = i + 1;
                                index[i] = i;
                                var temp = $("[nodeName=wml2:time]", this).text();
                                time[i] = temp.substr(0, 16)
                                var temp2 = $("[nodeName=wml2:value]", this).text();
                                value[i] = parseFloat(temp2);
                            });
                });
            });

            var Title = PropertyName + ' (' + units + ')';
            data.addColumn('datetime', 'Date');
            data.addColumn('number', Title);
            data.addRows(i);
            for (var j = 0; j < i; j++) {
                data.setValue(j,0,new Date(time[j]));
                data.setValue(j,1,value[j]);
            }

            var chart = new google.visualization.AnnotatedTimeLine(document.getElementById('chart_div'));
            chart.draw(data, {
                displayAnnotations: true
                });
            makeSidebar();
          }

      function makeSidebar() {
        var wfs_url = base_url + "/wfs?request=GetFeature&featureId=" + site;

        var html = '';

        var gdaDV_url = base_url + "/sos/dv?request=GetDataAvailablity&featureID=" + site;
        var gdaUV_url = base_url + "/sos/uv?request=GetDataAvailablity&featureID=" + site;

        var xml_wfs = LoadXML(wfs_url);
        $(xml_wfs).find("[nodeName=wfs:member],member").each(function(){
            var name = $("[nodeName=gml:name]", this).text();
            var Watershed = $("[nodeName=om:value]", this).text();
            var Location = $("[nodeName=gml:pos]", this).text();
            var Org = $("[nodeName=gmd:CharacterString]", this).text();
            
            html = '<b>' + name + '<br />' + Watershed + ' Watershed </b><br /><b>Location: </b>' + Location + '<br /><b>Managed by: </b>' + Org + '<br /><br />';
            var html_2 = '<b>' + name + '<br />';
            document.getElementById("Station_name").innerHTML = (html_2);
            document.getElementById("Plot_data").innerHTML = (Data_link);
        });

        var Plot_table_UV = "<table border='1'><tr><td><center><b>Recent Data</b></center></td><td>Begin date</td><td>End date</td></tr>";
        var Plot_table_DV = "<table border='1'><tr><td><b><center>Historical Data</b></center></td><td>Begin date</td><td>End date</td></tr>";
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
                var Plot_links_UV = '<a href =' + base_url + '/GoogleMap/DischargePlot.jsp?offering=UV&featureID=' + site + '&observedProperty=' + Parameter_cd + '&beginPosition=' + beginDate + '&endPosition=' + endDate + '>' + Prop + '</a>';
                Plot_table_UV = Plot_table_UV + '<tr><td>' + Plot_links_UV + '</td><td>' + beginDate + '</td><td>' + endDate + '</tr>';
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

            Plot_links_DV = '<a href =' + base_url + '/GoogleMap/DischargePlot.jsp?offering=DV&featureID=' + site + '&observedProperty=' + Parameter_cd_DV + '&beginPosition=' + beginDate_DV + '&endPosition=' + endDate_DV + '>' + Prop_DV + '</a>';
            Plot_table_DV = Plot_table_DV + '<tr><td>' + Plot_links_DV + '</td><td>' + beginDate_DV + '</td><td>' + endDate_DV + '</tr>';
                
        });

        var table_1 = 'Period of record plot links:<br />' + Plot_table_UV + '</table><br />' + Plot_table_DV + '</table><br />';

        document.getElementById("side_bar").innerHTML = (html + table_1 );
        var radio_html = '<input type="radio" name="offering" value="UV" checked/> Instantaneous<br /><input type="radio" name="offering" value="DV"/> Daily Mean<br />';

        if (offering == 'DV'){
            radio_html = '<input type="radio" name="offering" value="UV" /> Instantaneous<br /><input type="radio" name="offering" value="DV" checked/> Daily Mean<br />';
        }
        document.getElementById("radio").innerHTML = (radio_html);
        
      }

        </script>
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
        <h1>Surface Water IE Plot using GetObservation</h1>
        <center><table border=1" cellpadding="30">
            <tr>
                <td>
                    <div id='Station_name' ></div><br />
                    <div id='chart_div' style='width: 800px; height: 450px;'>Loading...</div><br />
                    Provisional data subject to revision<br />
                    <div id='Plot_data' ></div>
                </td>
                <td>
                    <div id='side_bar'style="overflow:auto">></div>
                    <table border="1" cellpadding = "10">
                        <td>
                            <form>
                                Station ID: <input type="text" name="featureID" value="<%=featureID%>"/><br />
                                Observed Property:<br />
                                <input type="text" name="observedProperty" value="<%=Property%>"/><br />
                                Begin Date: <input type="text" name="beginPosition" value="<%=beginPosition%>"/><br />
                                End Date: <input type="text" name="endPosition" value="<%=endPosition%>"/><br />
                                <div id='radio'></div>
                                <input type="submit" value="Submit" />
                            </form>
                        </td>
                    </table>

                </td>
            </tr>
        </table></center>

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

                Page Last Modified: Tuesday, 16-March-2011 16:45:46 CST
              </p>
        </div>
    </body>
</html>
