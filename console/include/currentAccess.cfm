 <!-- include/currentAccess -->
 <!-- file: include/currentaccess.cfm -->
<cfparam name="begintime" default="#createDate(year(request.timezoneadjustednow),month(request.timezoneadjustednow),day(request.timezoneadjustednow))#" />
<cfparam name="endtime" default="#dateAdd('d',1,beginTime)#" />
<cfsilent>
	<cfquery name="GetSchedule" datasource="#request.dsn#">
	select g.g_id,g.r_id,g.g_lname,g.g_fname,gv.g_checkedin,<!--- v.g_checkedin, --->
		gv.v_id,gv.dashpass,gv.g_permanent,s.g_singleentry,s.visit_date as schedule_date,
		gv.g_cancelled,gv.g_initialvisit,r.r_id,r.h_id,h.c_id,gv.insertedby_staff_id,
		r.r_fname,r.r_lname,h.h_id,h.h_address,h.h_unitnumber,h.h_phone,gv.guestcompanioncount
		from guests g 
		join guestvisits gv on gv.g_id = g.g_id
		join residents r on g.r_id = r.r_id
		join homesite h on r.h_id = h.h_id
		join barcodes on gv.g_barcode = barcodes.barcode
		join schedule s on gv.v_id = s.v_id 
		<!--- LEFT JOIN visits v on v.v_id = gv.v_id	
		  (bill king - I decided to move this logic into the display area because of the conflict between 24/7 and single entry types)	 --->
		WHERE h.c_id = #session.user_community#
		AND  barcodes.DATE_CANCELLED is null
		AND gv.G_CANCELLED is null 
		
		<cfif isDefined('attributes.r_id') and VAL(attributes.r_id)>
			AND g.r_id = <cfqueryparam value="#attributes.r_id#" cfsqltype="CF_SQL_INTEGER">
		</cfif>
		
		<cfif isDefined('url.viewhour')> 
		AND (gv.g_initialvisit BETWEEN '#dateFormat(begintime)# #timeFormat(begintime,'hh:mm tt')#' AND '#dateFormat(endtime)# #timeFormat(endtime,'hh:mm tt')#')		
		
		<cfelse> 
			<!--- gv.g_initialvisit --->
			AND (s.visit_date BETWEEN '#dateFormat(begintime)# #timeFormat(begintime,'hh:mm tt')#' AND '#dateFormat(endtime)# #timeFormat(endtime,'hh:mm tt')#')
			
		</cfif>
			<!--- AND gv.g_checkedin IS NULL Taken out to move to larger scrolling results. --->	
		ORDER BY g_lname, g_fname
</cfquery>
</cfsilent>
 <cfoutput>
  <div class="panel panel-default">
      <div class="panel-heading">
          <i class="fa fa-key fa-fw"></i> <cfoutput>Current Access</cfoutput>
          <div class="pull-right">
              <div class="btn-group">
                  <button type="button" class="btn btn-default btn-xs dropdown-toggle" data-toggle="dropdown">
                      Actions
                      <span class="caret"></span>
                  </button>
                  <ul class="dropdown-menu pull-right" role="menu">
                      <li><a href="##">Action</a>
                      </li>
                      <li><a href="##">Another action</a>
                      </li>
                      <li><a href="##">Something else here</a>
                      </li>
                      <li class="divider"></li>
                      <li><a href="##">Separated link</a>
                      </li>
                  </ul>
              </div>
          </div>
      </div>
      <!-- /.panel-heading -->
      <div class="panel-body">
          <div class="row">
             <div class="table-responsive">
                  <table class="table table-bordered table-hover table-striped">
                      <thead>
                          <tr>
                              <th>#labels.Visitor#</th>
                              <th>Phone</th>
                              <th>Unit</th>
                              <th>DashPass</th>
                              <th>Action</th>
                          </tr>
                      </thead>
                      <tbody>
                      <cfoutput query="GetSchedule" group="v_id">
                          <cfquery datasource="#request.dsn#" name="qInitial">
                            SELECT g_checkedin 
                            FROM visits 
                            WHERE v_id = #getSchedule.v_id#
                          </cfquery>
                          <cfset skiprecord = false>

                          <!--- if we are looking at a single hour we need to skip those guests 
                          that may have already had a visit, otherwise only skip those record if they are single entry --->
                          <cfif qInitial.recordcount AND isDefined('url.viewhour')>
                            <cfset skiprecord = true> 
                          <cfelseif qInitial.recordcount AND val(g_singleentry)>
                            <cfset skiprecord = true> 
                          </cfif>

                          <cfif NOT skiprecord>
                          <tr>
                              <td>#r_fname# #r_lname#</td>
                              <td>#h_phone#</td>
                              <td><cfif NOT getCommunity.showunitonlyoption>#h_address#,</cfif><cfif len(getschedule.h_unitnumber)> #getschedule.h_unitnumber#</cfif></td>
                              <td>
                                <input type="button" value="print" class="btn btn-sm" onclick="ReissueAndPrintPop(#v_id#,#g_id#);">
                                <a class="btn btn-sm" href="/staff/popup/emailPass.cfm?g_id=#g_id#&amp;v_id=#v_id#">email</a>
                              </td>
                              <td><input type="button" value="Check-In" class="btn btn-sm" onclick="GuestCheckin(#v_id#,#g_id#);"></td>
                          </tr>
                         </cfif>
                       </cfoutput>
                      </tbody>
                  </table>
                  <cfif not GetSchedule.recordcount><p>No results</p></cfif>
              </div>
              <!-- /.table-responsive -->
        </div>
        <!-- /.row -->
    </div>
    <!-- /.panel-body -->
</div>
<!-- /.panel -->
                    
  </cfoutput>