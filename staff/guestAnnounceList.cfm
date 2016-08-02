<cfif NOT isDefined('SESSION.user_community')>
	<cflocation url="/staff" addtoken="No">
</cfif>

<cfinclude template="../header5.cfm">
<cfinclude template="include/staffheaderinfo.cfm">
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
	<div id="pageBody" style="display:none;z-index:2;" onclick="position:absolute;height:600px;this.style.display:none;document.getElementById('popBox').style.display='none'"><!--- any click on the page should hide the address pop-up --->
	</div>
	<div style="clear:both;">
	</div>	
	<br /><br />
	<form action="guestAnnounce3.cfm" method="POST" name="ann2">
		<div style="font-size:11px;background-color:#f5f5f5;border:thin solid black;width:790px;">
		<table width="98%" align="center" style="margin:10px;border-collapse:collapse;" cellpadding="0" cellspacing="3" border="0">
			<tr>
				<td align="center"><br />
				
					<strong><cfoutput>GUEST ANNOUNCEMENTS: #ucase(getResidents.r_fname)# #ucase(getResidents.r_lname)#</cfoutput><br></strong>
					<br />
				</td>
			</tr>
			<tr>				
				<td style="background-color:white;" align="center">
				<table align="center">
					<cfset request.dsn = datasource>
					<tr>
						<td valign="top"><cfmodule template="../residents/cal.cfm" r_id="#r_id#" month="#month(request.timezoneadjustednow)#"></td>
						<td valign="top"><cfmodule template="../residents/cal.cfm" r_id="#r_id#" month="#month(request.timezoneadjustednow)+1#"></td>	
						<td valign="top"><cfmodule template="../residents/cal.cfm" r_id="#r_id#" month="#month(request.timezoneadjustednow)+2#"></td>	
						<td valign="top"><cfmodule template="../residents/cal.cfm" r_id="#r_id#" month="#month(request.timezoneadjustednow)+3#"></td>	
					</tr>
				</table>
				</td>
			</tr>		
			<tr>
				<td align="center"><br />
				
				</td>
			</tr>	
		</table>
		</div>
	</form>
	
	<br /><br />
	
	<div id="popBox" style="padding-bottom:0px;">
		<div id="calEventBoxHeader">Calendar Results</div>
		<div id="popBoxData" style="overflow:auto;height:80px;"></div>
		<div style="text-align:right;margin:0px;background-color:#eee;"><a href="#" onclick="document.getElementById('popBox').style.display='none';">close box</a></div>
	</div>
	<cfinclude template="actionlist.cfm">
<cfinclude template="../footer.cfm">