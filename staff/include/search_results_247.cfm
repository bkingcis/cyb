<cfset attributes.r_id = form.r_id>
<cfset begintime = createDate(year(request.timezoneadjustednow),month(request.timezoneadjustednow),Day(request.timezoneadjustednow))>
	<cfset endtime = dateAdd('d',1,begintime)>
	
	<cfinclude template="247Access.cfm">
	
	<!--- 
	
	<cfif getCommunity.dashpass and NOT getCommunity.checkoutoption>
		<cfinclude template="247Access.cfm">
	<cfelseif getCommunity.dashpass and getCommunity.checkoutoption>
		<cfinclude template="247Access.cfm">
	<cfelseif getCommunity.checkoutoption>
		<cfinclude template="homePageNoDashPassWithCheckout.cfm">
	<cfelse>
		<cfinclude template="homePageNODashpassOption.cfm">
	</cfif>
	
	
	--->
	
		