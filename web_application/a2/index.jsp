<!DOCTYPE html>
<html lang="en">
<head>
<!--
"Time-stamp: <Sun, 02-19-17, 12:36:56 Eastern Standard Time>"
//-->
<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta name="description" content="My online portfolio that illustrates skills acquired while working through various project requirements.">
	<meta name="author" content="Benjamin Landerman">
	<link rel="shortcut icon" href="../img/favicon.ico" type="image/x-icon">

	<title>LIS4368 - Assignment 2</title>

	<%@ include file="/css/include_css.jsp" %>		
	
</head>
<body>

<!-- display application path -->
<% //= request.getContextPath()%>
	
<!-- can also find path like this...<a href="${pageContext.request.contextPath}${'/a5/index.jsp'}">A5</a> -->

	<%@ include file="/global/nav.jsp" %>	

	<div class="container">
		<div class="starter-template">
			<div class="row">
				<div class="col-sm-8 col-sm-offset-2">
					
					<div class="page-header">
						<%@ include file="global/header.jsp" %>
					</div>

					<b>Servlet Compilation and Usage:</b><br />
					<img src="img/directory.png" class="img-responsive" alt="Directory" />
					<img src="img/index.png" class="img-responsive" alt="Index" />
					<img src="img/sayhello.png" class="img-responsive" alt="Say Hello" />
					<img src="img/sayhi.png" class="img-responsive" alt="Say Hi" />

					<br /> <br />
					<b>Database Connectivity Using Servlets:</b><br />
					<img src="img/querybook.png" class="img-responsive" alt="Querybook" />
				<br />
					<img src="img/query_result.png" class="img-responsive" alt="Query Result" />

				</div>
			</div>

	<%@ include file="/global/footer.jsp" %>

	</div> <!-- end starter-template -->
 </div> <!-- end container -->

 	<%@ include file="/js/include_js.jsp" %>		

</body>
</html>
