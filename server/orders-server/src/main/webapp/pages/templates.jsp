<%@include file="../generalpages/header.jsp" %> 


<fmt:message key="templates.createGroceryList" var="createGroceryList" />
<fmt:message key="templates.scheduleGroceryList" var="scheduleGroceryList" />
<fmt:message key="templates.deleteGroceryForm" var="deleteGroceryForm" />


<script type="text/javascript">

var Entities = {};

Entities.Collection = Backbone.Collection.extend({
    url: "<%=request.getContextPath()%>/rest/s/templates/custom/${language}"
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
    		var accordion_html = _.template($('#accordion-template').html());
    	
    		var h = $(accordion_html({id: item.get("type")+item.get("id"), name: item.get("name"), categories: item.get("goodsGroups")}))
        	$('#content').append( h );
        }, this);
    	activateTooltip();
    }
 });
 
function load() {
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

$(load);

// manage categories visibility
function selectCategory(id) {
	$(".category_display_control").css("display", "none");
	$(".category_display_controler").removeClass("btn-success");
	$("#"+id).addClass("btn-success");
	$("#list"+id).css("display", "table");
}

// send grocery list
function send(id){
	window.location.href = '<%=request.getContextPath()%>/pages/grocerylist.jsp?template='+id;
}

//delete grocery from
function remove(id){
	$.ajax({
		url: "<%=request.getContextPath()%>/rest/s/templates/custom/"+id,
        type: "delete",
  	    success: function(response, textStatus, jqXHR){
  	    	load();
        },
        // callback handler that will be called on error
        error: function(jqXHR, textStatus, errorThrown){
        	alert(JSON.stringify(jqXHR))
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

<script type="text/template" id="accordion-template">
<div class="accordion-group">
	<div class="accordion-heading">
		<a class="accordion-toggle" data-toggle="collapse" data-parent="#content" href="#<@=id@>" style="width:20%;display:inline-block;">
			<@=name@> &nbsp;<i class="icon-circle-arrow-down icon-white" ></i>
		</a>
		
		<a onclick="send('<@=id@>')" class="accordion-toggle" style="display:inline-block;float:right;margin-right:1%;">
			<i class="icon-list-alt icon-white" ></i>
			${createGroceryList}
		</a>
		<@ if( id.charAt(0) == 'C' ) { @>
		  <a onclick="remove('<@=id@>')" class="accordion-toggle" style="display:inline-block;float:right;margin-right:1%;">
			<i class="icon-trash icon-white" ></i>
			${deleteGroceryForm}
		  </a>
		<@ } @>

	</div>
	<div id="<@=id@>" class="accordion-body collapse">
		<div class="accordion-inner">
			<div class="btn-group btn-group-vertical" 
				style="float: left; margin-right: 5%; margin-bottom: 1%; margin-top: 1%;height: 450px; overflow-y: auto;">
			<@ _.each(categories, function(c) { @>
				  <button class="btn category_display_controler category_button"
 					id="<@=id@><@=c.gid@>" onclick="selectCategory('<@=id@><@=c.gid@>')"> <@= c.name @> </button>  
			<@ }); @>
			</div>
			<div style="float: right;">
			  <button class="btn btn-primary"  onclick="send('<@=id@>')"> 
		        ${createGroceryList}
		      </button>
 			</div>
			<@ _.each(categories, function(c) { @>
				  <div style="display: none;" class="category_display_control items_in_category" id="list<@=id@><@=c.gid@>">
					<@ _.each(c.items, function(i) { @>
						<@= i @> <br/>
					<@ }) @>
				  </div>  
			<@ }); @>
		</div>
	</div>
</div>
</script>

<div class="row">

	<div class="span6" align="left" >
		
       	<button class="btn .btn-large" type="button" onclick="javascript:window.location='<%=request.getContextPath()%>/pages/custom-template.jsp'"> 
       		<fmt:message key="template.createOwn" />
       	</button>  
    
    	<fmt:message key="template.selectOne" />
    </div>
    <div class="span6"></div>
</div>

<!-- this elements is used for inserting code -->
<div class="row">
<div id="content" class="accordion span12" style="margin-top: 3%">
</div>
</div>

<%@include file="../generalpages/footer.jsp" %>