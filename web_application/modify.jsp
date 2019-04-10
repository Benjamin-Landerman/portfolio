<!DOCTYPE html>
<html lang="en">
<head>
<!--
"Time-stamp: <Sun, 01-06-19, 22:51:33 Eastern Standard Time>"
//-->
<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta name="description" content="My online portfolio that illustrates skills acquired while working through various project requirements.">
	<meta name="author" content="Benjamin Landerman">
	<link rel="shortcut icon" href="img/favicon.ico" type="image/x-icon">

	<title>LIS4368 - JSP Forms</title>

	<%@ include file="/css/include_css.jsp" %>		

</head>
<body>

<!-- display application path -->
<% //= request.getContextPath()%>
	
<!-- can also find path like this...<a href="${pageContext.request.contextPath}${'/a5/index.jsp'}">A5</a> -->	
	
	<%@ include file="/global/nav_global.jsp" %>	

	<div class="container">
		<div class="starter-template">
					
					<div class="page-header">
						<%@ include file="/p2/global/header.jsp" %>
					</div>

					<h2>Update Customer</h2>

					<!-- instructional message for users completing form input -->
					<p><i><span style='color: red; background-color: yellow; font-weight: bold; font-variant:small-caps;'>All text boxes required except Notes.</span></i></p>

					<% //for debugging, test input (test servlet provided): action="testInput" %>											
					<form id="edit_customer_form" method="post" class="form-horizontal" action="customerAdmin">
						
						<input type="hidden" name="update_customer" value="${user.id}" />
						
						<div class="form-group">
							<label class="col-sm-4 control-label">FName:</label>
							<div class="col-sm-4">
								<input type="text" class="form-control" maxlength="15" name="fname" value="${user.fname}" />
							</div>
						</div>

						<div class="form-group">
							<label class="col-sm-4 control-label">LName:</label>
							<div class="col-sm-4">
								<input type="text" class="form-control" maxlength="30" name="lname" value="${user.lname}" />
							</div>
						</div>
						
						<div class="form-group">
							<label class="col-sm-4 control-label">Email:</label>
							<div class="col-sm-4">
								<input type="text" class="form-control" maxlength="100" name="email" value="${user.email}" />
							</div>
						</div>
						
						<div class="form-group">
							<div class="col-sm-6 col-sm-offset-3">
								<button type="submit" class="btn btn-primary" name="signup" value="Update">Update</button>
							</div>
						</div>
					</form>

	<%@ include file="/global/footer.jsp" %>

	</div> <!-- end starter-template -->
 </div> <!-- end container -->

 	<%--@ include file="/js/include_js.jsp" --%>		

<script type="text/javascript">
$(document).ready(function() {

	$('#edit_customer_form').formValidation({
			message: 'This value is not valid',
			icon: {
					valid: 'fa fa-check',
					invalid: 'fa fa-times',
					validating: 'fa fa-refresh'
			},
			fields: {

				fname: {
							validators: {
									notEmpty: {
											message: 'First name required'
									},
									stringLength: {
											min: 1,
											max: 15,
											message: 'First name no more than 15 characters'
									},
									regexp: {
										//http://www.regular-expressions.info/
										//http://www.regular-expressions.info/quickstart.html
										//http://www.regular-expressions.info/shorthand.html
										//http://stackoverflow.com/questions/13283470/regex-for-allowing-alphanumeric-and-space
										//alphanumeric (also, "+" prevents empty strings):
										regexp: /^[a-zA-Z\-]+$/,
										message: 'First name can only contain letters and hyphens'
									},									
							},
					},

				lname: {
							validators: {
									notEmpty: {
											message: 'Last name required'
									},
									stringLength: {
											min: 1,
											max: 30,
											message: 'Last name no more than 30 characters'
									},
									regexp: {
										regexp: /^[a-zA-Z\-]+$/,
										message: 'Last name can only contain letters and hyphens'
									},									
							},
					},
				
					email: {
							validators: {
									notEmpty: {
											message: 'Email address is required'
									},

									/*
									//built-in e-mail validator, comes with formValidation.min.js
									//using regexp instead (below)
									emailAddress: {
											message: 'Must include valid email address'
									},
									*/
								
									stringLength: {
											min: 1,
											max: 100,
											message: 'Email no more than 100 characters'
									},
									regexp: {
									regexp: /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/,
										message: 'Must include valid email'
									},																		
							},
					},
			}
	});
});
</script>

</body>
</html>
