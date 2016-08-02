<!--- RE-ISSUE OF SINGLE ENTRY IS THE SAME AS CREATING NEW --->
<!--- 
1. Create the new barcode record --->
  <!--- ### BEGIN RE-ISSUE CODE --->
  	<cfquery name="getNextBarcode" datasource="#datasource#">
		select * from barcodes
		Where c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#" />
		Order by bc_id
	</cfquery>
	<cfoutput query="getNextBarcode" startrow="#getNextBarcode.RecordCount#">
		<cfset nextBarcode = Evaluate(Right(getNextBarcode.barcode,7)+1)>
	</cfoutput>
	<cfset zeroes = "">
	<cfloop from="1" to="#evaluate(7-Len(nextBarcode))#" index="i">
	<cfset zeroes = zeroes & "0">
	</cfloop>
	<cfset zeroes1 = "">
	<cfloop from="1" to="#evaluate(5-Len(session.user_community))#" index="i">
	<cfset zeroes1 = zeroes1 & "0">
	</cfloop>
	
<cfset newBarCode = zeroes1 & session.user_community & zeroes & nextBarcode>
	

<!--- 
2. Grab the old data --->
	<cfquery name="qGuestVisit" datasource="#datasource#">
		select * FROM guestvisits			
		WHERE v_id = #attributes.v_id#
	</cfquery>
	
	<cfquery name="qSchedule" datasource="#datasource#">
		select * FROM schedule			
		WHERE v_id = #attributes.v_id#
	</cfquery>
	
<cfif NOT qSchedule.recordcount>	
	<strong>NO SCHEDULED DATES FOR THIS ANNOUNCEMENT.</strong>
	<cfabort >	
</cfif>

<cfset attributes.g_id = qSchedule.g_id>
<!--- 	
3. INSERT NEW DATA	 --->
	<cfquery name="insertNewBarcode" datasource="#datasource#">
		INSERT INTO barcodes
			(g_id,barcode,r_id,c_id)
			VALUES
			(#qGuestVisit.g_id#,'#newBarCode#',#qSchedule.r_id#,#session.user_community#)
	</cfquery>
	<cfquery name="insGuestVisits" datasource="#datasource#">
		INSERT INTO guestvisits (g_barcode,g_id,g_initialvisit,dashpass,
		ENTRY_NOTIFICATION,G_LPLATE,G_LPLATE_ST,G_PHOTO,MAP_EMAIL,STAFF_ID)
		VALUES ('#newBarCode#',
			#qGuestVisit.g_id#,
		#createODBCDateTime(request.timezoneadjustednow)#,'gate',#val(qGuestVisit.ENTRY_NOTIFICATION)#,'#qGuestVisit.G_LPLATE#',
		'#qGuestVisit.G_LPLATE_ST#','#qGuestVisit.G_PHOTO#','#qGuestVisit.MAP_EMAIL#',#session.STAFF_ID#)
	</cfquery>
	<cfquery datasource="#datasource#" name="qNewGuestVisit">
		select * from guestvisits 
		order by v_id desc limit 1
	</cfquery>	
	<cfquery name="updateGuestVisits" datasource="#datasource#">
		INSERT INTO	schedule (c_id,v_id,g_id,visit_date,g_singleentry,h_id,DASHPASS,ENTRY_NOTIFICATION,g_barcode,MAP_EMAIL,r_id)
		values (#session.user_community#,#qNewGuestVisit.v_id#,#qSchedule.r_id#,#createODBCDateTime(request.timezoneadjustednow)#,'true',#qSchedule.h_id#,
			'gate',#val(qSchedule.ENTRY_NOTIFICATION)#,'#newBarCode#','#qSchedule.MAP_EMAIL#',#qSchedule.r_id#
		)
	</cfquery>
	
	<cfset attributes.v_id = qNewGuestVisit.v_id>
	<cfset url.v_id = attributes.v_id>
	<!--- <cfoutput>#newBarCode#</cfoutput> --->

<!--- 3. Insert the visit record --->
<!--- removed per Todd:  https://app.asana.com/0/41870581947010/43442400551776  
<cfmodule template="record_entryByBarcode.cfm" dashpass="#newBarCode#" >
--->