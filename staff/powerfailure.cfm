<cfif NOT isDefined("session.staff_id") OR NOT VAL(session.staff_id)>
	<cflocation URL="../staff.cfm" addtoken="no">
</cfif>
<cfset timezoneadj = session.timezoneadj>
<CFSET BEGINTIME = CreateDateTime(DateFormat(request.timezoneadjustednow,"YYYY"),DateFormat(request.timezoneadjustednow,"MM"),DateFormat(request.timezoneadjustednow,"DD"),00,00,00)>
<CFSET ENDTIME = CreateDateTime(DateFormat(request.timezoneadjustednow,"YYYY"),DateFormat(request.timezoneadjustednow,"MM"),DateFormat(request.timezoneadjustednow,"DD"),23,59,59)>
<cfset tomorrow = dateAdd('d',1,request.timezoneadjustednow)>
<CFSET TOMORROWBEGINTIME = CreateDateTime(DateFormat(tomorrow,"YYYY"),DateFormat(tomorrow,"MM"),DateFormat(tomorrow,"DD"),00,00,00)>
<CFSET TOMORROWENDTIME = CreateDateTime(DateFormat(tomorrow,"YYYY"),DateFormat(tomorrow,"MM"),DateFormat(tomorrow,"DD"),23,59,59)>

<cfquery name="getCommunity" datasource="#datasource#">
	select * from communities 
	where c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#" />
</cfquery>
<cfquery datasource="#datasource#" name="getSearchResults">
		select g.g_id,g.r_id,g.g_lname,g.g_fname,gv.g_checkedin,<!--- v.g_checkedin, --->
		gv.v_id,gv.dashpass,gv.g_permanent,s.g_singleentry,s.visit_date as schedule_date,
		gv.g_cancelled,gv.g_initialvisit,r.r_id,r.h_id,h.c_id,
		r.r_fname,r.r_lname,h.h_id,h.h_address,h.h_phone 
		from guests g 
		join guestvisits gv on gv.g_id = g.g_id
		join residents r on g.r_id = r.r_id
		join homesite h on r.h_id = h.h_id
		join barcodes on gv.g_barcode = barcodes.barcode
		left join schedule s on gv.v_id = s.v_id 
		<!--- LEFT JOIN visits v on v.v_id = gv.v_id	
		  (bill king - I decided to move this logic into the display area because of the conflict between 24/7 and single entry types)	 --->
		WHERE h.c_id = #session.user_community#
		AND  barcodes.DATE_CANCELLED is null
		AND gv.G_CANCELLED is null 
		AND 
			(
				(s.visit_date BETWEEN '#dateFormat(begintime)# #timeFormat(begintime,'hh:mm tt')#' AND '#dateFormat(endtime)# #timeFormat(endtime,'hh:mm tt')#')
				OR gv.g_permanent = '1'
			)
		
		ORDER BY g_lname, g_fname, r_lname, schedule_date
</cfquery>
<cfquery name="GetSpecialEvents" datasource="#datasource#">
		select  r.r_fname, r.r_lname, h.h_phone, h.h_address, se.specialevent_id,
		se.starttime, se.endtime, t.label as eventlabel, r.r_id,  (
				select count(*) from specialeventvisits where specialevent_id = se.specialevent_id) as visitorcount 
		from specialEvents se 
		JOIN residents r on r.r_id = se.r_id
		join communityEventTypes t on t.etid = se.eventtypeid
		join homesite h on r.h_id = h.h_id
		where se.c_id = #session.user_community#
		and eventdate = #createDate(year(request.timezoneadjustednow),month(request.timezoneadjustednow),day(request.timezoneadjustednow))#
		ORDER BY se.starttime
	</cfquery>
	
<cfif 1 eq 1>
	<cfquery datasource="#datasource#" name="getSearchResults_tomorrow">
		select g.g_id,g.r_id,g.g_lname,g.g_fname,gv.g_checkedin,<!--- v.g_checkedin, --->
		gv.v_id,gv.dashpass,gv.g_permanent,s.g_singleentry,s.visit_date as schedule_date,
		gv.g_cancelled,gv.g_initialvisit,r.r_id,r.h_id,h.c_id,
		r.r_fname,r.r_lname,h.h_id,h.h_address,h.h_phone 
		from guests g 
		join guestvisits gv on gv.g_id = g.g_id
		join residents r on g.r_id = r.r_id
		join homesite h on r.h_id = h.h_id
		join barcodes on gv.g_barcode = barcodes.barcode
		left join schedule s on gv.v_id = s.v_id 
		<!--- LEFT JOIN visits v on v.v_id = gv.v_id	
		  (bill king - I decided to move this logic into the display area because of the conflict between 24/7 and single entry types)	 --->
		WHERE h.c_id = #session.user_community#
		AND  barcodes.DATE_CANCELLED is null
		AND gv.G_CANCELLED is null 
		AND 
			(
				(s.visit_date BETWEEN '#dateFormat(tomorrowbegintime)# #timeFormat(tomorrowbegintime,'hh:mm tt')#' AND '#dateFormat(tomorrowendtime)# #timeFormat(tomorrowendtime,'hh:mm tt')#')
				OR gv.g_permanent = '1'
			)
		
		ORDER BY g_lname, g_fname, r_lname, schedule_date
</cfquery>
<cfquery name="GetSpecialEvents_tomorrow" datasource="#datasource#">
		select  r.r_fname, r.r_lname, h.h_phone, h.h_address, se.specialevent_id,
		se.starttime, se.endtime, t.label as eventlabel, r.r_id,  (
				select count(*) from specialeventvisits where specialevent_id = se.specialevent_id) as visitorcount 
		from specialEvents se 
		JOIN residents r on r.r_id = se.r_id
		join communityEventTypes t on t.etid = se.eventtypeid
		join homesite h on r.h_id = h.h_id
		where se.c_id = #session.user_community#
		and eventdate = #createDate(year(tomorrow),month(tomorrow),day(tomorrow))#
		ORDER BY se.starttime
</cfquery>
</cfif>	
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>Cybatrol Power Failure</title>
<style type="text/css">
body {
	font-family : Tahoma,Verdana,Arial, Helvetica, sans-serif;
	font-size : 10pt;
	background-color: ##FFFFFF;
}

td {
	font-family : Tahoma,Verdana,Arial, Helvetica, sans-serif;
	font-size : 10pt;
}
</style>
</head>

<body onload="parent.print()">
<div align="center"><cfoutput>
		<cfif FileExists(ExpandPath("/uploadimages/#GetCommunity.c_crest#"))>
			<img src="/uploadimages/#GetCommunity.c_crest#" width="250" /><br><br>
		<cfelse>	
			<h2 style="color:##0662aa">#GetCommunity.c_name#</h2>
			<br><br>
		</cfif>	
<strong style="font-size:15px;">#DateFormat(request.timezoneadjustednow,"MM/DD/YYYY")# &nbsp; #TimeFormat(BEGINTIME,"h tt")# - #TimeFormat(ENDTIME,"h:mm tt")#</strong></cfoutput><br><strong>
&nbsp;</strong></div>

<cfif getSearchResults.RecordCount>
		<div align="center"><!--- <strong>SEARCH RESULTS</strong><br> ---><br>						
		<table cellpadding="0" cellspacing="0" border="0" width="747">
		<tr>
		<td style="font-weight:bold;background-color:#f5f5f5;color:Black;" align="left">Visitor/Company Name (L/F)</td>
		<td style="font-weight:bold;background-color:#f5f5f5;color:Black;" align="left">Resident Name (L/F)</td>
		<td style="font-weight:bold;background-color:#f5f5f5;color:Black;" align="left">Resident Address</td>
		<td style="font-weight:bold;background-color:#f5f5f5;color:Black;" align="center">Resident Phone</td>
		<td style="font-weight:bold;background-color:#f5f5f5;color:Black;" align="left" width="90"> &nbsp;</td>
		</tr>
		<cfoutput query="getSearchResults" group="v_id">
		
			<cfset rowTextColor="000">
			   <cfswitch expression="#getSearchResults.g_checkedin#">
					<cfcase value="">
						<cfif getSearchResults.RecordCount GT 0><cfset statusmessage = "NOT CHECKED IN"><cfset rowTextColor = "000"></cfif>
						<cfif getSearchResults.g_singleentry IS TRUE><cfset statusmessage = "SINGLE ENTRY"><cfset rowTextColor = "c33"></cfif>
						<!--- <cfif getSearchResults.g_permanent IS TRUE><cfset statusmessage = "24 / 7"></cfif> --->
					</cfcase>
					<cfdefaultcase>
						<cfset statusmessage = ""><!--- CHECKED-IN<br>#DateFormat(getSearchResults.g_checkedin,"MM/DD/YYYY")# --->
						<cfif getSearchResults.g_permanent IS TRUE><cfset statusmessage = "24 / 7"></cfif>
					</cfdefaultcase>
				</cfswitch>		
			<tr style="color:###rowTextColor#">
			<td valign="top" style="border-bottom:solid 1px black;">&nbsp;<strong>#ucase(getSearchResults.g_lname)#</strong><cfif len(getSearchResults.g_lname) and len(getSearchResults.g_fname)>, </cfif>#ucase(getSearchResults.g_fname)#</td>
			<td valign="top" style="border-bottom:solid 1px black;">#ucase(getSearchResults.r_lname)#,&nbsp;#ucase(getSearchResults.r_fname)#</td>
			<td align="left" valign="top" style="border-bottom:solid 1px black;">#getSearchResults.h_address#</td>
			<td align="center" valign="top" style="border-bottom:solid 1px black;">#getSearchResults.h_phone#</td>
			<td align="center" valign="top" style="border-bottom:solid 1px black;"></td><!--- #statusmessage# --->
			</tr>							
		</cfoutput>
		</table>
		</div>		
		
	 <div style="text-align:center;color:red;margin:8px;">Red - Single Entry Visitro</div>
	<cfelse>
		<div align="center" style="font-size:16px;font-weight:bold;">No Scheduled Visitors Expected.</div><br><br>				
	</cfif>
	
	<cfif GetSpecialEvents.Recordcount><br>
	<br>
	
		<div align="center"><strong>SPECIAL EVENTS</strong><br><br>						
		<table cellpadding="0" cellspacing="0" border="0" width="747">
		<tr>
		<td style="font-weight:bold;background-color:#f5f5f5;color:Black;" align="left">Resident Name (L/F)</td>
		<td style="font-weight:bold;background-color:#f5f5f5;color:Black;" align="center">Resident Phone</td>		
		<td style="font-weight:bold;background-color:#f5f5f5;color:Black;" align="center">Event Type</td>
		<td style="font-weight:bold;background-color:#f5f5f5;color:Black;" align="center">Time Frame</td>
		</tr>
		<cfoutput query="GetSpecialEvents">
		<tr class="notcheckedinRow" onmouseover="this.className='checkedinRowHover';" onmouseout="this.className='notcheckedinRow';">
			
			<td style="border-bottom:solid 1px black;">&nbsp;<strong>#ucase(r_lname)#</strong>, #ucase(r_fname)#</td>
			<td style="border-bottom:solid 1px black;" align="center">#h_phone#</td>
			<td style="border-bottom:solid 1px black;" align="center">&nbsp;#ucase(GetSpecialEvents.eventlabel)#</td><!--- 
			<td style="border-bottom:solid 1px black;" align="center">#h_address#</td> --->
			<td style="border-bottom:solid 1px black;" align="center">#TimeFormat(starttime,"h:mm tt")#-#TimeFormat(endtime,"h:mm tt")#</td>  
		</tr>
		</cfoutput>
		</table>
	</cfif>
	
	
	<cfif 1 eq 1>
	<br>
	<div style="clear:both;text-align:center;padding-top:80px;"><strong>Provided By:</strong><br />
	<img src="/images/footer.gif"></div>
	<hr />
	<p STYLE="page-break-before: always">&nbsp;</p>
	<br>
	
<div align="center">
	<cfoutput>
		<!--- <cfif FileExists(ExpandPath("/uploadimages/#GetCommunity.c_crest#"))>
			<img src="/uploadimages/#GetCommunity.c_crest#" width="250" /><br><br>
		<cfelse>	
			<h2 style="color:##0662aa">#GetCommunity.c_name#</h2>
			<br><br>
		</cfif> --->	<strong style="font-size:15px;">#DateFormat(tomorrow,"MM/DD/YYYY")# &nbsp; #TimeFormat(BEGINTIME,"h tt")# - #TimeFormat(ENDTIME,"h:mm tt")#</strong></cfoutput><br><strong>
&nbsp;</strong></div>

<cfif getSearchResults_tomorrow.RecordCount>
		<div align="center"><!--- <strong>SEARCH RESULTS</strong><br> ---><br>						
		<table cellpadding="0" cellspacing="0" border="0" width="747">
		<tr>
		<td style="font-weight:bold;background-color:#f5f5f5;color:Black;" align="left">Visitor/Company Name (L/F)</td>
		<td style="font-weight:bold;background-color:#f5f5f5;color:Black;" align="left">Resident Name (L/F)</td>
		<td style="font-weight:bold;background-color:#f5f5f5;color:Black;" align="left">Resident Address</td>
		<td style="font-weight:bold;background-color:#f5f5f5;color:Black;" align="center">Resident Phone</td>
		<td style="font-weight:bold;background-color:#f5f5f5;color:Black;" align="left"> &nbsp;</td>
		</tr>
		<cfoutput query="getSearchResults_tomorrow" group="v_id">
		<cfset rowTextColor="000">
			<cfswitch expression="#getSearchResults_tomorrow.g_checkedin#">
				<cfcase value="">
					<cfif getSearchResults_tomorrow.RecordCount GT 0><cfset statusmessage = "NOT CHECKED IN"><cfset rowTextColor = "000"></cfif>
					<cfif getSearchResults_tomorrow.g_singleentry IS TRUE><cfset statusmessage = "SINGLE ENTRY"><cfset rowTextColor = "c33"></cfif>
					<!--- <cfif getSearchResults.g_permanent IS TRUE><cfset statusmessage = "24 / 7"></cfif> --->
				</cfcase>
				<cfdefaultcase>
					<cfset statusmessage = ""><!--- CHECKED-IN<br>#DateFormat(getSearchResults.g_checkedin,"MM/DD/YYYY")# --->
					<cfif getSearchResults_tomorrow.g_permanent IS TRUE><cfset statusmessage = "24 / 7"></cfif>
				</cfdefaultcase>
			</cfswitch>
		
		<tr style="color:###rowTextColor#">
		<td valign="top" style="border-bottom:solid 1px black;">&nbsp;<strong>#ucase(getSearchResults_tomorrow.g_lname)#</strong><cfif len(getSearchResults_tomorrow.g_lname) and len(getSearchResults_tomorrow.g_fname)>, </cfif>#ucase(getSearchResults_tomorrow.g_fname)#</td>
		<td valign="top" style="border-bottom:solid 1px black;">#ucase(getSearchResults_tomorrow.r_lname)#,&nbsp;#ucase(getSearchResults_tomorrow.r_fname)#</td>
		<td align="left" valign="top" style="border-bottom:solid 1px black;">#getSearchResults_tomorrow.h_address#</td>
		<td align="center" valign="top" style="border-bottom:solid 1px black;">#getSearchResults_tomorrow.h_phone#</td>
		<td align="center" valign="top" style="border-bottom:solid 1px black;"></td>		<!--- #statusmessage# --->		
		</tr>							
		</cfoutput>
		</table>
		</div>		
	 <div style="text-align:center;color:red;margin:8px;">Red - Single Entry Visitor</div>
	<cfelse>
		<div align="center" style="font-size:16px;font-weight:bold;">No Scheduled Visitors Expected.</div><br><br>				
	</cfif>
	
	<cfif GetSpecialEvents_tomorrow.Recordcount><br>
	<br>
	
		<div align="center"><strong>SPECIAL EVENTS</strong><br><br>						
		<table cellpadding="0" cellspacing="0" border="0" width="747">
		<tr>
		<td style="font-weight:bold;background-color:#f5f5f5;color:Black;" align="left">Resident Name (L/F)</td>
		<td style="font-weight:bold;background-color:#f5f5f5;color:Black;" align="center">Resident Phone</td>		
		<td style="font-weight:bold;background-color:#f5f5f5;color:Black;" align="center">Event Type</td>
		<td style="font-weight:bold;background-color:#f5f5f5;color:Black;" align="center">Time Frame</td>
		</tr>
		<cfoutput query="GetSpecialEvents_tomorrow">
		<tr class="notcheckedinRow" onmouseover="this.className='checkedinRowHover';" onmouseout="this.className='notcheckedinRow';">
			
			<td style="border-bottom:solid 1px black;">&nbsp;<strong>#ucase(r_lname)#</strong><cfif len(r_lname) and len(r_fname)>, </cfif>#ucase(r_fname)#</td>
			<td style="border-bottom:solid 1px black;" align="center">#h_phone#</td>
			<td style="border-bottom:solid 1px black;" align="center">&nbsp;#ucase(GetSpecialEvents_tomorrow.eventlabel)#</td><!--- 
			<td style="border-bottom:solid 1px black;" align="center">#h_address#</td> --->
			<td style="border-bottom:solid 1px black;" align="center">#TimeFormat(starttime,"h:mm tt")#-#TimeFormat(endtime,"h:mm tt")#</td>  
		</tr>
		</cfoutput>
		</table>
		
	</cfif> <!--- END GetSpecialEvents_tomorrow block --->
	</cfif>
	
	<div style="clear:both;text-align:center;padding-top:80px;"><strong>Provided By:</strong><br />
	<img src="/images/footer.gif"></div>
</body>
</html>

