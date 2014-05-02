<%@include file="generalpages/header.jsp" %> 
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<div class="row">
	<div class="span10 offset1" >
		<div class="alert alert-block" style="display: none;" id="bad1">
			<fmt:message key="register.error" />
		</div>
	</div>
</div>

<div class="row">
	<div class="span10 offset1" >
		<div class="alert alert-block" style="display: none;" id="bad2">
			<fmt:message key="register.already" />
		</div>
	</div>
</div>

<div class="alert alert-error" align="center" style="display: none;" id="tooShort">
	<fmt:message key="changepass.tooshort" />
</div>
<div class="alert alert-error" align="center" style="display: none;" id="notEquals">
	<fmt:message key="changepass.notequals" />
</div>


<div class="row"  >
	<div class="span10 offset1" >
		<div class="alert alert-success" style="display: none;" id="ok">
			<h2> <fmt:message key="register.success" /> </h2>
			<br/>
			<p>
				<h4><fmt:message key="footer.sharepassion" /></h4>
				<div class='pluso pluso-theme-color'><a class='pluso-pinterest'></a><a class='pluso-facebook'></a><a class='pluso-twitter'></a><a class='pluso-vkontakte'></a><a class='pluso-google'></a><a class='pluso-livejournal'></a><a class='pluso-pinme'></a><a class='pluso-odnoklassniki'></a><a class='pluso-surfingbird'></a><a class='pluso-tumblr'></a><a class='pluso-delicious'></a><a class='pluso-digg'></a><a class='pluso-yandex'></a><a class='pluso-email'></a></div>
				<script type='text/javascript'>if(!window.pluso){pluso={version:'0.9.1',url:'http://share.pluso.ru/'};h=document.getElementsByTagName('head')[0];l=document.createElement('link');l.href=pluso.url+'pluso.css';l.type='text/css';l.rel='stylesheet';s=document.createElement('script');s.src=pluso.url+'pluso.js';s.charset='UTF-8';h.appendChild(l);h.appendChild(s)}</script>
			</p>
		</div>
	</div>
</div>

<script type="text/javascript">
   	function register() { 
   		if( $('#pass').val().length < 5 ){
   			$('#pass').addClass('errorField');
   			$('#tooShort').css('display','block');
   			return false;
   		}
   		
   		if( $('#pass').val() != $('#chpw2').val() ) {
   			$('#pass').addClass('errorField');
   			$('#chpw2').addClass('errorField');
   			$('#notEquals').css('display','block');
   			return false;
   		}
   		
   		var $form = $('#goForm'),
   		serializedData = $form.serialize();

   		$inputs = $form.find("input, select, button, textarea");
   		$inputs.attr("disabled", "disabled");
   		
   		$.ajax({
   			url: "<%=request.getContextPath()%>/rest/users/register",
   	        type: "post",
   	     	data: serializedData,
	   	     success: function(response, textStatus, jqXHR){
	   	    	$('.alert').css('display','none'); 
	   	    	$('#ok').css('display','block');
	   	    	$('#reg').css('display','none');
	         },
	         // callback handler that will be called on error
	         error: function(jqXHR, textStatus, errorThrown){
	        	 $('.alert').css('display','none');
	        	 if( jqXHR.status == '400' ) {
	            	 $('#bad2').css('display','block');
	        	 } else {
	        		 $('#bad1').css('display','block');
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
   	
   	function agreed() {
   		if( $('#agreeId').is(":checked") ) {
   			$('#regId').removeAttr('disabled');
   		} else {
   			$('#regId').attr('disabled', 'disabled');
   		}
   	}
</script>

<div class="row" id="reg">
	<div class="span8 offset2">
		<form class="form-horizontal well" id="goForm" onsubmit="register();return false;" autocomplete="on">
			<fieldset>
				<legend> <fmt:message key="register.registrationform" /> </legend>
				<div class="control-group">
					<label class="control-label" for="mail">
						<fmt:message key="register.mail" />
					</label>
					<div class="controls">
						<input type="email" class="input-xlarge" name="mail" id="mail" required="required" maxlength="40"/>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label" for="pass">
						<fmt:message key="register.pass" />
					</label>
					<div class="controls">
						<input type="password" class="input-xlarge" name="pass" id="pass" required="required" maxlength="30"/>
						<p><fmt:message key="register.passrules" /></p>
					</div>
				</div>
				<div class="control-group">    
				    <label class="control-label" for="chpw2">
				 		<fmt:message key="changepass.renewpass" />
				 	</label>
				 	<div  class="controls">
				     	<INPUT TYPE="PASSWORD" NAME="renewpass" id="chpw2">  
				     	<p class="help-block"> <fmt:message key="changepass.notequals"/> </p>  	
				    </div>
				</div>  
				<div class="control-group">
					<label class="control-label" for="pass">
						<fmt:message key="register.lang" />
					</label>
					<div class="controls">
						<select id="lang" name="lang">
			                <option value="en" ${language == 'en' ? 'selected' : ''}>English</option>
		               	 	<option value="ru" ${language == 'ru' ? 'selected' : ''}>Русский</option>
			            </select>
			            <p><fmt:message key="register.langtip" /></p>
					</div>
				</div>
				<div class="control-group">
					<div class="controls">
						<label class="checkbox">
							<input type="checkbox" value="acept" id="agreeId" onclick="agreed()"/>
							<fmt:message key="register.licenseagreement" />
						</label>
					</div>
				</div>
				<div style="visibility: none;">
					<input type="hidden" name="refId" value="<%=request.getParameter( "refId" )%>"/>
				</div>
				<div class="form-actions">
					<button type="submit" class="btn btn-primary" disabled="disabled" id="regId">
						<fmt:message key="register.go" />
					</button>
				</div>
			</fieldset>
		</form>
	</div>
</div>	
<p/>

<%@include file="generalpages/footer.jsp" %> 