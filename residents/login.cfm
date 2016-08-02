<cfif isdefined('form.username') and isdefined('form.password')>

	<cfquery name="get" datasource="#datasource#">
		SELECT	c.timezone, r.r_id, c.c_id, r.R_PASSRESET
		FROM	residents r join communities c on r.c_id = c.c_id
		WHERE	r_username = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.username#" />
				AND r_password = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.password#" />
				<cfif isDefined('form.c_id')>AND c.c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#form.c_id#" /></cfif>
	</cfquery>
	
	<cfif get.RecordCount gt 0>	
		<cfset session.user_id = get.r_id>
		<cfset session.user_community = get.c_id>
		<cfset session.impersonatedby = 0>
		<cfset session.loginsucc = "passed">
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
			<cfif get.r_passReset><!--- Passwords that have been reset by an administrator must be updated --->
				<!--- <cflocation URL="index.cfm"> --->
				<div> Processing....</div>
				<script>
					parent.location='/residents/index.cfm';
				</script>
			<cfelse>
				<cflocation URL="passwordUpdate.cfm">
			</cfif>
		
			<h2>Processing...</h2>
			
			<cfquery name="getPropList" datasource="#datasource#">
				SELECT	h.* from homesite h join residents_homesite rh on h.h_id = rh.h_id
								join residents r on r.r_id = rh.r_id
				WHERE	 	r.r_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#get.r_id#" />
			</cfquery>

			<cfif getPropList.recordcount gt 1>
				<cflocation url="/residents/popup/chooseLocation.cfm" addtoken="no">
			</cfif>
	<cfelse>
		<h2>Login Failed</h2>
		Close this window and try again.
		<cfabort>		
	</cfif>
		
		<cfset session.loginsucc = "failed">
		<!--- 
		<h2>Login Failed.</h2>
		<br />Close this box to try again.</div> --->
		
		
		<cfabort>
		<cflocation URL="../index.cfm?err=invalidPW" addtoken="no">

	
<cfelseif isdefined('form.loggedfromstaff') AND form.loggedfromstaff IS "YES">
		<cfset session.user_id = form.r_id>
		<cfset session.user_community = form.c_id>
		<cfset session.impersonatedby = form.staff_id>
		<cfquery datasource="#datasource#" name="get">
			select timezone from communities
			where c_id = #form.c_id#
		</cfquery>
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
			<cfdefaultcase>
				<cfset session.timezoneadj = 0>
			</cfdefaultcase>
		</cfswitch>
		<cfset session.loginsucc = "passed">
	<h2>Login Success.</h2>
		<cflocation URL="/residents/index.cfm">
<cfelse>
	<cfset session.loginsucc = "failed">
	<h2>Login Failed.</h2>
		<br />Close this box to try again.</div>
		<cfabort>
	<cflocation URL="../index.cfm?err=LoginFailed" addtoken="no">
</cfif>
