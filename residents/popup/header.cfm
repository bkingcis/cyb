<cfsilent>
<cfif NOT isDefined('session.user_id')><cflocation url="/residents" addtoken="false"></cfif>
<cfset request.dsn = datasource>
<cfquery name="getCommunity" datasource="#datasource#">
	select * from communities 
	where c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#" />
</cfquery>
	<cfset maxPermGuests = GetCommunity.maxpermguests>
<cfquery name="getResident" datasource="#datasource#">
	select * from residents
	where r_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_id#" />
</cfquery>
<cfquery datasource="#datasource#" name="qEventTypes">
	Select * from CommunityeventTypes
	where c_id = #getCommunity.c_id#
	order by label
</cfquery>
<cfquery datasource="#request.dsn#" name="qresidentSignInMessage">
	select 	*
	from	communitymessages
	where 	fieldname = 'residentSignInMessage'
	and 	c_id = #session.user_community#
	order by messageDate desc
</cfquery>
</cfsilent>
