<cfif NOT isDefined('SESSION.user_community')>
	<cflocation url="/staff" addtoken="No">
</cfif>

<cftry>
	<cfquery name="getCommunity" datasource="#datasource#">
		select * from communities 
		where c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#" />
	</cfquery>
	<cfset request.dsn = datasource>
	<cfif structKeyExists(url,'g_id')>
		<cfset form.g_id = url.g_id>
	<cfelse>
		<cfquery name="getLastVIsit" datasource="#datasource#">
			SELECT gv.g_id 
			FROM guests g 
				join guestvisits gv on gv.g_id = g.g_id
				join residents r on g.r_id = r.r_id
				join homesite h on r.h_id = h.h_id
				join barcodes on gv.g_barcode = barcodes.barcode
				join visits v on gv.v_id = v.v_id
			WHERE h.c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#" />
			ORDER BY gv.g_checkedin desc limit 1
		</cfquery>
		<cfset form.g_id = getLastVIsit.g_id>
	</cfif>

	<cfinclude template="header.cfm"><!--- <cfinclude template="../include/staffheaderinfo.cfm"> --->
	
	<cfquery name="getGuest" datasource="#datasource#">select g_lname,g_fname,r_id,g_id from guests
		where c_id =<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#">
		and g_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#form.g_id#">
	</cfquery>

	<cfmodule template="/staff/include/search_results_past.cfm" g_fname="#getGuest.g_fname#" g_lname="#getGuest.g_lname#">

<cfcatch><cfoutput>Error:  #cfcatch.message#</cfoutput></cfcatch>
</cftry>