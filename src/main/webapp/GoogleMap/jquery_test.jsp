<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
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
        <script type="text/javascript" src="jquery-1.4.4.js"></script>
        <script src="http://maps.google.com/maps?file=api&amp;v=2&amp;sensor=false&amp;key=ABQIAAAA_s7fSqhIs_dt6wGcko6mSRT0fazSD1VpH7Mi_uflQ_dFOWTAeBRRlw3A34pENLWUzwjXtIwUQHBc6Q" type="text/javascript"></script>
    </head>

    <body>
        <noscript><b>JavaScript must be enabled in order for you to use Google Maps.</b>
          However, it seems JavaScript is either disabled or not supported by your browser.
          To view Google Maps, enable JavaScript by changing your browser options, and then
          try again.
        </noscript>
        
        <script>

        var base = '<%=baseURL%>';
        var test = base.length - 10;    // Gets rid of /GoogleMap/ from baseURL
        var base_url = base.substring(0,test);

        $(document).ready(function(){
                //alert("Tried to load");
                $.ajax({
                    type: "GET",
                    //url: "./peakflow.xml",
                    url: "wfs_SE.xml",
                    dataType: "xml",
                    //success: parseXml,
                    success: parseXml_2,
                    error: errorHandler
               });
               //alert("finished load");
            });

            function parseXml(xml){     //this was an example for peakflow.xml
                alert("go original");
                $(xml).find("reading").each(function()
                    {
                        var vol = $(this).find("volume").text();
                        $("#date").append('<h3>Reading ID: ' + $(this).attr("id") + '</h3>');
                        var time = $(this).find("time").text();
                        $("#date").append('<br />Time = ' +time + '<br />Volume = ' + vol);
                        $("#volume").append(vol);
                    });
            }

            function parseXml_SOS(xml){
                $(xml).find("[nodeName=wml2:WaterMonitoringObservation],WaterMonitoringObservation").each(function(){
                        var units = $(this).find("[nodeName=wml2:unitOfMeasure]").attr("xlink:href");
                        var time = $(this).find("[nodeName=wml2:time]:first").text();
                        var value = $(this).find("[nodeName=wml2:value]").first().text();
                        var comment = $(this).find("[nodeName=wml2:comment]:first").text();

                        $("#date").append('Time: ' + time + 'Value: ' + value + ' ' + units + 'Comment: ' + comment + '<br />')
                });
            }

            function parseXml_2(xml){
                //alert("go namespace");

                $(xml).find("[nodeName=wfs:FeatureCollection],FeatureCollection").each(function()
                    {
                        var LowerCorner = $(this).find("[nodeName=gml:lowerCorner]").text();
                        var UpperCorner = $(this).find("[nodeName=gml:upperCorner]").text();

                        //$("#date").append('Lower Corner = ' + LowerCorner + '<br />Upper Corner = ' + UpperCorner + '<br />');

                        $(this).find("[nodeName=wfs:member],member").each(function()
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
                                var marker = test_funk(siteName, latitude, stateNM)
                                //$("#date").append(siteName + ': ' + latitude + ': ' + stateNM + '<br />');
                        });
                    });
                }

            function errorHandler(a,b,c){
                alert(a);
                alert(b);
                alert(c);
            }

            function test_funk(siteName, latitude, stateNM)
            {
                //$("#date").append(siteName + ': ' + latitude + ': ' + stateNM + '<br />');
            }

            function LoadSOSXML(filename){
                //alert("Tried to load");
                var temp = 'test';
                $.ajax({
                    type: "GET",
                    url: filename,
                    dataType: "xml",
                    success: parseXml_SOS,
                    error: errorHandler
               });
            }

            var sos_url = base_url + "/wml2?request=GetObservation&featureId=05389500&beginPosition=" + '<%=Today%>';
            LoadSOSXML(sos_url);



        </script>
        <!--<h1>"volume"</h1>-->
        <div id="date"></div>
    </body>
</html>
