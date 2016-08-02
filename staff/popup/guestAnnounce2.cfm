<cfif NOT isDefined('SESSION.user_community')>
	<cflocation url="/staff" addtoken="No">
</cfif>

<cfset form.r_id = url.r_id>

<cfinclude template="header.cfm"><!--- <cfinclude template="../include/staffheaderinfo.cfm"> --->
<cfquery name="getCommunity" datasource="#datasource#">
	select * from communities 
	where c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#" />
</cfquery>
<cfquery name="getResident" datasource="#datasource#">select r_lname,r_fname,r_id from residents
	where c_id =<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#">
	and r_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#form.r_id#">
</cfquery>
<cfquery name="getAddressbook" datasource="#datasource#">
	select * from guests
	where r_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#form.r_id#">
	AND showin_abook = 'TRUE'
	AND g_id not in (select g_id from guestvisits where g_permanent = 'True')
	order by g_lname
</cfquery>

<style>
.selectedBox {background-color: #aea}
.preselectedBox {background-color: #aea}
</style>
<script type="text/javascript">
<cfoutput>
function showDataPop(id) {			
		popBox = document.getElementById('popBox');
		//document.getElementById('pageBody').style.backgroundColor = '##eee';
		//document.getElementById('pageBody').style.display="block";
		addressFrame.location.href = '/staff/popup/addressbook.cfm?residentid=#form.r_id#&number='+id;
		popBox.style.left = '200px';
		popBox.style.top = '140px';
		popBox.style.width = '270px';
		popBox.style.height = '320px';
		popBox.style.display='block';
	}
</cfoutput>
function getIndex(input, arrayData) {
	for (i=0; i<arrayData.length; i++) {
		if (arrayData[i] == input) {
			return i;
		}
	}
	return -1;
}
function selectDateBox (boxToUpdate,thedate,itterationValue) {
	var listFrmVal = document.getElementById('allSelected'+itterationValue).value;
	var dateArr = listFrmVal.split( "," );
	var indexOfdate = getIndex(thedate,dateArr);
	if (indexOfdate != -1) {
			//alert(thedate + 'to remove');
			boxToUpdate.className='calDayBox';
			dateArr.splice(indexOfdate,1); //adds element to the array			
			document.getElementById('allSelected'+itterationValue).value=dateArr.join(); //pushes into a list on the hidden form field
	}
	else {
		//alert(thedate + 'to add');
		boxToUpdate.className='selectedBox';
		dateArr.push(thedate); //adds element to the array
		document.getElementById('allSelected'+itterationValue).value = dateArr.join(); //pushes into a list on the hidden form field
		}
}

function validateForm() {
	//alert('validate test');
	frm = document.ann2;
	if(frm.LName1.value.length != 0){
		//alert(frm.allSelected1.value);
		if(frm.LName1.value.length != 0){
			frm.submit();
		} else {
			alert('Please select, at least, one date to continue.');
		}
	} else {
		alert("A last name or company name is required to continue.");
		//frm.Lname1.focus();
	}
}
</script>
	<div id="popUpContainer">
	<h1>RESIDENT: <cfoutput>#ucase(getResident.r_lname)#, #ucase(getResident.r_fname)#</cfoutput></h1>
					<cfset i = 1>			
					
	<form action="guestAnnounce3.cfm" method="POST" name="ann2">
		<cfoutput><input type="hidden" name="f_ABUsed">
		<input type="hidden" name="r_id" value="#form.r_id#">
		
		<h2 style="text-transform:uppercase;margin-bottom:0">Add Visitor</h2>
		
		<cfset datelist = ''>
		<cfset form.hour1 = '12'>
		<cfparam name="form.lname#i#" default="">
		<cfparam name="form.fname#i#" default="">
		<div align="center">
		<table>
			<tr>
				<td>
				Last Name: 
				</td>
				<td>
				<input type="text" class="form-control" value="#evaluate('form.lname'&i)#" name="LName#i#" style="margin-left:4px;width: 200px;" maxlength="45" <cfif 1 eq 2 and isDefined('getAddressbook.recordcount') and getAddressbook.recordcount>onclick="return showDataPop(#i#);"</cfif> />
				</td>
			</tr>
			<tr>
		<!--- disabled guestbook by request from Todd June 17,2015 --->
				<td>First Name:</td>
				<td><input type="text" class="form-control" value="#evaluate('form.fname'&i)#"  name="FName#i#" maxlength="45" style="margin-left:4px;width: 200px;" /></td>
			</tr>
		<cfif getCommunity.guestcompanionOption>
			<tr><td>	Plus Guests:</td><td> <select name="guestcompanioncount#i#"><option>0<option>1<option>2<option>3<option>4</select></td></tr>
		<cfelse>
			<input type="hidden" class="form-control" name="guestcompanioncount#i#" value="">
		</cfif>
		<input type="hidden" class="form-control" name="Email#i#">	
		</cfoutput>
		</table>
		</div><br />
		<p style="color:white;padding:0;margin:0;font-size:12px;"><em>Click to highlight each authorized visit date.</em></p>
		<div style="margin:0; padding:5px; overflow-x: scroll;">
		<table border="2" cellpadding="4" bordercolor="#ffffff" align="center">
		<cfset request.dsn = datasource>
		<tr>
			<td valign="top"><cfmodule template="../../residents/cal.cfm" itterationVal="#i#" r_id="#r_id#" month="#month(request.timezoneadjustednow)#" calendarmode="selector" hide="events,visitors" selectedList="#dateList#"></td>
			<td valign="top"><cfmodule template="../../residents/cal.cfm" itterationVal="#i#" r_id="#r_id#" month="#month(request.timezoneadjustednow)+1#" calendarmode="selector" hide="events,visitors" selectedList="#dateList#"></td>	
			<td valign="top"><cfmodule template="../../residents/cal.cfm" itterationVal="#i#" r_id="#r_id#" month="#month(request.timezoneadjustednow)+2#" calendarmode="selector" hide="events,visitors" selectedList="#dateList#"></td>	
			<td valign="top"><cfmodule template="../../residents/cal.cfm" itterationVal="#i#" r_id="#r_id#" month="#month(request.timezoneadjustednow)+3#" calendarmode="selector" hide="events,visitors" selectedList="#dateList#"></td>	
		</tr>
		</table>
		</div>
		<cfoutput>
		<table align="center">
		<tr><td>
		Arrival Time: 			
		<select class="form-control" name="hour#i#">
			<option value=""> - Choose - </option>
			<cfloop from="0" to="23" index="h">
				<cfloop from="0" to="30" step="30" index="m">
					<cfif len(m) neq 2><cfset min = "00"><cfelse><cfset min = m></cfif>
					<cfset ittValue = h & ':' & min>
					<option value="#ittValue#"<cfif timeFormat(evaluate('form.hour'&i),'h:mm') is '#h#:#min#'> selected="selected"</cfif>><cfif h eq 12>12:#min#pm<cfelseif h gt 12>#evaluate(h-12)#:#min#pm<cfelseif h lt 1>12:#min#am<cfelse>#h#:#min#am</cfif></option>
				</cfloop>
			</cfloop>
			</select>&nbsp;&nbsp;&nbsp;	
		</td>
		<td>&nbsp;&nbsp;&nbsp;	&nbsp;&nbsp;&nbsp;	<input type="checkbox" name="singleEntry#i#"<cfif isDefined('form.singleEntry#i#') and val(evaluate('form.singleEntry#i#'))> checked="checked"</cfif>> Single Entry Pass&nbsp;&nbsp;
			<input type="hidden" name="allSelected#i#" id="allSelected#i#" value="#dateList#">
		</td><td>
		<input type="button" value="Submit Visitor" class="btn" onclick="validateForm()"></td>
		</tr></table>
		</cfoutput>
	</form>
	<div id="popBox" style="padding-bottom:0px;display:none;">
		<iframe name="addressFrame" style="overflow:auto;height:300px;width:270px;"></iframe>
		<div style="text-align:right;margin:0px;background-color:#eee;">
		<a href="#" onclick="document.getElementById('popBox').style.display='none';">close box</a>
		</div>
	</div>
</div>