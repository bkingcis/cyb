	<cfif NOT isDefined("session.staff_id") OR NOT VAL(session.staff_id)>
	<cflocation URL="../staff.cfm" addtoken="no">
</cfif>
<cfinclude template="header.cfm">

	<cfparam name="form.allselected" default="#dateFormat(now(),'m/d/yyyy')#">
	<cfparam name="form.hour" default="0">
	<cfparam name="form.minute" default="0">
	<cfparam name="entrynotification" DEFAULT="NO">
	<cfif left(form.allSelected,1) is ","><cfset form.allSelected = mid(form.allSelected,2,len(form.allSelected)-1)></cfif>
	<cfif form.allSelected IS  "">
		<div align="center">
		<strong>You must chose at least one date to successfully schedule a guest.</strong><br>		
		<form><br />		
		<input type="button" onClick="history.back();" value=" Go Back "  style="color: red;">
		</form>
		</div>
		
		<cfabort>
	</cfif>
	<cfif ListLen(form.allSelected) gt 1>
		<div align="center">
		<strong>Please choose only one Initial Visit Date for 24/7 Guests.</strong><br>		
		<form><br />		
		<input type="button" onClick="history.back();" value=" Go Back "  style="color: red;">
		</form>
		</div>
		<cfmodule template="actionlist.cfm" showonly="home,logout">
		<cfinclude template="../footer.cfm">
		<cfabort>	
	</cfif>
	
<!--- Create ODBC Ready Date and Time for Initial Visit--->			
<cfset InitialVisit = CreateDateTime(DateFormat(form.allSelected,"YYYY"),  DateFormat(form.allSelected,"MM"),  DateFormat(form.allSelected,"DD"),Listfirst(form.hour,":"), ListLast(form.hour,":"), 00)>
		
<cfset InitialVisit = createdate(year(request.timezoneadjustednow),month(request.timezoneadjustednow),day(request.timezoneadjustednow))>
<cfquery name="GetHomesite" datasource="#datasource#">
	select h_id from residents
	where r_id = #form.r_id#
</cfquery>
<cfset FIRSTNAME = Replace(form.FNAME1,chr(34),"","ALL")>
<cfset LASTNAME = Replace(form.LNAME1,chr(34),"","ALL")>
<cfset EMAILADDRESS = Replace(form.email1,chr(34),"","ALL")>
<cfset PGUEST = Replace(form.PGUEST1,chr(34),"","ALL")>
<cfparam name="form.dashpass1" default="">
<cfset DASHPASS = Replace(form.DASHPASS1,chr(34),"","ALL")>
<cfset mapemail = ''>
<!--- <cfset ENTRYNOTIFICATION = Replace(form.notify1,chr(34),"","ALL")> --->
  <cfset codepass = FALSE>

<cfquery name="insertAcct" datasource="#datasource#">
	INSERT INTO	guests				(r_id,h_id,c_id,g_fname,g_lname,g_email)
			VALUES	(#form.r_id#,#GetHomesite.h_id#,#session.user_community#,'#FIRSTNAME#','#LASTNAME#','#EMAILADDRESS#')
</cfquery>
<cfset TheFirstName = FIRSTNAME>
<cfset TheLastName = LASTNAME>
<cfquery name="GetNewGuest" datasource="#datasource#">
	select * 
	from guests
	Where g_fname = '#TheFirstName#'	AND g_lname = '#TheLastName#' AND r_id = #form.r_id#
</cfquery>
<cfquery name="insertGuestVisit" datasource="#datasource#">
	INSERT INTO	guestvisits
	(g_initialvisit,g_id<cfif PGUEST IS "YES">,g_permanent</cfif>,dashpass,map_email,entry_notification,insertedby_staff_id)
	VALUES
	(#CreateODBCDateTime(InitialVisit)#,#GetNewGuest.g_id#<cfif PGUEST IS "YES">,TRUE</cfif>,'#DASHPASS#','#MAPEMAIL#','#ENTRYNOTIFICATION#',#session.staff_id#)
</cfquery>
<cfquery name="getVID" datasource="#datasource#">
	select v_id from guestvisits
	Where g_id = #GetNewGuest.g_id#
	AND g_initialvisit = #CreateODBCDateTime(InitialVisit)#
	ORDER BY g_id DESC
</cfquery>
<cfif PGUEST IS "NO">
<!--- <cfoutput query="OrderDates">
	<cfquery name="insertSchedule" datasource="#datasource#">
		insert into schedule
				(c_id,h_id,r_id,g_id,visit_date<cfif #ListLen(form.allSelected)# IS 1>,g_singleentry</cfif>)				
				values(#GetNewGuest.c_id#, #GetNewGuest.h_id#, #GetNewGuest.r_id#, #GetNewGuest.g_id#, #CreateODBCDate(DATELIST)#<cfif #ListLen(form.allSelected)# IS 1><cfif #form.entrytype# IS "SingleEntry">,YES<cfelse>,NO</cfif></cfif>)
	</cfquery>
</cfoutput> --->
</cfif>
<!--- Set Barcode --->	
	<cfloop condition="codepass is FALSE">
		<cfset gid = RandRange(10000000,99999999)>
                 <cfquery datasource="#datasource#" name="qGetBarCodeHistory">
                     select barcode from barcodes where barcode = '#gid#'
                 </cfquery>
                 <cfif NOT qGetBarCodeHistory.recordcount>
                     <cfset codepass = TRUE>
                 </cfif>
             </cfloop>
	Barcode: <cfoutput>#gid#</cfoutput>

	<cfquery name="updateBarcodes" datasource="#datasource#">
		INSERT INTO barcodes
			(g_id,barcode,r_id,c_id)
			VALUES
			(#GetNewGuest.g_id#,'#gid#',#GetNewGuest.r_id#,#session.user_community#)
	</cfquery>
	<cfquery name="getVID" datasource="#datasource#">
			select v_id,g_barcode from guestvisits
			Where g_id = #GetNewGuest.g_id#
			ORDER BY v_id DESC
	</cfquery>
	<cfset visitid = getVID.v_id>
	<cfquery name="getNewBarcode" datasource="#datasource#">
		Select * from barcodes
			where c_id = #session.user_community#
			AND r_id = #GetNewGuest.r_id#
	</cfquery>				
	<cfquery name="updateGuestVisits" datasource="#datasource#">
		UPDATE guestvisits
			SET g_barcode = '#gid#'
		WHERE v_id = #visitid#
	</cfquery>
	<cfquery name="updateGuestVisits" datasource=#datasource#>
		UPDATE guests
			SET g_barcode = '#gid#'
		WHERE g_id = #GetNewGuest.g_id#
	</cfquery>
	<!--- <cfif DASHPASS IS "email">
		<cfinclude template="emailpass.cfm">					
	</cfif>	 --->
<cflocation url="permguest1.cfm?r_id=#form.r_id#">

	
	
	
