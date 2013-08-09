(function (document, $) {
    "use strict";

    $(document).fipo("tap.foundation-damadmin-detail-map-activator", "click.foundation-damadmin-detail-map-activator", ".foundation-damadmin-detail-map-activator", function (e) {
        var activator = $(this);

        var suffix = "";
        if (window.location.pathname.indexOf(".html") > 0) {
            suffix = window.location.pathname.substring(window.location.pathname.indexOf(".html") + 5);
        }

        var url = activator.data("href") + "?item=" + suffix;

        var contentAPI = activator.closest(".foundation-content").adaptTo("foundation-content");
        var pageTitle = activator.data('pageheading');
        url = Granite.HTTP.externalize (url + "&_charset_=utf-8");
        var pageTitle = activator.data("pageheading");
		var assetPath = Granite.HTTP.externalize(activator.data("contextpath") + decodeURI(suffix));
		contentAPI.go(url,false, {
			title: pageTitle,
			url: encodeURI(assetPath)
		});
    });

})(document, Granite.$);