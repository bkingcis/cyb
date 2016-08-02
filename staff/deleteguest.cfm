<cfif isDefined('url.v_id')><cfset form.v_id = url.v_id></cfif>
<!--- <cfquery name="updateAcct" datasource="#datasource#">
	UPDATE	guests
	SET		g_cancelled = #CreateODBCDateTime(request.timezoneadjustednow)#
	WHERE	g_id = #form.g_id#
</cfquery> --->
<cfquery name="deleteEvents" datasource="#datasource#">
	DELETE FROM guestvisits
	WHERE v_id = #form.v_id# <!--- and visit_date >= #CreateODBCDate(request.timezoneadjustednow)# --->
</cfquery>
<cfquery name="deleteEvents" datasource="#datasource#">
	DELETE FROM schedule
	WHERE v_id = #form.v_id# <!--- or visit_date >= #CreateODBCDate(request.timezoneadjustednow)# --->
</cfquery>

<cflocation url="index.cfm">

