<cfquery name="GetSpecialEvents" datasource="#request.dsn#">
		select  r.r_fname, r.r_lname, h.h_phone, h.h_address, se.specialevent_id,se.createdByStaffID,
		se.starttime, se.endtime, t.label as eventlabel, r.r_id,  (
				select count(*) from specialeventvisits where specialevent_id = se.specialevent_id
			) 	as visitorcount 
		from specialEvents se 
		JOIN residents r on r.r_id = se.r_id
		join communityEventTypes t on t.etid = se.eventtypeid
		join homesite h on r.h_id = h.h_id
		where se.c_id = #session.user_community#
		<cfif isDefined('attributes.r_id') and VAL(attributes.r_id)>
			AND r.r_id = <cfqueryparam value="#attributes.r_id#" cfsqltype="CF_SQL_INTEGER">
		</cfif>
		and eventdate = #createDate(year(request.timezoneadjustednow),month(request.timezoneadjustednow),day(request.timezoneadjustednow))#
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

    <cfif GetSpecialEvents.Recordcount>		
	<script language="JavaScript">
		function CountPop(specialevent_id) {
			self.location='act_eventcounter.cfm?specialevent_id='+specialevent_id;
		}
		function recordLPforSpecialEvent(specialevent_id) {
			var jThickboxNewLink = 'act_eventcounter.cfm?specialevent_id='+specialevent_id+'&height=300&width=500';
			tb_show('Record License Plate',jThickboxNewLink,null);
		}
	</script>
	<cfset daystart = createdate(year(request.timezoneadjustednow),month(request.timezoneadjustednow),day(request.timezoneadjustednow))>
	<h2><cfif datecompare(begintime,dateAdd("d",1,daystart)) gt 0>FUTURE </cfif>SPECIAL EVENTS</h2>
	<!--- <table width="98%" cellpadding="1" cellspacing="2" border="0" align="center">
		<tr>
		<td colspan="7" align="center"><strong></td>
		</tr>
	</table> --->
	<div class="homePageDatagrid">
		<table width="100%" cellpadding="1" cellspacing="2" border="0" align="center">
		<tr class="datatableHdr">
		<td align="center">Resident Name</td>
		<td align="center">Event Type</td>
		<td align="center">Resident Phone</td>
		<td align="center">Address</td>
		<td align="center">Duration</td>
		<td align="center">Action</td>
		</tr>	
		<cfoutput query="GetSpecialEvents">
		<tr class="notcheckedinRow" onmouseover="this.className='checkedinRowHover';" onmouseout="this.className='notcheckedinRow';">
			<td style="font-size:10px;">&nbsp;&nbsp;<a class="extlink" href="popup/specialevents_view.cfm?r_id=#r_id#&specialevent_id=#specialevent_id#">#ucase(r_lname)#, #ucase(r_fname)#</a><cfif val(createdByStaffID)>*</cfif> </td>
			<td style="font-size:10px;" align="center">&nbsp;#ucase(GetSpecialEvents.eventlabel)#</td>
			<td style="font-size:10px;" align="center">#h_phone#</td>
			<td style="font-size:10px;" align="center">#h_address#</td>
			<td style="font-size:10px;" align="center">#TimeFormat(starttime,"h:mm tt")#-#TimeFormat(endtime,"h:mm tt")#</td>  
			<td style="font-size:10px;" align="center">
			<cfif datecompare(begintime,dateAdd("d",1,daystart)) lte 0>
				<cfif isDefined("getCommunity.quickpass") and getCommunity.quickpass>
					<input title="Create QuickPass" type="button"  class="action-btn" value="Q" onclick="CountPop(#specialevent_id#);quickpassPrint(#r_id#);">
				<cfelseif getCommunity.recordlicenseplateonspecialevents>
					<input type="submit" value=" #visitorcount# "  class="action-btn" onclick="recordLPforSpecialEvent(#specialevent_id#);">
				<cfelse>	
					<input type="submit" value=" #visitorcount# "  class="action-btn" onclick="CountPop(#specialevent_id#);">
				</cfif>	
			</cfif></td>					
			
		</tr>
		</cfoutput>
		</table>
	</div>
	</cfif>