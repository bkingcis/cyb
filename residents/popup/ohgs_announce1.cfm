<!--- LEGACY #### Replaced By SpecialEvent_announce1.cfm --->
<cflocation addtoken="No" url="SpecialEvent_announce1.cfm">

<CFIF session.user_id EQ 0>
	<cflocation URL="../residents.cfm">	
<CFELSE>

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
	<cfinclude template="header.cfm">
	<!--- <cfinclude template="residentsinfo.cfm"> --->
	<div id="popUpContainer">
	
		<h1 style="text-transform: upper;">SCHEDULE <cfoutput>#labels.special_event#</cfoutput></h1>
		<h2 style="border-bottom: 1px solid silver;">&nbsp;</h2>
	<h2>SELECT EVENT DATE<!--- <a href="javascript:void(0);" onmouseover="return overlib('<strong>You are scheduling a single day event only.</strong><br>Select ONE date<br><br>', BUBBLE, BUBBLETYPE, 'roundcorners', STATUS, 'quotation popup', TEXTSIZE,'x-small');" onmouseout="nd();">
	<b style="background-color:#fff8dc;color:#000000;padding-top:1px;padding-bottom:1px;padding-left:2px;padding-right:2px;border-top:1px solid Grey;border-bottom:1px solid grey;border-left:1px solid grey;border-right:1px solid grey;font-variant:small-caps;font-weight:bold;font-size:12px;">?</b></a><br> ---></h2><br>
	<form name="testForm" action="ohgs_announce2.cfm" method=POST>
<table align="center">
<tr>
<td valign=top>
<table align="center">
<tr>
<td valign=top><table>
	<cfset request.dsn = datasource>
	<tr>
		<td valign="top"><cfmodule template="../cal.cfm" month="#month(request.timezoneadjustednow)#" calendarmode="selector" selectorcolor="eeee77" hide="visitors,events"></td>
		<td valign="top"><cfmodule template="../cal.cfm" month="#month(request.timezoneadjustednow)+1#" calendarmode="selector" selectorcolor="eeee77" hide="visitors,events"></td>	
		<td valign="top"><cfmodule template="../cal.cfm" month="#month(request.timezoneadjustednow)+2#" calendarmode="selector" selectorcolor="eeee77" hide="visitors,events"></td>	
		<!--- <td valign="top"><cfmodule template="../cal.cfm" month="#month(request.timezoneadjustednow)+3#" calendarmode="selector" selectorcolor="eeee77" hide="visitors,events"></td> --->	
	</tr>
</table><br>
</td>
</tr>

<tr>

<td align="center">
<input type="radio" name="ohgsType" value="oh"> <strong>Open House</strong>&nbsp;&nbsp;<input type="radio" name="ohgsType" value="gs"> <strong>Garage Sale</strong>
</td>
</tr>

<tr>
<td valign=top><br>
	<table width="95%" align="center" cellpadding="0" cellspacing="0" border="0">		
		<tr>
		<td width="10%" align="left">
			
			<!--- <input id="dateList" value="" name="dateList"> --->
			<select id="dateList" name="dateList" size="1" style="visibility:hidden;">
			<option value="-">-----------------</option>
			</select><BR>
			<script language="JavaScript">
			document.testForm.dateList.options[0]=null; 
			</script>
		</td><cfoutput>
		<td width="40%" align="center" style="border-top:1px solid black;border-bottom:1px solid black;border-right:1px solid black;border-left:1px solid black;background-color:f5f5f5;"><div align="center" style="font-weight:bold;padding-bottom:10px;">Beginning Time of Event</div>
		<select name="hour">
		<cfloop from="0" to="23" index="i">
		<cfloop from="0" to="45" step="15" index="m">
		<cfif len(m) neq 2><cfset min = "00"><cfelse><cfset min = m></cfif>
		<cfset ittValue = i & ':' & min>
		<option<cfif i eq 12 and min eq 0> selected</cfif> value="#ittValue#"><cfif i eq 12>12:#min#pm<cfelseif i gt 12>#evaluate(i-12)#:#min#pm<cfelseif i lt 1>12:#min#am<cfelse>#i#:#min#am</cfif></option>
		</cfloop>
		</cfloop>
		</select><br><br>
		
		</td>
		<td width="40%" align="center" style="border-top:1px solid black;border-bottom:1px solid black;border-right:1px solid black;border-left:1px solid black;background-color:f5f5f5;"><div align="center" style="font-weight:bold;padding-bottom:10px;">Ending Time of Event</div>
		<select name="end_hour">
		<cfloop from="0" to="23" index="i">
		<cfloop from="0" to="45" step="15" index="m">
		<cfif len(m) neq 2><cfset min = "00"><cfelse><cfset min = m></cfif>
		<cfset ittValue = i & ':' & min>
		<option<cfif i eq 12 and min eq 0> selected</cfif> value="#ittValue#"><cfif i eq 12>12:#min#pm<cfelseif i gt 12>#evaluate(i-12)#:#min#pm<cfelseif i lt 1>12:#min#am<cfelse>#i#:#min#am</cfif></option>
		</cfloop>
		</cfloop>
		</select><br><br>		
		</td></cfoutput>
		<td width="10%">&nbsp;</td>
		</tr>
	
	</table>

</td>
</tr>
</table>
<input type="hidden" name="allSelected" id="allSelected">

<div align="center">
<br>
<table cellpadding="2" border="0" align="center">
<tr>
<td><input type="button" value=" Back " style="color:Red;" onclick="history.back();"></td>
<td><input type="button" value=" Clear Date " onclick="self.location.reload();" style="color:Red;"></td>
<td><input type="submit" value=" Submit "  style="color:Green;"></td></form>
<form action="index.cfm" method="post"><!--- onclick="submitByDates(this.form)" --->
</tr>
</table></div>
	
	   <cfmodule template="actionlist.cfm" showonly="home,logout">
	<cfinclude template="../footer.cfm">
</CFIF>
