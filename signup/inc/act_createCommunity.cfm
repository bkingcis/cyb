<cfparam name="session.signup.timezone" default="Pacific">
<cfparam name="session.signup.c_county" default="">
<cfparam name="session.signup.maxPermGuests" default="10">
<cfparam name="session.signup.CHK_SHOWUNITONLYOPTION" default="0">
<cfset variables.c_cname = "">

<cftry>
<cfloop list="#session.signup.c_name#" index="word" delimiters=" ">
 <cfset variables.c_cname = variables.c_cname & left(word,1)>
</cfloop>
<!---
<cfquery datasource="#request.dsn#" name="pull">
	delete from communities where c_cname = 'cbn'
</cfquery>
<cfquery datasource="#request.dsn#" name="pull">
	select c_name,c_cname,c_address,c_city,c_state,c_zipcode,
		c_crest,c_county,timezone,maxHomesites,<cfif structKeyExists(session,"autoIdentifyStaff")>autoIdentifyStaff,</cfif>
		c_active,dashpass,quickpass,minipass,dashpass_map,keypunchoption,dashdirect,cardscan,history,permanantguests,checkoutoption,
		guestcompanionOption,recordLicensePlate,recordlicenseplateonallvisits,recordlicenseplateonspecialevents,maxPermGuests,insertdate
	from communities order by insertdate desc
</cfquery>
<cfdump var="#pull#">
<cfabort> --->


	<cfquery datasource="#request.dsn#" name="commAdd">
			INSERT INTO	communities (c_name,c_cname,c_address,c_city,c_state,c_zipcode,
				c_crest,c_county,timezone,maxHomesites,<cfif structKeyExists(session,"autoIdentifyStaff")>autoIdentifyStaff,</cfif>
				c_active,dashpass,quickpass,minipass,dashpass_map,keypunchoption,dashdirect,cardscan,history,permanantguests,checkoutoption,
				guestcompanionOption,recordLicensePlate,recordlicenseplateonallvisits,recordlicenseplateonspecialevents,
				parcelpickup,parcelPickupResidentOnly,maxPermGuests,SHOWUNITONLYOPTION)
			VALUES 	('#session.signup.c_name#',
				'#lcase(variables.c_cname)#',
				'#session.signup.c_address1#',
				'#session.signup.c_city#',
				'#ucase(session.signup.c_state)#',
				'#session.signup.c_postalcode#',
				<cfif structKeyExists(session.signup,'c_crest') and len(session.signup.c_crest)>'#session.signup.c_crest#'<cfelse>''</cfif>,
				'#session.signup.c_county#',
				'#session.signup.timezone#',
				#session.signup.HOMESITE_COUNT#,
				<cfif structKeyExists(session.signup,"autoIdentifyStaff")>#session.signup.autoIdentifyStaff#,</cfif>
				<cfif structKeyExists(session.signup,"c_active")>'True'<cfelse>'False'</cfif>,
				<cfif structKeyExists(session.signup,"chk_dashpass") and session.signup.chk_dashpass>'True'<cfelse>'False'</cfif>,
				<cfif structKeyExists(session.signup,"quickpass")>'True'<cfelse>'False'</cfif>,
				<cfif structKeyExists(session.signup,"minipass")>'True'<cfelse>'False'</cfif>,
				<cfif structKeyExists(session.signup,"dashpass_map")>'True'<cfelse>'False'</cfif>,
				<cfif structKeyExists(session.signup,"keypunchoption")>1<cfelse>0</cfif>,
				<cfif structKeyExists(session.signup,"dashdirect")>'True'<cfelse>'False'</cfif>,
				<cfif structKeyExists(session.signup,"cardscan")>'True'<cfelse>'False'</cfif>,
				<cfif structKeyExists(session.signup,"history")>'True'<cfelse>'False'</cfif>,	
				<cfif structKeyExists(session.signup,"CHK_247GUESTS") and session.signup.CHK_247GUESTS eq 1>1<cfelse>0</cfif>,	
				<cfif structKeyExists(session.signup,"checkoutoption")>1<cfelse>0</cfif>,	
				<cfif structKeyExists(session.signup,"guestcompanionOption")>1<cfelse>0</cfif>,		
				<cfif structKeyExists(session.signup,"RECORDLICENSEPLATE") and session.signup.RECORDLICENSEPLATE eq 1>1<cfelse>0</cfif>,	
				<cfif structKeyExists(session.signup,"recordlicenseplateonallvisits")>#val(session.signup.recordlicenseplateonallvisits)#<cfelse>0</cfif>,	
				<cfif structKeyExists(session.signup,"recordLicensePlate") and session.signup.recordLicensePlate eq 1>1<cfelse>0</cfif>,
				<!--- <cfif structKeyExists(session.signup,"recordlicenseplateonspecialevents")>#val(session.signup.recordlicenseplateonspecialevents)#<cfelse>0</cfif>,	
				--->
				<cfif structKeyExists(session.signup,"CHK_PACKAGEDROPOFF") and session.signup.chk_packagedropoff neq 0>1<cfelse>0</cfif>,
				<cfif structKeyExists(session.signup,"parcelPickupResidentOnly")>#val(session.signup.parcelPickupResidentOnly)#<cfelse>0</cfif>,
				#val(session.signup.maxPermGuests)#,
				#val(session.signup.CHK_SHOWUNITONLYOPTION)#
				)
		</cfquery>
		<cfquery datasource="#request.dsn#" name="pull_qry">
			select c_id
			from communities order by c_id desc limit 1
		</cfquery>
		<cfif structKeyExists(session.signup,"CHK_SPECIALEVENT") and listFindNoCase(session.signup.CHK_SPECIALEVENT,'oh')>
				<cfquery datasource="#request.dsn#">
					insert into CommunityeventTypes (etid,c_id,abbreviation,label)
					values (nextval('ai_seq'),<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#pull_qry.c_id#" />,'OH','Open House')
				</cfquery>
		</cfif>
		<cfif structKeyExists(session.signup,"CHK_SPECIALEVENT") and listFindNoCase(session.signup.CHK_SPECIALEVENT,'gs')>
				<cfquery datasource="#request.dsn#">
					insert into CommunityeventTypes (etid,c_id,abbreviation,label)
					values (nextval('ai_seq'),<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#pull_qry.c_id#" />,'GS','Garage Sale')
				</cfquery>
		</cfif>
		<cfif structKeyExists(session.signup,"CHK_SPECIALEVENT") and listFindNoCase(session.signup.CHK_SPECIALEVENT,'pt')>
				<cfquery datasource="#request.dsn#">
					insert into CommunityeventTypes (etid,c_id,abbreviation,label)
					values (nextval('ai_seq'),<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#pull_qry.c_id#" />,'PT','Party')
				</cfquery>
		</cfif>
		<cfif structKeyExists(session.signup,"CHK_SPECIALEVENT") and listFindNoCase(session.signup.CHK_SPECIALEVENT,'c1')>
			<cfif LEN(session.signup.custevent1)>
				<cfset thisAbbrev1 = left(session.signup.custevent1,2)>
				<cfif listFindNoCase('pt,oh,gs',thisAbbrev1)>
					<cfquery datasource="#request.dsn#">
						insert into CommunityeventTypes (etid,c_id,abbreviation,label)
						values (nextval('ai_seq'),<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#pull_qry.c_id#" />,
						<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#thisAbbrev1#" />,
						<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.signup.custevent1#" />)
					</cfquery>
				</cfif>
			</cfif>
		</cfif>
		<cfif structKeyExists(session.signup,"CHK_SPECIALEVENT") and listFindNoCase(session.signup.CHK_SPECIALEVENT,'c2')>
			<cfif LEN(session.signup.custevent2)>
				<cfset thisAbbrev2 = left(session.signup.custevent2,2)>
				<cfif listFindNoCase('pt,oh,gs',thisAbbrev2) and not thisAbbrev2 is thisAbbrev1><!--- TODO:  Think about a better way to prevent duplicates here --->
					<cfquery datasource="#request.dsn#">
						insert into CommunityeventTypes (etid,c_id,abbreviation,label)
						values (nextval('ai_seq'),<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#pull_qry.c_id#" />,
						<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#thisAbbrev2#" />,
						<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.signup.custevent2#" />)
					</cfquery>
				</cfif>
			</cfif>
		</cfif>

		<!--- community entry points --->
		<cfloop from="1" to="5" index="i">
			<cfif len(trim(session.signup['entrypoint_'&i]))>
			<cfquery datasource="#request.dsn#" name="insCEP">
				insert into communityentrypoints ( c_id, label )
				values (
					<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#pull_qry.c_id#" />,
					<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#session.signup['entrypoint_'&i]#" />
				)
			</cfquery>
			</cfif>
		</cfloop>
		<cfset session.c_id = pull_qry.c_id>
	<cfcatch type="Any">
			<cfif not isDefined('session.signup') OR not structKeyExists(session.signup,'c_name')>
				<h2>Your session timed out.</h2>
				
				<a href="/signup">Please click here to start again.</a>
			<cfelse>
				<cfdump var="#cfcatch#">
			</cfif>
						<cfabort>

	</cfcatch>
</cftry>
