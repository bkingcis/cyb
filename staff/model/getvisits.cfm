<cfif structKeyExists(attributes,'thedate') and NOT structKeyExists(attributes,'daysback') >
<cfset attributes.daysback = 1  />
</cfif>
<cfparam name="attributes.sortString" default="v.g_checkedin desc" />
<cfparam name="attributes.thedate" default="#createDate(year(request.timezoneadjustednow),month(request.timezoneadjustednow),day(request.timezoneadjustednow))#" />
<cfparam name="attributes.daysback" default="180">

<cfquery datasource="#request.dsn#" name="qvisits">
	select DISTINCT g.g_id,g.r_id,g.g_lname,g.g_fname,v.g_checkedin, 
		gv.v_id,gv.dashpass,gv.g_permanent,gv.insertedby_staff_id,
		gv.g_cancelled,gv.g_initialvisit,r.r_id,r.h_id,h.c_id,s.staff_fname || ' ' || s.staff_lname as recorded_by,
		r.r_fname,r.r_lname,h.h_id,h.h_address,h.h_phone, ep.label as entryPoint
		from guests g 
			join guestvisits gv on gv.g_id = g.g_id
			join residents r on g.r_id = r.r_id
			join homesite h on r.h_id = h.h_id
			join barcodes on gv.g_barcode = barcodes.barcode
			join visits v on gv.v_id = v.v_id
			join staff s on s.staff_id = v.staff_id
			left join communityentrypoints ep on ep.entrypointid = v.entrypointid
		WHERE h.c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#" />
		AND	  v.g_checkedin > '#dateFormat(dateAdd('d',attributes.daysback * -1,attributes.thedate))# 00:00:00'
		order by #attributes.sortString#
</cfquery>

<cfif isdefined("attributes.r_id") and val(attributes.r_id)>
	<cfquery dbtype="query" name="qvisits">
		select * from qvisits
		where  r_id = <cfqueryparam value="#ucase(attributes.r_id)#" cfsqltype="CF_SQL_INTEGER">
	</cfquery>
</cfif>
<cfif isdefined("attributes.g_lname") and len(attributes.g_lname)>
	<cfquery dbtype="query" name="qvisits">
		select * from qvisits
		where  upper(g_lname) = <cfqueryparam value="#ucase(attributes.g_lname)#" cfsqltype="CF_SQL_VARCHAR">
	</cfquery>
</cfif>
<cfif isdefined("attributes.g_fname") and len(attributes.g_fname)>
	<cfquery dbtype="query" name="qvisits">
		select * from qvisits
		where  upper(g_fname) = <cfqueryparam value="#ucase(attributes.g_fname)#" cfsqltype="CF_SQL_VARCHAR">
	</cfquery>
</cfif>
<cfif isdefined("attributes.r_lname") and len(attributes.r_lname)>
	<cfquery dbtype="query" name="qvisits">
		select * from qvisits
		where  upper(r_lname) = <cfqueryparam value="#ucase(attributes.r_lname)#" cfsqltype="CF_SQL_VARCHAR">
	</cfquery>
</cfif>
<cfif isdefined("attributes.r_fname") and len(attributes.r_fname)>
	<cfquery dbtype="query" name="qvisits">
		select * from qvisits
		where  upper(r_fname) = <cfqueryparam value="#ucase(attributes.r_fname)#" cfsqltype="CF_SQL_VARCHAR">
	</cfquery>
</cfif>
<cfif isdefined("attributes.r_id") and val(attributes.r_id)>
	<cfquery dbtype="query" name="qvisits">
		select * from qvisits
		where  r_id = <cfqueryparam value="#attributes.r_id#" cfsqltype="CF_SQL_INTEGER">

	</cfquery>
</cfif>
<cfif isdefined("attributes.g_id") and val(attributes.g_id)>
	<cfquery dbtype="query" name="qvisits">
		select * from qvisits
		where  g_id = <cfqueryparam value="#attributes.g_id#" cfsqltype="CF_SQL_INTEGER">
	</cfquery>
</cfif>

<cfset caller.qvisits = qvisits>