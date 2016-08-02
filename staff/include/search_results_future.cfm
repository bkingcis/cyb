<!--- <h1>Present</h1>

Current Day Searched:

Actual Visits (alpha by guest last - Scroll 10) - (sort by visit time)
Authorized Access (alpha by guest last - Scroll 10)
24/7 Guests (alpha by guest last name - Scroll 10)
Special Events (alpha by resident last name - Scroll 10)
	 --->	
	<cfquery datasource="#request.dsn#" name="getCommunity">
		Select * from Communities
		where c_id = #session.user_community#
	</cfquery>
	<cfparam name="thesearchdate" default="#request.timezoneadjustednow#" />
	<cfset begintime = createDate(year(thesearchdate),month(thesearchdate),Day(thesearchdate))>
	<cfset endtime = dateAdd('d',1,begintime)>
	
	<cfif isdefined("form.g_lname")><cfset attributes.g_lname = form.g_lname><cfelse><cfset attributes.g_lname = ""></cfif>
	<cfif isdefined("form.g_fname")><cfset attributes.g_fname = form.g_fname><cfelse><cfset attributes.g_fname = ""></cfif>
	<cfif isdefined("form.r_lname")><cfset attributes.r_lname = form.r_lname><cfelse><cfset attributes.r_lname = ""></cfif>
	<cfif isdefined("form.r_fname")><cfset attributes.r_fname = form.r_fname><cfelse><cfset attributes.r_fname = ""></cfif>
	<cfif isdefined("form.r_id")><cfset attributes.r_id = form.r_id><cfelse><cfset attributes.g_id = ""></cfif>
	
	<cfif getCommunity.dashpass and NOT getCommunity.checkoutoption>
		<cfinclude template="homePageDashpassOption.cfm">
	<cfelseif getCommunity.dashpass and getCommunity.checkoutoption>
		<cfinclude template="homePageDashPassWithCheckout.cfm">
	<cfelseif getCommunity.checkoutoption>
		<cfinclude template="homePageNoDashPassWithCheckout.cfm">
	<cfelse>
		<cfinclude template="homePageNODashpassOption.cfm">
	</cfif>
	<!--- special events --->
	<cfif NOT isDefined('url.viewhour')>
		<cfif NOT LEN(attributes.g_lname) AND NOT LEN(attributes.g_fname)>
	    <cfinclude template="homePageSpecialEvents.cfm">
		</cfif>
	</cfif>