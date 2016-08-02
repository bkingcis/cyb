<cfset eventdatelist = "">
<cfset visitdatelist = "">
<cfset datasource = caller.datasource>
<cfif not isDefined("attributes.r_id")>
<cfset attributes.r_id = session.user_id>
</cfif>

<cfset datastring = ''>
<cfparam name="attributes.calendarmode" default = "read" />
<cfparam name="attributes.hide" default = "" />
<cfparam name="attributes.SELECTEDLIST" default = "" />
<cfparam name="attributes.itterationVal" default="1" />

<cfset stCalItems = structnew()>
<cfif attributes.month gt 12>
	<cfset theyear = year(request.timezoneadjustednow) + 1>
	<cfset themonth = attributes.month - 12>
<cfelseif attributes.month lt 1>
	<cfset theyear = year(request.timezoneadjustednow) - 1>
	<cfset themonth = attributes.month + 12>
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

<cfparam name="attributes.selectorcolor" default="74dd82">
<cfoutput><style>
.selectedBox {background-color: ###attributes.selectorcolor#}
.preselectedBox {background-color: ###attributes.selectorcolor#}
</style></cfoutput>

<!--- Populate Visitors Object --->
<cfif NOT ListContains(attributes.hide,"visitors")>
<cfquery name="getEvents2" datasource="#datasource#">
	select distinct date_part('day',s.visit_date) as dayofmonthdata,s.visit_date, s.r_id, gv.guestcompanioncount,
		s.v_id, g.g_lname || ', ' || g.g_fname as gName, g.g_id,  s.g_singleentry, gv.insertedby_staff_id
	from schedule s	join  guestvisits gv on s.v_id = gv.v_id
		join guests g on g.g_id = gv.g_id
		<!--- left join visits v on v.v_id = gv.v_id and v.g_id = s.g_id --->
	Where s.r_id = #attributes.r_id#	
	and visit_date between #CreateODBCDate(createDate(theyear,themonth,1))# AND #CreateODBCDate(DateAdd("d",-1,createdate(nextmonthyear,nextmonth,1)))#
		<cfif isDefined('url.v_id') and val(url.v_id)>
			AND s.v_id = #url.v_id#
		</cfif>
	<!--- added to remove past dates --->
	and visit_date >= #CreateODBCDate(createDate(year(request.timezoneadjustednow),month(request.timezoneadjustednow),day(request.timezoneadjustednow)))#
	and gv.g_cancelled is null
</cfquery>
<cfloop query="getEvents2">
	<cfif g_singleentry>
		<cfquery name="getSEVisits" datasource="#datasource#">
			select v_id from visits
			where v_id = #getEvents2.v_id#
		</cfquery> 
		<cfif NOT getSEVisits.recordcount>
			<cfset visitdatelist = listappend(visitdatelist,dateformat(getEvents2.visit_date,"yyyymd"))>
			
			<cfif NOT structKeyExists(stCalItems,"d"&dateformat(getEvents2.visit_date,"yyyymd"))>
				<cfset temp = StructInsert(stCalItems,"d"&dateformat(getEvents2.visit_date,"yyyymd"),'visitor')>
			</cfif>
		</cfif> 
	<cfelse>
		<cfset visitdatelist = listappend(visitdatelist,dateformat(getEvents2.visit_date,"yyyymd"))>
	<cfif NOT structKeyExists(stCalItems,"d"&dateformat(getEvents2.visit_date,"yyyymd"))>
		<cfset temp = StructInsert(stCalItems,"d"&dateformat(getEvents2.visit_date,"yyyymd"),'visitor')>
	</cfif>
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
	AND r_id = #attributes.r_id#	
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
			<tr style="background-color: ##eee;color:black;font: 9px verdana bold;">
		</cfif>		
		
		<!--- day formatting --->
		<cfif structkeyExists(stCalItems,'d'&theyear&themonth&dayofmonth)><!--- style="background-color:##f77;"  --->
			<cfif stCalItems['d'&theyear&themonth&dayofmonth] is 'visitor'>
				<cfquery dbtype="query" name="qOfqGetEvents">
					SELECT * from getEvents2
					WHERE dayofmonthdata = #dayofmonth#
					<!---<cfif NOT isDefined("url.v_id")> we will not show single entry visitors if they have already used the pass 
					 	AND (g_singleentry = '0' OR g_checkedin is null)
					</cfif>--->
				</cfquery>
				<cfset datastring = '<ul style="list-style-type:none;margin:0px;padding:0px;">'>
				<cfloop query="qOfqGetEvents">
					<cfset skipitem = false>
					<cfif qOfqGetEvents.g_singleentry>
						<!--- this *Should* only be an issue on the current date (today) --->
						<cfquery datasource="#datasource#" name="qVisitsForSingleEntry">
							select g_checkedin  from visits
							where v_id = #qOfqGetEvents.v_id#
						</cfquery>
						<cfif qVisitsForSingleEntry.recordcount>
							<cfset skipitem = true>
						</cfif>
					</cfif>
					<cfif NOT skipitem>
					<cfset appendToName = ''>
					<cfif guestcompanioncount>
						<cfset appendToName = appendToName & '(+#guestcompanioncount#)'>
					</cfif>
					<cfset datastring = datastring & '<li class="popBoxList"><a href="modifyschedule2.cfm?r_id=#r_id#&g_id=' & qOfqGetEvents.g_id & '&v_id=' & qOfqGetEvents.v_id &'">' & qOfqGetEvents.gname & appendToName & '</a>' & iif(qOfqGetEvents.insertedby_staff_id eq 0,"",DE('*')) & '</li>'>
					</cfif>
				</cfloop>
				<cfset datastring = datastring & '</ul>'>
				<cfquery dbtype="query" name="qOfqGetEvents">
					select * from getEvents
					WHERE dayofmonthdata = #dayofmonth#
				</cfquery>
				<cfif qOfqGetEvents.recordcount>
					<cfset useTDclass = "calBothBox">
				<cfset datastring = datastring & '<br /><ul style="list-style-type:none;margin:0px;padding:0px;">'>
				<cfloop query="qOfqGetEvents">
					<cfset datastring = datastring & '<li class="popBoxList"><a href="modspecialevent.cfm?r_id=#r_id#&specialevent_id=' & qOfqGetEvents.specialevent_id & '">' & ucase(qOfqGetEvents.EventLabel) & '</a></li>'>
				</cfloop>
				<cfset datastring = datastring & '</ul>'>
				<cfelse>
					<cfset useTDclass = "calGuestBox">
				</cfif>
					<td class="#useTDclass#" onmouseover="this.className='calGuestBoxHover';" onmouseout="this.className='#useTDclass#'" onclick="showDataPop('#urlEncodedFormat(dataString)#','#urlEncodedFormat(dateFormat(createDate(theyear,themonth,dayofmonth),"mmmm d, yyyy"))#');">#dayofmonth#</td>
			<cfelse>
				<cfquery dbtype="query" name="qOfqGetEvents">
					select * from getEvents
					WHERE dayofmonthdata = #dayofmonth#
				</cfquery>
				<cfset datastring = '<ul style="list-style-type:none;margin:0px;padding:0px;">'>
				<cfloop query="qOfqGetEvents">
					<cfset datastring = datastring & '<li class="popBoxList"><a href="modspecialevent.cfm?specialevent_id=' & qOfqGetEvents.specialevent_id & '">' & ucase(qOfqGetEvents.EventLabel) & '</a></li>'>
				</cfloop>
				<td class="calEventBox" onmouseover="this.className='calEventBoxHover';" onmouseout="this.className='calEventBox'" onclick="showDataPop('#urlEncodedFormat(dataString)#','#urlEncodedFormat(dateFormat(createDate(theyear,themonth,dayofmonth),"mmmm d, yyyy"))#');">#dayofmonth#</td>
			</cfif>
		<cfelse>
			<cfif ListFind(attributes.selectedlist,"#themonth#/#dayofmonth#/#theyear#")>
				<cfset startClassName = "preselectedBox">
			<cfelse>
				<cfset startClassName = "calDayBox">
			</cfif>
			 <!---  IF it was already selected --->
			   <td <cfif dateCompare(createdate(year(request.timezoneadjustednow),month(request.timezoneadjustednow),day(request.timezoneadjustednow)),createdate(theyear,themonth,dayofmonth)) eq 0>style="border:1px solid ##666;" </cfif>class="#startClassName#"<cfif attributes.calendarmode is "selector" 
			   			AND dateCompare(createDate(year(request.timezoneadjustednow),month(request.timezoneadjustednow),day(request.timezoneadjustednow)),createDate(theyear,themonth,dayofmonth)) neq 1> onclick="selectDateBox(this,'#themonth#/#dayofmonth#/#theyear#',#attributes.itterationVal#)"</cfif>>#dayofmonth#</td>
		</cfif>
		<cfif dayofweek(createDate(theyear,themonth,dayofmonth)) eq 7></tr></cfif></cfloop>	
	</tr>
	</cfoutput>
</table>

