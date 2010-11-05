<html>
<head>
	<title>GRCAN GWIE OGC Services</title>
</head>
<% String baseURL = request.getRequestURL().toString().replaceAll("/[^/]*$", ""); %>
<body>
	
	<h1>Services Implemented</h1>
		<ul>
			<li><strong>Sensor Observation Service 1</strong>
				<dl>
					<dt>GetCapabilities</dt>
					<dd><a href="http://ngwd-bdnes.cits.nrcan.gc.ca/service/gin/sos/gin?REQUEST=GetCapabilities">http://ngwd-bdnes.cits.nrcan.gc.ca/service/gin/sos/gin?REQUEST=GetCapabilities</a></dd>
				</dl>
				<dl>
					<dt>SOS Form Testing Page</dt>
					<dd><a href="http://ngwd-bdnes.cits.nrcan.gc.ca/service/api_ngwds/en/sosform.html">http://ngwd-bdnes.cits.nrcan.gc.ca/service/api_ngwds/en/sosform.html</a></dd>
				</dl>
			</li>
		</ul>

		<ul>
			<li><strong>Web Feature Service</strong>
				<dl>
					<dt>GetCapabilities</dt>
					<dd><a href="http://ngwd-bdnes.cits.nrcan.gc.ca/service/gin/wfs/gin?REQUEST=GetCapabilities">http://ngwd-bdnes.cits.nrcan.gc.ca/service/gin/wfs/gin?REQUEST=GetCapabilities</a></dd>
				</dl>
			</li>
		</ul>
		
		
		<ul>
			<li><strong>Pass-through WFS to USGS</strong>
				<dl>
					<dt>GetFeature (modified to return html, so not a pass-through</dt>
					<dd><a href="http://ngwd-bdnes.cits.nrcan.gc.ca/service/gin/wfs/gw_usgs?request=GetFeature&FID=USGS.662135147232502&typeName=gwml:WaterWell&INFO_FORMAT=text/html">http://ngwd-bdnes.cits.nrcan.gc.ca/service/gin/wfs/gw_usgs?request=GetFeature&FID=USGS.662135147232502&typeName=gwml:WaterWell&INFO_FORMAT=text/html</a></dd>
				</dl>
				<dl>
					<dt>GetFeature (returns xml)</dt>
					<dd><a href="http://ngwd-bdnes.cits.nrcan.gc.ca/service/gin/wfs/gw_usgs?request=GetFeature&FID=USGS.662135147232502&typeName=gwml:WaterWell&INFO_FORMAT=text/xml">http://ngwd-bdnes.cits.nrcan.gc.ca/service/gin/wfs/gw_usgs?request=GetFeature&FID=USGS.662135147232502&typeName=gwml:WaterWell&INFO_FORMAT=text/xml</a></dd>
				</dl>
			</li>
		</ul>
		
		<ul>
			<li><strong>Sensor Observation Service 2</strong>
				<dl>
					<dt>SOS 2 Form Testing Page</dt>
					<dd><a href="http://ngwd-bdnes.cits.nrcan.gc.ca/service/gin/sos2/page/sos.html">http://ngwd-bdnes.cits.nrcan.gc.ca/service/gin/sos2/page/sos.html</a></dd>
				</dl>
			</li>
		</ul>

</body>
</html>