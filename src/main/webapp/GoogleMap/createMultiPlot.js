function createMultiPlot(sos_url, gdaDV_url, gdaUV_url, service, stat_cd, observedProperty) {
    $(function() {
        var sos_urlArray = sos_url.split(",");
        var serviceArray = service.split(",");
        var stat_cdArray = stat_cd.split(",");
        var observedPropertyArray = observedProperty.split(",");

        var data = new google.visualization.DataTable();

        var sos_splitINI = sos_urlArray[0].split("&");
        var sosINI = sos_splitINI[0] + "&" + sos_splitINI[1] + "&" + sos_splitINI[3] + "&latest";
        var xml = LoadXML(sosINI);
        var name = $(xml).find('[nodeName="gml:name"],name',this).text();
        var Watershed = $(xml).find('[nodeName="om:value"],value', this).text();
        var Location = $(xml).find('[nodeName="gml:pos"],pos', this).text();
        var Org = $(xml).find('[nodeName="gmd:CharacterString"],CharacterString', this).text();

        var html_2 = '<b>' + name + '<br />';
        var html = html_2 + Watershed + ' Watershed </b><br /><b>Location: </b>' + Location + '<br /><b>Managed by: </b>' + Org + '<br /><br />';
        var Plot_table = "<table border='1' cellpadding='2'><tr><td></td><td><center><b>Property</b></center></td><td><center><b>Offering</b></center></td><td><center><b>Begin date</b></center></td><td><center><b>End date</b></center></td></tr>";

        var xml_UV = LoadXML(gdaUV_url);
        $(xml_UV).find('[nodeName="gda:FeaturePropertyTemporalRelationship"],FeaturePropertyTemporalRelationship').each(function(){
            var Property = $(this).find('[nodeName="gda:targetProperty"],targetProperty');
            var Prop = Property.attr("xlink:title");
            var Parameter_cd_long = Property.attr("xlink:href");
            var Parameter_cd_array = Parameter_cd_long.split("_");
            var Parameter_cd = Parameter_cd_array[1];
            var beginTime_long = $(this).find('[nodeName="gml:beginPosition"],beginPosition').text();
            var beginTime = beginTime_long.substr(0,16);
            var beginDate = beginTime.split(" ")[0];
            var endTime_long = $(this).find('[nodeName="gml:endPosition"],endPosition').text();
            var endTime = endTime_long.substr(0,16);
            var endDate = endTime.split(" ")[0];
            var checkbox;
            for (m=0; m < observedPropertyArray.length; m++){
                if (Parameter_cd == observedPropertyArray[m] && serviceArray[m] == 'UV') {
                    checkbox = '<input type="checkbox" name="observedProperty" value="' + Parameter_cd + ',UVUNIT" checked/>';
                    break;
                }
                else {
                    checkbox = '<input type="checkbox" name="observedProperty" value="' + Parameter_cd + ',UVUNIT"/>';
                }
            }
            Plot_table = Plot_table + '<tr><td>' + checkbox + '</td><td>' + Prop + '</td><td>UNIT</td><td>' + beginDate + '</td><td>' + endDate + '</tr>';
        });

        var xml_DV = LoadXML(gdaDV_url);
        $(xml_DV).find('[nodeName="gda:FeaturePropertyTemporalRelationship"],FeaturePropertyTemporalRelationship').each(function(){
            var Property_DV = $(this).find('[nodeName="gda:targetProperty"],targetProperty');
            var Prop_DV = Property_DV.attr("xlink:title");
            var Offering = Property_DV.attr("x-offering");
            var Parameter_cd_long_DV = Property_DV.attr("xlink:href");
            var Parameter_cd_array_DV = Parameter_cd_long_DV.split("_");
            var Parameter_cd_DV = Parameter_cd_array_DV[1];
            var stat_cd_DV = Parameter_cd_array_DV[2];
            var beginTime_long_DV = $(this).find('[nodeName="gml:beginPosition"],beginPosition').text();
            var beginTime_DV = beginTime_long_DV.substr(0,16);
            var beginDate_DV = beginTime_DV.split(" ")[0];
            var endTime_long_DV = $(this).find('[nodeName="gml:endPosition"],endPosition').text();
            var endTime_DV = endTime_long_DV.substr(0,16);
            var endDate_DV = endTime_DV.split(" ")[0];
            var checkbox_DV;
            for (n=0; n < observedPropertyArray.length; n++){
                if (Parameter_cd_DV == observedPropertyArray[n] && serviceArray[n] == 'DV' && stat_cdArray[n] == stat_cd_DV) {
                    checkbox_DV = '<input type="checkbox" name="observedProperty" value="' + Parameter_cd_DV + ',DV' + stat_cd_DV + '" checked/>';
                    break;
                }
                else {
                    checkbox_DV = '<input type="checkbox" name="observedProperty" value="' + Parameter_cd_DV + ',DV' + stat_cd_DV + '"/>';
                }
            }
            Plot_table = Plot_table + '<tr><td>' + checkbox_DV + '</td><td>' + Prop_DV + '</td><td>DAILY ' + Offering + '</td><td>' + beginDate_DV + '</td><td>' + endDate_DV + '</tr>';

        });

        var table_1 = '<b>Available data:</b><br />' + Plot_table + '</table>';
        document.getElementById("side_bar_header").innerHTML = (html);
        document.getElementById("side_bar").innerHTML = (table_1 );
        document.getElementById("Station_name").innerHTML = (html_2);

        data.addColumn('datetime', 'Date');
        var colorINI = ['Red', 'Green', 'Orange', 'Purple', 'Maroon', 'Navy', 'Black', 'Blue', '#0066DD'];
        var color = [];
        for (i = 0; i < sos_urlArray.length; i++){
            var ser = serviceArray[i];
            var stat = stat_cdArray[i];
            var sos_split = sos_urlArray[i].split("&");
            var sos = sos_split[0] + "&" + sos_split[1] + "&" + sos_split[3] + "&latest";
            var ColumnData = LoadXML(sos);
            var units = $(ColumnData).find('[nodeName="wml2:unitOfMeasure"],unitOfMeasure', this).attr("uom");
            var PropertyName = $(ColumnData).find('[nodeName="om:observedProperty"],observedProperty', this).attr("xlink:title");
            var Title = PropertyName + ' (' + units + ')';
            data.addColumn('number', Title);
            if (i == (sos_urlArray.length-1)){
                color[i] = colorINI[8];
            }
            else {
                color[i] = colorINI[i];
            }
        }

        var k = 0;
        for (j = 0; j < sos_urlArray.length; j++){
            var PlotData = LoadXML(sos_urlArray[j]);

            data.addRows($(PlotData).find('[nodeName="wml2:point"],point').length);
            $(PlotData).find('[nodeName="wml2:point"],point').each(function()
            {
                var temp = $('[nodeName="wml2:time"],time', this).text();
                var value = parseFloat($('[nodeName="wml2:value"],value', this).text());
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

                data.setValue(k, 0, date);
                data.setValue(k, (j+1), value);

                k = k + 1;
            });
        }

        var chart = new google.visualization.AnnotatedTimeLine(document.getElementById("chart_div"));
        chart.draw(data,
        {
            'displayAnnotations': true,
            'scaleType':'allmaximized',
            'scaleColumns':[0,1,2],
            'thickness':2,
            'legendPosition':'newRow',
            'colors':color
        });

       google.visualization.events.addListener(chart,'rangechange',function(){
           r1 = chart.getVisibleChartRange();
           var startZoom = new Date(r1.start);
           var endZoom = new Date(r1.end);
           var start = startZoom.getFullYear() + '-' + (startZoom.getMonth()+1) + '-' + startZoom.getDate();
           var end = endZoom.getFullYear() + '-' + (endZoom.getMonth()+1) + '-' + endZoom.getDate();
           document.getElementById("Zoom").innerHTML = ('<b>Start: </b>' + start + '<br /><b>End: </b>' + end);
       });

    });
}