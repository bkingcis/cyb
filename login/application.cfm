<cfapplication name="user_login"
	sessionmanagement="Yes">
<cftry>
<cfparam name="login_type" default="Resident" />
<cfparam name="action" default="#login_type#" />

<cfif cgi.script_name is '/login/forgot.cfm'>
	<cfset action='forgotpass'>
</cfif>

	<cfswitch expression="#action#">
		<cfcase value="resident">
			<cfset request.login_processor = '/residents/login.cfm'>
			<cfset request.page_title = 'Resident User Secured Access:'>
		</cfcase>
		<cfcase value="personnel">
			<cfset request.login_processor = '/staff/login.cfm'>
			<cfset request.page_title = 'Personnel User Secured Access:'>
		</cfcase>
		<cfcase value="admin,commadmin">
			<cfset request.login_processor = '/admin/admin.cfm?fa=login'>
			<cfset request.page_title = 'Commiunity Administration Secured Access:'>
		</cfcase>
		<cfcase value="forgotpass">
			<cfset request.login_processor = '/login/forgotpass.cfm'>
			<cfset request.page_title = ucase(login_type) & ' Password Recovery'>
		</cfcase>
		<cfdefaultcase>
			<p>Invalid Login Type.</p><cfabort>
		</cfdefaultcase>
	</cfswitch>
	<cfcatch><cfdump var="#cfcatch#"></cfcatch>
</cftry>