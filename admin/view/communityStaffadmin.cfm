<script language="JavaScript">
	function staffPopulate(staff_id,staff_lname,staff_fname,staff_email,active,staff_level){
		document.getElementById('staff_id').value=staff_id;
		document.getElementById('staff_lname').value=staff_lname;
		document.getElementById('staff_fname').value=staff_fname;
		document.getElementById('staff_email').value=staff_email;
		document.getElementById('staffSaveBtn').value='Update Staff User';
		document.getElementById('staffEmailBtn').disabled=false;
		if (active){document.getElementById('status_active').checked=true;}
		else {document.getElementById('status_inactive').checked=true;}
		document.getElementById('fuseaction').value='updateStaffUser';
		if (staff_level == 2){
				document.getElementById('status_active').disabled=true;
				document.getElementById('status_inactive').disabled=true;
			}
		else {
				document.getElementById('status_active').disabled=false;
				document.getElementById('status_inactive').disabled=false;
			}
	}
	
	
	function viewHistory(fieldname) {
		window.open('messageHistory.cfm?fieldname='+fieldname,'msg','location=0,width=400,height=400,status=1,toolbar=1,scrollbars=1');
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
<li id="navtab3"><a href="#" onclick="navigateTabs(3);">Homesites</a></li>
<li class="current" id="navtab4"><a href="#" onclick="navigateTabs(4);">Staff Users</a></li>
</ul>
<div style="clear:both;border-bottom:5px solid #999;margin: 0 11px 18px 11px;"></div>
<div id="staffeditbox">
<fieldset style="margin:10px;border: 0px;">
<!--- <legend style="font-size: 16px; font-weight:600; font-family:Arial;">Staff Users</legend> --->
<div class="messageLeft">
	
	<div style="text-align:center;font-size:13px;font-weight:600">Current Staff Users</div>
	<div class="homeTabsStyle">
		<div id="aboutTab5" style="text-align: right; height: 185px;overflow-x:auto;margin-bottom:2px;">
			<table width="99%" bgcolor="#ffffff" cellpadding="0" cellspacing="0" border="0" style="margin:2px;">
				<tr>
					<th>Name</th>
					<!--- <th>ID</th> --->
					<th>Username</th>
					<th>Status</th>
				</tr>
				<cfif caller.qStaffList.recordcount>
				<!--- sort by status --->
					<cfoutput query="caller.qStaffList">
					<tr onclick="staffPopulate(#staff_id#,'#staff_lname#','#staff_fname#','#staff_Username#',#active#,#staff_level#)"
						class="#iif(caller.qStaffList.currentrow mod 2,de("dataB"),de("dataA"))#" onmouseover="this.className='rowHover'" onmouseout="this.className='#iif(caller.qStaffList.currentrow mod 2,de("dataB"),de("dataA"))#'">
						<td>#ucase(staff_fname)# #ucase(staff_lname)#</td>
						<!--- <td>#staff_employeenumber#</td> --->
						<td>#staff_Username#</td>
						<td align="center">
						<cfif staff_level eq 2>
							ADMIN
						<cfelse>
							<cfif val(active)>ACTIVE<cfelse>INACTIVE</cfif>
						</cfif>
						</td>
					</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="3" align="center">You currently have no staff users</td>
					</tr>
				</cfif>
				<tr>
					<td colspan="3" align="center">&nbsp;</td>
				</tr><tr>
					<td colspan="3" align="center">&nbsp;</td>
				</tr>
			</table>
		</div>
	</div>						
</div>

<cfoutput>
<div class="messageRight">
	<div style="text-align:center;font-size:13px;font-weight:600">Enter Staff Users</div>
	<div class="homeTabsStyle">
		<div id="aboutTab6"><table width="99%" bgcolor="##ffffff" cellpadding="0" cellspacing="0" border="0" style="margin:2px;">
		<tr><td><form name="staffEditfrm" action="#request.self#" method="post">
		<input type="hidden" id="fuseaction" name="fuseaction" value="insertStaffUser">
		<input type="hidden" id="staff_id" name="staff_id" value="0">
		<span class="txt">Name:</span><br>
		<input type="text" name="staff_fname" id="staff_fname" value="first" class="txtField" onfocus="this.value=''"> 
		<input type="text" value="last" name="staff_lname" id="staff_lname"  onfocus="this.value=''" class="txtField">
		<!--- <cfif NOT val(caller.qCommunity.autoIdentifyStaff)>
		<br>
		<span class="txt">Staff/Employee Number:</span><br>
				<input type="text" name="staff_employeenumber" id="staff_employeenumber" class="txtField" onchange="document.getElementById('messageSendBtn').disabled = false;">
		</cfif> --->	<br>
			<span class="txt">Email:</span><br>
				<input type="text" name="staff_email" id="staff_email" class="txtSubject" onchange="document.getElementById('messageSendBtn').disabled = false;">
			<!--- <br><span class="txt">Username/Password:</span><br>
				<input type="text" name="staff_username" id="staff_username" class="txtField">/<input type="password" name="staff_password" id="staff_password" class="txtField">
			 ---><br><span class="txt">Status:</span><br> 
				<input type="radio" id="status_active" name="active" value="true" checked="checked"> Active
				<input type="radio" id="status_inactive" name="active" value="false"> Inactive
			<br>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td><input type="Button" id="staffSaveBtn" value="Add Staff User" onclick="checkSubmitStaff(this);"></td>
					<td align="right"><input type="Button" id="staffEmailBtn" value="Reset Password" disabled="true" onclick="document.getElementById('fuseaction').value='#caller.xfa.resetStaffPass#';this.form.submit()"></td>
				</tr>
			</table></td></tr></table></form>
			
			<script type="text/javascript">
				function checkSubmitStaff(buttonObj) {
					if (document.getElementById('staff_fname').value=='first'||document.getElementById('staff_fname').value==''){
						alert('Please Complete Staff Name Field to Continue');
					 	document.getElementById('staff_fname').focus();
					}
					else 
					{
						if (document.getElementById('staff_email').value!=''){
						 buttonObj.form.submit()
						 }
						else { alert('Please Complete Email Field to Continue');
						 document.getElementById('staff_email').focus();
						 }
					 }
				 }
			</script>
		</div>
	</div>
</div>
<br style="clear:both"/><br />
	<div class="messageLeft">
	<div style="text-align:center;font-size:13px;font-weight:600">Staff Access History</div>
	<div class="homeTabsStyle">
		<cfquery datasource="cybatrol" name="qStaffHistory">
			select log.staffID, log.entryPointID, log.timestamp, log.action, s.staff_fname, 
			s.staff_lname,e.label as entrypoint
			from staffuselog log join staff s on log.staffid = s.staff_id
			left join communityentrypoints e on e.entrypointid = log.entrypointid
			where s.c_id = #session.user_Community#
			ORDER by #url.HistorySort#
		</cfquery>
		<div id="aboutTab7" style="text-align: right; height: 185px;overflow-x:auto;margin-bottom:2px;">
		<table width="99%" bgcolor="##ffffff" cellpadding="0" cellspacing="0" border="0" style="margin:2px;">
		<tr>
			<th>Name 
				<cfif url.historySort is "staff_lname DESC">
				<a href="admin.cfm?fa=staffhome&historysort=staff_lname"><img border="0" src="img/arrow_up.png"></a>
				<cfelse>
				<a href="admin.cfm?fa=staffhome&historysort=staff_lname DESC"><img border="0" src="img/arrow_dn.png"></a>
				</cfif>
				</th><th>Gate 				
				<cfif url.historySort is "entrypoint DESC">
				<a href="admin.cfm?fa=staffhome&historysort=entrypoint"><img border="0" src="img/arrow_up.png"></a>
				<cfelse>
				<a href="admin.cfm?fa=staffhome&historysort=entrypoint DESC"><img border="0" src="img/arrow_dn.png"></a>
				</cfif></th>
				<th>Action <cfif url.historySort is "action DESC">
				<a href="admin.cfm?fa=staffhome&historysort=action"><img border="0" src="img/arrow_up.png"></a>
				<cfelse>
				<a href="admin.cfm?fa=staffhome&historysort=action DESC"><img border="0" src="img/arrow_dn.png"></a>
				</cfif></th><th>Time/Date 
				<cfif url.historySort is "timestamp DESC">
				<a href="admin.cfm?fa=staffhome&historysort=timestamp"><img border="0" src="img/arrow_up.png"></a>
				<cfelse>
				<a href="admin.cfm?fa=staffhome&historysort=timestamp DESC"><img border="0" src="img/arrow_dn.png"></a>
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
		</div>
	</div>
	</div>
</div>



</cfoutput>
</fieldset>
	<script type="text/javascript">
	<!--//
		//initializetabcontent("homeTab");
		//initializetabcontent("homeTab");	
		//initializetabcontent("homeTab2");
		//initializetabcontent("homeTab3");
		//initializetabcontent("homeTab4");
		//initializetabcontent("homeTab5");
		//initializetabcontent("homeTab6");	
	
	// initialize the qForm object
	objForm = new qForm("staffEditfrm");	
	// make these fields required
	objForm.required("staff_fname,staff_lname,staff_email");
	objForm.staff_fname.description = "First Name";
	objForm.staff_lname.description = "Last Name";
	objForm.staff_email.description = "Email Address";
	//-->
</script>