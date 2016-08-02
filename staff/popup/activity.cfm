<cfif NOT isDefined('SESSION.user_community')>
	<cflocation url="/staff" addtoken="No">
</cfif>

<cftry>
	<cfinclude template="header.cfm"><div id="popUpContainer">
	<cfmodule template="/staff/include/search_results_present.cfm" >
  </div>
  <cfcatch><cfdump var="#cfcatch#"></cfcatch>
</cftry>