<cfcomponent displayname="commMessage">
	<cffunction name="read" returntype="query">
		<cfargument name="messageID" required="Yes">		
		<cfquery datasource="#request.dsn#" name="get">
			select * from adminMessageContent 
			WHERE messageid = #arguments.messageID#
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="acknowledgeAdminMessage" returntype="boolean">
		<cfargument name="userid" required="Yes">
		<cfargument name="messageID" required="Yes" />
		<cfargument name="c_id" required="Yes" />
		<cfquery datasource="#request.dsn#" name="get">
			UPDATE adminMessageRecipients 
			SET acknowledgedby = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.userid#" />
			WHERE messageid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.messageID#" />
			AND c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.c_id#" />
		</cfquery>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="GetHistoryByComunity" returntype="query">
		<cfargument name="c_id" required="Yes">		
		<cfquery datasource="#request.dsn#" name="get">
			select * from adminMessageContent 
			WHERE messageid IN  (
				select messageid from adminMessageRecipients
				WHERE		c_id = #arguments.c_id#)
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="getMostRecentCommunityMessage" returntype="query">
		<cfargument name="c_id" required="Yes">		
		<cfquery datasource="#request.dsn#" name="get">
			select * from adminMessageContent 
			WHERE messageid IN  (
				select messageid from adminMessageRecipients
				WHERE		c_id = #arguments.c_id#)
				order by insertdate desc
				LIMIT 1
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="insertCommMessage">
		<cfargument name="communityList" required="Yes">
		<cfargument name="messagesubject" required="Yes">
		<cfargument name="messageText" required="Yes">
		<cfargument name="sentToall" required="No" default="0">
		
		<cfquery datasource="#request.dsn#">
			insert into adminMessageContent (messagesubject,messageText,sentToall)
			values ('#arguments.messagesubject#','#arguments.messageText#',#arguments.sentToAll#)
		</cfquery>
		<cfquery name="newid" datasource="#request.dsn#">
			select max(messageID) as new_id from adminMessageContent
		</cfquery>
		<cfloop list="#arguments.communityList#" index="commID">
			<cfquery datasource="#request.dsn#">
				insert into adminMessageRecipients (messageid,c_id)
				values (#newid.new_id#,#commid#)
			</cfquery>
		</cfloop>
		<cfreturn true>
	</cffunction>
</cfcomponent>