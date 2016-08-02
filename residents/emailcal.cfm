<cfset eventdatelist = "">
<cfset visitdatelist = "">
<cfset datasource = caller.datasource>

<cfset datastring = ''>
<cfparam name="attributes.calendarmode" default = "read" />
<cfparam name="attributes.hide" default = "" />
<cfparam name="attributes.SELECTEDLIST" default = "" />

<cfset stCalItems = structnew()>
<cfif attributes.month gt 12>
	<cfset theyear = year(request.timezoneadjustednow) + 1>
	<cfset themonth = attributes.month - 12>
<cfelse>
	<cfset theyear = year(request.timezoneadjustednow)>
	<cfset themonth = attributes.month>
</cfif>
<cfif (themonth + 1) eq 13>
	<cfset nextmonth = 1>
	<cfset nextmonthyear = theyear + 1>
<cfelse>	
	<cfset nextmonth = themonth + 1>
	<cfset nextmonthyear = theyear>
</cfif>

<cfset daysinthemonth = day(DateAdd("d",-1,createdate(nextmonthyear,nextmonth,1)))>

<!--- Populate Visitors Object --->
<cfif NOT ListContains(attributes.hide,"visitors")>
<cfquery name="getEvents2" datasource="#datasource#">
	select date_part('day',s.visit_date) as dayofmonthdata,s.visit_date, s.r_id, 
		s.v_id, g.g_lname || ', ' || g.g_fname as gName, g.g_id
	from schedule s	join  guestvisits gv on s.v_id = gv.v_id
		join guests g on g.g_id = gv.g_id
	Where s.r_id = #session.user_id#	
	and visit_date between #CreateODBCDate(createDate(theyear,themonth,1))# AND #CreateODBCDate(DateAdd("d",-1,createdate(nextmonthyear,nextmonth,1)))#
		<cfif isDefined('attributes.v_id') and val(attributes.v_id)>AND s.v_id = #attributes.v_id#</cfif>
	<!--- added to remove past dates --->
	and visit_date > #CreateODBCDate(dateAdd("d",-1,request.timezoneadjustednow))#
</cfquery>
<cfloop query="getEvents2">
	<cfset visitdatelist = listappend(visitdatelist,dateformat(getEvents2.visit_date,"yyyymd"))>
		<cfif NOT structKeyExists(stCalItems,"d"&dateformat(getEvents2.visit_date,"yyyymd"))>
	<cfset temp = StructInsert(stCalItems,"d"&dateformat(getEvents2.visit_date,"yyyymd"),'visitor')>
	</cfif>
</cfloop>
</cfif>

<!--- Populate Events Object --->
<cfif NOT ListContains(attributes.hide,"events")>
<cfquery name="getEvents" datasource="#request.dsn#">
	select date_part('day',e.eventdate) as dayofmonthdata, e.eventdate, t.abbreviation,
		e.specialevent_id, e.r_id, e.starttime, e.endtime, e.eventtypeid, t.label as EventLabel
		FROM specialevents e join communityEventTypes t on t.etid = e.eventtypeid
	Where eventdate between #CreateODBCDate(createDate(theyear,themonth,1))# 
		AND #CreateODBCDate(DateAdd("d",-1,createdate(nextmonthyear,nextmonth,1)))#
	AND canceled IS null
	AND r_id = #session.user_id#	
	<!--- added to remove past dates --->
	and eventdate > #CreateODBCDate(dateAdd("d",-1,request.timezoneadjustednow))#
</cfquery>
<cfloop query="getEvents">
	<cfset eventdatelist = listappend(eventdatelist,dateformat(getEvents.eventdate,"yyyymd"))>
	<cfset stCalItemsKey = "d"&dateformat(getEvents.eventdate,"yyyymd")>
	<cfif NOT structKeyExists(stcalitems,stCalItemsKey)>
	<cfset temp = StructInsert(stCalItems,stCalItemsKey,abbreviation)>
	</cfif>
</cfloop>
</cfif>


<table width="150">
	<tr><th colspan="7" style="color:#333;"><cfoutput>#MonthAsString(themonth)#</cfoutput></th></tr>
	<tr style="background-color: #666;color:white;font: 9px verdana bold;">
		<td align="center">s</td>
		<td align="center">m</td>
		<td align="center">t</td>
		<td align="center">w</td>
		<td align="center">t</td>
		<td align="center">f</td>
		<td align="center">s</td>
	</tr>
	<cfoutput>
	<tr style="background-color: ##eee;color:black;font: 9px verdana bold;">
		<!--- pre month cells --->
		<cfloop from="1" to="#DayOfWeek(CreateDate(theYear,theMonth,1))-1#" index="x">
			<td bgcolor="##dddddd">&nbsp;</td>
		</cfloop>
		<cfloop from="1" to="#daysinthemonth#" index="dayofmonth">		
		<cfif dayofweek(createDate(theyear,themonth,dayofmonth)) eq 1>
			<tr style="color:black;font: 9px verdana;">
		</cfif>		
		
		<!--- day formatting --->
		<cfif structkeyExists(stCalItems,'d'&theyear&themonth&dayofmonth)><!--- style="background-color:##f77;"  --->
			<cfif stCalItems['d'&theyear&themonth&dayofmonth] is 'visitor'>
				<cfquery dbtype="query" name="qOfqGetEvents">
					select * from getEvents2
					WHERE dayofmonthdata = #dayofmonth#
				</cfquery>
				<cfif qOfqGetEvents.recordcount and not listFindNoCase(attributes.hide,'events')>
					<cfset useTDARG = 'class="calBothBox"'>
				<cfelse>
					<cfset useTDARG = 'class="calGuestBox" bgcolor="##66CC66"'>
				</cfif>
					<td #useTDARG#>#dayofmonth#</td>
			<cfelse>
				<cfquery dbtype="query" name="qOfqGetEvents">
					select * from getEvents
					WHERE dayofmonthdata = #dayofmonth#
				</cfquery>
				<td class="calEventBox">#dayofmonth#</td>
			</cfif>
		<cfelse>
			<cfif ListFind(attributes.selectedlist,"#themonth#/#dayofmonth#/#theyear#")>
				<cfset startClassName = "preselectedBox">
			<cfelse>
				<cfset startClassName = "calDayBox">
			</cfif>
			 <!---  IF it was already selected --->
			   <td class="#startClassName#">#dayofmonth#</td>
		</cfif>
		<cfif dayofweek(createDate(theyear,themonth,dayofmonth)) eq 7></tr></cfif></cfloop>	
	</tr>
	</cfoutput>
</table>

