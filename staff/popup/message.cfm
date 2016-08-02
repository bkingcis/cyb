<cfinclude template="header.cfm">
<cfparam name="residentLabel" default="Residents">
<cfparam name="staffLabel" default="Personnel">
<cfsilent>
<cfquery datasource="#datasource#" name="qMessage">
	select 	*
	from	communitymessages
	<cfif isDefined('url.type') and url.type is 'resident'>
	where 	fieldname = 'residentSignInMessage'
	<cfelse>
	where 	fieldname = 'staffSignInMessage'
	</cfif>
	and 	c_id = #val(GetCommunity.c_id)#
	order by messageDate desc,message_id desc
	limit 1
</cfquery>
</cfsilent>
<div id="popUpContainer">
	<cfoutput>
	<h1>message To <cfif isDefined('url.type') and url.type is 'resident'>
	#residentLabel#<cfelse>#staffLabel#</cfif>:</h1><br />
	<cfif qMessage.recordcount>
	<span style="color:white;font-size:14pt">#ucase(qMessage.messageText)#</span>
	<div style="text-align:right;color:##eee;font-size:0.8em;padding-top:4px;">
	Posted: #dateFormat(qMessage.messageDate,'long')#  #timeFormat(qMessage.messageDate,'h:mm tt')#</div>
	<cfelse>
		
	</cfif>
	</cfoutput>
</div>

