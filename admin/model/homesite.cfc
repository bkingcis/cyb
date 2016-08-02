<cfcomponent displayname="comunity">
	<cfparam name="application.residentObj" default="#createObject( 'component', 'admin.model.resident' )#">
	<cfset residentObj = application.residentObj>
	
	<cffunction name="create">
		<cfargument name="c_id" required="Yes">
		<cfargument name="h_id" required="No">
		<cfargument name="h_lname" required="Yes">
		<cfargument name="h_address" required="Yes">
		<cfargument name="h_unitnumber" required="Yes">
		<cfargument name="h_city" required="Yes">
		<cfargument name="h_state" required="Yes">
		<cfargument name="h_zipcode" required="Yes">
		<cfargument name="h_phone" required="Yes">
		<cfargument name="h_notes" required="Yes">
		
		<cfquery name="insHomesite" datasource="#request.dsn#">
		INSERT INTO	homesite (h_lname,h_address,h_unitnumber,h_city,h_state,h_zipcode,h_phone,c_id,h_notes)
		VALUES ('#arguments.h_lname#','#arguments.h_address#','#arguments.h_unitnumber#','#arguments.h_city#','#arguments.h_state#',
				 '#arguments.h_zipcode#','#arguments.h_phone#',#arguments.c_id#,'#arguments.h_notes#')
		</cfquery>
		
		<cfquery name="newid" datasource="#request.dsn#">
			select max(H_id) as new_h_id from homesite
		</cfquery>
		
		<cfreturn newid.new_h_id />
	</cffunction>
	
	<cffunction name="read" returntype="query">
		<cfargument name="c_id" required="Yes" />
		<cfquery name="get" datasource="#request.dsn#">
			SELECT	*
			FROM	homesite
			WHERE	c_id = #arguments.c_id#
			and 	softdelete = 0
			ORDER BY	h_lname
		</cfquery>
		<cfreturn get />
	</cffunction>

	<cffunction name="update">
		<cfargument name="c_id" required="Yes">
		<cfargument name="h_id" required="Yes">
		<cfargument name="h_lname" required="Yes">
		<cfargument name="h_address" required="Yes">
		<cfargument name="h_unitnumber" required="Yes">
		<cfargument name="h_city" required="Yes">
		<cfargument name="h_state" required="Yes">
		<cfargument name="h_zipcode" required="Yes">
		<cfargument name="h_phone" required="Yes">
		<cfargument name="h_notes" required="No">
		
		<cfquery name="updateAcct" datasource="#request.dsn#">
		UPDATE	homesite
		SET		h_lname = '#arguments.h_lname#',
				h_address = '#arguments.h_address#',
				h_unitnumber = '#arguments.h_unitnumber#',				
				h_city = '#arguments.h_city#',
				h_state = '#arguments.h_state#',
				h_zipcode = '#arguments.h_zipcode#',
				h_phone = '#arguments.h_phone#'
				<cfif isDefined("arguments.h_notes")>,h_notes = '#arguments.h_notes#'</cfif>
		WHERE	h_id = <cfqueryparam value="#val(arguments.h_id)#" cfsqltype="CF_SQL_INTEGER">
		</cfquery>
	</cffunction>
	
	<cffunction name="createVacant">
		<cfset newh_ID = create(session.user_community,'','Vacant',arguments.h_address,arguments.h_unitnumber,arguments.h_city,arguments.h_state,arguments.h_zipcode,'','Previous Occupant (#trim(ucase(arguments.h_lname))#, #ucase(arguments.r_fname)#)#chr(11)##chr(13)#Removed #dateFormat(now(),"full")#') />		
		<cfquery datasource="#request.dsn#" name="updatePreviousVacancyRecords">
			update homesitevacancy 
			SET homesiteid = <cfqueryparam value="#newh_ID#" cfsqltype="CF_SQL_INTEGER">
			WHERE	homesiteid = <cfqueryparam value="#arguments.h_id#" cfsqltype="CF_SQL_INTEGER">
		</cfquery>
		<cfquery datasource="#request.dsn#" name="insertVacancyRecord">
			insert into homesitevacancy (homesiteid,vacancydate,previoushomesiteid)
			values (<cfqueryparam value="#newh_ID#" cfsqltype="CF_SQL_INTEGER">,
				current_timestamp,
				<cfqueryparam value="#arguments.h_id#" cfsqltype="CF_SQL_INTEGER">
				)
		</cfquery>
		<cfreturn newh_ID>
	</cffunction>
	
	<cffunction name="delete">
		<cfargument name="h_id" required="Yes">
		<cfquery datasource="#request.dsn#">
			UPDATE homesite SET softdelete = 1, softdeletedate = <cfqueryparam cfsqltype="CF_SQL_DATE" value="#now()#" />
			WHERE h_id = #arguments.h_id#
		</cfquery>
		<cfreturn True />
	</cffunction>
	
</cfcomponent>