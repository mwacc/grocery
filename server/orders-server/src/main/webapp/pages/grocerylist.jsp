<%@include file="../generalpages/header.jsp" %> 


<script src="<%=request.getContextPath()%>/static/js/form2json.js" type="text/javascript"></script>

<fmt:message key="grocerylist.itemsInBasket" var="itemsInBasket"/>
<fmt:message key="grocerylist.comment" var="itemComment"/>
<fmt:message key="grocerylist.newItem" var="newItem"/>
<fmt:message key="general.add" var="addItem"/>

<script type="text/javascript">

var Entities = {};

Entities.Collection = Backbone.Collection.extend({
    url: "<%=request.getContextPath()%>/rest/s/templates/custom/g/<%=request.getParameter( "template" )%>"
});

Entities.Views = {};

// View
Entities.Views.List = Backbone.View.extend({   
    
    initialize: function(){
      _(this).bindAll( 'render'); // fixes loss of context for 'this' within methods
      this.collection.bind('refresh', this.render);// not all views are self-rendering. This one is.
    },
      
    render: function(){ 
    	$('#content').empty();
    	this.collection.each(function(item){ // in case collection is not empty
    		var accordion_html = _.template($('#grocerylist-template').html());
    	
    		var h = $(accordion_html({id: item.get("id"), name: item.get("name"), categories: item.get("goodsGroups")}))
        	$('#content').append( h ); 
        }, this);
    	selectCategory( $('.category_display_controler').get(0).id );
    	activateTooltip();
    }
 });

function loadGroceryListData() {
	var collection = new Entities.Collection();
   	var view = new Entities.Views.List({
       	collection: collection
   	});

	collection.fetch({
		success: function () {
			view.render();
			loadDataFromLocalStorage(markItemAsSelected);
		}
	});
}


$(loadGroceryListData);
$(applySerializationToJson)

//manage categories visibility
function selectCategory(id) {
	$(".category_display_control").css("display", "none");
	$(".category_display_controler").removeClass("btn-success");
	$("#"+id).addClass("btn-success");
	$("#list"+id).css("display", "table");
}

itemsInBasket = 0;


function markItemAsSelected(groupId, itemId) {
	if( $('#ch'+groupId+"_"+itemId).is(':checked') ) {
		$("#icon"+groupId+"_"+itemId).removeClass("icon-ok");
		$('#ch'+groupId+"_"+itemId).attr('checked', false);
		$('#link'+groupId+"_"+itemId).removeClass('included_item');
		$('#link'+groupId+"_"+itemId).addClass('excluded_item');
		$('.'+groupId+"_"+itemId).each( function (i) {
			$(this).attr('name', '-'+$(this).attr('name'));
		} );
		
		updateCounter(-1);
		updateCategoryCounter(groupId, -1);
	} else {
		$("#icon"+groupId+"_"+itemId).addClass("icon-ok");
		$('#ch'+groupId+"_"+itemId).attr('checked', true);
		$('#link'+groupId+"_"+itemId).removeClass('excluded_item');
		$('#link'+groupId+"_"+itemId).addClass('included_item');
		$('.'+groupId+"_"+itemId).each( function (i) {
			$(this).attr('name', $(this).attr('name').substring(1));
		} );
		
		updateCounter(+1);
		updateCategoryCounter(groupId, +1);
	}
}

// add Item
function addItem(id) {
	if( isBlank( $("#newGood"+id).val() ) )  return;
	
	var indexGoods = $("#indexGoods"+id).val();
	var newItem_html = _.template($('#groceryitem-template').html());
	
	var newItem = $("#newGood"+id).val();
	var h = $(newItem_html({indexGroup: id, indexGoods:indexGoods, item: newItem}));

	$("#indexGoods"+id).val( incrementCounter(indexGoods) );
	$("#newGood"+id).val('');
	
	$('#table'+id).append( h );
	
	selectItem(id, indexGoods, markItemAsSelected);
}

function updateCounter(incrementOn) {
	itemsInBasket = itemsInBasket + incrementOn;
	$('#resultId').text( '${itemsInBasket}'.replace('<@=counter@>', itemsInBasket) );
	if( itemsInBasket > 0 ) {
		$("#sendButtonId").css('display','');
	} else {
		$("#sendButtonId").css('display','none');
	}
}

function updateCategoryCounter(categoryId, incrementOn) {
	var elVal = 0;
	try {
		elVal = parseInt( $('#itemsCount'+categoryId).text() );
		if( isNaN(elVal) ) elVal = 0;
	} catch(e){
		elVal = 0;
	}
	
	elVal = elVal + incrementOn; // increment or decrement
	if( elVal > 0 ) {
		$('#itemsCountDiv'+categoryId).show();
	}else{
		$('#itemsCountDiv'+categoryId).hide();
	}
	
	$('#itemsCount'+categoryId).text(elVal)	
}

// send form
function sendForm(){
	var serializedData = $('#formToSend').serializeObject();
	$inputs = $('#formToSend').find("input, select, button, textarea, a");
	$inputs.attr("disabled", "disabled");
	
	$.ajax({
		url: "<%=request.getContextPath()%>/rest/s/grocery",
        type: "post",
     	data: JSON.stringify(serializedData),
     	dataType: "json",
     	contentType: "application/json; charset=utf-8",
  	    success: function(response, textStatus, jqXHR){
  	    	clearLocalStorage();
  	    	window.location.href = '<%=request.getContextPath()%>/pages/dashboard.jsp?result=success';
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



// typehead
$(function (){
	$.ajax({
		url: "<%=request.getContextPath()%>/rest/s/grocery/lasttargets",
		type: "get",
     	success: function(data, textStatus, jqXHR){
     		$('#targetEmail').attr('data-source', jqXHR.responseText);     		
     	}
	});
    
});


</script>

<script type="text/template" id="grocerylist-template">

		<div>
			<div class="btn-group btn-group-vertical category_list_column" 
               style="float: left; margin-right: 5%; margin-bottom: 1%; margin-top: 1%; height: 450px; overflow-y: auto;">
			<@ _.each(categories, function(c) { @>
				  <button class="btn category_display_controler category_button" type="button" 
 					id="<@=id@>_<@=c.gid@>" onclick="selectCategory('<@=id@>_<@=c.gid@>')"> 
					<@= c.name @>
					<i id="itemsCountDiv<@=c.gid@>" style="display:none;">(<i id="itemsCount<@=c.gid@>"></i>)</i> 
				  </button> 
			<@ }); @>
			</div>
			<@ _.each(categories, function(c) { @>
				<input type='hidden' name='goodsGroups[<@=c.gid@>][name]' value='<@=c.name@>' id='goodsGroups<@=c.gid@>'/>
				<div style="display: none;" class="category_display_control items_in_category" id="list<@=id@>_<@=c.gid@>">
					<@ var indexGoods = 0; @>
					<table border='0' style="background-color: inherit;"> <tr> <td>
					<table border='0' id='table<@=c.gid@>' style="background-color: inherit;" class="table-hover"> 
					<@ _.each(c.items, function(i) { @>
						<tr> <td onclick="selectItem(<@=c.gid@>, <@=indexGoods@>, markItemAsSelected)"> <div  class="excluded_item" id="link<@=c.gid@>_<@=indexGoods@>">
						  <i class="icon-white" id="icon<@=c.gid@>_<@=indexGoods@>"></i> 
						  <@=i@> 
						</div> </td>
						<td> <input type='hidden' name='-goodsGroups[<@=c.gid@>][items][<@=indexGoods@>][name]' 
							class="<@=c.gid@>_<@=indexGoods@>" value='<@=i@>' id='item<@=c.gid@>_<@=indexGoods@>'/>
						 <input type='text'  placeholder='${itemComment}' name='-goodsGroups[<@=c.gid@>][items][<@=indexGoods@>][c]' 
							class="<@=c.gid@>_<@=indexGoods@>" value='' onblur='updateComment(<@=c.gid@>, <@=indexGoods@>)'
							id="comment_<@=c.gid@>_<@=indexGoods@>"/>
						 <input type="checkbox" style="display: none;"  id="ch<@=c.gid@>_<@=indexGoods@>"/> 
						</td> </tr>  
						<@ indexGoods++; @>
					<@ }) @>
					</table>
					</td> </tr> 
					<tr> <td>
					<div class="input-append" align="left">
					  <input type='text'  placeholder='${newItem}' maxlength="20" id='newGood<@=c.gid@>' spellcheck="true"/>
					  <button class="btn" type="button" onclick="addItem('<@=c.gid@>')"> ${addItem} </button> 
					</div>
					<input type='hidden' id='indexGoods<@=c.gid@>' value='<@=indexGoods@>'/> 
					</td> </tr> </table>
				</div>  
			<@ }); @>
		</div>
	
</script>

<script type="text/template" id="groceryitem-template">
	<tr> <td> <div onclick="selectItem(<@=indexGroup@>, <@=indexGoods@>, markItemAsSelected)" class="excluded_item" id="link<@=indexGroup@>_<@=indexGoods@>">
		<i class="icon-white" id="icon<@=indexGroup@>_<@=indexGoods@>"></i> 
		<@=item@> 
		</div> </td>
		<td> <input type='hidden' name='goodsGroups[<@=indexGroup@>][items][<@=indexGoods@>][name]' 
				class="<@=indexGroup@>_<@=indexGoods@>" value="<@=item@>" id='item<@=indexGroup@>_<@=indexGoods@>'/>
		<input type='text' placeholder='${itemComment}' name='goodsGroups[<@=indexGroup@>][items][<@=indexGoods@>][c]' 
				class="<@=indexGroup@>_<@=indexGoods@>" spellcheck="true"/>
		<input type="checkbox" style="display: none;"  id="ch<@=indexGroup@>_<@=indexGoods@>" /> 
     </td> </tr>  

</script>

<div class="row">
	<div class="span12" align="left" >
       	<button class="btn .btn-large" type="button" onclick="javascript: history.go(-1)"> 
       		<fmt:message key="general.back" /> 
       	</button>  
    	<fmt:message key="customtemplate.desc" />
    </div>
</div>

<div class="row" id="badMail" style="display: none;">
	<div class="span3"></div>
	<div class="span6 alert alert-error" align="center">
		<b> <fmt:message key="grocerylist.mailerror" /> </b>
	</div>
</div>


<form id="formToSend" class="span12" style="margin-top: 3%" action="POST">
  <div class="row">
	<input type="hidden" name="language" value="${language}"/>
	<div id="content" ></div>
  </div>
  <div class="row">
	
	<h4 id="resultId">  </h4>
  </div>
  <div class="row">	
	<div style="margin-top:4%;">
		<fmt:message key="grocerylist.email" />&nbsp;
		<input id="targetEmail" type="text" name="target" data-provide="typeahead" />
		<button class="btn btn-primary" style="display: none; vertical-align: top;"  id="sendButtonId" onclick="sendForm();return false;"> 
		    <fmt:message key="grocerylist.send" /> 
		</button>
	</div>
  </div>
</form>


<%@include file="../generalpages/footer.jsp" %> 