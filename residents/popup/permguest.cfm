<cfsilent>
<cfif NOT structKeyExists(session,"user_id") OR session.user_id EQ 0><cflocation url="/residents"></cfif>
<cfquery name="getperms" datasource="#datasource#">select guests.g_id, guests.r_id, guests.g_fname, guests.g_lname, guestvisits.g_id, 
	guestvisits.g_permanent, guestvisits.g_cancelled, guestvisits.v_id, guestvisits.g_barcode, guests.g_paused
	FROM guests INNER JOIN guestvisits ON guests.g_id = guestvisits.g_id
	WHERE guests.r_id = #session.user_id#
	AND guestvisits.g_permanent = TRUE
	AND guests.g_cancelled IS NULL
	ORDER BY g_lname, g_fname
</cfquery>
</cfsilent>
<cfinclude template="header.cfm">
<div role="tabpanel">
		<div class="alert" role="alert"></div>

  <!-- Nav tabs 
  <ul class="nav nav-tabs" role="tablist">
	<li role="presentation" class="active"><a href="#new" aria-controls="new" role="tab" data-toggle="tab">New <cfoutput>#labels.permanent_visitor# #labels.visitor#</cfoutput>:</a></li>
	<li role="presentation"><a href="#old" aria-controls="old" role="tab" data-toggle="tab">Current <cfoutput>#labels.permanent_visitor# #labels.visitor#</cfoutput>s:</a></li>
  </ul>-->

  <!-- Tab panes -->
  <div class="tab-content">
	
	<div role="tabpanel" class="tab-pane active" id="new" style="min-height: 230px;">
		<!--- <p> &nbsp; </p>
		
		
		<cfif getperms.recordcount lt maxPermGuests OR maxPermGuests eq 999>
			<cfinclude template="permguest1.cfm">
		<cfelse>
			<div class="alert alert-warning" style="text-transform: upper">
			MAXIMUM NUMBER OF <cfoutput>#labels.permanent_visitor# #labels.visitor#</cfoutput>S: <strong><cfoutput>#maxPermGuests#</cfoutput></strong>  - You must
			remove an existing <cfoutput>#labels.permanent_visitor#</cfoutput> before adding a new one.
			</div>
			<script>
				$('#btnContinue').hide();	  
				$('#btnBack').hide();
				$('#btnClose').hide();
			</script>
		</cfif>
	</div>
	<div role="tabpanel" class="tab-pane" id="old" style="min-height: 230px;">
	<p> &nbsp; </p> --->
		
	<cfif getperms.recordcount>
		<table class="table table-hover">
			<thead>
				<tr>
					<th>#</th>
					<th><cfoutput>#labels.visitor#</cfoutput></th>
					<th align="right" style="text-align:right;">Actions</th>
				</tr>
			</thead>
			<tbody>
				<script>
					$(function() {
						$("[name='active_chk']").bootstrapSwitch(
							{
								onColor:'success',
								offColor: 'warning',
								onText: 'On',
								offText: 'Off'
							 }
						);
					})
				</script>
			<cfoutput query="getperms">
			<tr>
				<td>#currentRow#.</td>
				<td>#ucase(getperms.g_lname)#, #ucase(getperms.g_fname)#</td>
				<td align="right">
					<div class="btn-group btn-group-xs" role="group">						
						<input name="active_chk" type="checkbox"<cfif NOT val(getperms.g_paused)> checked="checked"</cfif> data-toggle="toggle" data-size="mini" data-vid="#getperms.v_id#">
						&nbsp;&nbsp;
					</div>
					<cfif GetCommunity.DashPass IS 'YES'>
					<div class="btn-group btn-group-xs" role="group">
						<input type="button" class="btn btn-xs btn-default reissue-dashpass-btn" value="Reissue DashPass" data-vid="#getperms.v_id#">
					</div>
					</cfif>
					<!--- <div class="btn-group btn-group-xs" role="group">
						<input type="button" class="btn btn-xs btn-default guest-history-btn" value="History" data-gid="#getperms.g_id#" />
					</div> --->
					<div class="btn-group btn-group-xs" role="group" aria-label="...">
					<button type="button" class="btn btn-xs btn-danger guest-cancel-btn" data-gid="#getperms.g_id#" ><span class="glyphicon glyphicon-trash" ></span></button>
					</div>
				</td>
			</tr>
			</cfoutput>
			</tbody>
		</table>
		</cfif>
			
		<cfif getperms.recordcount lt maxPermGuests OR maxPermGuests eq 999>
			<cfoutput>
			<!--- <p>To add an #labels.permanent_visitor# #labels.visitor#, select ADD #labels.visitor# and tick the #labels.permanent_visitor# box.</p>--->
			<button type="button" class="btn btn-primary new-perm-guest">Add #labels.permanent_visitor# #labels.visitor#</button>
			</cfoutput>
		<cfelse>
			<cfoutput>You have reached the maximum number of #labels.permanent_visitor# #labels.visitor#s permitted.</cfoutput>
		</cfif>
	</div>
		
</div>	
	
	