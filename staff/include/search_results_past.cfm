<!---<h1>Past</h1>
 
Past Date Searched:

Actual Visits (Alpha by guest last - Scroll 10) -  (sort by visit time)
Special Events (Alpha by resident last - Scroll 10)
No Shows (Alpha by guest last - Scroll 10)

	 --->	 
	<cfif isdefined("form.g_id")><cfset attributes.g_id = form.g_id><cfelse><cfparam name="attributes.g_id" default=""></cfif>
	<cfif isdefined("url.g_id")><cfset attributes.g_id = url.g_id><cfelse><cfparam name="attributes.g_id" default=""></cfif>
	<cfif isdefined("form.g_lname")><cfset attributes.g_lname = form.g_lname><cfelse><cfparam name="attributes.g_fname" default=""></cfif>
	<cfif isdefined("form.g_fname")><cfset attributes.g_fname = form.g_fname><cfelse><cfparam name="attributes.g_lname" default=""></cfif>
	<cfif isdefined("form.r_id")><cfset attributes.r_id = form.r_id><cfelse><cfparam name="attributes.r_id" default=""></cfif>
	<cfif isdefined("form.r_lname")><cfset attributes.r_lname = form.r_lname><cfelse><cfparam name="attributes.r_fname" default=""></cfif>
	<cfif isdefined("form.r_fname")><cfset attributes.r_fname = form.r_fname><cfelse><cfparam name="attributes.r_lname" default=""></cfif>
	<cfif isdefined("url.limit")><cfset attributes.limit = url.limit><cfelseif isdefined("form.limit")><cfset attributes.limit = form.limit></cfif>
	
	<cfparam name="thesearchdate" default="#request.timezoneadjustednow#" />
	  <cfimport taglib="../model" prefix="m">
	 <m:getvisits thedate="#thesearchdate#" daysback="360" g_id="#attributes.g_id#" r_id="#attributes.r_id#" g_lname="#attributes.g_lname#" g_fname="#attributes.g_fname#" r_lname="#attributes.r_lname#" r_fname="#attributes.r_fname#">
	
	<div id="popUpContainer"><div><p /></div>

	<cfif structKeyExists(attributes,'limit')>
		<cfset limitrows=attributes.limit>
	<cfelse>
		<cfset limitrows=200>	
	</cfif>
	<cfquery dbtype="query" name="qvisitsDistinct" maxrows="#limitrows#">
		select	DISTINCT * from qVisits
	</cfquery>
	
	<h1>Recorded Visits</h1>
	<div style="text-align:right">
		<button onclick="history.back()">Go Back</button>
	</div>	
	
	<cfif qvisits.recordcount>
		<div>
		<table width="98%" cellpadding="2" cellspacing="1" border="0" align="center">
			<tr>
			<td class="datatableHdr" align="center">Visitor name<!--- /Company Name ---> (L/F)</td>
			<td class="datatableHdr" align="center">Resident Name</td>
			<td class="datatableHdr" align="center">Resident Phone</td>
			<td class="datatableHdr" align="center">Address</td>
			<td class="datatableHdr" align="center" width="60">Date/Time</td>
			<td class="datatableHdr" align="center">Entry Point</td>
			<td class="datatableHdr" align="center">Personnel</td>
			 <!---<td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center">Details</td>
			 --->
			</tr>			
			<tbody>
			<cfoutput query="qvisitsDistinct">
				<tr class="notcheckedinRow" onmouseover="this.className='checkedinRowHover';" onmouseout="this.className='notcheckedinRow';">
				<td style="font-size:10px;">&nbsp;<!--- <a href="guestdetails.cfm?g_id=#g_id#&v_id=#v_id#"> --->#ucase(g_lname)#, #ucase(g_fname)#<!--- </a> ---></td>
					<td style="font-size:10px;" align="center">#ucase(r_lname)#, #ucase(r_fname)#</td>
					<td style="font-size:10px;" align="center">#h_phone#</td>
					<td style="font-size:10px;" align="center">#h_address#</td>
					<td style="font-size:10px;" align="center">#dateFormat(qvisitsDistinct.g_checkedin,"mm/dd/yyyy")# &nbsp; #TimeFormat(qvisitsDistinct.g_checkedin,"hh:mm:ss tt")#</td>
					<td style="font-size:10px;" align="center">#entryPoint#</td>
				  <td style="font-size:10px;" align="center">#recorded_by#</td>
				</tr>
			</cfoutput>
			</tbody>
		</table>
		</div>
		
		<br>
	<cfelse>
		 <div style="text-align:center;color:white;">NO VISITS RECORDED</div>
	</cfif>
		
	 <m:getnoshows thedate="#thesearchdate#" daysback="360" g_lname="#attributes.g_lname#" g_fname="#attributes.g_fname#" r_lname="#attributes.r_lname#" r_fname="#attributes.r_fname#">
	 <cfif qNoshows.recordcount>
		<h1>No Show(s)</h1>
		<div style="max-height: 136px; overflow: auto;">
		<table width="98%" cellpadding="2" cellspacing="1" border="0" align="center">
			<tr>
			<td class="datatableHdr" align="center">Guest name<!--- /Company Name ---> (L/F)</td>
			<td class="datatableHdr" align="center">Resident Name</td>
			<td class="datatableHdr" align="center">Resident Phone</td>
			<td class="datatableHdr" align="center">Resident Address</td>
			<td class="datatableHdr" align="center">Expected Time</td>
			<!--- <td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center">Details</td>
			 --->
			</tr>
			<tbody>
			<cfoutput query="qNoshows">
				<tr class="notcheckedinRow" onmouseover="this.className='checkedinRowHover';" onmouseout="this.className='notcheckedinRow';">
				<td style="font-size:10px;">&nbsp;<a href="/staff/guestdetails.cfm?g_id=#g_id#&v_id=#v_id#">#ucase(g_lname)#, #ucase(g_fname)#</a></td>
					<td style="font-size:10px;" align="center">#ucase(r_lname)#, #ucase(r_fname)#</td>
					<td style="font-size:10px;" align="center">#h_phone#</td>
					<td style="font-size:10px;" align="center">#h_address#</td>
					<td style="font-size:10px;" align="center">#timeFormat(g_initialVisit,'hh:mm tt')#</td>
				</tr>
			</cfoutput>
			</tbody>
		</table>
		</div>
	 </cfif>
		<br>
	
	 <cfquery name="GetSpecialEvents" datasource="#request.dsn#">
		select  r.r_fname, r.r_lname, h.h_phone, h.h_address, se.specialevent_id,
		se.starttime, se.endtime, t.label as eventlabel, r.r_id,  (
				select count(*) from specialeventvisits where specialevent_id = se.specialevent_id
			) 	as visitorcount 
		from specialEvents se 
		JOIN residents r on r.r_id = se.r_id
		join communityEventTypes t on t.etid = se.eventtypeid
		join homesite h on r.h_id = h.h_id
		where se.c_id = #session.user_community#
		and eventdate = #createDate(year(thesearchdate),month(thesearchdate),day(thesearchdate))#
		<!---  and ( CURRENT_TIME > starttime - interval '1 hours' AND CURRENT_TIME < endtime - interval '1 hours')
		--->ORDER BY se.starttime
	 </cfquery>
		<cfif isdefined("attributes.g_lname") and len(attributes.g_lname)>
			<cfquery dbtype="query" name="GetSpecialEvents">
				select * from GetSpecialEvents
				where  1 = 0 <!--- no results for guest name search --->
			</cfquery>
		</cfif>
		<cfif isdefined("attributes.g_fname") and len(attributes.g_fname)>
			<cfquery dbtype="query" name="GetSpecialEvents">
				select * from GetSpecialEvents
				where  1 = 0 <!--- no results for guest name search --->
			</cfquery>
		</cfif>
		<cfif isdefined("attributes.r_lname") and len(attributes.r_lname)>
			<cfquery dbtype="query" name="GetSpecialEvents">
				select * from GetSpecialEvents
				where  upper(r_lname) = <cfqueryparam value="#ucase(attributes.r_lname)#" cfsqltype="CF_SQL_VARCHAR">
			</cfquery>
		</cfif>
		<cfif isdefined("attributes.r_fname") and len(attributes.r_fname)>
			<cfquery dbtype="query" name="GetSpecialEvents">
				select * from GetSpecialEvents
				where  upper(r_fname) = <cfqueryparam value="#ucase(attributes.r_fname)#" cfsqltype="CF_SQL_VARCHAR">
			</cfquery>
		</cfif>
	
	 <cfif GetSpecialEvents.Recordcount and NOT structKeyExists(attributes,'g_lname')>	
		<h1>Special Event(s)</h1>
		<div style="max-height: 136px; overflow: auto;">
			<table width="98%" cellpadding="1" cellspacing="2" border="0" align="center">
			<tr class="datatableHdr">
			<td align="center">Resident Name</td>
			<td align="center">Event Type</td>
			<td align="center">Resident Phone</td>
			<td align="center">Address</td>
			<td align="center">Time Frame</td>
			<td align="center">Count</td>
			</tr>	
			<cfoutput query="GetSpecialEvents">
			<tr class="notcheckedinRow" onmouseover="this.className='checkedinRowHover';" onmouseout="this.className='notcheckedinRow';">
				<td style="font-size:10px;">&nbsp;<a href="specialevents_view.cfm?r_id=#r_id#&specialevent_id=#specialevent_id#">#ucase(r_lname)#, #ucase(r_fname)#</a> </td>
				<td style="font-size:10px;">&nbsp;#ucase(GetSpecialEvents.eventlabel)#</td>
				<td style="font-size:10px;" align="center">#h_phone#</td>
				<td style="font-size:10px;" align="center">#h_address#</td>
				<td style="font-size:10px;" align="center">#TimeFormat(starttime,"h:mm tt")#-#TimeFormat(endtime,"h:mm tt")#</td>  
				<td style="font-size:10px;" align="center">#visitorcount#</td>					
			</tr>
			</cfoutput>
			</table>
		</div><br />
	</cfif>
</div>
	
