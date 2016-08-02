<cfcomponent displayname="Contact">
	<cffunction name="create">
		<cfquery name="updateAcct" datasource="#request.dsn#">
			INSERT INTO	communityContacts (c_id,Contact_fname,Contact_lname,Contact_email,Contact_phone,Contact_altphone,staff_id)
			VALUES		( #arguments.c_id#,'#arguments.Contact_fname#','#arguments.Contact_lname#','#arguments.Contact_email#','#arguments.Contact_phone#','#arguments.Contact_altphone#',#arguments.staff_id#)
		</cfquery>
		<cfreturn true />
	</cffunction>
	
	<cffunction name="read" returntype="query">
		<cfargument name="c_id" required="Yes" />
		<cfargument name="contact_type" required="No" />
		<cfquery name="get" datasource="#request.dsn#">
			SELECT		*
			FROM		communityContacts cc left join staff s on s.staff_id = cc.staff_id
			WHERE		cc.c_id = #arguments.c_id#
			AND 		s.staff_level=2
			ORDER BY	contactid 
		</cfquery>
		<cfreturn get />
	</cffunction>
	
	<cffunction name="update">		
		<cfquery name="updateAcct" datasource="#request.dsn#">
		UPDATE	communityContacts
		SET		Contact_fname = '#arguments.Contact_fname#',
				Contact_lname = '#arguments.Contact_lname#',
				Contact_email = '#arguments.Contact_email#',
				Contact_phone = '#arguments.Contact_phone#',
				Contact_altphone = '#arguments.Contact_altphone#',
				staff_id = '#arguments.staff_id#'
		WHERE	Contactid = #arguments.Contactid#
		</cfquery>
		<cfreturn true />
	</cffunction>
	
	<cffunction name="save">
		<cfargument name="contactid">
		<cfargument name="staff_id">
		<cfargument name="c_id">
		<cfargument name="contact_lname">
		<cfargument name="contact_fname">
		<cfargument name="contact_email">
		<cfargument name="contact_phone">
		<cfargument name="contact_altphone">
		<cfargument name="contact_type">
		<cfquery datasource="#request.dsn#" name="checkit">
			select contactid from communityContacts
			WHERE 	c_id = #arguments.c_id#
			AND		contactid = #val(arguments.contactid)#
		</cfquery>
		<cfif checkit.recordcount>
			<cfset arguments.contactid = checkit.contactid>
			<cfset update(argumentcollection=arguments)>
		<cfelse>
			<cfset create(argumentcollection=arguments)>
		</cfif>
	</cffunction>
	
	<cffunction name="delete">
		<cfquery datasource="#request.dsn#">
			DELETE FROM communityContacts
			WHERE r_id = #arguments.r_id#
		</cfquery>
		<cfreturn True />		
	</cffunction>
	
</cfcomponent>