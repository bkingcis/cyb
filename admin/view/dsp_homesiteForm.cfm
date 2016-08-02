<script language="JavaScript">
	
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
<div style="clear:both;border-bottom:5px solid #666; margin: 0 11px 10px 11px;"></div><br />
<div id="currenthomesitebox"  style="width:770px;">
<cfoutput>

	<div style="text-align:center;font-size:13px;font-weight:600"><cfif url.h_id eq 0>New<cfelse>Edit</cfif> Homesite</div>	
			<div id="homeContent">
			<cfif url.h_id neq 0 and isdate(qhomesite.insertdate)>
			<div style="text-align:right;color:green">Active Account Since #dateFormat(qhomesite.insertdate,"mmmm d, yyyy")#</div>
			</cfif>
			<form name="hsForm" action="#request.self#" method="post">
				<input type="Hidden" name="fa" id="fuseaction" value="#xfa.submitform#">
				<input type="hidden" name="h_id" value="#qhomesite.h_id#"><!--- homesite id --->
				<input type="hidden" name="r_id" value="#qhomesite.r_id#"><!--- resident id --->
				<input type="hidden" name="c_id" value="#qhomesite.c_id#"><!--- community id --->
				<table width="92%" cellpadding="0" cellspacing="0" border="0" style="border: 2px solid white">
					<tr>
						<td>
							Main Surname<br>
							<input type="text" name="h_lname" id="h_lname" maxlength="60" class="txtField" value="#ucase(qHomesite.h_lname)#">
						</td>
						<td>
							First<br>
							<input type="text" name="r_fname" id="r_fname" maxlength="60" class="txtField" value="#ucase(qHomesite.r_fname)#"><!--- #qHomesite.h_fname# --->
						</td>
						<td>
							M/I<br>
							<input name="r_middleinitial" maxlength="1" type="text" class="txtField" value="#ucase(qHomesite.r_middleinitial)#">
						</td>
					</tr>
					<tr>
						<td>
							Resident Address<br>
							<input type="text" name="h_address" maxlength="100" class="txtField" value="#qHomesite.h_address#">
						</td>
						<td colspan="2">
							Unit ##<br>
							<input name="h_unitnumber" maxlength="12" type="text" class="txtField" value="#qHomesite.h_unitnumber#">
						</td>
					</tr>
					<!--- <tr><td colspan="3"><cfdump var="#qCommunity#"></td></tr> --->
					<tr>
						<td>
							City<br><cfif LEN(trim(qHomesite.h_city))><cfset cityVal = qHomesite.h_city><cfelse><cfset cityVal = qCommunity.c_city></cfif>
							<input type="text" name="h_city" maxlength="60" class="txtField" value="#cityVal#">
						</td>
						<td>
							State<br><cfif LEN(trim(qHomesite.h_state))><cfset stateVal = qHomesite.h_state><cfelse><cfset stateVal = qCommunity.c_state></cfif>
							<input type="text" name="h_state" class="txtField" maxlength="2" value="#stateVal#">
						</td>
						<td>
							Zip Code<br><cfif LEN(trim(qHomesite.h_zipcode))><cfset zipVal = qHomesite.h_zipcode><cfelse><cfset zipVal = qCommunity.c_zipcode></cfif>
							<input type="text" name="h_zipcode" class="txtField" maxlength="6" value="#zipVal#">
						</td>
					</tr>
					<tr>
						<td>
							Main Telephone<br>
							<input type="text" name="h_phone_part1" class="txtZip" maxlength="3" value="#listFirst(qHomesite.h_phone,".")#"> <input name="h_phone_part2" type="text" class="txtZip" maxlength="3" value="<cfif listLen(qhomesite.h_phone,".") gt 1>#listGetAt(qHomesite.h_phone,2,".")#</cfif>"> <input name="h_phone_part3" type="text" class="txtZip"class="txtZip" maxlength="4" value="<cfif listLen(qhomesite.h_phone,".") gt 2>#listGetAt(qHomesite.h_phone,3,".")#</cfif>"> 
						</td>
						<td colspan="2">
							Email<br>
							<input type="text" name="r_email" id="r_email" class="txtField" maxlength="160" class="txtField" value="#qHomesite.R_EMAIL#">
						</td>
					</tr>
					<tr>
						<td colspan="3">
							Auxillary Telephone<br>
							<input type="text" name="R_ALTPHONE_part1" class="txtZip" maxlength="3" value="#listFirst(qHomesite.R_ALTPHONE,".")#"> <input name="R_ALTPHONE_part2" type="text" class="txtZip" maxlength="3" value="<cfif listLen(qhomesite.R_ALTPHONE,".") gt 1>#listGetAt(qHomesite.R_ALTPHONE,2,".")#</cfif>"> <input name="R_ALTPHONE_part3" type="text" class="txtZip"class="txtZip" maxlength="4" value="<cfif listLen(qhomesite.R_ALTPHONE,".") gt 2>#listGetAt(qHomesite.R_ALTPHONE,3,".")#</cfif>"> 												</td>
					</tr>
				</table>
				
		<!--- <strong>Notes:</strong><br>
				<textarea name="h_notes" cols="55" rows="6">#qHomesite.h_notes#</textarea>
				  --->
				<div style="text-align:right;">
				<cfif NOT ucase(qHomesite.h_lname) is 'VACANT' AND NOT qHomesite.h_lname is ''>
				<input type="button" style="color:red" onclick="moveOutBtnClick(this);" value="Vacate Homesite">
				</cfif>
				<input type="button" style="color:green" onclick="saveThisHomesite(this);" value="Save Homesite"></div>
				</form>
				
			<cfif qVacancyHistory.recordcount>
			<div class="messageCenter">
				<div style="text-align:center;font-size:13px;font-weight:600">Previous Occupant(s)</div>
				<div class="homeTabsStyle">
					<div id="aboutTab7" style="text-align: right; height: 185px;overflow-x:auto;margin-bottom:2px;">
					<table width="99%" bgcolor="##ffffff" cellpadding="0" cellspacing="0" border="0" style="margin:2px;">
					<tr>
						<th>Date Removed</th><th>Name</th>
					</tr>
					<cfloop query="qVacancyHistory">
						<tr class="#iif(qVacancyHistory.currentrow mod 2,de("dataB"),de("dataA"))#" onmouseover="this.className='rowHover'" onmouseout="this.className='#iif(qVacancyHistory.currentrow mod 2,de("dataB"),de("dataA"))#'">
							<td align="center">#DateFormat(qVacancyHistory.vacancydate, "mm/dd/yyyy")# #TimeFormat(qVacancyHistory.vacancydate, "hh:mm:ss tt")#</td>
							<td>#ucase(qVacancyHistory.h_lname)#</td>
						</tr>			
					</cfloop>
					</table>
					</div>
				</div>
			</div>
			</cfif>	
				<script type="text/javascript">
					function moveOutBtnClick(buttonObj) {
						if(confirm('Are You Sure?')){
							document.getElementById('fuseaction').value='homeSiteMoveOut';
							buttonObj.form.submit();
						}
					}
					
					function saveThisHomesite(buttonObj) {
						//form validation needed
						if (document.getElementById('h_lname').value==''||document.getElementById('h_lname').value=='VACANT'){
								alert('Please supply a valid Main Surname for this homesite');
								document.getElementById('h_lname').focus();
								return false;
							}
						if (document.getElementById('r_fname').value==''||document.getElementById('r_fname').value=='VACANT'){
								alert('Please supply a valid First Name for this homesite');
								document.getElementById('r_fname').focus();
								return false;
							}
						if (document.getElementById('r_email').value.indexOf('@')>1){
							document.getElementById('fuseaction').value='#xfa.submitform#';
							buttonObj.form.submit();
						}
						else { 							
								alert('Please supply a valid Email address for this homesite');
								document.getElementById('r_email').focus();
								return false;
							}
						
						
					}
				</script>
			</div><br>
			<a href="admin.cfm?fa=homesites">Back</a>
	
</div></cfoutput>
