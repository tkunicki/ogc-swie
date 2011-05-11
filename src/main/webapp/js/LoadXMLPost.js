function LoadXMLPOST(filename,data){
    if (window.XMLHttpRequest) {
        xhttp = new XMLHttpRequest();
    }
    else {
        xhttp = new ActiveXObject("Microsoft.XMLHTTP");
    }
    xhttp.open("POST", filename, false);
    xhttp.send(data);

    return xhttp.responseXML;
}

//$(document).ready(function()
//{
//  $.ajax({
//    type: "Post",
//    url: "filename",
//    dataType: "xml",
//    success: parseXML
//  });
//});

//$.post(filename, function(data) {
//  $('.result').html(data);
//});