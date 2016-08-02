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
<cfquery datasource="#datasource#" name="getLatestVisit">
	select visit_id, g_checkedout from Visits
	where v_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#attributes.v_id#" />
	order by visit_id desc Limit 1
</cfquery>
<cfif NOT LEN(getLatestVisit.g_checkedout)>
	<cfquery datasource="#datasource#" name="insertVisit">
		update Visits set g_checkedout = <cfqueryparam value="#request.timezoneadjustednow#" cfsqltype="CF_SQL_TIMESTAMP">
		where visit_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(getLatestVisit.visit_id)#" />
	</cfquery>
<cfelse>
	<cfif NOT isDefined('request.guid')>
		<cfset request.guid = createuuid()>
	</cfif>
	<cfquery datasource="#datasource#" name="insertVisit">
		insert INTO Visits (g_checkedout,v_id,g_id,staff_id,guid,g_barcode,entrypointid) 
		values (
			<cfqueryparam value="#request.timezoneadjustednow#" cfsqltype="CF_SQL_TIMESTAMP">,
			<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#attributes.v_id#" />,
			<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#qGuestVisit.g_id#" />,
			<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.staff_id#" />,	
			<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#request.guid#" />,
			<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#qGuestVisit.g_barcode#" />,
		<cfif isDefined("session.entrypointid") AND VAL(session.entrypointid)>
			<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(session.entrypointid)#" />
		<cfelse>
			0
		</cfif>)
	</cfquery>
</cfif>