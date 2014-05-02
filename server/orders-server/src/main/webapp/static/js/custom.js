function isBlank(str) {
	return !str || /^\s*$/.test( str );
}

function insertHtmlAsStack(id, h, first) {
	if(first) {
		$(id).prepend( h );
	} else {
		$(h).insertBefore(id+' > div:last');
	}
}

function incrementCounter(val) {
	var i = parseInt(val);
	return ++i;
}

function getStyle(ID, styleProp) {
    var el = document.getElementById(ID);
    var result = 'unknown';
    if(el.currentStyle) {
        result = el.currentStyle[styleProp];
    } else if (window.getComputedStyle) {
        result = document.defaultView.getComputedStyle(el,null).getPropertyValue(styleProp);
    } 
    return result;
}