<cftry>
<cfif structKeyExists(form,'switch_h_id')>
	 <cfset session.h_id = form.switch_h_id>
<cfelseif NOT structKeyExists(session,'h_id')>
	 <cfquery name="GetH" datasource="#request.dsn#">
	 	select h_id from residents
		where r_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(session.user_id)#" />
	 </cfquery>
	 <cfset session.h_id = GetH.h_id>
</cfif>
<cfquery name="GetResident" datasource="#request.dsn#">
	select r.r_id, h.h_id, r.r_fname, r.r_lname, 
				r.r_altphone, r.r_email, h.*
	from 	residents r left join residents_homesite rh	on r.r_id = rh.r_id 
		left join 	homesite h on rh.h_id = h.h_id
	WHERE rh.h_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(session.h_id)#" />
	AND 	r.r_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(session.user_id)#" />
</cfquery>

<cfif !GetResident.recordcount>
	<cfquery name="GetResident" datasource="#request.dsn#">
		select r.r_id, h.h_id, r.r_fname, r.r_lname, 
					r.r_altphone, r.r_email, h.*
		from 	residents r join homesite h on r.h_id = h.h_id
		WHERE r.h_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(session.h_id)#" />
		AND 	r.r_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(session.user_id)#" />
	</cfquery>
</cfif>

<cfif isDefined("getCommunity.track_maintenance_requests") and getCommunity.track_maintenance_requests>
  <cfquery datasource="#request.dsn#" name="getRequests_active">
    select maintenance_request_id from maintenance_request 
		WHERE c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(session.user_community)#" />
		AND   ( request_status = 'inprogress' OR  request_status = 'new' )
		<!--- AND r_id in (select r_id from residents where ) --->
  </cfquery>
</cfif>
<cfquery datasource="#request.dsn#" name="qParcels">
	select p.*,r.r_fname, r.r_lname 
	from parcels p join residents r on cast(r.r_id as text) = p.deliverTo
	<cfif isDefined('qcommunity.parcelOptionAllHomesite')>
	where r.r_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(session.r_id)#" />
	<cfelse>
	where r.h_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(getResident.h_id)#" />
	</cfif>
	and delivereddate is null
</cfquery>
<cfinclude template="qry_overlap.cfm">
<nav class="navbar navbar-default">
<div class="container-fluid" style="background-image: url('/img/logo.png');background-position: right 70px top 8px;background-size: 134px;background-repeat: no-repeat;">
  <div class="navbar-header">
	<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
	  <span class="sr-only">Toggle navigation</span>
	  <span class="icon-bar"></span>
	  <span class="icon-bar"></span>
	  <span class="icon-bar"></span>
	</button>
	<cfoutput><a class="hidden-xs navbar-brand" href="##"><strong>#ucase(GetResident.r_fname)# #ucase(GetResident.r_lname)#</strong> 
	<!--- <small>primary phone: #GetResident.r_altphone#</small> ---></a></cfoutput>
  </div>
  <div id="navbar" class="navbar-collapse collapse" aria-expanded="false" style="height: 1px;">
	<ul class="nav navbar-nav">
	  <li><a style="cursor:pointer;" data-toggle="modal" data-target="#headerModal" data-action="settings"><span class="glyphicon glyphicon-user"></span> <cfoutput>#labels.other_users#</cfoutput></a></li>
		<cfif isDefined("getCommunity.track_maintenance_requests") and getCommunity.track_maintenance_requests>
		<li><a style="cursor:pointer;" data-toggle="modal" data-target="#headerModal" data-action="maintenance">
			<span class="glyphicon glyphicon-wrench"></span> 
			<cfoutput>#labels.communications#</cfoutput> <cfif getRequests_active.recordcount><span class="label label-warning label-as-badge"><cfoutput>#getRequests_active.recordcount#</cfoutput></span></cfif></a></li>
	  </cfif>
	  <li><a style="cursor:pointer;" data-toggle="modal" data-target="#headerModal" data-action="notifications"><span class="glyphicon glyphicon-flag"></span> Notifications</a></li>
	  <li><a href="logout.cfm" style="color:#f77b33;"><span class="glyphicon glyphicon-log-out"></span> logout</a></li>
	 <!--- <li><a href="messages.cfm"> Messages <span class="label label-danger label-as-badge">2</span></a></li> --->
	</ul>

  </div><!--/.nav-collapse -->
</div><!--/.container-fluid -->
</nav>

<style>
	.label-as-badge { border-radius: 1em; }
</style>
	<cfcatch><cfdump var="#cfcatch#"></cfcatch>
</cftry>

<!--- 
	<cfif qoverlap.recordcount>
			<div class="alert alert-danger"> 
				<strong>Alert:  Overlapping <cfoutput>#labels.visitor#</cfoutput> Announcements</strong>
				<br /><br />
				<cftry>
				<cfoutput query="qoverlap" group="g_id">
					<cfquery name="readguest" datasource="#request.dsn#">
						select g_fname, g_lname from guests
						where g_id = #qoverlap.g_id#
					</cfquery>
					<a data-toggle="modal" data-target="##baseModal" data-action="overlap" data-vid="#qoverlap.lv_id#,#qoverlap.rv_id#" data-gid="#qoverlap.g_id#">#ucase(readguest.g_lname)#, #ucase(readguest.g_fname)#</a><br /><!---  - #qoverlap.lv_id# :: #qoverlap.rv_id# --->
				</cfoutput>
				<cfcatch><cfdump var="#cfcatch#"></cfcatch>
				</cftry>
			</div>
		</cfif>
<cfif qParcels.recordcount>
<div class="alert alert-danger" role="alert"><button type="button" class="close" data-dismiss="alert" aria-label="Close">
	<span aria-hidden="true">&times;</span></button>
	<a data-toggle="modal" data-target="#baseModal" data-action="parcelHistory"><span class="glyphicon glyphicon-envelope"></span>  <strong>Notice:</strong>  You have a Parcel/Mail waiting for pick-up</a>
</div>
</cfif> --->