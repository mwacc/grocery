<%@include file="../generalpages/header.jsp" %> 

<div class="row">
	<div class="span3"></div>
	<div class="span6">
	<% if( "success".equals(request.getParameter( "result" )) ) { %>
		<div class="alert alert-success" align="center"> <fmt:message key="dashboard.successfulgrocerulist" /> </div> 
	<%} %>
	</div>
</div>

<div class="row">
	<div class="span6" align="left">
       	<h3>
       		<fmt:message key="dashboard.howto" />  
       	</h3>  
    </div>
</div>

<div class="row">
	<div class="span1"></div>
	<div class="span7" align="left">
       	<ol>
       		<li> <fmt:message key="dashboard.howto1" /> </li> 
       		<li> <fmt:message key="dashboard.howto2" /> </li> 
       		<li> <fmt:message key="dashboard.howto3" /> </li> 
       	</ol>  
    </div>
</div>

<%@include file="../generalpages/footer.jsp" %>