//function LoadXML(filename){
//    if (window.XMLHttpRequest) {
//        xhttp = new XMLHttpRequest();
//    }
//    else {
//        xhttp = new ActiveXObject("Microsoft.XMLHTTP");
//    }
//    xhttp.open("GET", filename, false);
//    xhttp.send("");
//
//    return xhttp.responseXML;
//}
function LoadXML(filename){   
      $.ajax({
        type: "Get",
        url: filename,
        dataType: "xml",
        success: parseXML
      });

}