<%@page import="java.util.Date"%>

<%@include file="generalpages/header.jsp" %> 	
   	
<script type="text/javascript">
   	function sendForm(){ 
   		var $form = $('#loginForm'),
   		serializedData = $form.serialize();

   		$inputs = $form.find("input, select, button, textarea");
   		$inputs.attr("disabled", "disabled");
   		
   		$.ajax({
   			url: "<%=request.getContextPath()%>/rest/users/signin",
   	        type: "post",
   	     	data: serializedData,
	   	     success: function(response, textStatus, jqXHR){
	   	    	window.location.href = '<%=request.getContextPath()%>/pages/dashboard.jsp';
	         },
	         // callback handler that will be called on error
	         error: function(jqXHR, textStatus, errorThrown){
	             $('#badAuth').css('display','block');
	         },
	         // callback handler that will be called on completion
	         // which means, either on success or error
	         complete: function(){
	             // enable the inputs
	             $inputs.removeAttr("disabled");
	         }
   		});
   		
   	}
   	
   	$(document).ready(function () {
   	    $('.carousel').carousel({
   	        interval: 6000,
   	     	pause: "hover"
   	    });

   	    $('.carousel').carousel('cycle');
   	}); 
</script>
 
        
        <p/>
        <div class="row">
               <div class="span12" align="center">
               	<h3><i>
               		<!-- <fmt:message key="page.title" /> -->  
               		<fmt:message key="first.row" />
               	</i></h3>  
               </div>
        </div>
        <p style="margin-top: 35px;"/>
        <div class="row">
        	<div class="span6">
        	
        	<div id="myCarousel" class="carousel slide hidden-phone" >
        		 <div class="carousel-inner" >
        		 	<div class="active item"> <img src="<%=request.getContextPath()%>/static/img/s1.png"/> 
	        		 	<div class="carousel-caption" style="color: white;">
	        		 		<a href="${language}/info.jsp#l1"><h3 style="color: white;"> <fmt:message key="index.v1" /></h3></a>
	        		 		<b style="color: white;"><fmt:message key="index.v1details" /></b> 
	        		 	</div>
        		 	</div>
        		 	<div class="item"> <img src="<%=request.getContextPath()%>/static/img/s2.jpg"/> 
	        		 	<div class="carousel-caption">
	        		 		<a href="${language}/info.jsp#l2"><h3 style="color: white;"> <fmt:message key="index.v2" /> </h3></a>
	        		 		<b style="color: white;"><fmt:message key="index.v2details" /> </b>
	        		 	</div>
        		 	</div>
        		 	<div class="item"> <img src="<%=request.getContextPath()%>/static/img/s3.jpg"/> 
	        		 	<div class="carousel-caption">
	        		 		<h3 style="color: white;"> <fmt:message key="index.v3" /> </h3>
	        		 		<b style="color: white;"><fmt:message key="index.v3details" /> </b>
	        		 	</div>
        		 	</div>
        		 </div>
        		 
        		 <a class="carousel-control left" href="#myCarousel" data-slide="prev">&lsaquo;</a>
        		 <a class="carousel-control right" href="#myCarousel" data-slide="next">&rsaquo;</a>
        	</div>
        	
        	</div>
	        <div class="span6" align="right"> 
	          <form  id="loginForm" onsubmit="sendForm(); return false;" class="form-horizontal well">
	        	<div class="alert alert-error" style="display: none;" align="center" id="badAuth">
	        		<fmt:message key="index.badAuth" />
	        	</div>
	        	<div  align="right">
	            	E-mail <input type="email" name="email" autocomplete="on" autofocus="autofocus">    
	            </div>	
		        <br/>
	        	<div  align="right">
	            	<fmt:message key="index.password" />   <INPUT TYPE="PASSWORD" NAME="pass">   	
	            </div>	
	        	<br/>
	        	<div  align="right">
	               	<button type="submit" class="btn btn-info" >
	               		<fmt:message key="index.signin" />
	               	</button>
	            </div>	
	           </form> 
		       	 <p/>
		         <div style="margin-top: 25px;" align="right">
		             	<a href="<%=request.getContextPath()%>/register.jsp" >
		             		<fmt:message key="index.signup" />
				 		</a>
		         </div>
		         <div style="margin-top: 25px;" align="right">
		             	<a href="<%=request.getContextPath()%>/restore.jsp" >
		             		<fmt:message key="restore.forgotpassword" />
				 		</a>
		         </div>  
		     </div>
		     <div class="span2"></div>
        </div>
        <p style="margin-top: 35px;"/> 
     <div class="row">
        <div class="span6" align="left">
        	
        </div>
        <div class="span6" align="left">
        	<a href="${language}/info.jsp"> <h3> <fmt:message key="index.learnmore" /> </h3> </a> 
        	<a href="${language}/taketour.jsp"> <h3> <fmt:message key="index.taketour" /> </h3> </a>	
        	
        </div>
      </div>  
      
<%@include file="generalpages/footer.jsp" %> 


    