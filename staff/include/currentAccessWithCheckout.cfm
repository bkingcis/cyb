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


	<script language="JavaScript">
		function GuestCheckin(v_id,g_id,recordPlate,checkin) {
			if(!checkin)var checkin = 0
			jThickboxNewLink="lpform.cfm?v_id="+v_id+"&g_id="+g_id+"&checkin="+checkin+"&height=500&width=700";
			<cfif getCommunity.recordLicensePlate>
				//tb_open_new(jThickboxNewLink);
				if (recordPlate){
				jThickboxNewLink = jThickboxNewLink + '&fancyCheckin=1';
				tb_show('Record License Plate',jThickboxNewLink,null);
				}
				else {
					//self.location=jThickboxNewLink;	
					 $.fancybox({
					'height':580,
					'width':680,
					'autoDimensions':false,
					'href':jThickboxNewLink,
					'type':'iframe'
				});	
				}
			<cfelse>
				 $.fancybox({
					'height':580,
					'width':680,
					'autoDimensions':false,
					'href':'guestdetails.cfm?v_id='+v_id+'&g_id='+g_id+'&checkin='+checkin,
					'type':'iframe'
				});			
			</cfif>
		}
		function GuestCheckout(v_id,g_id) {
			 $.fancybox({
					'height':180,
					'width':680,
					'autoDimensions':false,
					'href':'guestdetails.cfm?v_id='+v_id+'&g_id='+g_id+'&checkout=1',
					'type':'iframe'
				});
		}	
		function PrintPop(v_id,g_id) {
			printable=window.open("reprintDP.cfm?v_id="+v_id+"&g_id="+g_id,"printable","status=0,toolbar=0,width=825,height=700");
			<cfif getCommunity.recordLicensePlate><!--- should only run for initial print/visit --->
			GuestCheckin(v_id,g_id,1,0);
			</cfif>
		}
		function ReprintAndPrintPop(v_id,g_id) {
			printable=window.open("reprintDP.cfm?v_id="+v_id+"&g_id="+g_id,"printable","status=0,toolbar=0,width=825,height=700");
			<cfif getCommunity.recordLicensePlate and val(getCommunity.recordlicenseplateonallvisits)>
			GuestCheckin(v_id,g_id,1,0);
			</cfif>
		}
		function ReissueAndPrintPop(v_id,g_id) {
			printable=window.open("reissueDP.cfm?v_id="+v_id+"&g_id="+g_id,"printable","status=0,toolbar=0,width=825,height=700");
			<cfif getCommunity.recordLicensePlate and val(getCommunity.recordlicenseplateonallvisits)>
			GuestCheckin(v_id,g_id,1,0);
			</cfif>
		}
		function checkInAndPrintPop(vID) {
			printable=window.open("reprintDP.cfm?vid="+vID,"printable","status=0,toolbar=0,width=800,height=600");
			<cfif getCommunity.recordLicensePlate>
			GuestCheckin(v_id,g_id,1);
			</cfif>
		}
		function fancyCheckin(dashpass,recordPlate) {
			jThickboxNewLink="guestdetails.cfm?fancyCheckin=1&barcode="+dashpass+"&checkin=1&height=500&width=700";
			if (recordPlate){
				tb_show('Record License Plate',jThickboxNewLink,null);
			}
			else {
					//self.location=jThickboxNewLink;	
					 $.fancybox({
					'height':580,
					'width':680,
					'autoDimensions':false,
					'href':jThickboxNewLink,
					'type':'iframe'
				});	
			}
		}
	</script><br />
	
	<cfif GetSchedule.RecordCount> 
	<cfset daystart = createdate(year(request.timezoneadjustednow),month(request.timezoneadjustednow),day(request.timezoneadjustednow))>	
		<h2>AUTHORIZED VISITORS<cfif datecompare(begintime,daystart) gt 0><br>
			<cfif hour(begintime) gt 12>
				<cfset theHour = hour(begintime)-12><cfset timeTT = 'pm'>
			<cfelse>
				<cfset theHour = hour(begintime)><cfset timeTT = 'am'>
			</cfif>
			<cfif val(theHour)><cfoutput>#theHour#:00#timeTT# - #theHour#:59#timeTT#</cfoutput></cfif>
		</cfif></h2>
	<!---<table width="98%" cellpadding="1" cellspacing="1" border="0" align="center">
		<tr>
		
		<td align="center"><strong style="font-weight:bold;"></strong><!--- <br><cfoutput><span style="font-size:12px;">#TimeFormat(BEGINTIME,"h:mm:ss tt")# - #TimeFormat(ENDTIME,"h:mm:ss tt")#</span></cfoutput> ---></td>
		</tr>
	</table>
	<cfoutput>
 	Begintime: #dateFormat(begintime)# #timeformat(begintime)#<br>
	
	Endtime: #dateFormat(endtime)# #timeformat(endtime)#</cfoutput> --->
	<div class="homePageDatagrid">
		<!--- <em><cfoutput>#GetSchedule.recordcount# Records</cfoutput></em> --->
		<table width="100%" cellpadding="1" cellspacing="1" border="0" align="center">
		<tr class="datatableHdr">
		<td  align="center">Visitor Name (L/F)</td>
		<td  align="center">Resident Name</td>
		<td  align="center">Phone</td>
		<td  align="center"><cfif NOT getCommunity.showunitonlyoption>Address<cfelse>Unit</cfif></td>
		<td  align="center">Type</td>
		<td  align="center">Est Arrival</td>
		<cfif getCommunity.dashpass ><td align="center">DashPass</td></cfif>
		<td  align="center">Action</td>
		<!--- <td  align="center">Details</td>
		 ---></tr>	
			<cfoutput query="GetSchedule" group="v_id">
				<cfquery datasource="#datasource#" name="qInitial">
					SELECT g_checkedin, g_checkedout
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
				<td style="font-size:10px;"><div style="float:left;width:89%;padding:0px">&nbsp;&nbsp;<a href="/staff/guestdetails.cfm?g_id=#g_id#&v_id=#v_id#" class="extlink">#ucase(g_lname)#, #ucase(g_fname)#</a><cfif insertedby_staff_id>*</cfif></div><cfif guestcompanioncount><div style="float:right;width=10%;text-align:right;padding:0px;">+#guestcompanioncount#&nbsp;</div></cfif></td>
				<td style="font-size:10px;" align="center">#ucase(r_lname)#, #ucase(r_fname)# </td>
				<td style="font-size:10px;" align="center">#h_phone#</td>
				<td style="font-size:10px;" align="center"><cfif NOT getCommunity.showunitonlyoption>#h_address#,<cfelse>Unit</cfif><cfif len(getschedule.h_unitnumber)> #getschedule.h_unitnumber#</cfif></td>
				<td style="font-size:10px;" align="center">
				<cfif g_permanent is 1>24/7
					<cfelseif val(g_singleentry)>
						<strong style="color:red">single entry</strong>
					<cfelse>
						<!--- NEED TO FIND OUT HOW MANY SCHEDULED DAYS IN ORIGINAL ANNOUNCEMENT HERE TO SHOW TYPE --->
						<cfquery datasource="#datasource#" name="qScheduleCount">
							SELECT count(v_id) as numberofdays
							from schedule where v_id = #getSchedule.v_id#
						</cfquery>
						<cfif qScheduleCount.numberofdays lt 2>one full day<cfelse>multi-day</cfif>
					</cfif></td>
					<td style="font-size:10px;" align="center"><cfif qInitial.recordcount> + <cfelse><cfif dateCompare(createDate(year(g_initialvisit),month(g_initialvisit),day(g_initialvisit)),createdate(year(request.timezoneadjustednow),month(request.timezoneadjustednow),day(request.timezoneadjustednow))) lt 0> - <cfelse>#TimeFormat(g_initialvisit,"h:mm tt")#</cfif></cfif></td>
					<cfif getCommunity.dashpass >
					<td style="font-size:10px;" align="left" nowrap="true" width="100">
						<cfif dashpass is "email">
							<div style="float:left;width:82%;">
							<cfif NOT val(v_id)>
							bad record
							<cfelse>
							<input type="submit" value="print" style="font-size:9px;" onclick="ReprintAndPrintPop(#v_id#,#g_id#);">
							<input type="submit" value="email" style="font-size:9px;" onclick="EmailPass(#v_id#,#g_id#);">
							</cfif></div>						
							<div style="float:right;width:4%;padding-right:3px;padding-top:4px;">E&nbsp;</div>	
						<cfelse>
							<div style="float:left;width:82%">
							<cfif NOT qInitial.recordcount>
							<input type="submit" value="print" style="font-size:9px;" onclick="ReissueAndPrintPop(#v_id#,#g_id#);">
							<cfelse>
							<input type="submit" value="print" style="font-size:9px;" onclick="ReissueAndPrintPop(#v_id#,#g_id#);">
							<!--- <input type="submit" value="reissue" style="font-size:9px;" onclick="ReissueAndPrintPop(#v_id#,#g_id#);">--->
							</cfif>
							</div>
							<div style="float:right;width:4%;padding-right:3px;padding-top:4px;">G&nbsp;</div>						
						</cfif>					
					</td>
					</cfif>
					<td align="center" width="75">
						<input type="button" value="Check-In" style="font-size:9px;" onclick="GuestCheckin(#v_id#,#g_id#);">
						<cfif qInitial.recordcount><input type="submit" value="checkout" style="font-size:9px;" onclick="GuestCheckout(#v_id#,#g_id#);"></cfif>
					</td>
				</tr>
				
			</cfif>
			</cfoutput>
		</table>
	</div></cfif>