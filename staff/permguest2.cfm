

<CFIF session.user_id EQ 0>
	<cflocation URL="../residents.cfm">	
<CFELSE>
	<cfinclude template="../header3.cfm">
	<cfinclude template="residentsinfo.cfm">
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
	
	<div align="center" style="font-size:16px;font-weight:bold;color:#000;">24/7 &nbsp;GUEST(S)</div><br>
	
	<div align="center" style="font-weight:bold;font-size:15px;color:#336699;">SELECT INITIAL VISIT DATE<a href="javascript:void(0);" style="padding-top:20px;padding-bottom:20px;"><a href="javascript:void(0);" onmouseover="return overlib('Please choose the initial checkin date for this 24/7 guest', BUBBLE, BUBBLETYPE, 'roundcorners',ABOVE,ADJBUBBLE, STATUS,ABOVE,'quotation popup', TEXTSIZE,'x-small');" onmouseout="nd();">
	<b style="background-color:#fff8dc;color:#000000;padding-top:0px;padding-bottom:0px;padding-left:2px;padding-right:2px;border-top:1px solid Grey;border-bottom:1px solid grey;border-left:1px solid grey;border-right:1px solid grey;font-variant:small-caps;font-weight:bold;font-size:12px;">&nbsp;?&nbsp;</b></a><br></div><br>
	<form name="testForm" action="permguest3.cfm" method=POST>
		<table align="center">
		<cfset request.dsn = datasource>
			<tr>
				<td valign="top"><cf_cal month="#month(request.timezoneadjustednow)#" calendarmode="selector" hide="events,visitors"></td>
				<td valign="top"><cf_cal month="#month(request.timezoneadjustednow)+1#" calendarmode="selector" hide="events,visitors"></td>	
				<td valign="top"><cf_cal month="#month(request.timezoneadjustednow)+2#" calendarmode="selector" hide="events,visitors"></td>	
				<td valign="top"><cf_cal month="#month(request.timezoneadjustednow)+3#" calendarmode="selector" hide="events,visitors"></td>	
			</tr>
		<tr>
		
		<td>&nbsp;</td>
		<td colspan="2" align="center" style="border-top:1px solid black;border-bottom:1px solid black;border-right:1px solid black;border-left:1px solid black;background-color:f5f5f5;">
			<input type="hidden" name="allSelected" id="allSelected">
		
		<div align="center" style="font-weight:bold;padding-bottom:10px;">
		Approximate Arrival Time of Guest <br>
		on Initial Visit Date</div>
		<cfoutput>
		<select name="hour">
		<cfloop from="0" to="23" index="i">
		<cfloop from="0" to="45" step="15" index="m">
		<cfif len(m) neq 2><cfset min = "00"><cfelse><cfset min = m></cfif>
		<cfset ittValue = i & ':' & min>
		<option<cfif i eq 12 and min eq 0> selected</cfif> value="#ittValue#"><cfif i eq 12>12:#min#pm<cfelseif i gt 12>#evaluate(i-12)#:#min#pm<cfelseif i lt 1>12:#min#am<cfelse>#i#:#min#am</cfif></option>
		</cfloop>
		</cfloop>
		</select></cfoutput>
		<a href="javascript:void(0);" onmouseover="return overlib('Please provide an accurate estimate of your guest(s) initial arrival time. This will help to expedite the check-in process.<br><br>', BUBBLE, BUBBLETYPE, 'roundcorners', STATUS, 'quotation popup', TEXTSIZE,'x-small');" onmouseout="nd();">
	<b style="background-color:#fff8dc;color:#000000;padding-top:2px;padding-bottom:2px;padding-left:2px;padding-right:2px;border-top:1px solid Grey;border-bottom:1px solid grey;border-left:1px solid grey;border-right:1px solid grey;font-variant:small-caps;font-weight:bold;font-size:12px;">?</b></a><br><br>
		</td>
		<td>&nbsp;</td>
		
</tr>
</table>
<!--- <input type="Button" value="Submit By Dates" onclick="submitByDates(this.form)">
<input type="Button" value="Submit By Ranges" onclick="submitByRanges(this.form)"> --->
<input type="hidden" name="allSelected">
<cfloop INDEX="i" list="#form.FieldNames#">
	<cfoutput>
	<input type="hidden" name="#i#" value="#Evaluate(i)#">
	</cfoutput>
</cfloop>

<div align="center">
<br>
<table cellpadding="2" border="0" align="center">
<tr>
<td><input type="button" value=" : clear all dates : " onclick="gfFlat_1.fClearAll();gfFlat_1.fRepaint();gfFlat_2.fRepaint();gfFlat_3.fRepaint();gfFlat_4.fRepaint();gfFlat_5.fRepaint();gfFlat_6.fRepaint();return false;" style="color:Red;"></td>
<td><input type="submit" value=" : submit : " style="color:Green;"></td></form>
<form action="index.cfm" method="post">
<td><input type="submit" value=" : cancel guest : " style="color:Red;"></td></form>
</tr>
</table></div>
	<cfinclude template="actionlist.cfm">
	<cfinclude template="../footer.cfm">
</CFIF>
