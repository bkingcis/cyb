
	<h2 style="font: 16px 'Trebuchet MS', sans-serif;font-weight:bold;">Personnel Users</h2>
	<ul>
				<li>To add a new personnel user, click ADD PERSONNEL USER.</li>
				<li>To edit an existing personnel user, view their login data or change their status, click on the personnel user's name.</li>
				<li>To view the log in data for ALL personnel users, click on the PERSONNEL SIGN-IN LOG tab.</li></ul>
<div class="accordion">
		<div>
			<h3><a href="#">Current Personnel</a></h3>
		
			<div style="height:300px;overflow:auto;">
			
			<table width="99%" bgcolor="#ffffff" cellpadding="0" cellspacing="0" border="0" style="margin:2px;">
				<tr>
					<th>Name</th>
					<!--- <th>ID</th> --->
					<th>Username</th>
					<th>Status</th>
				</tr>
				<cfif qStaffList.recordcount>
				<!--- sort by status --->
					<cfoutput query="qStaffList">
					<tr onclick="staffPopulate(#staff_id#,'#staff_lname#','#staff_fname#','#staff_Username#',#active#,#staff_level#)"
						class="#iif(qStaffList.currentrow mod 2,de("dataB"),de("dataA"))#" onmouseover="this.className='rowHover'" onmouseout="this.className='#iif(qStaffList.currentrow mod 2,de("dataB"),de("dataA"))#'">
						<td align="center"><a href="forms/staffuser.cfm?staff_id=#staff_id#&height=440&width=540" class="thickbox" style="font-weight:600;">#ucase(staff_lname)#, #ucase(staff_fname)#</a></td>
						<!--- <td>#staff_employeenumber#</td> --->
						<td align="center">#staff_Username#</td>
						<td align="center">
						<cfif staff_level eq 2>Admin/<cfif NOT val(active)>/</cfif></cfif><cfif val(active)>Active<cfelse>Inactive</cfif>
						</td>
					</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="3" align="center">You currently have no personnel users</td>
					</tr>
				</cfif>
				<tr>
					<td colspan="3" align="center">&nbsp;</td>
				</tr><tr>
					<td colspan="3" align="center">&nbsp;</td>
				</tr>
			</table>
			<p><a href="forms/staffuser.cfm?height=440&width=540" id="dialog_link" class="thickbox ui-state-default ui-corner-all"><span class="ui-icon ui-icon-newwin"></span>Add Personnel User</a></p>
		
		</div>
	</div>
	
	<div>
		<h3><a href="#">Personnel Sign-In Log</a></h3>
		<div style="height:300px;overflow:auto;">		
			<cfparam name="url.historySort" default="timestamp desc">
			<cfquery datasource="cybatrol" name="qStaffHistory">
				select log.staffID, log.entryPointID, log.timestamp, log.action, s.staff_fname, 
				s.staff_lname,e.label as entrypoint
				from staffuselog log join staff s on log.staffid = s.staff_id
				left join communityentrypoints e on e.entrypointid = log.entrypointid
				where s.c_id = #session.user_Community#
				ORDER by #url.HistorySort#
			</cfquery>
		<cfoutput>
		<table width="99%" bgcolor="##ffffff" cellpadding="0" cellspacing="0" border="0" style="margin:2px;">
		<tr>
			<th>Name 
				<cfif url.historySort is "staff_lname DESC">
				<a href="index.cfm?historysort=staff_lname"><img border="0" src="/admin/img/arrow_up.png"></a>
				<cfelse>
				<a href="index.cfm?historysort=staff_lname DESC"><img border="0" src="/admin/img/arrow_dn.png"></a>
				</cfif>
				</th><th>Gate 				
				<cfif url.historySort is "entrypoint DESC">
				<a href="index.cfm?historysort=entrypoint"><img border="0" src="/admin/img/arrow_up.png"></a>
				<cfelse>
				<a href="index.cfm?historysort=entrypoint DESC"><img border="0" src="/admin/img/arrow_dn.png"></a>
				</cfif></th>
				<th>Action <cfif url.historySort is "action DESC">
				<a href="index.cfm?historysort=action"><img border="0" src="/admin/img/arrow_up.png"></a>
				<cfelse>
				<a href="index.cfm?historysort=action DESC"><img border="0" src="/admin/img/arrow_dn.png"></a>
				</cfif></th><th>Time/Date 
				<cfif url.historySort is "timestamp DESC">
				<a href="index.cfm?historysort=timestamp"><img border="0" src="/admin/img/arrow_up.png"></a>
				<cfelse>
				<a href="index.cfm?historysort=timestamp DESC"><img border="0" src="/admin/img/arrow_dn.png"></a>
				</cfif></th>
		</tr>
		<cfloop query="qStaffHistory">
			<tr class="#iif(qStaffHistory.currentrow mod 2,de("dataB"),de("dataA"))#" onmouseover="this.className='rowHover'" onmouseout="this.className='#iif(qStaffHistory.currentrow mod 2,de("dataB"),de("dataA"))#'">
			<td>#ucase(qStaffHistory.staff_fname)# #ucase(qStaffHistory.staff_lname)#</td>
			<td align="center">#ucase(qStaffHistory.entrypoint)#</td>
			<td align="center">#ucase(qStaffHistory.action)#</td>
			<td align="center">#DateFormat(qStaffHistory.timestamp, "mm/dd/yyyy")# #TimeFormat(qStaffHistory.timestamp, "hh:mm:ss tt")#
			</td>
			</tr>			
		</cfloop>
		</table>
		</div><!--- overflow div --->
		</cfoutput>
	</div>
</div>