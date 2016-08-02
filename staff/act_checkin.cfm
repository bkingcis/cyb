<CFIF session.staff_id EQ 0>
    <cflocation URL="../staff.cfm">
	<cfabort>
</CFIF>
<cfparam name="cancel" default="">
<cfset request.dsn = datasource>

<cfsavecontent variable="bodyContent">
<cfif isDefined("form.dashPass")>
<!--- RULES FOR DASHPASS BARCODE ENTRY --->

	<cfinclude template="bizrules/validate_entryBybarcode.cfm">
		
	  <cfif isDefined("qSchedule.v_id") >
		<cfset attributes.v_id = qSchedule.v_id>
		<cfset attributes.g_id = qSchedule.g_id>
			<cfquery datasource="#datasource#" name="getGuest">
			select * from guests g join residents r on g.r_id = r.r_id join homesite h on r.h_id = h.h_id
			where g.g_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(attributes.g_id)#" >
		    </cfquery>
		<cfelse>
			<cfset attributes.v_id = 0>
		</cfif>
		
	<cfswitch expression="#returncode#">
		<cfcase value="invalid barcode"><!--- INVALID CODE  --->
			<cfset message = "This barcode is not a recognized DashPass Product">
			<cfset nextActions = "FindResident,FindGuest">
		</cfcase>
		<cfcase value="canceled barcode"><!--- CANCELED CODE  --->
			<cfset message = "DASHPASS WAS CANCELED">
			<!--- find the guest --->
			<cfinclude template="bizrules/lookupInactiveDashPass.cfm">
			<cfif isDefined("scheduleFound") and scheduleFound>
				<p>(box display – date/time stamp)</p>
				<p>Please reprint the reissued DashPass or cancel and Reissue if lost, damaged or destroyed</p>
				<cfset nextActions = "reprintDP,reissueDP">
			<cfelse>
				<cfoutput>
				<p>This DashPass was canceled on #dateFormat(cancel,"short")#, #timeFormat(cancel,"h:mm tt")# </p>
				<p>Please contact the resident to verify entry<br>
				<strong>Main Phone: #getGuest.h_phone#<br><cfif LEN(getGuest.r_altphone) gt 2>Alt Phone: #getGuest.r_altphone#</cfif></strong>
				<cfset nextActions = "IssueSingleEntry">
				</cfoutput>
			</cfif>
		</cfcase>
		<cfcase value="permanent early"><!--- INVALID CODE  --->
			<cfset message = "Guest is early">
			<cfset nextActions = "FindResident,FindGuest">
		</cfcase>
		<cfcase value="allow permanent"><!--- GRANT ACCESS FOR 24/7 GUEST  --->
			<cfset message = "Allow Entry 24/7 Guest">
			<cfset messagetype = "green">
			<cfset metarefresh = true>
			<cfmodule template="bizrules/record_entryByBarcode.cfm" dashpass="#form.dashpass#">
			<cfset refreshtime = 8>
		</cfcase>
		<cfcase value="allow fullday"><!--- GRANT ACCESS FOR Fullday GUEST  --->
			<cfset message = "Allow Entry Fullday Guest">
			<cfset messagetype = "green">
			<cfset metarefresh = true>
			<cfmodule template="bizrules/record_entryByBarcode.cfm" dashpass="#form.dashpass#">
			<cfset refreshtime = 8>
		</cfcase>
		<cfcase value="fullday Not Scheduled"><!--- Expired Fullday GUEST  --->
			<cfset message = "PREMATURE/EXPIRED ENTRY REQUEST">
			<p>Please contact the resident to verify entry</p>
			<p><strong>Resident Phone: <cfoutput>#getGuest.h_phone#</cfoutput></strong></p>
			<cfset nextActions = "IssueSingleEntry">
		</cfcase>
		<cfcase value="single entry already activated"><!--- DO NOT ALLOW already activated  --->
			<cfset message = "INVALID DASHPASS">
			<strong style="color:red;font-size:14px;">SINGLE ENTRY GUEST</strong>			
				<br>				
			<p>Please contact the resident to verify entry<br>
			<cfoutput><strong>Main Phone: #getGuest.h_phone#<br>
                <cfif LEN(getGuest.r_altphone) gt 2>Alt Phone: #getGuest.r_altphone#</cfif></strong></cfoutput>
			<cfset nextActions = "IssueSingleEntry"></p>
		</cfcase>
		<cfcase value="single entry Not Scheduled"><!--- DO NOT ALLOW Not Scheduled  --->
			<cfset message = "PREMATURE/EXPIRED ENTRY REQUEST">			
			<p>Please contact the resident to verify entry
			<cfset nextActions = "IssueSingleEntry"></p>
		</cfcase>
		<cfcase value="allow single entry"><!--- GRANT ACCESS FOR single entry GUEST  --->
			<cfset message = "ALLOW ENTRY - SINGLE ENTRY">
			<cfset messagetype = "green">
			<cfmodule template="bizrules/record_entryByBarcode.cfm" dashpass="#form.dashpass#">
			<cfset metarefresh = true>
			<cfset refreshtime = 4>
		</cfcase>
		<cfdefaultcase>
			<cfset message = returncode>
			<cfset nextActions = "FindResident,FindGuest">
		</cfdefaultcase>
	</cfswitch>

	
<cfelseif isDefined("form.v_id")>
	<!--- RULES FOR GUESTS CHECKING IN FROM MAING "CHECK-IN" BUTTON --->
	<cfinclude template="bizrules/validate_entryByvid.cfm">
	
	<cfabort showerror="problem with Act_checkin">
	<!--- <cfmodule template="bizrules/record_entryByvid.cfm" vid="#form.v_id#"> --->
	
	<cfset message="Visitor Access">
	Guest Entry Type (ie: single, fullday, 24/7)
	<!--- (Guest name, Resident name, address, phone, dashpass#) --->
	<cfset nextActions = "reprintDP,reissueDP">
<!--- <cfelseif form.g_id>
	<cfset message="Visitor Access">
	<cfset nextActions = "reprintDP"> --->
</cfif>

</cfsavecontent>
<cfparam name="nextactions" default="" />
<cfinclude template="../header5.cfm">
	<cfoutput>
	<cfparam name="messagetype" default="red">
	<table width="90%" style="background-color:#iif(messagetype is 'green',de('aaeeaa'),de('e55'))#;border:thin solid black;padding:10px;margin:auto;" cellpadding="0" cellspacing="3" border="0" align="center">
	<tr><td style="font-size:14px;font-weight:600;text-align:center;">
	 #message#
	</td></tr>
	</table>	<br>
	<br>
	
  		<cfif isDefined("attributes.g_id") and VAL(attributes.g_id)>
		<cfinclude template="include/guestinfo.cfm">
	    </cfif>
    
    
	<table style="margin:auto;text-align:center;"><tr><td>
	#bodyContent#
	<br>
	</cfoutput>
	<cfmodule template="nextactions.cfm" nextactions="#nextactions#" v_id="#attributes.v_id#">
	</td></tr>
	</table>
	   <table align="center" bgcolor="#DEDEDE">
        <tr>
            <td valign="top"><cf_cal month="#month(request.timezoneadjustednow)#" g_id="#attributes.g_id#" v_id="#attributes.v_id#" hide="events"></td>	
            <td valign="top"><cf_cal month="#month(dateAdd("m",1,request.timezoneadjustednow))#" g_id="#attributes.g_id#" v_id="#attributes.v_id#" hide="events"></td>	
            <td valign="top"><cf_cal month="#month(dateAdd("m",2,request.timezoneadjustednow))#" g_id="#attributes.g_id#" v_id="#attributes.v_id#" hide="events"></td>	
            <td valign="top"><cf_cal month="#month(dateAdd("m",3,request.timezoneadjustednow))#" g_id="#attributes.g_id#" v_id="#attributes.v_id#" hide="events"></td>	
        </tr>
    </table>
	<cfmodule template="guesthistory.cfm" v_id="#attributes.v_id#">	
	
	<cfmodule template="actionlist.cfm" showonly="home,logout">
<cfinclude template="../footer.cfm">