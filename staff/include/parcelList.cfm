<cfquery datasource="#request.dsn#" name="getParcels">
	SELECT		p.*,s.staff_fname,s.staff_lname,
				s2.staff_fname as deliveredby_fname,s2.staff_lname as deliveredby_lname
		FROM 	parcels p   
		JOIN 	staff s on p.staff_id = s.staff_id
		LEFT 	JOIN staff s2 on p.deliveredbystaff_id = s2.staff_id

<cfif structKeyExists(form,'r_id')>where  r_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(form.r_id)#"></cfif>
	order by receiveddate desc
</cfquery>
<cfoutput>			
  <cfparam name="request.hidesubtitle" default="false">
		<cfif getParcels.RecordCount>	
			<cfif NOT request.hidesubtitle>
			<h2 style="text-transform: uppercase;"><cfoutput>#labels.mail_parcel#s</cfoutput></h2>
				<div class="homePageDatagrid">
				<table width="100%" cellpadding="1" cellspacing="1" border="0" class="fixed_headers">
			<cfelse>
				<div class="modalDatagrid"> 
        <table width="100%" cellpadding="2" cellspacing="1" border="0" align="center" style="text-transform: uppercase;">
		
			</cfif>
			<thead>
      <tr class="datatableHdr">
        <td>Received from </strong></td><td> <strong>## of Items</strong> </td><td> <strong>Received Time </strong></td><td> <strong>Received Date</strong> </td>
        <td><Received Staff Name </strong></td><td> <strong>Deliver To</strong> </td><td> <strong>Delivery Time</strong> </td><td> <strong>Delivery Date</strong> </td><td> <strong>Delivery Staff Name</strong></td>
      </tr>
    <cfloop query="getParcels">
    <tr class="notcheckedinRow" onmouseover="this.className='checkedinRowHover';" onmouseout="this.className='notcheckedinRow';">
			<td><cfif isNumeric(receivedFrom)>Resident<cfelse>#getParcels.receivedFrom#</cfif></td>
      <td align="center">#itemcount#</td><td>#timeFormat(getParcels.receivedDate)#</td>
      <td>#DateFormat(getParcels.receivedDate,'m/d/yyyy')#</td>
      <td>#getParcels.staff_fname# #getParcels.staff_lname#</td>
      <td><cfif isNumeric(getParcels.deliverTo)>Resident<cfelse>#getParcels.deliverTo#</cfif></td>
      <td><cfif isDate(getParcels.delivereddate)>#timeFormat(getParcels.delivereddate)#</cfif></td>
      <td><cfif isDate(getParcels.delivereddate)>#dateFormat(getParcels.delivereddate,'m/d/yyyy')#</cfif></td>
      <td>#getParcels.deliveredby_fname# #getParcels.deliveredby_lname#</td>
    </tr>
    </cfloop>
  </table>
 </cfif>
</cfoutput>