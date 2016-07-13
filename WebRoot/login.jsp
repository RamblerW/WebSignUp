<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>欢迎登录</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	<link rel="shortcut icon" href="<%=basePath%>img/login.png" type="image/x-icon" />
    <link rel="stylesheet" type="text/css" href="<%=basePath%>css/bootstrap.min.css">
    <link  rel="stylesheet" type="text/css" href="<%=basePath%>css/login.css">
	<!-- Bootstrap -->
  	<script src="<%=basePath%>js/jquery.min.js"></script>
	<script src="<%=basePath%>js/bootstrap.min.js"></script>
  	<script src="<%=basePath%>js/jquery.placeholder.js"></script>
  </head>
  
  <body class="login">
  	<div class="container">
		<form class="form-signin" action="<%=basePath%>servlet/LoginServlet" method="post">
			<h2 class="form-signin-heading">欢迎登录</h2>
			<input type="text" name="username" class="form-control" placeholder="username" required autofocus />
			<input type="password" name="password" class="form-control" placeholder="password" required />
			<button class="btn btn-lg btn-primary btn-block" type="submit">登录</button>
		</form>
	</div>
  </body>
</html>
