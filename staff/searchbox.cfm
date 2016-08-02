<CFIF NOT isDefined("session.staff_id") OR session.staff_id EQ 0>
	    <cflocation URL="../staff.cfm">
<CFELSE><cfset request.dsn = datasource>
<cfquery datasource="#request.dsn#" name="qAllResidents">
	select r_id, r_fname, r_lname from residents
	where  c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#" />
</cfquery>
	<!--- <cfinclude template="../header5.cfm">
	<cfinclude template="include/staffheaderinfo.cfm"> 
	<div style="clear:both;"></div><br /><br />--->
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
	<cfinclude template="popup/header.cfm"><div id="popUpContainer">
	<h1>VISITOR SEARCH</h1>
<form action="searchprocess.cfm" method="POST" name="testForm3"><!--- searchprocess.cfm --->
 <!--- tr>
<td colspan=3 align="center">
<div align="center" class="staffHeader1"></div>
</td>
</tr> 
<tr>
	<td colspan="4" align="center"> &nbsp;</td>
	</tr>
	<cfset request.dsn = datasource>
 <tr>
<td colspan=3 align="center">
<input type="radio" name="searchcrit" value="today" checked>&nbsp;Check-In Today&nbsp; 
<input type="radio" name="searchcrit" value="active" checked onclick="if (this.checked == true) {document.getElementById('calBox').style.display='none';document.getElementById('allSelected').value=''} else {document.getElementById('calBox').style.display='block'}">&nbsp;Active Access&nbsp;
<input type="radio" name="searchcrit" value="future"onclick="if (this.checked == true) {document.getElementById('calBox').style.display='none';document.getElementById('allSelected').value=''} else {document.getElementById('calBox').style.display='block'}">&nbsp;Future Access&nbsp;
<input type="radio" name="searchcrit" value="permenant" onclick="if (this.checked == true) {document.getElementById('calBox').style.display='none';document.getElementById('allSelected').value=''} else {document.getElementById('calBox').style.display='block'}">&nbsp;24/7 Access&nbsp;<br>
<input type="radio" name="searchcrit" value="hstry" onclick="if (this.checked == true) {document.getElementById('calBox').style.display='none';document.getElementById('allSelected').value=''} else {document.getElementById('calBox').style.display='block'}">&nbsp;History&nbsp;
<a href="#" onClick="document.getElementById('calBox').style.display='block';document.testForm3.searchcrit[4].checked=true"><img name="popcal" align="absbottom" src="calbtn.gif" width="34" height="22" border="0" alt=""></a>
</td>
</tr> --->

<cfoutput>

<table align="center" style="font-size:11px;" cellpadding="0" cellspacing="3" border="0">
	<tr>
		<td align="right" style="padding-right:5px;" valign="top">
		<strong style="color: white;font-size: 14pt;">VISITOR:</strong></td>
		<td valign="top"><input type="text" style="font-size:14pt;" name="g_lname"> <br />
		<span style="color:silver">Last Name or<br>
		 Company Name</span></td>
		<td valign="top"><input type="text" style="font-size:14pt" name="g_fname"> <br />
		<span style="color:silver">First Name</span></td>
	</tr>
	<tr><td><br /></td></tr>
	<tr>
		<td align="right" style="padding-right:5px;" valign="top">
		<strong style="color: white;font-size: 14pt;">RESIDENT:</strong></td>
		<td>
			<select name="r_id" id="selResidentID" style="font-size:14pt"><option value=""> - Select Resident -</option>
				<cfloop query="qAllResidents"><option value="#r_id#">#ucase(r_lname)#, #ucase(r_fname)#</option></cfloop>
			</select>
		</td>
	</tr>
	<tr><td><br /></td></tr>
	<tr>
		<td align="right" style="padding-right:5px;" valign="top">
		<strong style="color: white;font-size: 14pt;">VISIT DATE:</strong></td>
		<td>
			<select name="mon" style="font-size:14pt">
				<option value=""> </option>
				<cfloop from="1" to="12" index="mon"><option value="#mon#">#monthAsString(mon)#</option></cfloop>
			</select>
			<select name="day" style="font-size:14pt">
				<option value=""> </option>
				<cfloop from="1" to="31" index="day"><option value="#day#">#day#</option></cfloop>
			</select>
			<select name="yr" style="font-size:14pt">
				<option value=""> </option>
				<cfloop from="#year(now())-1#" to="#year(now())+1#" index="yr"><option value="#yr#">#yr#</option></cfloop>
			</select>
		</td>
	</tr>

</table><br /><input type="submit" value=": search :" style="color:green;">
<!--- <td><input type="text" size="10" name="r_lname"  onclick="return overlib(OLiframeContent('abook_residents.cfm?Number=#i#', 250, 400, 'if1', 1), WRAP, TEXTPADDING,0, BORDER,1, STICKY,NOCLOSE, SCROLL,CAPTIONPADDING,4, CAPTION,'Resident List',MIDX,-300, RELY,50, STATUS,'Example with iframe content, a caption and a Close link');" onmouseout="nd(20);" style="color:Black;"> Last Name</td>
<td><input type="text" size="10" name="r_fname"> First Name</td>
</tr>

<tr><td>&nbsp;</td></tr>
<tr>
<td style="padding-right:5px;" colspan="3">

<table width="100%" align="center"><tr><td>

<input type="radio" checked="checked" name="searchcrit" value="future"onclick="if (this.checked == true) {document.getElementById('calBox').style.display='none';document.getElementById('allSelected').value=''} else {document.getElementById('calBox').style.display='block'}">&nbsp;<strong>TODAY</strong>&nbsp;<br />
<input type="radio" name="searchcrit" value="sp_date" onclick="if (this.checked == true) {document.getElementById('calBox').style.display='block'} else {document.getElementById('calBox').style.display='none'}">&nbsp;<strong>SINGLE DATE</strong>&nbsp;
<input type="hidden" size="10" name="allSelected" id="allSelected" value="">
</td>
<td align="right"><input type="submit" value=": search :" style="color:green;"></td>
</td>
</tr></table>
<div id="calBox" style="width:587px;overflow:auto;">
<table align="center" border="2" bordercolor="white">
	<cfset request.dsn = datasource>
	<tr>
		<td valign="top"><cf_cal month="#month(dateAdd("m",-2,request.timezoneadjustednow))#" year="#year(dateAdd("m",-2,request.timezoneadjustednow))#" calendarmode="selector" selectorcolor="eeee77" hide="visitors,events"></td>
		<td valign="top"><cf_cal month="#month(dateAdd("m",-1,request.timezoneadjustednow))#" year="#year(dateAdd("m",-1,request.timezoneadjustednow))#" calendarmode="selector" selectorcolor="eeee77" hide="visitors,events"></td>
		<td valign="top"><cf_cal month="#month(request.timezoneadjustednow)#" year="#year(request.timezoneadjustednow)#" calendarmode="selector" selectorcolor="eeee77" hide="visitors,events"></td>
		<td valign="top"><cf_cal month="#month(dateAdd("m",1,request.timezoneadjustednow))#" year="#year(dateAdd("m",1,request.timezoneadjustednow))#" calendarmode="selector" selectorcolor="eeee77" hide="visitors,events"></td>
		<td valign="top"><cf_cal month="#month(dateAdd("m",2,request.timezoneadjustednow))#" year="#year(dateAdd("m",2,request.timezoneadjustednow))#" calendarmode="selector" selectorcolor="eeee77" hide="visitors,events"></td><!--- 
		<td valign="top"><cf_cal month="#month(request.timezoneadjustednow) + 3#" calendarmode="selector" selectorcolor="eeee77" hide="visitors,events"></td> --->
	</tr>
</table><iframe src="calbox.cfm" width="170" height="180"></iframe> --->
</cfoutput>
</form>

	<!--- quick dash-pass entry form 
	<cfinclude template="frmlicenseplate.cfm"> --->
	<cfif isDefined("url.allSelected")>
		<cfset form.allSelected = url.allSelected>
	</cfif>
	<cfparam name="form.g_lname" default="" />
	<cfparam name="form.g_fname" default="" />
	<cfparam name="form.r_lname" default="" />
	<cfparam name="form.r_fname" default="" />
	
	<cfif isDefined("searchcrit")>
	 
	<cfif val(form.mon) and val(form.day) and val(form.yr)>
		<cfset form.allselected = "#form.mon#/#form.day#/#form.yr#">
	</cfif>
		<cfif searchcrit is "future">
			<cfinclude template="include/search_results_future.cfm">
		<cfelse>
			<cfinclude template="include/search_results_history.cfm">		
		</cfif>
	</cfif>
	</div>
<br>
<!--- <br>

	<cfinclude template="actionlist.cfm"> 
	<cfinclude template="../footer.cfm"> --->
</CFIF>
