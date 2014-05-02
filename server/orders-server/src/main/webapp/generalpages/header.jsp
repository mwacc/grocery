
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page session="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<%@include file="../public/lang.jsp" %> 
<!DOCTYPE html>

<fmt:message key="general.comingSoon" var="commingSoon" />
<fmt:message key="header.reviewlist" var="reviewlist" />
<fmt:message key="header.clearlist" var="clearlist" />

<html lang="${language}" manifest="grocering.appcache">
    <head>
        <title> 
<%--         	<fmt:message key="header.title" />  --%>
        	<fmt:message key="first.row" />
       	</title>
        <meta name="description" content="Smart meal planner for family: we provide weekly menu ideas for you family or create own one. Shopping list app with shopping list templates and cookbook online, also available on iPhone, Android and Windows Phone " />
		<meta name="keywords" content="grocery list with recipes, meal planner, weekly menu ideas, shopping list, grocery list, shopping list app, menu planner, weekly menu planner, menu planner template, online shopping list, grocery shopping,online cookbook,
		 меню на неделю, диета на неделю, список покупук, рецепты, рецепты салатов, рецепты блюд,
		 Einkaufszettel,liste d'achats" />
		<meta http-equiv="content-type" content="text/html; charset=UTF-8">
		<meta name=”robots” content=”index,follow”> 

		<link rel="shortcut icon" href="<%=request.getContextPath()%>/static/img/ico.png" type="image/png">
        <link rel="stylesheet" type="text/css" media="screen" href="<%=request.getContextPath()%>/static/schema/${schema}/css/bootstrap.min.css">
		<link rel="stylesheet" type="text/css" media="screen" href="<%=request.getContextPath()%>/static/css/override_bootstrap.css">
		<link rel="stylesheet" type="text/css" media="screen" href="<%=request.getContextPath()%>/static/css/main.css">
		<link rel="stylesheet" type="text/css" media="screen" href="<%=request.getContextPath()%>/static/schema/${schema}/styles.css">
		
		<script src="<%=request.getContextPath()%>/static/js/jquery-1.8.3.min.js" type="text/javascript"></script>
		<script src="<%=request.getContextPath()%>/static/schema/${schema}/js/bootstrap.min.js" type="text/javascript"></script>
		<script src="<%=request.getContextPath()%>/static/js/underscore-min.js" type="text/javascript"></script>
		<script src="<%=request.getContextPath()%>/static/js/backbone-min.js" type="text/javascript"></script>
		<script src="<%=request.getContextPath()%>/static/js/custom.js" type="text/javascript"></script>
		<script src="<%=request.getContextPath()%>/static/js/tinybox.js" type="text/javascript"></script>
		
		<!-- custom scripts -->
		<script src="<%=request.getContextPath()%>/static/js/localStorage.js" type="text/javascript"></script>
		
		<!--[if lt IE 9]>  
		    <script src="//html5shim.googlecode.com/svn/trunk/html5.js"></script>  
		<![endif]-->
    </head>
    
  <body class="page_style">
    
<script type="text/template" id="grocerylist-review">
<div class="row" style="background:#636363;opacity:0.8;filter:alpha(opacity=80);">
<div class="span3">
 <div align="center" onclick='shoppingListVisibility()'>
   <b style="color: white;">${reviewlist}</b>
   <i class="icon-chevron-up icon-white" style="float: right;"  id='shoppingListVisibilityId'></i>
 </div>
 <div align="left" id="review-grocerylist-id" style='height: 450px; overflow-y: auto;'></div>
 <div align="right"> <a style="color: white;" onclick="clearLocalStorage();location.reload()"> ${clearlist} </a> </div>
</div>
</div>
</script>

<script type="text/template" id="grocerylist-review-item">
<div style="color: white;font-size: small;"><b><@=categoryName@></b></div>
<@ _.each(items, function(i) { @>
	<div style="color: white;font-size: small;"><i style='margin-left:8px;'><@=i.item@></i>&nbsp;<i><@=i.comment@></i></div>
<@ }); @>
</script>    
    
 <script type="text/javascript">
    
   	function langSubmit() {
   		var langForm = document.getElementById('langFromId');
   		var select = document.getElementById("language");
   		var langCode = select.options[select.selectedIndex].value;
   		
   		var exdate = new Date();
   		exdate.setDate(exdate.getDate() + 1000); // current time + 3 years
   		document.cookie = "lang=" + langCode + "; path=/; expires="+exdate.toUTCString() + ";";
   		langForm.submit();
   	}
   	
   	function signOut() {
   		try {
   			
	   	    $.ajax({
				url: "<%=request.getContextPath()%>/rest/s/users/signout",
		        type: "post",
		   	     success: function(response, textStatus, jqXHR){
		   	   		// clear shopping list
		   	   		clearLocalStorage();
		   	   		
		   	   		try{
		   		   	 	var exdate = new Date();
		   				exdate.setDate(0);
		   			 	document.cookie = "epath=x; path=/; expires="+exdate.toUTCString() + ";";
		   	   		}catch(e){}
		   	   		
		   	    	window.location.href = '<%=request.getContextPath()%>';
		         }
	   	    });
   		} catch(e){}
   	    
   	}
   	
   	// bootstrap tooltips
   	function activateTooltip(){
   		$("[rel=tooltip]").tooltip();
   	}
   	
   	
   	
   	// underscore templating
   	$(document).ready(function ()
    {            
   		_.templateSettings = {
		    interpolate: /\<\@\=(.+?)\@\>/gim,
		    evaluate: /\<\@(.+?)\@\>/gim,
		    escape: /\<\@\-(.+?)\@\>/gim
		};
   		
    });
   	
   	function shoppingListVisibility() {
   		if( $('#shoppingListVisibilityId').hasClass('icon-chevron-up') ) {
   			$('#shoppingListVisibilityId').removeClass('icon-chevron-up');
   			$('#shoppingListVisibilityId').addClass('icon-chevron-down');
   			$('#review-grocerylist-id').hide();
   			$('#success').css('height','20px');
   		} else {
   			$('#shoppingListVisibilityId').addClass('icon-chevron-up');
   			$('#shoppingListVisibilityId').removeClass('icon-chevron-down');
   			$('#review-grocerylist-id').show();
   			$('#success').css('height','470px');
   		}
   	}
   	
</script>

<c:if test="${isAuth}">
	<script type="text/javascript">
	// floating grocery list
   	$(document).ready(function ()
   	{
		activateTooltip();
   		
		if(typeof(Storage)!=="undefined") { 
			sessionStorage.grocerylistdepictured = 'no'
		}
   		activateReviewItems();   		
   	});
   	</script>
</c:if>

	<div class="container wrapper container_bg" id="containerId">
	  <div style="padding-bottom: 70px;">
        <div class="row">
        	<div class="span8" align="left">  <a href="/"> <h1>GROCERING</h1> </a> </div>
        	<div class="span4" align="right">
        		<form id="langFromId">
		            <select id="language" onchange="langSubmit()">
		                <option value="en" ${language == 'en' ? 'selected' : ''}>English</option>
		                <option value="ru" ${language == 'ru' ? 'selected' : ''}>Русский</option>
		            </select>
		        </form>
        	</div>
        </div>
     <c:if test="${isAuth}">   
        <div class="navbar">
		  <div class="navbar-inner">
		    <div class="container">
		      <ul class="nav">
				  <li>
				    <a href="<%=request.getContextPath()%>/pages/dashboard.jsp" style="font-weight: bold;">  <fmt:message key="header.home" />  </a>
				  </li>
				  <li>
				    <a href="<%=request.getContextPath()%>/pages/templates.jsp" style="font-weight: bold;">  <fmt:message key="header.templates" />  </a>
				  </li>
				  <!-- 
				  <li>
				    <a href="#">  <fmt:message key="header.scheduler" />  </a>
				  </li>
				  <li>
				    <a href="#">  <fmt:message key="header.cookbook" />  </a>
				  </li>
				  <li>
				    <a href="#">  <fmt:message key="header.menu" />  </a>
				  </li>
				  -->
			  </ul>
			  <ul class="nav pull-right">
			  	<li class="divider-vertical"></li>
			  	<li class="dropdown">
			  		<a href="#" class="dropdown-toggle" data-toggle="dropdown">
			  			<i class="icon-user"></i> <fmt:message key="header.account" />  <b class="caret"></b>
			  		</a>
			  		<ul class="dropdown-menu">
			  			<li> <a href="<%=request.getContextPath()%>/pages/account-settings.jsp"> <fmt:message key="header.accountsettings" />  </a> </li>
			  			<li> <a href="<%=request.getContextPath()%>/pages/changepass.jsp"> <fmt:message key="header.changepass" />  </a> </li>
			  			<li> <a href="javascript:signOut()"> <i class="icon-off"></i> <fmt:message key="header.logout" />  </a> </li>
			  		</ul>
			  	</li>
			  	
			  </ul>
		    </div>
		  </div>
		</div>
	</c:if>