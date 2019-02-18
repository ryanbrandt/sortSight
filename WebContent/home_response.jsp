
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.utils.jsp.Sorts, java.sql.*, javax.sql.*"%>
<!DOCTYPE html>
<html>
<!-- Head -->
<head>
	<meta charset="utf-8">
  	<meta name="viewport" content="width=device-width, initial-scale=1">
 	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
	<title>${param.method} Trial</title>
</head>
<!-- Content -->
<body>
<div class="container-fluid text-center">    
  	<div class="row content">
  		<!-- Side Links -->
    	<div class="col-sm-2 sidenav">
    		<br/><h2>More Resources</h2>
    		<h3>Algorithms</h3>
  			<a href="#">QuickSort</a><br/>
  			<a href="#">MergeSort</a><br/>
  			<a href="#">HeapSort</a><br/>
  			<a href="#">InsertionSort</a><br/>
  			<a href="#">BubbleSort</a>
  			<br/><h3>Data Structures</h3>
  			<a href="#">Stack</a><br/>
  			<a href="#">Heap</a><br/>
  			<a href="#">Binary Tree</a><br/>
  			<a href="#">Linked List</a><br/>
  			<a href="#">Hash Table</a><br/>
  			<a href="#">Graphs</a>
    	</div>
    	<!-- Main Text -->
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
	      			<select name="size">
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
		      		<%
		      			
		      			// make sample
		      			int n = Integer.parseInt(request.getParameter("size"));
		      			int arr[] = new int[n];
		      			for(int i = 0; i < n; i++) {
		      				arr[i] = (int)(Math.random()*100);
		      			}
		      			/* make sort instance */
		      			String methodCode = request.getParameter("method");
		      			Sorts mySort = new Sorts(arr, n, methodCode);
		      			/* do sort */
		      			long start = 0;
		      			switch(methodCode.charAt(0)){
		      			
		      			case 'M':
		      				start = mySort.startTime();
		      				mySort.split(0, mySort.arr.length-1);
		      				mySort.ms = mySort.endTime(start);
		      				break;
		      			case 'Q':
		      				start = mySort.startTime();
		      				mySort.quickSort(0, mySort.n-1, Integer.parseInt(request.getParameter("threshold")));
		      				mySort.ms = mySort.endTime(start);
		      				break;
		      			case 'H':
		      				start = mySort.startTime();
		      				mySort.heapSort();
		      				mySort.ms = mySort.endTime(start);
		      				break;
		      			case 'I':
		      				start = mySort.startTime();
		      				mySort.insertionSort(0, mySort.n-1);
		      				mySort.ms = mySort.endTime(start);
		      				break;
		      			case 'B':
		      				start = mySort.startTime();
		      				mySort.bubbleSort();
		      				mySort.ms = mySort.endTime(start);
		      			}
		      			out.print("<h4> Runtime </h4>");
		      			out.println(mySort.ms + "ms");
		      			%>
		      			</div> 
      				</form>
      				<div class="container" style="height: 200px; overflow-y: scroll;">
		      			<% 
		      			/* db connect */
		      			try{
		      				Class.forName("com.mysql.jdbc.Driver");
		      				Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/sortApp", "ryan", "password");
		      				Statement st = con.createStatement();
		      				// save recent trial
		      				st.executeUpdate("insert into trials(time, method, n)values('"+mySort.ms+"','"+mySort.method+"', '"+mySort.n+"')");
		      				// get all trials 
		      				ResultSet q = st.executeQuery("select * from trials");
		      				// put into table -- UPDATE ME!
		      				out.println("<table>");
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
		      				
		      				// get summary statistics here
		      				
		     				
		      			} catch(Exception e){
		      				out.println("hmm, database error: " + e);
		      				
		      			}
	      			%>
	      		</div>
    	</div>
    </div>
</div>


<!-- Footer -->
<div class="footer" style="position: fixed; bottom: 0; text-align: center; width: 100%; left: 0;">
<small>SortSight 2019 &copy</small>
</div>

</body>
<!-- JavaScript -->
<script src="https://code.jquery.com/jquery-3.3.1.js" integrity="sha256-2Kok7MbOyxpgUVvAk/HJ2jigOSYS2auK4Pfzbm7uH60="crossorigin="anonymous"></script>
<script type="text/javascript">
//add options if quicksort
$('#method-drop').on('change', function(){
	var val = $(this).val();
	if(val === "QuickSort"){
		document.getElementById("quick-buttons").innerHTML = '<h3>' + 'InsertionSort Threshold' + '</h3>' + '<small style="font-style:italic;">' + 'At what size n should QuickSort transition to InsertionSort?' + '</small><br/>' + '<input type="radio" name="threshold" value="25">'
		+ ' 25' + '</input>   ' + '<input type ="radio" name="threshold" value="50">' + ' 50' + '</input>   ' + '<input type="radio" name="threshold" value="75">'
		+ ' 75' + '</input>   ' + '<input type="radio" name="threshold" value="100">' + ' 100' + '</input>';
	} else {
		document.getElementById("quick-buttons").innerHTML = "";
	}
});
</script>

</html>