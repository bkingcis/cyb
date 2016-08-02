	<cfinclude template="header.cfm">
	<cfparam name="form.allselected" default="#dateFormat(now(),'m/d/yyyy')#">
	<cfparam name="form.hour" default="0">
	<cfparam name="form.minute" default="0">
	<cfparam name="form.pguest1" default="Yes">
	<cfif left(form.allSelected,1) is ","><cfset form.allSelected = mid(form.allSelected,2,len(form.allSelected)-1)></cfif>
	<cfif form.allSelected IS  "">
		<div class="well">
		<strong>You must chose at least one date to successfully schedule a #label.Visitor#.</strong><br>		
		<div class="modal-footer">	
			<input type="button" onClick="history.back();" value="GO BACK" class="btn btn-default">
		</div>
		</div>
		<cfabort>
	</cfif>
	
	<!--- COMING FROM THE Basic Announce Form
	<cfif structKeyExists(form,'fname1')>
		<cfset form.fname
	</cfif> --->
	<cfif ListLen(form.allSelected) gt 1>	
		<div class="well">
		<strong>Please choose only one Initial Visit Date for <!--- 24/7 ---> <cfoutput>#labels.permanent_visitor#</cfoutput> <cfoutput>#labels.visitor#s</cfoutput>.</strong><br>		
		<div class="modal-footer">	
			<input type="button" onClick="history.back();" value="GO BACK" class="btn btn-default">
		</div>
		</div>
		<cfabort>
	</cfif>
<cftry>
<cfset InitialVisit = createdate(year(now()),month(now()),day(now()))>
<cfquery name="GetHomesite" datasource="#datasource#">
	select h_id from residents
	where r_id = #session.user_id#
</cfquery>
<cfset FIRSTNAME = Replace(form.FNAME1,chr(34),"","ALL")>
<cfset LASTNAME = Replace(form.LNAME1,chr(34),"","ALL")>
<cfset EMAILADDRESS = Replace(form.email1,chr(34),"","ALL")>
<cfset PGUEST = Replace(form.PGUEST1,chr(34),"","ALL")>
<cfparam name="form.dashpass1" default="">
<cfset DASHPASS = Replace(form.DASHPASS1,chr(34),"","ALL")>
<cfset mapemail = ''>
<cfif structKeyExists(form,"notify1")>
	<cfset entrynotification = Replace(form.notify1,chr(34),"","ALL")>
<cfelse>
	<cfset entrynotification = ''>
</cfif>
  <cfset codepass = FALSE>

<cfquery name="insertAcct" datasource="#datasource#">
	INSERT INTO	guests				(r_id,h_id,c_id,g_fname,g_lname,g_email)
			VALUES	(#session.user_id#,#GetHomesite.h_id#,#session.user_community#,'#FIRSTNAME#','#LASTNAME#','#EMAILADDRESS#')
</cfquery>
<cfset TheFirstName = FIRSTNAME>
<cfset TheLastName = LASTNAME>
<cfquery name="GetNewGuest" datasource="#datasource#">
	select * 
	from guests
	Where g_fname = '#TheFirstName#'	AND g_lname = '#TheLastName#' AND r_id = #session.user_id#
</cfquery>
<cfquery name="insertGuestVisit" datasource="#datasource#">
	INSERT INTO	guestvisits
	(g_initialvisit,g_id<cfif PGUEST IS "YES">,g_permanent</cfif>,dashpass,map_email,entry_notification,insertedby_staff_id)
	VALUES
	(#CreateODBCDateTime(InitialVisit)#,#GetNewGuest.g_id#<cfif PGUEST IS "YES">,TRUE</cfif>,'#DASHPASS#','#MAPEMAIL#','#ENTRYNOTIFICATION#',<cfif isDefined('session.impersonatedby')>#session.impersonatedby#<cfelse>0</cfif>)
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
		<cfset gid = RandRange(1,9999999)>
			 <cfquery datasource="#datasource#" name="qGetBarCodeHistory">
					 select barcode from barcodes where barcode = '#gid#'
			 </cfquery>
			 <cfif NOT qGetBarCodeHistory.recordcount>
					 <cfset codepass = TRUE>
			 </cfif>
	 </cfloop>

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
	<cfquery name="updateGuestVisits" datasource="#datasource#">
		UPDATE guests
			SET g_barcode = '#gid#'
		WHERE g_id = #GetNewGuest.g_id#
	</cfquery><!--- --->
	<cfif DASHPASS IS "email">
		<cfinclude template="../emailpass.cfm">					
	</cfif>	
	<div class="alert alert-success" role="alert"><strong>Success:</strong>
		<cfoutput>#labels.visitor# added to #labels.permanent_visitor#</cfoutput>
	</div>
	<script>
		$('#btnContinue').hide();	  
		$('#btnBack').hide();
		$('#btnClose').hide();
	</script>
	<cfcatch type="any">
	<div class="well"><strong>There has been an error:</strong>
		<cfoutput>#cfcatch.message#</cfoutput>
	</div>
	</cfcatch>
	</cftry>
<!--- <cflocation url="permguest.cfm"> --->