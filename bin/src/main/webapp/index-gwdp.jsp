<html>
<head>
	<title>GRCAN GWDP OGC Services</title>
</head>
<% String baseURL = request.getRequestURL().toString().replaceAll("/[^/]*$", ""); %>
<body>
	<h1>Example Services</h1>
		<ul>
			<li><strong>Simple WFS GetFeature against well registry</strong>
				<dl>
					<dt>GetFeature</dt>
					<dd><a href="http://130.11.161.203:8080/geoserver/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=ogc-ie:GW_LEVELS&maxFeatures=50">http://130.11.161.203:8080/geoserver/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=ogc-ie:GW_LEVELS&maxFeatures=50</a></dd>
				</dl>
			</li>
		</ul>

		<ul>
			<li><strong>Complex WFS GetFeature against well registry with lithology and construction</strong>
				<dl>
					<dt>GetFeature</dt>
					<dd><a href="http://igsarmewfsbbh.er.usgs.gov:8080/geoserver/wfs?request=GetFeature&typeName=gsml:GeologicUnit">http://igsarmewfsbbh.er.usgs.gov:8080/geoserver/wfs?request=GetFeature&typeName=gsml:GeologicUnit</a></dd>
				</dl>
			</li>
		</ul>
		<ul>
			<li><strong>ogc-ie wfs GetFeature</strong>
				<dl>
					<dt>GetFeature</dt>
					<dd>/wfs?request=GetFeature&featureId=USGS.425856089320601&typeName=gwml:WaterWell
					<%=baseURL%>
						<a href="http://igsarmewfsbbh.er.usgs.gov:8080/geoserver/wfs?request=GetFeature&typeName=gsml:GeologicUnit">http://igsarmewfsbbh.er.usgs.gov:8080/geoserver/wfs?request=GetFeature&typeName=gsml:GeologicUnit</a><br/>
						mediated, <a href="http://localhost:8088/cocoon/gin/wfs/gw_usgs?request=GetFeature&FID=USGS.662135147232502&typeName=gwml:WaterWell&INFO_FORMAT=text/xml">http://localhost:8088/cocoon/gin/wfs/gw_usgs?request=GetFeature&FID=USGS.662135147232502&typeName=gwml:WaterWell&INFO_FORMAT=text/xml</a>
					</dd>
				</dl>
			</li>
		</ul>
http://localhost:8088/cocoon/gin/wfs/gw_usgs?request=GetFeature&FID=USGS.662135147232502&typeName=gwml:WaterWell&INFO_FORMAT=text/xml
</body>
</html>