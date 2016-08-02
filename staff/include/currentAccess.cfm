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
<script>
	function GuestCheckin(v_id,g_id,recordPlate,checkin) {
			if(!checkin)var checkin = 0
			jThickboxNewLink="lpform.cfm?v_id="+v_id+"&g_id="+g_id+"&checkin="+checkin;
			<cfif getCommunity.recordLicensePlate>
				$.ajax({
							type        : "POST",
							cache       : false,
							url         : "guestdetails.cfm?checkin=1",
							data        : $(this).serializeArray(),
							success: function(data) {
								$.fancybox({
									'content' : data,
									'height':300,
									'width':460,
									'autoDimensions':false
								});
							}
						});
				
				//tb_open_new(jThickboxNewLink);
				if (recordPlate){
				jThickboxNewLink = jThickboxNewLink + '&fancyCheckin=1';
				tb_show('Record License Plate',jThickboxNewLink,null);
				}
				else self.location=jThickboxNewLink;	
			<cfelse>
				$.ajax({
					type        : "GET",
					cache       : false,
					url         : "guestdetails.cfm?v_id="+v_id+"&g_id="+g_id+"&checkin=1",
					success: function(data) {
						$.fancybox({
							'content' : data,
							'height':200,
							'width':460,
							'autoDimensions':false
						});
					}
				});			
			</cfif>
		}
		function PrintPop(v_id,g_id) {
			printable=window.open("/staff/reprintDP.cfm?v_id="+v_id+"&g_id="+g_id,"printable","status=0,toolbar=0,width=825,height=700");
			<cfif getCommunity.recordLicensePlate><!--- should only run for initial print/visit --->
			GuestCheckin(v_id,g_id,1,0);
			</cfif>
		}
		function ReprintAndPrintPop(v_id,g_id) {
			printable=window.open("/staff/reprintDP.cfm?v_id="+v_id+"&g_id="+g_id,"printable","status=0,toolbar=0,width=825,height=700");
			<cfif getCommunity.recordLicensePlate and val(getCommunity.recordlicenseplateonallvisits)>
			GuestCheckin(v_id,g_id,1,0);
			</cfif>
		}
		function ReissueAndPrintPop(v_id,g_id) {
			printable=window.open("/staff/reissueDP.cfm?v_id="+v_id+"&g_id="+g_id,"printable","status=0,toolbar=0,width=825,height=700");
			<cfif getCommunity.recordLicensePlate and val(getCommunity.recordlicenseplateonallvisits)>
			GuestCheckin(v_id,g_id,1,0);
			</cfif>
		}
		function checkInAndPrintPop(vID) {
			printable=window.open("/staff/reprintDP.cfm?vid="+vID,"printable","status=0,toolbar=0,width=800,height=600");
			<cfif getCommunity.recordLicensePlate>
			GuestCheckin(v_id,g_id,1);
			</cfif>
		}
		function EmailPass(vID) {
			jThickboxNewLink="/staff/popup/emailPass.cfm?v_id="+vID+"&checkin=0&height=500&width=700";
			$.ajax({
					type        : "GET",
					cache       : false,
					url         : jThickboxNewLink,
					success: function(data) {
						$.fancybox({
							'content' : data,
							'height':200,
							'width':460,
							'autoDimensions':false
						});
					}
				});	
			//tb_show('Email DashPass',jThickboxNewLink,null);
		}
		function fancyCheckin(dashpass,recordPlate) {
			jThickboxNewLink="guestdetails.cfm?fancyCheckin=1&barcode="+dashpass+"&checkin=1&height=500&width=700";
			/*if (recordPlate){
				tb_show('Record License Plate',jThickboxNewLink,null);
			}
			else */
			self.location=jThickboxNewLink;			
		}	
	
</script>

<cfif isdefined("attributes.g_lname") and len(attributes.g_lname)>
	<cfquery dbtype="query" name="GetSchedule">
		select * from GetSchedule
		where  upper(g_lname) = <cfqueryparam value="#ucase(attributes.g_lname)#" cfsqltype="CF_SQL_VARCHAR">
	</cfquery>
</cfif>
<cfif isdefined("attributes.g_fname") and len(attributes.g_fname)>
	<cfquery dbtype="query" name="GetSchedule">
		select * from GetSchedule
		where  upper(g_fname) = <cfqueryparam value="#ucase(attributes.g_fname)#" cfsqltype="CF_SQL_VARCHAR">
	</cfquery>
</cfif>
<cfif isdefined("attributes.r_lname") and len(attributes.r_lname)>
	<cfquery dbtype="query" name="GetSchedule">
		select * from GetSchedule
		where  upper(r_lname) = <cfqueryparam value="#ucase(attributes.r_lname)#" cfsqltype="CF_SQL_VARCHAR">
	</cfquery>
</cfif>
<cfif isdefined("attributes.r_fname") and len(attributes.r_fname)>
	<cfquery dbtype="query" name="GetSchedule">
		select * from GetSchedule
		where  upper(r_fname) = <cfqueryparam value="#ucase(attributes.r_fname)#" cfsqltype="CF_SQL_VARCHAR">
	</cfquery>
</cfif>

<cfif GetSchedule.RecordCount>
	<cfset daystart = createdate(year(request.timezoneadjustednow),month(request.timezoneadjustednow),day(request.timezoneadjustednow))>
	<h2 style="text-transform: uppercase;">
	AUTHORIZED <cfoutput>#labels.visitor#S</cfoutput>
		<cfif datecompare(begintime,daystart) gt 0><br>
			<cfif hour(begintime) gt 12>
				<cfset theHour = hour(begintime)-12><cfset timeTT = 'pm'>
			<cfelse>
				<cfset theHour = hour(begintime)><cfset timeTT = 'am'>
			</cfif>
			<cfif val(theHour)><cfoutput>#theHour#:00#timeTT# - #theHour#:59#timeTT#</cfoutput></cfif>
		</cfif>
	</h2>	
	<!---<table width="98%" cellpadding="1" cellspacing="1" border="0" align="center">
		<tr>
		<td align="center"><strong style="font-weight:bold;"> </strong><!--- <br><cfoutput><span style="font-size:12px;">#TimeFormat(BEGINTIME,"h:mm:ss tt")# - #TimeFormat(ENDTIME,"h:mm:ss tt")#</span></cfoutput> ---></td>
		</tr>
	</table>
	<cfoutput>
 	Begintime: #dateFormat(begintime)# #timeformat(begintime)#<br>
	
	Endtime: #dateFormat(endtime)# #timeformat(endtime)#</cfoutput> --->
	<div class="homePageDatagrid">	<!--- <em><cfoutput>#GetSchedule.recordcount# Records</cfoutput></em> --->
		<table width="100%" cellpadding="1" cellspacing="1" border="0" align="center" class="fixed_headers">
			<thead>
				<tr>
				<cfoutput>
					<th class="datatableHdr">#labels.visitor# Name (L/F)</th>
					<th class="datatableHdr">#labels.resident# name</th>
					<th class="datatableHdr">Phone</th>
					<th class="datatableHdr"><cfif NOT getCommunity.showunitonlyoption>Address<cfelse>Unit</cfif></th>
					<th class="datatableHdr">Type</th>
					<th class="datatableHdr">Arrival</th>
					<cfif getCommunity.dashpass><th class="datatableHdr dp">DashPass</th></cfif>
					<th class="datatableHdr">Action</th>
				<!--- <th  align="center">Details</th> --->
			 	</cfoutput>
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
				<tr class="notcheckedinRow" onmouseover="this.className='checkedinRowHover';" onmouseout="this.className='notcheckedinRow';">
				<td><a href="/staff/guestdetails.cfm?g_id=#g_id#&v_id=#v_id#" class="extlink">#ucase(g_lname)#<cfif len(g_lname) and len(g_fname)>, </cfif>#ucase(g_fname)#</a><cfif insertedby_staff_id>*</cfif><cfif val(getCommunity.guestCompanionoption) AND guestcompanioncount></div><div style="float:right;width=10%;text-align:right;margin:0px;padding:0px;">+#guestcompanioncount#&nbsp;</div></cfif></td>
				<td>#ucase(r_lname)#, #ucase(r_fname)# </td>
				<td align="center">#h_phone#</td>
				<td align="center"><cfif NOT getCommunity.showunitonlyoption>#h_address#,</cfif><cfif len(getschedule.h_unitnumber)> #getschedule.h_unitnumber#</cfif></td>
				<td align="center">
					<cfif g_permanent is 1>24/7
					<cfelseif val(g_singleentry)>
						<strong style="color:red">single entry</strong>
					<cfelse>
						<!--- NEED TO FIND OUT HOW MANY SCHEDULED DAYS IN ORIGINAL ANNOUNCEMENT HERE TO SHOW TYPE --->
						<cfquery datasource="#request.dsn#" name="qScheduleCount">
							SELECT count(v_id) as numberofdays
							from schedule where v_id = #getSchedule.v_id#
						</cfquery>
						<cfif qScheduleCount.numberofdays lt 2>one full day<cfelse>multi-day</cfif>
					</cfif>
				</td>
				<td align="center"><cfif qInitial.recordcount> + <cfelse><cfif dateCompare(createDate(year(g_initialvisit),month(g_initialvisit),day(g_initialvisit)),createdate(year(request.timezoneadjustednow),month(request.timezoneadjustednow),day(request.timezoneadjustednow))) lt 0> - <cfelse>#TimeFormat(g_initialvisit,"h:mm tt")#</cfif></cfif></td>
				<cfif getCommunity.dashpass >
					<td class="dp">
						<!--- <cfif dashpass is "email"> --->
							<div style="float:left;margin:0px;padding:0px;">
							<cfif NOT val(v_id)>
								bad record
							<cfelse>
								<input type="button" value="print" class="action-btn" onclick="ReissueAndPrintPop(#v_id#,#g_id#);"><!--- ReprintAndPrintPop 
								<input type="submit" value="email" class="action-btn" onclick="EmailPass(#v_id#,#g_id#);">--->
								<a href="/staff/popup/emailPass.cfm?g_id=#g_id#&v_id=#v_id#" class="extlink action-btn">email</a>
							</cfif></div>						
							<div style="display:inline-block;float: right;"><cfif dashpass is 'email'>E<cfelse>G</cfif>&nbsp;</div>	
						<!--- <cfelse>
							<div style="float:left;margin:0px;padding:0px;">
							<cfif NOT qInitial.recordcount>
								<input type="button" value="print" class="action-btn" onclick="PrintPop(#v_id#,#g_id#);">
							<cfelse>
								<input type="button" value="print" class="action-btn" onclick="ReissueAndPrintPop(#v_id#,#g_id#);"><!--- ReprintAndPrintPop --->
								<!--- <input type="submit" value="reissue" class="action-btn" onclick="ReissueAndPrintPop(#v_id#,#g_id#);"> --->
							</cfif>
							</div>
							<div style="float:right;width:5px;padding-right:2px;padding-top:4px;">G&nbsp;</div>						
						</cfif>		--->			
					</td>
				</cfif>
				<td align="center">
					<input type="button" value="Check-In" class="action-btn" onclick="GuestCheckin(#v_id#,#g_id#);">
				</td>
				</tr>
			</cfif>
			</cfoutput>
			</tbody>
		</table>
	</div>
</cfif>