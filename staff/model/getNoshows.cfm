<cfparam name="attributes.sortString" default="g_lname,g_fname,r_lname,r_fname" />
<cfparam name="attributes.thedate" default="#createDate(year(request.timezoneadjustednow),month(request.timezoneadjustednow),day(request.timezoneadjustednow))#" />
		
<cfquery datasource="#request.dsn#" name="qNoshows">
	select g.g_id,g.r_id,g.g_lname,g.g_fname,gv.g_initialvisit, 
		gv.v_id,gv.dashpass,gv.g_permanent,
		gv.g_cancelled,gv.g_initialvisit,r.r_id,r.h_id,h.c_id,
		r.r_fname,r.r_lname,h.h_id,h.h_address,h.h_phone 
		from guests g 
		join guestvisits gv on gv.g_id = g.g_id
		join residents r on g.r_id = r.r_id
		join homesite h on r.h_id = h.h_id
		join barcodes on gv.g_barcode = barcodes.barcode
		left join visits v on gv.v_id = v.v_id 
		WHERE v.v_id is null
		AND h.c_id = #session.user_community#
		AND gv.g_initialvisit BETWEEN '#dateFormat(attributes.theDate)# 00:00:00' AND '#dateFormat(dateAdd('d',1,attributes.thedate))# 00:00:00'
		order by #attributes.sortString#
</cfquery>

<cfif isdefined("caller.attributes.g_lname") and len(caller.attributes.g_lname)>
	<cfquery dbtype="query" name="qNoshows">
		select * from qNoshows
		where  upper(g_lname) = <cfqueryparam value="#ucase(attributes.g_lname)#" cfsqltype="CF_SQL_VARCHAR">
	</cfquery>
</cfif>
<cfif isdefined("attributes.g_fname") and len(attributes.g_fname)>
	<cfquery dbtype="query" name="qNoshows">
		select * from qNoshows
		where  upper(g_fname) = <cfqueryparam value="#ucase(attributes.g_fname)#" cfsqltype="CF_SQL_VARCHAR">
	</cfquery>
</cfif>
<cfif isdefined("attributes.r_lname") and len(attributes.r_lname)>
	<cfquery dbtype="query" name="qNoshows">
		select * from qNoshows
		where  upper(r_lname) = <cfqueryparam value="#ucase(attributes.r_lname)#" cfsqltype="CF_SQL_VARCHAR">
	</cfquery>
</cfif>
<cfif isdefined("attributes.r_fname") and len(attributes.r_fname)>
	<cfquery dbtype="query" name="qNoshows">
		select * from qNoshows
		where  upper(r_fname) = <cfqueryparam value="#ucase(attributes.r_fname)#" cfsqltype="CF_SQL_VARCHAR">
	</cfquery>
</cfif>

<cfset caller.qNoshows = qNoshows>