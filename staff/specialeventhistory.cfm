<cfquery name="qEntryPoints" datasource="#request.dsn#">
	select *
    FROM communityentrypoints
	WHERE c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#" />
</cfquery>
<cfquery datasource="#datasource#" name="qHistory">
	select et.label, sev.entrypointid, cep.label as entrypointlabel, s.staff_lname, s.staff_fname,
		sev.g_checkedin,sev.licenseplatenumber,sev.licenseplatestatecode 
	from specialeventvisits sev join staff s on s.staff_id = sev.staff_id
	join specialevents se on sev.specialevent_id = se.specialevent_id
	join communityeventtypes et on se.eventtypeid = et.etid
	left join communityentrypoints cep on cep.entrypointid = sev.entrypointid
	WHERE sev.specialevent_id = #url.specialevent_id#
	ORDER BY g_checkedin desc
</cfquery>

<h2 style="font-weight:bold;color:#000;font-size:16px;border-bottom:1px solid silver;">Recorded Visits:</h2>
	<div style="height: 100px;overflow: auto; border: 1px solid silver;width: 90%;margin:0 auto 0 auto;">
		<table width="100%" style="margin:auto;border-collapse:collapse;" border="1">
		<tr bgcolor="#dddddd">
		<td>Event Type</td>
		<td>Access Date and Time</td>
		<td>Staff Member</td>		
		<cfif qEntryPoints.recordcount gt 1><td>Entry Point</td></cfif>
		<cfif val(getCommunity.recordlicenseplateonspecialevents)><td>License Plate</td></cfif>
		</tr>	
		<cfoutput query="qHistory">
		<tr>
			<td>#label#</td>
			<td><cfif isDate(g_checkedin)>#DateFormat(g_checkedin,"mm/dd/yyyy")# &nbsp; #TimeFormat(g_checkedin,"hh:mm:ss tt")#<cfelse>Not Recorded</cfif></td>
			<td>#ucase(staff_lname)#, #ucase(staff_fname)#</td>
			<cfif qEntryPoints.recordcount gt 1><td>#ucase(entrypointlabel)#</td></cfif>
			<cfif val(getCommunity.recordlicenseplateonspecialevents)><td>#ucase(licensePlateStateCode)#&nbsp; #ucase(licensePlateNumber)#</td></cfif>
		</tr>
		</cfoutput> 
	</table>
	</div>