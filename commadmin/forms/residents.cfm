<cfimport prefix="security" taglib="../../admin/security"><security:community>
<cfif isDefined("form.r_id")>
<cfif val(form.r_id)>
	<cfset result = residentObj.update(form.r_id,form.r_fname,"",form.r_lname,form.r_altphone,form.r_email)>
<cfelse>
	<cfset result = residentObj.create(session.user_community,form.h_id,form.r_fname,"",form.r_lname,form.r_altphone,form.r_email)>
	<cfset residentObj.createInitialPass(result)>
</cfif>
<cflocation url="/commadmin/">
</cfif>

<cfset qCommunity = CommunityObj.read(session.user_community)><cfset qResidents = residentObj.read(url.h_id)><cfoutput>
	<div class="accordionF">
		<div><h3>Edit Resident Users</h3>
			<div><br>
				<table width="600">
					<tr>
						<td width="10">&nbsp;</td>
						<td width="140">&nbsp;</td>
						<td width="100">Last</td>
						<td width="100">First</td>
						<td width="180">E-Mail</td>
						<td>Phone</td>
					</tr>
				</table>
				<form action="forms/residents.cfm" method="post" name="res1">
				<input type="hidden" id="r_id1" name="r_id" value="#qResidents.r_id[1]#" />
				<input type="Hidden" name="h_id" value="#url.h_id#" />
				<table>							
					<tr>
						<td width="10"><input type="Checkbox" id="res1chkpass" name="res1chkpass" value="#qResidents.r_id[1]#" /></td>
						<td width="140">Primary <br>(locked)</td>				
						<input type="hidden" name="r_fname" <cfif qResidents.recordcount>value="#ucase(qResidents.r_fname[1])#"</cfif>>
						<input type="hidden" name="r_lname" <cfif qResidents.recordcount>value="#ucase(qResidents.r_lname[1])#"</cfif>>
						<td width="100"><input type="text" disabled="disabled" name="last" maxlength="50" style="width:90px;"<cfif qResidents.recordcount>value="#ucase(qResidents.r_lname[1])#"</cfif>></td>
						<td width="100"><input type="text" disabled="disabled" name="first" maxlength="50" style="width:90px;"<cfif qResidents.recordcount>value="#ucase(qResidents.r_fname[1])#"</cfif>></td>
						<td width="180"><input type="text" name="r_email" maxlength="50" style="width:160px;"<cfif qResidents.recordcount>value="#qResidents.r_email[1]#"</cfif>></td>
						<td width="100"><input type="text" name="r_altphone" maxlength="50" style="width:90px;"<cfif qResidents.recordcount>value="#qResidents.r_altphone[1]#"</cfif>></td>
						<td><input value="Save" type="submit"></td>
					</tr>
				</table>
				</form>	
				<form action="forms/residents.cfm" method="post" name="res2">					
					<input type="hidden" id="r_id2" name="r_id" value="#qResidents.r_id[2]#" />					
					<input type="Hidden" name="h_id" value="#url.h_id#">
					<table>
						<tr>
							<td width="10"><input type="Checkbox" id="res2chkpass" name="res2chkpass" value="#qResidents.r_id[2]#" /></td>
							<td nowrap>Resident 2</td>
							<td width="90"><input type="text" name="r_lname" maxlength="50" style="width:90px;"<cfif qResidents.recordcount gt 1>value="#ucase(qResidents.r_lname[2])#"</cfif>></td>
							<td width="90"><input type="text" name="r_fname" maxlength="50" style="width:90px;"<cfif qResidents.recordcount gt 1>value="#ucase(qResidents.r_fname[2])#"</cfif>></td>
							<td width="180"><input type="text" name="r_email" maxlength="50" style="width:160px;"<cfif qResidents.recordcount gt 1>value="#qResidents.r_email[2]#"</cfif>></td>						
							<td width="100"><input type="text" name="r_altphone" maxlength="50" style="width:90px;"<cfif qResidents.recordcount gt 1>value="#qResidents.r_altphone[2]#"</cfif>></td>
							<td width="90"><input type="submit" name="saveRes2" value="#iif(len(qResidents.r_lname[2]),DE('Edit'),DE('Add'))#"></td>
						</tr>
					</table>
				</form>
				<form action="forms/residents.cfm" method="post" name="res3">					
					<input type="hidden" id="r_id3" name="r_id" value="#qResidents.r_id[3]#" />					
					<input type="Hidden" name="h_id" value="#url.h_id#">
					<table>
						<tr>
							<td width="10"><input type="Checkbox" id="res3chkpass" name="res3chkpass" value="#qResidents.r_id[3]#" /></td>
							<td nowrap>Resident 3</td>
							<td width="90"><input type="text" name="r_lname" maxlength="50" style="width:90px;"<cfif qResidents.recordcount gt 2>value="#ucase(qResidents.r_lname[3])#"</cfif>></td>
							<td width="90"><input type="text" name="r_fname" maxlength="50" style="width:90px;"<cfif qResidents.recordcount gt 2>value="#ucase(qResidents.r_fname[3])#"</cfif>></td>
							<td width="180"><input type="text" name="r_email" maxlength="50" style="width:160px;"<cfif qResidents.recordcount gt 2>value="#qResidents.r_email[3]#"</cfif>></td>						
							<td width="100"><input type="text" name="r_altphone" maxlength="50" style="width:90px;"<cfif qResidents.recordcount gt 2>value="#qResidents.r_altphone[3]#"</cfif>></td>
							<td width="90"><input type="submit" name="saveRes3" value="#iif(len(qResidents.r_lname[3]),DE('Edit'),DE('Add'))#"></td>
						
						</tr>
					</table>
				</form>
				<form action="forms/residents.cfm" method="post" name="res4">					
					<input type="hidden" id="r_id4" name="r_id" value="#qResidents.r_id[4]#" />					
					<input type="Hidden" name="h_id" value="#url.h_id#">
					<table width="600">
						<tr>
							<td width="10"><input type="Checkbox" id="res4chkpass" name="res4chkpass" value="#qResidents.r_id[4]#" /></td>
							<td width="60" nowrap>Resident 4</td>
							<td width="100"><input type="text" name="r_lname" maxlength="50" style="width:90px;"<cfif qResidents.recordcount gt 3>value="#ucase(qResidents.r_lname[4])#"</cfif>></td>
							<td width="100"><input type="text" name="r_fname" maxlength="50" style="width:90px;"<cfif qResidents.recordcount gt 3>value="#ucase(qResidents.r_fname[4])#"</cfif>></td>
							<td width="180"><input type="text" name="r_email" maxlength="50" style="width:160px;"<cfif qResidents.recordcount gt 3>value="#qResidents.r_email[4]#"</cfif>></td>						
							<td width="100"><input type="text" name="r_altphone" maxlength="50" style="width:90px;"<cfif qResidents.recordcount gt 3>value="#qResidents.r_altphone[4]#"</cfif>></td>
							<td><input type="submit" name="saveRes4" value="#iif(len(qResidents.r_lname[4]),DE('Edit'),DE('Add'))#"></td>
						</tr>
					</table>
				</form>
				<form action="forms/residents.cfm" method="post" name="res5">					
					<input type="hidden" id="r_id5" name="r_id" value="#qResidents.r_id[5]#" />					
					<input type="Hidden" name="h_id" value="#url.h_id#">
					<table width="600">
						<tr>
							<td width="10"><input type="Checkbox" id="res5chkpass" name="res5chkpass" value="#qResidents.r_id[4]#" /></td>
							<td width="60" nowrap>Resident 5</td>
							<td width="100"><input type="text" name="r_lname" maxlength="50" style="width:90px;"<cfif qResidents.recordcount gt 4>value="#ucase(qResidents.r_lname[5])#"</cfif>></td>
							<td width="100"><input type="text" name="r_fname" maxlength="50" style="width:90px;"<cfif qResidents.recordcount gt 4>value="#ucase(qResidents.r_fname[5])#"</cfif>></td>
							<td width="180"><input type="text" name="r_email" maxlength="50" style="width:160px;"<cfif qResidents.recordcount gt 4>value="#qResidents.r_email[5]#"</cfif>></td>						
							<td width="100"><input type="text" name="r_altphone" maxlength="50" style="width:90px;"<cfif qResidents.recordcount gt 4>value="#qResidents.r_altphone[5]#"</cfif>></td>
							<td><input type="submit" name="saveRes5" value="#iif(len(qResidents.r_lname[4]),DE('Edit'),DE('Add'))#"></td>
						</tr>
					</table>
				</form><cfif isDefined("session.message") AND LEN(session.message)>
				<div class="alert">	#session.message#
				</div><cfset session.message = ""></cfif>	<br>
							
				<input type="button" value="reset and send password" onclick="verifyselectionsandsend();">
			</div>
		</div>
		<form name="passResetForm" action="processor/resetPasswords.cfm" method="post">			
			<input type="hidden" id="passResetList" name="passResetList">			
			<input type="Hidden" name="h_id" value="#url.h_id#">
		</form></cfoutput>
	</div>
<script language="JavaScript">
	function verifyselectionsandsend() {
		var listtoupdate = 0;
		
		if (document.getElementById('res1chkpass').checked == true) {
			listtoupdate = listtoupdate + ',' + document.getElementById('res1chkpass').value;
		}
		if (document.getElementById('res2chkpass').checked == true) {
			listtoupdate = listtoupdate + ',' + document.getElementById('res2chkpass').value;
		}
		if (document.getElementById('res3chkpass').checked == true) {
			listtoupdate = listtoupdate + ',' + document.getElementById('res3chkpass').value;
		}
		if (document.getElementById('res4chkpass').checked == true) {
			listtoupdate = listtoupdate + ',' + document.getElementById('res4chkpass').value;
		}
		if (document.getElementById('res5chkpass').checked == true) {
			listtoupdate = listtoupdate + ',' + document.getElementById('res5chkpass').value;
		}
		
		document.getElementById('passResetList').value = listtoupdate;
		
		if (confirm('are you sure you want to change the password(s) and send email(s)?')) {
			document.passResetForm.submit();}
		else return false;
	}
	//$(".accordionF").accordion({ header: "h3" });
</script>