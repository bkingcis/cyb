<cfif NOT isDefined('SESSION.user_community')>
	<cflocation url="/staff" addtoken="No">
</cfif>
<cfset request.dsn = datasource>
<cfif isDefined('url.r_id')><cfset form.r_id = url.r_id></cfif>
<cfif isDefined('url.parcelPickup')>
	<cfinclude template="../bizrules/parcelPickup.cfm">
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


<cfinclude template="header.cfm">

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
	<div id="popUpContainer">
	<cfoutput>
	<h1>Parcel/Package:
	<cfif val(form.r_id)> &nbsp; #ucase(getResident.r_lname)#, #ucase(getResident.r_fname)#<cfelse> &nbsp; ALL RESIDENTS</cfif></h1>
	
	<cfif val(form.r_id)>
	<form name="testForm" action="parcel.cfm" method="post">	
		<input type="hidden" name="r_id" value="#form.r_id#" />
			<h2>Receive New Parcel/Package</h2>
				<table align="center" cellpadding="6" border="2" bordercolor="##ffffff">
					<tr>
						<td align="right" valign="top" width="50%"><strong>Number of Parcels:</strong></td>
						<td> <select name="numberOfParcels"><cfloop from="1" to="10" index="i"><option>#i#</cfloop></select></td>
					</tr>
					<tr>
						<td align="right" valign="top"><strong>Received From:</strong></td>
						<td>
							<select name="ReceivedFrom" id="ReceivedFromSel">
						<option> - Make Selection - </option>
						<option value="#r_id#">Resident</option>
						<cfloop list="#shippingList#" index="entity"><option>#entity#</option></cfloop>
						<option>Other*</option>
						</select>
						<div id="otherForReceived">If Other, Enter Received: <input name="otherReceivedtxt" type="text" value=""></div>
						</td>
					</tr>
					<tr>
						<td align="right" valign="top"><strong>Deliver To:</strong></td>
						<td>
						<select name="DeliverTo" id="DeliverToSel">
						<option> - Make Selection - </option>
						<option value="#r_id#">Resident</option>
						<cfloop list="#shippingList#" index="entity"><option>#entity#</option></cfloop>
						<option>Other*</option>
						</select>
						<div id="otherForDeliver">If Other, Enter Deliver To: <input name="otherDelivertxt" type="text" value=""></div></td>
					</tr>
				</table>
	<br />
			<input type="submit" value="save" style="color:Green;">
			
			<cfinclude template="../include/homePageParcelList.cfm">
			
			<cfquery datasource="#request.dsn#" name="getParcels">
				SELECT		p.*,s.staff_fname,s.staff_lname,
							s2.staff_fname as deliveredby_fname,s2.staff_lname as deliveredby_lname
					FROM 	parcels p   
					JOIN 	staff s on p.staff_id = s.staff_id
					LEFT 	JOIN staff s2 on p.deliveredbystaff_id = s2.staff_id
				where  r_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(form.r_id)#">
				order by receiveddate desc
			</cfquery>
			<cfif getParcels.recordcount>
			<h2>History</h2>
			<div class="homePageDatagrid" style="max-height: 120px;overflow: auto;">
			<table width="100%" cellpadding="1" cellspacing="1" border="0" align="center">
				<tr class="datatableHdr">
					<td><strong>Received from </strong></td><td> <strong>## of Items</strong> </td><td> <strong>Received Time </strong></td><td> <strong>Received Date</strong> </td>
					<td><strong> Received Staff Name </strong></td><td> <strong>Deliver To</strong> </td><td> <strong>Delivery Time</strong> </td><td> <strong>Delivery Date</strong> </td><td> <strong>Delivery Staff Name</strong></td>
				</tr>
				<cfloop query="getParcels">
				<tr class="notcheckedinRow" onmouseover="this.className='checkedinRowHover';" onmouseout="this.className='notcheckedinRow';">
					<td>&nbsp;<cfif isNumeric(receivedFrom)>Resident<cfelse>#getParcels.receivedFrom#</cfif></td>
					<td align="center">#itemcount#</td><td>#timeFormat(getParcels.receivedDate)#</td>
					<td>#DateFormat(getParcels.receivedDate,'m/d/yyyy')#</td>
					<td>#getParcels.staff_fname# #getParcels.staff_lname#</td>
					<td><cfif isNumeric(getParcels.deliverTo)>Resident<cfelse>#getParcels.deliverTo#</cfif></td>
					<td><cfif isDate(getParcels.delivereddate)>#timeFormat(getParcels.delivereddate)#</cfif></td>
					<td><cfif isDate(getParcels.delivereddate)>#dateFormat(getParcels.delivereddate,'m/d/yyyy')#</cfif></td>
					<td>#getParcels.deliveredby_fname# #getParcels.deliveredby_lname#</td>
				</tr>
				</cfloop>
			</table></div>
			</cfif>
		<cfelse>
			<cfinclude template="../include/homePageParcelList.cfm">
		</cfif>
	</cfoutput>		
	</div>
	</form>

