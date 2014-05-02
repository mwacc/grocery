<%@page import="org.springframework.util.StringUtils"%>
<%@include file="generalpages/header.jsp" %> 



<div class="row">
	<div class="span10 offset1" >
		<div class="alert alert-block" style="display: none;" id="bad1">
			<fmt:message key="restore.unknown" />
		</div>
	</div>
</div>

<div class="row">
	<div class="span10 offset1" >
		<div class="alert alert-block" style="display: none;" id="bad2">
			<fmt:message key="restore.toolate" />
		</div>
	</div>
</div>

<div class="row">
	<div class="span10 offset1" >
		<div class="alert alert-block" style="display: none;" id="bad3">
			<fmt:message key="restore.error" />
		</div>
	</div>
</div>

<div class="row"  >
	<div class="span10 offset1" >
		<div class="alert alert-success" style="display: none;" id="ok">
			<fmt:message key="restore.success" />
		</div>
	</div>
</div>

<div class="row"  >
	<div class="span10 offset1" >
		<div class="alert alert-success" style="display: none;" id="ok2">
			<fmt:message key="restore.done" />
		</div>
	</div>
</div>

<% String key = request.getParameter( "key" );

if( !StringUtils.hasText(key)) {%>

<script type="text/javascript">
   	function sendMail(event){ 
   		var $form = $('#entermail'),
   		serializedData = $form.serialize();

   		$inputs = $form.find("input, select, button, textarea");
   		$inputs.attr("disabled", "disabled");
   		
   		$.ajax({
   			url: "<%=request.getContextPath()%>/rest/users/try2restore",
   	        type: "post",
   	     	data: serializedData,
	   	     success: function(response, textStatus, jqXHR){
	   	    	$('.alert').css('display','none'); 
	   	    	$('#ok').css('display','block');
	         },
	         // callback handler that will be called on error
	         error: function(jqXHR, textStatus, errorThrown){
	        	 $('.alert').css('display','none');
	        	 if( jqXHR.status == '400' ) {
	            	 $('#bad1').css('display','block');
	        	 } else {
	        		 $('#bad3').css('display','block');
	        	 }
	         },
	         // callback handler that will be called on completion
	         // which means, either on success or error
	         complete: function(){
	             // enable the inputs
	             $('#mail').val('');
	             $inputs.removeAttr("disabled");
	         }
   		});
   		
   	}
   	
</script>

<div class="row" id="putmail">
	<div class="span10 offset1">
		<form class="form-horizontal well" id="entermail" onsubmit="sendMail();return false;">
			<fieldset>
				<legend> <fmt:message key="restore.forgotpassword" /> </legend>
				<div class="control-group">
					<label class="control-label" for="mail">
						<fmt:message key="restore.entermail" />
					</label>
					<div class="controls">
						<input type="email" class="input-xlarge" name="mail" id="mail"/>
						<p><fmt:message key="restore.mailtooltip" /></p>
					</div>
				</div>
				<div class="form-actions">
					<button type="submit" class="btn btn-primary">
						<fmt:message key="restore.restore" />
					</button>
				</div>
			</fieldset>
		</form>
	</div>
</div>	
<% } else { 
 out.println("<input type='hidden' name='key' id='key' value='"+key+"'/>");
%>

<script type="text/javascript">
   	function resetPassword(){
   		if( isBlank($('#pass').val()) || isBlank($('#repass').val()) || isBlank($('#key').val()) ){
   			return false;
   		} 
   		
   		// add check on content length and equality
   		
   		var $form = $('#newpass'),
   		serializedData = $form.serialize();

   		$inputs = $form.find("input, select, button, textarea");
   		$inputs.attr("disabled", "disabled");

   		$.ajax({
   			url: "<%=request.getContextPath()%>/rest/users/restore/"+$('#key').val(),
   	        type: "post",
   	     	data: serializedData,
	   	     success: function(response, textStatus, jqXHR){
	   	    	$('.alert').css('display','none'); 
	   	    	$('#ok2').css('display','block');
	   	    	
	   	    	window.setTimeout("window.location.href = '<%=request.getContextPath()%>/'", 1600);
	         },
	         // callback handler that will be called on error
	         error: function(jqXHR, textStatus, errorThrown){
	        	 $('.alert').css('display','none');
	        	 if( jqXHR.status == '400' ) {
	            	 $('#bad2').css('display','block');
	        	 } else {
	        		 $('#bad3').css('display','block');
	        	 }
	         },
	         // callback handler that will be called on completion
	         // which means, either on success or error
	         complete: function(){
	             // enable the inputs
	             $inputs.removeAttr("disabled");
	         }
   		});
   		
   		
   	}
   	
</script>

<div class="row"  id="restore">
	<div class="span10 offset1">
		<form class="form-horizontal well" id="newpass" onsubmit="resetPassword(); return false;">
			<fieldset>
				<legend> <fmt:message key="restore.forgotpass2" /> </legend>
				<div class="control-group">
					<label class="control-label" for="oldpass"><fmt:message key="changepass.newpass" /></label>
					<div class="controls">
						<input type="password" name="pass" class="input-xlarge" id="pass" maxlength="30" required="required"/>
						<p class="help-block"> <fmt:message key="changepass.minlength"/> </p>  
					</div>
				</div>
				<div class="control-group">
					<label class="control-label" for="newpass"><fmt:message key="changepass.renewpass" /></label>
					<div class="controls">
						<input type="password" name="repass" class="input-xlarge" id="repass" maxlength="30" required="required"/>
						<p class="help-block"> <fmt:message key="changepass.notequals"/> </p> 
					</div>
				</div>
				<div class="form-actions">
					<button type="submit" class="btn btn-primary">
						<fmt:message key="restore.reset" />
					</button>
				</div>
			</fieldset>
		</form>
	</div>
</div>	
<% } %>

<%@include file="generalpages/footer.jsp" %> 	