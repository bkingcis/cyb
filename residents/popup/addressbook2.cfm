<cftry>
<cfparam name="orderby" default="date">
	  <!--- Removed for inclusion in Announce Step. <cfinclude template="header.cfm"> --->
		<cfquery name="getAbook" datasource="#datasource#">
			select g.g_id,g.g_lname,g.g_fname,gv.g_initialvisit from guests g left join guestvisits gv on g.g_id = gv.g_id
			where g.r_id = #session.user_id#
			and gv.g_permanent <> 'true'
			and g.g_lname <> ''
			order by <cfif orderby is 'date'>gv.g_initialvisit desc<cfelse>g.g_lname</cfif>
		</cfquery>
		
		<cfif getabook.recordcount>
			<cfparam name="dsptype" default="table">
			<cfif dsptype is 'table'>
				<div role="tabpanel">
					<!-- <ul class="nav nav-pills" role="tablist">
					  <li role="presentation" class="active"><a href="#recent" aria-controls="recent" role="tab" data-toggle="pill">Recent</a></li>
					  <li role="presentation"><a href="#all" aria-controls="all" role="tab" data-toggle="pill">All</a></li>
					</ul> -->
					<div class="tab-content" style="padding:5px; border: 1px solid ##eee; height: 230px; overflow-y: scroll">
						<div role="tabpanel" class="tab-pane active" id="recent">
							<table class="table table-hover">
								<thead>
									<tr><th><cfoutput>#labels.visitor#</cfoutput></th><th>Visit Date</th><th class="text-right">Actions</th></tr>
								</thead>
								<tbody>
								<cfoutput query="getabook">
								<tr>
									<td>#ucase(getabook.g_lname)#<cfif len(getAbook.g_lname) and len(getAbook.g_fname)>,</cfif> #ucase(getabook.g_fname)#</td>
									<td>#dateFormat(g_initialvisit,'m/d/yyyy')#</td>
									<td align="right">					
										<div class="btn-group btn-group-xs" role="group" aria-label="...">
											<button class="btn btn-xs btn-default new-visit-btn" data-gid="#g_id#"><span class="glyphicon glyphicon-plus-sign"></span> New Visit</button>
											<button class="btn btn-xs btn-default guest-history-btn" data-gid="#g_id#"><span class="glyphicon glyphicon-time"></span> History</button>
											<!-- <input type="button" class="btn btn-xs btn-danger" class="btn-del" data-gid="#g_id#" value="Remove"> -->
										</div>
									</td>
								</tr>
								</cfoutput>
								</tbody>
							</table>
						</div>
						<!-- <div role="tabpanel" class="tab-pane" id="all">...Coming Soon...</div> -->

					</div>
				</div>
			<cfelse>
				<div class="row">
					<div class="col-sm-4"><strong>Name (Last, First):</strong></div>
					<div class="col-sm-4"><strong><cfoutput>#labels.visitor#</cfoutput> Type:</strong></div>
					<div class="col-sm-4"><strong>Announcement Options:</strong></div>
				</div>	
				<div style="padding:5px; border: 1px solid silver; height: 210px; overflow-y: scroll">
					<cfoutput query="getAbook">

						<div class="row">
							<div class="col-sm-4">#ucase(g_lname)#, #ucase(g_fname)#</div>
							<div class="col-sm-4">Short Term</div>
							<div class="col-sm-4">
								<!--- 
								<cfif getAbook.showin_abook IS "FALSE">
								<strong style="color:red;font-size:1.2em;">*</strong><cfelse>
								<strong style="color:green;font-size:1.2em">*</strong></cfif>
								<form method="post" action="abookedit.cfm?action=edit&id=#g_id#"> --->
									<div class="btn-group btn-group-xs" role="group" aria-label="...">
									<input type="submit" class="btn btn-xs btn-default" class="btn-newannounce" data-gid="#g_id#" value="New" />
									<input type="button" class="btn btn-xs btn-default" class="btn-history" data-gid="#g_id#" value="View All" onclick="self.form.action='guesthistory.cfm?id=#g_id#'" />
									<input type="button" class="btn btn-xs btn-danger" class="btn-del" data-gid="#g_id#" value="Remove">
									</div>
								<!--- </form> --->
							</div>
						</div>
						<hr>
					</cfoutput>
				</div>	
			</cfif>
		</cfif>
		<cfcatch><cfdump var="#cfcatch#"></cfcatch>
	</cftry>
	