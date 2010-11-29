<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<% String baseURL = request.getRequestURL().toString().replaceAll("/[^/]*$", "");%>
<html>
	<head>
		<title>OGC GroundWater Interoperability Experiment (USGS node)</title>
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
				<li><strong>Web Mapping Service</strong> at http://infotrek.er.usgs.gov/mapviewer11gr1/wms
					<dl>
						<dt>GetCapabilities</dt>
						<dd><a href="http://infotrek.er.usgs.gov/mapviewer11gr1/wms?REQUEST=GetCapabilities&VERSION=1.1.1&SERVICE=WMS">http://infotrek.er.usgs.gov/mapviewer11gr1/wms?REQUEST=GetCapabilities&VERSION=1.1.1&SERVICE=WMS</a></dd>
					</dl>
					<dl>
						<dt>GetMap</dt>
						<dd><a href="http://infotrek.er.usgs.gov/mapviewer11gr1/wms?REQUEST=GetMap&VERSION=1.1.1&FORMAT=image/gif&SERVICE=WMS&BBOX=-90,43,-89,44&SRS=EPSG:4326&LAYERS=GW_SITES&WIDTH=580&HEIGHT=500">http://infotrek.er.usgs.gov/mapviewer11gr1/wms?REQUEST=GetMap&VERSION=1.1.1&FORMAT=image/gif&SERVICE=WMS&BBOX=-90,43,-89,44&SRS=EPSG:4326&LAYERS=GW_SITES&WIDTH=580&HEIGHT=500 </a></dd>
					</dl>
				</li>
				<li><strong>Web Feature Service</strong> at <%=baseURL%>/wfs
					<dl>
						<dt>GetCapabilities</dt>
						<dd><a href="<%=baseURL%>/wfs?request=GetCapabilities"><%=baseURL%>/wfs?request=GetCapabilities</a></dd>
					</dl>
					<dl>
						<dt>DescribeFeatureType</dt>
						<dd><a href="<%=baseURL%>/wfs?request=DescribeFeatureType&typeName=gwml:WaterWell"><%=baseURL%>/wfs?request=DescribeFeatureType&typeName=gwml:WaterWell</a></dd>
					</dl>
					<dl>
						<dt>GetFeature examples</dt>
						<dd>
							<ul>
								<li>
									<dl>
										<dt>GetFeature by bounding box, KVP GET</dt>
										<dd><a href="<%=baseURL%>/wfs?request=GetFeature&bBox=-89.7,42.8,-89.2,43.3&typeName=gwml:WaterWell"><%=baseURL%>/wfs?request=GetFeature&bBox=-89.7,42.8,-89.2,43.3&typeName=gwml:WaterWell</a></dd>
									</dl>
								</li>
								<li>
									<dl>
										<dt>GetFeature by feature id, KVP GET</dt>
										<dd><a href="<%=baseURL%>/wfs?request=GetFeature&featureId=USGS.425856089320601&typeName=gwml:WaterWell"><%=baseURL%>/wfs?request=GetFeature&featureId=USGS.425856089320601&typeName=gwml:WaterWell</a></dd>
									</dl>
								</li>
								<li>
									<dl>
										<dt>GetFeature via XML Form POST using requestHack parameter (nonstandard)</dt>
										<dd>
											<form name="input" action="<%=baseURL%>/wfs" method="post">
												<textarea name="xml" rows="10" cols="90">
<?xml version="1.0" ?>
<wfs:GetFeature version="1.1.0" service="WFS"
	maxFeatures="3"  
    xmlns:wfs="http://www.opengis.net/wfs" 
    xmlns:ogc="http://www.opengis.net/ogc" 
    xmlns:gml="http://www.opengis.net/gml"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <wfs:Query typeName="gwml:WaterWell">
    <ogc:Filter>
      <ogc:BBOX>
        <gml:Envelope>
          <gml:lowerCorner>-89.7 42.8</gml:lowerCorner>
          <gml:upperCorner>-89.2 43.3</gml:upperCorner>
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
								</li>
								<li>
									<dl>
										<dt>GetFeature via XML HTTP body POST (standard)</dt>
										<dd>
											<textarea name="stdWFS" id="stdWFS" rows="10" cols="90">
<?xml version="1.0" ?>
<wfs:GetFeature version="1.1.0" service="WFS"
	maxFeatures="3"
    xmlns:wfs="http://www.opengis.net/wfs"
    xmlns:ogc="http://www.opengis.net/ogc"
    xmlns:gml="http://www.opengis.net/gml"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <wfs:Query typeName="gwml:WaterWell">
    <ogc:Filter>
      <ogc:BBOX>
        <gml:Envelope>
          <gml:lowerCorner>-89.7 42.8</gml:lowerCorner>
          <gml:upperCorner>-89.2 43.3</gml:upperCorner>
        </gml:Envelope>
      </ogc:BBOX>
    </ogc:Filter>
  </wfs:Query>
</wfs:GetFeature>
												</textarea><br></br>
											<input type="button" name="submit" value="Submit" onclick="httpBodyPost('<%=baseURL%>/wfs', 'stdWFS');" />
										</dd>
									</dl>
								</li>
							</ul>
						</dd>
					</dl>
				</li>
				<li><strong>Sensor Observation Service</strong> at <%=baseURL%>/sosbbox
					<dl>
						<dt>GetCapabilities</dt>
						<dd><a href="<%=baseURL%>/sosbbox?request=GetCapabilities"><%=baseURL%>/sosbbox?request=GetCapabilities</a></dd>
					</dl>
					<dl>
						<dt>GetProfile (tentative extension of OWS)</dt>
						<dd><a href="<%=baseURL%>/sosbbox?request=GetProfile"><%=baseURL%>/sosbbox?request=GetProfile</a></dd>
					</dl>
					<dl>
						<dt>DescribeSensor</dt>
						<dd><a href="<%=baseURL%>/sosbbox?request=DescribeSensor"><%=baseURL%>/sosbbox?request=DescribeSensor</a></dd>
					</dl>
					<dl>
						<dt>GetObservationById</dt>
						<dd><a href="<%=baseURL%>/sosbbox?request=GetObservationById&observationId=obs.MN040-474641090343501"><%=baseURL%>/sosbbox?request=GetObservationById&observationId=obs.MN040-474641090343501</a></dd>
					</dl>
					<dl>
						<dt>GetObservation examples</dt>
						<dd>
							<ul>
								<li>
									<dl>
										<dt>(nonstandard) GetObservation using explicit bounding box KVP GET</dt>
										<dd><a href="<%=baseURL%>/sosbbox?request=GetObservation&north=43&south=42.8&east=-89.50&west=-89.70"><%=baseURL%>/sosbbox?request=GetObservation&north=43&south=42.8&east=-89.50&west=-89.70</a></dd>
									</dl>
								</li>
								<li>
									<dl>
										<dt>(nonstandard) GetObservation using feature id KVP GET</dt>
										<dd><a href="<%=baseURL%>/sosbbox?request=GetObservation&featureId=USGS.425856089320601"><%=baseURL%>/sosbbox?request=GetObservation&featureId=USGS.425856089320601</a>
											<br/><a href="<%=baseURL%>/sosbbox?request=GetObservation&featureId=USGS.425958089321601"><%=baseURL%>/sosbbox?request=GetObservation&featureId=USGS.425958089321601</a>
										</dd>
									</dl>
								</li>
								<li>
									<dl>
										<dt>GetObservations via XML Form POST using requestHack parameter (nonstandard)</dt>
										<dd>
											<form name="input" action="<%=baseURL%>/sosbbox" method="post">
												<textarea name="xml" rows="10" cols="90">
<?xml version="1.0" ?>
<sos:GetObservation version="1.0.0" service="SOS" srsName="urn:ogc:def:crs:EPSG:4326"
    xmlns:sos="http://www.opengis.net/sos/1.0"
    xmlns:ogc="http://www.opengis.net/ogc"
    xmlns:gml="http://www.opengis.net/gml"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <sos:offering>observationOffering3</sos:offering>
  <sos:observedProperty>urn:ogc:def:property:OGC:GroundWaterLevel</sos:observedProperty>
  <sos:featureOfInterest>
    <ogc:BBOX>
      <ogc:PropertyName>urn:ogc:data:location</ogc:PropertyName>
      <gml:Envelope srsName="urn:ogc:def:crs:EPSG:4326">
        <gml:lowerCorner>-89.7 42.8</gml:lowerCorner>
        <gml:upperCorner>-89.2 43.3</gml:upperCorner>
      </gml:Envelope>
    </ogc:BBOX>
  </sos:featureOfInterest>
  <sos:responseFormat>text/xml; subtype="om/1.0.0"</sos:responseFormat>
</sos:GetObservation>
												</textarea><br></br>
												<input type="submit" value="Submit" />
											</form>
										</dd>
									</dl>
								</li>
								<li>
									<dl>
										<dt>GetObservations via XML HTTP body POST (standard)</dt>
										<dd>
											<textarea name="stdSOS" id="stdSOS" rows="10" cols="90">
<?xml version="1.0" ?>
<sos:GetObservation version="1.0.0" service="SOS" srsName="urn:ogc:def:crs:EPSG:4326"
    xmlns:sos="http://www.opengis.net/sos/1.0"
    xmlns:ogc="http://www.opengis.net/ogc"
    xmlns:gml="http://www.opengis.net/gml"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <sos:offering>observationOffering3</sos:offering>
  <sos:observedProperty>urn:ogc:def:property:OGC:GroundWaterLevel</sos:observedProperty>
  <sos:featureOfInterest>
    <ogc:BBOX>
      <ogc:PropertyName>urn:ogc:data:location</ogc:PropertyName>
      <gml:Envelope srsName="urn:ogc:def:crs:EPSG:4326">
        <gml:lowerCorner>-89.7 42.8</gml:lowerCorner>
        <gml:upperCorner>-89.2 43.3</gml:upperCorner>
      </gml:Envelope>
    </ogc:BBOX>
  </sos:featureOfInterest>
  <sos:responseFormat>text/xml; subtype="om/1.0.0"</sos:responseFormat>
</sos:GetObservation>
											</textarea>
											<br></br>
											<input type="button" name="submit" value="Submit" onclick="httpBodyPost('<%=baseURL%>/sosbbox', 'stdSOS');" />
										</dd>
									</dl>
								</li>
							</ul>
						</dd>
					</dl>
				</li>
			</ul>
	</body>
</html>