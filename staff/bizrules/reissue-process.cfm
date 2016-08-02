<!--- RE-ISSUE --->
<!--- 
1. Create the new barcode record --->
  <!--- ### BEGIN RE-ISSUE CODE --->
<cfset newbarcode = createObject('component','barcode').create(g_id)>

<!--- 
2. Update the guestvisit record --->
	<cfquery name="qGuestVisits" datasource="#datasource#">
		select g_barcode, v_id, g_id FROM guestvisits			
		WHERE v_id = #attributes.v_id#
	</cfquery>
	<cfquery name="qOldBarcode" datasource="#datasource#">
		SELECT r_id from barcodes
			where barcode = '#qGuestVisits.g_barcode#'
	</cfquery>
	<cfquery name="insertNewBarcode" datasource="#datasource#">
		INSERT INTO barcodes
			(g_id,barcode,r_id,c_id)
			VALUES
			(#qGuestVisits.g_id#,'#newBarCode#',#qOldBarcode.r_id#,#session.user_community#)
	</cfquery>
	<!--- CANCEL PREVIOUS --->
	<cfquery name="updateOldBarcode" datasource="#datasource#">
		UPDATE barcodes
			SET date_cancelled = #CreateODBCDateTime(request.timezoneadjustednow)#
			where barcode = '#qGuestVisits.g_barcode#'
	</cfquery>	
	<cfquery name="updateGuestVisits" datasource="#datasource#">
		UPDATE guestvisits
			SET g_barcode = '#newBarCode#',dashpass = 'Gate'
		WHERE v_id = #qGuestVisits.v_id#
	</cfquery>
	<cfquery name="updateGuestVisits" datasource="#datasource#">
		UPDATE 	schedule
		SET 	g_barcode = '#newBarCode#', dashpass = 'gate'
		WHERE 	v_id = #qGuestVisits.v_id#
		AND 	visit_date > current_date - interval '1 day'
	</cfquery>
	<cfquery name="updateGuestVisits" datasource="#datasource#">
		UPDATE guests
			SET g_barcode = '#newBarCode#'
		WHERE g_id = #qGuestVisits.g_id#
	</cfquery>
