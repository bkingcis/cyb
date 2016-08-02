<table width="92%" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td class="header">Web Site Page Content Management</td>
	</tr>
</table>
<div id="tableContainer" style="border:1px solid black;height:300px;overflow-y:scroll;overflow-x:hidden;" width="80%">
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<thead><tr>
		<th width="30">Delete</th>
		<th>Page Title</th>
		<th width="80%">&nbsp;&nbsp;</th>						
		</tr>
	</thead>
	<tbody style="overflow-x:hidden;" >
	<cfquery dbtype="query" name="qeditable">
		select * from qPageList 
		Where editable = 'true'
	</cfquery>
			<cfoutput query="qeditable">
			<tr class="#iif(qeditable.currentrow mod 2,de("dataB"),de("dataA"))#" 
					onmouseover="this.className='rowHover'"
					onmouseout="this.className='#iif(qeditable.currentrow mod 2,de("dataB"),de("dataA"))#'">
				<td><input type="checkbox" id="chkRSItem#qeditable.currentrow#" name="communityList" value="#qeditable.id#"></td>
				<td	onclick="self.location='#request.self#?fa=cmseditPage&id=#qeditable.id#'"><strong>#qeditable.pagetitle#</strong></td>
				<td>&nbsp;&nbsp;</td>
			</tr>
			</cfoutput>
		</tbody>
		</table>
</div>

<a href="/admin/admin.cfm">Admin Home</a> | <a href="/admin/admin.cfm?fa=cmspagelist">Content Mgmt Home</a>