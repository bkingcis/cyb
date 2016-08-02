<cfcomponent displayname="Resident">
	<cffunction name="create">
		<cfargument name="id" required="Yes">
		<cfargument name="pagetitle" required="Yes">
		<cfargument name="pagetext" required="Yes">
		<cfquery name="updatePage" datasource="#request.dsn#">
			INSERT INTO	mainpages (id,pagetitle,pagetext)
			VALUES		( #arguments.id#, '#arguments.pagetitle#','#arguments.pagetext#' )
		</cfquery>
		<cfquery name="getNewRes" datasource="#request.dsn#">
			SELECT max(id) as newID from mainpages 
		</cfquery>
		<cfreturn getNewRes.newID />
	</cffunction>
	<cffunction name="read" returntype="query">
		<cfargument name="id" required="no" />
		<cfquery name="get" datasource="#request.dsn#">
			SELECT	*
			FROM	mainpages
			<cfif isDefined('arguments.id')>WHERE	id = #arguments.id#</cfif>
			order by id
		</cfquery>
		<cfreturn get />
	</cffunction>
	
	<cffunction name="update">
		<cfargument name="id" required="Yes">
		<cfargument name="pagetitle" required="Yes">
		<cfargument name="pagetext" required="Yes">
		
		<cfquery name="updatePage" datasource="#request.dsn#">
		UPDATE	mainpages
		SET		pagetitle = '#arguments.pagetitle#',
				pagetext = '#arguments.pagetext#'
		WHERE	id = #arguments.id#
		</cfquery>
		<cfreturn true />
	</cffunction>
	
	<cffunction name="delete">
		<cfargument name="id" required="Yes">
		<cfquery datasource="#request.dsn#">
			DELETE FROM mainpages
			WHERE id = #arguments.id#
		</cfquery>
		<cfreturn True />		
	</cffunction>	
</cfcomponent>