var cida = {};

cida.createMultiPlot = function(sos_url, gdaDV_url, stat_cd, observedProperty, N) {
    $(function() {

        var sos_urlArray = sos_url.split(",");
        var stat_cdArray = stat_cd.split(",");
        var observedPropertyArray = observedProperty.split(",");

        var data = new google.visualization.DataTable();
        data.addColumn('datetime', 'Date');
        var Plot_table = "<table border='1' cellpadding='2'><tr><td></td><td><center><b>Property</b></center></td><td><center><b>Begin date</b></center></td><td><center><b>End date</b></center></td></tr>";
        var xml_Data = LoadXMLGDA(gdaDV_url);
        var name = $(xml_Data).find('[nodeName="gda:targetFeature"],targetFeature',this).attr("xlink:title");
        var station = $(xml_Data).find('[nodeName="gda:targetFeature"],targetFeature',this).attr("xlink:href").split("_")[1];
        var html = '<b>' + name + '</b> : ' + station;

        var colorINI = ['Maroon', 'Green', 'Orange', 'Purple', 'Red', 'Navy', 'Black', 'Blue', '#0066DD'];
        var color = [];

        $(xml_Data).find('[nodeName="gda:FeaturePropertyTemporalRelationship"],FeaturePropertyTemporalRelationship').each(function(){
            var Property = $(this).find('[nodeName="gda:targetProperty"],targetProperty');
            var Prop = Property.attr("xlink:title");
            var Parameter_cd_long = Property.attr("xlink:href");
            var Parameter_cd_array = Parameter_cd_long.split("_");
            var Parameter_cd = Parameter_cd_array[1];
            var stat_cd = Parameter_cd_array[2];
            var beginTime_long = $(this).find('[nodeName="gml:beginPosition"],beginPosition').text();
            var beginTime = beginTime_long.substr(0,16);
            var beginDate = beginTime.split(" ")[0];
            var endTime_long = $(this).find('[nodeName="gml:endPosition"],endPosition').text();
            var endTime = endTime_long.substr(0,16);
            var endDate = endTime.split(" ")[0];
            var checkbox;

            for (n=0; n < observedPropertyArray.length; n++){
                if (Parameter_cd == observedPropertyArray[n] && stat_cdArray[n] == stat_cd) {
                    checkbox = '<input type="checkbox" name="observedProperty" value="' + Parameter_cd + '_' + stat_cd + '" checked/>';
                    data.addColumn('number', Prop);
                    if (n == (sos_urlArray.length-1)){
                        color[n] = colorINI[8];
                    }
                    else {
                        color[n] = colorINI[n];
                    }
                    break;
                } else {
                    checkbox = '<input type="checkbox" name="observedProperty" value="' + Parameter_cd + '_' + stat_cd + '"/>';
                }
            }
            Plot_table = Plot_table + '<tr><td>' + checkbox + '</td><td>' + Prop + '</td><td>' + beginDate + '</td><td>' + endDate + '</tr>';
        });

        var table_1 = Plot_table + '</table>';

        document.getElementById("side_bar").innerHTML = (table_1 );
        document.getElementById("Station_name").innerHTML = (html);

        var k = 0;
//        $( "#progressbar" ).progressbar({value: 0});
        for (j = 0; j < sos_urlArray.length; j++){
            var PlotData = LoadXMLGDA(sos_urlArray[j]);

            data.addRows($(PlotData).find('[nodeName="wml2:point"],point').length);
            $(PlotData).find('[nodeName="wml2:point"],point').each(function(){

                var temp = $('[nodeName="wml2:time"],time', this).text();
                var value = parseFloat($('[nodeName="wml2:value"],value', this).text());
                var timestamp = temp.substr(0, 18);

                var temp2 = timestamp.split("T");
                var time = temp2[1].split(":");
                var fullDate = temp2[0].split("-");
                var month = parseFloat(fullDate[1]) - 1;
                var year = fullDate[0];
                var day = fullDate[2];
                var hours = time[0];
                var minutes = time[1];
                var seconds = time[2];
                var date = new Date(year,month,day,hours, minutes, seconds, 0);
                data.setValue(k, 0, date);
                data.setValue(k, (j+1), value);
                var percent = (k * 100)/N;
//                $("#progressbar").progressbar({value: percent});
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
//       $("#progressbar").hide('slow');
       google.visualization.events.addListener(chart,'rangechange',function(){
           r1 = chart.getVisibleChartRange();
           var startZoom = new Date(r1.start);
           var endZoom = new Date(r1.end);
           var start = startZoom.getFullYear() + '-' + (startZoom.getMonth()+1) + '-' + startZoom.getDate();
           var end = endZoom.getFullYear() + '-' + (endZoom.getMonth()+1) + '-' + endZoom.getDate();
           document.getElementById("ZoomBegin").innerHTML = (start);
           document.getElementById("ZoomEnd").innerHTML = (end);
       });

    });
}