	<CFIF session.user_id EQ 0>
	    <cflocation URL="/residents/">
	<CFELSE>
		<cfinclude template="header.cfm">
		<cftry>
			<cfquery name="getAbook" datasource="#datasource#">
				select * from guests
				where g_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#url.g_id#" /> 
				 <!--- and r_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_id#" /> ---> 
			</cfquery>
			<cfquery name="qEntryPoints" datasource="#datasource#">
				select *
				FROM communityentrypoints
				WHERE c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(GetCommunity.c_id)#" />
			</cfquery>
			<cfquery name="qHistory" datasource="#datasource#">
				select ep.label as entrypointlabel,v.g_checkedin,v.*,s.staff_fname,s.staff_lname
				FROM visits v JOIN staff s on s.staff_id = v.staff_id
					LEFT JOIN communityentrypoints ep on ep.entrypointid = v.entrypointid
					WHERE	v.g_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#url.g_id#" />
				order by g_checkedin desc
			</cfquery>
		<cfcatch><cfdump var="#cfcatch#"><cfabort></cfcatch>
		</cftry>
		<cfoutput><strong><!-- ACCESS HISTORY: -->
		 #ucase(getAbook.g_lname)#<cfif len(getAbook.g_lname) and len(getAbook.g_fname)>,</cfif> #ucase(getAbook.g_fname)#</strong></cfoutput><br /><br />
		<cfif qHistory.recordcount>
			<cfset request.dashpasshasbeenused = true>
			<div style="height: 320px;overflow: auto;">
				<table class="table table-hover">
				  <thead>
					<tr>
					  <cfif GetCommunity.DashPass IS 'YES'><td>DashPass</td></cfif>
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
					</tr></cfoutput>
				  </tbody>
				</table>
			</div>
		<cfelse>
			<div class="well"><strong>No Visits Recorded</strong></div><br />
			<br />	
		</cfif>
	</div>
</cfif>