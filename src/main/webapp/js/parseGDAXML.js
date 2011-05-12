function parseGDAXML(xml,base_url){
    var i = 0;
    var siteList = "";
    $(xml).find('[nodeName="gda:GetDataAvailability"],GetDataAvailability').each(function()
    {
        $(xml).find('[nodeName="gda:featureOfInterestEntryPoint"],featureOfInterestEntryPoint').each(function()
        {
            var site = $('[nodeName="gda:FeatureOfInterestInfo"],FeatureOfInterestInfo', this).attr("swes:id").split("_")[1];
            siteList = siteList + "," + site;
            i = i + 1;
        });
    });
    siteList = siteList.substring(1, siteList.length);
    wfs_url = base_url + 'wfs?request=GetFeature&featureId=' + siteList;
    document.getElementById("FeatureNumber").innerHTML = i;
    LoadXML(wfs_url);

}