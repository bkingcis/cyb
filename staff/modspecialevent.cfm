<cfinclude template="../header5.cfm"><cfinclude template="include/staffheaderinfo.cfm">

	<cfset request.dsn = datasource>

<cfquery name="getEvents2" datasource="#datasource#">
	select * from specialevents
	where c_id =<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#" />
	AND specialEvent_id = #url.specialevent_id#
</cfquery>

<cfquery datasource="#request.dsn#" name="qEventTypes">
	Select * from CommunityeventTypes
	where c_id = #session.user_community#
	order by label
</cfquery>

<cfif getEvents2.recordcount>
<cfquery name="getRes" datasource="#datasource#">
	select * from Residents
	Where r_id = #getEvents2.r_id#
</cfquery>
<cfelse>
	<script>
		alert('Event not found. Use your back button and try again.')
	</script>
	<cfabort>
</cfif>
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
<div style="clear:both;">
	</div><br/>

<form name="testForm" action="modspecialevent2.cfm" method=POST>
<cfoutput><cfset session.specialevent_id = url.specialevent_id></cfoutput><br>
<table align="center">
<tr><td colspan="2" align="center">
<b>EDIT EVENT INFORMATION</b><br /><br />
<table align="center">
<cfset dateList = "">
<cfloop query="getEvents2">
	<cfset dateList = listAppend(dateList,dateFormat(getEvents2.eventdate,"m/d/yyyy"))>
</cfloop>
	<cfset request.dsn = datasource>
	<tr>
		<td valign="top"><cf_cal multiday="false" month="#month(request.timezoneadjustednow)#" year="#year(request.timezoneadjustednow)#" calendarmode="selector" selectorcolor="eeee77" hide="events,visitors" selectedList="#dateList#"></td>
		<td valign="top"><cf_cal multiday="false" month="#month(dateAdd("m",1,request.timezoneadjustednow))#" year="#year(dateAdd("m",1,request.timezoneadjustednow))#" calendarmode="selector" selectorcolor="eeee77" hide="events,visitors" selectedList="#dateList#"></td>	
		<td valign="top"><cf_cal multiday="false" month="#month(dateAdd("m",2,request.timezoneadjustednow))#" year="#year(dateAdd("m",2,request.timezoneadjustednow))#" calendarmode="selector" selectorcolor="eeee77" hide="events,visitors" selectedList="#dateList#"></td>	
		<td valign="top"><cf_cal multiday="false" month="#month(dateAdd("m",3,request.timezoneadjustednow))#" year="#year(dateAdd("m",3,request.timezoneadjustednow))#" calendarmode="selector" selectorcolor="eeee77" hide="events,visitors" selectedList="#dateList#"></td>	
	</tr>
</table>
</td>
</tr>
<tr><td>

	<table width="95%" align="center" cellpadding="0" cellspacing="0" border="0">		
		<tr>
		<td width="10%" align="left">
			<select name="dateList" size="1" style="visibility:hidden;">
			<option value="-">-----------------</option>
			</select><BR>
			<script language="JavaScript">
			document.testForm.dateList.options[0]=null; 
			</script>
		</td>
		<td width="40%" align="center" style="border-top:1px solid black;border-bottom:1px solid black;border-right:1px solid black;border-left:1px solid black;background-color:f5f5f5;"><div align="center" style="font-weight:bold;padding-bottom:10px;">Beginning Time of Event</div>
		<cfoutput>
		<select name="starttime">
			<cfloop from="0" to="23" index="i">
			<cfloop from="0" to="45" step="15" index="m">
			<cfif len(m) neq 2><cfset min = "00"><cfelse><cfset min = m></cfif>
			<cfset ittValue = i & ':' & min>
			<option<cfif TimeFormat(getEvents2.starttime,"H:mm") is ittValue> selected</cfif> value="#ittValue#"><cfif i eq 12>12:#min#pm<cfelseif i gt 12>#evaluate(i-12)#:#min#pm<cfelseif i lt 1>12:#min#am<cfelse>#i#:#min#am</cfif></option>
			</cfloop>
			</cfloop>
		</select>
		</cfoutput>
		<!--- <a href="javascript:void(0);" onmouseover="return overlib('Please provide an accurate estimate of your guest\'s initial arrival.This will help to expedite the check-in process.(Reminder: Selected time applies to <u>ALL</u> Guests registered on the previous page.<br><br>', BUBBLE, BUBBLETYPE, 'roundcorners', STATUS, 'quotation popup', TEXTSIZE,'x-small');" onmouseout="nd();">
	<b style="background-color:#fff8dc;color:#000000;padding-top:2px;padding-bottom:2px;padding-left:2px;padding-right:2px;border-top:1px solid Grey;border-bottom:1px solid grey;border-left:1px solid grey;border-right:1px solid grey;font-variant:small-caps;font-weight:bold;font-size:12px;">?</b></a>
		 ---><br><br></td>
		<td width="40%" align="center" style="border-top:1px solid black;border-bottom:1px solid black;border-right:1px solid black;border-left:1px solid black;background-color:f5f5f5;"><div align="center" style="font-weight:bold;padding-bottom:10px;">Ending Time of Event</div>
		<cfoutput>
		<select name="endtime">
			<cfloop from="0" to="23" index="i">
			<cfloop from="0" to="45" step="15" index="m">
			<cfif len(m) neq 2><cfset min = "00"><cfelse><cfset min = m></cfif>
			<cfset ittValue = i & ':' & min>
			<option<cfif TimeFormat(getEvents2.endtime,"H:mm") is ittValue> selected</cfif> value="#ittValue#"><cfif i eq 12>12:#min#pm<cfelseif i gt 12>#evaluate(i-12)#:#min#pm<cfelseif i lt 1>12:#min#am<cfelse>#i#:#min#am</cfif></option>
			</cfloop>
			</cfloop>
		</select>
		</cfoutput>
		<!--- <a href="javascript:void(0);" onmouseover="return overlib('Please provide an accurate estimate of your guest\'s initial arrival.This will help to expedite the check-in process.(Reminder: Selected time applies to <u>ALL</u> Guests registered on the previous page.<br><br>', BUBBLE, BUBBLETYPE, 'roundcorners', STATUS, 'quotation popup', TEXTSIZE,'x-small');" onmouseout="nd();">
	<b style="background-color:#fff8dc;color:#000000;padding-top:2px;padding-bottom:2px;padding-left:2px;padding-right:2px;border-top:1px solid Grey;border-bottom:1px solid grey;border-left:1px solid grey;border-right:1px solid grey;font-variant:small-caps;font-weight:bold;font-size:12px;">?</b></a>---><br><br>
		 </td>
		<td width="10%">&nbsp;</td>
		</tr>
		<tr>
<td align="center" colspan="4">
<cfoutput><cfloop query="qEventTypes">
	<input type="radio" name="eventtypeid" value="#qEventTypes.etid#"<cfif qEventTypes.etid eq getEvents2.eventtypeid> checked="checked"</cfif>> <strong>#qEventTypes.label#</strong>&nbsp;&nbsp;
</cfloop>
</td>
</tr>
	
	</table>
<input type="hidden" id="allSelected" name="allSelected" value="#datelist#">
<input type="hidden" name="specialevent_id" value="#session.specialevent_id#">
</cfoutput>
</td>
</tr>
</table>
<div align="center">
<table cellpadding="2" border="0" align="center">
<tr>
<td><!--- <input type="button" value=" : clear all dates : " onclick="gfFlat_1.fClearAll();gfFlat_1.fRepaint();gfFlat_2.fRepaint();gfFlat_3.fRepaint();gfFlat_4.fRepaint();gfFlat_5.fRepaint();gfFlat_6.fRepaint();return false;" style="color:Red;"> ---></td>
<td><input type="submit" value=" : submit changes : " style="color:Green;"></td></form>
<form action="deletecheck4.cfm" method="post">
<td><cfoutput><input type="hidden" name="specialevent_id" value=#url.specialevent_id#></cfoutput>
<input type="submit" value=" : cancel event : " style="color:Red;"></td></form>
</tr>
</table>
</div>

<cfinclude template="actionlist.cfm">
<cfinclude template="../footer.cfm">
