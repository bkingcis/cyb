<cftry>
<cfquery name="updateAcct" datasource="#datasource#">
	UPDATE	specialevents
	SET		canceled = 1 <!--- #CreateODBCDateTime(request.timezoneadjustednow)# --->
	WHERE	specialevent_id = #form.specialevent_id#
</cfquery>
<cfinclude template="header.cfm">
	<div class="well">Special Event Canceled.</div>
	<script>
		$('#btnContinue').hide();	  
		$('#btnBack').hide();
		$('#btnClose').hide();
	</script>
<cfcatch><cfdump var="#cfcatch#"></cfcatch>
</cftry>

