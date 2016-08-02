<cfparam name="url.staff_id" default="0">
<cfquery datasource="#request.dsn#" name="qUser">
	select * from staff
	where staff_id = <cfqueryparam value="#url.staff_id#" cfsqltype="CF_SQL_INTEGER">
</cfquery>
<cfoutput>
	<div style="margin: 0 auto; text-align:center;font-size:13px;font-weight:600"><cfif val(url.staff_id)><!--- Edit ---><cfelse>ENTER</cfif> PERSONNEL USER</div>
	<div style="margin: 0 auto;width:300px;>
	<table width="60%" bgcolor="##ffffff" cellpadding="0" cellspacing="0" border="0" style="margin:2px;">
		<tr><td><form name="staffEditfrm" action="processor/staffuser.cfm" method="post">
		<input type="hidden" id="fuseaction" name="fuseaction" value="saveStaffUser">
		<input type="hidden" id="staff_id" name="staff_id" value="#Quser.staff_id#">
		<table  cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td>Last Name:<br />						
			<input type="text" name="staff_lname" id="staff_lname"  value="#Quser.staff_fname#" class="txtField">
			</td>
			<td>First Name:<br />
			<input type="text" name="staff_fname" id="staff_fname" class="txtField" value="#Quser.staff_lname#"> 
			</td>
		</tr>
		<tr>
			<td colspan="2">
			Email:<br />
			<input type="text" name="staff_email" id="staff_email" value="#Quser.staff_Username#" size="38">
			</td>
		</tr>
		</table>
		
			<br><span class="txt">Status:</span><br> 
				<input type="radio" id="status_active" name="active" value="true" <cfif val(quser.active) OR Quser.staff_id is ''>checked="checked"</cfif>> Active
				<input type="radio" id="status_inactive" name="active" value="false" <cfif NOT val(quser.active) AND Quser.staff_id neq ''>checked="checked"</cfif>> Inactive
			<br><br>		
				<cfif qUser.recordcount>
				<cfset btnTextLableSave = "Save">
				<cfelse><cfset btnTextLableSave = "Add Staff User">
				</cfif>
				<input type="Button" id="staffSaveBtn" value="#btnTextLableSave#" onclick="checkSubmitStaff(this);">
				<cfif val(url.staff_id)><input type="Button" id="staffEmailBtn" value="Reset Password" onclick="document.getElementById('fuseaction').value='resetStaffPass';this.form.submit()"></cfif></td>
			</tr>
		</table></form>
		</div>
		</cfoutput>	
		<cfif val(url.staff_id)> <!--- only show use log when an existing user is displayed --->
		<cfinclude template="../inc/userlog.cfm">
		</cfif>
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