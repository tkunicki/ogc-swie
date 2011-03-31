function createInactiveMarker(point, html, name, category) {
    var newIcon = MapIconMaker.createMarkerIcon({
        primaryColor: "#33CC66"
    });
    var marker = new GMarker(point, newIcon);
    marker.mycategory = category;
    marker.myname = name;
    GEvent.addListener(marker, "click", function() {
        marker.openInfoWindowHtml(html);
    });
    gmarkers.push(marker);
    return marker;
}