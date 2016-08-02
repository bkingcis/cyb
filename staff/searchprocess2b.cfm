 <cfquery name="getGuests2" datasource="#datasource#">
	select * from ((guests INNER JOIN guestvisits ON guests.g_id = guestvisits.g_id)  
	INNER JOIN residents ON guests.r_id = residents.r_id) 
	INNER JOIN homesite ON residents.h_id = homesite.h_id
	WHERE guestvisits.g_barcode = '#form.dashPass#'	
</cfquery> 

<cfinclude template="../header5.cfm">
<cfoutput>
<table align="center" cellpadding="0" cellspacing="0">
<tr>
<td width="50%" valign="top" align="center"><strong style="font-weight:bold;color:##336699;font-size:16px;">GUEST:</strong><br> #getGuests2.g_fname# #getGuests2.g_lname#<br>DashPass: #getGuests2.g_barcode#</td>
<td width="50%" valign="top" align="center"><strong style="font-weight:bold;color:##336699;font-size:16px;">RESIDENT:</strong><br> #getGuests2.r_fname# #getGuests2.r_lname#<br>
Phone: #getGuests2.h_phone#
</td>
</tr>
<cfquery name="getCancelled" datasource="#datasource#">
	select * from barcodes
	Where barcode = '#form.dashPass#'
</cfquery>
<tr>
<td colspan="2">
<cfif getCancelled.date_cancelled IS NOT "">
<table style="font-size:11px;background-color:##f5f5f5;border-top:thin solid black;border-right:thin solid black;border-bottom:thin solid black;border-left:thin solid black;padding-top:10px;padding-bottom:10px;padding-left:10px;padding-right:10px;margin-top:10px;margin-bottom:10px;" cellpadding="0" cellspacing="3" border="0" align="center">
	<tr>
		<td width="100%" valign="top" align="center">
		This Barcdode was cancelled (#DateFormat(getCancelled.date_cancelled,"mm/dd/yyyy")#)
		</td>
	</tr>
	</table>	
<cfelse>
<cfquery name="checkinNeeded" datasource="#datasource#">
	select * from guestvisits INNER JOIN schedule
	ON guestvisits.g_barcode = schedule.g_barcode 
	AND schedule.g_barcode = '#form.dashpass#' 
	AND guestvisits.g_checkedin IS NULL 
	AND schedule.visit_date = #CreateDate(DateFormat(request.timezoneadjustednow,"YYYY"),DateFormat(request.timezoneadjustednow,"MM"),DateFormat(request.timezoneadjustednow,"DD"))#
</cfquery>
<cfif checkinNeeded.RecordCount IS 0>
	<cfquery name="checkinNeeded" datasource="#datasource#">
		select * from guestvisits
		WHERE g_barcode = '#form.dashpass#' 
		AND guestvisits.g_checkedin IS NULL 
		AND g_permanent = 'YES'
	</cfquery>
</cfif>

<cfquery name="getAllowed" datasource="#datasource#">
	select * from guestvisits INNER JOIN schedule
	ON guestvisits.g_barcode = schedule.g_barcode 
	AND schedule.g_barcode = '#form.dashpass#' 
	AND (schedule.visit_date = #CreateDate(DateFormat(request.timezoneadjustednow,"YYYY"),DateFormat(request.timezoneadjustednow,"MM"),DateFormat(request.timezoneadjustednow,"DD"))#
		OR guestvisits.g_permanent = 'YES')
</cfquery>
<cfif getAllowed.RecordCount IS 0>
	<cfquery name="getAllowed" datasource="#datasource#">
	select * from guestvisits
	WHERE guestvisits.g_barcode = '#form.dashpass#' 
	AND guestvisits.g_permanent = 'YES'
</cfquery>
	
<cfquery name="getAllowed2" datasource="#datasource#">
	select * from guestvisits INNER JOIN schedule
	ON guestvisits.g_barcode = schedule.g_barcode 
	AND schedule.g_barcode = '#form.dashpass#' 
	Order By schedule.visit_date
</cfquery>
	<cfset arrEnd = getAllowed2.Recordcount>
</cfif>
<cfif checkinNeeded.Recordcount IS NOT 0>

	<table style="font-size:11px;background-color:##f5f5f5;border-top:thin solid black;border-right:thin solid black;border-bottom:thin solid black;border-left:thin solid black;padding-top:10px;padding-bottom:10px;padding-left:10px;padding-right:10px;margin-top:10px;margin-bottom:10px;" cellpadding="0" cellspacing="3" border="0" align="center">
	<cfform action="checkin.cfm" method="post" enctype="multipart/form-data">
	<tr>
		<td width="100%" valign="top" align="center">
		<strong><a href="javascript:void(0);" onmouseover="return overlib(OLiframeContent('jtwain.cfm', 450, 400, 'if1', 1), WRAP, TEXTPADDING,0, BORDER,1, STICKY,NOCLOSE, SCROLL,CAPTIONPADDING,4, CAPTION,'Resident Address Book',MIDX,-300, RELY,50, STATUS,'Example with iframe content, a caption and a Close link');" onmouseout="nd(20);" style="color:Black;">ID Scan</a></strong>&nbsp;&nbsp;<input type=file name="photo" size="10" required="YES" message="Photo ID is Required">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<strong>License Plate:</strong><cfinput type="text" name="licenseplate" size="10" required="YES" message="License Plate is Required">	<CF_CUSTOMSELECT LISTTYPE="st" LISTNAME="State" SELECTEDVALUE="FL">
		<cfoutput><input type="hidden" name="g_id" value="#checkinNeeded.g_id#"><input type="hidden" name="v_id" value="#checkinNeeded.v_id#"></cfoutput><input type="hidden" name="fromScan" value="YES">	<br><br><input type="submit" value="CHECK GUEST IN">
		</td>
	</tr>
	</cfform>
	</table>	
<cfelse>
	<table style="font-size:11px;background-color:##f5f5f5;border-top:thin solid black;border-right:thin solid black;border-bottom:thin solid black;border-left:thin solid black;padding-top:10px;padding-bottom:10px;padding-left:10px;padding-right:10px;margin-top:10px;margin-bottom:10px;" cellpadding="0" cellspacing="3" border="0" align="center">
	<tr>
		<td width="100%" valign="top" align="center">
		<cfif getAllowed.RecordCount IS NOT 0>
		<cfinclude template="displaycalendar3.cfm">	
		<cfinclude template="datesvisited.cfm">
		<cfelse>
		<div align="center" style="color:Red;font-size:18px;font-weight:bold;">Unauthorized Visit Date
		<cfif IsDefined("getAllowed2.RecordCount")>
		<cfif CreateODBCDateTime(request.timezoneadjustednow) LT getAllowed2.visit_date[1]><br>PREMATURE DASHPASS</cfif>
		<cfif CreateODBCDateTime(request.timezoneadjustednow) GT getAllowed2.visit_date[arrEnd]><br>EXPIRED DASHPASS<br>Expired: 
		#DateFormat(getAllowed2.visit_date[arrEnd],"MM/DD/YYYY")#
		</cfif>
		<!--- <br>#getAllowed2.visit_date[1]# - #getAllowed2.visit_date[arrEnd]# --->
		</cfif>
		</div>
		<br>
		<cfif CreateODBCDateTime(request.timezoneadjustednow) GT getAllowed2.visit_date[arrEnd]>
		<cfelse>View the available schedule below.
		</cfif>
		<br>		
		</cfif>		
		</td>
	</tr>
	</table>	

</cfif>
</cfif>

</td>
</tr>
<cfset session.g_id = getCancelled.g_id>
<cfif not isDefined("getAllowed.RecordCount") OR getAllowed.RecordCount IS 0>
<cfif not isDefined("getAllowed.RecordCount") OR CreateODBCDateTime(request.timezoneadjustednow) LT getAllowed2.visit_date[arrEnd]>
<tr>
<td colspan="2">
<!--  FlatCalendar Tags (tag name and id must match), note it's using plugins2.js -->
<iframe width=174 height=172 name="gToday:normal:agendadata7.cfm:gfFlat_1:plugins2.js" id="gToday:normal:agendadata7.cfm:gfFlat_1:plugins2.js" src="iflateng.htm" scrolling="no" frameborder="0">
<a name="gfFlat_1_spacer"><img width=172 height=178></a>
</iframe>
<iframe width=174 height=172 name="[gToday[0],gToday[1]+1]:normal:share[gfFlat_1]:gfFlat_2:plugins2.js" id="[gToday[0],gToday[1]+1]:normal:share[gfFlat_1]:gfFlat_2:plugins2.js" src="iflateng.htm" scrolling="no" frameborder="0">
<a name="gfFlat_2_spacer"><img width=172 height=178></a>
</iframe>
<iframe width=174 height=172 name="[gToday[0],gToday[1]+2]:normal:share[gfFlat_1]:gfFlat_3:plugins2.js" id="[gToday[0],gToday[1]+2]:normal:share[gfFlat_1]:gfFlat_3:plugins2.js" src="iflateng.htm" scrolling="no" frameborder="0">
<a name="gfFlat_3_spacer"><img width=172 height=178></a>
</iframe>
<iframe width=174 height=172 name="[gToday[0],gToday[1]+3]:normal:share[gfFlat_1]:gfFlat_4:plugins2.js" id="[gToday[0],gToday[1]+3]:normal:share[gfFlat_1]:gfFlat_4:plugins2.js" src="iflateng.htm" scrolling="no" frameborder="0">
<a name="gfFlat_4_spacer"><img width=172 height=178></a>
</iframe>
</td>
</tr>
</cfif>
</cfif>
</table>

</cfoutput>
	
<cfinclude template="actionlist.cfm">
<cfinclude template="../footer.cfm">