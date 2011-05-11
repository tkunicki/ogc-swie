function parseGDAXML(xml,base_url){
    var siteList = "";
    $(xml).find('[nodeName="gda:GetDataAvailablity"],GetDataAvailablity').each(function()
    {
        $(xml).find('[nodeName="gda:featureOfInterestEntryPoint"],featureOfInterestEntryPoint').each(function()
        {
            var site = $('[nodeName="gda:FeatureOfInterestInfo"],FeatureOfInterestInfo', this).attr("swes:id").split("_")[1];
            siteList = siteList + ',' + site;
        });
    });
    siteList = siteList;
    wfs_url = base_url + 'wfs?request=GetFeature&featureId=' + siteList;
    LoadXML(wfs_url);

}