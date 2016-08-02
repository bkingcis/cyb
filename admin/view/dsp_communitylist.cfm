<table width="92%" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td class="header">Cybatrol Master Administrative Console</td><td><table width="92%" cellpadding="0" cellspacing="0" border="0">
<tr>
	<td align="right"><a href="index.cfm">logout</a></td>
</tr>
</table></td>
	</tr>
</table>
	<button onclick="self.location='admin.cfm?fa=cmspagelist'">Manage Page Content</button><br>
<cfoutput>
<script language="JavaScript">
	function selectAll() {
		<cfloop from="1" to="#qCommunityList.recordcount#" index="i">document.getElementById('chkRSItem#i#').checked = true;</cfloop>
		document.getElementById('sentToAll').value = 1;
	}
	function clearAll() {
		<cfloop from="1" to="#qCommunityList.recordcount#" index="i">document.getElementById('chkRSItem#i#').checked = false;</cfloop>
		document.getElementById('sentToAll').value = 0;
	}
	
	function submitMessage(obj) {
		document.getElementById('fa').value = 'sendMessage';
		obj.form.submit();			
	}
	
	function resetMessageStatus() {
	 	document.getElementById('messageText').value = '';
		document.getElementById('messageSubject').value = '';
		document.getElementById('messageSendBtn').disabled = true;
	}
</script>
<cfif isDefined("session.message") AND LEN(session.message)><div class="alert"><cfoutput>#session.message#</cfoutput></div><cfset session.message = ""></cfif>	
<form action="#request.self#" method="post" >
<input type="Hidden" id="fa" name="fa" value="CommunityList">
<fieldset style="margin:10px;"><legend style="font-size: 12px; font-weight:600; font-family:Arial;">Communities</legend>

<div id="tableContainer" style="border:1px solid black;height:300px;overflow-y:scroll;overflow-x:hidden;" width="80%">
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<thead><tr>
		<th width="30">&nbsp;&nbsp;</th>
		<th>Community</th>
		<th>Homesites</th>
		<th>Last Capture</th>				
		<th>Next Capture</th>
		<th>Active</th>
		<th>Dash Pass</th>
		<!--- <th>Map</th> --->	
		<th>Special Event(s)</th>			
		<!--- <th>Dash Direct</th> --->
		<th>Capture</th>	
		
		<th>&nbsp;</th>						
		</tr>
	</thead>
	<tbody style="overflow-x:hidden;" >
			<cfloop query="qCommunityList">
				<cfset qEventTypes = CommunityObj.getEventTypes(qCommunityList.c_id)>
				<cfset lastCapture = captureObj.getLastDate(qCommunitylist.c_id)>
				<cfif NOT isDate(lastCapture)>
					<cfset nextCapture = dateAdd("d",90,qCommunityList.insertdate)>
				<cfelse>
					<cfset nextCapture = dateAdd("d",90,lastCapture)>
				</cfif>
				
				<tr class="#iif(qCommunityList.currentrow mod 2,de("dataB"),de("dataA"))#" 
					onmouseover="this.className='rowHover'"
					onmouseout="this.className='#iif(qCommunityList.currentrow mod 2,de("dataB"),de("dataA"))#'">
				<td><input type="checkbox" id="chkRSItem#qCommunityList.currentrow#" name="communityList" value="#qCommunityList.c_id#"></td>
				<td	onclick="self.location='#request.self#?fa=editCommunity&c_id=#qCommunityList.c_id#'"><strong>#qCommunityList.c_name#</strong><br>#qCommunityList.c_city#, #qCommunityList.c_state#</td>
				<td align="center" onclick="self.location='#request.self#?fa=editCommunity&c_id=#qCommunityList.c_id#'">#qCommunityList.homesiteCount# / #val(qCommunityList.maxHomesites)#</td>					
				<td align="center" onclick="self.location='#request.self#?fa=editCommunity&c_id=#qCommunityList.c_id#'">#dateFormat(lastCapture,"mm/dd/yyyy")#<br>#timeFormat(lastCapture,"hh:mm:ss")#</td>
				<td align="center" onclick="self.location='#request.self#?fa=editCommunity&c_id=#qCommunityList.c_id#'"> #dateFormat(nextCapture,"mm/dd/yyyy")#<br>#timeFormat(nextCapture,"hh:mm:ss")#</td>
				<td align="center" onclick="self.location='#request.self#?fa=editCommunity&c_id=#qCommunityList.c_id#'"><cfif val(qcommunitylist.c_active)><img src="img/newCheck.png"><cfelse>&nbsp;</cfif></td>
				<td align="center" onclick="self.location='#request.self#?fa=editCommunity&c_id=#qCommunityList.c_id#'"><cfif val(qcommunitylist.dashpass)><img src="img/newCheck.png"><cfelse>&nbsp;</cfif></td>
				<!--- <td align="center" onclick="self.location='#request.self#?fa=editCommunity&c_id=#qCommunityList.c_id#'"><cfif val(qcommunitylist.dashpass_map)><img src="img/newCheck.png"><cfelse>&nbsp;</cfif></td> --->
				<td align="center" onclick="self.location='#request.self#?fa=editCommunity&c_id=#qCommunityList.c_id#'"><cfif qEventTypes.recordcount><img src="img/newCheck.png"><cfelse>&nbsp;</cfif></td>
				<!--- <td align="center" onclick="self.location='#request.self#?fa=editCommunity&c_id=#qCommunityList.c_id#'"><cfif val(qcommunitylist.dashdirect)><img src="img/newCheck.png"><cfelse>&nbsp;</cfif></td> --->
				<td align="center" onclick="self.location='#request.self#?fa=editCommunity&c_id=#qCommunityList.c_id#'"><cfif val(qcommunitylist.history)><img src="img/newCheck.png"><cfelse>&nbsp;</cfif></td>
				<td><a href="admin.cfm?fa=delCommunity&c_id=#qCommunityList.c_id#">del</a>&nbsp;</td>
			</tr>
			</cfloop>
		</tbody>
		</table>
</div>
	<table style="margin-bottom: 10px;" align="center" cellpadding="0" cellspacing="0" width="92%">
		<tbody><tr>
			<td>
			<input value="Select All" type="button" onclick="selectAll();"> &nbsp; 
				<input value="Clear" type="button" onclick="clearAll();"> &nbsp;
			</td>
			<td style="border-bottom: 0px none;" align="right">
				
				 
				<input type="button" value="Add Community" onclick="self.location='#request.self#?fa=newCommunity'"> &nbsp; 
				<cfquery dbtype="query" name="qFilterList">
					select distinct 
						<cfif NOT isDefined("form.stateFilter")>
							c_state as filterVal from qCommunityList
						<cfelse>
							c_county as filterVal from qCommunityList
							where c_state = '#form.stateFilter#'
						</cfif>						
						order by filterVal
				</cfquery>
				<cfif NOT isDefined("form.statefilter")>
				
				<select name="statefilter" onchange="this.form.submit()">
					<option> - filter by state - </option>
					<cfloop query="qFilterList">
					<option>#qFilterList.filterval#</option>
					</cfloop>
				</select>
				
				<cfelse>
				<input type="hidden" name="stateFilter" value="#form.statefilter#">
				<select name="countyfilter" onchange="this.form.submit()">
					<option> - filter by county - </option>
					<cfloop query="qFilterList">
					<option>#qFilterList.filterval#</option>
					</cfloop>
				</select>
				
				</cfif>
				
				<select name="sortBy">
					<option> - sort by  - </option>
					<option>Community Name</option>		
					<option>Next Capture</option>
				</select>
				
				
				<cfif isDefined("form.statefilter")><br /><a href="#request.self#" style="font-size:12pt;">view all</a></cfif>
			</td>
		</tr>
	</tbody></table>
</cfoutput>
<br style="clear:both;" />
<fieldset>
	<legend>Message Center</legend>
	<table width="92%" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td class="messageCenter">
				<span class="txt">Subject</span><br />
				<input type="text" name="messageSubject" id="messageSubject" style="width:420px;" onchange="document.getElementById('messageSendBtn').disabled = false;"><br>
				
				<span class="txt">Message</span><br />
				
				<input type="hidden" name="senttoall" id="sentToAll" value="0"> 
				<textarea name="messageText" id="messageText"  style="border:1px solid;width:420px;height:140px;"></textarea><br>
				
				<input value="Send Message to Selected Communities" id="messageSendBtn" type="Button" onclick="submitMessage(this);" disabled="true">
				<input type="Button" value="Clear" onclick="resetMessageStatus();">
			</td>
		</tr>
	</table>
</fieldset>
		</form>
