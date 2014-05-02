<%@include file="../generalpages/header.jsp" %> 

<script src="<%=request.getContextPath()%>/static/js/form2json.js" type="text/javascript"></script>

<fmt:message key="general.add" var="addItem"/>
<fmt:message key="customtemplate.itemname" var="itemName"/>
<fmt:message key="customtemplate.categoryname" var="categoryName"/>


<script type="text/javascript">
//manage categories visibility
function selectCategory(id) {
	$(".category_display_control").css("display", "none");
	$(".category_display_controler").removeClass("btn-success");
	$("#"+id).addClass("btn-success");
	$("#list"+id).css("display", "block");
}

function addCategory() {
	if( isBlank( $("#newCategory").val() ) )  return;
	var cId = $("#categoryCounter").val();
	
	var newCat_html = _.template($('#category-template').html());
	var h = $(newCat_html({categoryId: cId, categoryName: $("#newCategory").val()}));
	insertHtmlAsStack('#categories', h, cId==0);

	var newItems_html = _.template($('#items-group-template').html());
	var h2 = $(newItems_html({categoryId: cId, categoryName: $("#newCategory").val()}));
	$('#content').append(h2);
	
	selectCategory(cId);
	$("#categoryCounter").val( incrementCounter(cId) );
	$("#newCategory").val('');
}

function addItem(categoryId) {
	if( isBlank( $("#newItem"+categoryId).val() ) )  return;
	var counter = $("#itemsCounter"+categoryId).val();
	
	var newItem_html = _.template($('#item-template').html());
	var h = $(newItem_html({categoryId: categoryId, itemId: counter, item: $("#newItem"+categoryId).val()}));
	insertHtmlAsStack('#items'+categoryId, h, counter==0);
	
	$("#itemsCounter"+categoryId).val( incrementCounter(counter) );
	$("#newItem"+categoryId).val('');
}

function remove(itemId) {
	$('#'+itemId).remove();
}

$(applySerializationToJson)

// send form
function save(){
	var serializedData = $('#formToSent').serializeObject();
	$inputs = $('#formToSent').find("input, select, button, textarea, a");
	$inputs.attr("disabled", "disabled");
	$.ajax({
		url: "<%=request.getContextPath()%>/rest/s/templates/custom",
        type: "POST",
     	data: JSON.stringify(serializedData),
     	dataType: "json",
     	contentType: "application/json; charset=utf-8",
  	    success: function(response, textStatus, jqXHR){
  	    	window.location.href = '<%=request.getContextPath()%>/pages/templates.jsp';
        },
        // callback handler that will be called on error
        error: function(jqXHR, textStatus, errorThrown){
            $('#badMail').css('display','block');
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

<script type="text/template" id="category-template">
<button class="btn category_display_controler category_button" type="button" 
  id="<@=categoryId@>" onclick="selectCategory('<@=categoryId@>')"> <@=categoryName@> </button>
</script>

<script type="text/template" id="item-template">
 <div class="items_in_category" id='item<@=categoryId@>_<@=itemId@>'> 
   <@=item@> 
   <input type='hidden' name='goodsGroups[<@=categoryId@>][items][<@=itemId@>]' value='<@=item@>' id="<@=categoryId@>_<@=itemId@>"/>
   <i class="icon-remove icon-white" onclick='remove("item<@=categoryId@>_<@=itemId@>")'></i>
</div>
</script>

<script type="text/template" id="items-group-template">
<div style="display: block;" class="category_display_control" id="list<@=categoryId@>">
  <div id="items<@=categoryId@>">
    <div class="input-append category_button items_in_category" align="left">
	  <input type='text'  placeholder='${itemName}' id='newItem<@=categoryId@>' maxlength="20" style="width: 60%"/>
	  <button class="btn" type="button" onclick="addItem('<@=categoryId@>')" style="width: 34%"> ${addItem} </button>
	</div>	
  </div>
  <input type='hidden' value='0' id="itemsCounter<@=categoryId@>"/>
  <input type='hidden' value='<@=categoryId@>' name="goodsGroups[<@=categoryId@>][gid]"/>
  <input type='hidden' name='goodsGroups[<@=categoryId@>][name]' value='<@=categoryName@>'/>
</div>
</script>

<div class="row">
	<div class="span12" align="left" >
       	<button class="btn .btn-large" type="button" onclick="javascript: history.go(-1)"> 
       		<fmt:message key="general.back" />
       	</button>  
    	<fmt:message key="customtemplate.desc" />
    </div>
</div>

<!-- this elements is used for inserting code -->
<form id="formToSent" class="span12" style="margin-top: 3%" method="POST">
  <div class="row">	
	<div style="margin-bottom:2%;">
		<fmt:message key="customtemplate.name" />&nbsp;<input type="text" maxlength="25" name="name" autocomplete="on"/>
	</div>
  </div>
  <div class="row">	
  <div id="content">
	<div class="btn-group btn-group-vertical" id="categories" style="float: left; margin-right: 5%;">
		
		<div class="input-append category_button category_list_column" align="left" style="margin-top:8px;">
		 <input type='text'  placeholder='${categoryName}' id='newCategory' maxlength="20" style="width: 60%"/>
		 <button class="btn" type="button" onclick="addCategory()" style="width: 34%"> ${addItem} </button>
		</div>
		<input type='hidden' value='0' id="categoryCounter"/>
	</div>
  </div>
  </div>	
  <div class="row">	
	<div style="margin-top:2%;" align="center">
		<button class="btn btn-primary" style="display: inline-block; vertical-align: top;"  id="sendButtonId" onclick="save(); return false;"> 
		    <fmt:message key="customtemplate.save" /> 
		</button>
	</div>
  </div>
</form>

<%@include file="../generalpages/footer.jsp" %> 