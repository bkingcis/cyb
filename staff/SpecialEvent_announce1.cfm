<cfif NOT isDefined('SESSION.user_community')>
	<cflocation url="/staff" addtoken="No">
</cfif>
<cfset request.dsn = datasource>

<cfquery datasource="#request.dsn#" name="qEventTypes">
	Select * from CommunityeventTypes
	where c_id = #session.user_community#
	order by label
</cfquery>
<cfquery datasource="#request.dsn#" name="getResident">
	select * from residents
	where c_id =<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#">
	and r_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(form.r_id)#">
</cfquery>
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

<cfinclude template="../header5.cfm">
<cfinclude template="include/staffheaderinfo.cfm">
<div id="pageBody" style="display:none;z-index:2;" onclick="position:absolute;height:600px;this.style.display:none;document.getElementById('popBox').style.display='none'"><!--- any click on the page should hide the address pop-up --->
	</div>
	<div style="clear:both;">
	</div>	
	<br /><br />
<div style="font-size:11px;background-color:#f5f5f5;border:thin solid black;width:790px;">		
<form name="testForm" action="specialEvent_announce2.cfm" method=POST><br>
<cfoutput><input type="hidden" name="r_id" value="#form.r_id#" /></cfoutput>
<div align="center">
<table>
	<tr>
<td align="center" colspan="4"><br />
	<strong><cfoutput>ADD SPECIAL EVENT FOR #ucase(getResident.r_fname)# #ucase(getResident.r_lname)#</cfoutput><br></strong>
	<br />
</td>
</tr>
	<tr>
		<td valign="top"><cf_cal month="#month(request.timezoneadjustednow)#" year="#year(request.timezoneadjustednow)#" calendarmode="selector" selectorcolor="eeee77" hide="visitors,events"></td>
		<td valign="top"><cf_cal month="#month(dateAdd("m",1,request.timezoneadjustednow))#" year="#year(dateAdd("m",1,request.timezoneadjustednow))#"  calendarmode="selector" selectorcolor="eeee77" hide="visitors,events"></td>	
		<td valign="top"><cf_cal month="#month(dateAdd("m",2,request.timezoneadjustednow))#" year="#year(dateAdd("m",2,request.timezoneadjustednow))#"  calendarmode="selector" selectorcolor="eeee77" hide="visitors,events"></td>	
		<td valign="top"><cf_cal month="#month(dateAdd("m",3,request.timezoneadjustednow))#" year="#year(dateAdd("m",3,request.timezoneadjustednow))#" calendarmode="selector" selectorcolor="eeee77" hide="visitors,events"></td>	
	</tr>
</table><br />

<!--- <input type="radio" name="ohgsType" value="oh"> <strong>Open House</strong>&nbsp;&nbsp;<input type="radio" name="ohgsType" value="gs"> <strong>Garage Sale</strong> --->
<cfoutput><cfloop query="qEventTypes">
	<input type="radio" name="eventtypeid" value="#qEventTypes.etid#"> <strong>#qEventTypes.label#</strong>&nbsp;&nbsp;
</cfloop></cfoutput>
<br />
</div><br />
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
		<cfloop from="0" to="30" step="30" index="m">
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
		<cfloop from="0" to="30" step="30" index="m">
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


<input type="hidden" name="allSelected" id="allSelected">


<br>
<table cellpadding="2" border="0" align="center">
<tr>
<td><input type="button" value=" Back " style="color:Red;" onclick="history.back();"></td>
<td><input type="button" value=" Clear Date " onclick="self.location.reload();" style="color:Red;"></td>
<td><input type="submit" value=" Submit "  style="color:Green;"></td></form>
<form action="index.cfm" method="post"><!--- onclick="submitByDates(this.form)" --->
</tr>
</table></div>
	
	   <cfmodule template="actionlist.cfm">
	<cfinclude template="../footer.cfm">

