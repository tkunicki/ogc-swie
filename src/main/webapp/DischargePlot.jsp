<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
	"http://www.w3.org/TR/html4/loose.dtd">
<%@ page  language="java" import="java.util.*,java.text.*"%>

<%
	Calendar lastWeek = new GregorianCalendar();
	Calendar lastYear = new GregorianCalendar();
	lastWeek.add(Calendar.DAY_OF_YEAR, -7);
	lastYear.add(Calendar.YEAR, -1);

	Date now = new Date();

	SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

	String todayFormated = formatter.format(now);
	String lastWeekFormated = formatter.format(lastWeek.getTime());
	String lastYearFormated = formatter.format(lastYear.getTime());

	String Today = todayFormated;
	String LastWeek = lastWeekFormated;
	String LastYear = lastYearFormated;

	String base_url = request.getRequestURL().toString().replaceAll("/[^/]*$", "");
	String sos_url;
	String service;
	String observedProperty;
	String stat_cd;
	String gdaDV_url = base_url + "/dv/sos?request=GetDataAvailability&featureID=";
	sos_url = "";
	service = "";
	stat_cd = "";
	observedProperty = "";

	String featureID = request.getParameter("featureID");
	String[] Property = request.getParameterValues("observedProperty");
	String beginPosition = request.getParameter("beginPosition");
	String endPosition = request.getParameter("endPosition");

	String[] obsProp;
	String[] stat_cdArray;
	String[] sos_urlArray;
	String[] display_urlArray;
	String[] offeringArray;
	int UVNum = 0;
	int DVNum = 0;
	int N = 0;
	Date beginDate;
	Date endDate;

	if (beginPosition != null) {
		beginDate = (Date) formatter.parse(beginPosition);
	} else {
		beginDate = (Date) formatter.parse(lastWeekFormated);
	}

	if (endPosition != null) {
		endDate = (Date) formatter.parse(endPosition);
	} else {
		endDate = (Date) formatter.parse(todayFormated);
	}

	int MillisecsPerDay = 24 * 60 * 60 * 1000;
	long deltaDays = (endDate.getTime() - beginDate.getTime()) / MillisecsPerDay;

	String Data_link = "";
	String mapLink = "<a href =" + base_url + ">Return home</a>";

	if (Property != null) {
		obsProp = new String[Property.length];
		stat_cdArray = new String[Property.length];
		sos_urlArray = new String[Property.length];
		display_urlArray = new String[Property.length];
		offeringArray = new String[Property.length];

		for (int i = 0; i < Property.length; i++) {
			obsProp[i] = Property[i].split("_")[0];
			offeringArray[i] = Property[i].split("_")[1];
			stat_cdArray[i] = offeringArray[i];

			if (stat_cdArray[i].equals("00000")) {
				sos_urlArray[i] = base_url + "/uv/sos?request=GetObservation&featureId=";
				sos_urlArray[i] = sos_urlArray[i] + featureID + "&offering=Unit&observedProperty=" + obsProp[i];
				display_urlArray[i] = base_url + "/wml2/uv/sos?request=GetObservation&featureId=";
				display_urlArray[i] = display_urlArray[i] + featureID + "&offering=Unit&observedProperty=" + obsProp[i];
				N = N + (int) deltaDays * 96;
			} else {
				sos_urlArray[i] = base_url + "/dv/sos?request=GetObservation&featureId=";
				sos_urlArray[i] = sos_urlArray[i] + featureID + "&offering=" + stat_cdArray[i] + "&observedProperty=" + obsProp[i];
				display_urlArray[i] = base_url + "/wml2/dv/sos?request=GetObservation&featureId=";
				display_urlArray[i] = sos_urlArray[i] + featureID + "&offering=" + stat_cdArray[i] + "&observedProperty=" + obsProp[i];
				N = N + (int) deltaDays;
			}

			if (beginPosition != null) {
				if (beginPosition.equalsIgnoreCase("null") || beginPosition.equalsIgnoreCase("")) {
					sos_urlArray[i] = sos_urlArray[i] + "&beginPosition=" + lastWeekFormated;
					display_urlArray[i] = display_urlArray[i] + "&beginPosition=" + lastWeekFormated;
				} else {
					sos_urlArray[i] = sos_urlArray[i] + "&beginPosition=" + beginPosition;
					display_urlArray[i] = display_urlArray[i] + "&beginPosition=" + beginPosition;
				}
			} else {
				sos_urlArray[i] = sos_urlArray[i] + "&beginPosition=" + lastWeekFormated;
				display_urlArray[i] = display_urlArray[i] + "&beginPosition=" + lastWeekFormated;
			}


			if (endPosition != null) {
				if (endPosition.equalsIgnoreCase("null") || endPosition.equalsIgnoreCase("")) {
					sos_urlArray[i] = sos_urlArray[i] + "&endPosition=" + todayFormated;
					display_urlArray[i] = display_urlArray[i] + "&endPosition=" + todayFormated;
				} else {
					sos_urlArray[i] = sos_urlArray[i] + "&endPosition=" + endPosition;
					display_urlArray[i] = display_urlArray[i] + "&endPosition=" + endPosition;
				}
			} else {
				sos_urlArray[i] = sos_urlArray[i] + "&endPosition=" + todayFormated;
				display_urlArray[i] = display_urlArray[i] + "&endPosition=" + todayFormated;
			}

			Data_link = Data_link + "<a href =" + display_urlArray[i] + ">Link to plot data: offering=" + stat_cdArray[i] + "&observedProperty=" + obsProp[i] + "</a><br />";
			sos_url = sos_url + sos_urlArray[i] + ",";
			stat_cd = stat_cd + stat_cdArray[i] + ",";
			observedProperty = observedProperty + obsProp[i] + ",";

		}

		sos_url = sos_url.substring(0, (sos_url.length() - 1));
		stat_cd = stat_cd.substring(0, (stat_cd.length() - 1));
		observedProperty = observedProperty.substring(0, (observedProperty.length() - 1));
		gdaDV_url = gdaDV_url + featureID;

	} else {
		if (featureID != null) {
			sos_url = base_url + "/dv/sos?request=GetObservation&offering=00003&observedProperty=00060&Interval=ThisYear&featureID=" + featureID;
			stat_cd = "00003";
			observedProperty = "00060";
			gdaDV_url = gdaDV_url + featureID;
			beginPosition = LastYear;
			endPosition = Today;
			N = 365;
		} else {
			sos_url = base_url + "/dv/sos?request=GetObservation&featureId=05082500&offering=00003&observedProperty=00060&Interval=ThisYear";
			featureID = "05082500";
			stat_cd = "00003";
			observedProperty = "00060";
			gdaDV_url = gdaDV_url + "05082500";
			beginPosition = LastYear;
			endPosition = Today;
			N = 365;
		}
	}

%>

<html>
    <head>
        <meta name="publisher" content="USGS"/>
        <meta name="description" content="Home page for water resources information from the US Geological Survey."/>
        <meta name="keywords" content="USGS, U.S. Geological Survey, water, earth science, hydrology, hydrologic, data, streamflow, stream, river, lake, flood, drought, quality, basin, watershed, environment, ground water, groundwater"/>
		<!--        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>-->
        <meta name="publisher" content="USGS - U.S. Geological Survey, Water Resources"/>
        <meta name="expires" content="never"/>

        <link href="http://www.usgs.gov/styles/common.css" rel="stylesheet" type="text/css"/>
        <link href="http://www.usgs.gov/frameworkfiles/styles/custom.css" rel="stylesheet" type="text/css" />
        <link href="http://www.usgs.gov/frameworkfiles/styles/framework.css" rel="stylesheet" type="text/css" />

        <link href="styles/custom-theme/jquery.ui.all.css" rel="stylesheet"/>
        <meta http-equiv="content-type" content="text/html; charset=UTF-8"/>

        <title>OGC Services</title>
        <style type="text/css">
			h1 {font-size: 3em;
                margin: 1px 0;
                font: 18px Helvetica;
            }
		</style>
		<!--        <script type="text/javascript" src="https://www.google.com/jsapi?key=ABQIAAAA_s7fSqhIs_dt6wGcko6mSRT0fazSD1VpH7Mi_uflQ_dFOWTAeBRRlw3A34pENLWUzwjXtIwUQHBc6Q" ></script>-->
		<script type="text/javascript" src="https://www.google.com/jsapi?autoload=%7B%22modules%22%3A%5B%7B%22name%22%3A%22visualization%22%2C%22version%22%3A%221%22%2C%22packages%22%3A%5B%22annotatedtimeline%22%5D%7D%5D%7D&key=ABQIAAAA_s7fSqhIs_dt6wGcko6mSRT0fazSD1VpH7Mi_uflQ_dFOWTAeBRRlw3A34pENLWUzwjXtIwUQHBc6Q"></script>
        <script src="js/jquery-1.6.js" type="text/javascript" ></script>
        <script src="js/LoadXML.js" type="text/javascript"></script>
        <script src="js/LoadXMLGDA.js" type="text/javascript"></script>
        <script src="js/createMultiPlot.js" type="text/javascript" ></script>
        <script src="js/jquery.ui.core.min.js" type="text/javascript" ></script>
        <script src="js/jquery.ui.widget.min.js" type="text/javascript" ></script>
        <script src="js/jquery-ui-1.8.12.custom.min.js" type="text/javascript" ></script>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<script type='text/javascript'>
			$(function() {
				var dates = $( "#from, #to" ).datepicker({
					maxDate: "0",
					changeMonth: true,
					changeYear: true,
					dateFormat:'yy-mm-dd',
					showButtonPanel: true,
					showOn: "button",
					buttonImage: "img/calendar.gif",
					buttonImageOnly: true,
					onSelect: function( selectedDate ) {
						var option = this.id == "from" ? "minDate" : "maxDate";
						var instance = $( this ).data( "datepicker" );
						var date = $.datepicker.parseDate(
						instance.settings.dateFormat ||	$.datepicker._defaults.dateFormat,
						selectedDate,
						instance.settings );
						dates.not( this ).datepicker( "option", option, date );
					}
				});

			});
		</script>
        <script type="text/javascript">
            function chkcontrol(j) {
                var total=0;
                for(var i=0; i < document.chooseData.observedProperty.length; i++){
                    if(document.chooseData.observedProperty[i].checked){
						total =total +1;
                    }
                    if(total > 3){
						alert("Please select no more than three")
						document.chooseData.observedProperty[i].checked = false ;
						return false;
                    }
                }
            } 
        </script>
        <script type="text/javascript">

            var gdaDV_url = '<%=gdaDV_url%>';
            var sos_url = '<%=sos_url%>';
            var stat_cd = '<%=stat_cd%>';
            var N = '<%=N%>';
            var observedProperty = '<%=observedProperty%>';
            google.load('visualization', '1', {'packages':['annotatedtimeline']});
            google.setOnLoadCallback(function(){cida.createMultiPlot (sos_url, gdaDV_url, stat_cd, observedProperty, N)});

        </script>
		<jsp:include page="template/css.jsp"></jsp:include>
    </head>
    <body>
		<img alt="Spinner"  style="display: none;" src = "img/ajax-loader.gif" id="loading_image"/>
        <table cellpadding="0" cellspacing="0" width="100%">
            <tr>
                <td width="100%" valign="top"><!-- START header and top navigation section -->
					<jsp:include page="template/usgsheader.jsp"></jsp:include>
                </td>
            </tr>
        </table>

        <h1>Forecasting Interoperability Experiment USGS Timeseries Observations</h1>
        <br />
		<table>
			<tr>
				<td>
					<jsp:include page="template/sidebar.jsp"></jsp:include>
				<td>
					<table>
						<tr>
							<td
								<center><div id='Station_name' ></div></center>
								<b>Note: </b>Data loading performs best in <b>Firefox, Chrome, Safari, or IE9</b>.
							</td>
						</tr>
						<tr>
							<td>
								<!--                            <div class="demo"><div id="progressbar"></div></div>-->
								<div id='chart_div' style='width: 560px; height: 400px;'>
									<img alt="Spinner" src = "img/ajax-loader.gif" id="loading_image"/>
								</div><br />
								Provisional data subject to revision<br /><%=Data_link%><%=mapLink%>
							</td>
							<td>
								<form action="DischargePlot.jsp" >
									<table style="width:400px">
										<tr>
											<td><input type="submit" value="Get New Station:" tabindex="1"/><input type="text" name="featureID" size="10" value="<%=featureID%>" tabindex="1"/></td>
											<td align="right">
												<!--                        <img src = "img/USGS.gif" width="84" height="31" alighn="right"/><br />-->
											</td>
										</tr>
									</table>
								</form>
								<form id="chooseData" name="chooseData" action="DischargePlot.jsp" >

									<table style="width:300px">
										<tr><td><input type="hidden" name="featureID" value="<%=featureID%>"/></td></tr>
										<tr><td width=119 align="right"><b>Begin Date: </b><div class="demo"><input type="text" id="from" name="beginPosition" size="10" value="<%=beginPosition%>" tabindex="2"/></div></td><td align="right"></td><td align="right"><b>Plot Begins:</b><div id='ZoomBegin'><%=beginPosition%></div></td></tr>
										<tr><td align="right"><b>End Date: </b><div class="demo"><input type="text" id="to" name="endPosition" value="<%=endPosition%>" tabindex="3" size="10"/></div></td><td align="right"></td><td align="right"><b>Plot Ends:</b><div id='ZoomEnd' ><%=endPosition%></div></td></tr>
									</table>
									<b>Available Data (choose up to 3 properties to plot):</b><br />
									<div id='side_bar' style="height: 300px; width: 400px; overflow: auto">Loading...<img alt="Spinner"  src = "img/ajax-loader.gif" /></div><br />
									<input type="submit" value="Submit" tabindex="5"/>

								</form>

							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>

		<span> <font size="0.5"><br />* References to non-U.S. Department of the Interior (DOI) products do not constitute an endorsement by the DOI. By viewing the Google Visualization API on this web site the user agrees to these
				<a href="http://code.google.com/apis/visualization/terms.html" target="_blank" title="Opens a new browser window.">Terms of Service set forth by Google</a>.<br /></font></span>
		<br />


	<jsp:include page="template/usgsfooter.jsp"></jsp:include>

	</body>
</html>
