<cfif not isDefined("datasource")>
	<cfset datasource = caller.datasource>
</cfif>

<!--- loolkup schedule and guestvisit --->
<cfquery datasource="#datasource#" name="qGuestVisit">
	select * from guestvisits
	where g_barcode = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#attributes.dashPass#" />
</cfquery>

<cfquery datasource="#datasource#" name="qSchedule">
	select * from schedule 
	where v_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#qGuestVisit.v_id#" />
</cfquery>

<cftransaction action="BEGIN">
<cfquery datasource="#datasource#" name="insertVisit">
	insert into Visits (
		v_id,	entrypointid,	g_barcode,	g_checkedin,	g_id,	staff_id
	) 
	values( 
		<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#qGuestVisit.v_id#" />,
		<cfif isDefined("session.entrypointid") AND VAL(session.entrypointid)>
			<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.entrypointid#" />
		<cfelse>
			0
		</cfif>,
		<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#attributes.dashPass#" />,
		<cfqueryparam value="#request.timezoneadjustednow#" cfsqltype="CF_SQL_TIMESTAMP">,
		<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#qGuestVisit.g_id#" />,
		<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.staff_id#" />		
	)
</cfquery>
<cfquery datasource="#datasource#" name="insertVisit">
	update guestvisits set g_checkedin = current_timestamp
	where v_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#qGuestVisit.v_id#" />
</cfquery>
</cftransaction>