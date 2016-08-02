<cfcomponent displayname="download">
	<cffunction name="create" returntype="numeric">
		<cfargument name="c_id" required="yes" />
		<cfargument name="label" required="yes" />
		<cfargument name="filename" required="yes" />
		<cfquery datasource="#request.dsn#" name="EPAdd">
			INSERT INTO	communitydownload (c_id,label,filename)
			values (#arguments.c_id#,'#arguments.label#','#arguments.filename#')
		</cfquery>
		<cfquery name="newid" datasource="#request.dsn#">
			select max(downloadid) as downloadid from communitydownload
		</cfquery>		
		<cfreturn newid.downloadid />
	</cffunction>
	<cffunction name="read" returntype="query">
		<cfargument name="c_id" required="yes" />
		<cfquery name="qEntrypoints" datasource="#request.DSN#">
			SELECT 	downloadid, label, filename
			FROM 	communitydownload 
				WHERE 	c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.c_id#" />
			order by label
		</cfquery>
		<cfreturn qEntrypoints />
	</cffunction>
	<cffunction name="delete" returntype="boolean">
		<cfargument name="downloadid" required="Yes" />
		<cfquery datasource="#request.dsn#" name="delEP">
			DELETE FROM	communitydownload
			WHERE	downloadid = #arguments.downloadid#
		</cfquery>
		<cfreturn true />
	</cffunction>
	
	<cffunction name="fileUpload" returntype="boolean">
		
		<cfreturn true />
	</cffunction>
	
</cfcomponent>