<cfquery name="getCommunity" datasource="#datasource#">
	select * from communities 
	where c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#" />
</cfquery>
<cfif NOT isDefined('form.licensePlateNumber') AND val(getCommunity.recordlicenseplateonspecialevents)>
	<cfquery name="qstateList" datasource="#datasource#">
		select state,abbreviation from states 
		order by state
	</cfquery>
	<cfoutput><form id="plateNumFrm" name="plateNumFrm" action="act_eventcounter.cfm?specialevent_id=#url.specialevent_id#" method="post">
	<div style="text-align:center;background-color:##0071BE;margin:0px;padding:45px;">
		<strong style="font-size:2em;color:white;">State:</strong>&nbsp; <select style="font-size:1.6em;width:140px;" name="licensePlateStateCode"><cfloop query="qstateList"><option value="#qstateList.abbreviation#"<cfif qstateList.abbreviation is getcommunity.c_state> selected="selected"</cfif>>#qstateList.state#</option></cfloop></select><br /><br /><br />
		<strong style="font-size:3.0em;color:white;">License Plate Number:</strong><br><br>		
		 <input type="text" name="licensePlateNumber" style="font-size:3.0em;width:175px;" maxlength="11"><br /><br /><input type="submit" value="Go" style="font-size:1.5em;width:80px;">
	</div>
	</form> </cfoutput>
	<cfabort>
</cfif>

<cfif isDefined('form.licensePlateNumber')>
	<cfset lpnumber = form.licensePlateNumber>
	<cfset lpstate = form.licensePlateStateCode>
<cfelse>
	<cfset lpnumber = ''>
	<cfset lpstate = ''>
</cfif>

<cfquery datasource="#datasource#" name="enterSpecialEventGuest">
	insert into specialeventvisits (specialevent_id,staff_id,g_checkedin,
		entrypointid,licenseplatenumber,licenseplatestatecode)
	values (#url.specialevent_id#,#session.staff_id#,<cfqueryparam value="#request.timezoneadjustednow#" cfsqltype="CF_SQL_TIMESTAMP">,
			#session.entrypointid#,'#lpnumber#','#lpstate#')
</cfquery>

<cflocation addtoken="No" url="index.cfm">