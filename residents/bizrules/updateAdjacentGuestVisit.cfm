<!--- NOW We need to Remove Old Record to be REISSUED --->
	<cfquery name="updateOldBarcode" datasource="#datasource#">
		UPDATE barcodes
			SET date_cancelled = #CreateODBCDateTime(request.timezoneadjustednow)#
			where barcode = '#oldbarcode#'
	</cfquery>
	<cfquery name="getVID" datasource="#datasource#">
		select g_id,v_id,g_barcode from guestvisits
		Where g_barcode = '#oldbarcode#'
	</cfquery>
   <cfquery name="removeoldbc" datasource="#datasource#">
		update guestvisits
		set g_barcode = 0
		where v_id = #val(getVID.v_id)#
	</cfquery>
	<cfquery name="removeBC" datasource="#datasource#">
		update guestvisits set g_barcode = ''
		where v_id = #val(getVID.v_id)#
	</cfquery>
	<cfquery name="getVID" datasource="#datasource#">
		select g_id,v_id,g_barcode from guestvisits
		Where v_id = #val(getVID.v_id)#
	</cfquery>
	<cfset visitid = getVID.v_id>