<!--- <cfquery datasource="#request.dsn#" name="getResident">
	select * from residents r join homesite h on h.h_id = r.h_id
	where h.c_id =<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#">
	and r.r_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(form.r_id)#">
</cfquery>
<cfquery datasource="#request.dsn#" name="getParcels">
	select p.*,s.staff_fname,s.staff_lname from parcels p   JOIN staff s on p.staff_id = s.staff_id
	where  r_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(form.r_id)#">
	order by receiveddate desc
</cfquery> --->

<cfif val(parcelPickup)>
	<cfquery datasource="#request.dsn#">
		update 	parcels
		set  	delivereddate = '#dateFormat(now())# #timeFormat(now())#',
				deliveredbystaff_id	 = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.staff_id#">
		where parcel_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(url.parcelPickup)#">
	</cfquery>
</cfif>