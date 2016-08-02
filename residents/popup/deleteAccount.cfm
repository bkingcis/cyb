<cftry><cfsilent>
<!--- This is just for user verification --->
<cfquery datasource="#request.dsn#" name="qMasterUser" >
	select h_id,c_id from residents where
	r_id = <cfqueryparam value="#val(session.user_id)#" cfsqltype="CF_SQL_INTEGER">
</cfquery>
<cfquery datasource="#request.dsn#">
	update residents set active = 0
	where r_id = <cfqueryparam value="#val(r_id)#" cfsqltype="CF_SQL_INTEGER">
	and h_id = <cfqueryparam value="#val(qMasterUser.h_id)#" cfsqltype="CF_SQL_INTEGER">
	and c_id = <cfqueryparam value="#val(qMasterUser.c_id)#" cfsqltype="CF_SQL_INTEGER">
</cfquery>
</cfsilent>Account removed.
<cfcatch>Could not remove account.</cfcatch>
</cftry>