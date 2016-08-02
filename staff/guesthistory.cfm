
<cftry><cfset timezoneadj = session.timezoneadj>
<cfquery name="getCommunity" datasource="#request.dsn#">
	select * from communities 
	where c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#" />
</cfquery>
<cfquery name="qHistory" datasource="#request.dsn#">
	select g.label as entrypointlabel,v.g_checkedin,v.G_checkedout,
		v.g_barcode,s.staff_fname,s.staff_lname, v.entrypointid, v.visit_id,
		v.licensePlateStateCode,v.licensePlateNumber
	FROM visits v JOIN staff s on s.staff_id = v.staff_id
		LEFT JOIN communityentrypoints g on g.entrypointid = v.entrypointid
	WHERE v_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#attributes.v_id#" />
	order by v.visit_id desc
</cfquery>
<style>
	.notcheckedinRow {background-color:#e6e6e6;}
	.notcheckedinRowHover {background-color:#fff;}
</style>

<h2 style="font-weight:bold;color:#000;font-size:16px;border-bottom:1px solid silver;">Access History:</h2>
	
<cfif qHistory.recordcount>
<cfquery name="qEntryPoints" datasource="#request.dsn#">
	select *
    FROM communityentrypoints
	WHERE c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#" />
</cfquery>
	<cfset request.dashpasshasbeenused = true>
	<div style="height: 100px;overflow: auto; border: 1px solid silver;width: 90%;margin:0 auto 0 auto;">
		<table width="100%" style="margin:auto;border-collapse:collapse;" border="1">
		<tr bgcolor="#bbbbbb">
		<cfif getCommunity.dashpass><td><strong>DashPass</strong></td></cfif>
		<td><strong>Access Date and Time</strong></td>
		<cfif getCommunity.checkoutoption><td><strong>Check-Out Date and Time</strong></td></cfif>
		<td><strong>Staff Member</strong></td>		
		<cfif qEntryPoints.recordcount gt 1><td><strong>Entry Point</strong></td></cfif>
		<cfif val(getCommunity.recordlicenseplateonallvisits)><td><strong>License Plate</strong></td></cfif>
		</tr>	
		<cfoutput query="qHistory" group="visit_id">
		<!--- <tr style="background-color: ##eee;"> --->
		<tr class="notcheckedinRow" onmouseover="this.className='checkedinRowHover';" onmouseout="this.className='notcheckedinRow';">
			<cfif getCommunity.dashpass><td>#g_barcode#</td></cfif>
			<td><cfif isDate(g_checkedin)>#DateFormat(g_checkedin,"mm/dd/yyyy")# &nbsp; #TimeFormat(g_checkedin,"hh:mm:ss tt")#<cfelse>Not Recorded</cfif></td>
			<cfif getCommunity.checkoutoption><td><cfif isDate(g_checkedout)>#DateFormat(g_checkedout,"mm/dd/yyyy")# &nbsp; #TimeFormat(g_checkedout,"hh:mm:ss tt")#<cfelse>Not Recorded</cfif></td></cfif>
			<td>#ucase(staff_lname)#, #ucase(staff_fname)#</td>
			<cfif qEntryPoints.recordcount gt 1><td>#ucase(entrypointlabel)#</td></cfif>
			<cfif val(getCommunity.recordlicenseplateonallvisits)><td>#ucase(licensePlateStateCode)#&nbsp; #ucase(licensePlateNumber)#</td></cfif>
		</tr>
		</cfoutput>
		
		<cfif NOT qHistory.recordcount>
			<tr>
				<td colspan="4" align="center">NO VISIT RECORDED</td>
			</tr>
		</cfif>
	</table>
	</div>
<cfelse><div align="center">NO VISIT RECORDED</div>
	<cfset request.dashpasshasbeenused = false>
</cfif>
<cfcatch><cfdump var="#cfcatch#">
</cfcatch>
</cftry>