<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.sql.*, javax.sql.*" %>
<%@ page import="com.google.gson.Gson"%>
<%@ page import="com.google.gson.JsonObject"%>
<!DOCTYPE html>
<html>
<!-- Head -->
<head>
	<meta charset="utf-8">
  	<meta name="viewport" content="width=device-width, initial-scale=1">
 	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
 	<title>InsertionSort Algorithm</title>
</head>
<!-- JSP Content -->
<%
/* manual summary statistics */
	String jsonified = null;
	try{
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/sortApp", "ryan", "password");
		Statement st = con.createStatement();
	
		int[] sums = new int[6];
		int[] numTrials = new int[6];
		int[] means = new int[6];
		// retrieve data, sum and find number of trials per input size
		ResultSet mergeSortData = st.executeQuery("select * from trials where 'insertionSort' in(method)");
		while(mergeSortData.next()){
			switch(mergeSortData.getString(4)){
			
			case "100":
				numTrials[0]++;
				sums[0] += Integer.parseInt(mergeSortData.getString(1));
				break;
			case "1000":
				numTrials[1]++;
				sums[1] += Integer.parseInt(mergeSortData.getString(1));
				break;
			case "10000":
				numTrials[2]++;
				sums[2] += Integer.parseInt(mergeSortData.getString(1));
				break;
			case "100000":
				numTrials[3]++;
				sums[3] += Integer.parseInt(mergeSortData.getString(1));
				break;
			case "1000000":
				numTrials[4]++;
				sums[4] += Integer.parseInt(mergeSortData.getString(1));
				break;
			case "10000000":
				numTrials[5]++;
				sums[5] += Integer.parseInt(mergeSortData.getString(1));
			}
		}
		// get means for different input sizes
		for(int i = 0; i < sums.length; i++){
			if(numTrials[i] > 0){
				means[i] = sums[i]/numTrials[i];
			} else {
				means[i] = -1;
			}
		}
		// jsonify data for canvasJS
		String []names = {"100", "1,000", "10,000", "100,000", "1,000,000", "10,000,000"};
		Gson gsonObj = new Gson();
		Map<Object,Object> map = null;
		List<Map<Object,Object>> list = new ArrayList<Map<Object,Object>>();
		for(int j = 0; j < names.length; j++){
			map = new HashMap<Object,Object>(); 
			map.put("label", names[j]);
			if(means[j] != -1){
				map.put("y", means[j]); 
			} else {
				map.put("y", null);
			}
			list.add(map);
		}
		jsonified = gsonObj.toJson(list);
		

	} catch(Exception e){
		// throw error to js log
		out.println("hmm, I'm having trouble connecting to my database :(");
		out.println("<script>console.log(" + "\"" + e.getClass().getCanonicalName() + "\"" + ");</script>");
		
	}	
%>
<!-- Visible Content -->
<body>
<div class="container-fluid text-center">    
  	<div class="row content">
  		<!-- Side Links -->
    	<div class="col-sm-2 sidenav">
    		<br/><h2>Resources</h2>
    		<a class="btn btn-primary" href="home.jsp">Test the Algorithms</a>
    		<h4>Algorithms</h4>
  			<a href="quickSort.jsp">QuickSort</a><br/>
  			<a href="mergeSort.jsp">MergeSort</a><br/>
  			<a href="heapSort.jsp">HeapSort</a><br/>
  			<a href="#">InsertionSort</a><br/>
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
		<div class="col-sm-8 text-left">
			<div id="chartContainer" style="height: 370px; width: 100%;"></div>
			<h1>The MergeSort Algorithm</h1>
			<p>
				An algorithm here!
			</p>
		</div>
	</div>
</div>
<!-- Footer -->
<div class="footer" style="position: absolute; bottom: 0; text-align: center; width: 100%; left: 0;">
<small>SortSight 2019 &copy</small>
</div>
</body>
<!-- JavaScript -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/canvasjs/1.7.0/canvasjs.js"></script>
<script type="text/javascript">
/* make graph */
window.onload = function() { 
var chart = new CanvasJS.Chart("chartContainer", {
	theme: "light2",
	title: {
		text: "InsertionSort Complexity"
	},
	axisX: {
		title: "Input Size"
	},
	axisY: {
		title: "Runtime (ms)"
	},
	data: [{
		type: "line",
		yValueFormatString: "#,##0ms",
		// pass data from sql -> jsp -> js
		dataPoints : <%out.print(jsonified);%>
	}]
});
chart.render();
}
</script>
</html>