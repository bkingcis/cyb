<h2 style="font-weight:bold;color:#000;font-size:16px;border-bottom:1px solid silver;">Options:</h2>
		<cfoutput>
		<table border="0" cellpadding="1" style="margin-left:20px;" width="700">        
			<!--- <cfif (qTodayAccess.recordcount OR qSchedule.g_permanent)>	
				<cfif val(qSchedule.g_singleentry) and request.dashpasshasbeenused> --->	
				<cfif NOT returncode is "Allow Access">
				<tr>
		            <td colspan="2" align="left">
						<strong style="color:red;font-size:14px;">
							<!--- #returncode#  ---> Unauthorized Access
						</strong><br />
						<div align="center"><strong>Please contact resident to confirm guest access.</strong><br />
						<strong>#ucase(getGuests2.r_lname)#, #ucase(getGuests2.r_fname)#</strong><br />
						Main Phone: #getHomesite.h_phone#<br />
						<cfif LEN(getGuests2.r_altphone)>Alt Phone: #getGuests2.r_altphone#</cfif>
						<br /><br /></div>
					</td>
				</tr>
				<tr>
		            <td width="80" align="right">
					<div style="font-weight:bold;color:##336699;font-size:13px;padding-top:13px;">
					<cfif NOT getcommunity.dashpass>OPTIONS:<cfelse>DASHPASS:</cfif> &nbsp;&nbsp;&nbsp;</div></td>
					<td align="left">
					<cfif NOT getcommunity.dashpass>
					<input type="submit" value="check-in" onclick="self.location='guestdetails.cfm?v_id=#qSchedule.v_id#&g_id=#attributes.g_id#&checkin=1&override=1';">
					(A New Entry Will Be Recorded)
					<cfelse>
					<input type="submit" value=" : Print Single-Entry Pass : " onclick="self.location='reissueSEDP.cfm?v_id=#attributes.v_id#&g_id=#attributes.g_id#';">
					</cfif>
					</td>
				</tr>
					
				<cfelseif val(qSchedule.g_singleentry)>
					<tr>
			            <td colspan="2">
							<strong style="color:green;font-size:14px;">VALID FOR SINGLE ENTRY</strong>
						</td>
					</tr>
					<tr>
			            <td width="80" align="right"><div style="font-weight:bold;color:##336699;font-size:13px;padding-top:13px;">
						<cfif NOT getcommunity.dashpass>OPTIONS:<cfelse>DASHPASS:</cfif> &nbsp;&nbsp;&nbsp;</div></td>
						<td align="left">
							<cfif NOT getcommunity.dashpass>
							<input type="submit" value="check-in" onclick="self.location='guestdetails.cfm?v_id=#qSchedule.v_id#&g_id=#attributes.g_id#&checkin=1';">
							<cfelse>
							<input type="submit" value=" : reprint : " onclick="ReprintAndPrintPop(#qSchedule.v_id#,#qSchedule.g_id#);">
							</cfif>
						</td>
					</tr>
				<cfelse>
					<tr>
		            	<td colspan="2">&nbsp;&nbsp;<strong style="color:green;font-size:14px;">
							<cfif returncode is 'Allow Access'>AUTHORIZED ACCESS<cfelse>#returncode# </cfif>
						</strong></td>
					</tr>
					<tr>
			            <td width="80" align="right"><div style="font-weight:bold;color:##336699;font-size:13px;padding-top:13px;">
						<cfif NOT getcommunity.dashpass>OPTIONS:<cfelse>DASHPASS:</cfif> &nbsp;&nbsp;&nbsp;</div></td>
						<td align="left">
							<cfif NOT getcommunity.dashpass>
								<input type="submit" value="check-in" onclick="self.location='guestdetails.cfm?v_id=#qSchedule.v_id#&g_id=#attributes.g_id#&checkin=1';">
							<cfelse>
								<cfquery datasource="#datasource#" name="qInitial">
									SELECT g_checkedin 
									FROM visits 
									WHERE v_id = #qSchedule.v_id#
								</cfquery>
								<cfif qSchedule.dashpass is "gate" AND NOT qInitial.recordcount>
								<input type="submit" value=" : print : " onclick="ReprintAndPrintPop(#v_id#,#g_id#);">
								<cfelse>
								<input type="submit" value=" : reprint : " onclick="ReprintAndPrintPop(#qSchedule.v_id#,#qSchedule.g_id#);">
								<input type="submit" value=" : reissue : " onclick="ReissueAndPrintPop(#qSchedule.v_id#,#qSchedule.g_id#);">
								</cfif>
								<input type="checkbox" id="printonlyChk" /> Print Only <!--- (will not record guest visit) --->
								<!--- 
								<input type="submit" value=" : print only : " onclick="PrintOnlyPop(#qSchedule.v_id#,#qSchedule.g_id#);"> --->
							</cfif>
						</td>
					</tr>
				</cfif>
			</cfoutput>
		
	</table>	