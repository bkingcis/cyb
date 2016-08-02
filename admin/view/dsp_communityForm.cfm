
<script language="JavaScript">	
	
	<cfif isDefined('url.c_id')>function deleteCrest() {
		res=confirm('Are you sure you want to delete the community crest?');
		if (res==true) {
			<cfoutput>self.location='?fa=deleteCrest&c_id=#url.c_id#';</cfoutput>
		}
	}</cfif>
	function enableDashPassFeatures(obj) {
		if (obj.checked == true){
			document.getElementById('chkminipass').disabled=false;
			//document.getElementById('chkquickpass').disabled=false;
		 	document.getElementById('chkstandardpass').disabled=false;
		 document.getElementById('chkstandardpass').checked=true;
		}
		else {
		 document.getElementById('chkstandardpass').disabled=true;
		 document.getElementById('chkstandardpass').checked=false;
		 document.getElementById('chkminipass').disabled=true;
		 document.getElementById('chkminipass').checked=false;
		 //document.getElementById('chkquickpass').disabled=true;
		 //document.getElementById('chkquickpass').checked=false;
		 }
	} 
	function enableEventBoxes(obj) {
		if (obj.checked == true){
			document.getElementById('chkeventBox1').disabled=false;
			document.getElementById('chkeventBox2').disabled=false;
			document.getElementById('chkeventBox3').disabled=false;
			document.getElementById('chkeventBox4').disabled=false;
			document.getElementById('chkeventBox5').disabled=false;
		}
		else {
			document.getElementById('chkeventBox1').disabled=true;
			document.getElementById('chkeventBox1').checked=false;
			document.getElementById('chkeventBox2').disabled=true;
			document.getElementById('chkeventBox2').checked=false;
			document.getElementById('chkeventBox3').disabled=true;
			document.getElementById('chkeventBox3').checked=false;
			document.getElementById('chkeventBox4').disabled=true;
			document.getElementById('chkeventBox4').checked=false;
			document.getElementById('chkeventBox5').disabled=true;
			document.getElementById('chkeventBox5').checked=false;
			
			document.getElementById('eventOptLabel3').disabled=true;
			document.getElementById('eventOptInitial3').disabled=true;
			
			document.getElementById('eventOptLabel4').disabled=true;
			document.getElementById('eventOptInitial4').disabled=true;
			
			document.getElementById('eventOptLabel5').disabled=true;
			document.getElementById('eventOptInitial5').disabled=true;
			}
	}
	
	function activateEventOptions3(obj) {
		if (obj.checked == true){
			document.getElementById('eventOptLabel3').disabled=false;
			document.getElementById('eventOptInitial3').disabled=false;
		}
		else {
			document.getElementById('eventOptLabel3').disabled=true;
			document.getElementById('eventOptInitial3').disabled=true;
			}
	}
	function activateEventOptions4(obj) {
		if (obj.checked == true){
			document.getElementById('eventOptLabel4').disabled=false;
			document.getElementById('eventOptInitial4').disabled=false;
		}
		else {
			document.getElementById('eventOptLabel4').disabled=true;
			document.getElementById('eventOptInitial4').disabled=true;
			}
	}
	function activateEventOptions5(obj) {
		if (obj.checked == true){
			document.getElementById('eventOptLabel5').disabled=false;
			document.getElementById('eventOptInitial5').disabled=false;
		}
		else {
			document.getElementById('eventOptLabel5').disabled=true;
			document.getElementById('eventOptInitial5').disabled=true;
			}
	}
	
	function openWin(msg){
						 window.open("popup.cfm?show=message&messageid="+msg,null,"height=200,width=400,status=yes,toolbar=no,menubar=no,location=no")
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
<cfoutput><table width="92%" cellpadding="0" cellspacing="0" border="0">
<tr>
	<td align="right"><a href="index.cfm">logout</a></td>
</tr>
</table>
<p class="pSpacing" style="font-family:Arial;font-size:20px;">
<cfif isDefined("url.c_id") and val(url.c_id)>Edit<cfelse>Create New</cfif> Community<cfif isDefined("url.c_id") and val(url.c_id)>: <strong>#qCommunity.c_name#</strong></cfif></p>

<cfif isDefined("session.message") AND LEN(session.message)><div class="alert"><cfoutput>#session.message#</cfoutput></div><cfset session.message = ""></cfif>	
<div id="bottomContainer">
<!---  <ul id="homeTab" class="homeShadeTabs">
	<li class="selected"><a class="tab" href="##" rel="aboutTab">Community Details</a></li>
</ul>  --->
<div class="homeTabsStyle">
		
				<table width="100%" cellpadding="0" cellspacing="0" border="0" style="border: 1px solid ##c0c0c0">
					<tr>
						<th colspan="3">Community Details</th>
					</tr>
				<form name="mainCommfrm" action="#request.self#?fa=#xfa.submitForm#" method="post" enctype="multipart/form-data">
				<input type="hidden" name="c_id" value="#qCommunity.c_id#"> 
					<tr>
						<td valign="top" width="33%">
							Community Name<br />
							<input type="Text" name="c_name" size="40" value="#qCommunity.c_name#" maxlength="200"><br />
							<br />Web Site Short Name<br />
							<input type="Text" name="c_cname" size="40" value="#qCommunity.c_cname#" maxlength="60"><br />
							<a href="http://#qCommunity.c_cname#.cybatrol.com">http://#qCommunity.c_cname#.cybatrol.com</a>
							<br />
							<br />
							Community Crest<br />
							<cfif IsDefined("qCommunity.c_crest") and qCommunity.c_crest IS NOT "">
							<img src="/uploadimages/#qCommunity.c_crest#" align="absmiddle" width="100" hspace="2"> <a href="javascript:deleteCrest();">X delete</a><br /></cfif>
							<input type=file name="c_crest" size="30">
							<cfif IsDefined("qCommunity.c_crest") and qCommunity.c_crest IS NOT ""><br />(select new file to replace crest)</cfif>
							<br />
							<br />
							Select Time Zone<br />
							<select name="timeZone">
								<option<cfif qCommunity.timezone is "Eastern"> selected</cfif>>Eastern</option>
								<option<cfif qCommunity.timezone is "Central"> selected</cfif>>Central</option>
								<option<cfif qCommunity.timezone is "Mountain"> selected</cfif>>Mountain</option>
								<option<cfif qCommunity.timezone is "Pacific"> selected</cfif>>Pacific</option>
							</select>
							<br />Street Address<br />
							<input type="text" name="c_address" value="#qcommunity.c_address#" maxlength="100" class="txtField"><br />
							City / State/ Zip<br />
							<input type="text" name="c_city" value="#qcommunity.c_city#" maxlength="80" class="txtField"> <input type="text" class="txtState" maxlength="2" name="c_state" value="#qcommunity.c_state#"> <input type="text" name="c_zipcode" value="#qcommunity.c_zipcode#" maxlength="5" class="txtZip"><br />
							County<br />
							<input type="text" name="c_county" value="#qcommunity.c_county#" maxlength="80" class="txtField">						
							<br /><br />
								<strong>Maximum Number of Users/Homesites</strong><br />
							<input type="text" name="maxHomesites" class="txtZip" value="#qcommunity.maxHomesites#">
							(#qcommunity.homesiteCount# / #qcommunity.maxHomesites#)<br /><br />
							
						</td>
						<td valign="top" width="35%" >
					
						<cfset ohON = 0>
						<cfset gsON = 0>
						<cfset otherEvents = structNew()>
						<cfloop query="qEventTypes">
							<cfif trim(ucase(qeventtypes.abbreviation)) is "OH">
								<cfset ohON = 1>
							<cfelseif trim(ucase(qeventtypes.abbreviation)) is "GS">
								<cfset gsON = 1>
							<cfelse>
								<cfset structInsert(otherEvents,trim(qeventtypes.abbreviation),trim(qeventtypes.label))>
							</cfif>
						</cfloop>
						<cfset eventAbbrevArr = structKeyArray(otherEvents)>
						<!--- <cfdump var="#eventAbbrevArr#"> --->
									
						<strong>Options:</strong><br />						
							<input type="checkbox" name="c_active"<cfif val(qCommunity.c_active)> checked="checked"</cfif>> Active<br />
							<input type="checkbox" name="dashpass"<cfif val(qCommunity.dashpass)> checked="checked"</cfif> onclick="enableDashPassFeatures(this)"> Dash Pass<br />
							&nbsp; &nbsp; &nbsp; <input type="checkbox" id="chkstandardpass" name="standardpass"<cfif NOT val(qCommunity.minipass)> checked="true"</cfif><cfif NOT val(qCommunity.dashpass)> disabled="true"</cfif> onclick="this.checked = true;document.getElementById('chkminipass').checked=false;"> Standard Size &nbsp; <input type="checkbox" id="chkminipass" name="minipass"<cfif val(qCommunity.minipass)> checked="true"</cfif><cfif NOT val(qCommunity.dashpass)> disabled="true"</cfif> onclick="this.checked = true;document.getElementById('chkstandardpass').checked=false;"> MiniPass/Card Size<br />
							<input type="checkbox" id="chkrecordLicensePlate" name="recordLicensePlate"<cfif val(qCommunity.recordLicensePlate)> checked="true"</cfif>> Record License Plate<br />
							&nbsp; &nbsp; &nbsp; <input name="recordlicenseplateonallvisits" id="recordallTrue" type="checkbox" <cfif val(qCommunity.recordlicenseplateonallvisits)> checked="checked"</cfif> value="1" Onclick="document.getElementById('recordallFalse').checked=false"> All Visits  <input id="recordallFalse" name="recordlicenseplateonallvisits" type="checkbox"<cfif NOT val(qCommunity.recordlicenseplateonallvisits)> checked="checked"</cfif> value="0" Onclick="document.getElementById('recordallTrue').checked=false"> Initial Visit Only<br />
							&nbsp; &nbsp; &nbsp; <input name="recordlicenseplateonspecialevents" id="recordLPONspecialEvents" type="checkbox" <cfif val(qCommunity.recordlicenseplateonspecialevents)> checked="checked"</cfif> value="1">  Special Events<br />
							
							
							<input type="checkbox" id="chkquickpass" name="quickpass"<cfif val(qCommunity.quickpass)> checked="true"</cfif>> QuickPass<br />
							<!--- &nbsp; &nbsp; &nbsp; <input type="checkbox" id="chkdashpassmap" name="dashpass_map"<cfif val(qCommunity.dashpass_map)> checked="true"</cfif><cfif NOT val(qCommunity.dashpass)> disabled="true"</cfif>> Dash Pass Map<br /> --->
							<input type="checkbox" name="guestcompanionOption"<cfif val(qCommunity.guestcompanionOption)> checked="checked"</cfif>> PLUS GUEST(S) (Companions)<br />							
							<input type="checkbox" name="keypunchoption"<cfif val(qCommunity.keypunchoption)> checked="checked"</cfif>> Punch Pass<br /><br />
							<!--- <input type="checkbox" name="dashdirect"<cfif val(qCommunity.dashdirect)> checked="checked"</cfif>> Dash Direct<br />
							<input type="checkbox" name="cardscan"<cfif val(qCommunity.cardscan)> checked="checked"</cfif>> Card Scan<br /> --->
							<input type="checkbox" name="history"<cfif val(qCommunity.history)> checked="checked"</cfif>> Capture<br /><br />
							<input type="checkbox" name="permanantguests"<cfif val(qCommunity.permanantguests)> checked="checked"</cfif>> 24 / 7 Access 
							<select name="maxPermGuests">
								<option value="5"<cfif qCommunity.maxPermGuests eq 5> selected="selected"</cfif>>5</option>
								<option value="10"<cfif qCommunity.maxPermGuests eq 10> selected="selected"</cfif>>10</option>
								<option value="15"<cfif qCommunity.maxPermGuests eq 15> selected="selected"</cfif>>15</option>
								<option value="20"<cfif qCommunity.maxPermGuests eq 20> selected="selected"</cfif>>20</option>
								<option value="25"<cfif qCommunity.maxPermGuests eq 25> selected="selected"</cfif>>25</option>
								<option value="999"<cfif qCommunity.maxPermGuests eq 999> selected="selected"</cfif>>unlimited</option>
							</select> (maximum)<br />   
							<input type="checkbox" name="checkoutoption"<cfif val(qCommunity.checkoutoption)> checked="checked"</cfif>> Check-Out Option   <br /><br />
							<input type="checkbox" name="parcelpickup"<cfif isDefined('qCommunity.parcelpickup') AND val(qCommunity.parcelpickup)> checked="checked"</cfif>> Parcel Pickup #qCommunity.parcelpickup#<br />
								&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" name="parcelPickupResidentOnly" value="0"<cfif NOT val(qCommunity.parcelPickupResidentOnly)> checked="checked"</cfif>> Entire Household &nbsp;&nbsp;
								<input type="radio" name="parcelPickupResidentOnly" value="1"<cfif val(qCommunity.parcelPickupResidentOnly)> checked="checked"</cfif>> Resident Only
								<br /><br />
							<input type="checkbox" name="track_maintenance_requests" value="#qcommunity.track_maintenance_requests#"<cfif val(qCommunity.track_maintenance_requests)> checked="checked"</cfif>><strong>Track Maintenance Requests</strong>
							
							<br />				
							<br />							
						<input type="submit" value="Save Community">	
						</td>
						<td valign="top">
						<!--- <strong>Staff Identifier:</strong><br />
						<input type="radio" name="autoIdentifyStaff" value="1"<cfif val(qCommunity.autoIdentifyStaff)> checked="checked"</cfif>> Employee ID Automatically Generated<br />
						<input type="radio" name="autoIdentifyStaff" value="0"<cfif NOT val(qCommunity.autoIdentifyStaff)> checked="checked"</cfif>> Community Enters Employee ID<br />
						<br /> ---></form>	
						<cfif val(qCommunity.c_id)>
						<strong>Entry Points:</strong>
						<form method="post" action="#request.self#?fa=insertEntryPoint" >
						<fieldset>
						<table style="margin:0px;padding:0px;"><cfif NOT qEntryPoints.recordcount><tr><td>Create your first entry point (eg. "Main Gate")</td></tr></cfif>
						<cfloop query="qEntryPoints">
						<tr><td>#qEntryPoints.label#</td><td><a href="#request.self#?fa=deleteEntryPoint&c_id=#url.c_id#&entrypointid=#qEntryPoints.entrypointid#">remove</a></td></tr>
						</cfloop>
						</table>
						
						<input type="hidden" name="c_id" value="#qCommunity.c_id#" />
						<input type="text" name="label" /><input type="submit" value="Add" />
						</fieldset>
						</form>	
						
						<strong>Address Display Options:</strong>
						<form method="post" action="#request.self#?fa=saveUnitNumberOption" ><fieldset>
						<input type="hidden" name="c_id" value="#qCommunity.c_id#" />
						<input type="checkbox" name="addressDisplay" value="Unit_only"<cfif val(qCommunity.showunitonlyoption)>checked="checked"</cfif> /> Show Unit Numbers ONLY<br /><input type="submit" value="Save" /></fieldset></form>
						<strong>Special Events</strong>
						<form method="post" action="#request.self#?fa=saveSpecialEventsOptions">
						<fieldset>
							<input type="hidden" name="c_id" value="#qCommunity.c_id#" />
							<input type="checkbox" name="c_specialevents"<cfif qEventTypes.recordcount> checked="true"</cfif> onclick="enableEventBoxes(this)"> Special Event(s)<br />
							&nbsp; &nbsp; &nbsp; <input type="checkbox" name="chkeventBox1" id="chkeventBox1" <cfif ohON> checked="checked"<cfelseif NOT gsON> disabled="true"</cfif>> Open House (OH)<br />
							&nbsp; &nbsp; &nbsp; <input type="checkbox" name="chkeventBox2" id="chkeventBox2" <cfif gsON> checked="checked"<cfelseif NOT ohON> disabled="true"</cfif>> Garage Sale (GS)<br />
							&nbsp; &nbsp; &nbsp; <input type="checkbox" name="chkeventBox3" id="chkeventBox3" onclick="activateEventOptions3(this)"<cfif StructCount(otherEvents)> checked="checked"<cfelseif not gsON and not ohon> disabled="true"</cfif>> <input type="text" name="eventOptLabel3" class="txtName" id="eventOptLabel3"<cfif StructCount(otherEvents)> value="#evaluate("otherEvents."&eventAbbrevArr[1])#"<cfelseif not gsON and not ohon> disabled="true"</cfif>> <input type="text" name="eventOptInitial3" id="eventOptInitial3" class="txtZip"<cfif StructCount(otherEvents)> value="#eventAbbrevArr[1]#"<cfelseif not gsON and not ohon> disabled="true"</cfif>> (initials)<br />
							&nbsp; &nbsp; &nbsp; <input type="checkbox" name="chkeventBox4" id="chkeventBox4" onclick="activateEventOptions4(this)"<cfif StructCount(otherEvents) gt 1> checked="checked"<cfelseif not gsON and not ohon> disabled="true"</cfif>> <input type="text" name="eventOptLabel4" class="txtName" id="eventOptLabel4" <cfif StructCount(otherEvents) gt 1> value="#evaluate("otherEvents."&eventAbbrevArr[2])#"<cfelseif not gsON and not ohon> disabled="true"</cfif><cfif StructCount(otherEvents) gt 1> value="#evaluate("otherEvents."&eventAbbrevArr[2])#"<cfelseif not gsON and not ohon> disabled="true"</cfif>> <input type="text" name="eventOptInitial4" id="eventOptInitial4" class="txtZip"<cfif StructCount(otherEvents) gt 1> value="#eventAbbrevArr[2]#"<cfelseif not gsON and not ohon> disabled="true"</cfif>><br />
							&nbsp; &nbsp; &nbsp; <input type="checkbox" name="chkeventBox5" id="chkeventBox5" onclick="activateEventOptions5(this)"<cfif StructCount(otherEvents) gt 2> checked="checked"<cfelseif not gsON and not ohon> disabled="true"</cfif>> <input type="text" name="eventOptLabel5" class="txtName" id="eventOptLabel5" <cfif StructCount(otherEvents) gt 1> value="#evaluate("otherEvents."&eventAbbrevArr[2])#"<cfelseif not gsON and not ohon> disabled="true"</cfif> <cfif StructCount(otherEvents) gt 2> value="#evaluate("otherEvents."&eventAbbrevArr[3])#"<cfelseif not gsON and not ohon> disabled="true"</cfif>> <input type="text" name="eventOptInitial5" id="eventOptInitial5" class="txtZip"<cfif StructCount(otherEvents) gt 2> value="#eventAbbrevArr[3]#"<cfelseif not gsON and not ohon> disabled="true"</cfif>>
							<input type="submit" value="Save" /></fieldset>
						</form>
						</cfif>
						
						
						</td>				
					</tr>
					<tr><td colspan="3" align="center">					
					</td></tr></table>
					<table width="100%" cellpadding="0" cellspacing="0" border="0" style="border: 1px solid ##c0c0c0">
					<cfif val(qCommunity.c_id)>
					<tr>
						<th colspan="3">Capture/Message Center</th>
					</tr>
					<tr>
						<td width="33%" valign="top" style="border: 1px solid ##c0c0c0">
							<strong>Capture History</strong>
							<div name="historyCapture" class="txtBoxS">
							<cfloop query="qCaptureHistory">
							<a href="downloader.cfm?file=/capture/archive/#qCaptureHistory.captureFile#" target="_blank">#qCommunity.c_name# Capture</a>
							<br />#DateFormat(qCaptureHistory.fromdate,"mm/dd/yyyy")# - #DateFormat(qCaptureHistory.todate,"mm/dd/yyyy")#
							<br />#DateFormat(qCaptureHistory.insertdate,"mm/dd/yyyy")# @ #TimeFormat(qCaptureHistory.insertdate,"hh:mm tt")#<br /><br />
							</cfloop>
							</div>
							<br />
							 Next Capture
							 <cfif qCaptureHistory.recordcount AND isDate(qCaptureHistory.todate[qCaptureHistory.recordcount])>
							 	<cfset date1 = DateFormat(dateAdd("d",1,qCaptureHistory.todate[qCaptureHistory.recordcount]),"mm/dd/yyyy")>
								<cfset date2 = DateFormat(dateAdd("m",3,qCaptureHistory.todate[qCaptureHistory.recordcount]),"mm/dd/yyyy")>
								<cfset nextCapture = date1 & ' - ' & date2>
							 <cfelse>
							 	<cfset date1 = DateFormat(dateAdd("m",-3,now()),"mm/dd/yyyy")>
								<cfset date2 = DateFormat(now(),"mm/dd/yyyy")>
								<cfset nextCapture = dateAdd("m",qCommunity.captureLengthMon,now())>
							 </cfif>
							<form action="#request.self#?fa=insertCapture" method="post">
							<input type="text" class="txtField" value="#nextCapture#" disabled>
							<input type="submit" value="capture" />							
							<input type="Hidden" name="c_cname" value="#qCommunity.c_cname#" />
							<input type="hidden" name="c_id" value="#url.c_id#" />
							<input type="hidden" name="captureInterval" value="#qCommunity.captureLengthMon#" />
							<!--- <input type="text" name="date1" value="#date1#" />
							<input type="text" name="date2" value="#date2#" /> --->
							<input type="text" name="date1" value="11/1/2008" />
							<input type="text" name="date2" value="1/31/2009" />
							</form>
							<form action="#request.self#?fa=updateCaptureInterval" method="post">
							<!---Choose Capture Interval:<br />
							 <input type="radio" name="captureLengthMon" value="1"<cfif qCommunity.captureLengthMon eq 1> checked</cfif> disabled="true">1 Month
							 <input type="radio" name="captureLengthMon" value="3"<cfif qCommunity.captureLengthMon eq 3> checked</cfif>>3 Months
							 <input type="radio" name="captureLengthMon" value="6"<cfif qCommunity.captureLengthMon eq 6> checked</cfif> disabled="true">6 Months
							<input type="radio" name="captureLengthMon" value="12"<cfif qCommunity.captureLengthMon eq 12> checked</cfif> disabled="true">12 Months
							
							<input type="submit" value="update interval" /> --->
							<input type="hidden" name="c_id" value="#url.c_id#" /></form>
						</td>
						<td width="33%" valign="top" style="border: 1px solid ##c0c0c0"><strong>Message History</strong> <span style="font-size:-1">(click to view complete message)</span>
							
							<div name="paymentReceived" class="txtBoxS">
							<cfloop query="qAdminMessages">
							<div class="#iif(qAdminMessages.currentrow mod 2,de("dataB"),de("dataA"))#" 
								onmouseover="this.className='rowHover'" onmouseout="this.className='#iif(qAdminMessages.currentrow mod 2,de("dataB"),de("dataA"))#'" 
								onclick="openWin(#qAdminMessages.messageid#);">#dateFormat(qAdminMessages.insertdate)# - #qAdminMessages.messagesubject#<cfif val(qAdminMessages.sentToall)> *</cfif></div>
							</cfloop>
							</div> <br />													
							* message sent to all communities
							</td>
							<td valign="top"><strong>Compose Message</strong>
								<form action="#request.self#" method="post" >							
								<div name="paymentReceived" class="txtBoxS" style="padding:1px;">
								<input type="Hidden" id="fa" name="fa" value="CommunityList">
								<input type="Hidden" name="communityList" value="#qcommunity.c_id#">
								Subject
								<input type="text" name="messageSubject" id="messageSubject" class="txtSubject" onchange="document.getElementById('messageSendBtn').disabled = false;">
								Message
								<input type="hidden" name="senttoall" id="sentToAll" value="0"> 
								<textarea name="messageText" id="messageText" class="txtBox" style="height:90px;"></textarea>
								</div><br /><br /><input value="Send Message" id="messageSendBtn" type="Button" onclick="submitMessage(this);" disabled="true">
								<input type="Button" value="Clear" onclick="resetMessageStatus();">
								</form>
							</td>
						<!--- <form action="#request.self#?fa=insertPayment" method="post">
						<td valign="top" style="border: 1px solid ##c0c0c0"><input type="Hidden" name="c_id" value="#qCommunity.c_id#">
							<strong>Payment History</strong>
							<div name="paymentReceived" class="txtBoxS">
							<cfloop query="qPayments">
							<div class="#iif(qAdminMessages.currentrow mod 2,de("dataB"),de("dataA"))#">#dateFormat(qPayments.insertDate,"m/d/yyyy")# - #qPayments.refNumber# - $#qPayments.PaymentAmount#</div>
							</cfloop>
							</div>
							Amount &nbsp;&nbsp;&nbsp;&nbsp; Chk/Invoice Number<br />
							$ <input type="text" class="txtName" name="paymentAmount"> <input type="text" class="txtZip" name="refNumber"> <input type="submit" value="add"><br />
						</form>
						<form action="#request.self#?fa=updatePaymentDueDate" method="post">
						<input type="Hidden" name="c_id" value="#qCommunity.c_id#">
							Due Date:<br />
							<cfif isDate(qCommunity.paymentDueDate)>
							<cfset buildDueDate = qCommunity.paymentDueDate>
							<cfelse>
							<cfset buildDueDate = dateAdd("y",1,now())>
							</cfif>
							<input name="paymentduedate" value="#DateFormat(buildDueDate,"mm/dd/yyyy")#"> <input type="submit" value="update"></form>
						</td> --->
					</tr>
					<tr>
						<th colspan="3">Community Administrator/Contacts</th>
					</tr>
					<tr>
					<form action="#request.self#?fa=#xfa.submitAdministratorform#" method="post">
					<input type="Hidden" name="c_id" value="#qCommunity.c_id#"> 
					<!------>
					 <cfloop from="1" to="3" index="i">
						<input type="Hidden" name="staff_id#i#" value="#qAdminContact.staff_id[i]#">
						<input type="Hidden" name="contactid#i#" value="#qAdminContact.contactid[i]#">
						<td valign="top">
							<div class="formHeader">Administrator ###i#</div>					
							Last / First Name<br />
							<input type="text" class="txtName" maxlength="30" name="admin_lname#i#" value="#qAdminContact.Contact_lname[i]#"> <input type="text" class="txtName" maxlength="30" name="admin_fname#i#" value="#qAdminContact.Contact_fname[i]#">
							<br />Email<br />
							<input type="text" class="txtSubject" maxlength="110" name="admin_email#i#" value="#qAdminContact.contact_email[i]#">				
							Password<br />
							<input type="text" class="txtField" maxlength="30" name="admin_password#i#" value="#qAdminContact.staff_password[i]#"><br />					
							Main Telephone<br />
							<input type="text" class="txtZip" name="adminPhonePart1#i#" value="#listFirst(qAdminContact.contact_phone[i],".")#" maxlength="3"> <input type="text" class="txtZip" name="adminPhonePart2#i#" maxlength="3" value="<cfif listLen(qAdminContact.contact_phone[i],".") gt 2>#ListGetAt(qAdminContact.contact_phone[i],2,".")#</cfif>"> <input type="text" class="txtZip" name="adminPhonePart3#i#" maxlength="4" value="<cfif listLen(qAdminContact.contact_phone[i],".") gt 2>#ListGetAt(qAdminContact.contact_phone[i],3,".")#</cfif>"><br />
							Auxillary Telephone<br />
							<input type="text" class="txtZip" name="adminAltPhonePart1#i#" value="#listFirst(qAdminContact.contact_altphone[i],".")#" maxlength="3"> <input type="text" class="txtZip" name="adminAltPhonePart2#i#" maxlength="3" value="<cfif listLen(qAdminContact.contact_altphone[i],".") gt 2>#ListGetAt(qAdminContact.contact_altphone[i],2,".")#</cfif>"> <input type="text" class="txtZip" name="adminAltPhonePart3#i#" maxlength="4" value="<cfif listLen(qAdminContact.contact_altphone[i],".") gt 2>#ListGetAt(qAdminContact.contact_altphone[i],3,".")#</cfif>">		
						</td>
					</cfloop> 
						<!--- <td valign="top">
							<div class="formHeader">Administrator ##2</div>
							Last / First Name<br />
							<input type="text" class="txtName" maxlength="30" name="admin_lname" value="#qAdminContact.staff_lname#"> <input type="text" class="txtName" maxlength="30" name="admin_fname" value="#qAdminContact.staff_fname#">
							<br />Email<br />
							<input type="text" class="txtSubject" maxlength="110" name="admin_email" value="#qAdminContact.contact_email#">				
							Password<br />
							<input type="text" class="txtField" maxlength="30" name="admin_password" value="#qAdminContact.staff_password#"><br />					
							Main Telephone<br />
							<input type="text" class="txtZip" name="adminPhonePart1" value="#listFirst(qAdminContact.contact_phone,".")#" maxlength="3"> <input type="text" class="txtZip" name="adminPhonePart2" maxlength="3" value="<cfif listLen(qAdminContact.contact_phone,".") gt 2>#ListGetAt(qAdminContact.contact_phone,2,".")#</cfif>"> <input type="text" class="txtZip" name="adminPhonePart3" maxlength="4" value="<cfif listLen(qAdminContact.contact_phone,".") gt 2>#ListGetAt(qAdminContact.contact_phone,3,".")#</cfif>"><br />
							Auxillary Telephone<br />
							<input type="text" class="txtZip" name="adminAltPhonePart1" value="#listFirst(qAdminContact.contact_altphone,".")#" maxlength="3"> <input type="text" class="txtZip" name="adminAltPhonePart2" maxlength="3" value="<cfif listLen(qAdminContact.contact_altphone,".") gt 2>#ListGetAt(qAdminContact.contact_altphone,2,".")#</cfif>"> <input type="text" class="txtZip" name="adminAltPhonePart3" maxlength="4" value="<cfif listLen(qAdminContact.contact_altphone,".") gt 2>#ListGetAt(qAdminContact.contact_altphone,3,".")#</cfif>">		
						</td>
						<td valign="top">	
							<div class="formHeader">Administrator ##3</div>			
							Last / First Name<br />
							<input type="text" class="txtName" maxlength="30" name="admin_lname" value="#qAdminContact.staff_lname#"> <input type="text" class="txtName" maxlength="30" name="admin_fname" value="#qAdminContact.staff_fname#">
							<br />Email<br />
							<input type="text" class="txtSubject" maxlength="110" name="admin_email" value="#qAdminContact.contact_email#">				
							Password<br />
							<input type="text" class="txtField" maxlength="30" name="admin_password" value="#qAdminContact.staff_password#"><br />					
							Main Telephone<br />
							<input type="text" class="txtZip" name="adminPhonePart1" value="#listFirst(qAdminContact.contact_phone,".")#" maxlength="3"> <input type="text" class="txtZip" name="adminPhonePart2" maxlength="3" value="<cfif listLen(qAdminContact.contact_phone,".") gt 2>#ListGetAt(qAdminContact.contact_phone,2,".")#</cfif>"> <input type="text" class="txtZip" name="adminPhonePart3" maxlength="4" value="<cfif listLen(qAdminContact.contact_phone,".") gt 2>#ListGetAt(qAdminContact.contact_phone,3,".")#</cfif>"><br />
							Auxillary Telephone<br />
							<input type="text" class="txtZip" name="adminAltPhonePart1" value="#listFirst(qAdminContact.contact_altphone,".")#" maxlength="3"> <input type="text" class="txtZip" name="adminAltPhonePart2" maxlength="3" value="<cfif listLen(qAdminContact.contact_altphone,".") gt 2>#ListGetAt(qAdminContact.contact_altphone,2,".")#</cfif>"> <input type="text" class="txtZip" name="adminAltPhonePart3" maxlength="4" value="<cfif listLen(qAdminContact.contact_altphone,".") gt 2>#ListGetAt(qAdminContact.contact_altphone,3,".")#</cfif>">		
						</td> --->
					</tr>
					<tr><td colspan="3" bgcolor="##c0c0c0" align="center" style="border: 1px solid ##c0c0c0">
					<input type="submit" value="Save Contacts">		<input type="button" value="Cancel and Return To Start Page" onclick="self.location='admin.cfm?fa=communityList';" />		
					</form>
					</td></tr>
					</cfif>
				</table>
				
				
<div style="clear:both"></div>
	</div>
</div></cfoutput>
<div style="clear:both"></div>

