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
	
	
	
	function navigateTabs(tab) {
	var navtab1 = document.getElementById('navtab1');
	var navtab2 = document.getElementById('navtab2');
	var navtab3 = document.getElementById('navtab3');
	
		if (tab == '1') {
				window.location='admin.cfm?fa=communityMessages';
		}
		if (tab == '2') {
				window.location='admin.cfm?fa=banners';
				}
				
		if (tab == '3') {
				window.location='admin.cfm?fa=homesites';
				}
				
		if (tab == '4') {
				window.location='admin.cfm?fa=staffhome';
			}
		  
	}
</script>
<ul style="list-style:none;" id="navTabs">
<li id="navtab1"><a href="#" onclick="navigateTabs(1);">Messages</a></li><!--- <img align="middle" src="img/grey-nav-edge.png" style="margin: -10px -25px 0 0;">--->
<li id="navtab2"><a href="#" onclick="navigateTabs(2);">Banners</a></li>
<li class="current" id="navtab3"><a href="#" onclick="navigateTabs(3);">Homesites</a></li>
<li id="navtab4"><a href="#" onclick="navigateTabs(4);">Staff Users</a></li>
</ul>
<div style="clear:both;border-bottom:5px solid #999;margin: 0 11px 10px 11px;"></div><br />
<div id="currenthomesitebox">
<cfoutput>	
	<div style="text-align:center;font-size:13px;font-weight:600">Homesite Residents</div>	
			<div id="homeContent" style="width:770px;">
				<table>
					<tr>
						<td colspan=2> &nbsp;</td>
							<td>Last</td>
						<td>First</td>
						<td>E-Mail</td>
					</tr>
					<tr>
						<td>Primary (locked)</td><td><input type="Checkbox" id="res1chkpass" name="res1chkpass" value="#qResidents.r_id[1]#" /></td>
						<td><strong>#ucase(qResidents.r_lname[1])#</strong></td>
						<td><strong>#ucase(qResidents.r_fname[1])#</strong></td>
						<td>#qResidents.r_email[1]#</td>
						<td>&nbsp;</td>
					</tr>
					<form action="admin.cfm?fa=saveResident" method="post" name="res2">
					<input type="hidden" id="r_id2" name="r_id" value="#qResidents.r_id[2]#" /><input type="Hidden" name="h_id" value="#url.h_id#">
					<tr>
						<td>Resident 2</td><td><input type="Checkbox" id="res2chkpass" name="res2chkpass" value="#qResidents.r_id[2]#" /></td>
						<td><input type="text" name="r_lname" maxlength="50" class="txtField"<cfif qResidents.recordcount gt 1> value="#ucase(qResidents.r_lname[2])#"</cfif>></td>
						<td><input type="text" name="r_fname" maxlength="50" class="txtField"<cfif qResidents.recordcount gt 1> value="#ucase(qResidents.r_fname[2])#"</cfif>></td>
						<td><input type="text" name="r_email" maxlength="50" class="txtField"<cfif qResidents.recordcount gt 1> value="#qResidents.r_email[2]#"</cfif>></td>
						<td><input type="submit" name="saveRes2" value="#iif(len(qResidents.r_lname[2]),DE('edit'),DE('add'))#"></td>
					</tr>
					</form>
					<script language="JavaScript">			
						<!--//
						objForm = new qForm("res2");
						objForm.required("r_lname,r_fname,r_email");objForm.r_lname.description = "Last Name";objForm.r_fname.description = "First Name";objForm.r_email.description = "Email Address";
						//-->
					</script> 
					<form action="admin.cfm?fa=saveResident" method="post" name="res3">
					<input type="hidden" id="r_id3" name="r_id" value="#qResidents.r_id[3]#" /><input type="Hidden" name="h_id" value="#url.h_id#">
					<tr>
						<td>Resident 3</td><td><input type="Checkbox" id="res3chkpass" name="res3chkpass" value="#qResidents.r_id[3]#" /></td>
						<td><input type="text" name="r_lname" maxlength="50" class="txtField"<cfif qResidents.recordcount gt 2> value="#ucase(qResidents.r_lname[3])#"</cfif>></td>
						<td><input type="text" name="r_fname" maxlength="50" class="txtField"<cfif qResidents.recordcount gt 2> value="#ucase(qResidents.r_fname[3])#"</cfif>></td>
						<td><input type="text" name="r_email" maxlength="50" class="txtField"<cfif qResidents.recordcount gt 2> value="#qResidents.r_email[3]#"</cfif>></td>
						<td><input type="submit" name="saveRes3" value="#iif(len(qResidents.r_lname[3]),DE('edit'),DE('add'))#"></td>
					</tr>
					</form>
					<script language="JavaScript">			
						<!--//
						objForm = new qForm("res3");
						objForm.required("r_lname,r_fname,r_email");objForm.r_lname.description = "Last Name";objForm.r_fname.description = "First Name";objForm.r_email.description = "Email Address";
						//-->
					</script> 
					<form action="admin.cfm?fa=saveResident" method="post" name="res4">
					<input type="hidden" id="r_id4" name="r_id" value="#qResidents.r_id[4]#" /><input type="Hidden" name="h_id" value="#url.h_id#">
					<tr>
						<td>Resident 4</td><td><input type="Checkbox" id="res4chkpass" name="res4chkpass" value="#qResidents.r_id[4]#" /></td>
						<td><input type="text" name="r_lname" maxlength="50" class="txtField"<cfif qResidents.recordcount gt 3> value="#ucase(qResidents.r_lname[4])#"</cfif>></td>
						<td><input type="text" name="r_fname" maxlength="50" class="txtField"<cfif qResidents.recordcount gt 3> value="#ucase(qResidents.r_fname[4])#"</cfif>></td>
						<td><input type="text" name="r_email" maxlength="50" class="txtField"<cfif qResidents.recordcount gt 3> value="#qResidents.r_email[4]#"</cfif>></td>
						<td><input type="submit" name="saveRes4" value="#iif(len(qResidents.r_lname[4]),DE('edit'),DE('add'))#"></td>
					</tr>
					</form>
					<script language="JavaScript">			
						<!--//
						objForm = new qForm("res4");
						objForm.required("r_lname,r_fname,r_email");objForm.r_lname.description = "Last Name";objForm.r_fname.description = "First Name";objForm.r_email.description = "Email Address";
						//-->
					</script> 
					<form action="admin.cfm?fa=saveResident" method="post" name="res5">
					<input type="hidden" id="r_id5" name="r_id" value="#qResidents.r_id[5]#" /><input type="Hidden" name="h_id" value="#url.h_id#">
					<tr>
						<td>Resident 5</td><td><input type="Checkbox" id="res5chkpass" name="res5chkpass" value="#qResidents.r_id[5]#" /></td>
						<td><input type="text" name="r_lname" maxlength="50" class="txtField"<cfif qResidents.recordcount gt 4> value="#ucase(qResidents.r_lname[5])#"</cfif>></td>
						<td><input type="text" name="r_fname" maxlength="50" class="txtField"<cfif qResidents.recordcount gt 4> value="#ucase(qResidents.r_fname[5])#"</cfif>></td>
						<td><input type="text" name="r_email" maxlength="50" class="txtField"<cfif qResidents.recordcount gt 4> value="#qResidents.r_email[5]#"</cfif>></td>
						<td><input type="submit" name="saveRes5" value="#iif(len(qResidents.r_lname[5]),DE('edit'),DE('add'))#"></td>
					</tr></form>
					<script language="JavaScript">			
						<!--//
						objForm = new qForm("res5");
						objForm.required("r_lname,r_fname,r_email");objForm.r_lname.description = "Last Name";objForm.r_fname.description = "First Name";objForm.r_email.description = "Email Address";
						//-->
					</script> 
				</table><cfif isDefined("session.message") AND LEN(session.message)><div class="alert">#session.message#</div><cfset session.message = ""></cfif>
				<input type="button" value="reset and send password" onclick="verifyselectionsandsend();">
		</div>
	</div>
	
<form name="passResetForm" action="admin.cfm?fa=resetPasswords" method="post"><input type="hidden" id="passResetList" name="passResetList"><input type="Hidden" name="h_id" value="#url.h_id#"></form>
				<a href="admin.cfm?fa=homesites">Back</a>
</cfoutput>