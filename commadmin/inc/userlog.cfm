<cfquery datasource="#request.dsn#" name="qUserLog">
	select sl.*, e.label from staffuselog sl 
		left join communityentrypoints e on e.entrypointid = sl.entrypointid
	where  sl.staffid = <cfqueryparam value="#url.staff_id#" cfsqltype="CF_SQL_INTEGER">
	order by sl.timestamp desc
</cfquery>
<div style="margin: 14px auto 0px; text-align:center;font-size:13px;font-weight:600">LOG HISTORY</div>	
<div style="margin: 0 auto;width: 95%;height:190px;overflow:auto;width:300px;border:1px solid silver;">
<table width="100%">
	<tr style="background-color: #8AF;">
		<th>&nbsp;Action</th><th>&nbsp;&nbsp;Entry Gate</th><th>&nbsp;&nbsp;&nbsp;&nbsp;Timestamp</th>
	</tr>
	<cfoutput query="qUserLog">
		<cfif qUserLog.action is 'login'>
			<cfset rowclass="loginRow">
		<cfelse>
			<cfset rowclass="logoutRow">
		</cfif>
		<tr>
			<td class="#rowclass#">#qUserLog.action#</td>
			<td class="#rowclass#">#qUserLog.label#</td>
			<td class="#rowclass#">#dateFormat(qUserLog.timestamp,'m/d/yyyy')# #timeFormat(qUserLog.timestamp)#</td>
		</tr>
	</cfoutput>
</table>
</div>

<style>
	.loginRow {
		color: green;
		background-color: #efefef;
	}
	.logoutRow {
		color: red;
		background-color: #efefef;
	}
</style>