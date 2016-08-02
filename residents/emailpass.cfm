<cfquery name="GetCommunity" datasource="#datasource#">
	select * from communities
	WHERE c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#" />
</cfquery>

<cfquery name="GetResident" datasource="#datasource#">
	select residents.r_fname,residents.r_lname,homesite.h_id,homesite.h_address, homesite.h_city, homesite.h_state, homesite.h_zipcode 
	from residents INNER JOIN homesite ON residents.h_id = homesite.h_id
	WHERE r_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_id#" />
</cfquery>
<cfsavecontent variable="messageContent">
	<cfinclude template="include/printableDashPass.cfm">
</cfsavecontent>

<cfmail to="#EMAILADDRESS#" from="DashPass@cybatrol.com" subject="Cybatrol DashPass" type="html" >
#messageContent#
</cfmail>
