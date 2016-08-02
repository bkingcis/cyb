<cftry>
	<cfloop collection="#form#" item="fieldname">
		<cfif structKeyExists(session.signup,fieldname)>
			<cfset temp = structUpdate(session.signup,fieldname,form[fieldname])>
		<cfelse>
			<cfset temp = structInsert(session.signup,fieldname,form[fieldname])>
		</cfif>
	</cfloop>
	<cfcatch>
	<cfdump var="#cfcatch#"></cfcatch>
</cftry>