<cfif NOT isUserInRole('master')>
	<cfset session.message = "Your session has expired.  Please log in again.">
	<cflocation url="index.cfm">
</cfif>