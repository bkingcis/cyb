<cfcomponent>
	<cffunction name="GetUserType" access="public" returntype="query">
		<cfargument name="username" required="yes">
		<cfargument name="password" required="yes">
		
		<cfquery name="get" datasource="#request.dsn#">
		SELECT	*
		FROM	staff
		WHERE	staff_username = '#arguments.username#'
			AND staff_password = '#arguments.password#'
			AND staff_level > 0
		</cfquery>
		
		<cfquery datasource="#request.dsn#" name="community">
			select c_active from communities
			where c_id = #val(get.c_id)#
		</cfquery>
		
		<cfif len(community.c_active) and community.c_active>		
			<cfreturn get />
		<cfelse>
			<cfquery name="get2" datasource="#request.dsn#">
			SELECT	*			FROM	staff 	WHERE	1 = 2
			</cfquery>
			<cfreturn get2 />
		</cfif>
	</cffunction>
	<cffunction name="Read" access="public" returntype="query">
		<cfargument name="c_id" required="yes">
		
		<cfquery name="get" datasource="#request.dsn#">
		SELECT	*
		FROM	staff
		WHERE	c_id = #arguments.c_id#
			AND staff_level = 2
		</cfquery>
		
		<cfreturn get />
	</cffunction>
	<cffunction name="passwordUpdate" access="public" returntype="boolean">
		<cfargument name="staff_id" required="yes">
		<cfargument name="newPass" required="yes">
		
		<cfquery name="get" datasource="#request.dsn#">
		UPDATE staff
		SET  staff_password = '#arguments.newPass#',s_passReset=1
		WHERE	staff_id = #arguments.staff_id#
		
		</cfquery>
		
		<cfreturn true />
	</cffunction>
    <cffunction name="updateAdministrator" access="public" returntype="numeric">
		<cfargument name="c_id" required="yes">
		<cfargument name="staff_username" required="yes">
		<cfargument name="staff_password" required="yes">
		<cfargument name="staff_lname" required="yes">
		<cfargument name="staff_fname" required="yes">
		<cfargument name="staff_id" required="yes">
		
		<cfif val(arguments.staff_id)>
			<cfquery datasource="#request.dsn#">	
				update staff set
					staff_username='#arguments.staff_username#',
					staff_password='#arguments.staff_password#',
					staff_fname='#arguments.staff_fname#', 
					staff_lname='#arguments.staff_lname#'
				where staff_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.staff_id#" />
			</cfquery>
			<cfreturn arguments.staff_id>
		<cfelse>
			<cfquery datasource="#request.dsn#">
	            INSERT INTO 	staff
	            	(staff_username, staff_password, staff_fname, staff_lname, staff_level, c_id)
	        	VALUES('#arguments.staff_username#','#arguments.staff_password#','#arguments.staff_fname#','#arguments.staff_lname#',2,#arguments.c_id#)
	        </cfquery>
			<cfquery datasource="#request.dsn#" name="inserted">
	            select max(staff_id) as lastStaff from staff
			</cfquery>
			<cfreturn inserted.lastStaff>
		</cfif>
	</cffunction>
 
</cfcomponent>