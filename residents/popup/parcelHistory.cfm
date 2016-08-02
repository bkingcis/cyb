<cfinclude template="header.cfm">
	<cfquery datasource="#datasource#" name="qParcels">
		select p.*,r.r_fname, r.r_lname,  s.staff_fname,s.staff_lname
		from parcels p join residents r on cast(r.r_id as text) = p.deliverTo
		join staff s on s.staff_id = p.staff_id  
		<cfif isDefined('qcommunity.parcelOptionAllHomesite')>
			where r.r_id = #session.r_id#
		<cfelse>
			where r.h_id = #val(getResident.h_id)#
		</cfif>
		and delivereddate is null
	</cfquery>
	<cfquery datasource="#datasource#" name="qparcelsHistory">
		<!--- select p.*,r.r_fname, r.r_lname ,  s.staff_fname,s.staff_lname,			
				s2.staff_fname as deliveredby_fname,s2.staff_lname as deliveredby_lname
		from parcels p join residents r on cast(r.r_id as text) = p.deliverTo
		join staff s on s.staff_id = p.staff_id  
		LEFT 	JOIN staff s2 on p.deliveredbystaff_id = s2.staff_id
		<cfif isDefined('qcommunity.parcelOptionAllHomesite')>
			where r.r_id = #session.r_id#
		<cfelse>
			where r.h_id = #val(getResident.h_id)#
		</cfif>
		order by receiveddate desc --->
		SELECT		p.*,s.staff_fname,s.staff_lname,r_lname, r_fname,
				s2.staff_fname as deliveredby_fname,s2.staff_lname as deliveredby_lname
		FROM 	parcels p
		JOIN 	residents r on (cast(r.r_id as text) = p.deliverTo OR cast(r.r_id as text) = p.ReceivedFrom)
		JOIN 	staff s on p.staff_id = s.staff_id
		LEFT 	JOIN staff s2 on p.deliveredbystaff_id = s2.staff_id
		where  r.r_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(getResident.r_id)#">
		order by receiveddate desc
	</cfquery>
	
	<h4>Items to Pick Up:</h4>
		<table class="table table-hover table-condensed" style="font-size: 0.8em">
		<thead>
		<tr>
			<th>Resident / Adressee</th>
			<th>Received From</th>
			<th># Of Items</th>
			<th>Received</th>
			<th>Staff Name</th>
		</tr>
		</thead>
		<tbody>
		<cfoutput query="qparcels">
		<tr bgcolor="##AAEEAA" onmouseover="$(this).attr('bgcolor','##ffffff')" onmouseout="$(this).attr('bgcolor','##AAEEAA')">
			<td>#ucase(r_lname)#, #ucase(r_fname)#</td>
			<td>#receivedFrom#</td>
			<td align="center">#itemcount#</td>
			<td>#dateFormat(receivedDate,'m/d/yyyy')# #timeFormat(receivedDate)#</td>
			<td>#staff_fname# #staff_lname#</td>			
		</tr>
		</cfoutput>
		</tbody>
	</table>
	
	<h4>Parcel/Mail History:</h4>
		<table class="table table-hover table-condensed" style="font-size: 0.8em">
		<thead>
		<tr>
			<th>Received From</th>
			<th># Of Items</th>
			<th>Received</th>
			<th>Staff Name</th>
			<th>Delivered To</th>
			<th>Pick-up</th>
			<th>Pick-up Staff</th>
		</tr>
		</thead>
		<tbody>
		<cfoutput query="qparcelsHistory">
		<tr>
			<td nowrap="nowrap"><cfif isNumeric(deliverTo)>#ucase(r_lname)#, #ucase(r_fname)#<cfelse>#deliverTo#</cfif></td>
			<td valign="top" align="center">#itemcount#</td>
			<td valign="top">#dateFormat(receivedDate,'m/d/yyyy')# #timeFormat(receivedDate)#</td>
			<td nowrap="nowrap">#staff_fname# #staff_lname#</td>
			<td nowrap="nowrap"><cfif isNumeric(receivedFrom)>#ucase(r_lname)#, #ucase(r_fname)#<cfelse>#receivedFrom#</cfif></td>
			<td valign="top">#dateFormat(deliveredDate,'m/d/yyyy')# #timeFormat(deliveredDate)#</td>
			<td nowrap="nowrap">#deliveredby_fname# #deliveredby_lname#</td>
		</tr>
		</cfoutput>
		</tbody>
	</table>
	
