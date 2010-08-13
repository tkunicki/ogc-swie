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
				<dt>GetFeature</dt>
				<dd><a href="<%=baseURL%>/wfs?request=GetFeature&bBox=-89.7,42.8,-89.2,43.3&typeName=gwml:WaterWell"><%=baseURL%>/wfs?request=GetFeature&bBox=-89.7,42.8,-89.2,43.3&typeName=gwml:WaterWell</a></dd>
			</dl>			
		</li>
		<li><strong>Sensor Observation Service</strong><br/><%=baseURL%>/sosbbox

		</li>	
	</ul>
</body>
</html>