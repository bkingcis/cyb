<cfif NOT isDefined('SESSION.user_community')>
	<cflocation url="/staff" addtoken="No">
</cfif>

<cftry>
<cfinclude template="popup/header.cfm">
<cfquery name="getResidents" datasource="#datasource#">select r_lname,r_fname,r_id from residents
	where c_id =<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#">and h_id NOT IN (
		select h_id from homesite 
		where c_id =<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#">and (softdelete = 1 or h_lname = 'VACANT')
		)
	order by r_lname, r_fname
</cfquery>
<cfquery name="getGuestVisits" datasource="#datasource#">
	SELECT * from guestvisits
	where v_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(url.v_id)#" />
</cfquery>	
<cfset session.g_id = getGuestVisits.g_id>
<cfquery name="getGuest" datasource="#datasource#">
	SELECT * from guests
	where g_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(getGuestVisits.g_id)#" />
</cfquery>	
<cfquery name="getSchedule" datasource="#datasource#">
	SELECT visit_date,g_singleEntry
	from schedule 
	WHERE v_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(url.v_id)#" />
</cfquery>
<cfquery name="getVisits" datasource="#datasource#">
	SELECT v_id
	from visits 
	WHERE v_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(url.v_id)#" />
</cfquery>

<script type="text/javascript">
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
</script>


<div id="popUpContainer">

	<form action="modifyschedule3.cfm" method="POST" name="ann2">
		<cfoutput>
		<input type="hidden" name="v_id" value="#url.v_id#">
		<input type="hidden" name="r_id" value="#getGuest.r_id#">
		<input type="hidden" name="g_id" value="#getGuestVisits.g_id#">
		<input type="hidden" name="g_barcode" value="#getGuestVisits.g_barcode#">
		</cfoutput>
		<table style="margin:10px;border-collapse:collapse;" cellpadding="0" cellspacing="3" border="0">
			<tr>
				<td style="background-color:white;" align="center">
				<cfset i = 0>
				<cfset form.fname0 = getGuest.g_fname>
				<cfset form.lname0 = getGuest.g_lname>
				<cfset r_id = getGuest.r_id>
				<cfset dateList = ''>
				<cfloop query="getSchedule">
				<cfset dateList = listAppend(dateList,dateFormat(getSchedule.visit_date,'m/d/yyyy'))>
				</cfloop>
				<cfset form.hour0 = getGuestVisits.g_initialvisit>
				<cfset form.singleEntry0 = getSchedule.g_singleEntry>
				
				<cfinclude template="include/guestAnnounceForm.cfm">
				</td>
			</tr>
		</table>
	
		<table width="90%" style="margin:10px;border-collapse:collapse;" cellpadding="0" cellspacing="3" border="0">
			<tr>
				<td style="text-align:center;" align="center">
				<input name="sbtButton" type="submit" value=" : submit changes : "  style="color:Green;">
				<input name="sbtButton" type="submit" value=" : cancel announcement : " style="color:Red;">
				</td>
			</tr>
		</table>
		
	</form>
	<br /><br />	
	<div id="popBox" style="padding-bottom:0px;">
		<div id="calEventBoxHeader">Calendar Results</div>
		<div id="popBoxData" style="overflow:auto;height:80px;"></div>
		<div style="text-align:right;margin:0px;background-color:#eee;"><a href="#" onclick="document.getElementById('popBox').style.display='none';">close box</a></div>
	</div>
<!--- 
<cfinclude template="actionlist.cfm">
<cfinclude template="../footer.cfm"> --->
</div>

<cfcatch><cfdump var="#cfcatch#"></cfcatch>
</cftry>