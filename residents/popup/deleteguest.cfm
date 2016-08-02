<cftry>
<cfif structKeyExists(url,'v_id')>
	<cfset form.v_id = url.v_id>
</cfif>
<cfif structKeyExists(form,'v_id')>
	<!--- 
	<cfquery name="getRes" datasource="#datasource#">
		select r_id from guestvisits
		WHERE v_id = #form.v_id#
	</cfquery>--->
	<cfquery name="deleteEvents" datasource="#datasource#">
		DELETE FROM guestvisits
		WHERE v_id = #form.v_id# <!--- and visit_date >= #CreateODBCDate(request.timezoneadjustednow)# --->
	</cfquery>
	<cfquery name="deleteEvents" datasource="#datasource#">
		DELETE FROM schedule
		WHERE v_id = #form.v_id# <!--- or visit_date >= #CreateODBCDate(request.timezoneadjustednow)# --->
	</cfquery>
<cfelseif structKeyExists(form,"g_id")>
	<cfquery name="updateAcct" datasource="#datasource#">
		UPDATE	guests
		SET		g_cancelled = #CreateODBCDateTime(request.timezoneadjustednow)#
		WHERE	g_id = #form.g_id#
	</cfquery> 
</cfif>
	<cfinclude template="header.cfm">
	<div class="well">Guest Removed.</div>
	<script>
		$('#btnContinue').hide();	  
		$('#btnBack').hide();
		$('#btnClose').hide();
	</script>
<cfcatch><cfdump var="#cfcatch#"></cfcatch>
</cftry>

