<%--
  ADOBE CONFIDENTIAL

  Copyright 2013 Adobe Systems Incorporated
  All Rights Reserved.

  NOTICE:  All information contained herein is, and remains
  the property of Adobe Systems Incorporated and its suppliers,
  if any.  The intellectual and technical concepts contained
  herein are proprietary to Adobe Systems Incorporated and its
  suppliers and may be covered by U.S. and Foreign Patents,
  patents in process, and are protected by trade secret or copyright law.
  Dissemination of this information or reproduction of this material
  is strictly forbidden unless prior written permission is obtained
  from Adobe Systems Incorporated.
--%><%@page import="com.day.cq.dam.api.Asset,
      com.day.cq.wcm.webservicesupport.Configuration,
	  com.day.cq.wcm.webservicesupport.ConfigurationManager,
      org.apache.sling.api.resource.ResourceResolver"
%><%@include file="/libs/foundation/global.jsp"%><%
%><cq:includeClientLib categories="cq.gui.map"/><%
%><%@page session="false" %><%

    String[] services = pageProperties.getInherited("cq:cloudserviceconfigs", new String[]{});
	ConfigurationManager cfgMgr = (ConfigurationManager)sling.getService(ConfigurationManager.class);
    String apiKey = null;
	if(cfgMgr != null) {
	    Configuration cfg = cfgMgr.getConfiguration("googlemaps", services);
	    if(cfg != null) {
    	    apiKey = cfg.get("apiKey", null);
        }
    }

    String path = request.getParameter("item");
	ResourceResolver resolver = slingRequest.getResourceResolver();
	Resource res = resolver.getResource(path);

/*
    Asset asset = res.adaptTo(Asset.class);
	Object lat = asset != null ? asset.getMetadata("dam:GPSLatitude") : null;
	String latRef = asset != null ? asset.getMetadataValue("dam:GPSLatitudeRef") : null;
	Object lon = asset != null ? asset.getMetadata("dam:GPSLongitude") : null;
	String lonRef = asset != null ? asset.getMetadataValue("dam:GPSLongitudeRef") : null;
*/

	// Alt route
	Resource md = res.getChild("jcr:content/metadata");
	ValueMap props = md.adaptTo(ValueMap.class);
	Double[] lats = (Double[]) props.get("dam:GPSLatitude");
	double lat = lats[0] + lats[1] / 60 + lats[2] / 3600;
	Object latRef = props.get("dam:GPSLatitudeRef");
	if ("S".equals(latRef)) lat = -lat;
	Double[] lons = (Double[]) props.get("dam:GPSLongitude");
	double lon = lons[0] + lons[1] / 60 + lons[2] / 3600;
	Object lonRef = props.get("dam:GPSLongitudeRef");
	if ("W".equals(lonRef)) lon = -lon;

%>
<script type="text/javascript">
function initializeGoogleMap() {
    var center = new google.maps.LatLng(<%= lat %>, <%= lon %>);

    var mapOptions = {
        zoom: 18,
        center: center,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    }
    var map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
	var marker = new google.maps.Marker({
    	position: center,
      	map: map
  	});    
}

(function(document, $) {
    "use strict";

    $(document).on("foundation-contentloaded", function(e) {

	   if (typeof google != 'undefined' && typeof google.maps != 'undefined') { return initializeGoogleMap(); }

      console.info("Loading Google Maps APIs");

      var script = document.createElement("script");
      script.type = "text/javascript";
      script.src = "http://maps.googleapis.com/maps/api/js?key=<%= apiKey %>&sensor=false&callback=initializeGoogleMap";
      document.body.appendChild(script);
    });


})(document, Granite.$);    
</script>
<div id="map-canvas" style="width: 100%; height: 100%; border: 1px solid black"></div>    
