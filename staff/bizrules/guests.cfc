<cfcomponent>
	<cfset datasource="cybatrol" />
	<cffunction name="create" access="public" returntype="numeric" displayname="Create User " hint="Returns User ID">
		<cfargument name="lastname" required="true" />
		<cfargument name="firstname" required="true" />
		<cfargument name="email" required="true" />		
		<cfargument name="mobileNumber" required="false" />
		<cfargument name="r_id" required="true" />
		
		<cfquery name="GetGuest" datasource="#datasource#">
			select g_id from guests
			Where g_fname = '#firstname#'	
			AND g_lname = '#lastname#' 
			AND g_email = '#email#'
			AND r_id = #r_id#
		</cfquery>
		<cfif GetGuest.RecordCount GT 0>
			<cfreturn getGuest.g_id />
		<cfelse>
			<cfquery name="addGuest" datasource="#datasource#">
			insert into guests (g_lname,g_fname,g_email,r_id<cfif isDefined('arguments.mobileNumber')>,mobilePhone</cfif>)
			Values ('#lastname#','#firstname#','#email#',#r_id#<cfif isDefined('arguments.mobileNumber')>,'#arguments.mobileNumber#'</cfif>)
			</cfquery>
			<cfquery name="GetGuest" datasource="#datasource#">
				select g_id from guests
				Where g_fname = '#firstname#'	
				AND g_lname = '#lastname#' 
				AND g_email = '#email#'
				AND r_id = #r_id#
			</cfquery>
			<cfreturn getGuest.g_id />
		</cfif>
	</cffunction>
</cfcomponent>