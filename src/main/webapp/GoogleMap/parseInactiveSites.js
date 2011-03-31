function parseInactiveSites() {
    GDownloadUrl("InactiveSites.csv", function(doc) {
        lines = doc.split("\n");
        for (var i = 0; i < lines.length; i++) {
            if (lines[i].length > 1) {
                parts = lines[i].split(",");
                var Lat = parseFloat(parts[0]);
                var Long = parseFloat(parts[1]);
                var name_in = parts[2];
                var point = new GLatLng(Lat, Long);
                var html = "Inactive USGS site: <br />" + name_in;
                var marker = createInactiveMarker(point, html, name_in, "Inactive");
                map.addOverlay(marker);
            }
        }
        hide("Inactive");
    });
}