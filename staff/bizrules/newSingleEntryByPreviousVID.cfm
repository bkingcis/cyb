<!--- RE-ISSUE --->
<!--- 
1. Create the new barcode record --->
	<cfset pass = false>
  	<cfloop condition="pass is false">
		<cfset newBarCode = randRange(1,9999999)>
		<cfquery name="qdups" datasource="#datasource#">
			select * from barcodes
			Where c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#" />
			AND barcode = <cfqueryparam value="#newBarCode#" cfsqltype="CF_SQL_VARCHAR" />
		</cfquery>
		<cfif NOT qdups.recordcount>
			<cfset pass = true>
		</cfif>	
	</cfloop>
	

<!--- 
2. Update the guestvisit record --->
	<cfquery name="qGuestVisits" datasource="#datasource#">
		select * FROM guestvisits			
		WHERE v_id = #attributes.v_id#
	</cfquery>
	<cfquery name="GetNewGuest" datasource="#datasource#">
		select * 
		from guests
		where g_id = #qGuestVisits.g_id#
	</cfquery>
	<!--- CANCEL PREVIOUS BARCODE --->
	<cfquery name="updateOldBarcode" datasource="#datasource#">
		UPDATE barcodes
			SET date_cancelled = #CreateODBCDateTime(request.timezoneadjustednow)#
			where barcode = '#qGuestVisits.g_barcode#'
	</cfquery>	
	<!--- INSERT THE NEW BARCODE --->
	<cfquery name="insertNewBarcode" datasource="#datasource#">
		INSERT INTO barcodes
			(g_id,barcode,r_id,c_id)
			VALUES
			(#qGuestVisits.g_id#,'#newBarCode#',#GetNewGuest.r_id#,#session.user_community#)
	</cfquery>	
	
	<cfquery name="updateGuestVisits" datasource="#datasource#">
		INSERT INTO	guestvisits
		(g_initialvisit,g_barcode,map_email,g_id,entry_notification)
		VALUES
		( #CreateODBCDateTime(request.timezoneadjustednow)#,'#newbarcode#','#qGuestVisits.map_email#',#qGuestVisits.g_id#,'#qGuestVisits.entry_notification#')
	</cfquery>	
	<!--- Grab new guestvisit Record --->
	<cfquery name="qGV" datasource="#datasource#">
		select v_id as lastentry FROM guestvisits
		where g_id = #qGuestVisits.g_id#
		order by v_id desc	
	</cfquery>
	<cfset attributes.v_id = qGV.lastentry>
	<cfset url.v_id = qGV.lastentry><!--- make sure old url var is overridden --->
	
	
	<cfquery name="updateGuestVisits" datasource="#datasource#">
		insert into schedule
		(c_id,h_id,r_id,g_id,g_barcode,visit_date,g_singleentry,v_id)				
		values
		(#session.user_community#, #GetNewGuest.h_id#, #GetNewGuest.r_id#, #qGuestVisits.g_id#,'#newBarCode#', #CreateODBCDate(request.timezoneadjustednow)#,TRUE,#attributes.v_id#)
	</cfquery>
	<cfquery name="updateGuestVisits" datasource="#datasource#">
		UPDATE guests
			SET g_barcode = '#newBarCode#'
		WHERE g_id = #qGuestVisits.g_id#
	</cfquery>