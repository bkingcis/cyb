<cfif session.staff_id EQ 0>
    <cflocation URL="../staff.cfm">
	<cfabort>
</cfif>
<cfset timezoneadj = session.timezoneadj>
	<!--- <cfinclude template="../header5.cfm"> --->
	<cfinclude template="header.cfm">
	
	<div id="popUpContainer">
	<h1>Special Events</h1>
<cfif NOT structKeyExists(url,'specialevent_id') and structKeyExists(url,'eventdate')>
	<cfif isDate(url.eventdate)>		
	<cfset startdate = url.eventdate>
	</cfif>
 <cfquery datasource="#datasource#" name="qSpecialEvents">
		select  r.r_fname, r.r_lname, h.h_phone, h.h_address, se.specialevent_id,r.r_altphone,
		se.eventdate,se.starttime, se.endtime, se.staffnotes, se.createdByStaffID, se.eventtypeid, t.label as eventlabel, r.r_id
		from specialEvents se 
		JOIN residents r on r.r_id = se.r_id
		join communityEventTypes t on t.etid = se.eventtypeid
		join homesite h on r.h_id = h.h_id
		where se.c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#" />
		<cfif val(url.r_id)>and r.r_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#url.r_id#" /></cfif>
		and se.eventdate BETWEEN '#dateFormat(startdate)#' AND '#dateFormat(dateAdd('d',1,startdate))#'
	</cfquery>
	<cfif qSpecialEvents.recordcount eq 1 and 1 eq 2>
		<cflocation url="specialEvents_edit.cfm?&specialEvent_id=#qSpecialEvents.specialEvent_id#">
	<cfelseif qSpecialEvents.recordcount gt 0> 
		<table width="100%" cellpadding="1" cellspacing="1" border="0" align="center">
		  <tr class="datatableHdr">
				<th>Resident</th>
				<th align="center">Event</th>
				<th align="center">Action</th>
		  </tr>
			<cfoutput query="qSpecialEvents">
					<tr class="notcheckedinRow" onmouseover="this.className='checkedinRowHover';" onmouseout="this.className='notcheckedinRow';">
						<td>#qSpecialEvents.r_fname# #qSpecialEvents.r_lname#</td>
						<td align="center">#qSpecialEvents.eventlabel#</td>
						<td align="center"><a href="/staff/popup/specialEvents_edit.cfm?&specialEvent_id=#qSpecialEvents.specialEvent_id#" class="extlink action-btn">Edit</a></td>
					</tr>
			</cfoutput>
		</table>
	</cfif>
<cfelse>
		<cfif isDefined('form.staffNotes')>
			<cfquery name="getCommunity" datasource="#datasource#">
			update specialEvents
			set  staffNotes = <cfqueryparam value="#form.staffNotes#" cfsqltype="CF_SQL_LONGVARCHAR">
			where specialevent_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#url.specialevent_id#" />
			</cfquery>
		</cfif>
		<cfquery name="getCommunity" datasource="#datasource#">
			select * from communities 
			where c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#" />
		</cfquery>
		<cfquery datasource="#datasource#" name="qEventTypes">
			Select * from CommunityeventTypes
			where c_id = #session.user_community#
			order by label
		</cfquery>

			<cfquery datasource="#datasource#" name="qSpecialEvent">
				select  r.r_fname, r.r_lname, h.h_phone, h.h_address, se.specialevent_id,r.r_altphone, h_unitnumber,
				se.eventdate,se.starttime, se.endtime, se.staffnotes, se.createdByStaffID, se.eventtypeid, t.label as eventlabel, r.r_id
				from specialEvents se 
				JOIN residents r on r.r_id = se.r_id
				join communityEventTypes t on t.etid = se.eventtypeid
				join homesite h on r.h_id = h.h_id
				where se.c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#" />
				and se.specialevent_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#url.specialevent_id#" />
			</cfquery>

			<cfquery datasource="#datasource#" name="qSpecialEventCounter">
				select count(*) as counter from specialeventvisits 
				where specialevent_id = #url.specialevent_id#
			</cfquery>

			<script>
				function getIndex(input, arrayData) {
					for (i=0; i<arrayData.length; i++) {
						if (arrayData[i] == input) {
							return i;
						}
					}
					return -1;
				}

				function selectDateBox (boxToUpdate,thedate) {
					//OLD WAY - WAS USED TO APPEND DATES  var listFrmVal = document.getElementById('allSelected').value;
					//NEW WAY	
					$('.preselectedBox').removeClass('preselectedBox').addClass('calDayBox');
					$('#allSelected').val(thedate);
					boxToUpdate.className='preselectedBox';
				}
			</script>

			<cfoutput>

		<form name="testForm" action="modspecialevent2.cfm" method="post">
			 <table border="0" cellpadding="1" width="90%">
						<tr>
								<td rowspan="10" width="50">&nbsp;&nbsp;</td>

					<td style="font-weight:bold;color:##FFFFFF;font-size:13px;" width="120" valign="top">RESIDENT:</td>
					<td>
					<strong>#ucase(qSpecialEvent.r_lname)#, #ucase(qSpecialEvent.r_fname)#</strong><br>
						<cfif NOT getCommunity.showunitonlyoption>#qSpecialEvent.h_address#<br><cfelse>Unit</cfif>
						<cfif len(qSpecialEvent.h_unitnumber)> 
							#qSpecialEvent.h_unitnumber#
						<cfelse> 
							#qSpecialEvent.h_city#,#qSpecialEvent.h_state#&nbsp; #qSpecialEvent.h_zipcode#
						</cfif><br>
					Main Phone: #qSpecialEvent.h_phone#
					<cfif len(qSpecialEvent.r_altphone) gt 2><br>Alt Phone: #qSpecialEvent.r_altphone#</cfif>
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>&nbsp;<!--- spacer ---></td>			   
				</tr>
				 <tr>
								<td style="font-weight:bold;color:##FFFFFF;font-size:13px;" width="120" valign="top">EVENT TYPE:</td>
					<td><strong>#ucase(qSpecialEvent.eventlabel)#</strong></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>&nbsp;<!--- spacer ---></td>			   
				</tr>
				<tr>
					<td colspan="2">
						<table align="center" border="2" bordercolor="white">
						<cfset dateList = "">
						<cfloop query="qSpecialEvent">
							<cfset dateList = listAppend(dateList,dateFormat(qSpecialEvent.eventdate,"m/d/yyyy"))>
						</cfloop>
						<cfset request.dsn = datasource>
								<tr>
								<td valign="top"><cfmodule template="../cal.cfm" multiday="false" month="#month(request.timezoneadjustednow)#" year="#year(request.timezoneadjustednow)#" selectorcolor="eeee77" hide="events,visitors" selectedList="#dateList#"></td>
								<td valign="top"><cfmodule template="../cal.cfm" multiday="false" month="#month(dateAdd("m",1,request.timezoneadjustednow))#" year="#year(dateAdd("m",1,request.timezoneadjustednow))#" selectorcolor="eeee77" hide="events,visitors" selectedList="#dateList#"></td>	
								<td valign="top"><cfmodule template="../cal.cfm" multiday="false" month="#month(dateAdd("m",2,request.timezoneadjustednow))#" year="#year(dateAdd("m",2,request.timezoneadjustednow))#" selectorcolor="eeee77" hide="events,visitors" selectedList="#dateList#"></td>	
								<td valign="top"><cfmodule template="../cal.cfm" multiday="false" month="#month(dateAdd("m",3,request.timezoneadjustednow))#" year="#year(dateAdd("m",3,request.timezoneadjustednow))#" selectorcolor="eeee77" hide="events,visitors" selectedList="#dateList#"></td>	
							</tr>
						</table>
					</td>			   
						</tr>

				</table>
				<table border="0" cellpadding="1" width="90%">
					<tr>
									<td rowspan="4" width="50">&nbsp;&nbsp;</td>
						<td width="120" style="font-weight:bold;color:##FFFFFF;font-size:13px;" valign="top">EVENT START:</td>
						<td style="font-size:13px;" valign="top"> <!---
						<select name="starttime">
							<cfloop from="0" to="23" index="i">
							<cfloop from="0" to="45" step="15" index="m">
							<cfif len(m) neq 2><cfset min = "00"><cfelse><cfset min = m></cfif>
							<cfset ittValue = i & ':' & min>
							<option<cfif TimeFormat(qSpecialEvent.starttime,"H:mm") is ittValue> selected</cfif> value="#ittValue#"><cfif i eq 12>12:#min#pm<cfelseif i gt 12>#evaluate(i-12)#:#min#pm<cfelseif i lt 1>12:#min#am<cfelse>#i#:#min#am</cfif></option>
							</cfloop>
							</cfloop>
						</select> ---> #TimeFormat(qSpecialEvent.starttime)#
						</td>
						<td rowspan="4" style="font-weight:bold;color:##FFFFFF;font-size:13px;" align="center"><!--- COMMENTS: ---><br />
							<!--- <form action="##" method="post"><textarea name="staffNotes" rows="5" cols="30">#qSpecialEvent.staffNotes#</textarea><br /><input type="submit" value="save"></form> ---></td>		   
					</tr>
					<tr>
						<td style="font-weight:bold;color:##FFFFFF;font-size:13px;" valign="top">EVENT END:</td>
						<td style="font-size:13px;" valign="top">
						<!--- <select name="endtime">
							<cfloop from="0" to="23" index="i">
							<cfloop from="0" to="45" step="15" index="m">
							<cfif len(m) neq 2><cfset min = "00"><cfelse><cfset min = m></cfif>
							<cfset ittValue = i & ':' & min>
							<option<cfif TimeFormat(qSpecialEvent.endtime,"H:mm") is ittValue> selected</cfif> value="#ittValue#"><cfif i eq 12>12:#min#pm<cfelseif i gt 12>#evaluate(i-12)#:#min#pm<cfelseif i lt 1>12:#min#am<cfelse>#i#:#min#am</cfif></option>
							</cfloop>
							</cfloop>
						</select> --->#TimeFormat(qSpecialEvent.endtime)#
						</td>			   
							</tr>
					<tr>
						<td style="font-weight:bold;color:##FFFFFF;font-size:13px;" valign="top">VISITOR COUNT:</td>
						<td style="font-size:13px;" valign="top"> #qSpecialEventCounter.counter#<br>
						</td>			   
							</tr>
				<cfif isDefined('qSpecialEvent.createdByStaffID') and val(qSpecialEvent.createdByStaffID)>
					<cfquery datasource="#datasource#" name="qStaffUser">
						select * from staff where staff_id = <cfqueryparam value="#qSpecialEvent.createdByStaffid#" cfsqltype="CF_SQL_INTEGER">
					</cfquery>
					<tr>
						<td style="font-weight:bold;color:##FFFFFF;font-size:13px;" valign="top">EVENT ADDED BY:</td>
						<td style="font-size:13px;" valign="top"> #qStaffUser.staff_fname# #qStaffUser.staff_lname#<br>
						</td>			   
							</tr>
				<cfelse>
					<tr>
						<td>&nbsp;</td>
						<td>&nbsp;<!--- spacer ---></td>			   
					</tr>		
				</cfif>		
			</table>
			<input type="hidden" id="allSelected" name="allSelected" value="#datelist#">
			<input type="hidden" name="specialevent_id" value="#url.specialevent_id#">
			<button type="button" onclick="self.location='specialEvents_edit.cfm?specialevent_id=#url.specialEvent_id#'">Edit/Cancel</button>
			</form>
			</cfoutput>
			<!--- <cfif val(getCommunity.recordlicenseplateonspecialevents)> 
				<cfinclude template="../specialeventhistory.cfm">--->
			<!--- </cfif> --->
			<!--- <cfmodule template="actionlist.cfm" showonly="home,logout">
		<cfinclude template="../footer.cfm"> --->
</cfif>
</div>