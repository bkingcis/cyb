<cfif NOT isDefined('SESSION.user_community')>
	<cflocation url="/staff" addtoken="No">
</cfif>

<cfset form.r_id = url.r_id>

<cfinclude template="header.cfm">
<!--- <cfinclude template="../include/staffheaderinfo.cfm"> --->
<cfquery name="getResidents" datasource="#datasource#">
	select r_lname,r_fname,r_id from residents
	where c_id =<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#">and h_id NOT IN (
		select h_id from homesite 
		where c_id =<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#">and (softdelete = 1 or h_lname = 'VACANT')
		)
	and r_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#form.r_id#">
	order by r_lname, r_fname
</cfquery>

<script type="text/javascript">	
function showDataPop(rn,dt) {		
	p = document.getElementById('popBox');
	ph = document.getElementById('calEventBoxHeader');
	pb = document.getElementById('popBoxData');
	pb.innerHTML = unescape(rn);
	ph.innerHTML = unescape(dt);
	p.style.left = '200px';
	p.style.top = '200px';
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
<h1><cfoutput>VISITOR ANNOUNCEMENTS<cfif qEventTypes.recordcount> / SPECIAL EVENTS</cfif><br />
	RESIDENT: #ucase(getResidents.r_lname)#, #ucase(getResidents.r_fname)#</cfoutput></h1>
	
	<h2 style="border-bottom: 1px solid silver;font-size:2px">&nbsp;</h2>	
	<p>
	Click highlighted date to view items to edit.</p>
	<form action="guestAnnounce3.cfm" method="POST" name="ann2">
	<!--- <div style="border:2px solid #fff;margin: 0 66px;"> --->
	<table align="center" border="2" cellpadding="4" bordercolor="#ffffff">
		<cfset request.dsn = datasource>
		<tr>
			<td valign="top"><cfmodule template="../../residents/cal.cfm" r_id="#r_id#" month="#month(request.timezoneadjustednow)#"></td>
			<td valign="top"><cfmodule template="../../residents/cal.cfm" r_id="#r_id#" month="#month(request.timezoneadjustednow)+1#"></td>	
			<td valign="top"><cfmodule template="../../residents/cal.cfm" r_id="#r_id#" month="#month(request.timezoneadjustednow)+2#"></td>	
			<td valign="top"><cfmodule template="../../residents/cal.cfm" r_id="#r_id#" month="#month(request.timezoneadjustednow)+3#"></td>
		</tr>
	</table><br />
	<div style="text-align:center;">  
		<span style="background-color:#74dd82;padding:0px;border:1px solid #666;">&nbsp;&nbsp;&nbsp;&nbsp;</span> Indicates Arriving Visitors &nbsp;
		<cfif qEventTypes.recordcount><span style="background-color:#eeee77;padding:0px;border:1px solid #666;">&nbsp;&nbsp;&nbsp;&nbsp;</span> Indicates Special Event(s)</cfif>
	</div><br>
	
	<!--- </div> --->
	<cfoutput><input type="button" value="Announce Visitor" onclick="self.location='guestAnnounce2.cfm?r_id=#url.r_id#'">
	<cfif qEventTypes.recordcount><input type="button" value="Enter Special Event" onclick="self.location='SpecialEvent_announce1.cfm?r_id=#url.r_id#'"></cfif>
	</cfoutput></form>	
	<div id="popBox" style="padding-bottom:0px;display:none;">
		<div id="calEventBoxHeader">Calendar Results</div>
		<div id="popBoxData" style="overflow:auto;height:80px;"></div>
		<div style="text-align:right;margin:0px;background-color:#eee;"><a href="#" onclick="document.getElementById('popBox').style.display='none';">close box</a></div>
	</div>
</div>	
	<!--- 
	
	<cfinclude template="actionlist.cfm">
<cfinclude template="../footer.cfm"> --->