<cfif not isDefined("datasource")>
	<cfset datasource = caller.datasource>
</cfif>
<cfif NOT VAL(attributes.v_id)>
	<cfabort showerror="v_id is not numeric">
</cfif>
<!--- lookup schedule and guestvisit --->
<cfquery datasource="#datasource#" name="qGuestVisit">
	select * from guestvisits
	where v_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#attributes.v_id#" />
</cfquery>
<cfquery datasource="#datasource#" name="qSchedule">
	select * from schedule 
	where v_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#attributes.v_id#" />
</cfquery>


<cfif NOT isDefined('request.guid')>
	<cfset request.guid = createuuid()>
	<cfquery datasource="#datasource#" name="insertVisit">
		insert into Visits (
			v_id,	entrypointid,	g_barcode,	g_checkedin,	g_id,	staff_id, guid
			<cfif isDefined('form.licensePlateNumber')>, licensePlateNumber</cfif>
			<cfif isDefined('form.licensePlateStateCode')>, licenseplateStateCode</cfif>
		) 
		values( 
			<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#attributes.v_id#" />,
			<cfif isDefined("session.entrypointid") AND VAL(session.entrypointid)>
				<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(session.entrypointid)#" />
			<cfelse>
				0
			</cfif>,
			<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#qGuestVisit.g_barcode#" />,
			<cfqueryparam value="#request.timezoneadjustednow#" cfsqltype="CF_SQL_TIMESTAMP">,
			<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#qGuestVisit.g_id#" />,
			<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.staff_id#" />,
			<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#request.guid#" />
			
			<cfif isDefined('form.licensePlateNumber')>, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.licensePlateNumber#" /></cfif>
			<cfif isDefined('form.licensePlateStateCode')>, <cfqueryparam cfsqltype="CF_SQL_CHAR" value="#form.licensePlateStateCode#" /></cfif>
		)
	</cfquery>
	<!--- work around for duplicate entry issue on database --->
	<cfquery datasource="#datasource#" name="validateVisit">
		select * from Visits where guid = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#request.guid#" />
	</cfquery>
	<cfif validateVisit.recordcount gt 1>
		<!--- duplicate entry. Delete the dups --->
		<cfabort showerror="STILL GETTING DUPLICATES!">
	</cfif>
<cfelse>
<h1>Duplicate Found request.guid stopped it.</h1><cfabort>
</cfif>

<cfquery datasource="#datasource#" name="updGuestVisit">
	update guestvisits set g_checkedin = <cfqueryparam value="#request.timezoneadjustednow#" cfsqltype="CF_SQL_TIMESTAMP">
	where v_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#qGuestVisit.v_id#" />
</cfquery>

