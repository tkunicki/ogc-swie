// ========================Create a tabbed marker============================================
function createMarker(point, name, StateNM, Site_no, USGS_URL, base_url, watershed)
{
    //var marker = new GMarker(point, {icon: gicons[StateNM]});
//    var newIcon = '';
//    if (StateNM == 'Coastal') {
//        newIcon = MapIconMaker.createMarkerIcon({
//            primaryColor: "#660000"
//        });
//    }
//    else {
//        newIcon = MapIconMaker.createMarkerIcon({
//            primaryColor: "#3366FF"
//        });
//    }

    var marker = new GMarker(point, newIcon);

    marker.mycategory = StateNM;
    marker.myname = name;
    
    var label1 = 'Site information';
    var site = Site_no;
    var USGS_picture = '<img src = "USGS.gif" width="84" height="32"/>';

    GEvent.addListener(marker, "click", function() {
        ActiveMarker.hide();
        ActiveMarker = new GMarker(point, clickedIcon);

        var sos_url = base_url + "/sos/uv?request=GetObservation&featureId=" + site + "&observedProperty=Discharge&latest";
        $.get(sos_url, function(xml) {
            $(xml).find("[nodeName=wml2:TimeseriesObservation],TimeseriesObservation").each(function(){
                var units = $(this).find("[nodeName=wml2:unitOfMeasure]").attr("uom");
                var time_long = $(this).find("[nodeName=wml2:time]:first").text();
                var time = time_long.substr(0,16);
                time = time.replace("T"," ");
                var value = $(this).find("[nodeName=wml2:value]").first().text();
                var comment = $(this).find("[nodeName=wml2:comment]:first").text();

                var USGS_link = '<a href = "' + USGS_URL + '" >' + Site_no + '</a>';
                var Title = '<table cellpadding="10"><tr><td>' + USGS_picture + '</td><td>' + USGS_link + '</td></table>';
                var Name_html = '<b>' + name + '</b><br />';
                var Watershed_html = '<b>' + watershed + ' Watershed</b><br />';

                var html_header = Title + Name_html + Watershed_html;

                var table_1 = "Latest reading:<br /><center><table border='1'><tr><td>Discharge</td><td>" + time + '</td><td>' + value + ' ' + units + ' <b>' + comment +'</b></td></tr></table></center>';

                var html = html_header + table_1 + '<br />Available data:';
                var gdaDV_url = base_url + "/sos/dv?request=GetDataAvailablity&featureID=" + Site_no + "&offering=00003";
                var gdaUV_url = base_url + "/sos/uv?request=GetDataAvailablity&featureID=" + Site_no + "&offering=00003";

                var Plot_table_UV = "<center><table border='1'><tr><td><center><b>Recent Data</b></center></td><td>Begin Time</td><td>End Time</td></tr>";
                var Plot_table_DV = "<center><table border='1'><tr><td><b><center>Daily Mean</b></center></td><td>Begin Time</td><td>End Time</td></tr>";
                var xml_UV = LoadXML(gdaUV_url);

                $(xml_UV).find("[nodeName=gda:FeaturePropertyTemporalRelationship],FeaturePropertyTemporalRelationship").each(function(){
                    var Property = $(this).find("[nodeName=gda:targetProperty]");
                    var Prop = Property.attr("xlink:title");
                    var Parameter_cd_long = Property.attr("xlink:href");
                    var Parameter_cd_array = Parameter_cd_long.split("_");
                    var Parameter_cd = Parameter_cd_array[1];
                    var beginTime_long = $(this).find("[nodeName=gml:beginPosition]").text();
                    var beginTime = beginTime_long.substr(0,16);
                    var beginDate = beginTime.split(" ")[0];
                    var endTime_long = $(this).find("[nodeName=gml:endPosition]").text();
                    var endTime = endTime_long.substr(0,16);
                    var endDate = endTime.split(" ")[0];
                    var Plot_links_UV = '<a href =' + base_url + '/GoogleMap/DischargePlot.jsp?&featureID=' + site + '&observedProperty=' + Parameter_cd + ',UV&beginPosition=' + LastWeekStr + '&endPosition=' + endDate + '>' + Prop + '</a>';
                    Plot_table_UV = Plot_table_UV + '<tr><td>' + Plot_links_UV + '</td><td>' + beginDate + '</td><td>' + endDate + '</td></tr>';
                });

                var xml_DV = LoadXML(gdaDV_url);
                $(xml_DV).find("[nodeName=gda:FeaturePropertyTemporalRelationship],FeaturePropertyTemporalRelationship").each(function(){
                    var Property_DV = $(this).find("[nodeName=gda:targetProperty]");
                    var Prop_test = Property_DV.attr("xlink:title");
                    var Prop_DV = Prop_test.substring(0,Prop_test.lastIndexOf(' ('));
                    var Parameter_cd_long_DV = Property_DV.attr("xlink:href");
                    var Parameter_cd_array_DV = Parameter_cd_long_DV.split("_");
                    var Parameter_cd_DV = Parameter_cd_array_DV[1];
                    var beginTime_long_DV = $(this).find("[nodeName=gml:beginPosition]").text();
                    var beginTime_DV = beginTime_long_DV.substr(0,16);
                    var beginDate_DV = beginTime_DV.split(" ")[0];
                    var endTime_long_DV = $(this).find("[nodeName=gml:endPosition]").text();
                    var endTime_DV = endTime_long_DV.substr(0,16);
                    var endDate_DV = endTime_DV.split(" ")[0];
                    var endDateYear = parseInt(endTime_DV.split("-")[0]) - 1;
                    var beginDateLink = endDateYear.toString() + '-' + endTime_DV.split("-")[1] + '-' + endTime_DV.split("-")[2];

                    Plot_links_DV = '<a href =' + base_url + '/GoogleMap/DischargePlot.jsp?featureID=' + site + '&observedProperty=' + Parameter_cd_DV + ',DV00003&beginPosition=' + beginDateLink + '&endPosition=' + endDate_DV + '>' + Prop_DV + '</a>';
                    Plot_table_DV = Plot_table_DV + '<tr><td>' + Plot_links_DV + '</td><td>' + beginDate_DV + '</td><td>' + endDate_DV + '</td></tr>';
                });

                var table_2 = '<br />' + Plot_table_UV + '</table></center><br />' + Plot_table_DV + '</table></center><br />';
                html = html + table_2;
//
                
                map.addOverlay(ActiveMarker);   //This adds a new marker over the old one...not allowing you to re-click...need to find better way....
                //marker.openInfoWindowTabsHtml([new GInfoWindowTab(label1,html)]);
                document.getElementById("side_bar").innerHTML = html;
                

            });
        });
    });

    gmarkers.push(marker);
    return marker;
}
