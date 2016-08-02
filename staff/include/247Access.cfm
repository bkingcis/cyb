<cfquery datasource="#request.dsn#" name="Get247Schedule">
			select guests.g_id,guests.r_id,guests.g_lname,guests.g_fname,guests.g_paused,guestvisits.g_checkedin,v.g_checkedin,
			guestvisits.v_id,guestvisits.dashpass,guestvisits.g_permanent,schedule.g_singleentry,
			schedule.visit_date as schedule_date,guestvisits.insertedby_staff_id,
			guestvisits.g_cancelled,guestvisits.g_initialvisit,residents.r_id,residents.h_id,
			residents.r_fname,residents.r_lname,homesite.h_id,homesite.h_address,homesite.h_unitnumber,homesite.h_phone 
			from guests join guestvisits on guestvisits.g_id = guests.g_id
			join residents on guests.r_id = residents.r_id
			join homesite on residents.h_id = homesite.h_id
			LEFT join schedule on guestvisits.v_id = schedule.v_id 
			LEFT JOIN visits v on v.v_id = guestvisits.v_id		
			WHERE guests.c_id = #session.user_community#
			<cfif isDefined('attributes.r_id') and VAL(attributes.r_id)>
				AND guests.r_id = <cfqueryparam value="#attributes.r_id#" cfsqltype="CF_SQL_INTEGER">
			</cfif>
			AND (guestvisits.G_CANCELLED is null)
			<!--- AND  (g_initialvisit < <cfqueryparam cfsqltype="CF_SQL_DATE" value="#createDate(year(tomorrow),month(tomorrow),day(tomorrow))#">) --->
			and  g_permanent IS NOT NULL AND g_permanent <> '0'	
			AND guests.g_cancelled IS NULL
			ORDER BY g_lname, g_fname
		</cfquery>
		
		
		<cfif isdefined("attributes.g_lname") and len(attributes.g_lname)>
			<cfquery dbtype="query" name="Get247Schedule">
				select * from Get247Schedule
				where  upper(g_lname) = <cfqueryparam value="#ucase(attributes.g_lname)#" cfsqltype="CF_SQL_VARCHAR">
			</cfquery>
		</cfif>
		<cfif isdefined("attributes.g_fname") and len(attributes.g_fname)>
			<cfquery dbtype="query" name="Get247Schedule">
				select * from Get247Schedule
				where  upper(g_fname) = <cfqueryparam value="#ucase(attributes.g_fname)#" cfsqltype="CF_SQL_VARCHAR">
			</cfquery>
		</cfif>
		<cfif isdefined("attributes.r_lname") and len(attributes.r_lname)>
			<cfquery dbtype="query" name="Get247Schedule">
				select * from Get247Schedule
				where  upper(r_lname) = <cfqueryparam value="#ucase(attributes.r_lname)#" cfsqltype="CF_SQL_VARCHAR">
			</cfquery>
		</cfif>
		<cfif isdefined("attributes.r_fname") and len(attributes.r_fname)>
			<cfquery dbtype="query" name="Get247Schedule">
				select * from Get247Schedule
				where  upper(r_fname) = <cfqueryparam value="#ucase(attributes.r_fname)#" cfsqltype="CF_SQL_VARCHAR">
			</cfquery>
		</cfif>
		
		<cfparam name="request.hidesubtitle" default="false">
		<cfif Get247Schedule.RecordCount>	
			<cfif NOT request.hidesubtitle>
			<h2 style="text-transform: uppercase;"><cfoutput>#labels.permanent_visitor# #labels.visitor#S</cfoutput></h2>
				<div class="homePageDatagrid">
				<table width="100%" cellpadding="1" cellspacing="1" border="0" class="fixed_headers">
			<cfelse>
				<div class="modalDatagrid">
				<table cellpadding="1" cellspacing="1" border="0" align="center">
			</cfif>
			<thead>
				<tr>
					<cfoutput>
					<th class="datatableHdr">#labels.visitor# name<!--- /Company Name ---> (L/F)</th>
					<th class="datatableHdr">#labels.resident# Name</th>
					<th class="datatableHdr">Phone</th>
					<th class="datatableHdr"><cfif NOT getCommunity.showunitonlyoption>Address<cfelse>Unit</cfif></th>
					<th class="datatableHdr">Type</th>
					<!--- <th class="datatableHdr">Details</th>
					 --->
					<cfif getCommunity.dashpass><th class="datatableHdr dp">DashPass</th></cfif>
					<th class="datatableHdr" align="center">Action</th>
					</cfoutput>
				</tr>
			</thead>
			<tbody>
			<style>
			.paused {background-color:#fe6 !important;}
			</style>
			<cfoutput query="Get247Schedule" group="v_id">
				<cfquery datasource="#request.dsn#" name="qInitial">
					SELECT g_checkedin 
					FROM visits 
					WHERE v_id = <cfqueryparam value="#Get247Schedule.v_id#" cfsqltype="CF_SQL_INTEGER">
				</cfquery>
			<tr class="notcheckedinRow<cfif g_paused> paused</cfif>" 
						onmouseover="$(this).toggleClass('checkedinRowHover',true);$(this).toggleClass('notcheckedinRow',false);" 
						onmouseout="$(this).toggleClass('notcheckedinRow',true);$(this).toggleClass('checkedinRowHover',false);">
					
				<td style="font-size:10px;">&nbsp;&nbsp;<a href="javascript:self.location='/staff/popup/permguest_options.cfm?g_id=#g_id#&v_id=#v_id#';" class="extlink">#ucase(g_lname)#, #ucase(g_fname)#</a><cfif insertedby_staff_id>*</cfif></td>
					<td align="center">#ucase(r_lname)#, #ucase(r_fname)# </td>
				<td align="center">#h_phone#</td>
				<td align="center"><cfif NOT getCommunity.showunitonlyoption>#h_address#</cfif><cfif len(h_unitnumber)><cfif NOT getCommunity.showunitonlyoption>, Unit </cfif>#h_unitnumber#</cfif></td>
				<td align="center">24/7</td>
				<cfif getCommunity.dashpass>
				<td class="dp"><div style="float:left;width:86%;">
				<!--- <cfif qInitial.recordcount or Get247Schedule.dashpass is 'email'> --->
				<input type="button" value="print" class="action-btn" onclick="ReissueAndPrintPop(#v_id#,#g_id#);"><!--- ReprintAndPrintPop --->
				<!--- <input type="submit" value="email" style="font-size:9px;" onclick="EmailPass(#v_id#,#g_id#);"><--- ReissueAndPrintPop --->
								<a href="/staff/popup/emailPass.cfm?g_id=#g_id#&v_id=#v_id#" class="extlink action-btn">email</a>
					<cfif getCommunity.checkoutoption>
					<input type="submit" value="check-out" class="action-btn" onclick="GuestCheckout(#v_id#,#g_id#);">
					</cfif>
				<!--- <cfelse>
				<input type="submit" value="print" class="action-btn" onclick="ReissueAndPrintPop(#v_id#,#g_id#);">	
				</cfif>		--->		
				</div><div style="float:right;width:4%;padding-right:3px;padding-top:4px;">#ucase(left(dashpass,1))#&nbsp;</div>
				</td>
				</cfif>
				<td align="center">
					<cfif g_paused>
					<input type="button" value=" Paused " class="action-btn" onclick="self.location='/staff/popup/permguest_options.cfm?g_id=#g_id#&v_id=#v_id#';">
					<cfelse>
					<input type="button" value="Check-In" class="action-btn" onclick="GuestCheckin(#v_id#,#g_id#);">
					</cfif>
					<cfif structKeyExists(request,'showadvancedoptions') and request.showadvancedoptions>
						<input type="button" value="Recorded Visits" class="action-btn" onclick="self.location='/staff/popup/history.cfm?g_id=#g_id#'">
						<input type="button" value="Delete" style="color:red;" class="action-btn" onclick="self.location='/staff/deletecheck3.cfm?g_id=#g_id#&v_id=#v_id#'"">					
					</cfif>
				</td>
				</tr>	
			</cfoutput>
			</tbody>
		</table>
		</div>
		</cfif><!--- end recordcount IF block --->