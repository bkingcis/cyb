<cfparam name="form.r_id" default="0">
<cfquery datasource="#request.dsn#" name="getParcels">
	select p.*,r.r_fname,r.r_lname from parcels p   
	JOIN residents r on p.r_id = r.r_id 
	JOIN homesite h on h.h_id = r.h_id
	<cfif val(form.r_id)>
		where r.r_id = <cfqueryparam value="#form.r_id#" cfsqltype="CF_SQL_INTEGER" />
	<cfelse>	
		where  r.r_id in (select r_id from residents where c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(session.user_community)#" />)
	</cfif>
	and delivereddate is null
	order by receiveddate desc
</cfquery>
<cfif getParcels.recordcount>
	<h2>PARCEL/PACKAGE</h2>
	<div class="homePageDatagrid" style="max-height: 120px;">
		<table width="100%" cellpadding="1" cellspacing="2" border="0" align="center">
		<tr class="datatableHdr">
			<td align="center">Deliver To</td>
			<td align="center"># of Items</td>
			<td align="center">Received From</td>
			<td align="center">Drop-Off Date</td>
			<td align="center">Action</td>
		</tr>	
		<cfoutput query="getParcels">
			<tr class="notcheckedinRow" onmouseover="this.className='checkedinRowHover';" onmouseout="this.className='notcheckedinRow';">
				<td align="left">&nbsp;&nbsp;<a href="/staff/popup/parcelpickup.cfm?deliverto=#deliverTo#" class="extlink"><cfif isNumeric(deliverTo)>#UCASE(r_lname)#, #UCASE(r_fname)#<cfelse>#ucase(deliverTo)#</cfif></a></td>
				<td align="center">#itemcount#</td>
				<td align="center"><cfif isNumeric(receivedFrom)>#UCASE(r_lname)#, #UCASE(r_fname)#<cfelse>#ucase(receivedFrom)#</cfif></td>
				<td align="center">#dateFormat(receivedDate,'m/d/yyyy')# #timeFormat(receivedDate)#</td>
				<td align="center"><input type="button" value="pick-up" onclick="ParcelPickup(#parcel_Id#);"></td>
			</tr>
		</cfoutput>
		</table>
	</div>
	
	<script>
		function ParcelPickup(parcelid){
			/*$.fancybox({
				'type': 'iframe',
				'href': 'parcel.cfm?parcelPickup='+parcelid
			});*/
			self.location='/staff/parcel.cfm?parcelPickup='+parcelid;
		}
	</script>
</cfif>