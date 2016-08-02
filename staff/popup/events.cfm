<cfset request.dsn = datasource>
<cfset form.r_id = url.r_id>

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

<cfinclude template="header.cfm">
<script>	
	function showDataPop(rn,dt) {		
		p = document.getElementById('popBox');
		ph = document.getElementById('calEventBoxHeader');
		pb = document.getElementById('popBoxData');
		pb.innerHTML = unescape(rn);
		ph.innerHTML = unescape(dt);
		p.style.left = '600px';
		p.style.top = '300px';
		p.style.display='block';
	}	
		
	function selectDateBox (boxToUpdate,thedate) {
		//var indexOfdate = getIndex(thedate,dateArr);
		$('#allSelected').val(thedate);
		$('.selectedBox').addClass('calDayBox').removeClass('selectedBox');
		boxToUpdate.className='selectedBox';
	}
	
	$(document).ready(function(){
		$('#guestOptionsBox').hide();
		$('#showOptions').click(function(e){
			$('#guestShowBox').hide();
			$('#guestOptionsBox').show();
		});
	});
	
</script>

<div id="popUpContainer"><h1>SPECIAL EVENTS: &nbsp;<cfif NOT LEN(getResident.r_lname)> ALL RESIDENTS<cfelse><cfoutput>#ucase(getResident.r_lname)#<cfif LEN(getResident.r_fname)>, #ucase(getResident.r_fname)#</cfif></cfoutput></cfif></h1>
	
	<div id="guestShowBox">	<p>To view/edit previously added special events, click on the <b class="calEventBox" style="font-size:11pt;">&nbsp; &nbsp; </b>.</p>
			
	
<cfset request.dsn = datasource>
<CFPARAM NAME="TODAYSTART" DEFAULT=#CreateDateTime(DateFormat(request.timezoneadjustednow,"YYYY"),DateFormat(request.timezoneadjustednow,"MM"),DateFormat(request.timezoneadjustednow,"DD"),00,00,00)#>
<CFPARAM NAME="TODAYEND" DEFAULT=#CreateDateTime(DateFormat(request.timezoneadjustednow,"YYYY"),DateFormat(request.timezoneadjustednow,"MM"),DateFormat(request.timezoneadjustednow,"DD"),23,59,59)#>

	<table align="center" border="2" bordercolor="white">
	<tr>
		<td valign="top" ><cfmodule template="../cal.cfm" year="#year(request.timezoneadjustednow)#" month="#month(request.timezoneadjustednow)#" hide="visitors" r_id="#val(form.r_id)#"></td>
		<td valign="top"><cfmodule template="../cal.cfm" year="#year(dateAdd('m',1,request.timezoneadjustednow))#" month="#month(dateAdd('m',1,request.timezoneadjustednow))#" hide="visitors" r_id="#val(form.r_id)#"></td>	
		<td valign="top"><cfmodule template="../cal.cfm" year="#year(dateAdd('m',2,request.timezoneadjustednow))#" month="#month(dateAdd('m',2,request.timezoneadjustednow))#" hide="visitors" r_id="#val(form.r_id)#"></td>	
		<td valign="top"><cfmodule template="../cal.cfm" year="#year(dateAdd('m',3,request.timezoneadjustednow))#" month="#month(dateAdd('m',3,request.timezoneadjustednow))#" hide="visitors" r_id="#val(form.r_id)#"></td>	
		</tr>
	</table>
	<br clear="all" />	<cfif val(url.r_id)>	
		<input id="showOptions" class="btn" type="button" value="Add Special Event">		
	</cfif>
	
	</div>
	<div id="guestOptionsBox"><p style="color:white;">Click to hightlight the date.</p>
		
<table align="center" border="2" bordercolor="white">
	<tr>
		<td valign="top"><cfmodule template="../cal.cfm" month="#month(request.timezoneadjustednow)#" year="#year(request.timezoneadjustednow)#" calendarmode="selector" selectorcolor="eeee77" hide="visitors,events"></td>
		<td valign="top"><cfmodule template="../cal.cfm" month="#month(dateAdd("m",1,request.timezoneadjustednow))#" year="#year(dateAdd("m",1,request.timezoneadjustednow))#"  calendarmode="selector" selectorcolor="eeee77" hide="visitors,events"></td>	
		<td valign="top"><cfmodule template="../cal.cfm" month="#month(dateAdd("m",2,request.timezoneadjustednow))#" year="#year(dateAdd("m",2,request.timezoneadjustednow))#"  calendarmode="selector" selectorcolor="eeee77" hide="visitors,events"></td>	
		<td valign="top"><cfmodule template="../cal.cfm" month="#month(dateAdd("m",3,request.timezoneadjustednow))#" year="#year(dateAdd("m",3,request.timezoneadjustednow))#" calendarmode="selector" selectorcolor="eeee77" hide="visitors,events"></td>	
	</tr>
</table>

<form name="testForm" action="specialEvent_announce2.cfm" method="POST" style="color:white"><br>
<cfoutput><input type="hidden" name="r_id" value="#form.r_id#" /></cfoutput>
<!--- <input type="radio" name="ohgsType" value="oh"> <strong>Open House</strong>&nbsp;&nbsp;<input type="radio" name="ohgsType" value="gs"> <strong>Garage Sale</strong> --->
<cfoutput><cfloop query="qEventTypes">
	<input type="radio" name="eventtypeid" value="#qEventTypes.etid#"> <strong>#qEventTypes.label#</strong>&nbsp;&nbsp;
</cfloop></cfoutput>

				<br />
				<br />

	<table align="center" cellpadding="5" border="2" bordercolor="#ffffff">		
		<tr>
			<!--- <td width="10%" align="left">			
				<!--- <input id="dateList" value="" name="dateList"> --->
				<select id="dateList" name="dateList" size="1" style="visibility:hidden;">
				<option value="-">-----------------</option>
				</select><BR>
				<script language="JavaScript">
				document.testForm.dateList.options[0]=null; 
				</script>
			</td> --->
		<cfoutput>
			<td width="50%" align="center" style="">
				
				<br />
				<div align="center" style="font-weight:bold;padding-bottom:10px;">Beginning Time of Event</div>
				<select name="hour">
				<cfloop from="0" to="23" index="i">
				<cfloop from="0" to="30" step="30" index="m">
				<cfif len(m) neq 2><cfset min = "00"><cfelse><cfset min = m></cfif>
				<cfset ittValue = i & ':' & min>
				<option<cfif i eq 12 and min eq 0> selected</cfif> value="#ittValue#"><cfif i eq 12>12:#min#pm<cfelseif i gt 12>#evaluate(i-12)#:#min#pm<cfelseif i lt 1>12:#min#am<cfelse>#i#:#min#am</cfif></option>
				</cfloop>
				</cfloop>
				</select><br /><br />		
			</td>
			<td width="50%" align="center" style="">
				<br />
			<div align="center" style="font-weight:bold;padding-bottom:10px;">Ending Time of Event</div>
				
				<select name="end_hour">
				<cfloop from="0" to="23" index="i">
				<cfloop from="0" to="30" step="30" index="m">
				<cfif len(m) neq 2><cfset min = "00"><cfelse><cfset min = m></cfif>
				<cfset ittValue = i & ':' & min>
				<option<cfif i eq 12 and min eq 0> selected</cfif> value="#ittValue#"><cfif i eq 12>12:#min#pm<cfelseif i gt 12>#evaluate(i-12)#:#min#pm<cfelseif i lt 1>12:#min#am<cfelse>#i#:#min#am</cfif></option>
				</cfloop>
				</cfloop>
				</select><br /><br />
			</td>
		</cfoutput>
		</tr>
	</table>
	<br />
	<input type="hidden" name="allSelected" id="allSelected">
	<table cellpadding="2" border="0" align="center">
	<tr>
	<!--- <td><input type="button" value=" Back " style="color:Red;" onclick="history.back();"></td>
	 ---><td><input type="button" class="btn" value=" Clear Date " onclick="self.location.reload();" style="color:Red;"></td>
	<td><input type="submit" class="btn" value=" Submit "  style="color:Green;"></td></form>
	<form action="index.cfm" method="post"><!--- onclick="submitByDates(this.form)" --->
	</tr>
	</table>
	</div>	
</div>
<div id="popBox" style="padding-bottom:0px;"> 
	<div id="calEventBoxHeader" style="text-align:center">Calendar Results</div> 
	<div id="popBoxData" style="text-align:center;overflow:auto;height:80px;"></div> 
	<div style="text-align:right;margin:0px;background-color:#eee;">
	<a href="#" onclick="document.getElementById('popBox').style.display='none';">close box</a> 
	</div> 
</div> 
