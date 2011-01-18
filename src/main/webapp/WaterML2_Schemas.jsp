<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<% String baseURL = request.getRequestURL().toString().replaceAll("/[^/]*$", "");%>
<html>
	<head>
		<title>Water ML2 Schemas </title>
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
    <dt><strong>WaterML 2.0 Schemas: </strong></dt>
        <dd>
            <a href="<%=baseURL%>/schemas/waterml2.xsd">WaterML2.xsd</a>
        </dd>
        <dd>
            <a href="<%=baseURL%>/schemas/waterSampling.xsd">waterSampling.xsd</a>
        </dd>
        <dd>
            <a href="<%=baseURL%>/schemas/waterResultsCoverage.xsd">waterResultsCoverage.xsd</a>
        </dd>
        <dd>
            <a href="<%=baseURL%>/schemas/waterProperty.xsd">waterProperty.xsd</a>
        </dd>
        <dd>
            <a href="<%=baseURL%>/schemas/waterProcedure.xsd">waterProcedure.xsd</a>
        </dd>
        <dd>
            <a href="<%=baseURL%>/schemas/waterObservation.xsd">waterObservation.xsd</a>
        </dd>
        <dd>
            <a href="<%=baseURL%>/schemas/WaterCollection.xsd">WaterCollection.xsd</a>
        </dd>
        <dd>
            <a href="<%=baseURL%>/schemas/timeseriesLite.xsd">timeseriesLite.xsd</a>
        </dd>
   <dt><strong>Additional externally required schemas:</strong></dt>
        <dd>
            <a href="<%=baseURL%>/schemas/observation.xsd">observation.xsd</a>
        </dd>
        <dd>
            <a href="<%=baseURL%>/schemas/samplingFeature.xsd">samplingFeature.xsd</a>
        </dd>
        <dd>
            <a href="<%=baseURL%>/schemas/spatialSamplingFeature.xsd">spatialSamplingFeature.xsd</a>
        </dd>
        <p></p>

  </body>
</html>
