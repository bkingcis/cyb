
	<!--- <cfimport taglib="../model" prefix="m">	
	<m:getSchedule begintime="#begintime#" endtime="#begintime#" >	 --->
<cfinclude template="currentAccess.cfm">
		<cfif NOT isDefined('url.viewhour')>
		<cfif val(getCommunity.permanantguests)>
		<cfinclude template="247Access.cfm">
		</cfif><!--- end community 24/7 IF block --->
		</cfif>
	
	
		<!--- end url.viewhour IF block --->