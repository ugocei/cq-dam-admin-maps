(function(document, $) {
    "use strict";

$(document).on("foundation-contentloaded", function(e) {

  var originalHref = $('.damadmin-detail-viewon-select').data('assetpath');
    if (originalHref){
        $('.viewon .foundation-damadmin-detail-original').attr('href', Granite.HTTP.externalize(originalHref));
    }

	var href = $('.viewon .foundation-damadmin-detail-property-activator').attr('href');
    if (href){
		$('.viewon .foundation-damadmin-detail-property-activator').attr('data-href', href);
        $('.viewon .foundation-damadmin-detail-property-activator').removeAttr('href');
    }

	href = $('.viewon .foundation-damadmin-detail-map-activator').attr('href');
    if (href){
		$('.viewon .foundation-damadmin-detail-map-activator').attr('data-href', href);
        $('.viewon .foundation-damadmin-detail-map-activator').removeAttr('href');
    }

});


})(document, Granite.$);