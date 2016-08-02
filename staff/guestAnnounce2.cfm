<cfif NOT isDefined('SESSION.user_community')>
	<cflocation url="/staff" addtoken="No">
</cfif>

<cfinclude template="../header5.cfm"><cfinclude template="include/staffheaderinfo.cfm">
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


<script type="text/javascript">
<cfoutput>
function showDataPop(id) {			
		popBox = document.getElementById('popBox');
		document.getElementById('pageBody').style.backgroundColor = '##eee';
		document.getElementById('pageBody').style.display="block";
		addressFrame.location.href = 'popup/addressbook.cfm?residentid=#form.r_id#&number='+id;
		popBox.style.left = '500px';
		popBox.style.top = '200px';
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
	<div id="pageBody" style="display:none;z-index:2;" onclick="position:absolute;height:600px;this.style.display:none;document.getElementById('popBox').style.display='none'"><!--- any click on the page should hide the address pop-up --->
	</div>
	<div style="clear:both;">
	</div>
	
	<br/><br/>
	<form action="guestAnnounce3.cfm" method="POST" name="ann2">
		
		<div style="font-size:11px;background-color:#f5f5f5;border:thin solid black;width:790px;">
		<table align="center" style="margin:10px;border-collapse:collapse;" cellpadding="0" cellspacing="3" border="0">
			<!---  --->
			<cfoutput>
			<tr>
				<td colspan="3" align="center">
					<div align="center" class="staffHeader2">
					RESIDENT: #ucase(getResident.r_lname)#, #ucase(getResident.r_fname)#
					</div>
				</td>
			</tr>
			<tr>	
				<td colspan="2" align="right">					
					<input type="submit" value="Submit Visitor(s)">
					<input type="hidden" name="f_ABUsed">
					<input type="hidden" name="r_id" value="#form.r_id#">
				</td>
			</tr>
			</cfoutput>
			
			<cfloop from="1" to="5" index="i">
				<cfinclude template="include/guestAnnounceForm.cfm">
			</cfloop>
			<tr>	
				<td colspan="2" align="right">					
					<input type="submit" value="Submit Visitor(s)">
				</td>
			</tr>
		</table>
		</div>
	</form>
	<div id="popBox" style="padding-bottom:0px;">
			<iframe name="addressFrame" style="overflow:auto;height:300px;width:270px;"></iframe>
			<div style="text-align:right;margin:0px;background-color:#eee;">
			<a href="#" onclick="document.getElementById('popBox').style.display='none';">close box</a>
			</div>
		</div>
	<br /><br />
	<cfinclude template="actionlist.cfm">
<cfinclude template="../footer.cfm">