<html>
<head>
	<title>OGC GroundWater Interoperability Experiment (USGS node)</title>
</head>
<% String baseURL = request.getRequestURL().toString().replaceAll("/[^/]*$", ""); %>
<body>
	<h1>Services Implemented</h1>
	<ul>
		<li><strong>Web Mapping Service</strong><br/>
			<dl>
				<dt>GetCapabilities</dt>
				<dd><a href="http://infotrek.er.usgs.gov/mapviewer11gr1/wms?REQUEST=GetCapabilities&VERSION=1.1.1&SERVICE=WMS ">http://infotrek.er.usgs.gov/mapviewer11gr1/wms?REQUEST=GetCapabilities&VERSION=1.1.1&SERVICE=WMS</a></dd>
			</dl>
			<dl>
				<dt>GetMap</dt>
				<dd><a href="http://infotrek.er.usgs.gov/mapviewer11gr1/wms?REQUEST=GetMap&VERSION=1.1.1&FORMAT=image/gif&SERVICE=WMS&BBOX=-90,43,-89,44&SRS=EPSG:4326&LAYERS=GW_SITES&WIDTH=580&HEIGHT=500 ">http://infotrek.er.usgs.gov/mapviewer11gr1/wms?REQUEST=GetMap&VERSION=1.1.1&FORMAT=image/gif&SERVICE=WMS&BBOX=-90,43,-89,44&SRS=EPSG:4326&LAYERS=GW_SITES&WIDTH=580&HEIGHT=500 </a></dd>
			</dl>
		</li>
		<li><strong>Web Feature Service</strong><br/>
			<dl>
				<dt>GetCapabilities</dt>
				<dd><a href="<%=baseURL%>/wfs?request=GetCapabilities"><%=baseURL%>/wfs?request=GetCapabilities</a></dd>
			</dl>
			<dl>
				<dt>DescribeFeatureType</dt>
				<dd><a href="<%=baseURL%>/wfs?request=DescribeFeatureType&typeName=gwml:WaterWell"><%=baseURL%>/wfs?request=DescribeFeatureType&typeName=gwml:WaterWell</a></dd>
			</dl>
			<dl>
				<dt>GetFeature by bounding box</dt>
				<dd><a href="<%=baseURL%>/wfs?request=GetFeature&bBox=-89.7,42.8,-89.2,43.3&typeName=gwml:WaterWell"><%=baseURL%>/wfs?request=GetFeature&bBox=-89.7,42.8,-89.2,43.3&typeName=gwml:WaterWell</a></dd>
			</dl>
			<dl>
				<dt>GetFeature by feature id</dt>
				<dd><a href="<%=baseURL%>/wfs?request=GetFeature&featureId=USGS.425856089320601&typeName=gwml:WaterWell"><%=baseURL%>/wfs?request=GetFeature&featureId=USGS.425856089320601&typeName=gwml:WaterWell</a></dd>
			</dl>
			<dl>
				<dt>Ad hoc Query</dt>
				<dd>
					<form name="input" action="<%=baseURL%>/wfs" method="post">
						<textarea name="requestHack" rows="10" cols="60">
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
						</textarea>
						<input type="submit" value="Submit" />
					</form>
				</dd>
			</dl>
		</li>
		<li><strong>Sensor Observation Service</strong><br/><%=baseURL%>/sosbbox
			<dl>
				<dt>GetCapabilities</dt>
				<dd><a href="<%=baseURL%>/sosbbox?request=GetCapabilities"><%=baseURL%>/sosbbox?request=GetCapabilities</a></dd>
			</dl>
			<dl>
				<dt>DescribeSensor (To be implemented)</dt>
				<dd><a href="<%=baseURL%>/sosbbox?request=DescribeSensor"><%=baseURL%>/sosbbox?request=DescribeSensor</a></dd>
			</dl>
			<dl>
				<dt>nonstandard GetObservations using explicit bounding box KVP</dt>
				<dd><a href="<%=baseURL%>/sosbbox?request=GetObservation&north=43&south=42.8&east=-89.50&west=-89.70"><%=baseURL%>/sosbbox?request=GetObservation&north=43&south=42.8&east=-89.50&west=-89.70</a></dd>
			</dl>
			<dl>
				<dt>nonstandard GetObservations using feature id</dt>
				<dd><a href="<%=baseURL%>/sosbbox?request=GetObservation&featureId=USGS.425856089320601"><%=baseURL%>/sosbbox?request=GetObservation&featureId=USGS.425856089320601</a></dd>
			</dl>
			<dl>
				<dt>GetObservations POST (Example forthcoming)</dt>
			</dl>
			<dl>
				<dt>Ad hoc Query</dt>
				<dd>
					<form name="input" action="<%=baseURL%>/sosbbox" method="post">
						<textarea name="requestHack" rows="10" cols="60"></textarea>
						<input type="submit" value="Submit" />
					</form>
				</dd>
			</dl>
		</li>	
	</ul>
</body>
</html>