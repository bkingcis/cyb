
		<cfquery name="getAbook" datasource="#datasource#">
			select * from guests
			where g_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#url.id#" />
		</cfquery>
<div align="center" class="staffHeader2">ACCESS HISTORY:</div><br />
		<cfoutput>
		<h4>#ucase(getAbook.g_lname)#, #ucase(getAbook.g_fname)#</h4>
		</cfoutput>
		<cfquery name="qHistory" datasource="#datasource#">
			select g.label as entrypointlabel,v.g_checkedin,v.g_barcode,s.staff_fname,s.staff_lname, v.entrypointid
			FROM visits v JOIN staff s on s.staff_id = v.staff_id
				LEFT JOIN communityentrypoints g on g.entrypointid = v.entrypointid
			WHERE g_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#url.id#" />
			order by g_checkedin desc
		</cfquery>

	<cfif qHistory.recordcount>
		<cfquery name="qEntryPoints" datasource="#datasource#">
			select *
			FROM communityentrypoints
			WHERE c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(GetCommunity.c_id)#" />
		</cfquery>
			<cfset request.dashpasshasbeenused = true>
				<table class="table table-hover">
				<thead>
					<tr>
					  <cfif GetCommunity.DashPass IS 'YES'><th>DashPass</th></cfif>
					  <th>Access Date and Time</th>
					  <th>Staff Member</th>
					  <cfif qEntryPoints.recordcount gt 1><th>Entry Point</th></cfif>
					 </tr>	
				 </thead>
				 <tbody>
					<cfoutput query="qHistory">
					<tr>
						<cfif GetCommunity.DashPass IS 'YES'><td>#qHistory.g_barcode#</td></cfif>
						<td>#DateFormat(qHistory.g_checkedin,"mm/dd/yyyy")# &nbsp; #TimeFormat(qHistory.g_checkedin,"hh:mm:ss tt")#</td>
						<td>#ucase(qHistory.staff_lname)#, #ucase(qHistory.staff_fname)#</td>
						<cfif qEntryPoints.recordcount gt 1><td>#qHistory.entrypointlabel#</td></cfif>
					</tr>
					</cfoutput>
				</tbody>
			</table>

		<cfelse>
			<div align="center"><strong>No Visits Recorded</strong></div><br />
			<br />	
		</cfif>
