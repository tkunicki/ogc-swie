<html>
<head>
	<title>OGC GroundWater Interoperability Experiment (USGS node)</title>
</head>
<% String baseURL = request.getRequestURL().toString().replaceAll("/[^/]*$", ""); %>
<body>
	<h1>Services Implemented</h1>
	<ul>
		<li><strong>Web Feature Service</strong><br/>
			<dl>
				<dt>GetCapabilities</dt>
				<dd><a href="<%=baseURL%>/wfs?request=GetCapabilities"><%=baseURL%>/wfs?request=GetCapabilities</a></dd>
			</dl>
			<dl>
				<dt>DescribeFeatureType</dt>
				<dd><a href="<%=baseURL%>/wfs?request=DescribeFeatureType"><%=baseURL%>/wfs?request=DescribeFeatureType</a></dd>
			</dl>
			<dl>
				<dt>GetFeature by bounding box</dt>
				<dd><a href="<%=baseURL%>/wfs?request=GetFeature&bBox=-89.7,42.8,-89.2,43.3&typeName=gwml:WaterWell"><%=baseURL%>/wfs?request=GetFeature&bBox=-89.7,42.8,-89.2,43.3&typeName=gwml:WaterWell</a></dd>
			</dl>
			<dl>
				<dt>GetFeature by feature id</dt>
				<dd><a href="<%=baseURL%>/wfs?request=GetFeature&featureId=USGS.435629089353901&typeName=gwml:WaterWell"><%=baseURL%>/wfs?request=GetFeature&featureId=USGS.435629089353901&typeName=gwml:WaterWell</a></dd>
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
				<dd><a href="<%=baseURL%>/sosbbox?request=GetObservation&north=43&south=42.9&east=-89.57&west=-89.65"><%=baseURL%>/sosbbox?request=GetObservation&north=43&south=42.9&east=-89.57&west=-89.65</a></dd>
			</dl>
			<dl>
				<dt>GetObservations POST (Example forthcoming</dt>
			</dl>
		</li>	
	</ul>
</body>
</html>