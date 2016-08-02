<cfsilent>
<cfset nextday = createDate(year(dateAdd("d",1,BEGINTIME)),month(dateAdd("d",1,BEGINTIME)),day(dateAdd("d",1,BEGINTIME)))>

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
		<cfif isDefined('form.r_id') and val(form.r_id)>AND (r.r_id = #form.r_id#)</cfif>
			
		<!--- LEFT JOIN visits v on v.v_id = gv.v_id	
		  (bill king - I decided to move this logic into the display area because of the conflict between 24/7 and single entry types)	 --->
		WHERE h.c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(session.user_community)#" />
		AND  barcodes.DATE_CANCELLED is null
		AND gv.G_CANCELLED is null 
		
		<cfif isDefined('url.viewhour')> 
		AND (gv.g_initialvisit BETWEEN '#dateFormat(begintime)# #timeFormat(begintime,'hh:mm tt')#' AND '#dateFormat(endtime)# #timeFormat(endtime,'hh:mm tt')#')		 
		<cfelse> 
			<!--- s.visit_date --->
			AND (gv.g_initialvisit BETWEEN '#dateFormat(begintime)# #timeFormat(begintime,'hh:mm tt')#' AND '#dateFormat(endtime)# #timeFormat(endtime,'hh:mm tt')#')
			
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
</cfsilent>
<br />
	<script language="JavaScript">
		function GuestCheckin(v_id,g_id) {
			//self.location="guestdetails.cfm?v_id="+v_id+"&g_id="+g_id+"&checkin=1";
			linkTo="guestdetails.cfm?v_id="+v_id+"&g_id="+g_id+"&checkin=1";
			//linkTo="guestcheckin.cfm?v_id="+v_id+"&g_id="+g_id;
			$.fancybox({
		                'href' : linkTo,
						'type' : 'iframe',
						'margin' : '0',
						'height': '45%',
						'width' : '40%',
						'showCloseButton' : false,
						'onComplete' : function(){
							parent.$.fancybox.close();
						}
		            });
		}	
		function GuestCheckout(v_id,g_id) {
			//self.location="guestdetails.cfm?v_id="+v_id+"&g_id="+g_id+"&checkout=1";
			linkTo="guestdetails.cfm?v_id="+v_id+"&g_id="+g_id+"&checkout=1";
			$.fancybox({
		                'href' : linkTo,
						'type' : 'iframe',
						'margin' : '0',
						'height': '45%',
						'width' : '40%',
						'showCloseButton' : false,
						'onComplete' : function(){
							parent.$.fancybox.close();
						}
		            });
		}		
		function ReprintAndPrintPop(v_id,g_id) {
			printable=window.open("reprintDP.cfm?v_id="+v_id+"&g_id="+g_id,"printable","status=0,toolbar=0,width=825,height=700");
		}
		function ReissueAndPrintPop(v_id,g_id) {
			printable=window.open("reissueDP.cfm?v_id="+v_id+"&g_id="+g_id,"printable","status=0,toolbar=0,width=825,height=700");
		}
		function checkInAndPrintPop(vID) {
			printable=window.open("reprintDP.cfm?vid="+vID,"printable","status=0,toolbar=0,width=800,height=600");
		}	
	</script>
	
	<cfif GetSchedule.recordcount><cfset daystart = createdate(year(request.timezoneadjustednow),month(request.timezoneadjustednow),day(request.timezoneadjustednow))>
		<h2><cfif datecompare(begintime,daystart) gt 0>FUTURE </cfif>AUTHORIZED GUEST(S)</h2>
		<!--- <cfoutput>#dateFormat(BEGINTIME,"m/d/yyy")# #timeFormat(BEGINTIME,"h:mm tt")# - #dateFormat(ENDTIME,"m/d/yyy")# #timeformat(ENDTIME,"h:mm tt")#</cfoutput> --->
	<!--- <table width="100%" cellpadding="1" cellspacing="2" border="0" align="center">
		<tr>
		
		<td align="center"><strong style="font-weight:bold;"></strong><br><!--- <cfoutput><span style="font-size:12px;">#TimeFormat(BEGINTIME,"h:mm:ss tt")# - #TimeFormat(ENDTIME,"h:mm:ss tt")#</span></cfoutput> ---></td>
		</tr>
	</table> --->
	<div class="homePageDatagrid">
	<table width="100%" cellpadding="1" cellspacing="1" border="0">
		<tr class="datatableHdr">
			<td align="center">Guest Name (L/F)</td>
			<td align="center">Resident Name</td>
			<td align="center">Phone</td>
			<td align="center"><cfif NOT getCommunity.showunitonlyoption>Address<cfelse>Unit</cfif></td>
			<td align="center">Type</td>
			<td align="center">Arrival</td>
			<td align="center">Action</td>
		</tr>	
				<cfset recordsshown = 0>
	<cfoutput query="GetSchedule" group="v_id">
			<cfquery datasource="#datasource#" name="qInitial">
				SELECT g_checkedin, g_checkedout
				FROM visits 
				WHERE v_id = #getSchedule.v_id#
			</cfquery>
			<cfset checkedin = false>
				<cfif qInitial.recordcount AND val(g_singleentry)>
					<cfset checkedin = true> 
				</cfif>
				<cfif  val(g_singleentry) AND qInitial.recordcount AND val(qInitial.g_checkedout)>
					<cfset singleentrycheckedout = true> 
				<cfelse>
					<cfset singleentrycheckedout = false>
				</cfif>
				<cfif NOT singleentrycheckedout>
				<tr class="notcheckedinRow" onmouseover="this.className='checkedinRowHover';" onmouseout="this.className='notcheckedinRow';">
					<td style="font-size:10px;"><div style="float:left;width:87%">&nbsp;<a href="/staff/guestdetails.cfm?g_id=#g_id#&v_id=#v_id#" class="extlink">#ucase(g_lname)#, #ucase(g_fname)#</a><cfif insertedby_staff_id>*</cfif></div><cfif guestcompanioncount><div style="float:right;width=10%;text-align:right;">+#guestcompanioncount#&nbsp;</div></cfif></td>
					<td style="font-size:10px;" align="center">#ucase(r_lname)#, #ucase(r_fname)#</td>
					<td style="font-size:10px;" align="center">#h_phone#</td>
					<td style="font-size:10px;" align="center"><cfif NOT getCommunity.showunitonlyoption>#h_address#,<cfelse>Unit</cfif><cfif len(getschedule.h_unitnumber)> #getschedule.h_unitnumber#</cfif></td>
					<td style="font-size:10px;" align="center">
					<cfif g_permanent is 1>24/7
					<cfelseif val(g_singleentry)><strong style="color:red">single entry</strong>
					<cfelse>
						<!--- NEED TO FIND OUT HOW MANY SCHEDULED DAYS IN ORIGINAL ANNOUNCEMENT HERE TO SHOW TYPE --->
						<cfquery datasource="#datasource#" name="qScheduleCount">
							SELECT count(v_id) as numberofdays
							from schedule where v_id = #getSchedule.v_id#
						</cfquery>
						<cfif qScheduleCount.numberofdays lt 2>one full day<cfelse>multi-day</cfif>
					</cfif></td>
					<td style="font-size:10px;" align="center"><cfif qInitial.recordcount> + <cfelse><cfif dateCompare(createDate(year(g_initialvisit),month(g_initialvisit),day(g_initialvisit)),createdate(year(request.timezoneadjustednow),month(request.timezoneadjustednow),day(request.timezoneadjustednow))) lt 0> - <cfelse>#TimeFormat(g_initialvisit,"h:mm tt")#</cfif></cfif></td>
					<td style="font-size:10px;" align="center">
					<cfif val(g_singleentry)>	
						<cfif NOT checkedin>
							<input type="submit" value="check-in" style="font-size:9px;" onclick="GuestCheckin(#v_id#,#g_id#);">
						<cfelse>
							<input type="submit" value="check-out" style="font-size:9px;" onclick="GuestCheckout(#v_id#,#g_id#);">
						</cfif>
					<cfelse>
						<input type="submit" value="check-in" style="font-size:9px;" onclick="GuestCheckin(#v_id#,#g_id#);">&nbsp;
						<input type="submit" value="check-out" style="font-size:9px;" onclick="GuestCheckout(#v_id#,#g_id#);">
					</cfif>
					
					</td>
				</tr>
				<cfset recordsshown = recordsshown + 1>
				</cfif>
			</cfoutput>
			</table>
		</div>
	</cfif>
	<cfif NOT isDefined('url.viewhour')>
	<cfif val(getCommunity.permanantguests)>
	<cfquery datasource="#datasource#" name="Get247Schedule">
	select guests.g_id,guests.r_id,guests.g_lname,guests.g_fname,guestvisits.g_checkedin,v.g_checkedin,
			guestvisits.v_id,guestvisits.dashpass,guestvisits.g_permanent,schedule.g_singleentry,
			schedule.visit_date as schedule_date,
			guestvisits.g_cancelled,guestvisits.g_initialvisit,residents.r_id,residents.h_id,
			residents.r_fname,residents.r_lname,homesite.h_id,homesite.h_address,homesite.h_unitnumber,homesite.h_phone 
			from guests join guestvisits on guestvisits.g_id = guests.g_id
			join residents on guests.r_id = residents.r_id
			join homesite on residents.h_id = homesite.h_id
			LEFT join schedule on guestvisits.v_id = schedule.v_id 
			LEFT JOIN visits v on v.v_id = guestvisits.v_id		
			WHERE guests.c_id = #session.user_community#
			AND (guestvisits.G_CANCELLED is null)
			<cfif isDefined('form.r_id') and val(form.r_id)>AND (residents.r_id = #form.r_id#)</cfif>
			<!--- AND  (g_initialvisit < <cfqueryparam cfsqltype="CF_SQL_DATE" value="#createDate(year(tomorrow),month(tomorrow),day(tomorrow))#">) --->
			and  g_permanent IS NOT NULL AND g_permanent <> '0'			
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
	
	
	<cfif Get247Schedule.RecordCount><h2>24/7 ACCESS</h2>
		<!--- <table width="100%" cellpadding="1" cellspacing="2" border="0" align="center">
		<tr>
		<td align="center"><strong style="font-weight:bold;"></strong><br><!--- <cfoutput><span style="font-size:12px;">#TimeFormat(BEGINTIME,"h:mm:ss tt")# - #TimeFormat(ENDTIME,"h:mm:ss tt")#</span></cfoutput> ---></td>
		</tr>
	</table> --->
		<div class="homePageDatagrid">
		<table width="100%" cellpadding="1" cellspacing="1" border="0" align="center">
			<tr>
			<td class="datatableHdr" align="center">Guest name<!--- /Company Name ---> (L/F)</td>
			<td class="datatableHdr" align="center">Resident Name</td>
			<td class="datatableHdr" align="center">Phone</td>
			<td class="datatableHdr" align="center"><cfif NOT getCommunity.showunitonlyoption>Address<cfelse>Unit</cfif></td>
			<td class="datatableHdr" align="center" width="60">Type</td>
			<td class="datatableHdr" align="center">Action</td>
			<!--- <td style="font-weight:bold;background-color:#c0c0c0;color:Black;" align="center">Details</td>
			 ---></tr>
			<tbody>
			<cfoutput query="Get247Schedule" group="v_id">
				<!--- <cfif len(trim(g_checkedin))>
					<tr class="checkedinRow" onmouseover="this.className='checkedinRowHover';" onmouseout="this.className='checkedinRow';">
				<cfelse> --->
					<tr class="notcheckedinRow" onmouseover="this.className='checkedinRowHover';" onmouseout="this.className='notcheckedinRow';">
				<!--- </cfif> --->
				<td style="font-size:10px;">&nbsp;&nbsp;<a href="/staff/guestdetails.cfm?g_id=#g_id#&v_id=#v_id#" class="extlink">#ucase(g_lname)#, #ucase(g_fname)#</a></td>
					<td align="center">#ucase(r_lname)#, #ucase(r_fname)# </td>
				<td style="font-size:10px;" align="center">#h_phone#</td>
				<td style="font-size:10px;" align="center"><cfif NOT getCommunity.showunitonlyoption>#h_address#</cfif><cfif len(h_unitnumber)><cfif NOT getCommunity.showunitonlyoption>, Unit </cfif>#h_unitnumber#</cfif></td>
				<td style="font-size:10px;" align="center">24/7</td>
				<!--- <td align="center">#dateFormat(g_initialvisit,"m/d/yyyy")#</td> --->
				<td align="center">				
				<input type="submit" value="check-in" style="font-size:9px;" onclick="GuestCheckin(#v_id#,#g_id#);">
				<cfif getCommunity.checkoutoption>
				<input type="submit" value="check-out" style="font-size:9px;" onclick="GuestCheckout(#v_id#,#g_id#);">
				</cfif>
				</td></tr>	
			</cfoutput>
			</tbody>
		</table>
		</div>
	   </cfif><!--- end recordcount IF block --->
	   </cfif><!--- end community 24/7 IF block --->
	</cfif>	<!--- end url.viewhour IF block --->