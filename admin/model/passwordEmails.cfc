<cfcomponent>
	<cffunction name="GetEmailMessageByType" access="public" returntype="query">
		<cfargument name="type" required="yes">
		
		<cfquery name="get" datasource="#request.dsn#">
		SELECT	emailText
		FROM	emailMessageText
		WHERE	type = <cfqueryparam value="#arguments.type#" cfsqltype="CF_SQL_VARCHAR">
		</cfquery>
		
		<cfreturn get />
	</cffunction>
	<cffunction name="Update" access="public" returntype="boolean">
		<cfargument name="type" required="yes">
		<cfargument name="emailText" required="yes">
		
		<cfquery name="get" datasource="#request.dsn#">
		select * from emailMessageText
		WHERE	type = <cfqueryparam value="#arguments.type#" cfsqltype="CF_SQL_VARCHAR">
		</cfquery>
		<cfif get.recordcount>
		<cfquery name="upd" datasource="#request.dsn#">
		UPDATE 	emailMessageText 
		SET 	emailText = <cfqueryparam value="#arguments.emailText#" cfsqltype="CF_SQL_VARCHAR">
		WHERE	type = <cfqueryparam value="#arguments.type#" cfsqltype="CF_SQL_VARCHAR">
		</cfquery>
		
		<cfreturn true />
		<cfelse>
		<cfquery name="ins" datasource="#request.dsn#">
		insert into	emailMessageText (emailText,type)
		values (<cfqueryparam value="#arguments.emailText#" cfsqltype="CF_SQL_VARCHAR">,
		 <cfqueryparam value="#arguments.type#" cfsqltype="CF_SQL_VARCHAR">)
		</cfquery>
		<cfreturn false />
		</cfif>
	</cffunction>
</cfcomponent>