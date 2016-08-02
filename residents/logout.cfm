<cftry>
<cfset temp = structClear(session)>
<cflocation url="/login/?login_type=resident" addToken="no">
<cfcatch><cfdump var="#cfcatch#"></cfcatch>
</cftry>