<cftry>
<style>
.selectedBox {background-color: #aea}
.preselectedBox {background-color: #aea}
</style>
<cfquery name="GetResident" datasource="#datasource#">
		select residents.r_id, residents.h_id, residents.r_fname, residents.r_lname, 
		residents.r_altphone, residents.r_email, homesite.h_id, homesite.h_lname, 
		homesite.h_address,homesite.h_unitnumber, homesite.h_city, homesite.h_state, homesite.h_zipcode, homesite.h_phone
		from residents, homesite
		where residents.h_id = homesite.h_id AND residents.r_id = #form.r_id#
	</cfquery>
	<script type="text/javascript">
<cfoutput>
function showDataPop(id) {			
		popBox = document.getElementById('popBox');
		document.getElementById('pageBody').style.backgroundColor = '##eee';
		document.getElementById('pageBody').style.display="block";
		addressFrame.location.href = '/staff/popup/addressbook.cfm?residentid=#form.r_id#&number='+id;
		popBox.style.left = '200px';
		popBox.style.top = '300px';
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
</script>
<cfinclude template="../bizrules/SaveGuestAnnouncements.cfm">
<cfinclude template="header.cfm">
<!--- <cfinclude template="include/staffheaderinfo.cfm"> --->
<div id="popUpContainer"><h1>Announce Visitor</h1>
	<table align="center" style="font-size:12px;padding-top:10px;padding-bottom:10px;padding-left:10px;padding-right:10px;margin-top:10px;width:500px;" cellpadding="0" cellspacing="3" border="0">
			<tr>
				<td colspan="3" style="padding-right:5px;">
					<ul>
					<cfoutput>#results#</cfoutput>
					</ul>	
				</td>
			</tr>
			<cfif NOT ListLen(alertList)>
				<cflocation url="/staff">
			<cfelse>
			<tr>
				<td colspan="3" align="center">	&nbsp;
				</td>
			</tr>
			<tr>
				<td colspan="3" style="padding-right:5px;">
				<form action="guestAnnounce3.cfm" method="POST" name="ann2">
				<div style="font-size:11px;width:790px;">
				<table align="center" style="margin:10px;border-collapse:collapse;" cellpadding="0" cellspacing="3" border="0">
		
					<cfoutput>
					<tr>	
						<td colspan="2" align="right">					
							<input type="submit" value="Submit Guest(s)" class="btn">
							<input type="hidden" name="f_ABUsed">
							<input type="hidden" name="r_id" value="#form.r_id#">
						</td>
					</tr>
					</cfoutput>
					<cfloop list="#alertList#" index="i">
						<cfinclude template="../include/guestAnnounceForm.cfm">
					</cfloop>
					<tr>	
				<td colspan="2" align="right">					
					<input type="submit" value="Submit Guest(s)" class="btn">
				</td>
			</tr>
		</table>
		</div>
				</td>
			</tr>
			
			</cfif>
		</table>
	</form>
	
	<div id="popBox" style="padding-bottom:0px;">
			<iframe name="addressFrame" style="overflow:auto;height:300px;width:270px;"></iframe>
			<div style="text-align:right;margin:0px;background-color:#eee;">
			<a href="#" onclick="document.getElementById('popBox').style.display='none';">close box</a>
			</div>
		</div>
</div>
<cfcatch><cfdump var="#cfcatch#"></cfcatch>
</cftry>