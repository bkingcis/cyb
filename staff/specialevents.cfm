
<cfinclude template="../header5.cfm">
<cfinclude template="include/staffheaderinfo.cfm">
	<div style="clear:both;"></div><br /><br />
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
	</script>

<CFIF isDefined("session.staff_id") AND session.staff_id GT 0>	
<cfset request.dsn = datasource>
<CFPARAM NAME="TODAYSTART" DEFAULT=#CreateDateTime(DateFormat(request.timezoneadjustednow,"YYYY"),DateFormat(request.timezoneadjustednow,"MM"),DateFormat(request.timezoneadjustednow,"DD"),00,00,00)#>
<CFPARAM NAME="TODAYEND" DEFAULT=#CreateDateTime(DateFormat(request.timezoneadjustednow,"YYYY"),DateFormat(request.timezoneadjustednow,"MM"),DateFormat(request.timezoneadjustednow,"DD"),23,59,59)#>
<div align="center" class="staffHeader1">SPECIAL EVENT(S)<br>INVENTORY</div>
<table style="margin-left:60px;">
	
	<tr><td colspan="7"><table align="center">
	<tr>
		<td valign="top" style="border: 2px solid silver;"><cf_cal year="#year(request.timezoneadjustednow)#" month="#month(request.timezoneadjustednow)#" hide="visitors"></td>
		<td valign="top" style="border: 2px solid silver;"><cf_cal year="#year(dateAdd('m',1,request.timezoneadjustednow))#" month="#month(dateAdd('m',1,request.timezoneadjustednow))#" hide="visitors"></td>	
		<td valign="top" style="border: 2px solid silver;"><cf_cal year="#year(dateAdd('m',2,request.timezoneadjustednow))#" month="#month(dateAdd('m',2,request.timezoneadjustednow))#" hide="visitors"></td>	
		<td valign="top" style="border: 2px solid silver;"><cf_cal year="#year(dateAdd('m',3,request.timezoneadjustednow))#" month="#month(dateAdd('m',3,request.timezoneadjustednow))#" hide="visitors"></td>	
		</tr>
	</table>
	<br clear="all" />
	<div style="text-align:center;">  <!--- style="background-color:green;color:#000000;padding-top:0px;padding-bottom:0px;padding-left:2px;padding-right:2px;border-top:1px solid Grey;border-bottom:1px solid grey;border-left:1px solid grey;border-right:1px solid grey;font-variant:small-caps;font-weight:bold;font-size:12px;" --->
		<b class="calEventBox" style="font-size:11pt;">&nbsp; &nbsp; </b></a>
		<span style="font-size:12px;color:#333;font-weight:bold;font-family:Tahoma,Verdana, Arial;">&nbsp; Indicates Special Event(s)</div>
	</td></tr>
	
	
	<!--- <tr>
	<td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center">Event Type</td>
		<td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center">Resident Name (L/F)</td>
		<td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center">Resident Phone</td>
		<td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center">Address</td>
		<td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center">Time Frame</td>
		
	</tr>	
	<cfoutput query="GetSpecialEvents">
		<cfset eventtype = "Open House">
		<tr>	
			<td style="font-size:10px;" align="center">#eventtype#</td>
			<td style="font-size:10px;" align="center">#r_lname#, #r_fname# </td>
			<td style="font-size:10px;" align="center">#h_phone#</td>
			<td style="font-size:10px;" align="center">#h_address#</td>
			<td style="font-size:10px;" align="center">#TimeFormat(starttime,"h:mm tt")#-#TimeFormat(endtime,"h:mm tt")#</td>  
		</tr>
	</cfoutput> --->
	</table>
	
<div id="popBox" style="padding-bottom:0px;"> 
	<div id="calEventBoxHeader" style="text-align:center">Calendar Results</div> 
	<div id="popBoxData" style="text-align:center;overflow:auto;height:80px;"></div> 
	<div style="text-align:right;margin:0px;background-color:#eee;">
	<a href="#" onclick="document.getElementById('popBox').style.display='none';">close box</a> 
	</div> 
</div> 

<cfinclude template="actionlist.cfm"> 
	<cfinclude template="../footer.cfm">	
<CFELSE>
<cflocation URL="../staff.cfm">		
</CFIF>