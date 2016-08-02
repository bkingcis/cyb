<cfquery name="logAccess" datasource="#datasource#">
	INSERT INTO  staffuselog (staffid,entrypointid,timestamp,action)
	VALUES (<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.staff_id#" />,
		<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.entrypointid#" />,
		<cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#dateAdd('h',session.timezoneadj,now())#" />,
		'logout')
</cfquery>

<cfset session.staff_id = 0>
<cfset session.loginsucc = 0>
<cfset session.staff_level = 0>
<cfset session.timezoneadj = 0>
<cfset session.user_community = 0>
<cfset session.entrypointid = 0>

<cflocation url="/login/?login_type=personnel" addtoken="false">
