<cftry>
	<cfquery name="getEvents" datasource="#datasource#">
		select date_part('day',e.eventdate) as dayofmonthdata,e.specialevent_id, e.eventdate, t.abbreviation,
			e.specialevent_id, e.r_id, e.starttime, e.endtime, e.eventtypeid, t.label as EventLabel
			FROM specialevents e join communityEventTypes t on t.etid = e.eventtypeid
		Where eventdate between #CreateODBCDate(dt)# 
			AND #CreateODBCDate(DateAdd("d",1,dt))#
		AND canceled IS null
		AND r_id = #session.user_id#	
		<!--- added to remove past dates --->
		and eventdate > #CreateODBCDate(dateAdd("d",-1,request.timezoneadjustednow))#
	</cfquery>
	<cfquery name="getEvents2" datasource="#datasource#">
		select distinct date_part('day',s.visit_date) as dayofmonthdata,s.visit_date, 
			s.r_id, gv.guestcompanioncount,
			s.v_id, g.g_lname || ', ' || g.g_fname as gName, g.g_id,  s.g_singleentry, gv.insertedby_staff_id
		from schedule s	join  guestvisits gv on s.v_id = gv.v_id
			join guests g on g.g_id = gv.g_id
			<!--- left join visits v on v.v_id = gv.v_id and v.g_id = s.g_id --->
		Where s.r_id = #session.user_id#	
		<!--- added to remove past dates --->
		and visit_date = #CreateODBCDate(dt)#
		and gv.g_cancelled is null
	</cfquery>
	<cfcatch type="any"><cfdump var="#cfcatch#"><cfabort></cfcatch>
</cftry>
	
	 <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title"><cfoutput>#DateFormat(dt,'mmmm d, yyyy')#</cfoutput></h4>
      </div>
      <div class="modal-body">
	<cfif getevents2.recordcount>
		<strong>Guests</strong>
		
		<table class="table table-hover">
			<thead>
				<tr>
					<th>Guest (last, first):</th>
					<th>Options</th>	
				</tr>
			</thead>
			<tbody>
			<cfoutput query="getEvents2">
				<tr><td>#getEvents2.gname#</td>
					<td>					
						<input type="button" class="btn btn-sm btn-default" value="EDIT" onclick="self.location='modifyschedule2.cfm?v_id=#getEvents2.v_id#'">
						<input type="button" class="btn btn-sm btn-primary" value="CANCEL" onclick="self.location='deletecheck3.cfm?v_id=#getEvents2.v_id#'">
					</td>
				</tr>
			</cfoutput>
			</tbody>
		</table>
	</cfif>
	 
	<cfif getEvents.recordCount>
		<h2>Special Events</h2>
		<table class="table table-hover">
			<thead>
				<tr>
					<th>Event</th>
					<th>Options</th>	
				</tr>
			</thead>
			<tbody>
				<cfoutput query="getEvents">
					<tr><td>#getEvents.Eventlabel#</td>
						<td>					
							<input type="button" class="btn btn-sm btn-default" value="EDIT" onclick="self.location='modspecialevent.cfm?specialevent_id=#getEvents.specialevent_id#'">
							<input type="button" class="btn btn-sm btn-primary" value="CANCEL" onclick="self.location='deletecheck3.cfm?specialevent_id=#getEvents.specialevent_id#'">
						</td>
					</tr>
				</cfoutput>
			</tbody>
		</table>
	</cfif>
	</div>
	<div class="modal-footer">
		<button type="button" id="btn_back" class="btn btn-sm btn-default" data-dismiss="modal">CLOSE</button>
	</div>
</div>		
