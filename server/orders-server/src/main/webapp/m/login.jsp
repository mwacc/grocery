<%@include file="../generalpages/m-header.jsp" %> 

<fmt:message key="index.password" var="passwordLabel"/>

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
	   	    	window.location.href = '<%=request.getContextPath()%>/m/templates.jsp';
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
</script>

<form id="loginForm">
  <div data-role="login" id="loginPage" align="center">
    <div data-role="content">
        <h2>
            Grocering
        </h2>
        <h4> <fmt:message key="page.title" />  </h4>
        <div data-role="fieldcontain">
            <fieldset data-role="controlgroup">
                <input name="email" id="emailId" placeholder="Email" value="" type="email">
            </fieldset>
        </div>
        <div data-role="fieldcontain">
            <fieldset data-role="controlgroup">
                <input name="pass" id="passId" placeholder="${passwordLabel}" value="" type="password">
            </fieldset>
        </div>
        <a data-role="button" data-inline="true" data-transition="none" data-theme="b"
        href="#page1" onclick="sendForm();">
            <fmt:message key="index.signin" />
        </a>
        <div style="margin-top:20px;">
            <a href="<%=request.getContextPath()%>/register.jsp" data-transition="fade">
               <fmt:message key="index.signup" />
            </a>
        </div>
    </div>
  </div>
</form>

<%@include file="../generalpages/m-footer.jsp" %> 