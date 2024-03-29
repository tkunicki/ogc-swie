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
      <p />
      <dt><strong>WaterML 2.0 Schemas: </strong></dt>
        <dd>
            <a href="schemas/waterml2.xsd">waterML2.xsd</a>
        </dd>
	    <dd>
            <a href="schemas/collection.xsd">collection.xsd</a>
        </dd>
	    <dd>
            <a href="schemas/monitoringPoint.xsd">monitoringPoint.xsd</a>
        </dd>
	    <dd>
            <a href="schemas/observationProcess.xsd">observationProcess.xsd</a>
        </dd>
	    <dd>
            <a href="schemas/timeseries.xsd">timeseries.xsd</a>
        </dd>
	    <dd>
            <a href="schemas/timeseriesObservationMetadata.xsd">timeseriesObservationMetadata.xsd</a>
        </dd>
<!--        
        <dd>
            <a href="http://services.iwis.csiro.au/WaterML2Validation/schemas/waterml_2/waterml2.xsd">WaterML2.xsd</a>
        </dd>
		<dd>
            <a href="http://services.iwis.csiro.au/WaterML2Validation/schemas/waterml_2/waterSampling.xsd">waterSampling.xsd</a>
        </dd>
        <dd>
            <a href="http://services.iwis.csiro.au/WaterML2Validation/schemas/waterml_2/waterResultsCoverage.xsd">waterResultsCoverage.xsd</a>
        </dd>
        <dd>
            <a href="http://services.iwis.csiro.au/WaterML2Validation/schemas/waterml_2/waterProperty.xsd">waterProperty.xsd</a>
        </dd>
        <dd>
            <a href="http://services.iwis.csiro.au/WaterML2Validation/schemas/waterml_2/waterProcedure.xsd">waterProcedure.xsd</a>
        </dd>
        <dd>
            <a href="http://services.iwis.csiro.au/WaterML2Validation/schemas/waterml_2/waterObservation.xsd">waterObservation.xsd</a>
        </dd>
        <dd>
            <a href="http://services.iwis.csiro.au/WaterML2Validation/schemas/waterml_2/WaterCollection.xsd">WaterCollection.xsd</a>
        </dd>
        <dd>
            <a href="http://services.iwis.csiro.au/WaterML2Validation/schemas/waterml_2/timeseriesLite.xsd">timeseriesLite.xsd</a>
        </dd>-->
    <p />
   <dt><strong>Additional externally required schemas:</strong></dt>
        
        <dt>   OM 2.0 </dt>
            <dd><a href="http://services.iwis.csiro.au/WaterML2Validation/schemas/externalSchemas/SCHEMAS_OPENGIS_NET/om/2.0/observation.xsd">observation.xsd</a></dd>
        

        <dt>Sampling 2.0 </dt>
            <dd><a href="http://services.iwis.csiro.au/WaterML2Validation/schemas/externalSchemas/SCHEMAS_OPENGIS_NET/sampling/2.0/samplingFeature.xsd">samplingFeature.xsd</a></dd>
        
        <dt>samplingSpatial 2.0 </dt>
            <dd><a href="http://services.iwis.csiro.au/WaterML2Validation/schemas/externalSchemas/SCHEMAS_OPENGIS_NET/samplingSpatial/2.0/spatialSamplingFeature.xsd">spatialSamplingFeature.xsd</a></dd>
        
        <p />
        <dt><strong>Notes:</strong> <br />
            The links take you to an external site. Last modified Dec. 27, 2011.<br />
		<p />
      <dt><strong>Older WaterML 2.0 Schemas: </strong></dt>
	  <dt>Used in SWIE through April 6, 2012, WaterML2 schemas from August 24, 2011</dt>
        <dd>
            <a href="schemas/waterml2_old.xsd">waterML2.xsd</a>
        </dd>
	    <dd>
            <a href="schemas/collection_old.xsd">collection.xsd</a>
        </dd>
	    <dd>
            <a href="schemas/monitoringPoint_old.xsd">monitoringPoint.xsd</a>
        </dd>
	    <dd>
            <a href="schemas/observationProcess_old.xsd">observationProcess.xsd</a>
        </dd>
	    <dd>
            <a href="schemas/timeseries_old.xsd">timeseries.xsd</a>
        </dd>
	    <dd>
            <a href="schemas/timeseriesObservationMetadata_old.xsd">timeseriesObservationMetadata.xsd</a>
        </dd>

  </body>
</html>
