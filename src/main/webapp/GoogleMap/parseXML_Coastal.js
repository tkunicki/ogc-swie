function parseXml_Coastal(xml){
    $(xml).find("[nodeName=wfs:FeatureCollection],FeatureCollection").each(function()
    {
        $(xml).find("[nodeName=wfs:member],member").each(function()
        {
            var siteName = $("[nodeName=gml:name]", this).text();
            var pos = $("[nodeName=gml:pos]", this).text();
            var pos_array = pos.split(" ");
            var latitude = pos_array[0];
            var longitude = pos_array[1];
            var pos_name = $("[nodeName=gml:pos]", this).attr("srsName");
            var siteCode = $("[nodeName=wml2:WaterMonitoringPoint]", this).attr("gml:id");
            var USGS_URL = $("[nodeName=sf:sampledFeature]", this).attr("xlink:ref");
            var URL_array = USGS_URL.split("/");
            var stateNM = "Coastal";
            var watershed = "Coastal"
            var point = new GLatLng(latitude, longitude);
            var marker = createMarker(point, siteName,  stateNM, siteCode, USGS_URL, base_url, watershed);
            map.addOverlay(marker);
            makeSidebar();
        });
    });
}