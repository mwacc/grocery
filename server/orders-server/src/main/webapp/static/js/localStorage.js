// this file contains functionality that provide base operation on grocery list relate to HTML5 local storage

function activateReviewItems() {
   	try {
   		if(typeof(Storage)!=="undefined" && typeof(TINY)!=="undefined") { 
   			if( sessionStorage.grocerylistdepictured == 'yes' ) { 
   				
   			} else if( typeof sessionStorage.grocerylist != "undefined" && sessionStorage.grocerylist != "" ) {
				var containerWidth = parseInt( getStyle('containerId','width') );
				var review = _.template($('#grocerylist-review').html(), {});
				TINY.box.show({html:review,animate:false,close:false,mask:false,
					boxid:'success',top:150,
					left:(window.screen.width-containerWidth)/2 + containerWidth - containerWidth/4})
				
				setTimeout( function(){
   					showGroceryListPreview( JSON.parse( sessionStorage.grocerylist ) ) },
   				800); 
				sessionStorage.grocerylistdepictured = 'yes'
   			}
   		} 
	}catch(e){alert('activateReviewItems '+e)} 
}

function addItemToReviewList(categoryid, itemid, category, item, comment) {
	try {
   		if(typeof(Storage)!=="undefined") {
   			var line = new Object();
   			line.category = category;
   			line.item = item;
   			line.itemid = itemid;

   			var storage = new Object();
   			if( typeof sessionStorage.grocerylist != "undefined" &&
   					sessionStorage.grocerylist != "" ) {
   				storage = JSON.parse( sessionStorage.grocerylist );
   			} 
   			if( typeof storage[categoryid] == "undefined" ) {
   				storage[categoryid] = new Array(); 
   			}
   			storage[categoryid].push(line);
   			
   			showGroceryListPreview(storage);
   			sessionStorage.grocerylist = JSON.stringify(storage)
   		}
   		
	} catch(e){alert('addItemToReviewList: '+e)} 
	
	activateReviewItems();
}

function removeItemFromReviewList(categoryid, itemid) {
	try {
   		if(typeof(Storage)!=="undefined" && typeof sessionStorage.grocerylist != "undefined") {
   			var storage = JSON.parse( sessionStorage.grocerylist );	
   			var items = storage[categoryid];
   			for(var i in items) {
   				if( items[i].itemid == itemid ) {
   					items.splice(i,1);
   					break;
   				}
   			}
   			showGroceryListPreview(storage);
   			sessionStorage.grocerylist = JSON.stringify(storage)
   		}
	} catch(e){alert('removeItemFromReviewList:'+e)}
}

function showGroceryListPreview(storage) {
	$('#review-grocerylist-id').empty();
	
	Object.keys(storage).forEach(function(key) {
		    var categoryItems = storage[key];
		    if(categoryItems[0]) {
			  var newItem_html = _.template($('#grocerylist-review-item').html());
			  var h = $(newItem_html({categoryName: categoryItems[0].category, items: categoryItems}));
			  $('#review-grocerylist-id').append(h);
		    }
		}); 
}
   	
// load data from local session storage
function loadDataFromLocalStorage(callbackMarkItemAsSelected){
	try {
		if(typeof(Storage)!=="undefined" && 
				typeof sessionStorage.grocerylist != "undefined" &&
				sessionStorage.grocerylist != "") {
			var storage = JSON.parse( sessionStorage.grocerylist );	
			
			Object.keys(storage).forEach(function(key) {
			    var categoryItems = storage[key];
			    if(categoryItems[0]) {
			    	for(var i in categoryItems) {
			    		callbackMarkItemAsSelected(key, categoryItems[i].itemid)
			    		if(typeof categoryItems[i].comment != "undefined") {
			    			$("#comment_"+key+"_"+categoryItems[i].itemid).val(categoryItems[i].comment)
			    		}
			    	}
			    }
			}); 
		}
	}catch(e){alert("loadDataFromLocalStorage: "+e)}
}

//manage item status
function selectItem(groupId, itemId, viewCallback) {
	viewCallback(groupId, itemId);

	if( $('#ch'+groupId+"_"+itemId).is(':checked') ) {
		addItemToReviewList(groupId, itemId, $('#goodsGroups'+groupId).val(), $('#item'+groupId+'_'+itemId).val(), '');
	} else {
		removeItemFromReviewList(groupId, itemId);
	}
}

function clearLocalStorage(){
	if(typeof(Storage)!=="undefined" && typeof sessionStorage.grocerylist != "undefined") {
		sessionStorage.grocerylist = ''
		sessionStorage.grocerylistdepictured = 'no'
	}
}

function updateComment(groupId, itemId) {
	var comment = $("#comment_"+groupId+"_"+itemId).val()
	try {
   		if(typeof(Storage)!=="undefined" && 
   				typeof sessionStorage.grocerylist != "undefined" &&
   				sessionStorage.grocerylist != "" ) {
   			var storage = JSON.parse( sessionStorage.grocerylist );	
   			var items = storage[groupId];
   			for(var i in items) {
   				if( items[i].itemid == itemId ) {
   					items[i].comment = comment;
   					break;
   				}
   			}
   			showGroceryListPreview(storage);
   			sessionStorage.grocerylist = JSON.stringify(storage)
   		}
	} catch(e){alert('updateComment:'+e)}
	
}

