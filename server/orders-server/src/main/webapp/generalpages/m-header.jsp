<%@page import="com.grocery.filters.Cookies"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page session="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@include file="../public/lang.jsp" %> 
<!DOCTYPE html>
<html lang="${language}" manifest="demo.appcache">
<head>

<meta charset="utf-8">
<title>Grocering</title>
<meta name="HandheldFriendly" content="True">
<meta name="MobileOptimized" content="320">
<meta name="viewport" content="width=device-width, target-densitydpi=160, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
<meta name="format-detection" content="telephone=no, email=no">
<meta name="apple-mobile-web-app-capable" content="no">
<meta name="description" content="On-the-go access to your shopping list via a mobile phone browser.">

<meta http-equiv="content-type" content="text/html; charset=UTF-8">

<script src="<%=request.getContextPath()%>/static/js/jquery-1.8.3.min.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/static/js/underscore-min.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/static/js/backbone-min.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/static/js/custom.js" type="text/javascript"></script>

<!-- jquery mobile -->
<!--  CDN
<link rel="stylesheet" href="http://code.jquery.com/mobile/1.2.0/jquery.mobile-1.2.0.min.css" />
<script src="http://code.jquery.com/mobile/1.2.0/jquery.mobile-1.2.0.min.js"></script>
-->

<script src="<%=request.getContextPath()%>/static/js/jquery.mobile-1.3.0.min.js" type="text/javascript"></script>
<link rel="stylesheet" href="<%=request.getContextPath()%>/static/css/jquery.mobile-1.3.0.min.css" />

<!-- custom scripts -->
<script src="<%=request.getContextPath()%>/static/js/localStorage.js" type="text/javascript"></script>

 <script type="text/javascript">
 
//underscore templating
	$(document).ready(function ()
	 {            
			_.templateSettings = {
			    interpolate: /\<\@\=(.+?)\@\>/gim,
			    evaluate: /\<\@(.+?)\@\>/gim,
			    escape: /\<\@\-(.+?)\@\>/gim
			};
			
	 });
 
 </script>

</head>
<body>