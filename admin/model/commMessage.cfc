<cfcomponent displayname="commMessage">
	<cffunction name="updateCommMessage">
		<cfargument name="c_id" required="Yes">
		<cfargument name="message_id" required="Yes">
		<cfargument name="messageText" required="Yes">
		
		<!--- <cfquery datasource="#request.dsn#">
			update communitymessages 
			SET messageText = '#arguments.messageText#'
			WHERE message_id = #arguments.message_id#
			AND		c_id = #arguments.c_id#
		</cfquery> --->
		<!--- altered here to only enter new messages instead of updating...All historical messages are now saved --->
		<cfset insertCommMessage(c_id,fieldname,messageText)>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="insertCommMessage">
		<cfargument name="c_id" required="Yes">
		<cfargument name="fieldname" required="Yes">
		<cfargument name="messageText" required="Yes">
		
		<cfquery datasource="#request.dsn#">
			insert into communitymessages (c_id,fieldname,messageText,MESSAGEDATE)
			values (#arguments.c_id#,'#arguments.fieldname#','#arguments.messageText#','#dateformat(now(), "yyyy-mm-dd")#T#TimeFormat(now(), "HH:mm:ss")#')
		</cfquery>
		<cfreturn true>
	</cffunction>
	<cffunction name="GetAllByFieldname" returntype="query">
		<cfargument name="c_id" required="Yes">
		<cfargument name="fieldname" required="Yes">
		<cfif arguments.fieldname is 'notification'>
            <cfquery name="qCommmessages" datasource="#request.dsn#">
                select insertDate as messagedate, messagetext, messageSubject from adminMessageContent 
                WHERE messageid IN  (
                    SELECT messageid from adminMessageRecipients
                    WHERE		c_id = #session.user_community#)
                ORDER by insertdate desc
            </cfquery>
        <cfelse>
            <cfquery name="qCommmessages" datasource="#request.dsn#">
                SELECT * from communitymessages
                WHERE fieldname = '#arguments.fieldname#'
                AND c_id =  #arguments.c_id#
                ORDER by messagedate desc, message_id desc
            </cfquery>
        </cfif>
		<cfreturn qCommmessages>
	</cffunction>
	<cffunction name="read" returntype="query">
		<cfargument name="messageid" required="Yes" />
            <cfquery name="qCommmessages" datasource="#request.dsn#">
                select insertDate as messagedate, messagetext, messageSubject from adminMessageContent 
                WHERE messageid IN  (
                    SELECT messageid from adminMessageRecipients
                    WHERE		c_id = <cfqueryparam value="#session.user_community#" cfsqltype="CF_SQL_INTEGER" />
					AND messageid = <cfqueryparam value="#arguments.messageid#" cfsqltype="CF_SQL_INTEGER" />)
                ORDER by insertdate desc
            </cfquery>
		<cfreturn qCommmessages>
	</cffunction>
</cfcomponent>