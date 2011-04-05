function createPlot(sos_url, wfs_url, gdaDV_url, gdaUV_url, service, stat_cd, observedProperty) {
    $(function() {

        var data = new google.visualization.DataTable();

        var xml = LoadXML(sos_url);
        var units = $(xml).find("[nodeName=wml2:unitOfMeasure],unitOfMeasure", this).attr("uom");

        var PropertyName = $(xml).find("[nodeName=om:observedProperty],observedProperty", this).attr("xlink:title");
        var Title = PropertyName + ' (' + units + ')';
        data.addColumn('datetime', 'Date');
        data.addColumn('number', Title);

        $(xml).find("[nodeName=wml2:point],point").each(function()
        {
            var temp = $("[nodeName=wml2:time]", this).text();
            var value = parseFloat($("[nodeName=wml2:value]", this).text());
            var timestamp = temp.substr(0, 18);
            var date = new Date();
            var UTCOffsetHours = parseInt(temp.substr(19, 2));

            var temp2 = timestamp.split("T");
            var time = temp2[1].split(":");
            var fullDate = temp2[0].split("-");
            var month = parseFloat(fullDate[1]) - 1;
            var year = fullDate[0];
            var day = fullDate[2];
            var hours = time[0];
            var minutes = time[1];
            var seconds = time[2];
            date.setFullYear(year,month,day);
            date.setHours(hours, minutes, seconds, 0);

            data.addRow([date,value]);
        });

        var xml_wfs = LoadXML(wfs_url);
        var name = $(xml_wfs).find("[nodeName=gml:name]", this).text();
        var Watershed = $(xml_wfs).find("[nodeName=om:value]", this).text();
        var Location = $(xml_wfs).find("[nodeName=gml:pos]", this).text();
        var Org = $(xml_wfs).find("[nodeName=gmd:CharacterString]", this).text();

        html = '<b>' + name + '<br />' + Watershed + ' Watershed </b><br /><b>Location: </b>' + Location + '<br /><b>Managed by: </b>' + Org + '<br /><br />';
        var html_2 = '<b>' + name + '<br />';
        document.getElementById("Station_name").innerHTML = (html_2);

        var Plot_table_UV = "<table border='1' cellpadding='2'><tr><td></td><td><center><b>Real Time</b></center></td><td>Begin date</td><td>End date</td></tr>";
        var Plot_table_DV = "<table border='1' cellpadding='2'><tr><td></td><td><b><center>Daily</b></center></td><td>Offering</td><td>Begin date</td><td>End date</td></tr>";

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
            if (Parameter_cd == observedProperty && service == 'UV') {
                var radio = '<input type="radio" name="observedProperty" value="' + Parameter_cd + ',UV" checked/>';
            }
            else {
                var radio = '<input type="radio" name="observedProperty" value="' + Parameter_cd + ',UV"/>';
            }
            Plot_table_UV = Plot_table_UV + '<tr><td>' + radio + '</td><td>' + Prop + '</td><td>' + beginDate + '</td><td>' + endDate + '</tr>';
        });

        var xml_DV = LoadXML(gdaDV_url);
        $(xml_DV).find("[nodeName=gda:FeaturePropertyTemporalRelationship],FeaturePropertyTemporalRelationship").each(function(){
            var Property_DV = $(this).find("[nodeName=gda:targetProperty]");
            var Prop_DV = Property_DV.attr("xlink:title");
            var Offering = Property_DV.attr("x-offering");
            var Parameter_cd_long_DV = Property_DV.attr("xlink:href");
            var Parameter_cd_array_DV = Parameter_cd_long_DV.split("_");
            var Parameter_cd_DV = Parameter_cd_array_DV[1];
            var stat_cd_DV = Parameter_cd_array_DV[2];
            var beginTime_long_DV = $(this).find("[nodeName=gml:beginPosition]").text();
            var beginTime_DV = beginTime_long_DV.substr(0,16);
            var beginDate_DV = beginTime_DV.split(" ")[0];
            var endTime_long_DV = $(this).find("[nodeName=gml:endPosition]").text();
            var endTime_DV = endTime_long_DV.substr(0,16);
            var endDate_DV = endTime_DV.split(" ")[0];
            if (Parameter_cd_DV == observedProperty && service == 'DV' && stat_cd == stat_cd_DV) {
                var radio_DV = '<input type="radio" name="observedProperty" value="' + Parameter_cd_DV + ',DV' + stat_cd_DV + '" checked/>';
            }
            else {
                var radio_DV = '<input type="radio" name="observedProperty" value="' + Parameter_cd_DV + ',DV' + stat_cd_DV + '"/>';
            }

            Plot_table_DV = Plot_table_DV+ '<tr><td>' + radio_DV + '</td><td>' + Prop_DV + '</td><td>' + Offering + '</td><td>' + beginDate_DV + '</td><td>' + endDate_DV + '</tr>';

        });

        var table_1 = 'Available data:<br />' + Plot_table_UV + '</table><br />' + Plot_table_DV + '</table><br />';
        document.getElementById("side_bar_header").innerHTML = (html);
        document.getElementById("side_bar").innerHTML = (table_1 );

        var chart = new google.visualization.AnnotatedTimeLine(document.getElementById("chart_div"));
        chart.draw(data,
        {
            'displayAnnotations': true,
            'scaleType':'maximized'
        //                    'scaleColumns':[0,1]
        });
    });
}