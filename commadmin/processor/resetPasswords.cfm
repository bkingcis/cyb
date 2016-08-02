<cfset residentObj = application.residentObj>
<cfset passResetList = ListDeleteAt(form.passResetList, ListFind(form.passResetList, 0))>
<cfloop list="#passResetList#" index="res">
	<cfset result = residentObj.resetPass(res)>
</cfloop>		
<cfif ListLen(passResetList) eq 1>
	<cfset session.message = "Password has been updated and sent to the resident email address.">
<cfelse>
	<cfset session.message = ListLen(passResetList) & " Passwords have been updated and sent to the resident email addresses.">
</cfif>	

<cflocation url="../index.cfm##tabs-1" addtoken="no">