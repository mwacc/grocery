<%@include file="../generalpages/header.jsp" %> 

<fmt:message key="changepass.minlength" var="passmin"/>
<fmt:message key="changepass.notequals" var="badpass"/>

<!-- <script src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.9/jquery.validate.min.js"></script> -->

<script type="text/javascript">

   	function changePass(){
   		$('.alert').css('display','none');
   		$('input').removeClass('errorField');
   		
   		if( $('#chpw').val().length < 5 ){
   			$('#chpw').addClass('errorField');
   			$('#tooShort').css('display','block');
   			return false;
   		}

   		if( $('#chpw').val() != $('#chpw2').val() ) {
   			$('#chpw').addClass('errorField');
   			$('#chpw2').addClass('errorField');
   			$('#notEquals').css('display','block');
   			return false;
   		}
   		
   		var $form = $('#form'),
   		serializedData = $form.serialize();

   		$inputs = $form.find("input, select, button, textarea");
   		$inputs.attr("disabled", "disabled");
   		
   		$.ajax({
   			url: "<%=request.getContextPath()%>/rest/s/users/changepass",
   	        type: "post",
   	     	data: serializedData,
	   	     success: function(response, textStatus, jqXHR){
	   	    	$('.alert').css('display','none');
	   	    	$('#ok').css('display','block');
	         },
	         // callback handler that will be called on error
	         error: function(jqXHR, textStatus, errorThrown){
	        	 if( jqXHR.status == '400' ) {
	        		 $('.alert').css('display','none'); 
	        		 $('#notEquals').css('display','block');
	        	 } else {
	        		 $('.alert').css('display','none');
	             	 $('#badAuth').css('display','block');
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



  <div class="row">
 	<div class="span3"></div>
 	<div class="span6">
	 	<div class="alert alert-error" align="center" style="display: none;" id="badAuth">
	 		<fmt:message key="changepass.bad" />
	 	</div>
	 	<div class="alert alert-error" align="center" style="display: none;" id="notEquals">
	 		<fmt:message key="changepass.notequals" />
	 	</div>
	 	<div class="alert alert-error" align="center" style="display: none;" id="tooShort">
	 		<fmt:message key="changepass.tooshort" />
	 	</div>
	 	<div class="alert alert-success" align="center" style="display: none;" id="ok">
	 		<fmt:message key="changepass.ok" />
	 	</div>
	 </div>
 	<div class="span3"></div>
  </div>
  

<form  id="form" class="form-horizontal well" onsubmit="changePass(); return false;">
<fieldset>
  <div class="control-group">
 	<label class="control-label" for="inputPass">
 		<fmt:message key="changepass.oldpass" />
 	</label>
 	<div class="controls">
     	<INPUT TYPE="PASSWORD" NAME="oldpass" id="inputPass">   	
    </div>	
  </div>
  <div class="control-group">   
    <label class="control-label" for="chpw">
 		<fmt:message key="changepass.newpass" />
 	</label>
 	<div class="controls">
     	<INPUT TYPE="PASSWORD" NAME="newpass" id="chpw"> 
     	<p class="help-block"> <fmt:message key="changepass.minlength"/> </p>  	
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
  <div align="center">
	  <button type="submit" class="btn btn-info" >
	   	<fmt:message key="changepass.change" />
	  </button>
  </div>
</fieldset>
</form>

   	


<%@include file="../generalpages/footer.jsp" %> 