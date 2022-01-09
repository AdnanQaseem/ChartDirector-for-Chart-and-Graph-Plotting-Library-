<%@page import="java.text.SimpleDateFormat"%>
<%@page import="ChartDirector.*, java.util.*"%>
<%@page import="com.chart.controller.GetChartData"%>
<%!//
	// Initialize the WebChartViewer when the page is first loaded
	//
	
	GetChartData gt;

	int[] slots;

	int[] MachNo;

	String startDate = "2018-10-01";
	String endDate = "2020-10-30";
	int Real_SN = 0000;
	int MachineNo = 1;
	String clmnsName = "";
	int xx = 0;
	private void initViewer(WebChartViewer viewer) {
		try{
		gt = new GetChartData();
		slots = gt.getAllSlotNo();

		MachNo = gt.getAllMachineNo();
		// The full x-axis range is from Jan 1, 2007 to Jan 1, 2012
		java.util.Date startDatee = new GregorianCalendar(2010, 1, 1).getTime();
		java.util.Date endDatee = new GregorianCalendar(2022, 1, 1).getTime();
		viewer.setFullRange("x", startDatee, endDatee);

		// Initialize the view port to show the last 366 days (out of 1826 days)
		viewer.setViewPortWidth(366.0 / 1826);
		viewer.setViewPortLeft(1 - viewer.getViewPortWidth());

		// Set the maximum zoom to 10 days (out of 1826 days)
		viewer.setZoomInWidthLimit(10.0 / 1826);
		}
		catch(Exception e){}
	}

	//custom function to get XYChart
	
	private XYChart getXYChart(XYChart c,ArrayList<String> data000,LineLayer layer,String clmnSelect,Date[] timeStamps){
		
		double[] data0;
// 			c.setPlotArea(55, 55, c.getWidth() - 80, c.getHeight() - 90,
// 					c.linearGradientColor(0, 55, 0, c.getHeight() - 35, 0xf0f6ff, 0xa0c0ff), -1, Chart.Transparent,
// 					0xffffff, 0xffffff);

			c.setPlotArea(60, 20, 520, 150, 0xffffff, -1, -1, 0xcccccc, 0xcccccc);
			
// 			c.setPlotArea(55, 55, c.getWidth() - 80, c.getHeight() - 90,
// 					c.linearGradientColor(0, 55, 0, c.getHeight(), 0xf0f6ff, 0xa0c0ff), -1, Chart.Transparent,
// 					0xffffff, 0xffffff);
			c.setClipping();
			
			c.xAxis().setColors(Chart.Transparent);
			c.yAxis().setColors(Chart.Transparent);
			
			c.yAxis().setTitle(clmnSelect, "Arial Bold Italic", 10);
			
			layer=c.addLineLayer2();
			layer.setLineWidth(2);
			
			layer.setFastLineMode();
			
			layer.setXData(timeStamps);
			
			
			
			data0 = new double[gt.getrowcount()];
			data0=gt.getvalus(data000);
			layer.addDataSet(data0, 0xFF0000, clmnSelect);
			
			
			c.xAxis().setFormatCondition("align", 360 * 86400);
			c.xAxis().setLabelFormat("{value|yyyy}");
			
			
			// If all ticks are monthly aligned, then we use "mmm yyyy" in bold font as the first label of a
			// year, and "mmm" for other labels.
			c.xAxis().setFormatCondition("align", 30 * 86400);
			c.xAxis().setMultiFormat(Chart.StartOfYearFilter(), "<*font=bold*>{value|mmm yyyy}", Chart.AllPassFilter(),
					"{value|mmm}");
			

			// If all ticks are daily algined, then we use "mmm dd<*br*>yyyy" in bold font as the first
			// label of a year, and "mmm dd" in bold font as the first label of a month, and "dd" for other
			// labels.
			c.xAxis().setFormatCondition("align", 86400);
			c.xAxis().setMultiFormat(Chart.StartOfYearFilter(),
					"<*block,halign=left*><*font=bold*>{value|mmm dd<*br*>yyyy}", Chart.StartOfMonthFilter(),
					"<*font=bold*>{value|mmm dd}");
			c.xAxis().setMultiFormat2(Chart.AllPassFilter(), "{value|dd}");
			
			

			// For all other cases (sub-daily ticks), use "hh:nn<*br*>mmm dd" for the first label of a day,
			// and "hh:nn" for other labels.
			c.xAxis().setFormatCondition("else");
			c.xAxis().setMultiFormat(Chart.StartOfDayFilter(), "<*font=bold*>{value|hh:nn<*br*>mmm dd}",
					Chart.AllPassFilter(), "{value|hh:nn}");
			
			
		return c;
	}
	
	//
	// Draw the chart
	//
	
	private void drawChart(WebChartViewer viewer) throws Exception {
		
		// Determine the visible x-axis range
				java.util.Date viewPortStartDate = Chart.NTime(viewer.getValueAtViewPort("x", viewer.getViewPortLeft()));
				java.util.Date viewPortEndDate = Chart
						.NTime(viewer.getValueAtViewPort("x", viewer.getViewPortLeft() + viewer.getViewPortWidth()));
				
		System.out.println("the startDate is  #"+viewer.getCustomAttr("startDate"));
		System.out.println("the enddate is  #"+viewer.getCustomAttr("enddate"));
		System.out.println("the Slot Number is  #"+viewer.getCustomAttr("Slot_No"));
		System.out.println("the Machine_No Number is  #"+viewer.getCustomAttr("Machine_No"));
// 		System.out.println("the select is  #"+viewer.getCustomAttr("clmnSelect"));
		
		if (viewer.getCustomAttr("startDate") != null && viewer.getCustomAttr("startDate") != "") {
			startDate = viewer.getCustomAttr("startDate");
			endDate = viewer.getCustomAttr("enddate");
			Real_SN = Integer.parseInt(viewer.getCustomAttr("Slot_No"));
			MachineNo = Integer.parseInt(viewer.getCustomAttr("Machine_No"));
// 			clmnsName =  viewer.getCustomAttr("clmnSelect");
			
// 			System.out.println("the select is  #"+clmnsName);

		}
		ArrayList<String> data000;
		double[] data0;

		
		ArrayList<String> data012 = gt.fetchData1(startDate, endDate, Real_SN, MachineNo, "Write_down_Date");
		
		Date[] timeStamps= new Date[data012.size()];
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		int i = 0;
		for (String dateValue : data012) {
			timeStamps[i++] = dateFormat.parse(dateValue);
		}
		

		

		// We need to get the data within the visible x-axis range. In real code, this can be by using a
		// database query or some other means as specific to the application. In this demo, we just
		// generate a random data table, and then select the data within the table.


		// Select the data for the visible date range viewPortStartDate to viewPortEndDate. It is
		// possible there is no data point at exactly viewPortStartDate or viewPortEndDate. In this
		// case, we also need the data points that are just outside the visible date range to "overdraw"
		// the line a little bit (the "overdrawn" part will be clipped to the plot area) In this demo,
		// we do this by adding a one day margin to the date range when selecting the data.

		// The selected data from the random data table
		//
		// Now we have obtained the data, we can plot the chart.
		//

		//================================================================================
		// Configure overall chart appearance.
		//================================================================================

		// Create an XYChart object of size 640 x 350 pixels
		

		MultiChart m = new MultiChart(640, 2420);
				
		
		XYChart[] c=new XYChart[12];LineLayer[] layer=new LineLayer[12];
		

		int curny=0;
		
		if (!"F".equals(viewer.getCustomAttr("Metal_mass"))) {
 			
 			data000 = gt.fetchData1(startDate, endDate, Real_SN, MachineNo, "Metal_mass");

 			c[0]= new XYChart(640, 200,0xeeeeff, 0x000000, 1);
 			
 			c[0]=getXYChart(c[0], data000,layer[0],"Metal_mass",timeStamps);
 			
 			m.addChart(0, curny, c[0]);
 			curny+=200;
		}
		
		if (!"F".equals(viewer.getCustomAttr("Fe_Content"))) {
 			
 			data000 = gt.fetchData1(startDate, endDate, Real_SN, MachineNo, "Fe_Content");

 			c[1]= new XYChart(640, 200,0xeeeeff, 0x000000, 1);
 			
 			c[1]=getXYChart(c[1], data000,layer[1],"Fe_Content",timeStamps);
 			m.addChart(0, curny, c[1]);
 			curny+=200;
		}
		
		if (!"F".equals(viewer.getCustomAttr("Metal_Quality"))) {
 			
 			data000 = gt.fetchData1(startDate, endDate, Real_SN, MachineNo, "Metal_Quality");

 			c[2]= new XYChart(640, 200,0xeeeeff, 0x000000, 1);
 			
 			c[2]=getXYChart(c[2], data000,layer[2],"Metal_Quality",timeStamps);
 			
 			m.addChart(0, curny, c[2]);
 			curny+=200;	
		}
		
		
		if (!"F".equals(viewer.getCustomAttr("Si_Content"))) {
 			
 			data000 = gt.fetchData1(startDate, endDate, Real_SN, MachineNo, "Si_Content");

 			c[3]= new XYChart(640, 200,0xeeeeff, 0x000000, 1);
 			
 			c[3]=getXYChart(c[3], data000,layer[3],"Si_Content",timeStamps);
 			
 			m.addChart(0, curny, c[3]);
 			curny+=200;
 			
		}
		
		if (!"F".equals(viewer.getCustomAttr("Bath_Ratio"))) {
 			
 			data000 = gt.fetchData1(startDate, endDate, Real_SN, MachineNo, "Bath_Ratio");

 			c[4]= new XYChart(640, 200,0xeeeeff, 0x000000, 1);
 			
 			c[4]=getXYChart(c[4], data000,layer[4],"Bath_Ratio",timeStamps);
 			
 			m.addChart(0, curny, c[4]);
 			curny+=200;
 			
		}
		
		if (!"F".equals(viewer.getCustomAttr("Bath_Height"))) {
 			
 			data000 = gt.fetchData1(startDate, endDate, Real_SN, MachineNo, "Bath_Height");

 			c[5]= new XYChart(640, 200,0xeeeeff, 0x000000, 1);
 			
 			c[5]=getXYChart(c[5], data000,layer[5],"Bath_Height",timeStamps);
 			
 			m.addChart(0, curny, c[5]);
 			curny+=200;
 			
		}
		
		if (!"F".equals(viewer.getCustomAttr("Metal_Height"))) {
 			
 			data000 = gt.fetchData1(startDate, endDate, Real_SN, MachineNo, "Metal_Height");

 			c[6]= new XYChart(640, 200,0xeeeeff, 0x000000, 1);
 			
 			c[6]=getXYChart(c[6], data000,layer[6],"Metal_Height",timeStamps);
 			
 			m.addChart(0, curny, c[6]);
 			curny+=200;
 			
		}

		if (!"F".equals(viewer.getCustomAttr("Bath_Temperature"))) {
 			
 			data000 = gt.fetchData1(startDate, endDate, Real_SN, MachineNo, "Bath_Temperature");

 			c[7]= new XYChart(640, 200,0xeeeeff, 0x000000, 1);
 			
 			c[7]=getXYChart(c[7], data000,layer[7],"Bath_Temperature",timeStamps);
 			
 			m.addChart(0, curny, c[7]);
 			curny+=200;
 			
		}
		
		if (!"F".equals(viewer.getCustomAttr("CVD"))) {
 			
 			data000 = gt.fetchData1(startDate, endDate, Real_SN, MachineNo, "CVD");

 			c[8]= new XYChart(640, 200,0xeeeeff, 0x000000, 1);
 			
 			c[8]=getXYChart(c[8], data000,layer[8],"CVD",timeStamps);
 			
 			m.addChart(0, curny, c[8]);
 			curny+=200;
 			
		}
		
		if (!"F".equals(viewer.getCustomAttr("ACD"))) {
 			
 			data000 = gt.fetchData1(startDate, endDate, Real_SN, MachineNo, "ACD");

 			c[9]= new XYChart(640, 200,0xeeeeff, 0x000000, 1);
 			
 			c[9]=getXYChart(c[9], data000,layer[9],"ACD",timeStamps);
 			
 			m.addChart(0, curny, c[9]);
 			curny+=200;
 			
		}

		if (!"F".equals(viewer.getCustomAttr("Superheat"))) {
		
		data000 = gt.fetchData1(startDate, endDate, Real_SN, MachineNo, "Superheat");

		c[10]= new XYChart(640, 200,0xeeeeff, 0x000000, 1);
		
		c[10]=getXYChart(c[10], data000,layer[10],"Superheat",timeStamps);
		
		m.addChart(0, curny, c[10]);
		curny+=200;
		
		}
		if (!"F".equals(viewer.getCustomAttr("Al2O3_Concen"))) {
			
			data000 = gt.fetchData1(startDate, endDate, Real_SN, MachineNo, "Al2O3_Concen");

			c[11]= new XYChart(640, 200,0xeeeeff, 0x000000, 1);
			
			c[11]=getXYChart(c[11], data000,layer[8],"Al2O3_Concen",timeStamps);
			
			m.addChart(0, curny, c[11]);
			curny+=200;
			
		}

		//================================================================================
		// Configure axis scale and labelling
		//================================================================================
		// Set the x-axis as a date/time axis with the scale according to the view port x range.
		for(int z=0;z<12;z++){
		viewer.syncDateAxisWithViewPort("x", c[z].xAxis());
		}
		
		
		//================================================================================
		// Step 5 - Output the chart
		//================================================================================

		// Output the chart
		
		
		
		String chartQuery = m.makeSession(viewer.getRequest(), viewer.getId());
		


		// Set the chart URL to the viewer
		viewer.setImageUrl("getchart.jsp?" + chartQuery);

		// Output Javascript chart model to the browser to support tracking cursor
// 		viewer.setChartModel(c[0].getJsChartModel());
		viewer.setChartModel(m.getJsChartModel());
		curny=0;
		
	}%>
<%
	//
// This script handles both the full page request, as well as the subsequent partial updates (AJAX
// chart updates). We need to determine the type of request first before we processing it.
//

// Create the WebChartViewer object
WebChartViewer viewer = new WebChartViewer(request, "chart1");

if (viewer.isPartialUpdateRequest()) {
	// Is a partial update request. Draw the chart and perform a partial response.
	drawChart(viewer);
	out.clear();
	viewer.partialUpdateChart(response);
	return;
}

//
// If the code reaches here, it is a full page request.
//

// In this exapmle, we just need to initialize the WebChartViewer and draw the chart.
initViewer(viewer);
drawChart(viewer);
%>

<!DOCTYPE html>
<html>
<head>
<title>Zooming and Scrolling with Track Line</title>
<script type="text/javascript" src="cdjcv.js"></script>
<script type="text/javascript" src="js/jquery-3.3.1.min.js"></script>
<link rel="stylesheet" href="css/bootstrap.min.css">
<script type="text/javascript" src="js/bootstrap.min.js"></script>
<style type="text/css">
.chartButton {
	font: 12px Verdana;
	border-bottom: #000000 1px solid;
	padding: 5px;
	cursor: pointer;
}

.chartButtonSpacer {
	font: 12px Verdana;
	border-bottom: #000000 1px solid;
	padding: 5px;
}

.chartButton:hover {
	box-shadow: inset 0px 0px 0px 2px #444488;
}

.chartButtonPressed {
	background-color: #CCFFCC;
}

.tg {
	border-collapse: collapse;
	border-spacing: 0;
}

.tg td {
	border-color: black;
	border-style: solid;
	border-width: 1px;
	font-family: Arial, sans-serif;
	font-size: 14px;
	overflow: hidden;
	padding: 10px 5px;
	word-break: normal;
}

.tg th {
	border-color: black;
	border-style: solid;
	border-width: 1px;
	font-family: Arial, sans-serif;
	font-size: 14px;
	font-weight: normal;
	overflow: hidden;
	padding: 10px 5px;
	word-break: normal;
}

.tg .tg-0lax {
	text-align: left;
	vertical-align: top
}

.tg .tg-0pky {
	border-color: inherit;
	text-align: left;
	vertical-align: top
}

@media screen and (max-width: 767px) {
	.tg {
		width: auto !important;
	}
	.tg col {
		width: auto !important;
	}
	.tg-wrap {
		overflow-x: auto;
		-webkit-overflow-scrolling: touch;
	}
}
</style>
</head>
<body style="margin: 0px;">
	<script type="text/javascript">

//
// Execute the following initialization code after the web page is loaded
//
JsChartViewer.addEventListener(window, 'load', function() {
    // Update the chart when the view port has changed (eg. when the user zooms in using the mouse)
    var viewer = JsChartViewer.get('<%=viewer.getId()%>');
    viewer.attachHandler("ViewPortChanged", viewer.partialUpdate);

    // The Update Chart can also trigger a view port changed event to update the chart.
    document.getElementById("SubmitButton").onclick = function() { viewer.raiseViewPortChangedEvent(); return false; };

 // The Update Chart can also trigger a view port changed event to update the chart.
    document.getElementById("UpdateButton").onclick = function() { viewer.raiseViewPortChangedEvent(); return false; };

    // Before sending the update request to the server, we include the state of the check boxes as custom
    // attributes. The server side charting code will use these attributes to decide the data sets to draw.
    viewer.attachHandler("PreUpdate", function() {
    	
    	var checkBoxes = ["Metal_mass","Fe_Content","Metal_Quality","Si_Content","Bath_Ratio","Bath_Height","Metal_Height",
		    "Bath_Temperature","CVD","ACD","Superheat","Al2O3_Concen"];
        for (var i = 0; i < checkBoxes.length; ++i)
            viewer.setCustomAttr(checkBoxes[i], document.getElementById(checkBoxes[i]).checked ? "T" : "F");

        viewer.setCustomAttr("Machine_No",document.getElementById("Machine_No").value);
        viewer.setCustomAttr("Slot_No",document.getElementById("Slot_No").value);
        viewer.setCustomAttr("startDate",document.getElementById("startDate").value);
        viewer.setCustomAttr("enddate",document.getElementById("enddate").value);
        
  
    });

    
    
    // Draw track cursor when mouse is moving over plotarea or if the chart updates
    viewer.attachHandler(["MouseMovePlotArea", "TouchStartPlotArea", "TouchMovePlotArea", "PostUpdate",
        "Now", "ChartMove"], function(e) {
        this.preventDefault(e);   // Prevent the browser from using touch events for other actions
        trackLineLegend(viewer, viewer.getPlotAreaMouseX());
    });
});

//
// Draw track line with legend
//
function trackLineLegend(viewer, mouseX)
{
	//console.log(viewer.getChartCount());
    // Remove all previously drawn tracking object
    viewer.hideObj("all");
    
    var xValue = viewer.getChart().getNearestXValue(mouseX);

    var c = null;
    
    for (var k = 0; k < viewer.getChartCount(); k++)
    {
    // The chart and its plot area
    c = viewer.getChart(k);
    var plotArea = c.getPlotArea();

    // Get the data x-value that is nearest to the mouse, and find its pixel coordinate.
    
    var xCoor = c.getXCoor(xValue);
    if (xCoor == null)
        return;

    // Draw a vertical track line at the x-position
    viewer.drawVLine("trackLine", xCoor, plotArea.getTopY(), plotArea.getBottomY(), "black 1px dotted");

    // Array to hold the legend entries
    var legendEntries = [];

    // Iterate through all layers to build the legend array
    for (var i = 0; i < c.getLayerCount(); ++i)
    {
        var layer = c.getLayerByZ(i);

        // The data array index of the x-value
        var xIndex = layer.getXIndexOf(xValue);

        // Iterate through all the data sets in the layer
        for (var j = 0; j < layer.getDataSetCount(); ++j)
        {
            var dataSet = layer.getDataSetByZ(j);

            // We are only interested in visible data sets with names, as they are required for legend entries.
            var dataName = dataSet.getDataName();
            var color = dataSet.getDataColor();
            if ((!dataName) || (color == null))
                continue;

            // Build the legend entry, consist of a colored square box, the name and the data value.
            var dataValue = dataSet.getValue(xIndex);
            legendEntries.push("<nobr>" + viewer.htmlRect(7, 7, color) + " " + dataName + ": " +
                ((dataValue == null) ? "N/A" : dataValue.toPrecision(4)) + viewer.htmlRect(20, 0) + "</nobr> ");

            // Draw a track dot for data points within the plot area
//             var yCoor = c.getYCoor(dataSet.getPosition(xIndex), dataSet.getUseYAxis());
//             if ((yCoor != null) && (yCoor >= plotArea.getTopY()) && (yCoor <= plotArea.getBottomY()))
//             {
//                 viewer.showTextBox("dataPoint" + i + "_" + j, xCoor, yCoor, JsChartViewer.Center,
//                     viewer.htmlRect(7, 7, color));
//             }
        }
  
    }

     
    
 // The legend is formed by concatenating the legend entries.
    var legend = legendEntries.reverse().join(" ");

    // Add the date and the ohlcLegend (if any) at the beginning of the legend
    legend = "<nobr>[" + c.xAxis().getFormattedLabel(xValue, "mm/dd/yyyy") + "]" + viewer.htmlRect(20, 0) +
				"</nobr> " + legendEntries.reverse().join("");

    // Get the plot area position relative to the entire FinanceChart
    var plotArea = c.getPlotArea();
    var plotAreaLeftX = plotArea.getLeftX() + c.getAbsOffsetX();
    var plotAreaTopY = plotArea.getTopY() + c.getAbsOffsetY();

    // Draw a vertical track line at the x-position
    viewer.drawVLine("trackLine" + k, c.getXCoor(xValue) + c.getAbsOffsetX(), plotAreaTopY,
        plotAreaTopY + plotArea.getHeight(), "black 1px dotted");

    // Display the legend on the top of the plot area
    viewer.showTextBox("legend" + k, plotAreaLeftX + 1, plotAreaTopY + 1, JsChartViewer.BottomLeft, legend,
        "padding-left:5px;width:" + (plotArea.getWidth() - 1) + "px;font:11px Arial;-webkit-text-size-adjust:100%;");
    
    }
}

//
// This method is called when the user clicks on the Pointer, Zoom In or Zoom Out buttons
//
function setMouseMode(mode)
{
    var viewer = JsChartViewer.get('<%=viewer.getId()%>');
    if (mode == viewer.getMouseUsage())
        mode = JsChartViewer.Default;

    // Set the button color based on the selected mouse mode
    document.getElementById("scrollButton").className = "chartButton" +
        ((mode  == JsChartViewer.Scroll) ? " chartButtonPressed" : "");
    document.getElementById("zoomInButton").className = "chartButton" +
        ((mode  == JsChartViewer.ZoomIn) ? " chartButtonPressed" : "");
    document.getElementById("zoomOutButton").className = "chartButton" +
        ((mode  == JsChartViewer.ZoomOut) ? " chartButtonPressed" : "");

    // Set the mouse mode
    viewer.setMouseUsage(mode);
}

//
// This method is called when the user clicks on the buttons that selects the last NN days
//
function setTimeRange(duration)
{
    var viewer = JsChartViewer.get('<%=viewer.getId()%>');

			// Set the view port width to represent the required duration (as a ratio to the total x-range)
			viewer.setViewPortWidth(Math.min(1, duration
					/ (viewer.getValueAtViewPort("x", 1) - viewer
							.getValueAtViewPort("x", 0))));

			// Set the view port left so that the view port is moved to show the latest data
			viewer.setViewPortLeft(1 - viewer.getViewPortWidth());

			// Trigger a view port change event
			viewer.raiseViewPortChangedEvent();
}
	</script>
	
<div class="container" >	
<div style="font: bold 18pt verdana;" class="jumbotron jumbotron-fluid">alummanagertest.day_report
</div>
<div style="font: 10pt verdana; margin-bottom: 20px">
	<a href='viewsource.jsp?file=<%=request.getServletPath()%>'></a>
</div>
<div style="font: 10pt verdana; width: 600px; margin-bottom: 20px">
	<form name="frm" method="POST" action="zoomscrolltrack.jsp">

		<div class="tg-wrap">
			<table class="tg">
				<thead>
					<tr>
						<th class="tg-0lax"><label for="Machine_No">Machine
								No</label></th>
						<th class="tg-0lax"><label for="Slot_No">Slot No.</label></th>
						<th class="tg-0lax"><label for="startDate">Start
								Date:</label></th>
						<th class="tg-0lax"><label for="enddate">End Date:</label></th>
						<th class="tg-0lax"></th>
					</tr>
				</thead>
				<tbody>
					<tr>

						<td class="tg-0lax"><select name="Machine_No"
							id="Machine_No">
								<%
									for (int mn : MachNo) {
								%>

								<option value="<%=mn%>"><%=mn%></option>
								<%
									}
								%>
						</select></td>
						<td class="tg-0lax"><select name="Slot_No" id="Slot_No">
								<%
									for (int st : slots) {
								%>
								<option value="<%=st%>"><%=st%></option>
								<%
									}
								%>
						</select></td>

						<td class="tg-0lax"><input type="date" name="startDate"
							id="startDate" value="2018-01-01"></td>
						<td class="tg-0pky"><input type="date" name="enddate"
							id="enddate" value="2019-12-30"></td>
						<td class="tg-0pky"><input type="submit" id="SubmitButton" name="SubmitButton"
							value="Update Chart" /></td>

					</tr>

				</tbody>
			</table>
<!-- 			<div class="input-group mb-3"> -->
<!-- 			  <div class="input-group-prepend"> -->
<!-- 			    <label class="input-group-text" for="clmnSelect">Options</label> -->
<!-- 			  </div> -->
<!-- 			  <select class="custom-select" id="clmnSelect" name="clmnSelect"> -->
<!-- 			    <option >Choose...</option> -->
<!-- 			    <option selected value="Metal_mass">Metal_mass</option> -->
<!-- 			    <option value="Fe_Content">Fe_Content</option> -->
<!-- 			    <option value="Metal_Quality">Metal_Quality</option> -->
			    
<!-- 			    <option value="Si_Content">Si_Content</option> -->
<!-- 			    <option value="Bath_Ratio">Bath_Ratio</option> -->
<!-- 			    <option value="Bath_Height">Bath_Height</option> -->
			    
<!-- 			    <option value="Metal_Height">Metal_Height</option> -->
<!-- 			    <option value="Bath_Temperature">Bath_Temperature</option> -->
<!-- 			    <option value="CVD">CVD</option> -->
			    
<!-- 			    <option value="ACD">ACD</option> -->
<!-- 			    <option value="Superheat">Superheat</option> -->
<!-- 			    <option value="Al2O3_Concen">Al2O3_Concen</option> -->
			    
<!-- 			  </select> -->
<!-- 			</div> -->
		</div>
	</form>
</div>
	<form method="post">
		<table cellspacing="0" cellpadding="0"
			style="border: black 1px solid;">
			<tr>
				<td align="right" colspan="2"
					style="background: #000088; color: #ffff00; padding: 0px 4px 2px 0px;">
					<a
					style="color: #FFFF00; font: italic bold 10pt Arial; text-decoration: none"
					href="http://www.advsofteng.com/"> alummanagertest.day_report </a>
				</td>
			</tr>
			<tr valign="top">
				<td style="width: 150px; background: #c0c0ff;">
					<div style="width: 150px">
						<!-- The following table is to create 3 cells for 3 buttons to control the mouse usage mode. -->
						<table
							style="width: 100%; padding: 0px; border: 0px; border-spacing: 0px;">
							<tr>
								<td class="chartButton" id="scrollButton"
									onclick="setMouseMode(JsChartViewer.Scroll)"
									ontouchstart="this.onclick(event); event.preventDefault();">
									<img src="scrollew.gif" style="vertical-align: middle"
									alt="Drag" />&nbsp;&nbsp;Drag to Scroll
								</td>
							</tr>
							<tr>
								<td class="chartButton" id="zoomInButton"
									onclick="setMouseMode(JsChartViewer.ZoomIn)"
									ontouchstart="this.onclick(event); event.preventDefault();">
									<img src="zoomInIcon.gif" style="vertical-align: middle"
									alt="Zoom In" />&nbsp;&nbsp;Zoom In
								</td>
							</tr>
							<tr>
								<td class="chartButton" id="zoomOutButton"
									onclick="setMouseMode(JsChartViewer.ZoomOut)"
									ontouchstart="this.onclick(event); event.preventDefault();">
									<img src="zoomOutIcon.gif" style="vertical-align: middle"
									alt="Zoom Out" />&nbsp;&nbsp;Zoom Out
								</td>
							</tr>
							<tr>
								<td class="chartButtonSpacer">
									<div style="padding: 2px">&nbsp;</div>
								</td>
							</tr>
							<tr>
								<td class="chartButton" onclick="setTimeRange(30 * 86400);"
									ontouchstart="this.onclick(event); event.preventDefault();">
									<img src="goto.gif" style="vertical-align: middle"
									alt="Last 30 days" />&nbsp;&nbsp;Last 30 days
								</td>
							</tr>
							<tr>
								<td class="chartButton" onclick="setTimeRange(90 * 86400);"
									ontouchstart="this.onclick(event); event.preventDefault();">
									<img src="goto.gif" style="vertical-align: middle"
									alt="Last 90 days" />&nbsp;&nbsp;Last 90 days
								</td>
							</tr>
							<tr>
								<td class="chartButton" onclick="setTimeRange(366 * 86400);"
									ontouchstart="this.onclick(event); event.preventDefault();">
									<img src="goto.gif" style="vertical-align: middle"
									alt="Last Year" />&nbsp;&nbsp;Last Year
								</td>
							</tr>
							<tr>
								<td class="chartButton" onclick="setTimeRange(1E15);"
									ontouchstart="this.onclick(event); event.preventDefault();">
									<img src="goto.gif" style="vertical-align: middle"
									alt="All Time" />&nbsp;&nbsp;All Time
								</td>
							</tr>
						</table>
					
						<div
							style="font: 9pt Verdana; line-height: 1.5; padding-top: 25px">
							<input id="Metal_mass" type="checkbox" checked="checked" />Metal_mass<br /> 
							<input id="Fe_Content" type="checkbox"checked="checked" /> Fe_Content<br /> 
							<input id="Metal_Quality" type="checkbox" checked="checked" />Metal_Quality<br />
							
							<input id="Si_Content" type="checkbox" checked="checked" />Si_Content<br /> 
							<input id="Bath_Ratio" type="checkbox"checked="checked" /> Bath_Ratio<br /> 
							<input id="Bath_Height" type="checkbox" checked="checked" />Bath_Height<br />
							
							<input id="Metal_Height" type="checkbox" checked="checked" />Metal_Height<br /> 
							<input id="Bath_Temperature" type="checkbox"checked="checked" /> Bath_Temperature<br /> 
							<input id="CVD" type="checkbox" checked="checked" />CVD<br />
							
							<input id="ACD" type="checkbox" checked="checked" />ACD<br /> 
							<input id="Superheat" type="checkbox"checked="checked" /> Superheat<br /> 
							<input id="Al2O3_Concen" type="checkbox" checked="checked" />Al2O3_Concen<br />
						</div>
						
						<div
							style="font: 9pt Verdana; margin-top: 15px; text-align: center">
							<input type="submit" id="UpdateButton" name="UpdateButton"
								value="Update Chart" />
						</div>
						
					</div>
				</td>
				<td style="border-left: black 1px solid; padding: 10px 5px 0px 5px;">
					<!-- ****** Here is the chart image ****** --> <%=viewer.renderHTML(response)%>
				</td>
			</tr>
		</table>
	</form>
	
	</div>
</body>
</html>
