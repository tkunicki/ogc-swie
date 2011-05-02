function parseXML(xml){
    $(xml).find('[nodeName="wfs:FeatureCollection"],FeatureCollection').each(function()
    {
        $(xml).find('[nodeName="wfs:member"],member').each(function()
        {
            var siteName = $('[nodeName="gml:name"],name', this).text();
            var pos = $('[nodeName="gml:pos"],pos', this).text();
            var pos_array = pos.split(" ");
            var latitude = pos_array[0];
            var longitude = pos_array[1];
            var pos_name = $('[nodeName="gml:pos"],pos', this).attr("srsName");
            var siteCode_long = $('[nodeName="wml2:WaterMonitoringPoint"],WaterMonitoringPoint', this).attr("gml:id");
            var siteCode_array = siteCode_long.split(".");
            var siteCode = siteCode_array[2];
            var USGS_URL = $('[nodeName="sf:sampledFeature"],sampledFeature', this).attr("xlink:ref");
            var URL_array = USGS_URL.split("/");
            var stateNM = URL_array[3];
            var watershed = $('[nodeName="om:value"],value', this).text();
            var point = new GLatLng(latitude, longitude);
            var marker = createMarker(point, siteName,  stateNM, siteCode, USGS_URL, base_url, watershed);
            map.addOverlay(marker);
        }); 
    });
}