<cfparam name="url.printonly" default="0" />
<body onload="this.print();">
<cfif NOT isDefined("session.staff_id") OR NOT VAL(session.staff_id)>
	<cflocation URL="../staff.cfm" addtoken="no">
</cfif>
<cfif NOT isDefined("session.staff_id") OR NOT VAL(session.staff_id)>
	<cflocation URL="../staff.cfm" addtoken="no">
</cfif>
<cfset attributes.vid = url.v_id>
<cfset attributes.v_id = url.v_id>
<cfinclude template="bizrules/reissue-process.cfm">

<!--- removed per Todd:  https://app.asana.com/0/41870581947010/43442400551776  
<cfif NOT url.printonly>
<cfmodule template="bizrules/record_entryByBarcode.cfm" dashpass="#newBarCode#" >
</cfif>
--->

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