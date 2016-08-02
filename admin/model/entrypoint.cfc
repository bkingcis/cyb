<cfcomponent displayname="comunity">
	<cffunction name="create" returntype="numeric">
		<cfquery datasource="#request.dsn#" name="EPAdd">
			INSERT INTO	communityentrypoints (c_id,label)
			values (#arguments.c_id#,'#arguments.label#')
		</cfquery>
		
		<cfquery name="newid" datasource="#request.dsn#">
			select max(entrypointid) as entrypointid from communityentrypoints
		</cfquery>
		
		<cfreturn newid.entrypointid />
	</cffunction>
	<cffunction name="read" returntype="query">
		<cfargument name="c_id" required="yes" />
		<cfquery name="qEntrypoints" datasource="#request.DSN#">
			SELECT 	entrypointid, label 
			FROM 	communityentrypoints 
				WHERE 	c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.c_id#" />
			order by label
		</cfquery>
		<cfreturn qEntrypoints />
	</cffunction>
	<cffunction name="delete" returntype="boolean">
		<cfargument name="entrypointid" required="Yes" />
		<cfquery datasource="#request.dsn#" name="delEP">
			DELETE FROM	communityentrypoints
			WHERE	entrypointid = #arguments.entrypointid#
		</cfquery>
		<cfreturn true />
	</cffunction>
</cfcomponent>