<cfsilent>
<cfset timezoneadj = session.timezoneadj>
<cfparam name="alertPass" default="NO">
<cfinclude template="header.cfm">
	<!---<cfinclude template="residentsinfo.cfm"> --->
<cfset session.g_id = url.g_id>
<cfquery name="getAnnouncements" datasource="#datasource#">
	select guests.*, guestvisits.*
	from guests JOIN guestvisits ON 
	guests.g_id = guestvisits.g_id
	where guestvisits.v_id in (#url.v_id#)
</cfquery>	
<!--- <cfquery name="getBarcode" datasource="#datasource#">
	select g_barcode
	from guestvisits 
	where g_id = #url.g_id#
	AND v_id = #url.v_id#
</cfquery> --->
</cfsilent>
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
	var listFrmVal = document.getElementById('allSelected').value;
	var dateArr = listFrmVal.split( "," );
	var indexOfdate = getIndex(thedate,dateArr);
	if (indexOfdate != -1) {
			//alert(thedate + 'to remove');
			boxToUpdate.className='calDayBox';
			dateArr.splice(indexOfdate,1); //adds element to the array			
			document.getElementById('allSelected').value=dateArr.join(); //pushes into a list on the hidden form field
	}
	else {
		//alert(thedate + 'to add');
		boxToUpdate.className='selectedBox';
		dateArr.push(thedate); //adds element to the array
		document.getElementById('allSelected').value = dateArr.join(); //pushes into a list on the hidden form field
		}
}
</script>
<cfoutput>
	<h4>#getAnnouncements.g_lname#<cfif len(getAnnouncements.g_fname)>, #getAnnouncements.g_fname#</cfif></h4>
</cfoutput>
<cfoutput query="getAnnouncements">
	<cfquery name="getVisits" datasource="#datasource#">
	select v_id,visit_date
	from schedule 
	where v_id = #getAnnouncements.v_id#
	</cfquery>	
	
	<form name="testForm" action="modifyschedule2.cfm" target="_parent" method="POST">
		<input type="hidden" name="v_id" value="#getAnnouncements.v_id#">
			<cfset dateList = "">
			<cfloop query="getVisits">
				<cfset dateList = listAppend(dateList,dateFormat(getVisits.visit_date,"m/d/yyyy"))>
			</cfloop>		
			<cfset request.dsn = datasource>
			<table align="center" border="2" bordercolor="white">
			<tr>
				<td valign="top"><cfmodule template="../cal.cfm" month="#month(request.timezoneadjustednow)#" calendarmode="selector" hide="events,visitors" selectedList="#dateList#"></td>
				<td valign="top"><cfmodule template="../cal.cfm" month="#month(request.timezoneadjustednow)+1#" calendarmode="selector" hide="events,visitors" selectedList="#dateList#"></td>	
				<td valign="top"><cfmodule template="../cal.cfm" month="#month(request.timezoneadjustednow)+2#" calendarmode="selector" hide="events,visitors" selectedList="#dateList#"></td>	
				<!--- <td valign="top" class="hidden-sm hidden-xs"><cfmodule template="../cal.cfm" month="#month(request.timezoneadjustednow)+3#" calendarmode="selector" hide="events,visitors" selectedList="#dateList#"></td>	--->
			</tr>
			</table>
		<div align="center">
			<input class="btn btn-sm btn-danger" type="button" value="Delete" name="DELETE" onclick="loadModal('popup/deletecheck.cfm?v_id=#getAnnouncements.v_id#')"> 
			<!--- <input class="btn btn-sm btn-primary" type="button" value="Edit" name="EDIT" onclick="loadModal('modifyschedule2.cfm?v_id=#getAnnouncements.v_id#')"> --->
		</div>
	</form>
</cfoutput>
</div>

