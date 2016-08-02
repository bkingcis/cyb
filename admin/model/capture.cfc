<cfcomponent displayname="capture">
	<cffunction name="create">
		<cfargument name="c_id" required="Yes">
		<cfargument name="c_cname" required="Yes">
		<cfargument name="date1" required="Yes">
		<cfargument name="date2" required="Yes">
		<!--- <cfargument name="captureinterval" required="Yes"> --->
		<cfsavecontent variable="cyhData">
		<cfset date1 = arguments.date1>
		<cfset date2 = arguments.date2>
		<cfinclude template="../../capture/createJson.cfm">
		</cfsavecontent>
		<cfset newfilename="#arguments.c_cname##dateFormat(now(),'yyyymmdd')#.cyh">
		<cffile action="WRITE" output="#cyhData#" file="#expandPath('\capture\archive\')##newfilename#" >
		<cfquery name="updateAcct" datasource="#request.dsn#">
			INSERT INTO	dataCaptureLog (c_id,captureFile,fromdate,todate)
			VALUES (#arguments.c_id#,'#newfilename#',<cfqueryparam value="#arguments.date1#" cfsqltype="CF_SQL_DATE">,<cfqueryparam value="#arguments.date2#" cfsqltype="CF_SQL_DATE">)
		</cfquery>
		<cfreturn true />
	</cffunction>
	<cffunction name="getLastDate" returntype="string">
		<cfargument name="c_id" required="Yes" />
		<cfquery name="get" datasource="#request.dsn#">
			SELECT	insertdate 
			FROM	dataCaptureLog
			WHERE	c_id = #arguments.c_id#
			ORDER BY	insertdate desc 
			LIMIT 1
		</cfquery>
		<cfreturn get.insertdate />
	</cffunction>
	<cffunction name="read" returntype="query">
		<cfargument name="c_id" required="Yes" />
		<cfquery name="get" datasource="#request.dsn#">
			SELECT	*
			FROM	dataCaptureLog
			WHERE	c_id = #arguments.c_id#
			ORDER BY	insertdate desc 
		</cfquery>
		<cfreturn get />
	</cffunction>
</cfcomponent>
