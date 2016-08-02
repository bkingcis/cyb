<cfparam name="message" default="">

<!--- FIRST WE'LL CLEAN OUT ANY RIF-RAFF (BAD CODES OR CANCELED CODES) --->
<cfquery datasource="#datasource#" name="qBarcode">
	select * from barcodes 
	where barcode = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#barcode#" />
	and c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#" />
</cfquery>

<cfif val(qBarcode.g_id)>
	<cfquery datasource="#datasource#" name="qGuest">
		select * from guests 
		where g_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#qBarcode.g_id#" />
	</cfquery>
	<!--- <cfoutput>
		<strong>Guest Data:</strong><br />
		Name: #qGuest.G_LNAME#, #qGuest.G_FNAME#<br />
		Email: #qGuest.G_EMAIL#
	</cfoutput> --->
	<cfquery datasource="#datasource#" name="qSchedule">
		select * from 
		guestvisits GV left join schedule S on GV.v_id = S.v_id
		where GV.g_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#qBarcode.g_id#" />
	</cfquery>
	<cfset allowdates = valuelist(qSchedule.visit_date)>
	<cfif qSchedule.recordcount>
	<cfloop query="qSchedule">
	<cfset ITTdate = qSchedule.visit_date>
		<cfif isDate(ITTdate) AND dateCompare(createDate(year(request.timezoneadjustednow),month(request.timezoneadjustednow),day(request.timezoneadjustednow)),createDate(year(ITTdate),month(ITTdate),day(ITTdate))) eq 0>
			<cfset message = message & "<p>Schedule FOUND!  Choose RePrint</p>">
			<cfset scheduleFound = True>
			<cfbreak />
		</cfif>
	</cfloop>
	<cfelse>
		<cfset scheduleFound = false>
		<cfset message = message & "<p>Guest Is not Scheduled For Current Access.</p>">
	</cfif>
	<cfparam name="scheduleFound" default="false">
<cfelse>
	<cfset message = message & "<p>Could Not Locate Guest Information</p>">
</cfif>

