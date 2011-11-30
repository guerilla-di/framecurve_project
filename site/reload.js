function reloadStylesheets() {
	var stylesheets = $('link[rel="stylesheet"]');
	var reloadQueryString = '?reload=' + new Date().getTime();
	stylesheets.each(function () {
		this.href = this.href.replace(/\?.*|$/, reloadQueryString);
	});
}
window.onload = function() {
setInterval(reloadStylesheets, 100);
}
