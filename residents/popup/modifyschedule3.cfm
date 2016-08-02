<cfsilent>
<cfparam name="dashpass_reissue" default="">
<cfparam name="passed_inspection" default="NO">
<cfparam name="newEntryType" DEFAULT=FALSE>
<cfif IsDefined("form.change_entrytype")>
	<cfif form.change_entrytype IS "SingleEntry" AND ListLen(form.allSelected) IS 1>
		<cfset newEntryType = 'TRUE'>
	<cfelse>
		<cfset newEntryType = 'FALSE'>
	</cfif>
<cfelseif IsDefined("form.entrytype")>
	<cfif form.entrytype IS "SingleEntry" AND ListLen(form.allSelected) IS 1>
		<cfset newEntryType = 'TRUE'>
	<cfelse>
		<cfset newEntryType = 'FALSE'>
	</cfif>
</cfif>
<cfquery name="getGuestVisits" datasource="#datasource#">
	SELECT * from guestvisits
	where v_id = <cfqueryparam value="#form.v_id#" cfsqltype="CF_SQL_INTEGER" />
</cfquery>	
<cfset session.g_id = getGuestVisits.g_id>
<cfquery name="getGuest" datasource="#datasource#">
	SELECT * from guests
	where g_id = <cfqueryparam value="#getGuestVisits.g_id#" cfsqltype="CF_SQL_INTEGER" />
</cfquery>	
</cfsilent>
<cfinclude template="header.cfm">
<!--- <div id="popUpContainer">
<cfinclude template="../residentsinfo.cfm"> --->
<cfif form.allSelected IS NOT "" AND (ListLen(form.allSelected) IS NOT 1 OR IsDefined("form.change_entrytype") OR passed_inspection IS "YES")>		<!--- Create New Quesry from DateList to Query and Order--->	    
	   <CFSET DatesListed = QueryNew("DATELIST")>
		<cfloop list="#allSelected#" index="i">
			<cfset thisdate = i>			    
		    <cfset temp = QueryAddRow(DatesListed, 1)>			    
		    <cfset temp = QuerySetCell(DatesListed, "DATELIST", thisdate)>
		</cfloop>
		<cfquery name="OrderDates" DBTYPE="query">
			select * from DatesListed
				ORDER BY DATELIST
		</cfquery>
		
		<cfinclude template="../bizrules/handleConnectingVisitsModify.cfm">
		<!--- IN PROGRESS <cfinclude template="bizrules/handleDatesRemoval.cfm"> --->
		
			<cfif breaksRule>
				<div class="alert">
				<cfoutput>#session.message#</cfoutput>
				<cfset session.message = ''>
				<form method="post" action="popup/announce2.cfm"><!--- <br />		
				<input type="button" onClick="history.back();" value=" Go Back "  style="color: red;">
				<input type="button" onClick="self.location='announce1.cfm';" value=" New Announcement "  style="color: green;">
				 ---></form>
				</div>
				<script>
					$('#btnBack').show().text('Go Back');
					$('#btnContinue').show().text('Create A New Announcement');
				</script>
				
				<cfset session.message = "">
				<cfabort>
			</cfif>
		
		<!--- End of Ordering Dates--->
		<cfif ListLen(OrderDates.DATELIST) IS 0>
			<cflocation url="deletecheck2.cfm?g_id=#form.g_id#">
		</cfif>
		
		<cfset dayinquestion = DATELIST>	
		<cfoutput query="OrderDates" startrow="#OrderDates.RecordCount#" maxrows="1">
		<cfset lastdayinquestion = DATELIST>
		<!--- #lastdayinquestion# --->
		</cfoutput>
		
		<cfparam name="form.hour" default="12:00">
		<cfset InitialVisit = CreateDateTime(DateFormat(OrderDates.DATELIST,"YYYY"),  DateFormat(OrderDates.DATELIST,"MM"),  DateFormat(OrderDates.DATELIST,"DD"),  listFirst(form.hour,":"), listRest(form.hour,":"), 00)>
		
	<cfif IsDefined("dashpass_reissue") AND dashpass_reissue IS NOT "">
		<cfquery name="getNextBarcode" datasource="#datasource#">
			select * from barcodes
			Where c_id = #session.user_community#
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
		<cfset zeroes1 = "#zeroes1#" & "0">
		</cfloop>
		<cfset gid = "#zeroes1#" & "#session.user_community#" & "#zeroes#" & "#nextBarcode#">
		<!--- Barcode: <cfoutput>#gid#</cfoutput> --->
		<cfquery name="getNewBarcode" datasource="#datasource#">
			UPDATE barcodes
				SET date_cancelled = #CreateODBCDateTime(request.timezoneadjustednow)#
				where barcode = '#form.g_barcode#'
		</cfquery>		
		<cfquery name="updateBarcodes" datasource="#datasource#">
			INSERT INTO barcodes
				(g_id,barcode,r_id,c_id)
				VALUES
				(#form.g_id#,'#gid#',#session.user_id#,#session.user_community#)
		</cfquery>
		<cfquery name="updateGuestVisits" datasource="#datasource#">
			UPDATE guestvisits
				SET g_barcode = '#gid#', dashpass = '#dashpass_reissue#'
			WHERE v_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#v_id#" />
		</cfquery>
		<cfquery name="updateGuestVisits" datasource="#datasource#">
			UPDATE guests
				SET g_barcode = '#gid#'
			WHERE g_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#g_id#" />
		</cfquery>
		<cfif dashpass_reissue IS "email">		
			<cfquery name="updateGuestemail" datasource="#datasource#">
				update guests
				set g_email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#g_email#" />
				where g_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#g_id#" />
			</cfquery>
			<cfquery name="getGuestemail" datasource="#datasource#">
				select * from guests
				where g_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#g_id#" />
			</cfquery>
			<cfinclude template="../reissue_emailpass.cfm">					
		</cfif>
	<cfelse>
		<cfquery name="getGuestBC" datasource="#datasource#">
			select g_barcode from guestvisits
			where v_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#v_id#" />
		</cfquery>	
		<cfoutput>
			<cfset gid = getGuestBC.g_barcode>
		</cfoutput>
	</cfif>

	<cfif isdefined('form.g_fname')>		
		<cfquery name="updateAcct" datasource="#datasource#">
		UPDATE	guests
		SET		r_id = #session.user_id#,
				c_id = #session.user_community#,
				g_fname = '#form.g_fname#',
				g_lname = '#form.g_lname#',
				g_email = '#form.g_email#'
		WHERE	g_id = #form.g_id#
		</cfquery>
	</cfif>
	
	<cfquery name="getGuest" datasource="#datasource#">
		select guests.g_id,guests.r_id,guests.c_id,residents.h_id,residents.r_id
		from guests, residents
		where residents.r_id = guests.r_id AND guests.g_id = #form.g_id#
	</cfquery>	
	<cfif getGuest.recordcount>
	<cfquery name="GetVisit" datasource="#datasource#">
		select * 
		from schedule
		WHERE g_id = #getGuest.g_id#
		AND v_id = #form.v_id#
	</cfquery>	
	<cfelse>
		<script>alert('There was an unexpected Error.  Guest Not Found.  Please use your browser back button and try again.');</script>
		<cfabort>
	</cfif>

	<cfquery name="updateInitialVisit" datasource="#datasource#">
		UPDATE guestvisits
		SET g_initialvisit = #CreateODBCDateTime(InitialVisit)#,guestcompanioncount=#form.guestcompanioncount#
		WHERE g_id = #getGuest.g_id#
		AND v_id = #form.v_id#
	</cfquery>	
	
	<cfquery name="deleteEvents" datasource="#datasource#">
		DELETE FROM schedule
		WHERE g_id = #form.g_id# 
		AND v_id = #form.v_id#
		and visit_date >= #CreateODBCDate(request.timezoneadjustednow)# 
	</cfquery>
	<cfloop list="#allSelected#" index="i">
		<cfset thisdate = i>
		<cfquery name="insertSchedule" datasource="#datasource#">
			insert into schedule
			(c_id,h_id,r_id,g_id,g_barcode,visit_date,g_singleentry,v_id)				
			values(#getGuest.c_id#, #getGuest.h_id#, #getGuest.r_id#, #form.g_id#,'#gid#', #CreateODBCDate(thisdate)#,#newEntryType#,#form.v_id#)
		</cfquery>
	</cfloop>
	<div class="alert alert-success"> Update complete.</div>
	<script>
		$('#btnContinue').hide();	  
		$('#btnBack').hide();
		$('#btnClose').hide();
	</script>
<cfelseif ListLen(form.allSelected) IS 1>
	<strong style="font-weight:bold;font-size:15px;color:#336699;padding-bottom:10px;">Please verify the following:</strong><br>
	<form name="passinspect" action="/residents/popup/modifyschedule3.cfm" method=POST>
	<input type="radio" name="entrytype" value="SingleEntry">&nbsp;SINGLE ENTRY (This guest is authorized for a single entry into the community)<br>
	<input type="radio" name="entrytype" value="FullDay" checked>&nbsp;FULL DAY (This guest is authorized full day access into the community)<br>
	<input type="hidden" name="passed_inspection" value="YES">
	
		<cfloop INDEX="i" list="#form.FieldNames#">
			<cfoutput>
			<input type="hidden" name="#i#" value="#Evaluate(i)#">
			</cfoutput>
		</cfloop>
		<!--- <cfoutput><input type="hidden" name="allSelected" value="#form.allSelected#"></cfoutput>
		<br><input type="submit" value=" : schedule guest : " style="color:Green;"> --->
	</form></div>
<cfelse>
	<strong>You must choose at least one date to successfully schedule a guest.</strong><br>
	<cfoutput>
	<form action="modifyschedule2.cfm?g_id=#form.g_id#" method=POST>
	<input type="hidden" name="FName" value="#form.g_fname#">
	<input type="hidden" name="LName" value="#form.g_lname#">
	<!--- <input type="hidden" name="Phone" value="#form.g_phone#"> --->
	<input type="hidden" name="Email" value="#form.g_email#">
	
	<!--- <input type="submit" value=" : go back : " style="background-color:##336699;color:##f5f5f5;padding-top:5px;padding-bottom:5px;padding-left:10px;padding-right:10px;border-top:1px solid Grey;border-bottom:1px solid grey;border-left:1px solid grey;border-right:1px solid grey;font-variant:small-caps;font-weight:bold;font-size:11px;margin-top:10px;"> --->
	</form>
	</cfoutput>
	<script>
		$('#btnContinue').hide();	  
		$('#btnBack').show();
		$('#btnClose').hide();
	</script>	
</cfif>