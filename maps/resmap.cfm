<cfscript>
	request.GoogleMapKey = "ABQIAAAAUbrmcJQyJL_-VA4154qdcRQYdTd-AQ-D6m3UAMK7V8HXzHN_RRTqXGj8ESlrgxNg-eG_3_7bJwbZUA";
</cfscript>
<cftry>
<cfquery name="GetResident" datasource="#datasource#">
	select residents.r_fname,residents.r_lname,homesite.h_id,communities.c_name,
	homesite.h_address, homesite.h_city, homesite.h_state, homesite.h_zipcode 
	FROM residents 
		INNER JOIN homesite ON residents.h_id = homesite.h_id
		INNER JOIN communities on communities.c_id = homesite.c_id
	WHERE homesite.h_id = #url.res#
</cfquery>

<!--- <cfoutput query="GetResident"> --->
<cfset address = URLEncodedFormat(GetResident.h_address) & ", " & URLEncodedFormat(GetResident.h_city) & ", " & URLEncodedFormat(GetResident.h_state) & "%20" & GetResident.h_zipcode>
<!--- </cfoutput> --->
<cfimport taglib="../tags" prefix="gm">
<CFHTTP method="Get" URL="http://rpc.geocoder.us/service/rest/geocode?address=#address#"></CFHTTP>
		
<CFMODULE TEMPLATE="FindValue.cfm"
          VariableName=":long>"
          String="#CFHTTP.FILECONTENT#"
          DataEndIndicator="<"
          StartPosition="1">
<cfset longval = FindValueData>
<CFMODULE TEMPLATE="FindValue.cfm"
          VariableName=":lat>"
          String="#CFHTTP.FILECONTENT#"
          DataEndIndicator="<"
          StartPosition="1">
<cfset latval = FindValueData>

		  
<!--- <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <title>Google Maps JavaScript API Example</title>
    <script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAAmSCgx9YGNyZilq3ALpjH0hRS2baC34ODbs7BpYdkTqhPW6Mn_hSu8wyohELjpNmzrG-u8m3cVwB1Bg"
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
  <body onload="LoadMap()"> --->
  <cfinclude template="../header_maps.cfm">
    <div align="center" style="font-size:1.2em;">Resident Address: <br />
	<strong><cfoutput>#URLDecode(address)#</cfoutput></strong><br /><br />
	<span style="font-size:0.85em;">* click on address location to get driving directions</span><br />
   <gm:googlemap width="600" height="380" key="#request.GoogleMapKey#" maptype="map" fitPointsToMap="true">
          <gm:googlemapicon iconurl="/img/pro_thumb.png" iconname="prologo" width="41" height="40">
			<cfset qmap="#address#">
       	  <!--- let's get rid of any spaces first --->
       	 <cfset qmap = replace(qmap, chr(32), "+", "ALL")>
       	 <cfset qmap = replace(qmap, "%20", " ", "ALL")>
          <gm:googlemappoint title="#replace(GetResident.c_name,"'","","all")#" address="#URLDecode(address)#" lon="#longval#" lat="#latval#">       
      </gm:googlemap>
      <gm:googlemapshow>
<cfcatch>
<h2>Sorry!  No map available.</h2><p>This may be an invalid address</p><br /><br /><br /><br />
 
</cfcatch>
</cftry>

	</div>
<cfinclude template="/footer2.cfm">