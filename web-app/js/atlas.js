$(function(){
	// Sticky footer
	var footerHeight = $(".site-footer").outerHeight();
	$(".wrap").css("margin-bottom", -footerHeight);
	$(".push").height(footerHeight);
	
	// Tabs
	var hash = window.location.hash;
	hash && $(".taxon-tabs a[href=" + hash + "]").tab("show");
	$(".taxon-tabs a").click(function (e) {
		window.location.hash = this.hash;
	});
	
	// Links to tabs
	$(".tab-link").click(function (e) {
		e.preventDefault();
		window.location.hash = this.hash;
		var tabID = $(this).attr("href");
		$(".taxon-tabs a[href=" + tabID + "]").tab("show");
	})

	// Lightbox
	$(document).delegate('*[data-toggle="lightbox"]', 'click', function(event) { 
		event.preventDefault(); 
		$(this).ekkoLightbox(); 
	});

	// Tooltips
	$("[data-toggle='tooltip']").tooltip();

	// Search: Refine results accordions
	$(".refine-box h2 a").click(function() {
		$(this).children(".glyphicon").toggleClass("glyphicon-chevron-down glyphicon-chevron-up");
	});
	$("a.expand-options").click(function() {
		$(this).text(function(i, text){
			return text === "More" ? "Less" : "More";
		})
		$(this).prev(".collapse").collapse("toggle");
	});
});