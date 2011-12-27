function createMarker(point, name, StateNM, Site_no, USGS_URL, base_url, watershed)
{
//    var marker = new GMarker(point, newIcon);
    var customIcon = new GIcon(G_DEFAULT_ICON);
    customIcon.image = "img/40px-Green_equilateral_triangle_point_up.svg.png";
    customIcon.iconSize = new GSize(10, 9);
    customIcon.iconAnchor = new GPoint(5,3);
    var marker = new GMarker(point, customIcon);
    var USGS_link = 'Station number: <a href = "' + USGS_URL + '" >' + Site_no + '</a>';
    var Name_html = '<b>' + name + '</b><br />';
    var Watershed_html = '<b>' + watershed + ' Watershed</b><br />';
    var html_header = Name_html + Watershed_html + USGS_link;

    GEvent.addListener(marker,"mouseover", function() {
        document.getElementById("StationInfo").innerHTML = Name_html;
    });

    GEvent.addListener(marker,"mouseout", function() {document.getElementById("StationInfo").innerHTML = ""});
    GEvent.addListener(marker, "click", function() {
    ActiveMarker.hide();
    ActiveMarker = new GMarker(point, clickedIcon);

    var Properties = [];
    var time = "";
    document.getElementById("AvailableData").innerHTML = 'Loading...<img src = "img/ajax-loader.gif" />';

    var gdaDV_url = base_url + "/dv/sos?request=GetDataAvailability&featureID=" + Site_no;

    var Data_table = "<center><table border='1'><tr><td><b><center>Property</center></b></td><td><center><b>Begin Time</center></b></td><td><b><center>End Time</center></b></td></tr>";

    var xml_Data = LoadXMLGDA(gdaDV_url);
    $(xml_Data).find('[nodeName="gda:FeaturePropertyTemporalRelationship"],FeaturePropertyTemporalRelationship').each(function(){
        var Property = $(this).find('[nodeName="gda:targetProperty"],targetProperty');
        var Prop = Property.attr("xlink:title");
        var Parameter_cd_long = Property.attr("xlink:href");
        var Parameter_cd_array = Parameter_cd_long.split("_");
        var Parameter_cd = Parameter_cd_array[1];
        var Offering_cd = Property.attr("xlink:href").split("_")[2];
        var beginTime_long = $(this).find('[nodeName="gml:beginPosition"],beginPosition').text();
        var beginTime = beginTime_long.substr(0,16);
        var beginDate = beginTime.split(" ")[0];
        var endTime_long = $(this).find('[nodeName="gml:endPosition"],endPosition').text();
        var endTime = endTime_long.substr(0,16);
        var endDate = endTime.split(" ")[0];
        var EndYear = endDate.split("-")[0];
        var EndMonth = endDate.split("-")[1]-1;
        var EndDay = endDate.split("-")[2];
        var Start = new Date(EndYear, EndMonth, EndDay);
        var lastWeek = new Date(Start);
		lastWeek.setDate(lastWeek.getDate()-7);
        var NewYear = lastWeek.getFullYear();
        var NewMonth = lastWeek.getMonth();
        var NewDay = lastWeek.getDate();
        NewMonth = NewMonth + 1;
		if (Offering_cd != '00000') {
            NewYear = NewYear - 1;
        }
        if (NewMonth < 10) {
            NewMonth = '0' + NewMonth;
        }
        if (NewDay < 10) {
            NewDay = '0' + NewDay;
        }
        var StartFormatted = NewYear + '-' + NewMonth + '-' + NewDay;

        var Plot_links = '<a href =' + base_url + '/DischargePlot.jsp?&featureID=' + Site_no + '&observedProperty=' + Parameter_cd + '_' + Offering_cd;
        Plot_links = Plot_links + '&beginPosition=' + StartFormatted + '&endPosition=' + endDate + '>' + Prop + '</a>';
        Data_table = Data_table + '<tr><td>' + Plot_links + '</td><td>' + beginDate + '</td><td>' + endDate + '</td></tr>';
    });

    var AvailableTable = Data_table + '</table></center>';
    document.getElementById("AvailableDataHeader").innerHTML = '<b><i>Clicked Marker:</i></b><br />' + html_header + '<br /><b>Available Data:</b><br />';
    document.getElementById("AvailableData").innerHTML = AvailableTable;


    map.addOverlay(ActiveMarker);

    });

    return marker;
}