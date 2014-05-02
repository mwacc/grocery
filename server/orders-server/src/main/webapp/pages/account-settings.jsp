<%@include file="../generalpages/header.jsp" %> 

<script src="<%=request.getContextPath()%>/static/js/form2json.js" type="text/javascript"></script>

<script type="text/javascript">
function updateMailing() {
	$('#mailingCheckboxValue').attr('value', $('#mailingCheckbox').is(':checked') ) 
}

function loadDate() {
	$.ajax({
		url: "<%=request.getContextPath()%>/rest/s/users/accsettings",
        type: "get",
	     success: function(response, textStatus, jqXHR){
	    	$('.alert').css('display','none');

	    	$('input:radio[name="theme"]')[JSON.parse(jqXHR.responseText).theme-1].checked = true;
	    	$('#mailingCheckbox').attr('checked', JSON.parse(jqXHR.responseText).allowMailing );
	    	$('#mailingCheckboxValue').attr('value', JSON.parse(jqXHR.responseText).allowMailing);
	     },
	     // callback handler that will be called on error
	     error: function(jqXHR, textStatus, errorThrown){
	    		 $('.alert').css('display','none');
	         	 $('#bad').css('display','block');
	     },
	     // callback handler that will be called on completion
	     // which means, either on success or error
	     complete: function(){
	         // enable the inputs
	         //$inputs.removeAttr("disabled");
	     }
	});
}

function save(){
	var $form = $('#form');
	var serializedData = $form.serializeObject(); 

	$inputs = $form.find("input, select, button, textarea");
	$inputs.attr("disabled", "disabled");
	$.ajax({
		url: "<%=request.getContextPath()%>/rest/s/users/updateaccsettings",
        type: "post",
        data: JSON.stringify(serializedData),
     	dataType: "json",
     	contentType: "application/json; charset=utf-8",
  	    success: function(response, textStatus, jqXHR){
  	    	$('.alert').css('display','none');
  	    	$('#ok').css('display','block');
  	    	
  	    	window.setTimeout('location.reload()', 1200);
        },
        // callback handler that will be called on error
        error: function(jqXHR, textStatus, errorThrown){
   		 	$('.alert').css('display','none');
        	$('#notok').css('display','block');
    	},
        // callback handler that will be called on completion
        // which means, either on success or error
        complete: function(){
            // enable the inputs
            $inputs.removeAttr("disabled");
        }
	});
	
}
	
$(loadDate)
$(applySerializationToJson)
</script>


<div class="row">
 	<div class="span3"></div>
 	<div class="span6">
	 	<div class="alert alert-error" align="center" style="display: none;" id="notok">
	 		<fmt:message key="accountsettings.bad" />
	 	</div>
	 	<div class="alert alert-success" align="center" style="display: none;" id="ok">
	 		<fmt:message key="accountsettings.ok" />
	 	</div>
	 </div>
 	<div class="span3"></div>
  </div>


<form  id="form" class="form-horizontal well" onsubmit="save(); return false;">
 <fieldset>

  <div class="control-group">
 	<label class="control-label" for="inputPass">
 		<fmt:message key="accountsettings.theme" />
 	</label>
 	<div class="controls">
     	<label class="radio"> <input type="radio" name="theme" value="1"> <fmt:message key="accountsettings.theme1" /> </label>
		<label class="radio"> <input type="radio" name="theme" value="2"> <fmt:message key="accountsettings.theme2" /> </label>	
		<label class="radio"> <input type="radio" name="theme" value="3"> <fmt:message key="accountsettings.theme3" /> </label>
		<label class="radio"> <input type="radio" name="theme" value="4"> <fmt:message key="accountsettings.theme4" /> </label>	
    </div>	
  </div>
  <div class="control-group">
            <label class="control-label" for="mailingCheckbox">
            	<fmt:message key="accountsettings.mailing" />
            </label>
            <div class="controls">
              <label class="checkbox">
                <input type="checkbox" id="mailingCheckbox" checked="checked" onclick="updateMailing()">
                <input type="hidden" id="mailingCheckboxValue" name="allowMailing" value="true">
                <fmt:message key="accountsettings.mailing.details" />
              </label>
            </div>
          </div>
  <div align="center">
	  <button type="submit" class="btn btn-info" >
	   	<fmt:message key="general.save" />
	  </button>
  </div>

 </fieldset>
</form>

<%@include file="../generalpages/footer.jsp" %> 