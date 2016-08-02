<cfparam name="attributes.g_lname" default="">
<cfparam name="attributes.g_fname" default="">
<cfparam name="attributes.r_lname" default="">
<cfparam name="attributes.r_fname" default="">

<cfset start = dateadd("d",-20,request.timezoneadjustednow)>
<cfset BEGINTIME = createDate(year(start),month(start),day(start))>
<cfset ENDTIME = dateAdd("d",21,begintime)>

<cfquery datasource="#datasource#" name="getDatedVisits">
	SELECT g.g_fname,g.g_lname,r.r_fname,r.r_lname,h.h_address,h.h_phone,
		s.visit_date as schedule_date,gv.g_permanent,s.g_singleentry,v.visit_id,
		v.g_checkedin,gv.g_barcode,g.g_id,gv.v_id,v.g_checkedin
		FROM guests g
			join guestvisits gv on gv.g_id = g.g_id
			join visits v on gv.v_id = v.v_id  and g.g_id = v.g_id
			join residents r on g.r_id = r.r_id
			join homesite h on r.h_id = h.h_id
			left join schedule s  on gv.v_id = s.v_id
	WHERE g.c_id = #session.user_community# 
		<cfif ListLen(attributes.allselected)>AND	 
		(       <cfloop list="#attributes.allSelected#" index="ITTdate">
					<cfset nextday = createDate(year(dateAdd("d",1,ITTdate)),month(dateAdd("d",1,ITTdate)),day(dateAdd("d",1,ITTdate)))>
					(v.g_CHECKEDIN BETWEEN '#dateFormat(ITTDATE)# 00:00:00' AND '#dateFormat(nextday)# 00:00:00' 
		)
					<cfif NOT listFind(attributes.allselected,ITTdate) eq listLen(attributes.allSelected)> OR </cfif>
				</cfloop>)
		</cfif>
		<CFIF len(trim(attributes.g_lname))>AND upper(g_lname) LIKE '#trim(ucase(attributes.g_lname))#%'</CFIF>
		<CFIF len(trim(attributes.g_fname))>AND upper(g_fname) LIKE '#trim(ucase(attributes.g_fname))#%'</CFIF>
		<CFIF len(trim(attributes.r_lname))>AND upper(r_lname) LIKE '#trim(ucase(attributes.r_lname))#%'</CFIF>
		<CFIF len(trim(attributes.r_fname))>AND upper(r_fname) LIKE '#trim(ucase(attributes.r_fname))#%'</CFIF>	
	ORDER BY 
	<cfif isDefined("sort")>
		#sort#
	<cfelse>
		g_lname, g_fname, gv.v_id desc
	</cfif>
</cfquery>
<cfquery datasource="#datasource#" name="getDatedNoShows">
	SELECT g.g_fname,g.g_lname,r.r_fname,r.r_lname,h.h_address,h.h_phone,
		s.visit_date as schedule_date,gv.g_permanent,s.g_singleentry,
		v.g_checkedin,gv.g_barcode,g.g_id,gv.v_id,v.g_checkedin
		
		FROM 
			
			guestvisits gv join schedule s  on gv.v_id = s.v_id
			join guests g on g.g_id = s.g_id
			join residents r on g.r_id = r.r_id
			join homesite h on r.h_id = h.h_id
			left join	visits v on gv.v_id = v.v_id 
		
		WHERE  v.v_id is null
		<cfif ListLen(attributes.allSelected)>AND 
		 (<cfloop list="#attributes.allSelected#" index="ITTdate">
					<cfset nextday = createDate(year(dateAdd("d",1,ITTdate)),month(dateAdd("d",1,ITTdate)),day(dateAdd("d",1,ITTdate)))>
					(s.visit_date  BETWEEN '#dateFormat(ITTDATE)# 0:00:00' AND '#dateFormat(nextday)# 0:00:00')
					<cfif NOT listFind(attributes.allselected,ITTdate) eq listLen(attributes.allSelected)> OR </cfif>
				</cfloop>)
		</cfif>
		
			<CFIF len(trim(attributes.g_lname))>AND upper(g_lname) LIKE '#trim(ucase(attributes.g_lname))#%'</CFIF>
				<CFIF len(trim(attributes.g_fname))>AND upper(g_fname) LIKE '#trim(ucase(attributes.g_fname))#%'</CFIF>
				<CFIF len(trim(attributes.r_lname))>AND upper(r_lname) LIKE '#trim(ucase(attributes.r_lname))#%'</CFIF>
				<CFIF len(trim(attributes.r_fname))>AND upper(r_fname) LIKE '#trim(ucase(attributes.r_fname))#%'</CFIF>
			
	AND	 g.c_id = #session.user_community#
	ORDER BY g_lname, g_fname, gv.v_id desc
	
</cfquery>
<style>
		.visitedRow {background-color:#ccf;}
			.visitedRow td {font-size:10px;background-color:#ccf;}
		.visitedRowHover {background-color:#efefef;}
			.visitedRowHover td {font-size:10px;background-color:#efefef;}
		
		.notcheckedinRow {background-color:#eee;}
			.notcheckedinRow td {font-size:10px;}
		.notcheckedinRowHover {background-color:#efefef;}
			.notcheckedinRowHover td {font-size:10px;}
	</style>
<br>
	
<div style="text-align:center"><strong>Recorded Visits</strong></div>
<table width="98%" cellpadding="1" cellspacing="2" border="0" align="center">
	<tr>
		<td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center">Guest Name <!--- /Company Name ---> (L/F)</td>
		<td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center">Resident Name</td>
		<td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center">Resident Phone</td>
		<td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center">Address</td>
		<td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center">Visitor Type</td>
		<td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center">Entry Data (<cfoutput><a href="?searchcrit=sp_date&sort=visit_id&allSelected=#allSelected#">sort</a></cfoutput>)</td>
	</tr>
	<tbody>
		<cfif getDatedVisits.RecordCount>
			<cfif isDefined("sort") and sort is "visit_id"><!--- group by visit_id instead of v_id --->
			<cfoutput query="getDatedVisits" group="visit_id">
				<tr class="visitedRow" onmouseover="this.className='visitedRowHover';" onmouseout="this.className='visitedRow';">
				<td>&nbsp;<a href="guestdetails.cfm?g_id=#g_id#&v_id=#v_id#">#ucase(g_lname)#, #ucase(g_fname)#</a></td>
				<td align="center">#ucase(r_lname)#, #ucase(r_fname)# </td>
				<td align="center">#h_phone#</td>
				<td align="center">#h_address#</td>
				<td align="center"><cfif g_permanent is 1>24/7<cfelseif val(g_singleentry)>single entry<cfelse>full day</cfif></td>
				<td align="center">#dateFormat(g_checkedin,"m/d/yyyy")# #timeFormat(g_checkedin,"hh:mm tt")#</td>
				<!--- <td align="left">
					&nbsp;
				</td> ---></tr>
			</cfoutput>
			<cfelse>
			<cfoutput query="getDatedVisits" group="v_id">
				<tr class="visitedRow" onmouseover="this.className='visitedRowHover';" onmouseout="this.className='visitedRow';">
				<td style="font-size:10px;">&nbsp;<a href="guestdetails.cfm?g_id=#g_id#&v_id=#v_id#">#ucase(g_lname)#, #ucase(g_fname)#</a></td>
				<td align="center" style="font-size:10px;">#ucase(r_lname)#, #ucase(r_fname)# </td>
				<td align="center" style="font-size:10px;">#h_phone#</td>
				<td align="center" style="font-size:10px;">#h_address#</td>
				<td align="center" style="font-size:10px;"><cfif g_permanent is 1>24/7<cfelseif val(g_singleentry)>single entry<cfelse>full day</cfif></td>
				<td align="center" style="font-size:10px;">#dateFormat(g_checkedin,"m/d/yyyy")# #timeFormat(g_checkedin,"hh:mm tt")#</td>
				<!--- <td align="left" style="font-size:10px;">
					&nbsp;
				</td> ---></tr>
			</cfoutput>
			</cfif>
		<cfelse>
		<tr><td colspan="6" align="center">No Visits For Selected Time Period</td></tr>
		</cfif>
		</tbody> 
	</table>
	<br>		
	<div style="text-align:center"><strong>No Entry Recorded</strong></div>
	<table width="98%" cellpadding="1" cellspacing="2" border="0" align="center">
	<tr>
		<td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center">Guest Name (L/F)</td>
		<td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center">Resident Name</td>
		<td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center">Resident Phone</td>
		<td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center">Address</td>
		<td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center">Visitor Type</td>
		<td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center">Scheduled Date</td>
	</tr>
	<tbody>
		<cfif getDatedNoShows.RecordCount>
			<cfoutput query="getDatedNoShows" group="v_id">
			<tr class="visitedRow" onmouseover="this.className='visitedRowHover';" onmouseout="this.className='visitedRow';">
				<td style="font-size:10px;">&nbsp;<a href="guestdetails.cfm?g_id=#g_id#&v_id=#v_id#">#ucase(g_lname)#, #ucase(g_fname)#</a></td>
				<td align="center" style="font-size:10px;">#ucase(r_lname)#, #ucase(r_fname)# </td>
				<td align="center" style="font-size:10px;">#h_phone#</td>
				<td align="center" style="font-size:10px;">#h_address#</td>
				<td align="center" style="font-size:10px;"><cfif g_permanent is 1>24/7<cfelseif val(g_singleentry)><strong style="color:red">single entry</strong><cfelse>full day</cfif></td>
				<td align="center" style="font-size:10px;">#dateFormat(schedule_date,"m/d/yyyy")#</td>
			</tr>	
			</cfoutput>
		<cfelse>
		<tr><td colspan="6" align="center">No No-Shows For Selected Time Period</td></tr>
		</cfif>
	</tbody> 		
</table>
