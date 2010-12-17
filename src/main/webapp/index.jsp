<html>
<head>
	<title>USGS OGC Services</title>
</head>
<% String baseURL = request.getRequestURL().toString().replaceAll("/[^/]*$", ""); %>
<body>
	
	<ul>
		<li><a href="index-gwie-usgs.jsp">USGS GWIE OGC Services</a></li>
		<li><a href="index-swie-usgs.jsp">USGS SWIE OGC Services</a></li>
		<li><a href="index-gwie-grcan.jsp">GRCAN GWIE OGC Services</a></li>
		<li><a href="index-gwdp.jsp">GroundWater Data Portal Sample OGC Services</a></li>
		<li><a href="index-gwdp-mediator.jsp">GWDP Mediator OGC Services</a></li>
	</ul>
</body>
</html>