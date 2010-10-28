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
					<dd><a href="http://130.11.161.208:8080/geoserver/wfs?request=GetFeature&typeName=gsml:GeologicUnit">http://130.11.161.208:8080/geoserver/wfs?request=GetFeature&typeName=gsml:GeologicUnit</a></dd>
				</dl>
			</li>
		</ul>

</body>
</html>