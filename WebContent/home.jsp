
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*, javax.sql.*, java.util.*"%>
<%@ page import="com.google.gson.Gson"%>
<%@ page import="com.google.gson.JsonObject"%>
<!DOCTYPE html>
<html>
<!-- Head -->
<head>
	<meta charset="utf-8">
  	<meta name="viewport" content="width=device-width, initial-scale=1">
 	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
	<title>SortSight</title>
</head>
<!-- Content -->
<body>
<div class="container-fluid text-center">    
  	<div class="row content">
  		<!-- Side Links -->
    	<div class="col-sm-2 sidenav">
    		<br/><h2>Resources</h2>
    		<h4>Algorithms</h4>
  			<a href="quickSort.jsp">QuickSort</a><br/>
  			<a href="mergeSort.jsp">MergeSort</a><br/>
  			<a href="heapSort.jsp">HeapSort</a><br/>
  			<a href="insertionSort.jsp">InsertionSort</a><br/>
  			<a href="bubbleSort.jsp">BubbleSort</a>
  			<br/><h4>Data Structures</h4>
  			<a href="#">Stack</a><br/>
  			<a href="#">Heap</a><br/>
  			<a href="#">Binary Tree</a><br/>
  			<a href="#">Linked List</a><br/>
  			<a href="#">Hash Table</a><br/>
  			<a href="#">Graphs</a>
    	</div>
    	<!-- Main Content -->
    	<div class="col-sm-8 text-left" id="test"> 
      		<h1>Welcome to SortSight!</h1>
      		<p>
      		Originally created as an application where users can visualize the real-time complexity of various sorting algorithms with various sized
      		input, SortSight is an algorithms and data structures brush-up tool to help you nail your next interview or review the fundamentals!
      		</p>
      		<p>
      		Just select your method, choose your size of input and get testing! 
      		</p>
      		<!-- Sort Form -->
      		<form action="home_response.jsp">
      			<div class="sort-form" style="text-align: center; background-color: rgb(0,0,0,0.2); padding: 25px;">
	      			<h3>Size of Input</h3>
	      			<select name="size" id="size-drop">
	      				<option value="100">100</option>
	      				<option value="1000">1,000</option>
	      				<option value="10000">10,000</option>
	      				<option value="100000">100,000</option>
	      				<option value="1000000">1,000,000</option>
	      				<option value="10000000">10,000,000</option>
	      			</select>  
	      			<h3>Sorting Algorithm</h3> 
	      			<select name="method" id="method-drop">
	      				<option value="MergeSort">MergeSort</option>
	      				<option value="QuickSort">QuickSort</option>
	      				<option value="HeapSort">HeapSort</option>
	      				<option value="InsertionSort">InsertionSort</option>
	      				<option value="BubbleSort">BubbleSort</option>
	      			</select>
	      			<div id="quick-buttons"></div>
	      			<br/>
	      			<input type="submit"/>
      			</div> 
      		</form>
      		<br/>
      		<div id="chartContainer" style="height: 370px; width: 100%;"></div>
      		<div class="container" style="height: 300px; overflow-y: scroll; width: 70%; margin-bottom: 50px;">
		      			<% 
		      			String[] jsonified = new String[5];
		      			/* db connect */
		      			try{
		      				Class.forName("com.mysql.jdbc.Driver");
		      				Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/sortApp", "ryan", "password");
		      				Statement st = con.createStatement();
		      				// get all trials 
		      				ResultSet q = st.executeQuery("select * from trials");
		      				// put into table -- UPDATE ME!
		      				out.println("<table width=250 align=center>");
		      				out.println("<tr>");
		      				out.println("<th style=padding:10px;>Runtime</th>");
		      				out.println("<th style=padding:10px;>Algorithm</th>");
		      				out.println("<th style=padding:10px;>Input</th>");
		      				out.println("</tr>");
		      				while(q.next()){
		      				
		      					out.println("<td>" + q.getString(1) + "ms</td>");
		      					out.println("<td>" + q.getString(2) + "</td>");
		      					out.println("<td>" + q.getString(4) + "</td>");
		      					out.println("</tr>");
		      				}
		      				
		      				// retrieve data, organize into json for js plot
		      				Gson gsonObj = new Gson();
							Map<Object,Object> map = null;
							List<Map<Object,Object>> list = null;
							
		      				String[] allMethods = {"MergeSort", "HeapSort", "QuickSort", "InsertionSort", "BubbleSort"};
		      				// for each method, get all trials, get means for each sized input
		      				for(int k = 0; k < allMethods.length; k++){
		      					list = new ArrayList<Map<Object,Object>>();
		      					ResultSet cur = st.executeQuery("select * from trials where '"+allMethods[k]+"' in(method)");
		      					int[] numTrials = new int[6];
		      					int[] sums = new int[6];
		      					int [] means = new int[6];
		      					
		      					while(cur.next()){
		      						
		      						switch(cur.getString(4)){
		      							
		      						case "100":
		      							numTrials[0]++;
		      							sums[0] += Integer.parseInt(cur.getString(1));
		      							break;
		      						case "1000":
		      							numTrials[1]++;
		      							sums[1] += Integer.parseInt(cur.getString(1));
		      							break;
		      						case "10000":
		      							numTrials[2]++;
		      							sums[2] += Integer.parseInt(cur.getString(1));
		      							break;
		      						case "100000":
		      							numTrials[3]++;
		      							sums[3] += Integer.parseInt(cur.getString(1));
		      							break;
		      						case "1000000":
		      							numTrials[4]++;
		      							sums[4] += Integer.parseInt(cur.getString(1));
		      							break;
		      						case "10000000":
		      							numTrials[5]++;
		      							sums[5] += Integer.parseInt(cur.getString(1));
		      						}
		      					}
		      					// get trial averages by input size
		      					for(int c = 0; c < means.length; c++){
		      						if(numTrials[c] > 0){
		      							means[c] = sums[c]/numTrials[c];
		      						} else {
		      							// if no recorded data reflect on graph
		      							means[c] = -1;
		      						}
		      					}
		      					// jsonify for JS graph
		      					String []names = {"100", "1,000", "10,000", "100,000", "1,000,000", "10,000,000"};
		      					for(int j = 0; j < names.length; j++){
		      						map = new HashMap<Object,Object>(); 
		      						if(means[j] != -1){
			      						map.put("y", means[j]);
		      						} else {
		      							map.put("y", null);
		      						}
		      						map.put("label", names[j]);
		      						list.add(map);
		      					}
		      					jsonified[k] = gsonObj.toJson(list);
		      				
		      				}
		     				
		      			} catch(Exception e){
		      				// throw error to js log
		      				out.println("hmm, I'm having trouble connecting to my database :(");
		      				out.println("<script>console.log(" + "\"" + e.getClass().getCanonicalName() + "\"" + ");</script>");
		      				out.println(e);
		      				
		      			}
	      			%>
	      		</div>	
    	</div>
    </div>
</div>

<!-- Footer -->
<div class="footer" style="position: absolute; bottom: 0; text-align: center; width: 100%; left: 0;">
<small>SortSight 2019 &copy</small>
</div>
</body>
<!-- JavaScript -->
<script src="https://code.jquery.com/jquery-3.3.1.js" integrity="sha256-2Kok7MbOyxpgUVvAk/HJ2jigOSYS2auK4Pfzbm7uH60="crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/canvasjs/1.7.0/canvasjs.js"></script>
<script type="text/javascript">
/* add options if quicksort, disclaimer if large n bubble/insertion */
$('#method-drop').on('change', function(){
	var val = $(this).val();
	if(val === "QuickSort"){
		document.getElementById("quick-buttons").innerHTML = '<h3>' + 'InsertionSort Threshold' + '</h3>' + '<small style="font-style:italic;">' + 'At what size n should QuickSort transition to InsertionSort?' + '</small><br/>' + '<input type="radio" name="threshold" value="25">'
		+ ' 25' + '</input>   ' + '<input type ="radio" name="threshold" value="50">' + ' 50' + '</input>   ' + '<input type="radio" name="threshold" value="75">'
		+ ' 75' + '</input>   ' + '<input type="radio" name="threshold" value="100">' + ' 100' + '</input>';
	} else if((method == "BubbleSort" || method == "InsertionSort") && document.getElementById("size-drop").value > 10000){
		document.getElementById("quick-buttons").innerHTML = '<small style=font-style: italic;>' + '(this might take a while)' + '</small>';
	} else {
		document.getElementById("quick-buttons").innerHTML = "";
	}
});
/* other end for large n bubble/insertion */
$('#size-drop').on('change', function(){
	var size = $(this).val();
	var method = document.getElementById("method-drop").value;
	if(size > 10000 && (method == "BubbleSort" || method == "InsertionSort")){
		document.getElementById("quick-buttons").innerHTML = '<small style=font-style: italic;>' + '(this might take a while)' + '</small>';
	} else if(method != "QuickSort"){
		document.getElementById("quick-buttons").innerHTML = "";
	}
});
/* make graph */
window.onload = function () {

var chart = new CanvasJS.Chart("chartContainer", {
	animationEnabled: true,
	title:{
		text: "Algorithm Trial Averages"
	},
	axisX: {
		title: "Input Size"
		
	},
	axisY: {
		title: "Runtime (ms)"
		
	},
	legend:{
		cursor: "pointer",
		fontSize: 16,
		itemclick: toggleDataSeries
	},
	toolTip:{
		shared: true
	},
	data: [{
		name: "MergeSort",
		type: "spline",
		showInLegend: true,
		dataPoints: <%out.print(jsonified[0]);%>
	},
	{
		name: "HeapSort",
		type: "spline",
		showInLegend: true,
		dataPoints: <%out.print(jsonified[1]);%>
	},
	{
		name: "QuickSort",
		type: "spline",
		showInLegend: true,
		dataPoints: <%out.print(jsonified[2]);%>
	},
	{
		name: "InsertionSort",
		type: "spline",
		showInLegend: true,
		dataPoints: <%out.print(jsonified[3]);%>
	},
	{
		name: "BubbleSort",
		type: "spline",
		showInLegend: true,
		dataPoints: <%out.print(jsonified[4]);%>
	}]
});
chart.render();

function toggleDataSeries(e){
	if (typeof(e.dataSeries.visible) === "undefined" || e.dataSeries.visible) {
		e.dataSeries.visible = false;
	}
	else{
		e.dataSeries.visible = true;
	}
	chart.render();
}

}
</script>

</html>