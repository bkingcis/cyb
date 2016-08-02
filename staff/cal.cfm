<cfset eventdatelist = "">
<cfset visitdatelist = "">
<cfset datasource = caller.datasource>
<cfparam name="attributes.twentyfour7" default="false">

<cfset datastring = ''>
<cfparam name="attributes.calendarmode" default = "read" />
<cfparam name="attributes.hide" default = "" />
<cfparam name="attributes.SELECTEDLIST" default = "" />
<cfparam name="attributes.multiday" default = "true" />

<cfset stCalItems = structnew()>

<!--- sets current month/year --->
<cfset theyear = attributes.year>
<cfset themonth = attributes.month>

<!--- sets next month/year (used for) ---> 
<cfif (themonth + 1) gt 12>
	<cfset nextmonth = 1>
	<cfset nextmonthyear = theyear + 1>
<cfelse>	
	<cfset nextmonth = themonth + 1>
	<cfset nextmonthyear = theyear>
</cfif>

<cfset daysinthemonth = day(DateAdd("d",-1,createdate(nextmonthyear,nextmonth,1)))>

<cfparam name="attributes.selectorcolor" default="74dd82">
<cfoutput><style>
.selectedBox {background-color: ###attributes.selectorcolor#}
.preselectedBox {background-color: ###attributes.selectorcolor#}
.caleventBox {background-color: ###attributes.selectorcolor#}
</style></cfoutput>

<cftry>
<!--- Populate Visitors Object --->
<cfif NOT ListContains(attributes.hide,"visitors")>
<cfquery name="getEvents2" datasource="#datasource#">
	select date_part('day',s.visit_date) as dayofmonthdata,s.visit_date, s.r_id, 
		s.v_id, g.g_lname || ', ' || g.g_fname as gName, g.g_id
	from schedule s	join  guestvisits gv on s.v_id = gv.v_id
		join guests g on g.g_id = gv.g_id
	Where g.g_id = #attributes.g_id#	
	<cfif isDefined("attributes.v_id") AND val(attributes.v_id)>AND s.v_id = #attributes.v_id#</cfif>
	and visit_date between #CreateODBCDate(createDate(theyear,themonth,1))# AND #CreateODBCDate(DateAdd("d",-1,createdate(nextmonthyear,nextmonth,1)))#
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
	select date_part('day',e.eventdate) as dayofmonthdata, e.eventdate, t.abbreviation, r.r_fname, r.r_lname,
		e.specialevent_id, e.r_id, e.starttime, e.endtime, e.eventtypeid, t.label as EventLabel
		FROM specialevents e join communityEventTypes t on t.etid = e.eventtypeid
		join residents r on e.r_id = r.r_id
	Where eventdate between #CreateODBCDate(createDate(theyear,themonth,1))# AND #CreateODBCDate(DateAdd("d",-1,createdate(nextmonthyear,nextmonth,1)))#
	AND canceled IS null	
	AND e.c_id = #session.user_community#		
	<cfif isDefined("attributes.r_id") AND val(attributes.r_id)>AND r.r_id = #attributes.r_id#</cfif>
	<!--- added to remove past dates --->
	and eventdate > #CreateODBCDate(dateAdd("d",-1,request.timezoneadjustednow))#
	<cfif isDefined("attributes.eventID")>AND e.specialevent_id = #attributes.eventID# </cfif>
</cfquery>
<cfloop query="getEvents">
	<cfset eventdatelist = listappend(eventdatelist,dateformat(getEvents.eventdate,"yyyymd"))>
	<cfset stCalItemsKey = "d"&dateformat(getEvents.eventdate,"yyyymd")>
	<cfif NOT structKeyExists(stcalitems,stCalItemsKey)>
	<cfset temp = StructInsert(stCalItems,stCalItemsKey,abbreviation)>
	</cfif>
</cfloop>
</cfif>

<cfcatch type="any">
	<cfdump var="#cfcatch#"><cfabort>
</cfcatch>
</cftry>
<table width="150">
	<tr><th colspan="7" style="color:#333;padding-left:3px"><cfoutput>#MonthAsString(themonth)#</cfoutput></th></tr>
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
			<tr style="background-color: ##eee;color:black;font: 9px verdana bold;">
		</cfif>		
		<!--- day formatting --->
		<cfif structkeyExists(stCalItems,'d'&theyear&themonth&dayofmonth)><!--- style="background-color:##f77;"  --->
			<cfif stCalItems['d'&theyear&themonth&dayofmonth] is 'visitor'>
				<cfquery dbtype="query" name="qOfqGetEvents">
					select * from getEvents2
					WHERE dayofmonthdata = #dayofmonth#
				</cfquery>
				<cfset datastring = '<ul style="list-style-type:none;margin:0px;padding:0px;">'>
				<cfloop query="qOfqGetEvents">
					<cfset datastring = datastring & '<li class="popBoxList"><a href="modifyschedule2.cfm?g_id=' & qOfqGetEvents.g_id & '&v_id=' & qOfqGetEvents.v_id &'">' & qOfqGetEvents.gname & '</a></li>'>
				</cfloop>
					<td class="calGuestBox" onmouseover="this.className='calGuestBoxHover';" onmouseout="this.className='calGuestBox'" onclick="showDataPop('#urlEncodedFormat(dataString)#','#urlEncodedFormat(dateFormat(createDate(theyear,themonth,dayofmonth),"mmmm d, yyyy"))#');">#dayofmonth#</td>
			<cfelseif LEN(stCalItems['d'&theyear&themonth&dayofmonth])>
				<cfquery dbtype="query" name="qOfqGetEvents">
					select * from getEvents
					WHERE dayofmonthdata = #dayofmonth#
					order by r_lname,r_fname
				</cfquery>
				<cfset datastring = '<ul style="list-style-type:none;margin:0px;padding:0px;">'>
			
				<cfloop query="qOfqGetEvents">
					<cfset eventITem = ucase(qOfqGetEvents.abbreviation)>
					<cfset datastring = datastring & '<li class="row' & evaluate(qOfqGetEvents.recordcount mod 1) & '"><a href="specialEvents_view.cfm?r_id=#url.r_id#&specialEvent_id=#specialEvent_id#">' & ucase(r_lname) & ', ' & ucase(r_fname) & ' (' & trim(eventITem) &')</a><br /> (' & timeFormat(starttime,"short") & '-' & timeFormat(endtime,"short") & ')</li>'>
				</cfloop>
				<td class="calEventBox" onmouseover="this.className='calEventBoxHover';" onmouseout="this.className='calEventBox'" onclick="self.location='specialEvents_view.cfm?r_id=#val(r_id)#&eventDate=#urlEncodedFormat(dateFormat(createDate(theyear,themonth,dayofmonth),"m/d/yyyy"))#'">#dayofmonth#</td>
			<cfelse> 
				<td class="calEventBox" onmouseover="this.className='calEventBoxHover';" onmouseout="this.className='calEventBox'" onclick="showDataPop('#urlEncodedFormat(dataString)#','#urlEncodedFormat(dateFormat(createDate(theyear,themonth,dayofmonth),"mmmm d, yyyy"))#');">#dayofmonth#</td>
			</cfif>
		<cfelseif dateCompare(createdate(year(request.timezoneadjustednow),month(request.timezoneadjustednow),day(request.timezoneadjustednow)),createdate(theyear,themonth,dayofmonth)) eq 0>
			<cfif attributes.calendarmode is 'selector'>
				<cfset todayBorderColor = '6C6'>
			<cfelse>
			    <cfset todayBorderColor = '666'><!--- 6C6 --->
			</cfif>
			<cfif ListFind(attributes.selectedlist,"#themonth#/#dayofmonth#/#theyear#")
				OR 
				(
				attributes.twentyfour7 AND 
					(
					month(request.timezoneadjustednow) lt themonth 
					OR day(request.timezoneadjustednow) lt dayofmonth
					OR year(request.timezoneadjustednow) lt theyear
					)
				)><!--- OR (attributes.twentyfour7 and dateCompare(createDate(year(now()),month(now()),day(now())),createDate(theyear,themonth,dayofmonth)) lte 0) --->
				<cfset startClassName = "preselectedBox">
			<cfelse>
				<cfset startClassName = "calDayBox">
			</cfif>
			<td class="#startClassName#" style="border:1px solid ###todayBorderColor#;"
				<cfif attributes.calendarmode is "selector"> onclick="selectDateBox(this,'#themonth#/#dayofmonth#/#theyear#')"</cfif>>#dayofmonth#</td>
		<cfelse>
			<cfif ListFind(attributes.selectedlist,"#themonth#/#dayofmonth#/#theyear#")
				OR 
				(
				attributes.twentyfour7 AND 
					(
					month(request.timezoneadjustednow) lt themonth 
					OR day(request.timezoneadjustednow) lt dayofmonth
					OR year(request.timezoneadjustednow) lt theyear
					)
				)><!--- OR (attributes.twentyfour7 and dateCompare(createDate(year(now()),month(now()),day(now())),createDate(theyear,themonth,dayofmonth)) lte 0) --->
				<cfset startClassName = "preselectedBox">
			<cfelse>
				<cfset startClassName = "calDayBox">
			</cfif>
			<td class="#startClassName#"<cfif attributes.calendarmode is "selector"> onclick="selectDateBox(this,'#themonth#/#dayofmonth#/#theyear#')"</cfif> >#dayofmonth#</td>
		</cfif>
		<cfif dayofweek(createDate(theyear,themonth,dayofmonth)) eq 7></tr></cfif></cfloop>	
	</tr>
	</cfoutput>
</table>