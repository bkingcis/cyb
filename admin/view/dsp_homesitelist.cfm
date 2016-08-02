<script type="">
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
</script>

<h2 class="demoHeaders">Manage Your Community</h2>
<div class="tabs">
	<ul>
		<li><a href="#tabs-1">Homesites</a></li>
		<li><a href="#tabs-2">Banners</a></li>
		<li><a href="#tabs-3">Messages</a></li>
		<li><a href="#tabs-4">Staff Users</a></li>
	</ul>
	<div id="tabs-1"><!--- <legend style="font-size: 16px; font-weight:600; font-family:Arial;">Current Homesites</legend> --->
		<cfset qHomesites = caller.qHomesites>
		<cfoutput>
		<div class="accordion">
			<div>
				<h3><a href="##">Current Homesites</a></h3>
				<div>
				<table width="100%">
					<tr>
					<th class="community">Primary Resident</th>
					<th>Number of Users</th>
					<th>Address</th>
					<th>Main Phone</th>
				</tr>
					<cfloop query="qHomesites">
						<cfquery  name="qResCount" datasource="#request.dsn#">
							select count(*) as counter
							from residents where h_id = #qHomesites.h_id#								
						</cfquery>
					<tr class="#iif(qHomesites.currentrow mod 2,de("dataB"),de("dataA"))#" onmouseover="this.className='rowHover'" onmouseout="this.className='#iif(qHomesites.currentrow mod 2,de("dataB"),de("dataA"))#'">
						<td><a href="#request.self#?fa=editHomesite&h_id=#qHomesites.h_id#" style="font-weight:600;">#ucase(qHomesites.h_Lname)#<!--- , #ucase(qHomesites.h_fname)# ---></a></td>
						<td align="center"><a href="#request.self#?fa=editResidents&h_id=#qHomesites.h_id#" style="font-weight:600;">#qResCount.counter#</a></td>
						<td align="center">#h_address#<cfif len(h_unitnumber)> Unit #h_unitnumber#</cfif></td>
						<td align="center">#h_phone#</td>							
					</tr>
					</cfloop>
				</table>
			
				<table width="92%" style="margin-bottom:10px;" align="center" cellpadding="0" cellspacing="0">
					<tr>
						<td style="border-bottom:0px;" align="right">
							<input type="button" value="Add Homesite" onclick="self.location='#request.self#?fa=newHomeSite'"> &nbsp; 
						</td></cfoutput>
					</tr>
				</table>
				</div>
			</div><!-- end first accordian block -->
		</div><!-- end of accordian -->			
	</div>	<!-- end of tab 1 -->		
	<div id="tabs-2">
		<cfparam name="residentSignInMessage" default="Default Resident Sign In Message">
		<cfparam name="DashPassMessage" default="Default Dash Pass Message">
		<cfparam name="staffSignInMessage" default="Default Staff Sign In Message">
		<cfparam name="dashDirectMessage" default="Default Dash Direct Message">
		
		
		<div class="accordion">
			<div>
				<h3><a href="#">Resident Login Banner</a></h3>
				<div>			
					<cfquery datasource="#request.dsn#" name="qresidentSignInMessage">
						select 	*
						from	communitymessages
						where 	fieldname = 'residentSignInMessage'
						and 	c_id = #session.user_community#
						order by messageDate desc,message_id desc
						limit 1
					</cfquery>
					<cfoutput>				
					<form action="#request.self#?fa=updateCommMessage" method="post" onsubmit="ResidentSignInEditor.saveHTML()">
					<textarea name="messageText" id="ResidentSignInMessageText" rows="10" cols="160">#qresidentSignInMessage.messageText#</textarea>
					<input type="hidden" name="fieldname" value="residentSignInMessage"><input type="hidden" name="message_id" value="#qresidentSignInMessage.message_id#">
					<br /><a href="javascript:viewHistory('residentSignInMessage')">view resident message history</a> <input type="submit" value="Save"></form>
					</cfoutput>
				</div>
			</div>
			<div>
				<h3><a href="#">Staff Login Page Banner</a></h3>
				<div>		
					<cfquery datasource="#request.dsn#" name="qstaffSignInMessage">
						select 	*
						from	communitymessages
						where 	fieldname = 'staffSignInMessage'
						and 	c_id = #session.user_community#
						order by messageDate desc,message_id desc
						limit 1
					</cfquery>
			
					<cfoutput><form action="#request.self#?fa=updateCommMessage" method="post" onsubmit="StaffSignInEditor.saveHTML()">
					<textarea name="messageText" id="StaffSignInMessageText" rows="10" cols="160">#qstaffSignInMessage.messageText#</textarea>
					<input type="hidden" name="fieldname" value="staffSignInMessage"><input type="hidden" name="message_id" value="#qstaffSignInMessage.message_id#">
					<br /><a href="javascript:viewHistory('staffSignInMessage')">view staff sign-in message history</a> <input type="submit" value="Save"></form></cfoutput>
				</div>
			</div>	
		<cfif val(caller.qCommunity.dashpass)>
			<div>									
				<h3><a href="#">DashPass Message Box Left</a></h3>
				<div>			
					<cfquery datasource="#request.dsn#" name="qDashPassMessage">
						select 	*
						from	communitymessages
						where 	fieldname = 'DashPassMessage'
						and 	c_id = #session.user_community#
						order by messageDate desc,message_id desc
						limit 1
					</cfquery>  
				
					<cfoutput><form action="#request.self#?fa=updateCommMessage" method="post" onsubmit="DashPassMessageEditor.saveHTML()">
					<textarea name="messageText" id="DashPassMessageText"  rows="10" cols="160">#qDashPassMessage.messageText#</textarea>
					<input type="hidden" name="fieldname" value="DashPassMessage"><input type="hidden" name="message_id" value="#qDashPassMessage.message_id#">
					<br /><a href="javascript:viewHistory('DashPassMessage');">view DashPass message history</a> <input type="submit" value="Save">
		            </form></cfoutput>
				</div>
			</div>
			<div>					
				<h3><a href="#">DashPass Message Box Right</a></h3>
				<div>
					<cfquery datasource="#request.dsn#" name="qDashPassMessage2">
						select 	*
						from	communitymessages
						where 	fieldname = 'DashPassMessage2'
						and 	c_id = #session.user_community#
						order by messageDate desc,message_id desc
						limit 1
					</cfquery>	
		    		<cfoutput>
					<form action="#request.self#?fa=updateCommMessage" method="post" onsubmit="DashPassMessage2TextEditor.saveHTML()">
					<textarea name="messageText" id="DashPassMessage2Text" rows="10" cols="160">#qDashPassMessage2.messageText#</textarea>
					<input type="hidden" name="fieldname" value="DashPassMessage2"><input type="hidden" name="message_id" value="#qDashPassMessage2.message_id#">
					<br /><a href="javascript:viewHistory('DashPassMessage2');">view DashPass message history</a> <input type="submit" value="Save"></form>
					</cfoutput>
				</div>
			</div><!-- end fourth accordian block -->
			</cfif>
			
		</div><!-- end accordian -->
	</div>
	<div id="tabs-3">
		<cfif isDefined("session.message") AND LEN(session.message)><div class="alert"><cfoutput>#session.message#</cfoutput></div><cfset session.message = ""></cfif>	
		<cfquery datasource="#request.dsn#" name="qNotifications">
	        select * from adminMessageContent m join adminMessageRecipients r
			on m.messageid = r.messageid
	        order by insertdate desc
	    </cfquery>	
		<cfoutput>
		<div class="accordion">
		<div>
			<h3><a href="##">Messages</a></h3>
			<div>
		<table width="100%">
			<tr>
				<th class="community">Date</th>
				<th class="community">Subject</th>
			</tr>
			<cfloop query="qNotifications">
			<tr class="#iif(qNotifications.currentrow mod 2,de("dataB"),de("dataA"))#" onclick="viewMessage(#qNotifications.messageid#)" onmouseover="this.className='rowHover'" onmouseout="this.className='#iif(qNotifications.currentrow mod 2,de("dataB"),de("dataA"))#'">
				<td width="180" class="<cfif qNotifications.acknowledgedby eq 0>emailUnread<cfelse>emailRead</cfif>"><a href="javascript:viewMessage(#qNotifications.messageid#)" style="font-weight:600;">#dateFormat(qNotifications.insertDate,"m/d/yyyy")# - #TimeFormat(qNotifications.insertDate,"h:m tt")#</a></td>
				<td align="left" class="<cfif qNotifications.acknowledgedby eq 0>emailUnread<cfelse>emailRead</cfif>"><a href="javascript:viewMessage(#qNotifications.messageid#)" style="font-weight:600;">#qNotifications.messageSubject#</a></td>						
			</tr>
			</cfloop>
		</table>
		</cfoutput></div>
		</div>
		</div>
	</div>
	<div id="tabs-4">
	<div class="accordion">
		<div>
			<h3><a href="##">Current Staff Users</a></h3>
			<div><div class="messageLeft">
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
		</cfoutput>
	</div>
	</div>
	</div>
</div>
