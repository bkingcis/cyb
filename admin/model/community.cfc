<cfcomponent displayname="comunity">
	<cffunction name="create" returntype="numeric">
		<cfquery datasource="#request.dsn#" name="commAdd">
			INSERT INTO	communities (c_name,c_cname,c_address,c_city,c_state,c_zipcode,
				c_crest,c_county,timezone,maxHomesites,
				<cfif isDefined("arguments.autoIdentifyStaff")>autoIdentifyStaff,</cfif>
				c_active,dashpass,quickpass,minipass,dashpass_map,keypunchoption,dashdirect,cardscan,
				history,permanantguests,checkoutoption,
				guestcompanionOption,recordLicensePlate,recordlicenseplateonallvisits,
				recordlicenseplateonspecialevents,parcelpickup,parcelPickupResidentOnly,
				maxPermGuests,insertdate)
			VALUES 	('#arguments.c_name#',
				'#lcase(arguments.c_cname)#',
				'#arguments.c_address#',
				'#arguments.c_city#',
				'#ucase(arguments.c_state)#',
				'#arguments.c_zipcode#',
				<cfif len(form.c_crest)>'#form.c_crest#'<cfelse>''</cfif>,
				'#arguments.c_county#',
				'#arguments.timezone#',
				#arguments.maxHomesites#,
				<cfif isDefined("arguments.autoIdentifyStaff")>#arguments.autoIdentifyStaff#,</cfif>
				<cfif isDefined("form.c_active")>'True'<cfelse>'False'</cfif>,
				<cfif isDefined("form.dashpass")>'True'<cfelse>'False'</cfif>,
				<cfif isDefined("form.quickpass")>'True'<cfelse>'False'</cfif>,
				<cfif isDefined("form.minipass")>'True'<cfelse>'False'</cfif>,
				<cfif isDefined("form.dashpass_map")>'True'<cfelse>'False'</cfif>,
				<cfif isDefined("form.keypunchoption")>1<cfelse>0</cfif>,
				<cfif isDefined("form.dashdirect")>'True'<cfelse>'False'</cfif>,
				<cfif isDefined("form.cardscan")>'True'<cfelse>'False'</cfif>,
				<cfif isDefined("form.history")>'True'<cfelse>'False'</cfif>,	
				<cfif isDefined("form.permanantguests")>1<cfelse>0</cfif>,	
				<cfif isDefined("form.checkoutoption")>1<cfelse>0</cfif>,	
				<cfif isDefined("form.guestcompanionOption")>1<cfelse>0</cfif>,		
				<cfif isDefined("form.recordLicensePlate")>1<cfelse>0</cfif>,	
				<cfif isDefined("form.recordlicenseplateonallvisits")>#val(form.recordlicenseplateonallvisits)#<cfelse>0</cfif>,	
				<cfif isDefined("form.recordlicenseplateonspecialevents")>#val(form.recordlicenseplateonspecialevents)#<cfelse>0</cfif>,	
				<cfif isDefined("form.parcelpickup")>1<cfelse>0</cfif>,
				<cfif isDefined("form.parcelPickupResidentOnly")>#val(form.parcelPickupResidentOnly)#<cfelse>0</cfif>,
				#arguments.maxPermGuests#,
				'#dateFormat(now(),"mm/dd/yyyy hh:mm:ss")#'
				)
		</cfquery>
		
		<cfquery name="newid" datasource="#request.dsn#">
			select max(c_id) as new_c_id from communities
		</cfquery>
		
		<cfreturn newid.new_c_id />
	</cffunction>
	
	<cffunction name="read" returntype="query">
		<cfargument name="c_id" required="No" />
		<cfquery name="qCommunities" datasource="#request.DSN#">
			SELECT 	c.*, (select count(*) from homesite where c_id = c.c_id) as  homesiteCount 
			FROM 	communities c
			<cfif isDefined("arguments.c_id")>
				WHERE 	c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.c_id#" />
			<cfelse>
			<cfif isDefined("arguments.statefilter")>
				WHERE  c.c_state = '#arguments.statefilter#'
				<cfif isDefined("arguments.countyfilter")>
					AND  c.c_county = '#arguments.countyfilter#'
				</cfif>
			</cfif>
			order by c.c_name
			</cfif>
		</cfquery>
		<cfreturn qCommunities />
	</cffunction>
	<cffunction name="update">
		<cfquery datasource="#request.dsn#" name="commupdate">
		UPDATE	communities
		SET		c_name = '#arguments.c_name#',
				c_cname = '#lcase(arguments.c_cname)#',
				<!--- c_description = '#arguments.c_description#', --->
				c_address = '#arguments.c_address#',
				c_city = '#arguments.c_city#',
				c_state = '#arguments.c_state#',
				c_zipcode = '#arguments.c_zipcode#',
				<cfif len(form.c_crest)>c_crest='#form.c_crest#',</cfif>
				c_county = '#arguments.c_county#',
				timezone = '#arguments.timezone#',
				maxHomesites = #arguments.maxHomesites#,
				<cfif isDefined("arguments.autoIdentifyStaff")>autoIdentifyStaff = #arguments.autoIdentifyStaff#,</cfif>
				c_active = <cfif isDefined("form.c_active")>'True'<cfelse>'False'</cfif>,
				dashpass = <cfif isDefined("form.dashpass")>'True'<cfelse>'False'</cfif>,
				quickpass = <cfif isDefined("form.quickpass")>'True'<cfelse>'False'</cfif>,
				minipass = <cfif isDefined("form.minipass")>'True'<cfelse>'False'</cfif>,
				dashpass_map = <cfif isDefined("form.dashpass_map")>'True'<cfelse>'False'</cfif>,
				keypunchoption = <cfif isDefined("form.keypunchoption")>1<cfelse>0</cfif>,
				dashdirect = <cfif isDefined("form.dashdirect")>'True'<cfelse>'False'</cfif>,
				cardscan = <cfif isDefined("form.cardscan")>'True'<cfelse>'False'</cfif>,
				history = <cfif isDefined("form.history")>'True'<cfelse>'False'</cfif>,
				permanantguests = <cfif isDefined("form.permanantguests")>1<cfelse>0</cfif>,
				checkoutoption = <cfif isDefined("form.checkoutoption")>1<cfelse>0</cfif>,
				guestcompanionOption = <cfif isDefined("form.guestcompanionOption")>1<cfelse>0</cfif>,
				recordLicensePlate = <cfif isDefined("form.recordLicensePlate")>1<cfelse>0</cfif>,
				recordlicenseplateonallvisits = <cfif isDefined("form.recordlicenseplateonallvisits")>#val(form.recordlicenseplateonallvisits)#<cfelse>0</cfif>,		
				recordlicenseplateonspecialevents = <cfif isDefined("form.recordlicenseplateonspecialevents")>#val(form.recordlicenseplateonspecialevents)#<cfelse>0</cfif>,
				parcelPickup = <cfif isDefined("form.parcelpickup")>1<cfelse>0</cfif>,
				parcelPickupResidentOnly = <cfif isDefined("form.parcelPickupResidentOnly")>#val(form.parcelPickupResidentOnly)#<cfelse>0</cfif>,				
				maxPermGuests = #arguments.maxPermGuests#,
				track_maintenance_requests = <cfif isDefined("form.track_maintenance_requests")>1<cfelse>0</cfif>
				
		WHERE	c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.c_id#" />
		</cfquery>		
	</cffunction>
	<cffunction name="updateCaptureInterval">
		<cfargument name="c_id" required="Yes" />
		<cfargument name="captureLengthMon" required="Yes" />		
		<cfquery datasource="#request.dsn#" name="commupdate">
		UPDATE	communities
		SET		captureLengthMon = '#arguments.captureLengthMon#'
		WHERE	c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.c_id#" />
		</cfquery>
		<cfreturn true />
	</cffunction>
	<cffunction name="updatePaymentDueDate">
		<cfargument name="c_id" required="Yes" />
		<cfargument name="paymentduedate" required="Yes" />		
		<cfquery datasource="#request.dsn#" name="commupdate">
		UPDATE	communities
		SET		paymentDueDate = '#arguments.paymentDueDate#'
		WHERE	c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.c_id#" />
		</cfquery>
		<cfreturn true />
	</cffunction>
	<cffunction name="saveUnitNumberOption">
		<cfargument name="c_id" required="Yes" />
		<cfargument name="addressDisplay" required="No" />		
		<cfquery datasource="#request.dsn#" name="commupdate">
		UPDATE	communities
		SET		showunitonlyoption = 
		<cfif isDefined('arguments.addressDisplay')>1<cfelse>0</cfif>
		WHERE	c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.c_id#" />
		</cfquery>
		<cfreturn true />
	</cffunction>
	<cffunction name="getEventTypes" returntype="query">
		<cfargument name="c_id" required="Yes" />
		<cfquery datasource="#request.dsn#" name="getTypes">
		SELECT 	<!--- EventTypeID,Abbreviation,Label ---> *
		FROM	communityEventTypes
		WHERE	c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.c_id#" />
		</cfquery>
		<cfreturn getTypes />
	</cffunction>
	<cffunction name="deleteLogo" returntype="boolean">
		<cfargument name="c_id" required="Yes" />
		<cfquery datasource="#request.dsn#" name="getTypes">
		update communities set c_crest = ''
		WHERE	c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.c_id#" />
		</cfquery>
		<cfreturn true />
	</cffunction>
	<cffunction name="delete" returntype="boolean">
		<cfargument name="c_id" required="Yes" />
		<cfquery datasource="#request.dsn#" name="del">
		delete from communities
		WHERE	c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.c_id#" />
		</cfquery>
		<cfreturn true />
	</cffunction>
</cfcomponent>