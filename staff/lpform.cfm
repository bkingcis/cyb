<cfquery name="getCommunity" datasource="#datasource#">
	select * from communities 
	where c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#" />
</cfquery>
<cfquery name="qstateList" datasource="#datasource#">
	select state,abbreviation from states 
	order by state
</cfquery>
<cfparam name="url.checkin" default="1">
<cfif NOT isDefined("form.licensePlateNumber")>
	<cfoutput>
	<form id="plateNumFrm" name="plateNumFrm" action="lpform.cfm?v_id=#url.v_id#&g_id=#url.g_id#&checkin=#url.checkin#" method="post">
	<div style="text-align:center;background-color:##0071BE;margin:0px;padding:85px;height:320px;">
		<strong style="font-size:2em;color:white;">State:</strong>&nbsp; <select style="font-size:1.6em;width:140px;" name="licensePlateStateCode"><cfloop query="qstateList"><option value="#qstateList.abbreviation#"<cfif qstateList.abbreviation is getcommunity.c_state> selected="selected"</cfif>>#qstateList.state#</option></cfloop></select><br /><br /><br />
		<strong style="font-size:3.0em;color:white;">License Plate Number:</strong><br><br>		
		 <input type="text" name="licensePlateNumber" style="font-size:3.0em;width:175px;" maxlength="11"><br><br><input type="submit" value="Go" style="font-size:1.5em;width:80px;">
	</div>
	</form>
	</cfoutput>
<cfelse>
	<cfquery name="qLastVisitRecord" datasource="#datasource#">
		select max(visit_id) as lastvisit_id from visits 
		where v_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#url.v_id#" />
	</cfquery>
	<cfquery name="qSingleEntryOption" datasource="#datasource#">
		select g_singleentry from schedule 
		where v_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#url.v_id#" />
	</cfquery>
	<cfquery name="UpdateLastVisitRecord" datasource="#datasource#">
		update  visits 
		set licenseplatestatecode = <cfqueryparam value="#form.licensePlateStateCode#" cfsqltype="CF_SQL_VARCHAR" />,
		licensePlateNumber = <cfqueryparam value="#form.licensePlateNumber#" cfsqltype="CF_SQL_VARCHAR">
		where visit_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#qLastVisitRecord.lastvisit_id#" />
	</cfquery>
	<cfif val(qSingleEntryOption.g_singleentry)>
		<cflocation url="index.cfm">
	<cfelse>
		<cflocation url="guestdetails.cfm?v_id=#url.v_id#&g_id=#url.g_id#&checkin=#url.checkin#">
	</cfif>
	
</cfif>
