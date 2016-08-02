<cfinclude template="../config.cfm">
<cfapplication	name="cybatrolstaff"
	sessionmanagement="Yes"
	sessiontimeout="#CreateTimeSpan(0,0,100,0)#">
<cftry>	
<cfparam name="session.TIMEZONEADJ" default="0">
<cfscript>
   application.respref = '';
   application.respath = '';
   application.absroot = '';
   request.timezoneadjustednow  = dateAdd('h',session.timezoneadj,now());
</cfscript>
<cfif NOT structKeyExists(form,'username')>
	<cfif NOT isDefined('session.staff_id') or NOT val(session.staff_id)><h2>You have not logged in or your credentials were invalid.</h2>
	<cflocation url='/login/?login_type=Personnel' addtoken="false">	<!--- <cfabort> --->
	</cfif>
	<cfif isDefined('form.entrypointid')>
		<cfset session.entrypointid = form.entrypointid>
		<cfquery name="logAccess" datasource="#datasource#">
			INSERT INTO  staffuselog (staffid,entrypointid,timestamp,action)
			VALUES (<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.staff_id#" />,
				<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.entrypointid#" />,
				<cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#dateAdd('h',session.timezoneadj,now())#" />,
				'login')
		</cfquery>
	<cfelseif NOT isDefined('session.entrypointid') OR NOT val(session.entrypointid)>
		<cfquery datasource="#datasource#" name="qEntryPoints">
			select * from communityentrypoints where
			c_id = <cfqueryparam value="#session.user_community#" cfsqltype="CF_SQL_INTEGER" />
		</cfquery>		
		<cfinclude template="popup/choose_enttypoint.cfm"><cfabort>
	</cfif>
</cfif>

<cfcatch>
	<cfdump var="#cfcatch#">
</cfcatch>
</cftry>