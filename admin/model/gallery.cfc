<cfcomponent displayname="gallery">
	<cffunction name="create" returntype="numeric">
		<cfargument name="c_id" required="yes" />
		<cfargument name="caption" required="yes" />
		<cfargument name="filename" required="yes" />
		<cfquery datasource="#request.dsn#" name="EPAdd">
			INSERT INTO	communitygallery (c_id,caption,filename)
			values (#arguments.c_id#,'#arguments.caption#','#arguments.filename#')
		</cfquery>
		
		<cfquery name="newid" datasource="#request.dsn#">
			select max(galleryitemid) as galleryitemid from communitygallery
		</cfquery>
		
		<cfreturn newid.galleryitemid />
	</cffunction>
	<cffunction name="read" returntype="query">
		<cfargument name="c_id" required="yes" />
		<cfquery name="qgallery" datasource="#request.DSN#">
			SELECT 	galleryitemid, label, caption, filename
			FROM 	communitygallery 
				WHERE 	c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.c_id#" />
		</cfquery>
		<cfreturn qgallery />
	</cffunction>
	<cffunction name="delete" returntype="boolean">
		<cfargument name="galleryitemid" required="Yes" />
		<cfquery datasource="#request.dsn#" name="delEP">
			DELETE FROM	communitygallery
			WHERE	galleryitemid = #arguments.galleryitemid#
		</cfquery>
		<cfreturn true />
	</cffunction>
</cfcomponent>