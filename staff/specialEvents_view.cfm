<cfif session.staff_id EQ 0>
    <cflocation URL="../staff.cfm">
	<cfabort>
</cfif>
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
<cfset timezoneadj = session.timezoneadj>
	<cfinclude template="../header5.cfm">
	<cfquery datasource="#datasource#" name="qSpecialEvent">
		select  r.r_fname, r.r_lname, h.h_phone, h.h_address, se.specialevent_id,r.r_altphone,
		se.eventdate,se.starttime, se.endtime, se.staffnotes, se.createdByStaffID, t.label as eventlabel, r.r_id
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
		
	<cfoutput>
	<h1 style="text-align:center; font-size:22px;">Special Event</h1>
	<h2 style="font-weight:bold;font-size:16px;border-bottom:1px solid silver;"> &nbsp;</h2>
	 <table border="0" cellpadding="1" width="90%">
        <tr>
            <td rowspan="10" width="50">&nbsp;&nbsp;</td>
	            
			<td style="font-weight:bold;color:##336699;font-size:13px;" width="120" valign="top">RESIDENT:</td>
			<td>
			<strong>#ucase(qSpecialEvent.r_lname)#, #ucase(qSpecialEvent.r_fname)#</strong><br>
            #qSpecialEvent.h_Address#<br>
			Main Phone: #qSpecialEvent.h_phone#
			<cfif len(qSpecialEvent.r_altphone) gt 2><br>Alt Phone: #qSpecialEvent.r_altphone#</cfif>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;<!--- spacer ---></td>			   
		</tr>
		 <tr>
            <td style="font-weight:bold;color:##336699;font-size:13px;" width="120" valign="top">EVENT TYPE:</td>
			<td><strong>#ucase(qSpecialEvent.eventlabel)#</strong></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;<!--- spacer ---></td>			   
		</tr>
		<tr>
			<td colspan="2">
				<table align="center">
				<cfset request.dsn = datasource>
				    <tr>
			            <td valign="top"><cf_cal month="#month(request.timezoneadjustednow)#" year="#year(request.timezoneadjustednow)#" eventid="#url.specialevent_id#" hide="visitors"></td>	
			            <td valign="top"><cf_cal month="#month(dateAdd("m",1,request.timezoneadjustednow))#" year="#year(dateAdd("m",1,request.timezoneadjustednow))#" eventid="#url.specialevent_id#" hide="visitors"></td>	
			            <td valign="top"><cf_cal month="#month(dateAdd("m",2,request.timezoneadjustednow))#" year="#year(dateAdd("m",2,request.timezoneadjustednow))#" eventid="#url.specialevent_id#" hide="visitors"></td>	
			            <td valign="top"><cf_cal month="#month(dateAdd("m",3,request.timezoneadjustednow))#" year="#year(dateAdd("m",3,request.timezoneadjustednow))#" eventid="#url.specialevent_id#" hide="visitors"></td>	
			        </tr>
				</table>
			</td>			   
        </tr>
		
		</table>
		<table border="0" cellpadding="1" width="90%">
			<tr>
	            <td rowspan="4" width="50">&nbsp;&nbsp;</td>
				<td width="120" style="font-weight:bold;color:##336699;font-size:13px;" valign="top">EVENT START:</td>
				<td style="font-size:13px;" valign="top"> #TimeFormat(qSpecialEvent.starttime,"h:mm tt")#<br></td>
				<td rowspan="4" style="font-weight:bold;color:##336699;font-size:13px;" align="center">COMMENTS:<br />
					<form action="##" method="post"><textarea name="staffNotes" rows="5" cols="30">#qSpecialEvent.staffNotes#</textarea><br /><input type="submit" value="save"></form></td>		   
			</tr>
			<tr>
				<td style="font-weight:bold;color:##336699;font-size:13px;" valign="top">EVENT END:</td>
				<td style="font-size:13px;" valign="top"> #TimeFormat(qSpecialEvent.endtime,"h:mm tt")#<br>
				</td>			   
	        </tr>
			<tr>
				<td style="font-weight:bold;color:##336699;font-size:13px;" valign="top">VISITOR COUNT:</td>
				<td style="font-size:13px;" valign="top"> #qSpecialEventCounter.counter#<br>
				</td>			   
	        </tr>
		<cfif isDefined('qSpecialEvent.createdByStaffID') and val(qSpecialEvent.createdByStaffID)>
			<cfquery datasource="#datasource#" name="qStaffUser">
				select * from staff where staff_id = <cfqueryparam value="#qSpecialEvent.createdByStaffid#" cfsqltype="CF_SQL_INTEGER">
			</cfquery>
			<tr>
				<td style="font-weight:bold;color:##336699;font-size:13px;" valign="top">EVENT ADDED BY:</td>
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
	</cfoutput>
	<!--- <cfif val(getCommunity.recordlicenseplateonspecialevents)> --->
		<cfinclude template="specialeventhistory.cfm">
	<!--- </cfif> --->
	<cfmodule template="actionlist.cfm" showonly="home,logout">
<cfinclude template="../footer.cfm">