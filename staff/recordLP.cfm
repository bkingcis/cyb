<cfquery name="updateLP" datasource="#datasource#">
		update visits set licenseplatenumber = <cfqueryparam value="#form.licensePlateNumber#" cfsqltype="CF_SQL_VARCHAR">
		, licenseplatestatecode = <cfqueryparam value="#form.licensePlateStateCode#" cfsqltype="CF_SQL_VARCHAR">
		where visit_id= <cfqueryparam value="#form.visit_id#" cfsqltype="CF_SQL_INTEGER">
	</cfquery>
<cfparam name="form.g_id" default="0" />
<cflocation url="guestdetails.cfm?v_id=#form.v_id#&g_id=#form.g_id#" />