<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<% String baseURL = request.getRequestURL().toString().replaceAll("/[^/]*$", "");%>
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
		<h1>Services Implemented - SWIE</h1>
                    <ul>
                                <li><strong>Web Mapping Service</strong> at http://igsarmewfsbbh.er.usgs.gov:8080/geoserver/wms
                                    <p></p>
                                    <dl>
						<dt>GetFeature</dt>
                                                <dd>All features:<br />
                                                    <a href="http://igsarmewfsbbh.er.usgs.gov:8080/geoserver/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=upload:SWIE_SITES&maxFeatures=50 ">http://igsarmewfsbbh.er.usgs.gov:8080/geoserver/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=upload:SWIE_SITES&maxFeatures=50 </a></dd>
                                                <dd>One feature: <i>not working yet....</i><br />
                                                <a href="http://igsarmewfsbbh.er.usgs.gov:8080/geoserver/ows?FILTER%3D%3CFilter%20xmlns%3D%22http%3A//www.opengis.net/ogc%22%3E%3CPropertyIsEqualTo%3E%3CPropertyName%3Eupload%3ASITE_NO%3C/PropertyName%3E%3CLiteral%3E01427207%3C/Literal%3E%3C/PropertyIsEqualTo%3E%3C/Filter%3E&INFO_FORMAT=text/xml&service=WFS&version=1.0.0&request=GetFeature&typeName=upload:SWIE_SITES& ">http://igsarmewfsbbh.er.usgs.gov:8080/geoserver/ows?FILTER%3D%3CFilter%20xmlns%3D%22http%3A//www.opengis.net/ogc%22%3E%3CPropertyIsEqualTo%3E%3CPropertyName%3Eupload%3ASITE_NO%3C/PropertyName%3E%3CLiteral%3E01427207%3C/Literal%3E%3C/PropertyIsEqualTo%3E%3C/Filter%3E&INFO_FORMAT=text/xml&service=WFS&version=1.0.0&request=GetFeature&typeName=upload:SWIE_SITES&  </a></dd>
                                    </dl>
				    <dl>
						<dt>GetMap</dt>
						<dd><a href="http://igsarmewfsbbh.er.usgs.gov:8080/geoserver/wms?service=WMS&version=1.1.0&request=GetMap&layers=upload:SWIE_SITES&styles=&bbox=-92.8,37.216,-74.697,45.831&width=693&height=330&srs=EPSG:4269&format=application/openlayers
">  http://igsarmewfsbbh.er.usgs.gov:8080/geoserver/wms?service=WMS&version=1.1.0&request=GetMap&layers=upload:SWIE_SITES&styles=&bbox=-92.8,37.216,-74.697,45.831&width=693&height=330&srs=EPSG:4269&format=application/openlayers
 </a></dd>
                                    </dl>
                                    <p></p>
				</li>
                                
                                <li><strong>Web Feature Service</strong> at <%=baseURL%>/wfsnwis
                                    <p></p>
                                    <dt>GetFeature</dt>
                                        <dd>All features:<br />
                                        <a href="<%=baseURL%>/wfsnwis?request=GetFeature&typename=swml:Discharge"><%=baseURL%>/wfsnwis?request=GetFeature&typename=swml:Discharge</a>
                                        </dd>
                                        <dd>GetFeature by feature ID:<br />
                                        <a href="<%=baseURL%>/wfsnwis?request=GetFeature&typename=swml:Discharge&featureId=01446500"><%=baseURL%>/wfsnwis?request=GetFeature&typename=swml:Discharge&featureId=01446500</a>
                                        </dd>
                                        <dd>GetFeature by via XML HTTP body POST:<br />

                                        <form name="input" action="<%=baseURL%>/wfsnwis?request=GetFeature&typename=swml:Discharge" method="post">
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
                                    <p></p>
                                </li>

                                <li><strong>Sensor Observation Service</strong> at <%=baseURL%>/sosnwis
                                    <p></p>
                                    <dt>GetObservations</dt>
                                    <dd>GetObservation by feature ID:<br />
                                        <a href="<%=baseURL%>/sosnwis?request=GetObservation&featureId=01446500"><%=baseURL%>/sosnwis?request=GetObservation&featureId=01446500</a>
                                    </dd>
                                    <p></p>
                                </li>

                    </ul>



	</body>
</html>