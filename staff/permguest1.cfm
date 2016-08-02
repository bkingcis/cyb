<cfif NOT isDefined("session.staff_id") OR NOT VAL(session.staff_id)>
	<cflocation URL="../staff.cfm" addtoken="no">
</cfif>
<cfinclude template="../header5.cfm">
<cfinclude template="include/staffheaderinfo.cfm">

<script type="text/javascript">
	function validateSubmission(obj){
	 if(document.getElementById('LName1').value!=''){
	 	obj.form.submit();
	 }
	 else{
	 	document.getElementById('LName1').focus();
		alert('Please Provide a valid Last Name or Company Name to continue.');
	 }
	}
</script>
<div style="clear:both;"></div><br /><br />
<cfparam name="FNAME" DEFAULT="">
<cfparam name="LNAME" DEFAULT="">
<!--- <cfparam name="PHONE" DEFAULT=""> --->
<cfparam name="EMAIL" DEFAULT="">
<cfparam name="PGUEST" DEFAULT="NO">

	<cfparam name="number_of_guests" default=1>
	<cfparam name="form.dashpass1" default="0">
	<cfquery name="getperms" datasource="#datasource#">
		select guests.g_id, guests.r_id, guests.g_fname, guests.g_lname, guestvisits.g_id, 
		guestvisits.g_permanent, guestvisits.g_cancelled, guestvisits.v_id, guestvisits.g_barcode
		FROM guests INNER JOIN guestvisits ON guests.g_id = guestvisits.g_id
		WHERE guests.r_id = <cfqueryparam value="#form.r_id#" cfsqltype="CF_SQL_INTEGER" />
		AND guestvisits.g_permanent = TRUE
		AND guestvisits.g_cancelled IS NULL
		ORDER BY g_lname, g_fname
	</cfquery>
	<cfquery datasource="#datasource#" name="getResident">
		select r_fname,r_lname from residents
		where r_id = <cfqueryparam value="#form.r_id#" cfsqltype="CF_SQL_INTEGER" />
	</cfquery>
		
	<div align="center" class="staffHeader1"><!--- 24/7 ACCESS --->EXPRESS PASS VISITORS FOR: <cfoutput>#ucase(getResident.r_lname)#, #ucase(getResident.r_fname)#</cfoutput></div>
	<br>	
	<cfset maxPermGuests = GetCommunity.maxpermguests>
	<cfif getperms.recordcount lt maxPermGuests OR maxPermGuests eq 999>	
		
	<div align="center">
		
		<form action="permguest3.cfm" method="Post">
		<cfoutput>
		<input type="hidden" name="number_of_guests" value="#number_of_guests#">
		<input type="hidden" name="r_id" value="#form.r_id#">
		<!--- <input type="hidden" name="h_id" value="#form.h_id#"> --->
		<input type="hidden" name="staff_id" value="#session.staff_id#">
		<!--- <input type="hidden" name="r_fname" value="#form.r_fname#">
		<input type="hidden" name="r_lname" value="#form.r_lname#"> --->
		</cfoutput>
		
		<div align="center" class="staffHeader2">ADD VISITOR INFORMATION</div>
	<table cellpadding="3" cellspacing="0" border="0" align="center">
		<!--- <tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td align="center" style="font-weight:Bold;text-decoration:underline;" valign="top">
		<cfif GetCommunity.DashPass IS 'YES'>DashPass</cfif>
		</td>
		<td align="center" style="font-weight:Bold;text-decoration:underline;" valign="top">
		<cfif GetCommunity.DashPass_Map IS 'YES'>Map</cfif>
		</td>
		<td align="center" style="font-weight:Bold;text-decoration:underline;" valign="top">
		<cfif GetCommunity.Entry_Notify IS 'YES'>Notify</cfif>		
		</td> 
		</tr>--->
		<cfloop FROM="1" TO="#number_of_guests#" Index="i">
		  <cfoutput>
		  <cfif i EQ 1>
		  <cfset LNAME = LNAME & "LNAME#i#"> 		  
		  <cfelse>
		  <cfset LNAME = LNAME & "," & "LNAME#i#"> 
		  </cfif>
		  <tr <cfif i MOD 2 IS 1>style="background-color:##f5f5f5;"</cfif>>
		  	<td>
			Last Name or Company Name&nbsp;
			</td>
			<td>
			<input type="text" size="30" name="LName#i#" id="LName#i#"> <span style="color:##666;"> (required)</span>
			</td>
			<td>
			<!--- <cfinclude template="announce_prefs.cfm">--->
			</td> 
		  </tr>
		  <tr <cfif i MOD 2 IS 1>style="background-color:##f5f5f5;"</cfif>>
		  	<td>
			First Name
			</td>
			<td>
			<input id="fname#i#" type="text" size="30" name="FName#i#">
			<cfif i EQ 1>
		  <cfset FNAME = "#FNAME#" & "FNAME#i#"> 		  
		  <cfelse>
		  <cfset FNAME = "#FNAME#" & "," & "FNAME#i#"> 
		  </cfif>
			</td>
			<td>&nbsp;<!--- <a href="javascript:void(0);" onmouseover="return overlib('First Name not required when announcing a company name.<br><br>', BUBBLE, BUBBLETYPE, 'roundcorners', STATUS, 'quotation popup', TEXTSIZE,'x-small');" onmouseout="nd();">
	<b style="background-color:##fff8dc;color:##000000;padding-top:2px;padding-bottom:2px;padding-left:2px;padding-right:2px;border-top:1px solid Grey;border-bottom:1px solid grey;border-left:1px solid grey;border-right:1px solid grey;font-variant:small-caps;font-weight:bold;font-size:12px;">?</b></a> ---></td>
		  </tr>
		  <!--- <tr <cfif #i# MOD 2 IS 1>style="background-color:##f5f5f5;"</cfif>>
		  	<td>
			(#i#) Phone (optional)
			</td>
			<td>
			<input type="text" size="30" name="Phone#i#">
				<cfif #i# EQ 1>
		  <cfset #PHONE# = "#PHONE#" & "PHONE#i#"> 		  
		  <cfelse>
		  <cfset #PHONE# = "#PHONE#" & "," & "PHONE#i#"> 
		  </cfif>
			</td>
			<td>&nbsp;</td>
		  </tr> --->
		  
		  <cfif GetCommunity.DashPass IS 'YES' and 1 eq 2>
			  <tr <cfif i MOD 2 IS 1>style="background-color:##f5f5f5;"</cfif>>
			  	<td>Email Address</td>
				<td><input type="text" size="30" name="Email#i#"></td>
				<td><a href="javascript:void(0);" onmouseover="return overlib('Email Address Required only when utilizing the DashDirect and DashPass products<br><br>', BUBBLE, BUBBLETYPE, 'roundcorners', STATUS, 'quotation popup', TEXTSIZE,'x-small');" onmouseout="nd();">
				<b style="background-color:##fff8dc;color:##000000;padding-top:2px;padding-bottom:2px;padding-left:2px;padding-right:2px;border-top:1px solid Grey;border-bottom:1px solid grey;border-left:1px solid grey;border-right:1px solid grey;font-variant:small-caps;font-weight:bold;font-size:12px;">?</b></a></td>
			  </tr>
		  <cfelse>
		  	<input type="hidden" name="Email#i#">
		  </cfif>
		  <cfif i EQ 1>
		   <cfset EMAIL = "#EMAIL#" & "EMAIL#i#"> 		  
		  <cfelse>
		   <cfset EMAIL = "#EMAIL#" & "," & "EMAIL#i#"> 
		  </cfif>  
			<input type="hidden" name="pguest#i#" value="YES">
					<cfif i EQ 1>
					  <cfset pguest = pguest & "pguest#i#"> 		  
					  <cfelse>
					  <cfset pguest = pguest & "," & "pguest#i#"> 
					  </cfif>
		
		  </cfoutput>
		 </cfloop>
		</table>
		<cfoutput>
		<input type=hidden name=FNAME value="#FNAME#">
		<input type=hidden name=LNAME value="#LNAME#">
		<!--- <input type=hidden name=PHONE value="#PHONE#"> --->
		<input type=hidden name=EMAIL value="#EMAIL#">		
		</cfoutput><br>
		
		<input type="button" value=" submit " onclick="validateSubmission(this)">
		</form>
	<cfelse>
		<br><br>
		Maximum Number of Express Pass Visitors: <strong><cfoutput>#maxPermGuests#</cfoutput></strong>	
		
	</cfif><br>
		<br>
	</div>
	
	<div align="center"><strong> <!--- CURRENT 24/7 ACCESS --->EXPRESS PASS VISITORS</strong><br>
	<div align="center">
		<table cellpadding="2" cellspacing="5" border="0">
			<tr>
				<td style="font-weight:bold;background-color:#336699;color:White;" width="300" align="center">	Name (Last, First):
				</td>
				<td style="font-weight:bold;background-color:#336699;color:White;" align="center">	Options:
				</td>	
			</tr>
			<cfoutput query="getperms">
			<tr>
				<td width="300">	#ucase(getperms.g_lname)#,&nbsp;#ucase(getperms.g_fname)#
				</td>
				<td>					
					<!--- <cfif GetCommunity.DashPass IS 'YES'>					
					<input type="button" value="reissue DashPass" onclick="self.location='reissueDashPass.cfm?v_id=#getperms.v_id#'">
					</cfif> --->
					<input type="button" value="check-in" style="color:Green;" onclick="self.location='guestdetails.cfm?checkin=1&g_id=#getperms.g_id#&v_id=#getperms.v_id#'" />
					<input type="button" value="history" onclick="self.location='guestdetails.cfm?g_id=#getperms.g_id#&v_id=#getperms.v_id#'" />
					<input type="button" value="cancel guest" style="color:Red;" onclick="self.location='deletecheck3.cfm?v_id=#getperms.v_id#'">
				</td>
			</tr>
			</cfoutput>
		</table>
	</div>
	<cfinclude template="actionlist.cfm">
	<cfinclude template="../footer.cfm">

