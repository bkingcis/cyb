<cfset timezoneadj = session.timezoneadj>
	<cfif NOT form.searchcrit is "sp_date">
		<cfset BEGINTIME = createDate(year(request.timezoneadjustednow),month(request.timezoneadjustednow),day(request.timezoneadjustednow))>
		<cfset ENDTIME = dateAdd("d",15,begintime)>
	</cfif>	
	<cfquery datasource="#datasource#" name="GetSchedule">
		select guests.g_id,guests.r_id,guests.g_lname,guests.g_fname,guestvisits.g_checkedin,v.g_checkedin,
		guestvisits.v_id,guestvisits.dashpass,guestvisits.g_permanent,schedule.g_singleentry,
		schedule.visit_date as schedule_date,
		guestvisits.g_cancelled,guestvisits.g_initialvisit,residents.r_id,residents.h_id,
		residents.r_fname,residents.r_lname,homesite.h_id,homesite.h_address,homesite.h_phone 
		from guests join guestvisits on guestvisits.g_id = guests.g_id
		join residents on guests.r_id = residents.r_id
		join homesite on residents.h_id = homesite.h_id
		LEFT join schedule on guestvisits.v_id = schedule.v_id 
		LEFT JOIN visits v on v.v_id = guestvisits.v_id		
		WHERE guests.c_id = #session.user_community#
		AND (guestvisits.G_CANCELLED is null)
			<cfif NOT len(form.r_lname) and not LEN(form.r_fname) and NOT LEN(form.g_lname) and NOT LEN(form.g_fname)>
				AND (g_initialvisit >= #BEGINTIME#
					AND g_initialvisit <= #ENDTIME#
					OR g_permanent = True
				)
			<cfelse>
				AND (g_initialvisit >= #BEGINTIME# OR g_permanent = True)
				<CFIF len(trim(form.g_lname))>AND upper(g_lname) LIKE '#trim(ucase(form.g_lname))#%'</CFIF>
				<CFIF len(trim(form.g_fname))>AND upper(g_fname) LIKE '#trim(ucase(form.g_fname))#%'</CFIF>
				<CFIF len(trim(form.r_lname))>AND upper(r_lname) LIKE '#trim(ucase(form.r_lname))#%'</CFIF>
				<CFIF len(trim(form.r_fname))>AND upper(r_fname) LIKE '#trim(ucase(form.r_fname))#%'</CFIF>
			</cfif>
			
			<!--- AND g_checkedin IS NULL --->
		ORDER BY g_lname, g_fname, r_lname, schedule_date
	</cfquery>
	<cfset tomorrow = dateadd("d",1,request.timezoneadjustednow)>
	<cfquery dbtype="query" name="GetTodaySchedule"	>
		select * from GetSchedule 
		WHERE  schedule_date = <cfqueryparam cfsqltype="CF_SQL_DATE" value="#createDate(year(request.timezoneadjustednow),month(request.timezoneadjustednow),day(request.timezoneadjustednow))#">
		AND (g_permanent IS NULL OR g_permanent = '0')					
	</cfquery>
	<cfif val(getCommunity.permanantguests)>		
		<cfquery dbtype="query" name="Get247ScheduleTODAY">
			select * from GetSchedule 
			where  g_initialvisit < <cfqueryparam cfsqltype="CF_SQL_DATE" value="#createDate(year(tomorrow),month(tomorrow),day(tomorrow))#">
			and    g_initialvisit > <cfqueryparam cfsqltype="CF_SQL_DATE" value="#createDate(year(request.timezoneadjustednow),month(request.timezoneadjustednow),day(request.timezoneadjustednow))#">
			and g_permanent IS NOT NULL AND g_permanent <> '0'
			order by g_lname, g_fname
		</cfquery> 
		<cfquery dbtype="query" name="Get247Schedule">
			select * from GetSchedule 
			where  (<!--- g_initialvisit > <cfqueryparam cfsqltype="CF_SQL_DATE" value="#createDate(year(tomorrow),month(tomorrow),day(tomorrow))#"> 
			OR --->
			   g_initialvisit < <cfqueryparam cfsqltype="CF_SQL_DATE" value="#createDate(year(tomorrow),month(tomorrow),day(tomorrow))#">)
			and  g_permanent IS NOT NULL AND g_permanent <> '0'
			order by g_lname, g_fname
		</cfquery>
	</cfif> 
    <cfquery dbtype="query" name="GetFutureSchedule">
		select * from GetSchedule 
		where (schedule_date >  <cfqueryparam cfsqltype="CF_SQL_DATE" value="#createDate(year(request.timezoneadjustednow),month(request.timezoneadjustednow),day(request.timezoneadjustednow))#">)
		order by g_lname, g_fname
	</cfquery>
	<style>
		.checkedinRow {background-color:#ccffcc;}
			.checkedinRow td {font-size:10px;}
		.checkedinRowHover {background-color:#efefef;}
			.checkedinRowHover td {font-size:10px;}
		
		.notcheckedinRow {background-color:#aaeeaa;}
			.notcheckedinRow td {font-size:10px;}
		.notcheckedinRowHover {background-color:#efefef;}
			.notcheckedinRowHover td {font-size:10px;}
	</style>
	<script language="JavaScript">
		function ReprintAndPrintPop(vID) {
			printable=window.open("reprintDP.cfm?v_id="+vID,"printable","status=0,toolbar=0,width=800,height=600");
		}
		function ReissueAndPrintPop(vID) {
			printable=window.open("reissueDP.cfm?v_id="+vID,"printable","status=0,toolbar=0,width=800,height=600");
		}
		function GuestCheckin(vid,gid) {
			printable=window.open("guestcheckin.cfm?vid="+vid+"&gid="+gid,"printable","status=0,toolbar=0,width=825,height=700");
		}	
	</script><br>
		<div style="text-align:center"><strong>Authorized Access</strong></div>
		<table width="98%" cellpadding="0" cellspacing="2" border="0" align="center">
		<tr>
		<td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center">Guest<!--- /Company Name ---> (L/F)</td>
		<td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center">Resident Name (L/F)</td>
		<td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center">Resident Phone</td>
		<td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center">Address</td>
		<td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center">Visitor Type</td>
		<td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center">Access</td>
		<td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center" width="115">Actions</td>
		<!--- <td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center">Details</td>
		 ---></tr>
		
		<tbody>
		<cfif GetTodaySchedule.RecordCount>
			<cfoutput query="GetTodaySchedule" group="v_id">
			<cfif len(trim(g_checkedin)) AND val(g_singleentry)>
			<!-- skip single entry that has been activated -->
			<cfelse>
				<cfif len(trim(g_checkedin))>
					<tr class="checkedinRow" onmouseover="this.className='checkedinRowHover';" onmouseout="this.className='checkedinRow';">
				<cfelse>
					<tr class="notcheckedinRow" onmouseover="this.className='checkedinRowHover';" onmouseout="this.className='notcheckedinRow';">
				</cfif>
				<td>&nbsp;<a href="guestdetails.cfm?g_id=#g_id#&v_id=#v_id#">#ucase(g_lname)#, #ucase(g_fname)#</a></td>
				<td align="center">#ucase(r_lname)#, #ucase(r_fname)# </td>
				<td align="center">#h_phone#</td>
				<td align="center">#h_address#</td>
				<td align="center"><cfif g_permanent is 1>24/7<cfelseif val(g_singleentry)><strong style="color:red">single entry</strong><cfelse>full day</cfif></td>
				<td align="center">#dateFormat(schedule_date,"m/d/yyyy")#</td>
				<td align="left">
					<cfif getCommunity.dashpass eq 1>
						<input type="submit" value="reprint" style="font-size:9px;" onclick="ReprintAndPrintPop(#GetTodaySchedule.v_id#);">
						<cfif  NOT val(g_singleentry)>
							<input type="submit" value="reissue" style="font-size:9px;" onclick="ReissueAndPrintPop(#GetTodaySchedule.v_id#);">
						</cfif>
					<cfelse>
						<input type="submit" value="check-in" style="font-size:9px;" onclick="GuestCheckin(#GetTodaySchedule.v_id#,#GetTodaySchedule.g_id#);">
					</cfif>	
				</td>
				
				<!--- <form action="guestdetails.cfm" method="POST">
				<td align="center" style="font-size:10px;"><input type="hidden" name="g_id" value=#GetSchedule.g_id#><input type="hidden" name="v_id" value=#GetSchedule.v_id#><input type="submit" value=" : go : " style="font-size:9px;"></td></form>		
				 ---></tr>	
			 </cfif>
			</cfoutput>
		<cfelse>
		<tr><td colspan="7" align="center">No New Arrivals Today.</td></tr>
		</cfif>
		
	<cfif val(getCommunity.permanantguests)>
		</table> 
		
		<div style="text-align:center"><br /><strong>24/7 Access</strong></div>
		<table width="98%" cellpadding="0" cellspacing="2" border="0" align="center">
		<tr>
		<td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center">Guest<!--- /Company Name ---> (L/F)</td>
		<td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center">Resident Name (L/F)</td>
		<td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center">Resident Phone</td>
		<td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center">Address</td>
		<td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center">Visitor Type</td>
		<td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center">Access</td>
		<td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center" width="115">Actions</td>
		<!--- <td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center">Details</td>
		 ---></tr>
		<tbody>
		<!--- <cfoutput query="Get247ScheduleTODAY" group="v_id">
			<cfif len(trim(g_checkedin))>
				<tr class="checkedinRow" onmouseover="this.className='checkedinRowHover';" onmouseout="this.className='checkedinRow';">
			<cfelse>
				<tr class="notcheckedinRow" onmouseover="this.className='checkedinRowHover';" onmouseout="this.className='notcheckedinRow';">
			</cfif>
			<td style="font-size:10px;">&nbsp;<a href="guestdetails.cfm?g_id=#g_id#&v_id=#v_id#">#ucase(g_lname)#, #ucase(g_fname)#</a></td>
			<td align="center">#ucase(r_lname)#, #ucase(r_fname)# </td>
			<td align="center">#h_phone#</td>
			<td align="center">#h_address#</td>
			<td align="center">24/7</td>
			<td align="center">#dateFormat(g_initialvisit,"m/d/yyyy")#</td>
			<td align="left">
			<input type="submit" value="reprint" style="font-size:9px;" onclick="ReprintAndPrintPop(#v_id#);">
			<input type="submit" value="reissue" style="font-size:9px;" onclick="ReissueAndPrintPop(#v_id#);">
			</td></tr>	
		</cfoutput>
		<tr>
			<td colspan="7" style="border-bottom:1px solid black;">
			</td>
		</tr> --->
		<cfif Get247Schedule.RecordCount>
			<cfoutput query="Get247Schedule" group="v_id">
			<cfif len(trim(g_checkedin))>
				<tr class="checkedinRow" onmouseover="this.className='checkedinRowHover';" onmouseout="this.className='checkedinRow';">
			<cfelse>
				<tr class="notcheckedinRow" onmouseover="this.className='checkedinRowHover';" onmouseout="this.className='notcheckedinRow';">
			</cfif>
			<td>&nbsp;<a href="guestdetails.cfm?g_id=#g_id#&v_id=#v_id#">#ucase(g_lname)#, #ucase(g_fname)#</a></td>
				<td align="center">#ucase(r_lname)#, #ucase(r_fname)# </td>
			<td align="center">#h_phone#</td>
			<td align="center">#h_address#</td>
			<td align="center">24/7</td>
			<td align="center">#dateFormat(g_initialvisit,"m/d/yyyy")#</td>
			<td align="left">				
			<cfif getCommunity.dashpass eq 1>
				<input type="submit" value="reprint" style="font-size:9px;" onclick="ReprintAndPrintPop(#v_id#);">
				<input type="submit" value="reissue" style="font-size:9px;" onclick="ReissueAndPrintPop(#v_id#);">
			<cfelse>
				<input type="submit" value="check-in" style="font-size:9px;" onclick="GuestCheckin(#GetTodaySchedule.v_id#,#GetTodaySchedule.g_id#);">
			</cfif>	
			</td></tr>	
			</cfoutput>
		<cfelseif NOT Get247ScheduleTODAY.recordcount>
		<tr><td colspan="7" align="center">No 24/7 Guests.</td></tr>
		</cfif>
		</table>
        <cfif dateCompare(begintime,createDate(year(request.timezoneadjustednow),month(request.timezoneadjustednow),day(request.timezoneadjustednow))) lt 1>
        	<cfset begintime = dateAdd("d",1,begintime)>
       	</cfif>
	</cfif>
		<div style="text-align:center"><br /><strong>Future Access</strong> <cfoutput>(#dateFormat(BEGINTIME,"m/d/yyyy")# - #dateFormat(ENDTIME,"m/d/yyyy")#)</cfoutput></strong></div>
		<table width="98%" cellpadding="0" cellspacing="2" border="0" align="center">
		<tr>
		<td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center">Guest<!--- /Company Name ---> (L/F)</td>
		<td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center">Resident Name (L/F)</td>
		<td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center">Resident Phone</td>
		<td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center">Address</td>
		<td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center">Visitor Type</td>
		<td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center">Access</td>
		<td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center" width="115">Actions</td>
		<!--- <td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center">Details</td>
		 ---></tr>
		<tbody>
		<cfif GetFutureSchedule.RecordCount>
			<cfoutput query="GetFutureSchedule" group="v_id">
			<cfif dateCompare(createDate(year(request.timezoneadjustednow),month(request.timezoneadjustednow),day(request.timezoneadjustednow)),dateFormat(g_initialvisit,"m/d/yyyy")) neq 0>
			<tr bgcolor="##FBFBA8" height="19">
			<td style="font-size:10px;">&nbsp;<a href="guestdetails.cfm?g_id=#g_id#&v_id=#v_id#">#ucase(g_lname)#, #ucase(g_fname)#</a></td>
				<td style="font-size:10px;" align="center">#ucase(r_lname)#, #ucase(r_fname)# </td>
			<td style="font-size:10px;" align="center">#h_phone#</td>
			<td style="font-size:10px;" align="center">#h_address#</td>
			<td style="font-size:10px;" align="center"><cfif g_permanent is 1>24/7<cfelseif val(g_singleentry)><strong style="color:red">single entry</strong><cfelse>full day</cfif></td>
			<td style="font-size:10px;" align="center">#dateFormat(g_initialvisit,"m/d/yyyy")#</td>
			<td style="font-size:10px;" align="left">
			<cfif g_permanent is 1>
			<input type="submit" value=" : check-in : " style="font-size:9px;" onclick="ReprintAndPrintPop(#v_id#);">
			<cfelse>&nbsp;</cfif>
			</td>
			</tr>	
			</cfif>
			</cfoutput>
		<cfelse>
		<tr><td colspan="7" align="center">No Future Access.</td></tr>		
		</cfif>
		</tbody>
		</table>
		
		<!--- MAKE SURE THAT NON DASH PASS COMMUNITIES SEE ONLY "CHECK-IN" OR "DETAILS" BUTTONS (NOT RE-ISSUE, RE-PRINT) --->