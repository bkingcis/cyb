<!--- ABQIAAAAmSCgx9YGNyZilq3ALpjH0hRS2baC34ODbs7BpYdkTqhPW6Mn_hSu8wyohELjpNmzrG-u8m3cVwB1Bg

http://maps.cybatrol.com/



<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <title>Google Maps JavaScript API Example</title>
    <script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAAmSCgx9YGNyZilq3ALpjH0hRS2baC34ODbs7BpYdkTqhPW6Mn_hSu8wyohELjpNmzrG-u8m3cVwB1Bg"
      type="text/javascript"></script>
    <script type="text/javascript">

    //<![CDATA[

    function load() {
      if (GBrowserIsCompatible()) {
        var map = new GMap2(document.getElementById("map"));
        map.setCenter(new GLatLng(37.4419, -122.1419), 13);
      }
    }

    //]]>
    </script>
  </head>
  <body onload="load()" onunload="GUnload()">
    <div id="map" style="width: 500px; height: 300px"></div>
  </body>
</html> --->

<CFHTTP method="Get"
        URL="http://rpc.geocoder.us/service/rest/geocode?address=7906%20Kennedy%20Lane,%20Sarassota,%20FL%2034240"></CFHTTP>

		
<CFMODULE TEMPLATE="FindValue.cfm"
          VariableName=":long>"
          String="#CFHTTP.FILECONTENT#"
          DataEndIndicator="<"
          StartPosition="1">
<cfset #longval# = "#FindValueData#">
<CFMODULE TEMPLATE="FindValue.cfm"
          VariableName=":lat>"
          String="#CFHTTP.FILECONTENT#"
          DataEndIndicator="<"
          StartPosition="1">
<cfset #latval# = "#FindValueData#">
		  
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <title>Google Maps JavaScript API Example</title>
    <script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAAmSCgx9YGNyZilq3ALpjH0hQB-6ruTG2is-PrqUCbt97_hTTHcRRhV7Hq-U1zhi0-QGVLu2ge3uMz1Q"
      type="text/javascript"></script>
<script type="text/javascript">
    //<![CDATA[
    function LoadMap()
   	{
	var map = new GMap(document.getElementById("map"));
	map.addControl(new GSmallMapControl());
	map.addControl(new GMapTypeControl());
	map.centerAndZoom(new GPoint(<cfoutput>#longval#,#latval#</cfoutput>), 2);
	var point = new GPoint(<cfoutput>#longval#,#latval#</cfoutput>);
	var marker = new GMarker(point);
	map.addOverlay(marker);
	}
    //]]>
</script>
  </head>
  <body onload="LoadMap()">
    <div id="map" style="width: 500px; height: 300px"></div>
  </body>
</html>

<!--- http://rpc.geocoder.us/service/rest/geocode?address=7906%20Kennedy%20Lane,%20Sarassota,%20FL%2034240 --->