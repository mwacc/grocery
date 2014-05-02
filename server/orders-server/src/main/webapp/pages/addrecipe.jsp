<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@include file="../generalpages/header.jsp" %> 	

<script type="text/template" id="indigrients-template">
<div>
	<b><@=name@></b> <@=amount@>
	
	
</div> 
</script>

<form class="form-horizontal well">
  <fieldset>
    <legend> <fmt:message key="addrecipe.title" /> </legend>
    <div class="control-group">
      <label class="control-label" for="recipeName"> <fmt:message key="addrecipe.name" /> </label>
      <div class="controls">
        <input type="text" class="input-xlarge" name="name" id="recipeName">
        <p class="help-block">In addition to freeform text, any HTML5 text-based input appears like so.</p>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label" for="recipeImg"> <fmt:message key="addrecipe.img" /> </label>
      <div class="controls">
        <input type="file" class="input-xlarge" name="imgSrc" id="recipeImg">
      </div>
    </div>
    
    <div class="control-group">
   	 	<label class="control-label"> <fmt:message key="addrecipe.indigrients" /> </label>
   	 	<div class="controls">
   	 	  <div id="indigrients"></div>
    	  <div class="input-append" align="left" id="indigrients">
		 	<input type='text' class="span3" id="indigrient1" placeholder='' maxlength="20" spellcheck="true"/>
			<select id="indigrient2" class="span2">
			  <option value="1">Meat</option>
			  <option value="2">Fish</option>
			</select>
			<input type='text' id="indigrient3" class="span2" placeholder='' maxlength="20"  spellcheck="true"/>
			<button class="btn" type="button" onclick=""> Add </button> 
		  </div>
		  
		</div>
	</div>
    
    <div class="form-actions">
      <button type="submit" class="btn btn-primary">Save changes</button>
      <button type="reset" class="btn">Cancel</button>
    </div>
  </fieldset>
</form>

<%@include file="../generalpages/footer.jsp" %> 