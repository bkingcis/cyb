<!--- NOT isUserInRole('communityadmin') OR --->

<cfif NOT isDefined("session.user_community")>
	<cfset session.message = "Your session has expired.  Please log in again.">
	<cflocation url="/admin/index.cfm" addtoken="false">
</cfif>