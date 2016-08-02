<cfif NOT isDefined('SESSION.user_community')>
	<cflocation url="/staff" addtoken="No">
</cfif>

<cfinclude template="popup/header.cfm">
<cftry>
<cfif (structKeyExists(form,'sbtButton') and (FindNoCase('cancel',form.sbtButton) or FindNoCase('remove',form.sbtButton))) OR (structKeyExists(url,'cancel'))>
	<table align="center" style="font-size:11pt;background-color:#f5f5f5;border-top:thin solid black;border-right:thin solid black;border-bottom:thin solid black;border-left:thin solid black;padding-top:10px;padding-bottom:10px;padding-left:10px;padding-right:10px;margin-top:10px;width:500px;" cellpadding="0" cellspacing="3" border="0">
		<tr>
			<td align="center">	&nbsp;
			</td>
		</tr>
		<tr>
			<td align="center" style="text-align:center;padding:30px"><strong>Are you sure?</strong>
			</td>
		</tr>
		<cfoutput>
		<tr><td style="text-align:center;padding-right:5px;">
			<button onclick="self.location='modifyschedule3.cfm?v_id=#v_id#&cancel-confirmed=1'" style="font: 14px Arial bold;">Yes Cancel Visitor</button> 
			<button  onclick="history.back();"  style="font: 14px Arial bold;">No, Do not delete <!--- 24/7 ---> Express Pass Visitor</button></td></tr>
		</cfoutput>
	</table>
<cfelseif structKeyExists(url,'cancel-confirmed')>
	<cfquery name="getNewBarcode" datasource="#datasource#">
		UPDATE guestvisits SET G_Cancelled = #CreateODBCDateTime(request.timezoneadjustednow)#
		WHERE  v_id =  <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#v_id#" />
	</cfquery>
	<table align="center" style="font-size:11pt;background-color:#f5f5f5;border-top:thin solid black;border-right:thin solid black;border-bottom:thin solid black;border-left:thin solid black;padding-top:10px;padding-bottom:10px;padding-left:10px;padding-right:10px;margin-top:10px;width:500px;" cellpadding="0" cellspacing="3" border="0">
		<tr>
			<td align="center">	&nbsp;
			</td>
		</tr>
		<tr>
			<td style="text-align:center;padding:30px"><strong>Guest Visit Has been CANCELLED.</strong>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
	</table><cfabort>
<cfelse>
	<cfset barcode = createObject('component','barcode').create(g_id)>
	<cfquery name="getNewBarcode" datasource="#datasource#">
		UPDATE barcodes
			SET date_cancelled = #CreateODBCDateTime(request.timezoneadjustednow)#
			where barcode = '#form.g_barcode#'
	</cfquery>		
	<cfquery name="updateBarcodes" datasource="#datasource#">
		INSERT INTO barcodes
			(g_id,barcode,r_id,c_id)
		VALUES
			(#form.g_id#,'#barcode#',#form.r_id#,#session.user_community#)
	</cfquery>
	<cfquery name="updateGuestVisits" datasource="#datasource#">
		UPDATE guestvisits
			SET g_barcode = '#barcode#'
		WHERE v_id = #v_id#
	</cfquery>
	<cfquery name="updateGuestVisits" datasource="#datasource#">
		UPDATE guests
			SET g_barcode = '#barcode#'
		WHERE g_id = #g_id#
	</cfquery>

	<cfif isdefined('form.g_fname0')>		
		<cfquery name="updateAcct" datasource="#datasource#">
		UPDATE	guests
		SET		r_id = #form.r_id#,
				c_id = #session.user_community#,
				g_fname = '#form.g_fname0#',
				g_lname = '#form.g_lname0#'
		WHERE	g_id = #form.g_id#
		</cfquery>
	</cfif>

	<cfquery name="getGuest" datasource="#datasource#">
		select guests.g_id,guests.r_id,guests.c_id,residents.h_id,residents.r_id
		from guests, residents
		where residents.r_id = guests.r_id AND guests.g_id = #form.g_id#
	</cfquery>	

	<cfquery name="GetVisit" datasource="#datasource#">
		select * 
		from schedule
		WHERE g_id = #getGuest.g_id#
		AND v_id = #form.v_id#
	</cfquery>
	 <CFSET DatesListed = QueryNew("DATELIST")>

	<cfif NOT isDefined('form.allSelected0')>
		<!--- This should only happen when the dates cannot be 
			changed.  IE - intial visit had been recorded --->

			<cfset form.allSelected0 = ''>
	</cfif>

	<cfloop list="#allSelected0#" index="i">
		<cfset thisdate = i>			    
		<cfset temp = QueryAddRow(DatesListed, 1)>			    
		<cfset temp = QuerySetCell(DatesListed, "DATELIST", thisdate)>
	</cfloop>
	<cfquery name="OrderDates" DBTYPE="query">
		select * from DatesListed
			ORDER BY DATELIST
	</cfquery>

	<cfparam name="form.hour0" default="12:00">
	<cfset InitialVisit = CreateDateTime(DateFormat(OrderDates.DATELIST,"YYYY"),  DateFormat(OrderDates.DATELIST,"MM"),  DateFormat(OrderDates.DATELIST,"DD"),  listFirst(form.hour0,":"), listRest(form.hour0,":"), 00)>

	<cfquery name="updateInitialVisit" datasource="#datasource#">
		UPDATE guestvisits
		SET g_initialvisit = #CreateODBCDateTime(initialvisit)#
		<cfif len(form.guestcompanioncount0)>,guestcompanioncount=#form.guestcompanioncount0#</cfif>
		WHERE g_id = #getGuest.g_id#
		AND v_id = #form.v_id#
	</cfquery>	

	<cfquery name="deleteEvents" datasource="#datasource#">
		DELETE FROM schedule
		WHERE g_id = #form.g_id# 
		AND v_id = #form.v_id#
		and visit_date >= #CreateODBCDate(request.timezoneadjustednow)# 
	</cfquery>

	<cfif isDefined('singleentry0')>
		<cfset singleentry = 'True'>
	<cfelse>
		<cfset singleentry = 'False'>
	</cfif>

	<cfloop list="#allSelected0#" index="i">
		<cfset thisdate = i>
		<cfquery name="insertSchedule" datasource="#datasource#">
			insert into schedule
			(c_id,h_id,r_id,g_id,g_barcode,visit_date,g_singleentry,v_id)				
			values(#session.user_community#, #getGuest.h_id#, #getGuest.r_id#, #form.g_id#,'#barcode#', #CreateODBCDate(thisdate)#,#singleentry#,#form.v_id#)
		</cfquery>
	</cfloop>

	<table align="center" style="font-size:11pt;background-color:#f5f5f5;border-top:thin solid black;border-right:thin solid black;border-bottom:thin solid black;border-left:thin solid black;padding-top:10px;padding-bottom:10px;padding-left:10px;padding-right:10px;margin-top:10px;width:500px;" cellpadding="0" cellspacing="3" border="0">
		<tr>
			<td align="center">	&nbsp;
			</td>
		</tr>
		<tr>
			<td align="center" style="padding-right:5px;font: 1.1em Arial;"><strong>Guest visit has been updated.</strong>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
	</table>
	
</cfif>
	<cfcatch type="any">
		<cfdump var="#cfcatch#">
		<cfdump var="#form#">
		<cfdump var="#url#">
		<cfabort>
	</cfcatch>
</cftry>
