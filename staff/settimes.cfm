<cfif IsDefined("url.viewhour")>
	<cfif findNoCase(url.viewhour,'p')>
		<cfset starthour = replace(url.viewhour,'p','') + 12>
	<cfelse>
		<cfset starthour = url.viewhour>
	</cfif>
	<cfset BEGINTIME = createDateTime(year(request.timezoneadjustednow),month(request.timezoneadjustednow),day(request.timezoneadjustednow),starthour,0,0)>
	<cfset ENDTIME = dateAdd('n',59,begintime)>
<cfelse>
	<cfif hour(request.timezoneadjustednow) gt 21>
		<cfset BEGINTIME = createDate(year(request.timezoneadjustednow),month(request.timezoneadjustednow),day(request.timezoneadjustednow))>
		<cfset ENDTIME = dateAdd('h',27,BEGINTIME)>
	<cfelseif hour(request.timezoneadjustednow) lt 3>
		<cfset tempvar = createDate(year(request.timezoneadjustednow),month(request.timezoneadjustednow),day(request.timezoneadjustednow))>
		<cfset ENDTIME = dateAdd('d',1,tempvar)>
		<cfset BEGINTIME =  dateAdd('h',-27,ENDTIME)>
	<cfelse>
	
		<cfset BEGINTIME = createDate(year(request.timezoneadjustednow),month(request.timezoneadjustednow),day(request.timezoneadjustednow))>
		<cfset ENDTIME = dateAdd('d',1,BEGINTIME)>
		<cfset ENDTIME = dateAdd('n',-1,ENDTIME)>
	</cfif>
</cfif>
