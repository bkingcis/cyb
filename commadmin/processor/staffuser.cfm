<security:community>

<!--- <cfdump var="#session#"><cfabort> --->

<cfswitch expression="#fuseaction#">
	<cfcase value="saveStaffUser">
	<cfif val(form.staff_id)>
		<cfquery datasource="#request.dsn#" name="qUser">
			update staff
				set staff_fname = <cfqueryparam value="#form.staff_fname#" cfsqltype="CF_SQL_VARCHAR">,
				staff_lname = <cfqueryparam value="#form.staff_lname#" cfsqltype="CF_SQL_VARCHAR">,
				staff_Username = <cfqueryparam value="#form.staff_email#" cfsqltype="CF_SQL_VARCHAR">,
				staff_email = <cfqueryparam value="#form.staff_email#" cfsqltype="CF_SQL_VARCHAR">,
				active = <cfqueryparam value="#form.active#" cfsqltype="CF_SQL_BIT" />
			where staff_id = <cfqueryparam value="#form.staff_id#" cfsqltype="CF_SQL_INTEGER">
		</cfquery>
	<cfelse>
		<cfquery datasource="#request.dsn#" name="newUser">
			insert into staff (staff_email,staff_Username,staff_fname,staff_lname,active,c_id)
			values	(
				  <cfqueryparam value="#form.staff_email#" cfsqltype="CF_SQL_VARCHAR" />,
				  <cfqueryparam value="#form.staff_email#" cfsqltype="CF_SQL_VARCHAR" />,
				  <cfqueryparam value="#form.staff_fname#" cfsqltype="CF_SQL_VARCHAR" />,
				  <cfqueryparam value="#form.staff_lname#" cfsqltype="CF_SQL_VARCHAR" />,
				  <cfqueryparam value="#form.active#" cfsqltype="CF_SQL_BIT" />,
				  <cfqueryparam value="#session.user_Community#" cfsqltype="CF_SQL_INTEGER" />
				  )
		</cfquery>
		<cfquery datasource="#request.dsn#" name="qUser">
			select max(staff_id) as newid
			from staff 
		</cfquery>
		<cfset result = staffObj.resetPass(qUser.newid,"new")>	
	</cfif>
	</cfcase>
	<cfcase value="resetStaffPass">
		<cfset result = staffObj.resetPass(form.staff_id)>	
		<cfif result>
		<cfset session.message = "Staff User password has been reset.">
		<cfelse>
		<cfset session.message = "PASSWORD COULD NOT BE RESET.">
		</cfif>
	</cfcase>
</cfswitch>
<cflocation url="../index.cfm##tabs-4" addtoken="no">

