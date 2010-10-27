<html>
<head>
	<title>GRCAN GWIE OGC Services</title>
</head>
<% String baseURL = request.getRequestURL().toString().replaceAll("/[^/]*$", ""); %>
<body>
	
	<h1>Services Implemented</h1>
		<ul>
			<li><strong>Sensor Observation Service</strong>
				<dl>
					<dt>GetCapabilities</dt>
					<dd><a href="http://ngwd-bdnes.cits.nrcan.gc.ca/service/gin/sos/gin?REQUEST=GetCapabilities">http://ngwd-bdnes.cits.nrcan.gc.ca/service/gin/sos/gin?REQUEST=GetCapabilities</a></dd>
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

</body>
</html>