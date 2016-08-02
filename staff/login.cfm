<cftry>
<cfif isdefined('form.username') and isdefined('form.password')>
	<cfset session.entrypointid = 0>
	<cfset session.staff_id = 0>

	<cfquery name="get" datasource="#request.dsn#">
		SELECT	staff_id, c.c_id, staff_username, staff_password, staff_level, timezone, S_PASSRESET
		FROM	staff s join communities c on s.c_id = c.c_id
			 WHERE	staff_username = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.username#" />
				AND staff_password = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.password#" />
				and c.c_active = <cfqueryparam cfsqltype="CF_SQL_BIT" value="1" />
			<!---AND c.c_id = #form.c_id# --->
	</cfquery>
	
	<cfif get.RecordCount gt 0>
		<cfset session.staff_id = get.staff_id>
		<cfset session.user_community = get.c_id>	
		<cfset session.staff_level = get.staff_level>	
		<cfset session.loginsucc = "passed">
		<cfset session.logintime = now()>
		<cfswitch expression="#get.timezone#">
			<cfcase value="Hawaii">
				<cfset session.timezoneadj = -6>
			</cfcase>
			<cfcase value="Alaska">
				<cfset session.timezoneadj = -4>
			</cfcase>
			<cfcase value="Pacific">
				<cfset session.timezoneadj = -3>
			</cfcase>
			<cfcase value="Mountain">
				<cfset session.timezoneadj = -2>
			</cfcase>
			<cfcase value="Central">
				<cfset session.timezoneadj = -1>
			</cfcase>
			<cfcase value="Eastern">
				<cfset session.timezoneadj = 0>
			</cfcase>
			<cfcase value="EasternPlus3">
				<cfset session.timezoneadj = 3>
			</cfcase>
			<cfdefaultcase>
				<cfset session.timezoneadj = 0>
			</cfdefaultcase>
		</cfswitch>
		<cfif val(get.s_passReset)><!--- Passwords that have been reset by an administrator must be updated --->
			<cflocation URL="/staff/">
		<cfelse>
			<cflocation URL="passwordUpdate.cfm">
		</cfif>		
	<cfelse>
	
		<div style="text-align: center;"><br>
		Login Failed.<br />
		<br />Close this box to try again.</div>
		
	</cfif>
<cfelse>
	<cfset session.loginsucc = "failed">
	<h2>Login Failed.  Please close this dialog and try again</h2>
</cfif>
<cfcatch>
	<cfdump var="#cfcatch#">
</cfcatch>
</cftry>
