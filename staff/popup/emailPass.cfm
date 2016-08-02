<cftry>
	<cfquery name="GetCommunity" datasource="#request.dsn#">
		select * from communities
		WHERE c_id = <cfqueryparam value="#session.user_community#" cfsqltype="CF_SQL_INTEGER">
	</cfquery>
	<cfif structKeyExists(form, "email")>
	<cfquery datasource="#request.dsn#">
	update guests set g_email = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.email#" />
	</cfquery>
	</cfif>
	
	<cfquery name="GetGuestEmail" datasource="#request.dsn#">
		select * from guests
		WHERE g_id = <cfqueryparam value="#g_id#" cfsqltype="CF_SQL_INTEGER">
	</cfquery>
<cfinclude template="header.cfm">
<div id="popUpContainer">
		
	<cfif NOT Find('@',getGuestEmail.g_email)>
		<h1>NO EMAIL PRESENT</h1>
		<p style="color:white">Enter a destination email address to send the DashPass.</p>
		<form action="#" method="post">
			<table style="margin-left:130px;">
				<tr><td width="350"><input name="email" value="" placeholder="email@example.net" class="form-control"></td>
				<td><input type="submit" value="continue" class="btn"></td>
				</tr>
			</table>
			<input type="hidden" name="g_id" value="#g_id#" >
			<input type="hidden" name="v_id" value="#v_id#" >
		</form>
		<cfabort>
	</cfif>
	
<cfset attributes.vid = url.v_id>
<cfset attributes.v_id = url.v_id>
<cfinclude template="../bizrules/reissue-process.cfm">

	<cfsavecontent variable="email_content">
		<cfif NOT val(getCommunity.minipass)>
		<cfinclude template="../printable-pass.cfm">
		<cfelse>
		<cfinclude template="../printable-minipass.cfm">
		</cfif>
	</cfsavecontent>
	
	<cfoutput>
	<CFMAIL TO="#GetGuestEmail.g_email#" FROM="dashpass@cybatrol.com" SUBJECT="Cybatrol DashPass" TYPE="html"	spoolenable="no">
		#email_content#
	</cfmail>
	</cfoutput>
	<h1>Success!</h1>
	<div>A new dashpass was sent to the visitor's email address.</div>
	<cfcatch>
		<cfinclude template="header.cfm">
		<div id="popUpContainer">
		There was an error processing your request:  <cfoutput>#cfcatch.message#
		<cfif isDefined('cfcatch.cause.message')><br /><br />Cause:  #cfcatch.cause.message#</cfif>
	   #repeatString('<br />', 34)#
	</cfoutput>
	<cfdump var="#cfcatch#"></cfcatch>
</cftry>
</div>