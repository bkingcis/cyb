
<body onload="this.print();">
<cfif NOT isDefined("session.staff_id") OR NOT VAL(session.staff_id)>
	<cflocation URL="../staff.cfm" addtoken="no">
</cfif>
<cfset attributes.vid = url.v_id>
<cfset attributes.v_id = url.v_id><!--- locate original v_id --->
<!--- <cfset attributes.g_id = url.g_id> moved to lookup based on v_id --->
<cfinclude template="bizrules/reissue-singleentry-process.cfm">

<!---  <cfoutput>NEW PASS CREATED #newBarcode#</cfoutput> --->
<cfquery name="qPasstype" datasource="#datasource#">
	select minipass from communities 
	where c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#" />
</cfquery>
<cfif NOT qPasstype.minipass>
<cfinclude template="printable-pass.cfm">
<cfelse>
<cfinclude template="printable-minipass.cfm">
</cfif>
</body>