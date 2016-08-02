<cfif NOT isDefined("session.staff_id") OR NOT VAL(session.staff_id)>
	<cflocation URL="../staff.cfm" addtoken="no">
</cfif>
<cfparam name="url.checkin" default="0" />

<cfparam name="request.timesrun" default="0" />
<cfset request.timesrun = request.timesrun +1>
<cfif isDefined('form.dashpass')>
	<cfset attributes.dashpass = form.dashpass>	
<cfelseif isDefined('url.barcode')>
	<cfset attributes.dashpass = url.barcode>
</cfif>
<cfquery name="getCommunity" datasource="#datasource#">
	select * from communities 
	where c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#" />
</cfquery>
<cfquery name="qstateList" datasource="#datasource#">
	select state,abbreviation from states 
	order by state
</cfquery>
<cfquery name="qPreviousVisits" datasource="#datasource#">
	select v_id,g_id from visits 
	<cfif isDefined("url.v_id")>
	where v_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#url.v_id#" />
	<cfelseif isDefined('attributes.dashpass')>
		where g_barcode = <cfqueryparam value="#attributes.dashpass#" cfsqltype="CF_SQL_VARCHAR">
	<cfelse>
		where 1 = 0
	</cfif>
</cfquery>
<cfif isDefined('attributes.dashpass') and NOT isDefined("url.v_id")>
	<cfquery name="getVByBarcode" datasource="#datasource#">
		select g_id, v_id from guestvisits 
		where g_barcode = '#attributes.dashPass#'
	</cfquery>
	<cfset url.v_id = val(getVByBarcode.v_id)>
	<cfset url.g_id = val(getVByBarcode.g_id)>
</cfif>

<cfparam name="nextactions" default="" />
<cfinclude template="popup/header.cfm">
<cfif isDefined('attributes.dashpass') or isDefined('form.fancycheckin')>
	<cfquery name="getVByBarcode" datasource="#datasource#">
		select g_id, v_id from guestvisits 
		where g_barcode = '#attributes.dashPass#'
	</cfquery>	
	<cfif NOT getVByBarcode.recordcount>
		<div id="popUpAlert" style="background-color: white;">
			<script type="text/javascript">
				window.setTimeout(function(){
					parent.location.href = parent.location.href;
				}, 1000);
			</script> <br /><br />
			<div style="float:left;width:120px">
				<img src="/staff/assets/images/red-x-sign-57906.png" height="120">
			</div>
			<div style="float:left;width:300px;margin-top: 40px">	
			 <span style="color:red;font-size:30px;font-weight:600;">Invalid Barcode.</span>
			</div>
		</div>
		<!--- See if any contact information can be found --->
		<cftry>
		<cfquery name="getOldBarcodeData" datasource="#datasource#">
		select b.r_id,r.r_fname,r.r_lname,h.h_phone from barcodes b
		join guests g on g.g_id = b.g_id
		join residents r on g.r_id = r.r_id 
		join homesite h on r.h_id = h.h_id
		where b.barcode = '#attributes.dashPass#'
		</cfquery>
		<cfif getOldBarcodeData.recordcount>
			<div style="font-size: 1.2em;text-align:center;"><cfoutput>Please contact #getOldBarcodeData.r_fname# #getOldBarcodeData.r_lname# at #getOldBarcodeData.h_phone# to confirm visitor access.</cfoutput>
		</cfif>
		<cfcatch type="any">
			<cfdump var="#cfcatch#">
		</cfcatch>
		</cftry>
		<cfabort>
	</cfif>
</cfif>


<cfif (NOT qPreviousVisits.recordcount 
	OR val(getCommunity.recordlicenseplateonallvisits)) 
	AND url.checkin>	
	<cfif NOT isDefined('form.licensePlateNumber') 	
		and getCommunity.recordLicensePlate 
		and isDefined('url.checkin')>	<!--- AND NOT getCommunity.dashpass --->	
		<cfquery name="qstateList" datasource="#datasource#">
			select state,abbreviation from states 
			order by state
		</cfquery>
		<cfparam name="url.checkin" default="1">
		
		<cfoutput>
		<div id="popUpContainer"><h1>Record License Plate</h1>
		<form id="plateNumFrm" name="plateNumFrm" action="guestdetails.cfm?v_id=#url.v_id#&g_id=#url.g_id#&checkin=#url.checkin#" method="post">
	
				<table>
					<tr>
						<td style="test-align:right;"><strong style="font-size:1.5em;color:white;">State:</strong></td>
						<td>&nbsp; <select style="width:140px;font-size:14pt;" name="licensePlateStateCode"><cfloop query="qstateList"><option value="#qstateList.abbreviation#"<cfif qstateList.abbreviation is getcommunity.c_state> selected="selected"</cfif>>#qstateList.state#</option></cfloop></select></td>
					</tr>
					<tr>
						<td style="test-align:right;"><strong style="font-size:1.5em;color:white;">Plate Number:</strong></td>
						<td><input type="text" style="font-size:14pt;" name="licensePlateNumber" maxlength="11"></td>
					</tr>
				</table>
					<br />
				 <input type="submit" value="Skip" style="color:red;" onclick="parent.$.fancybox.close();" tabindex="99" />
				 <input type="submit" value="Save" style="color:green;" />
			</div>
		</form> 
		</cfoutput>		
		<cfabort>
	</cfif>
<cfelseif structKeyExists(url, 'fancyCheckin') and qPreviousVisits.recordcount>
	<cfoutput>
	<script>
	<cfif isDefined('url.v_id')>
		self.location = 'guestdetails.cfm?v_id=#url.v_id#&g_id=#url.g_id#';
	<cfelse>
		self.location = 'guestdetails.cfm?v_id=#getVByBarcode.v_id#&g_id=#getVByBarcode.g_id#';
	</cfif>
	</script>
	</cfoutput>
	<cfabort> this abort should speed up the page load to do a client location 	
</cfif>


<cfset timezoneadj = session.timezoneadj>

<cfparam name="cancel" default="">
<cfparam name="returncode" default="">
<cfparam name="message" default="">
<cfparam name="url.checkin" default="false">
<cfparam name="url.checkout" default="false">
<cfparam name="validentry" default="false">
<cfset request.dsn = datasource>
<cfset attributes.v_id = url.v_id>
<cfset attributes.g_id = url.g_id>
<cfset attributes.checkin = url.checkin>
<cfset attributes.checkout = url.checkout>

<cfif attributes.checkin>		
	<cfset metarefresh = true>
	<cfset refreshtime = 10>
<cfelseif isDefined("url.norefresh")>
	<cfset metarefresh = true>	
	<cfset refreshtime = 120>
<cfelse>
	<cfset metarefresh = true>
	<cfset refreshtime = 10>
</cfif>

<!--- RULES FOR GUESTS CHECKING IN FROM MAIN "CHECK-IN" BUTTON --->
<cfif isDefined("url.override")>
	<cfinclude template="bizrules/newSingleEntryByPreviousVID.cfm">
</cfif>
<cfinclude template="bizrules/validate_entryByvid.cfm">
	
<cfif attributes.checkin AND validentry>
	<cfmodule template="bizrules/record_entryByVID.cfm" v_id="#attributes.v_id#">
	<cfset checkinreturncode = "Visitor Entry Recorded">
<cfelseif attributes.checkout>
	<cfmodule template="bizrules/record_checkoutByVID.cfm" v_id="#attributes.v_id#">
<cfset checkinreturncode = "Visitor Check-Out Recorded">
</cfif>
<cfquery name="getGuests2" datasource="#datasource#">
	select guests.g_id, guests.g_lname, guests.g_fname, 
	guestvisits.v_id,guestvisits.g_initialvisit, guests.r_id, guestvisits.g_checkedin,
	guestvisits.g_barcode,guestvisits.g_permanent, guestvisits.insertedby_staff_id, guestvisits.guestcompanioncount,
	guestvisits.g_barcode,guestvisits.g_photo,residents.h_id ,residents.r_lname, residents.r_fname, 
	residents.r_id, residents.r_altphone
	from guests, guestvisits, residents
	where guests.g_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(attributes.g_id)#" />
	and guests.g_id = guestvisits.g_id 
	and guestvisits.v_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(attributes.v_id)#" />
	and guests.r_id = residents.r_id
</cfquery>
<cfquery name="getHomesite" datasource="#datasource#">
	select * from homesite where h_id = #val(getGuests2.h_id)#
</cfquery>

<cfquery name="qHistory" datasource="#datasource#">
	select *
	FROM visits	WHERE v_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(attributes.v_id)#" />
	order by g_checkedin desc
</cfquery>


<!--- <cfsavecontent variable="bodyContent">
<cfswitch expression="#returncode#">
		<cfcase value="Visit Record Not Found"><!--- INVALID VISIT  --->
			<cfset message = "Visit Record Not Found">
			<cfset nextActions = "FindResident,FindGuest">
		</cfcase>
		<cfcase value="Canceled"><!--- CANCELED CODE  --->
			<cfset message = "Scheduled Visit Has Been Canceled">
			<!--- find the guest --->
			<cfinclude template="bizrules/lookupOtherVisitsForGuest.cfm">
			<cfif isDefined("scheduleFound") and scheduleFound>
				<p>(box display 栤ate/time stamp)</p>
				<p>Please reprint the reissued DashPass or cancel and Reissue if lost, damaged or destroyed</p>
				<cfset nextActions = "reprintDP,reissueDP">
			<cfelse>
				<p>This DashPass was canceled on<cfoutput> #dateFormat(DateAdd('h',timezoneadj,cancel),"short")#, #timeFormat(DateAdd('h',timezoneadj,cancel),"h:mm tt")#</cfoutput> </p>
				<p>Please contact the resident to verify visitor entry</p>
				<cfset nextActions = "IssueSingleEntry">
			</cfif>
		</cfcase>
		
		<cfdefaultcase>
			<cfset message = returncode>
			<cfset nextActions = "FindResident,FindGuest">
		</cfdefaultcase>
	</cfswitch>
</cfsavecontent> --->
<cfif val(qSchedule.g_permanent)>
	<cfset is247 = true>
<cfelse>
	<cfset is247 = false>
</cfif>
<cfparam name="nextactions" default="" />

<cfif url.checkin>	
	<script type="text/javascript">
	window.setTimeout(function(){
		parent.location.href = parent.location.href;
	}, 3200);
</script> 
	
	<div id="popUpAlert" style="background-color: white;">
		<div style="float:left;width:130px">
			<img src="/staff/assets/images/check_mark_green_circle.png" height="120">
		</div>
		<div style="float:left;width:290px;">			
			<cfoutput>
			<h1 style="color:green;font-size:32px;">Check-In Successful</h1>
			<br /><br />
			<strong style="font-size:18px;">VISITOR: <a href="/staff/guestdetails.cfm?g_id=#getGuests2.g_id#&v_id=#getGuests2.v_id#" class="extlink">#getGuests2.g_fname# #getGuests2.g_lname#</a></strong><br />
			<strong style="font-size:18px;">RESIDENT: #getGuests2.r_fname# #getGuests2.r_lname#</strong>
			</cfoutput>	
			<!--- CHECK IN ENDS HERE --->
		</div>
	</div>
	<cfabort>
</cfif>
<cfparam name="checkinreturncode" default="">
<cfif checkinreturncode is "Visitor Check-Out Recorded">
	<script type="text/javascript">
	window.setTimeout(function(){
		parent.location.href = parent.location.href;
	}, 1100);
	</script> 
	<div id="popUpAlert">
	<h1>Check-Out Successful</h1>
		<!--- CHECK IN ENDS HERE --->
	</div>
	<cfabort>
</cfif>
<script language="JavaScript">
	function PrintOnlyPop(v_id,g_id) {
		printable=window.open("printOnlyDP.cfm?v_id="+v_id+"&g_id="+g_id,"printable","status=0,toolbar=0,width=825,height=700");
	}
	function ReprintAndPrintPop(v_id,g_id) {
		var printonly = 0;
		if (document.getElementById("printonlyChk").checked == true) printonly = 1;
		printable=window.open("reprintDP.cfm?v_id="+v_id+"&g_id="+g_id+"&printonly="+printonly,"printable","status=0,toolbar=0,width=825,height=700");
	}
	function ReissueAndPrintPop(v_id,g_id) {
		var printonly = 0;
		if (document.getElementById("printonlyChk").checked == true) printonly = 1;
		printable=window.open("reissueDP.cfm?v_id="+v_id+"&g_id="+g_id+"&printonly="+printonly,"printable","status=0,toolbar=0,width=825,height=700");
	}
</script>

<div id="popUpContainer">
<cfoutput><h1>Visitor: &nbsp;#UCASE(getGuests2.g_lname)#, #UCASE(getGuests2.g_fname)#</h1></cfoutput>
<cfif getGuests2.recordcount>
    <cfoutput query="getGuests2" group="v_id">
	    <table border="0" cellpadding="1" width="100%">
	        <tr>
	            <td style="font-weight:bold;vertical-align: text-top;">Resident:</td>
	            <td>#ucase(getGuests2.r_lname)#, #ucase(getGuests2.r_fname)#
								<cfif guestcompanioncount> 
									<span style="font-size:0.8em;font-weight:100;">(+#guestcompanioncount#)</span>
								</cfif><br />
								<cfif NOT getCommunity.showunitonlyoption>#gethomesite.h_address#<br><cfelse>Unit</cfif>
					 			<cfif len(gethomesite.h_unitnumber)> 
									#gethomesite.h_unitnumber#
								<cfelse> 
									#gethomesite.h_city#,#gethomesite.h_state#&nbsp; #gethomesite.h_zipcode#
								</cfif>
	              <br />Main Phone: #gethomesite.h_phone#<br>
	              <cfif Len(getGuests2.r_altphone) and not getGuests2.r_altphone is "..">Alt Phone: #getGuests2.r_altphone#</cfif>
	            </td>
							<cfif NOT qhistory.recordcount>
	            <td style="font-weight:bold;vertical-align: text-top;">Expected:</td>
							<td style="font-size:0.9em;vertical-align: text-top;">
							 	#DateFormat(qSchedule.g_initialvisit,"m/d/yyyy")# #TimeFormat(qSchedule.g_initialvisit,"hh:mm tt")#
											(estimated)
							</td>
							</cfif>
	        </tr>
	        <tr>
						<td style="font-weight:bold;vertical-align: text-top;">Announced by:</td>
							<cfif qSchedule.insertedby_staff_id>
								<cfquery datasource="#request.dsn#" name="getStaffMemWhoInserted">
									select staff_fname, staff_lname from staff where staff_id  = #val(qSchedule.insertedby_staff_id)#
								</cfquery>
								 <td style="font-size:0.9em;vertical-align: text-top;">#ucase(getStaffMemWhoInserted.staff_lname)#, #ucase(getStaffMemWhoInserted.staff_fname)# </td>
	            <cfelse>
								<cfquery datasource="#request.dsn#" name="getResidentWhoInserted">
									select r_fname, r_lname from residents
									where r_id  = #val(qSchedule.r_id)#
								</cfquery>
								 <td style="font-size:0.9em;vertical-align: text-top;">#ucase(getResidentWhoInserted.r_lname)#, #ucase(getResidentWhoInserted.r_fname)# </td>
							</cfif>	       
	            <cfif getCommunity.dashpass>
								<td style="font-weight:bold;vertical-align: text-top;">DashPass:</td>
	            	<td style="font-weight:bold;vertical-align: text-top;">#g_barcode#</td>      
		   				</cfif>
		   			</tr>	  
						<cfif val(guestcompanioncount)>
							<tr>
								<td style="font-weight:bold;vertical-align: text-top;">Plus Guest:</td>
								<td style="font-size:14px;" valign="top">
									#guestcompanioncount#
								</td>
							</tr>
						</cfif>
			
						<cfif getCommunity.recordLicensePlate and not val(getCommunity.recordlicenseplateonallvisits)>
						<tr>
							<td style="font-weight:bold;vertical-align: text-top;">License Plate:</td>
							<td>
							#qHistory.licensePlateStateCode[qhistory.recordcount]#&nbsp; #ucase(qHistory.licensePlateNumber[qhistory.recordcount])#
							</td>
						</tr>
						</cfif>
	    </table>
	</cfoutput>
	<cfif NOT returncode is "Allow Access">
		<span style="display:inline-block; background-color: #ddd;border-radius: 3px; padding: 5px; margin: 8px; color:red;font-size:14px;text-align:center;">
				! <strong>&nbsp;<cfoutput>#returncode#</cfoutput></strong> &nbsp;!
		</span>
	<cfelse>
		<span style="display:inline-block; background-color: #ddd;border-radius: 3px; padding: 5px; margin: 8px; font-size:14px;font-weight:600;text-align:center;">
			 <cfif val(qSchedule.g_singleentry)>VALID FOR SINGLE ENTRY<cfelse>AUTHORIZED ACCESS</cfif>
		</span>
	</cfif>
	
    <table align="center" bordercolor="white" border="2">
        <tr>
            <td valign="top"><cf_cal month="#month(request.timezoneadjustednow)#" year="#year(request.timezoneadjustednow)#" g_id="#url.g_id#" v_id="#url.v_id#" hide="events" twentyfour7="#is247#"></td>	
            <td valign="top"><cf_cal month="#month(dateAdd("m",1,request.timezoneadjustednow))#" year="#year(dateAdd("m",1,request.timezoneadjustednow))#" g_id="#url.g_id#" v_id="#url.v_id#" hide="events" twentyfour7="#is247#"></td>	
            <td valign="top"><cf_cal month="#month(dateAdd("m",2,request.timezoneadjustednow))#" year="#year(dateAdd("m",2,request.timezoneadjustednow))#" g_id="#url.g_id#" v_id="#url.v_id#" hide="events" twentyfour7="#is247#"></td>	
            <td valign="top"><cf_cal month="#month(dateAdd("m",3,request.timezoneadjustednow))#" year="#year(dateAdd("m",3,request.timezoneadjustednow))#" g_id="#url.g_id#" v_id="#url.v_id#" hide="events" twentyfour7="#is247#"></td>	
		</tr>
    </table>
	
	<cfif val(url.v_id)>	<br /><br />
		<cfoutput>
		<cfif val(qSchedule.g_permanent)>
			<input id="deleteVisit" type="button" value="Cancel" onclick="self.location='/staff/modifyschedule3.cfm?v_id=#url.v_id#&cancel=true'">
		<cfelse>
			<input id="editVisit" type="button" value="Edit/Cancel" onclick="self.location='/staff/modifyschedule2.cfm?v_id=#url.v_id#'">
		</cfif>
		<input id="viewHistory" type="button" value="Recorded Visits" onclick="self.location='/staff/popup/history.cfm?g_id=#url.g_id#'">
		</cfoutput>
	</cfif>
	
	<!--- <div id="pauseBtn" style="text-align:right;margin-right:33px;">
		<cfif isDefined("url.norefresh")>
		<button onclick="window.location='index.cfm'">Refresh</button> &nbsp;<br>
		(Page Paused)
		<cfelse>
		<cfoutput><button onclick="window.location='guestdetails.cfm?g_id=#url.g_id#&v_id=#url.v_id#&norefresh=true'">Pause</button> &nbsp;
		</cfoutput></cfif>	
	</div> --->
    <!--- </cfif> --->
		<cfif isDefined("qSchedule.v_id")>
			<cfset attributes.v_id = qSchedule.v_id>
		<cfelse>
			<cfset attributes.v_id = 0>
		</cfif>
		<cfquery dbtype="query" name="qTodayAccess">
			select * from qSchedule
			WHERE visit_date = #createDate(year(request.timezoneadjustednow),month(request.timezoneadjustednow),day(request.timezoneadjustednow))#
		</cfquery>
		
		<cfif isDefined("attributes.checkin") AND attributes.checkin AND returncode is "Allow Access">
			<cfinclude template="include/checkinMessage.cfm">
		<cfelseif  isDefined("attributes.checkout")>
			<cfinclude template="include/checkoutMessage.cfm">
		<cfelse>	
			<cfinclude template="include/guestDetailOptions.cfm">
		</cfif>
		
<cfelse>
	<div style="font-size: 14px; text-align:center; font-weight: 600" > No Results Found </div>
</cfif>	<!--- 
<cfinclude template="actionlist.cfm">
<cfinclude template="../footer.cfm"> --->
</div>