<%@include file="../generalpages/m-header.jsp" %> 

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
    	$('#templates').empty();
    	var index = -1;
    	// index -1 - means first row, 0 - means row inthe middle, 1 - means last 
    	var counter = 0;
    	this.collection.each(function(item){ // in case collection is not empty
    		var accordion_html = _.template($('#grocery-template').html());
    	
    		var h = $(accordion_html({id: item.get("type")+item.get("id"), name: item.get("name")}))
        	$('#templates').append( h );
        }, this);
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

// send grocery list
function send(id){
	window.location.href = '<%=request.getContextPath()%>/m/grocerylist.jsp?template='+id;
}

</script>

<script type="text/template" id="grocery-template">
<li data-theme="c" data-corners="false" data-shadow="false" data-iconshadow="true" data-wrapperels="div" 
data-icon="arrow-r" data-iconpos="right" class="ui-btn ui-btn-icon-right ui-li-has-arrow ui-li ui-btn-up-c">
<div class="ui-btn-inner ui-li ui-corner-top"><div class="ui-btn-text">
        <a href="#page1" data-transition="slide" class="ui-link-inherit" onclick="send('<@=id@>')">
            <@=name@>
        </a>
</div><span class="ui-icon ui-icon-arrow-r ui-icon-shadow">&nbsp;</span></div></li>
</script>

<div data-role="page" id="templates-page">
    <div data-role="content">
        <h2>
            <fmt:message key="m.templates.header" />
        </h2>
        <ul data-role="listview" data-divider-theme="b" data-inset="true" id="templates"
        	class="ui-listview ui-listview-inset ui-corner-all ui-shadow">
 
        </ul>
    </div>
</div>

 <%@include file="../generalpages/m-footer.jsp" %>   