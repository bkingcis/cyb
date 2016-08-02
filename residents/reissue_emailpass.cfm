<cfquery name="GetCommunity" datasource="#datasource#">
	select * from communities
	WHERE c_id = #session.user_community#
</cfquery>

<cfquery name="GetResident" datasource="#datasource#">
	select residents.r_fname,residents.r_lname,homesite.h_id,homesite.h_address, homesite.h_city, homesite.h_state, homesite.h_zipcode 
	from residents INNER JOIN homesite ON residents.h_id = homesite.h_id
	WHERE r_id = #session.user_id#
</cfquery>
<cfquery name="GetExpiry" datasource="#datasource#">
	select * from schedule
	WHERE g_id = #g_id#
	AND v_id = #v_id#
	Order By visit_date DESC
</cfquery>
<cfset visitid = v_id>
<cfsavecontent variable="mailVar">
<cfinclude template="include/printableDashPass.cfm">
</cfsavecontent>

<cftry>
	<cfset expiry = DateFormat(GetExpiry.visit_date,"MM/DD/YYYY")>
	<cfmail to="#getGuestemail.g_email#" from="DashPass@cybatrol.com" subject="Cybatrol DashPass" type="html">
		#mailVar#
	</cfmail>
	<cfcatch>
		<cfdump var="#cfcatch#">
		<cfdump var="#getGuestemail#"><cfabort>
	</cfcatch>
</cftry>
