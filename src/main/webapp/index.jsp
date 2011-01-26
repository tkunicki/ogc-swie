<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<% String baseURL = request.getRequestURL().toString().replaceAll("/[^/]*$", "");%>
<%@ page  language="java" import="java.util.*,java.text.*"%>
<%
    Calendar ca = new GregorianCalendar();
    //ca = ca.set(Calendar.DATE, -7)
    int Day=ca.get(Calendar.DATE);
    int Year=ca.get(Calendar.YEAR);
    int Month=ca.get(Calendar.MONTH)+1;
    int old_Day = Day - 7;
    if (old_Day < 0) {
        old_Day = 1;
        };
    String Month_str = "";
    if (Month < 10) {
        Month_str = '0' + Integer.toString(Month);
        }
    else {
           Month_str = Integer.toString(Month);
       };
    String Day_str = "";
    if (old_Day < 10) {
        Day_str = '0' + Integer.toString(old_Day);
        }
    else {
        Day_str = Integer.toString(old_Day);
       };
    String Old_Date = Integer.toString(Year) + '-' + Month_str + '-' + Day_str;

 %>



<html>
	<head>
		<title>OGC Surface Water Interoperability Experiment (USGS node)</title>
		<script type="text/javascript" language="JavaScript">
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
	<body>
               <h1>Services Implemented</h1>
                    <ul>
                                <li> <strong>Warning </strong>
                                    <dt> SOS and other caveats go here....</dt>

                                </li>
                                <p></p>
                                <li><strong>Sensor Observation Service</strong>
                                    <dl>
                                        <dt>GetObservation</dt>
                                        <dd>Observation by feature ID:<br />
                                            <a href="<%=baseURL%>/wml2?request=GetObservation&featureId=01446500"><%=baseURL%>/wml2?request=GetObservation&featureId=01446500</a>
                                        </dd>
                                    </dl>
                                    <dl>
                                        <dd>Observation by feature ID with beginTime:<br />
                                            <a href="<%=baseURL%>/wml2?request=GetObservation&featureId=01446500&beginPosition=<%=Old_Date%>"><%=baseURL%>/wml2?request=GetObservation&featureId=01446500&beginPosition=<%=Old_Date%></a>
                                        </dd>
                                    </dl>
                                    <dl>
						<dt>GetCapabilities</dt>
						<dd><a href="<%=baseURL%>/sos?request=GetCapabilities"><%=baseURL%>/sos?request=GetCapabilities</a></dd>
				    </dl>
                                    <dl>
						<dt>DescribeSensor</dt>
						<dd><a href="<%=baseURL%>/sos?request=DescribeSensor"><%=baseURL%>/sos?request=DescribeSensor</a></dd>
				    </dl>
                                </li>
                                    <p></p>
                                                                          
                                <li><strong>Web Feature Service</strong>
                                    <dl>
						<dt>GetCapabilities</dt>
						<dd><a href="<%=baseURL%>/wfs?request=GetCapabilities"><%=baseURL%>/wfs?request=GetCapabilities</a></dd>
				    </dl>
                                    <dl>
						<dt>DescribeFeatureType</dt>
						<dd><a href="<%=baseURL%>/wfs?request=DescribeFeatureType"><%=baseURL%>/wfs?request=DescribeFeatureType</a></dd>
				    </dl>

                                    <dt>GetFeature</dt>
                                    <dl>
                                        <dd>All features related to SWIE:<br />
                                        <a href="<%=baseURL%>/wfs?request=GetFeature&typename=swml:Discharge"><%=baseURL%>/wfs?request=GetFeature&typename=swml:Discharge</a>
                                        </dd>
                                        <p></p>
                                    </dl>
                                    <dl>
                                        <dd>GetFeature by feature ID:<br />
                                        <a href="<%=baseURL%>/wfs?request=GetFeature&typename=swml:Discharge&featureId=01446500"><%=baseURL%>/wfs?request=GetFeature&typename=swml:Discharge&featureId=01446500</a>
                                        </dd>
                                        <p></p>
                                    </dl>
                                    <dl>
                                        <dd>GetFeature by via XML HTTP body POST:<br />

                                        <form name="input" action="<%=baseURL%>/wfs?request=GetFeature&typename=swml:Discharge" method="post">
						<textarea name="xml" rows="10" cols="90">
<?xml version="1.0" ?>
<wfs:GetFeature version="1.1.0" service="WFS"
        maxFeatures="3"
    xmlns:wfs="http://www.opengis.net/wfs"
    xmlns:ogc="http://www.opengis.net/ogc"
    xmlns:gml="http://www.opengis.net/gml"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <wfs:Query typeName="swml:Discharge">
    <ogc:Filter>
      <ogc:BBOX>
        <gml:Envelope>
          <gml:lowerCorner>-90 43</gml:lowerCorner>
          <gml:upperCorner>-89.2 43.7</gml:upperCorner>
        </gml:Envelope>
      </ogc:BBOX>
    </ogc:Filter>
  </wfs:Query>
</wfs:GetFeature>
                                                </textarea><br></br>
                                            <input type="submit" value="Submit" />
                                        </form>
                                        </dd>
                                    </dl>
                                    <p></p>
                                </li>

                                <li><strong>Web Mapping Service</strong>
                                    <dl>
                                                <dt>GetMap Google (currently doesn't work in IE)</dt>
                                                <dd><a href="<%=baseURL%>/GoogleMap/GoogleMap.jsp">Google Map</a></dd>
                                    </dl>
                                    <p></p>
				</li>
                                    
                                <li><strong>External Schema</strong>
                                    <dl>Required Schemas<br />
                                        <dd>
                                            <a href="WaterML2_Schemas.jsp">WaterML2 Schemas</a>
                                        </dd>
                                    </dl>
                                    <p></p>
                                    
                                </li>
                    </ul>
	</body>
</html>