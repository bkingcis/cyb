<cfset request.dsn = datasource>
<cftry>
<cfquery name="getEvents2" datasource="#datasource#">
	select * from specialevents
	Where r_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(session.user_id)#" />	
	AND specialEvent_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#url.specialevent_id#" />
</cfquery>

<cfquery datasource="#request.dsn#" name="qEventTypes">
	Select * from CommunityeventTypes
	where c_id = <cfqueryparam value="#val(session.user_community)#" cfsqltype="CF_SQL_INTEGER" />
	order by label
</cfquery> 

<cfif getEvents2.recordcount>
<cfquery name="getRes" datasource="#datasource#">
	select * from Residents
	Where r_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#getEvents2.r_id#" />
</cfquery>
<cfelse>
	<script>
		alert('Event not found. Use your back button and try again.')
	</script>
	<cfabort>
</cfif>

<cfinclude template="header.cfm">
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
	$('.preselectedBox').removeClass('preselectedBox').addClass('calDayBox');
	$('#allSelected').val(thedate);
	boxToUpdate.className='preselectedBox';
}

</script>
<form name="testForm" action="popup/modspecialevent2.cfm" method="post">
	<cfoutput>
	<input type="button" class="btn btn-sm btn-danger event-cancel-btn" value="CANCEL <cfoutput>#ucase(labels.special_event)#</cfoutput>" data-spid="#url.specialevent_id#">
	</cfoutput>
	<fieldset style="overflow:auto;"><legend><small>1. Select <cfoutput>#labels.special_event#</cfoutput> Date:</small></legend>
	<cfset session.specialevent_id = url.specialevent_id>
	<table align="center" border="2" bordercolor="white">
		<cfset dateList = "">
		<cfloop query="getEvents2">
			<cfset dateList = listAppend(dateList,dateFormat(getEvents2.eventdate,"m/d/yyyy"))>
		</cfloop>
		<tr>
			<td valign="top"><cfmodule template="../cal.cfm" month="#month(request.timezoneadjustednow)#" calendarmode="selector" selectorcolor="eeee77" hide="events,visitors" selectedList="#dateList#"></td>
			<td valign="top"><cfmodule template="../cal.cfm" month="#month(request.timezoneadjustednow)+1#" calendarmode="selector" selectorcolor="eeee77" hide="events,visitors" selectedList="#dateList#"></td>	
			<td valign="top"><cfmodule template="../cal.cfm" month="#month(request.timezoneadjustednow)+2#" calendarmode="selector" selectorcolor="eeee77" hide="events,visitors" selectedList="#dateList#"></td>	
			<!--- <td valign="top"><cfmodule template="../cal.cfm" month="#month(request.timezoneadjustednow)+3#" calendarmode="selector" selectorcolor="eeee77" hide="events,visitors" selectedList="#dateList#"></td>	--->
		</tr>
	</table>
	</fieldset>
	
			<style>
			.selectedBox {background-color: ##ff6}
			.preselectedBox {background-color: ##ff6}
			</style>
	
	<script language="JavaScript">
		document.testForm.dateList.options[0]=null; 
	</script>
	<fieldset><legend><small>2. Choose Times:</small></legend>
		<div class="form-group col-sm-offset-2 col-sm-6">
				<select name="dateList" size="1" style="visibility:hidden;">
				<option value="-">-----------------</option>
				</select>
			<label for="hour">Start Time:</label>
			<cfoutput>
			<select class="form-control" name="starttime">
				<cfloop from="0" to="23" index="i">
				<cfloop from="0" to="30" step="30" index="m">
				<cfif len(m) neq 2><cfset min = "00"><cfelse><cfset min = m></cfif>
				<cfset ittValue = i & ':' & min>
				<option<cfif TimeFormat(getEvents2.starttime,"H:mm") is ittValue> selected</cfif> value="#ittValue#"><cfif i eq 12>12:#min#pm<cfelseif i gt 12>#evaluate(i-12)#:#min#pm<cfelseif i lt 1>12:#min#am<cfelse>#i#:#min#am</cfif></option>
				</cfloop>
				</cfloop>
			</select>
			<label for="end_hour">End Time:</label>
			<select class="form-control" name="endtime">
				<cfloop from="0" to="23" index="i">
				<cfloop from="0" to="30" step="30" index="m">
				<cfif len(m) neq 2><cfset min = "00"><cfelse><cfset min = m></cfif>
				<cfset ittValue = i & ':' & min>
				<option<cfif TimeFormat(getEvents2.endtime,"H:mm") is ittValue> selected</cfif> value="#ittValue#"><cfif i eq 12>12:#min#pm<cfelseif i gt 12>#evaluate(i-12)#:#min#pm<cfelseif i lt 1>12:#min#am<cfelse>#i#:#min#am</cfif></option>
				</cfloop>
				</cfloop>
			</select>
		</div>
	</fieldset>
	
	<fieldset><legend><small>3. Choose <cfoutput>#labels.special_event#</cfoutput> Type:</small></legend>
		<div class="form-group col-sm-offset-2 col-sm-10">
		<cfloop query="qEventTypes">
			<input type="radio" name="eventtypeid" value="#qEventTypes.etid#"<cfif qEventTypes.etid eq getEvents2.eventtypeid> checked="checked"</cfif>> <strong>#qEventTypes.label#</strong>&nbsp;&nbsp;
		</cfloop>
		</div>
		<input type="hidden" id="allSelected" name="allSelected" value="#datelist#">
		<input type="hidden" name="specialevent_id" value="#session.specialevent_id#">
	</fieldset>
	
</form></cfoutput>
</div>
<cfcatch><cfdump var="#cfcatch#"></cfcatch>
</cftry>
