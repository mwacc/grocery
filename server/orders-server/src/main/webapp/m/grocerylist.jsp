<%@include file="../generalpages/m-header.jsp" %> 

<script src="<%=request.getContextPath()%>/static/js/form2json.js" type="text/javascript"></script>


<fmt:message key="general.back" var="back"/>
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
    	$(".category_display_control").css("display", "none");
    	//activateTooltip();
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
		}
	});
	
}


$(loadGroceryListData);
$(applySerializationToJson)

//manage categories visibility
function selectCategory(id) {
	$(".category_display_control").css("display", "none");
	$(".categories").css("display", "none");
	$("#"+id).addClass("btn-success");
	$("#list"+id).css("display", "table");
}

function backToCategories(){
	$(".items_in_category").css("display", "none");
	$(".categories").css("display", "table");
}

itemsInBasket = 0;

function markItemAsSelected(groupId, itemId) {
	if( $('#ch'+groupId+"_"+itemId).is(':checked') ) {
		$('#ch'+groupId+"_"+itemId).attr('checked', false);
		$('#link'+groupId+"_"+itemId).css('color','black');
		$('.'+groupId+"_"+itemId).each( function (i) {
			$(this).attr('name', '-'+$(this).attr('name'));
		} );
		
		updateCounter(-1);
		updateCategoryCounter(groupId, -1);
	} else {
		$('#ch'+groupId+"_"+itemId).attr('checked', true);
		$('#link'+groupId+"_"+itemId).css("color","green");
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
	if( itemsInBasket > 0 ) {
		$("#sendButtonId").css('display','');
	} else {
		$("#sendButtonId").css('display','none');
	}
}

// TODO: must work w/ array of values, because there are several elements w/ the same class on view
function updateCategoryCounter(categoryId, incrementOn) {
	var elVal = 0;
	try {
		elVal = parseInt( $('.itemsCount'+categoryId)[0].text() );
		if( isNaN(elVal) ) elVal = 0;
	} catch(e){
		elVal = 0;
	}

	elVal = elVal + incrementOn; // increment or decrement
	for(var i in $('.itemsCountDiv'+categoryId)) {
		if( elVal > 0 ) {
			$('.itemsCountDiv'+categoryId)[i].show();
		}else{
			$('.itemsCountDiv'+categoryId)[i].hide();
		}
		
		$('.itemsCount'+categoryId)[i].text(elVal)
	}
}

</script>

<script type="text/template" id="grocerylist-template">

		<div>
			<div class="categories" 
               style="float: left; margin-right: 5%; margin-bottom: 1%; margin-top: 1%; height: 450px; overflow-y: auto;">
			<@ _.each(categories, function(c) { @>
				  <div id="<@=id@>_<@=c.gid@>" onclick="selectCategory('<@=id@>_<@=c.gid@>')"> 
					<@= c.name @>
					<i class="itemsCountDiv<@=c.gid@>" style="display:none;">(<i class="itemsCount<@=c.gid@>"></i>)</i> 
				  </div> 
			<@ }); @>
			</div>
			<@ _.each(categories, function(c) { @>
				<input type='hidden' name='goodsGroups[<@=c.gid@>][name]' value='<@=c.name@>' id='goodsGroups<@=c.gid@>'/>
				<div style="display: none;" class="category_display_control items_in_category" id="list<@=id@>_<@=c.gid@>">
					<h3><@= c.name @> <i class="itemsCountDiv<@=c.gid@>" style="display:none;">(<i id="itemsCount<@=c.gid@>"></i>)</i> </h3>
					<h4 onclick="backToCategories()">${back}</h4>	
	
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
							class="<@=c.gid@>_<@=indexGoods@>" value=''/>
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
	<tr> <td> <div onclick="selectItem(<@=indexGroup@>, <@=indexGoods@>, markItemAsSelected)" class="included_item" id="link<@=indexGroup@>_<@=indexGoods@>">
		<i style="color: black;" id="icon<@=indexGroup@>_<@=indexGoods@>"></i> 
		<@=item@> 
		</div> </td>
		<td> <input type='hidden' name='goodsGroups[<@=indexGroup@>][items][<@=indexGoods@>][name]' 
				class="<@=indexGroup@>_<@=indexGoods@>" value="<@=item@>" id='item<@=indexGroup@>_<@=indexGoods@>'/>
		<input type='text' placeholder='${itemComment}' name='goodsGroups[<@=indexGroup@>][items][<@=indexGoods@>][c]' 
				class="<@=indexGroup@>_<@=indexGoods@>" spellcheck="true"/>
		<input type="checkbox" style="display: none;"  id="ch<@=indexGroup@>_<@=indexGoods@>" /> 
     </td> </tr>  

</script>

<div data-role="page" id="grocerylist-page">
   <div id="content">
   </div> 
    
</div>

<%@include file="../generalpages/m-footer.jsp" %>    