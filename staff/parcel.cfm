<cfif NOT isDefined('SESSION.user_community')>
	<cflocation url="/staff" addtoken="No">
</cfif>
<cfset request.dsn = datasource>

<cfif isDefined('url.parcelPickup')>
	<cfinclude template="bizrules/parcelPickup.cfm">
	<cflocation url="index.cfm" addtoken="false">
</cfif>

<cfif isDefined('form.numberOfParcels')>
	<cfquery datasource="#request.dsn#">
		insert into parcels (r_id, staff_id,entrypoint_id,itemcount,receivedfrom,deliverto,receiveddate)
		values (<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(form.r_id)#">,
			<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(session.staff_id)#">,
			<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(session.entrypointid)#">,
			<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#form.numberOfParcels#">,
			<cfif findNoCase('other',form.receivedFrom)>
				<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.otherReceivedtxt#">
			<cfelse>
				<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.receivedFrom#">
			</cfif>,
			<cfif findNoCase('other',form.deliverto)>
				<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.otherDelivertxt#">
			<cfelse>
				<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.deliverTo#">
			</cfif>,
			<cfqueryparam value="#CreateODBCDateTime(now())#" cfsqltype="CF_SQL_TIMESTAMP">
		)
	</cfquery>
</cfif>


<cfparam name="form.r_id" default="0">
<cfset shippingList = "USPS, FedEx, UPS, DSL, Manager">
			
<cfquery datasource="#request.dsn#" name="getResident">
	select * from residents r join homesite h on h.h_id = r.h_id
	where h.c_id =<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#">
	and r.r_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(form.r_id)#">
</cfquery>


<cfinclude template="../header5.cfm">
<cfinclude template="include/staffheaderinfo.cfm">
<script type="text/javascript">
	$(document).ready(function(){
		r_id = <cfoutput>#r_id#;</cfoutput>
		selectsReset();
					
		$('#ReceivedFromSel').change(function(e){
			selectsReset();
			if ($(this).val()==r_id){
				<cfoutput><cfloop list="#shippingList#" index="entity">
				$("##DeliverToSel").append('<option>#entity#</option>');</cfloop></cfoutput>				
				$("#DeliverToSel").append('<option>Other*</option>');
			}
			else {
				$("#DeliverToSel").append('<option value="'+r_id+'">Resident</option>');
				if ($(this).val()=='Other*'){
					$('#otherForReceived').show();
				}
				else{
					$('#otherForReceived').hide();
				}
			}			
		});
	
		$('#DeliverToSel').change(function(e){
			if ($(this).val()=='Other*'){
				$('#otherForDeliver').show();
			}
			else{
				$('#otherForDeliver').hide();
			}
		});
	});
	
		function selectsReset(){
			$('#DeliverToSel option').remove();
			$('#otherForReceived').hide();
			$('#otherForDeliver').hide();	
		}
		
</script>
<div id="pageBody" style="display:none;z-index:2;" onclick="position:absolute;height:600px;this.style.display:none;document.getElementById('popBox').style.display='none'"><!--- any click on the page should hide the address pop-up --->
	</div>
	<div style="clear:both;">
	</div>	
	<br /><br />
	<div style="font-size:11px;background-color:#f5f5f5;border:thin solid black;width:790px;">		
	<form name="testForm" action="parcel.cfm" method="post"><br>
	<div style="text-align:center">
		<cfoutput><input type="hidden" name="r_id" value="#form.r_id#" />		
			<div class="staffHeader1">PARCEL/MAIL PICK-UP<br></div>
			<br />
			<table style="margin-left: 57px;">
			<tr>
			<tr>
	            <td style="font-weight:bold;color:##336699;font-size:13px;" valign="top" rowspan="6">RESIDENT:</td>
	            <td style="font-size:14px;" valign="top" rowspan="6"><strong>#ucase(getResident.r_lname)#, #ucase(getResident.r_fname)#</strong><br>
	                <cfif NOT getCommunity.showunitonlyoption>#getResident.h_address#<br><cfelse>Unit</cfif>
					 <cfif len(getResident.h_unitnumber)> #getResident.h_unitnumber#<br></cfif>
	                 #getResident.h_city#,#getResident.h_state#&nbsp;#getResident.h_zipcode#<br>
	                Main Phone: #getResident.h_phone#<br>
	                <cfif Len(getResident.r_altphone) and not getResident.r_altphone is "..">Alt Phone: #getResident.r_altphone#</cfif>
	            </td>
			</tr>
			</table><br />
			<fieldset style="background-color:##ffffff;border: 1px solid ##333366;width:650px;text-align:left;margin:6px auto 0px;"><legend style="font-size: 11pt;color:##336699;font-weight:bold">Add New Receipt</legend>
				<dl style="margin-left: 12px;">
					<dt>Step 1:</dt>
						<dd>Number of Parcels: <select name="numberOfParcels"><cfloop from="1" to="10" index="i"><option>#i#</cfloop></select></dd>
					<dt>Step 2:</dt>
						<dd>Received From: <select name="ReceivedFrom" id="ReceivedFromSel">
						<option> - Make Selection - </option>
						<option value="#r_id#">Resident</option>
						<cfloop list="#shippingList#" index="entity"><option>#entity#</option></cfloop>
						<option>Other*</option>
						</select>
						<div id="otherForReceived">If Other, Enter Received: <input name="otherReceivedtxt" type="text" value=""></div>
						</dd>
					<dt>Step 3:</dt>
						<dd>Deliver To: <select name="DeliverTo" id="DeliverToSel">
						<option> - Make Selection - </option>
						<option value="#r_id#">Resident</option>
						<cfloop list="#shippingList#" index="entity"><option>#entity#</option></cfloop>
						<option>Other*</option>
						</select>
						<div id="otherForDeliver">If Other, Enter Deliver To: <input name="otherDelivertxt" type="text" value=""></div>
						</dd>
				</dl>
			</fieldset><br />
			<input type="submit" value="save">
			<fieldset style="background-color:##ffffff;border: 1px solid ##333366;width:650px;text-align:left;margin:6px auto 0px;">
				<legend style="font-size: 11pt;color:##336699;font-weight:bold">History</legend>
			<div style="height:124px;overflow:auto;border:1px solid black;">
			<cfinclude template="/staff/include/parcelList.cfm" >
			</div>
			</fieldset>
	</cfoutput>		
	</div>
	</form>
</div>
	
	   <cfmodule template="actionlist.cfm">
	<cfinclude template="../footer.cfm">

