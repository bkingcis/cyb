<cftry>
	<cfquery datasource="#request.dsn#">
		INSERT INTO 	staff
			(staff_username, staff_password, staff_fname, staff_lname, staff_level, c_id)
		VALUES('#session.signup.email#','#session.signup.newUser_password#','#session.signup.f_name#','#session.signup.l_name#',
		2,#session.c_id#)
	</cfquery>
	<cfquery datasource="#request.dsn#" name="newStaff">
		select max(staff_id) as id from staff
	</cfquery>
	<cfquery name="updateAcct" datasource="#request.dsn#">
			INSERT INTO	communityContacts (c_id,Contact_fname,Contact_lname,Contact_email,Contact_phone,Contact_altphone,staff_id)
			VALUES		( #session.c_id#,'#session.signup.f_name#','#session.signup.l_name#','#session.signup.email#','#session.signup.phone#','',#newStaff.id#)
		</cfquery>
<cfcatch type="Any"><cfdump var="#cfcatch#"><cfabort></cfcatch>
</cftry>